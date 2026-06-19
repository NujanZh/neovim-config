vim.lsp.enable({
  "clangd",
})

vim.opt.completeopt = { "menuone", "noselect", "popup" }

vim.api.nvim_create_autocmd("LspAttach", {
  callback = function(event)
    local client = vim.lsp.get_client_by_id(event.data.client_id)
    if client and client.name == "clangd" then
      vim.lsp.completion.enable(true, client.id, event.buf, {
        autotrigger = true,
      })
    end
  end,
})

vim.diagnostic.config({ virtual_text = true })
