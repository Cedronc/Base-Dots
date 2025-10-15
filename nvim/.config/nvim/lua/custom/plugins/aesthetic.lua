return {
  -----------------------------------------------------------------------------
  -- 🌀 Indent Scope (Animated Indent Lines)
  -- https://github.com/nvim-mini/mini.indentscope
  -----------------------------------------------------------------------------
  {
    'echasnovski/mini.indentscope',
    version = '*',
    config = function()
      require('mini.indentscope').setup {
        symbol = '│',
        options = { try_as_border = true },
      }
    end,
  },

  -----------------------------------------------------------------------------
  -- 🔔 Notify (Popup Notifications)
  -----------------------------------------------------------------------------
  {
    'rcarriga/nvim-notify',
    config = function()
      vim.notify = require 'notify'
      require('notify').setup {
        background_colour = '#000000',
      }
    end,
  },

  -----------------------------------------------------------------------------
  -- 🔮 Noice (Enhanced UI, Messages, Cmdline)
  -----------------------------------------------------------------------------
  -- {
  --   'folke/noice.nvim',
  --   dependencies = {
  --     'MunifTanjim/nui.nvim',
  --     'rcarriga/nvim-notify',
  --   },
  --   config = function()
  --     require('noice').setup {}
  --   end,
  -- },
}
