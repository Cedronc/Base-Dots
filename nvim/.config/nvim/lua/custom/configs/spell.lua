-- TODO: Add spelling toggle on or off using `:set spell?, :set nospell, :set spell`

-- Add word in a specific language
local function add_word_to_lang(lang)
  -- Find word under cursor
  local word = vim.fn.expand '<cword>'
  if word == '' then
    print 'No word under cursor.'
    return
  end

  -- Save original language and spellfile
  local original_lang = vim.opt.spelllang:get()
  local original_spellfile = vim.opt.spellfile

  -- Get the current language file
  local spellfile_path = vim.fn.expand(string.format('~/Base-Dots/nvim/.config/nvim/spell/%s.utf-8.add', lang))

  -- Temporarily set spelllang to only the desired language
  vim.opt.spelllang = { lang }
  vim.opt.spellfile = spellfile_path

  -- Mark word as good and save spellfile
  vim.cmd('silent! spellgood ' .. word)
  vim.cmd('silent! mkspell! ' .. spellfile_path)

  -- Restore original settings
  vim.opt.spelllang = original_lang
  vim.opt.spellfile = original_spellfile

  print("Added '" .. word .. "' to " .. lang)
end

vim.keymap.set('n', '<leader>z', '', { desc = 'Spelling' })
vim.keymap.set('n', '<leader>zn', function()
  add_word_to_lang 'nl'
end, { desc = 'Add word to Dutch' })
vim.keymap.set('n', '<leader>ze', function()
  add_word_to_lang 'en'
end, { desc = 'Add word to English' })

return {}
