require("mason").setup({
    registries = {
        "github:mason-org/mason-registry",
        "github:Crashdummyy/mason-registry",
    },
})

vim.lsp.config("roslyn", {
    on_attach = function()
        vim.notify("rosyln attached")
    end,
    settings = {
        ["csharp|background_analysis"] = {
            dotnet_show_name_completion_suggestions = true,
        },
        ["csharp|completions"] = {
            dotnet_show_name_completion_suggestions = true,
        },
        ["csharp|inlay_hints"] = {
            csharp_enable_inlay_hints_for_implicit_object_creation = true,
            csharp_enable_inlay_hints_for_implicit_variable_types = true,
        },
        ["csharp|code_lens"] = {
            dotnet_enable_references_code_lens = true,
        },
    },
})

return {
  {
    'seblyng/roslyn.nvim',
    ---@module 'roslyn.config'
    ---@type RoslynNvimConfig
    opts = {},
  },

}
