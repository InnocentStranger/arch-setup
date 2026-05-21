-- lua/plugins/lsp/attach.lua
--
-- Two responsibilities:
--   1. Global LSP capabilities — tell every server what blink.cmp supports
--   2. LspAttach — buffer-local keymaps and feature setup per server
--
-- ─── NEOVIM 0.11/0.12 DEFAULT KEYMAPS (already exist, do not remap) ──────────
--
--   K        → hover documentation
--   grn      → rename symbol
--   gra      → code action (Normal + Visual)
--   grr      → references
--   gri      → implementation
--   grt      → type definition
--   grx      → run codelens at cursor
--   gO       → document symbols
--   <C-s>    → signature help (Insert mode)
--
--   These are global, active at startup, no-ops without LSP. Don't remap them.
--
-- ─── WHAT THIS FILE ADDS ──────────────────────────────────────────────────────
--
--   gd             → go to definition (telescope picker)
--   gD             → go to declaration
--   <leader>ch     → toggle inlay hints
--
--   Plus per-server feature setup when the server supports it:
--     inlay hints      → enabled by default, toggled with <leader>ch
--     codelens         → enabled via vim.lsp.codelens.enable() (0.12 API)
--     document highlight → cursor rests on symbol → all references glow

return {
  {
    "neovim/nvim-lspconfig",  -- deduped by lazy.nvim; runs after servers.lua
    config = function()

      -- ── 1. Global capabilities ──────────────────────────────────────────────
      --
      -- vim.lsp.config("*") applies to every server at attach time.
      -- blink.cmp must be loaded before any server attaches (it's lazy=false).
      --
      -- What get_lsp_capabilities() adds over the bare defaults:
      --   - snippet support (servers send richer completions)
      --   - resolve support (servers send docs/details in completion items)
      --   - everything else blink supports that bare Neovim doesn't advertise
      vim.lsp.config("*", {
        capabilities = (function()
          local ok, blink = pcall(require, "blink.cmp")
          if ok then return blink.get_lsp_capabilities() end
          -- Fallback: blink not loaded yet or not installed
          return vim.lsp.protocol.make_client_capabilities()
        end)(),
      })

      -- ── 2. LspAttach ────────────────────────────────────────────────────────
      --
      -- Fires once per buffer when any LSP server attaches.
      -- Keymaps are buffer-local — only active in buffers with LSP attached.
      -- client:supports_method() checks are mandatory before enabling features:
      -- not every server supports every capability, and skipping the check
      -- causes silent failures or wasted autocmds.
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

          -- gd: go to definition — NOT in Neovim's defaults
          -- Using telescope gives a picker UI; swap for vim.lsp.buf.definition
          -- if you prefer to jump directly without a picker.
          map("gd", function()
            require("telescope.builtin").lsp_definitions()
          end, "Go to definition")

          -- gD: declaration — NOT in Neovim's defaults
          -- Different from definition: declaration = where the symbol is declared
          -- (e.g. function signature in a .h file); definition = where it's implemented
          map("gD", vim.lsp.buf.declaration, "Go to declaration")

          -- ── Inlay hints ─────────────────────────────────────────────────────
          -- Grey inline annotations showing inferred types, parameter names, etc.
          -- Example: func(/* name: */ "John", /* age: */ 30)
          -- Enabled by default if the server supports them; toggle with <leader>ch.
          if client:supports_method("textDocument/inlayHint") then
            vim.lsp.inlay_hint.enable(true, { bufnr = event.buf })

            map("<leader>ch", function()
              local enabled = vim.lsp.inlay_hint.is_enabled({ bufnr = event.buf })
              vim.lsp.inlay_hint.enable(not enabled, { bufnr = event.buf })
            end, "Toggle inlay hints")
          end

          -- ── Codelens ────────────────────────────────────────────────────────
          -- Small actionable annotations that servers render above/beside code.
          -- Examples: "▶ Run test", "2 references", "▶ Debug"
          -- Run the lens at cursor with grx (a default Neovim keymap — don't remap).
          --
          -- 0.12 API: vim.lsp.codelens.enable(true, { bufnr = bufnr })
          -- This replaces the old pattern of calling vim.lsp.codelens.refresh()
          -- manually and setting up autocmds. Neovim now manages refresh internally.
          --
          -- DEPRECATED (removed in 0.13): vim.lsp.codelens.refresh()
          if client:supports_method("textDocument/codeLens") then
            vim.lsp.codelens.enable(true, { bufnr = event.buf })
          end

          -- ── Document highlight ───────────────────────────────────────────────
          -- When cursor rests on a symbol, all its references in the buffer glow.
          -- Purely visual — no keymap needed. Clears when cursor moves.
          -- Controlled by updatetime (set in options.lua, default 200ms).
          if client:supports_method("textDocument/documentHighlight") then
            local hl = vim.api.nvim_create_augroup("UserLspHighlight", { clear = false })

            vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
              buffer   = event.buf,
              group    = hl,
              callback = vim.lsp.buf.document_highlight,
            })

            vim.api.nvim_create_autocmd("CursorMoved", {
              buffer   = event.buf,
              group    = hl,
              callback = vim.lsp.buf.clear_references,
            })
          end

        end,
      })
    end,
  },
}
