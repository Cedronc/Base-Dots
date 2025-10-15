vim.keymap.set('n', '<leader>r', ':update <CR> :make<CR>')

vim.api.nvim_create_autocmd('BufEnter', {
  callback = function()
    local filetypes = {
      scala = 'scala %',
      sh = 'bash %',
    }
    local makeprg = filetypes[vim.bo.filetype] or nil
    if not (makeprg == nil) then
      vim.opt.makeprg = makeprg
    end
  end,
})

return {}
