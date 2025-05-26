return {
    "VidocqH/lsp-lens.nvim",
    event =  "LspAttach",
    config = function()
        require("lsp-lens").setup({
            enable = true,
            include_declaration = false, -- Reference include declaration
            sections = {                 -- Enable / Disable specific request, formatter example looks 'Format Requests'
                definition = true,
                references = true,
                implements = false,
                git_authors = false,
            },
            ignore_filetype = {
                "prisma",
            },
        })
    end,
}
