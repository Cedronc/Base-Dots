local vault_path = vim.fn.expand '~/Documents/ObsidianVaults'
if not vim.uv.fs_stat(vault_path) then
  return {}
end

vim.keymap.set('n', '<leader>os', ':ObsidianSearch<CR>')
vim.keymap.set('n', '<leader>ot', ':ObsidianTags<CR>')
vim.keymap.set('n', '<leader>oi', ':ObsidianPasteImg<CR>')
vim.keymap.set('n', '<leader>of', ':ObsidianFollowLink<CR>')
vim.keymap.set('n', '<leader>oo', ':ObsidianOpen<CR>')

return {
  {
    'epwalsh/obsidian.nvim',
    version = '*', -- recommended, use latest release instead of latest commit
    lazy = true,
    ft = '',
    -- Replace the above line with this if you only want to load obsidian.nvim for markdown files in your vault:
    -- event = {
    --   -- If you want to use the home shortcut '~' here you need to call 'vim.fn.expand'.
    --   -- E.g. "BufReadPre " .. vim.fn.expand "~" .. "/my-vault/*.md"
    --   -- refer to `:h file-pattern` for more examples
    --   "BufReadPre path/to/my-vault/*.md",
    --   "BufNewFile path/to/my-vault/*.md",
    -- },
    dependencies = {
      -- Required.
      'nvim-lua/plenary.nvim',
      'nvim-telescope/telescope.nvim',

      -- see below for full list of optional dependencies 👇
    },
    config = {
      workspaces = {
        {
          name = 'Personal',
          path = '~/Documents/ObsidianVaults/Personal',
        },
        {
          name = 'MyVault',
          path = '~/Documents/ObsidianVaults/MyVault',
        },
      },

      -- Optional, for templates (see below).
      templates = {
        folder = '0 - Templates',
        date_format = '%Y-%m-%d',
        time_format = '%H:%M',
        -- A map for custom variables, the key should be the variable and the value a function
        substitutions = {},
      },
      mappings = {
        -- Overrides the 'gf' mapping to work on markdown/wiki links within your vault.
        ['gf'] = {
          action = function()
            return require('obsidian').util.gf_passthrough()
          end,
          opts = { noremap = false, expr = true, buffer = true },
        },
        -- Smart action depending on context, either follow link or toggle checkbox.
        ['<cr>'] = {
          action = function()
            return require('obsidian').util.smart_action()
          end,
          opts = { buffer = true, expr = true },
        },
      },
    },
  },
}
