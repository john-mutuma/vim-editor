----------------------------------------------------------------------
-- 1. Sidekick CLI Cleanup
----------------------------------------------------------------------
--- Sidekick.nvim's tmux backend deliberately keeps the tmux session (and
--- the running CLI process — e.g. Copilot CLI, Claude, etc.) alive across
--- nvim exits. In the `:terminal` (non-mux) backend, Copilot may also
--- survive if it ignores SIGHUP or is spawned in its own process group.
--- Either way, for Copilot CLI it causes concrete pain:
---
--- - Each Copilot CLI process holds an `inuse.<pid>.lock` on its
---   `~/.copilot/session-state/<uuid>/` directory.
--- - When nvim exits, the lock stays.
--- - Next nvim → new sidekick session UUID → old session is hidden from
---   the "Sessions" tab; `/resume` finds it but reports "in use by
---   another".
--- - Orphaned processes accumulate over time.
---
--- This utility follows the pattern already used for OpenCode
--- (`nvim/lua/nairovim/plugins/ai/opencode.lua`): on `VimLeavePre`,
--- explicitly tear down sidekick's CLI processes so they release their
--- locks and don't linger. Handles both backends:
---
---   * tmux (mux enabled) → `tmux kill-session` on sidekick-owned sessions
---   * :terminal (mux disabled, e.g. Windows Terminal in this project) →
---     kill each session's process group (TERM then KILL after 500 ms)
---     using the pids sidekick already tracks in
---     `sidekick.cli.terminal.terminals[id].pids`.
---
--- A defensive startup sweep also cleans up sessions/processes orphaned
--- by prior nvim crashes.

local M = {}

--- Two-phase kill delay (ms). SIGTERM first, then SIGKILL after this
--- delay for any stragglers.
local KILL_DELAY_MS = 500

--- List tmux sessions whose name matches sidekick's `sidekick-*` /
--- `copilot-*` / `<tool>-*` naming pattern created via `tmux new -A -s
--- <session_name>`.
--- @return string[] session_names
local function list_sidekick_tmux_sessions()
    if vim.fn.executable("tmux") ~= 1 then
        return {}
    end
    local out = vim.fn.systemlist({ "tmux", "list-sessions", "-F", "#{session_name}" })
    if vim.v.shell_error ~= 0 then
        return {}
    end
    local result = {}
    for _, name in ipairs(out) do
        -- Match sidekick-created session names. Sidekick creates sessions
        -- named after the sidekick.cli.session id (e.g. "copilot-8bbf0a7a3",
        -- "claude-<hex>"). We match anything that has a hex suffix.
        if name:match("^%w[%w_%-]-%-%x+$") then
            table.insert(result, name)
        end
    end
    return result
end

