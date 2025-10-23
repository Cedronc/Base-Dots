return {
  { "ellisonleao/gruvbox.nvim",
    priority = 1000 ,
    config = function()
      -- NOTE: you do not need to call setup if you don't want to.
      require('gruvbox').setup {
        -- optional configuration here
      }
      vim.cmd 'colorscheme gruvbox'
    end,
    opts = {}},
  { -- If you want to see what colorschemes are already installed, you can use `:Telescope colorscheme`.
    'folke/tokyonight.nvim',
    priority = 1000,
    config = function()
      ---@diagnostic disable-next-line: missing-fields
      require('tokyonight').setup {
        styles = {
          comments = { italic = false },
        },
      }
    end,
  },
  {
    'sainnhe/everforest',
    lazy = false,
    priority = 1001,
    config = function()
      -- Optionally configure and load the colorscheme
      -- directly inside the plugin declaration.
      vim.g.everforest_enable_italic = true
      vim.g.everforest_background = 'hard'
      vim.cmd.colorscheme 'everforest'
    end,
  },
  {
    'vague-theme/vague.nvim',
    lazy = false, -- make sure we load this during startup if it is your main colorscheme
    priority = 1000, -- make sure to load this before all the other plugins
  },
  {
    "scottmckendry/cyberdream.nvim",
    lazy = false,
    priority = 1000,
  }
}
