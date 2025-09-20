local vim = vim

if not vim.g.vscode then
    require("nairovim.core")
    require("nairovim.lazy")
else
    require("nairovim-vscode.core")
    require("nairovim-vscode.lazy")
end
