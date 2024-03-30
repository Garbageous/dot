local on_lsp_attach = function(client, bufnr)
end

return {
  -- Dotnet Roslyn
  {
    'jmederosalvarado/roslyn.nvim',
    dependencies = { 'hrsh7th/cmp-nvim-lsp' },
    config = function()
      local capabilities = vim.lsp.protocol.make_client_capabilities()
      capabilities = require('cmp_nvim_lsp').default_capabilities(capabilities)
      require('roslyn').setup {
        on_attach = on_lsp_attach,
        capabilities = capabilities,
      }
    end,
  },
}