--- Return true if the given tmux session was launched by *this* nvim
--- instance. Checked by walking the tmux server -> pane pid chain and
--- comparing the immediate child ancestor to nvim's PID.
--- We approximate: if the tmux client attached to this session has a
--- parent pid = our nvim pid, it's ours.
--- @param session_name string
--- @return boolean
local function is_our_session(session_name)
    if vim.fn.has("linux") ~= 1 then
        -- On non-Linux, we can't reliably introspect. Err on the safe
        -- side and treat as ours only when the session name contains
        -- our pid (sidekick doesn't do that today), otherwise skip.
        return false
    end

    -- Get the session's server pid via `tmux display-message`.
    local out = vim.fn.systemlist({
        "tmux",
        "display-message",
        "-p",
        "-t",
        session_name,
        "#{pid}",
    })
    if vim.v.shell_error ~= 0 or #out == 0 then
        return false
    end

    -- The tmux client for this session was spawned by sidekick as a child
    -- of nvim. Walk sidekick's tmux-command pids to find any whose ppid
    -- equals our nvim pid.
    local our_pid = tostring(vim.fn.getpid())
    local tmux_cmd_pids = vim.fn.systemlist({
        "pgrep",
        "-P",
        our_pid,
        "-f",
        "tmux new -A -s " .. session_name,
    })
    if vim.v.shell_error == 0 and #tmux_cmd_pids > 0 then
        return true
    end
    return false
end

--- Kill a single tmux session two-phase (SIGTERM to processes, then
--- kill-session for cleanup).
--- @param session_name string
local function kill_session(session_name)
    -- Best effort: `tmux kill-session` triggers detach-on-destroy and stops
    -- the pane's foreground process (SIGHUP-style).
    vim.fn.system({ "tmux", "kill-session", "-t", session_name })
end

--- Kill a process group two-phase: SIGTERM, then SIGKILL after a delay
--- for stragglers. Uses negative PID form so the whole process group
--- (Copilot + its child LSPs / MCP servers) goes down.
--- @param pid integer|string
local function kill_process_group(pid)
    local pid_str = tostring(pid)
    if pid_str == "" or pid_str == "0" then
        return
    end
    vim.fn.system(string.format("kill -15 -%s 2>/dev/null", pid_str))
    vim.defer_fn(function()
        vim.fn.system(string.format("kill -9 -%s 2>/dev/null", pid_str))
    end, KILL_DELAY_MS)
end

--- Kill Copilot CLI processes launched by *this* nvim inside sidekick's
--- :terminal (non-mux) backend. Iterates sidekick.cli.terminal.terminals
--- for sessions without a mux_session and terminates their process
--- groups.
local function kill_terminal_sessions()
    local ok, terminal = pcall(require, "sidekick.cli.terminal")
    if not ok then
        return
    end
    for _, session in pairs(terminal.terminals or {}) do
        if not session.mux_session then
            for _, pid in ipairs(session.pids or {}) do
                kill_process_group(pid)
            end
        end
    end
end

--- Kill CLI processes launched inside sidekick's tmux sessions **owned by
--- this nvim instance**, then release their session locks. Also kills
--- :terminal-backend sessions (used when sidekick's mux is disabled, e.g.
--- on Windows Terminal in this project's config).
function M.cleanup_on_exit()
    -- :terminal backend: iterate sidekick's live sessions and kill their
    -- process groups so Copilot releases its ~/.copilot/session-state/<uuid>
    -- lock.
    kill_terminal_sessions()

    -- tmux backend: kill sidekick-owned tmux sessions. `kill-session`
    -- triggers detach-on-destroy and terminates the pane's foreground
    -- process (Copilot CLI), releasing its lock.
    if vim.fn.executable("tmux") ~= 1 then
        return
    end
    for _, name in ipairs(list_sidekick_tmux_sessions()) do
        if is_our_session(name) then
            kill_session(name)
        end
    end
end

--- Best-effort startup cleanup: kill sidekick-owned CLI leftovers whose
--- owning nvim is no longer running. Covers both:
---   * tmux sessions whose starter's parent nvim is gone
---   * bare `copilot --session-id ...` processes whose parent chain does
---     not reach a live nvim (i.e. orphaned `:terminal` children).
--- Runs once shortly after startup so it doesn't slow down nvim boot.
function M.cleanup_orphans_on_startup()
    if vim.fn.has("linux") ~= 1 then
        return
    end

    -- Part A: orphaned tmux sessions.
    if vim.fn.executable("tmux") == 1 then
        local sessions = list_sidekick_tmux_sessions()
        for _, name in ipairs(sessions) do
            local starters = vim.fn.systemlist({
                "pgrep",
                "-f",
                "tmux new -A -s " .. name,
            })
            if #starters == 0 then
                kill_session(name)
            else
                local pid = vim.trim(starters[1])
                if pid ~= "" then
                    local ppid = vim.trim(vim.fn.system("ps -o ppid= -p " .. pid .. " 2>/dev/null"))
                    if ppid == "" or vim.fn.system("kill -0 " .. ppid .. " 2>/dev/null; echo $?"):match("^1") then
                        kill_session(name)
                    end
                end
            end
        end
    end

    -- Part B: orphaned :terminal-backend Copilot CLI processes.
    -- Match `copilot --session-id ...` (the actual TUI binary), then check
    -- whether any ancestor is still a live nvim. If not, kill the process
    -- group.
    local copilot_pids = vim.fn.systemlist("pgrep -f 'copilot .*--session-id' 2>/dev/null")
    for _, pid in ipairs(copilot_pids) do
        pid = vim.trim(pid)
        if pid ~= "" and pid ~= tostring(vim.fn.getpid()) then
            -- Walk ancestor chain looking for a live nvim.
            local has_live_nvim = false
            local cur = pid
            for _ = 1, 10 do -- bound the walk
                local ppid = vim.trim(vim.fn.system("ps -o ppid= -p " .. cur .. " 2>/dev/null"))
                if ppid == "" or ppid == "0" or ppid == "1" then
                    break
                end
                local comm = vim.trim(vim.fn.system("ps -o comm= -p " .. ppid .. " 2>/dev/null"))
                if comm == "nvim" then
                    has_live_nvim = true
                    break
                end
                cur = ppid
            end
            if not has_live_nvim then
                kill_process_group(pid)
            end
        end
    end
end

--- Register autocmds. Idempotent (clears the augroup on each call).
function M.setup()
    local group = vim.api.nvim_create_augroup("nairovim_sidekick_cleanup", { clear = true })

    vim.api.nvim_create_autocmd("VimLeavePre", {
        group = group,
        desc = "Kill sidekick CLI tmux sessions owned by this nvim on exit",
        callback = M.cleanup_on_exit,
    })

    -- Defensive startup sweep: run 2 s after start to give the system time
    -- to settle. Handles sessions orphaned by prior nvim crashes.
    vim.defer_fn(M.cleanup_orphans_on_startup, 2000)
end

return M
