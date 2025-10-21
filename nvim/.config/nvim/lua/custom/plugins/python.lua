return {
  {
    "benomahony/uv.nvim",
    -- Optional filetype to lazy load when you open a python file
    ft = { "python", "py" },
    dependencies = { "nvim-telescope/telescope.nvim" },
    opts = {
      picker_integration = true,
    },
  },
}
