-- define :Browse to enable GBrowse to work
vim.cmd([[
  command! -nargs=1 Browse silent execute '!open' shellescape(<q-args>,1)
]])
