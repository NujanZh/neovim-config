local function switch_source_header(client, bufnr)
  client:request(
    "textDocument/switchSourceHeader",
    vim.lsp.util.make_text_document_params(bufnr),
    function(err, result)
      if err then
        vim.notify(err.message or tostring(err), vim.log.levels.ERROR)
        return
      end

      if not result then
        vim.notify("No corresponding source or header file found")
        return
      end

      vim.cmd.edit(vim.uri_to_fname(result))
    end,
    bufnr
  )
end

return {
  cmd = { "clangd" },
  filetypes = { "c", "cpp", "objc", "objcpp", "cuda" },
  root_markers = {
    ".clangd",
    "compile_commands.json",
    "compile_flags.txt",
    ".git",
  },
  capabilities = {
    textDocument = {
      completion = {
        editsNearCursor = true,
      },
    },
    offsetEncoding = { "utf-8", "utf-16" },
  },
  on_init = function(client, init_result)
    if init_result.offsetEncoding then
      client.offset_encoding = init_result.offsetEncoding
    end
  end,
  on_attach = function(client, bufnr)
    local format = function()
      vim.lsp.buf.format({ bufnr = bufnr, name = "clangd", async = true })
    end

    vim.api.nvim_buf_create_user_command(bufnr, "ClangdFormat", format, {
      desc = "Format the current buffer with clangd",
    })
    vim.api.nvim_buf_create_user_command(bufnr, "ClangdSwitchSourceHeader", function()
      switch_source_header(client, bufnr)
    end, {
      desc = "Switch between the corresponding source and header file",
    })

    vim.keymap.set({ "n", "x" }, "grf", format, {
      buffer = bufnr,
      desc = "Format with clangd",
    })
    vim.keymap.set("n", "grh", function()
      switch_source_header(client, bufnr)
    end, {
      buffer = bufnr,
      desc = "Switch C/C++ source and header",
    })
  end,
}
