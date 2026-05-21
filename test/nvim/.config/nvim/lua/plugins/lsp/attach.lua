-- lua/plugins/lsp/attach.lua
return {
  {
    "neovim/nvim-lspconfig",
    config = function()
      -- 1. ── Global Capabilities ─────────────────────────────────────────────
      -- Injects blink.cmp autocomplete capabilities into every server seamlessly.
      vim.lsp.config("*", {
        capabilities = (function()
          local ok, blink = pcall(require, "blink.cmp")
          if ok then return blink.get_lsp_capabilities() end
          return vim.lsp.protocol.make_client_capabilities()
        end)(),
      })

      -- 2. ── LspAttach (Buffer-Local Logic) ──────────────────────────────────
      vim.api.nvim_create_autocmd("LspAttach", {
        group = vim.api.nvim_create_augroup("UserLspAttach", { clear = true }),
        callback = function(event)
          local client = vim.lsp.get_client_by_id(event.data.client_id)
          if not client then return end

          -- Helper to bind keys strictly to this specific buffer
          local map = function(keys, func, desc)
            vim.keymap.set("n", keys, func, { buffer = event.buf, desc = "LSP: " .. desc })
          end

          -- Map Telescope Definition (Overrides nothing, adds to defaults)
          map("gd", require("telescope.builtin").lsp_definitions, "Go to definition")
          map("gD", vim.lsp.buf.declaration, "Go to declaration")

          -- Inlay hints (Modern 0.10+ Native API)
          if client:supports_method("textDocument/inlayHint") then
            vim.lsp.inlay_hint.enable(true, { bufnr = event.buf })
            map("<leader>ch", function()
              local enabled = vim.lsp.inlay_hint.is_enabled({ bufnr = event.buf })
              vim.lsp.inlay_hint.enable(not enabled, { bufnr = event.buf })
            end, "Toggle inlay hints")
          end

          -- CodeLens (FIXED: Modern 0.12+ Native API)
          -- Replaces the deprecated codelens.refresh() loop
          if client:supports_method("textDocument/codeLens") then
            vim.lsp.codelens.enable(true, { bufnr = event.buf })
          end

          -- Document Highlight: Glows all references of the variable under your cursor
          -- (Fact Check: As of 0.12, this still requires a manual autocmd block, 
          -- there is no .enable() API for document_highlight yet).
          if client:supports_method("textDocument/documentHighlight") then
            local hl = vim.api.nvim_create_augroup("UserLspHighlight", { clear = false })
            vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
              buffer = event.buf,
              group = hl,
              callback = vim.lsp.buf.document_highlight
            })
            vim.api.nvim_create_autocmd("CursorMoved", {
              buffer = event.buf,
              group = hl,
              callback = vim.lsp.buf.clear_references
            })
          end
        end,
      })
    end,
  },
}
