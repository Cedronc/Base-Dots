 -- TODO: Add a way to open in a new terminal and maybe add some file watcher like `nodemon` or `when-changed`
vim.keymap.set('n', '<leader>r', ':update <CR> :make<CR>')

vim.api.nvim_create_autocmd('BufEnter', {
  callback = function()
    local filetypes = {
      scala = 'scala %',
      lisp = 'sbcl --script % ',
      sh = 'bash %',
      python = 'uv run %',
    }
    local makeprg = filetypes[vim.bo.filetype] or nil
    if not (makeprg == nil) then
      vim.opt.makeprg = makeprg
    end
  end,
})

return {}
