-- vim.api.nvim_create_autocmd('LspAttach', {
--     callback = function(args)
--         local client_id = args.data.client_id
--         local bufnr = args.buf
--         local client = vim.lsp.get_client_by_id(client_id)
--         if not client then
--             return
--         end
--
--         if client.server_capabilities.completionProvider and client.name ~= 'minuet' then
--             vim.lsp.completion.enable(true, client_id, bufnr, { autotrigger = true })
--         end
--     end,
--     desc = 'Enable built-in auto completion',
-- })

vim.keymap.set('n' , '<leader>tm', ":Minuet virtualtext toggle <CR>", { desc = 'Toggle Minuet virtualtext' })

return
{
  'milanglacier/minuet-ai.nvim',
  config = function()
    require('minuet').setup {
      provider_options = {
        codestral = {
          model = 'codestral-latest',
          end_point = 'https://codestral.mistral.ai/v1/fim/completions',
          api_key = 'CODESTRAL_API_KEY',
          stream = true,
          optional = {
            max_tokens = 256,
            stop = { '\n\n' },
          },
        },
      },

      virtualtext = {
        auto_trigger_ft = {},
        keymap = {
          -- accept whole completion
          accept = '<A-Y>',
          -- accept one line
          accept_line = '<A-y>',
          -- accept n lines (prompts for number)
          -- e.g. "A-z 2 CR" will accept 2 lines
          -- accept_n_lines = '<A-y>',
          -- Cycle to prev completion item, or manually invoke completion
          prev = '<A-p>',
          -- Cycle to next completion item, or manually invoke completion
          next = '<A-n>',
          dismiss = '<A-e>',
        },
      },
    }
  end,
}
