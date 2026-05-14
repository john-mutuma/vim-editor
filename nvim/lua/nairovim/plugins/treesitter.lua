----------------------------------------------------------------------
-- Treesitter (main branch — Neovim 0.11+ API)
----------------------------------------------------------------------
return {
    "nvim-treesitter/nvim-treesitter",
    branch = "main",
    lazy = false,        -- main branch recommends not lazy-loading
    build = ":TSUpdate",
    dependencies = {
        "windwp/nvim-ts-autotag",
    },
    config = function()
        local parsers = {
            "json", "javascript", "typescript", "tsx", "lua",
            "vim", "vimdoc", "css", "html", "markdown",
            "markdown_inline", "dockerfile", "gitignore", "bash",
            "yaml", "graphql", "c_sharp",
        }

        -- Install parsers (idempotent; main API)
        require("nvim-treesitter").install(parsers)

        -- Enable highlights + folds per buffer when a parser is available
        vim.api.nvim_create_autocmd("FileType", {
            callback = function(args)
                local ft = vim.bo[args.buf].filetype
                local lang = vim.treesitter.language.get_lang(ft)
                if lang and pcall(vim.treesitter.start, args.buf, lang) then
                    vim.opt_local.foldmethod = "expr"
                    vim.opt_local.foldexpr   = "v:lua.vim.treesitter.foldexpr()"
                    vim.opt_local.foldenable = true
                    vim.opt_local.foldlevel  = 2
                    -- Indent (main branch is opt-in, experimental)
                    vim.bo[args.buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
                end
            end,
        })

        -- nvim-ts-autotag (independent of treesitter API change)
        require("nvim-ts-autotag").setup({
            opts = {
                enable_close = true,
                enable_rename = true,
                enable_close_on_slash = false,
            },
            per_filetype = {
                ["html"] = { enable_close = false },
            },
        })

        ----------------------------------------------------------------------
        -- Compat shim for nvim-ts-autotag on main branch
        -- nvim-ts-autotag uses legacy nvim-treesitter.configs API (removed in main)
        -- See AGENTS.md: 2026-05-07 telescope migration / ts-autotag tech debt
        ----------------------------------------------------------------------
        package.preload["nvim-treesitter.configs"] = function()
            return {
                is_enabled = function() return true end,
                get_module = function() return {} end,
                setup = function() end,
            }
        end
    end,
}
