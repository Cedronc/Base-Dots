-- Increase timeout for key sequences
vim.opt.timeoutlen = 1000  -- default is 1000 (1 second), try 500-1000
vim.opt.ttimeoutlen = 50  -- for terminal key codes

-- vim.cmd 'set path+=**'
vim.o.conceallevel = 2

--[[ Setting options ]]
-- See `:help vim.o`
-- NOTE: You can change these options as you wish!
--  For more options, you can see `:help option-list`
vim.o.signcolumn = 'yes'
vim.cmd 'set nowrap'

vim.cmd 'set wildignore=*.docx,*.jpg,*.png,*.gif,*.pdf,*.pyc,*.exe,*.flv,*.img,*.xlsx'
vim.cmd 'set tabstop=2'
vim.cmd 'set shiftwidth=2'
vim.cmd 'set softtabstop=2'
vim.cmd 'set expandtab'
vim.cmd 'set noshiftround'

-- needs to be here to work with import inside init.lua
return {}
