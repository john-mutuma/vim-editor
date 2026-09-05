----------------------------------------------------------------------
-- 1. Sidekick CLI Cleanup
----------------------------------------------------------------------
--- Sidekick.nvim's tmux backend deliberately keeps the tmux session (and
--- the running CLI process — e.g. Copilot CLI, Claude, etc.) alive across
--- nvim exits. That's fine as a design choice, but for Copilot CLI it
--- causes concrete pain:
---
--- - Each Copilot CLI process holds an `inuse.<pid>.lock` on its
---   `~/.copilot/session-state/<uuid>/` directory.
--- - When nvim exits, the tmux session survives; the lock stays.
--- - Next nvim → new sidekick session UUID → old session is hidden from
---   the "Sessions" tab; `/resume` finds it but reports "in use by
---   another".
--- - Orphaned tmux sessions accumulate over time.
---
--- This utility follows the pattern already used for OpenCode
--- (`nvim/lua/nairovim/plugins/ai/opencode.lua`): on `VimLeavePre`,
--- explicitly tear down sidekick's CLI processes so they release their
--- locks and don't linger. It also does a defensive startup sweep to
--- clean up sessions orphaned by a previous nvim crash.

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

--- Kill CLI processes launched inside sidekick's tmux sessions **owned by
--- this nvim instance**, then release their session locks.
function M.cleanup_on_exit()
    if vim.fn.executable("tmux") ~= 1 then
        return
    end

    for _, name in ipairs(list_sidekick_tmux_sessions()) do
        if is_our_session(name) then
            kill_session(name)
        end
    end
end

--- Best-effort startup cleanup: kill sidekick tmux sessions whose owning
--- nvim (based on the `tmux new -A -s <name>` process's ppid) is no
--- longer running. Runs once shortly after startup so it doesn't slow
--- down nvim boot.
function M.cleanup_orphans_on_startup()
    if vim.fn.has("linux") ~= 1 or vim.fn.executable("tmux") ~= 1 then
        return
    end

    local sessions = list_sidekick_tmux_sessions()
    for _, name in ipairs(sessions) do
        -- Find the `tmux new -A -s <name>` process that started this session.
        local starters = vim.fn.systemlist({
            "pgrep",
            "-f",
            "tmux new -A -s " .. name,
        })
        if #starters == 0 then
            -- Its starter is gone; kill the orphaned session.
            kill_session(name)
        else
            -- Check whether the parent nvim of the starter is still alive.
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
