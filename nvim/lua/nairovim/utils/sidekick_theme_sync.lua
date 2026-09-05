----------------------------------------------------------------------
-- 1. Sidekick Theme Sync
----------------------------------------------------------------------
--- Copilot CLI (and other TUIs) launched via sidekick.nvim pick their
--- light/dark palette at process startup. When nvim's colorscheme is
--- toggled, the sidekick window bg flips but the child process keeps its
--- stale palette (e.g. dark-mode text ends up rendered faintly on a
--- now-light bg or vice versa).
---
--- Copilot CLI exposes no runtime signal (no slash command, no SIGHUP
--- handler, no /theme reload) to make it re-query OSC 11 / $COLORFGBG.
--- The only remedy is to restart the process.
---
--- Two paths depending on sidekick's backend for the session:
---
--- 1. tmux/mux backend (sidekick spawns the CLI inside a tmux pane):
---    Use `tmux respawn-pane -k` to swap the process in place. The nvim
---    window stays attached; user sees only a brief flicker inside the
---    pane. Env overrides (`-e COLORFGBG=...`) hand the new process the
---    freshly-synced bg hint.
---
--- 2. :terminal backend (mux disabled, e.g. on Windows Terminal where the
---    project sets `mux.enabled = false`): sidekick uses `jobstart(...,
---    { term = true, env = os_environ() })`. There is no external pane
---    to respawn, so we close the sidekick session and re-toggle it. The
---    new session inherits the just-updated `vim.env.COLORFGBG` via
---    `os_environ`, so the fresh CLI process picks the right palette.

local M = {}

--- Debounce window in ms — some colorscheme plugins fire multiple
--- ColorScheme events per user action (e.g. base scheme + variant tweaks).
--- Coalescing prevents redundant respawns.
local DEBOUNCE_MS = 100

--- @type uv.uv_timer_t?
local pending_timer = nil

--- Path A: restart the CLI running in a tmux-backed sidekick session by
--- swapping the pane's foreground process in place with `respawn-pane -k`.
--- @param session table Sidekick session (from sidekick.cli.terminal.terminals).
local function respawn_tmux(session)
    if not (session.tool and session.tool.cmd and #session.tool.cmd > 0) then
        return
    end

    local cmd = { "tmux", "respawn-pane", "-k", "-t", session.mux_session .. ":" }
    if vim.env.COLORFGBG then
        vim.list_extend(cmd, { "-e", "COLORFGBG=" .. vim.env.COLORFGBG })
    end
    if vim.env.NVIM_COLORFGBG then
        vim.list_extend(cmd, { "-e", "NVIM_COLORFGBG=" .. vim.env.NVIM_COLORFGBG })
    end
    vim.list_extend(cmd, session.tool.cmd)

    vim.fn.jobstart(cmd, { detach = true })
end

--- Path B: restart the CLI in a :terminal-backed sidekick session by
--- closing the session and re-toggling it. Preserves focus state.
--- @param session table Sidekick session (from sidekick.cli.terminal.terminals).
local function restart_terminal(session)
    local tool_name = session.tool and session.tool.name
    if not tool_name then
        return
    end

    local was_focused = false
    if type(session.is_focused) == "function" then
        local ok, focused = pcall(session.is_focused, session)
        was_focused = ok and focused or false
    end

    -- Tear down the current session (stops job, deletes buf/win, unregisters
    -- from sidekick.cli.terminal.terminals, clears autocmds).
    pcall(function()
        session:close()
    end)

    -- Re-open on the next tick so sidekick's internal state settles before
    -- attach. The fresh session's jobstart inherits vim.env.COLORFGBG, which
    -- our options.lua ColorScheme handler already updated to match the new bg.
    vim.schedule(function()
        local ok, cli = pcall(require, "sidekick.cli")
        if ok then
            pcall(cli.toggle, { name = tool_name, focus = was_focused })
        end
    end)
end

--- Iterate all active sidekick sessions and restart their CLIs.
--- Dispatches per-session based on whether it uses a tmux/mux backend or
--- runs directly in a nvim :terminal.
function M.restart_all_after_colorscheme()
    local ok, terminal = pcall(require, "sidekick.cli.terminal")
    if not ok then
        return
    end
    for _, s in pairs(terminal.terminals or {}) do
        if s.mux_session and (s.mux_backend or "tmux") == "tmux" then
            respawn_tmux(s)
        else
            restart_terminal(s)
        end
    end
end

--- Register a debounced ColorScheme autocmd. Idempotent — calling setup()
--- multiple times replaces the previous augroup.
function M.setup()
    local group = vim.api.nvim_create_augroup("nairovim_sidekick_theme_sync", { clear = true })
    vim.api.nvim_create_autocmd("ColorScheme", {
        group = group,
        desc = "Restart sidekick CLI processes on ColorScheme so palettes re-detect bg",
        callback = function()
            if pending_timer and not pending_timer:is_closing() then
                pending_timer:stop()
                pending_timer:close()
            end
            pending_timer = vim.defer_fn(function()
                pending_timer = nil
                M.restart_all_after_colorscheme()
            end, DEBOUNCE_MS)
        end,
    })
end

return M
