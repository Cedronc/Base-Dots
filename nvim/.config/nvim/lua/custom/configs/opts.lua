-- vim.cmd 'set path+=**'
vim.opt.spelllang = { "en", "nl" } -- Set languages

-- [[ Setting options ]]
-- See `:help vim.o`
-- NOTE: You can change these options as you wish!
--  For more options, you can see `:help option-list`
vim.o.signcolumn = 'yes'

vim.cmd 'set wildignore=*.docx,*.jpg,*.png,*.gif,*.pdf,*.pyc,*.exe,*.flv,*.img,*.xlsx'
vim.cmd 'set tabstop=2'
vim.cmd 'set shiftwidth=2'
vim.cmd 'set softtabstop=2'
vim.cmd 'set expandtab'
vim.cmd 'set noshiftround'

-- needs to be here to work with import inside init.lua
return {}
