-- lua/plugins/lsp/attach.lua
--
-- Global LSP capabilities and per-buffer setup via LspAttach.
-- This file owns: capabilities, keymaps, inlay hints, codelens, doc highlight.
--
-- ─── WHAT NEOVIM 0.11/0.12 PROVIDES BY DEFAULT ───────────────────────────────
-- These keymaps are set GLOBALLY at startup, not in LspAttach.
-- They are no-ops when no LSP is attached. Do not remap them.
--
--   K        → vim.lsp.buf.hover()
--   grn      → vim.lsp.buf.rename()
--   gra      → vim.lsp.buf.code_action()     (Normal + Visual)
--   grr      → vim.lsp.buf.references()
--   gri      → vim.lsp.buf.implementation()
--   grt      → vim.lsp.buf.type_definition()
--   grx      → vim.lsp.codelens.run()
--   gO       → vim.lsp.buf.document_symbol()
--   <C-s>    → vim.lsp.buf.signature_help()  (Insert)
--
-- ─── WHAT WE ADD IN LspAttach ─────────────────────────────────────────────────
--   gd       → definition (not in defaults; uses telescope picker)
--   gD       → declaration (not in defaults)
--   <leader>ch → toggle inlay hints

return {
  {
    "neovim/nvim-lspconfig",   -- deduped by lazy.nvim; runs config after servers.lua
    config = function()

      -- ── Global capabilities ───────────────────────────────────────────────
      -- Applied to every LSP server at attach time via the "*" wildcard.
      -- blink.cmp must be loaded before any server attaches (lazy=false).
      vim.lsp.config("*", {
        capabilities = (function()
          local ok, blink = pcall(require, "blink.cmp")
          if ok then return blink.get_lsp_capabilities() end
          return vim.lsp.protocol.make_client_capabilities()
        end)(),
      })

      -- ── LspAttach ─────────────────────────────────────────────────────────
      vim.api.nvim_create_autocmd("LspAttach", {
        group = vim.api.nvim_create_augroup("UserLspAttach", { clear = true }),
        callback = function(event)
          local client = vim.lsp.get_client_by_id(event.data.client_id)
          if not client then return end

          local map = function(keys, func, desc, mode)
            vim.keymap.set(mode or "n", keys, func, {
              buffer = event.buf,
              desc   = "LSP: " .. desc,
            })
          end

          -- gd: go to definition via telescope (not in Neovim defaults)
          map("gd", function()
            require("telescope.builtin").lsp_definitions()
          end, "Go to definition")

          -- gD: declaration (not in defaults)
          map("gD", vim.lsp.buf.declaration, "Go to declaration")

          -- Inlay hints
          if client:supports_method("textDocument/inlayHint") then
            vim.lsp.inlay_hint.enable(true, { bufnr = event.buf })
            map("<leader>ch", function()
              local enabled = vim.lsp.inlay_hint.is_enabled({ bufnr = event.buf })
              vim.lsp.inlay_hint.enable(not enabled, { bufnr = event.buf })
            end, "Toggle inlay hints")
          end

          -- Code lens auto-refresh (grx to run is already a default keymap)
          if client:supports_method("textDocument/codeLens") then
            vim.lsp.codelens.refresh()
            vim.api.nvim_create_autocmd(
              { "BufEnter", "CursorHold", "InsertLeave" },
              { buffer = event.buf, callback = vim.lsp.codelens.refresh }
            )
          end

          -- Document highlight: glow all references to symbol under cursor
          if client:supports_method("textDocument/documentHighlight") then
            local hl = vim.api.nvim_create_augroup("UserLspHighlight", { clear = false })
            vim.api.nvim_create_autocmd(
              { "CursorHold", "CursorHoldI" },
              { buffer = event.buf, group = hl, callback = vim.lsp.buf.document_highlight }
            )
            vim.api.nvim_create_autocmd(
              "CursorMoved",
              { buffer = event.buf, group = hl, callback = vim.lsp.buf.clear_references }
            )
          end
        end,
      })
    end,
  },
}
