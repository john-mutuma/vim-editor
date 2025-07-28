require("nairovim.core")
require("nairovim.lazy")

-- Autosave on InsertLeave and FocusLost
-- TODO: add this auto save functionality when needed and ready
-- vim.api.nvim_create_autocmd({ "InsertLeave", "FocusLost" }, {
--     pattern = "*",
--     callback = function()
--         if vim.bo.modified and vim.bo.filetype ~= "" and vim.fn.expand("%") ~= "" then
--             vim.cmd("silent! write")
--             print("Autosaved ")
--         end
--     end,
--     desc = "Autosave on insert leave or focus lost",
-- })
