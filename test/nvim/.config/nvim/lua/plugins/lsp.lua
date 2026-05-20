-- lua/plugins/lsp.lua
--
-- ─── ARCHITECTURE OVERVIEW ────────────────────────────────────────────────────
--
-- THREE plugins. Three separate jobs. They do not overlap.
--
--   mason.nvim              → installs the binary (e.g. lua-language-server)
--                             to ~/.local/share/nvim/mason/bin/
--
--   nvim-lspconfig          → contributes lsp/*.lua files onto runtimepath.
--                             Each file has: cmd, filetypes, root_markers.
--                             Neovim merges these with YOUR lsp/*.lua files.
--                             NOTE: require('lspconfig') is DEPRECATED.
--                             You never call it. The plugin works passively.
--
--   mason-lspconfig.nvim    → bridge. Calls vim.lsp.enable() automatically
--                             for every server installed via Mason.
--                             Also provides :LspInstall command.
--
-- ─── THE lsp/ DIRECTORY ──────────────────────────────────────────────────────
--
-- Neovim 0.11+ auto-discovers lsp/<server>.lua from ALL runtimepath entries.
-- nvim-lspconfig adds its own lsp/ to runtimepath (cmd, filetypes, root_markers).
-- YOUR ~/.config/nvim/lsp/<server>.lua adds only your custom settings.
-- Neovim MERGES both. You only write what you want to override.
--
-- Structure:
--   ~/.config/nvim/
--   ├── lsp/                   ← YOUR server configs (only custom settings)
--   │   ├── lua_ls.lua
--   │   ├── ts_ls.lua
--   │   ├── gopls.lua
--   │   └── ...
--   └── lua/plugins/lsp.lua   ← THIS FILE (plugin specs + LspAttach only)
--
-- ─── WHAT require('lspconfig').gopls.setup() WAS ─────────────────────────────
--
-- The OLD pattern did four things in one call:
--   1. Registered cmd/filetypes/root_markers for gopls
--   2. Merged your custom settings
--   3. Set up an on_attach callback
--   4. Started the server
--
-- The NEW pattern splits these:
--   1. nvim-lspconfig lsp/gopls.lua  → cmd, filetypes, root_markers (passive, auto)
--   2. your lsp/gopls.lua            → your custom settings (passive, auto-merged)
--   3. LspAttach autocmd             → keymaps and per-buffer setup
--   4. vim.lsp.enable() via          → mason-lspconfig automatic_enable = true
--      mason-lspconfig
--
-- ─── DEFAULT LSP KEYMAPS IN 0.11/0.12 ───────────────────────────────────────
--
-- These are set GLOBALLY by Neovim at startup — NOT inside LspAttach.
-- They do nothing when no LSP is attached but the mappings always exist.
-- DO NOT remap these; you would just duplicate what Neovim already provides.
--
--   K          → vim.lsp.buf.hover()
--   grn        → vim.lsp.buf.rename()
--   gra        → vim.lsp.buf.code_action()     (Normal + Visual)
--   grr        → vim.lsp.buf.references()
--   gri        → vim.lsp.buf.implementation()
--   grt        → vim.lsp.buf.type_definition()
--   grx        → vim.lsp.codelens.run()
--   gO         → vim.lsp.buf.document_symbol()
--   <C-s>      → vim.lsp.buf.signature_help()  (Insert mode)
--
-- What is NOT in the defaults (set in LspAttach below):
--   gd         → definition  (different from type_definition)
--   gD         → declaration
--   <leader>ch → toggle inlay hints
--   telescope variants if you want pickers for gd/gr etc.
--
-- ─── CAPABILITIES (blink.cmp) ────────────────────────────────────────────────
--
-- vim.lsp.config("*", { capabilities = ... }) sets capabilities for ALL servers.
-- blink.cmp must be loaded before any server attaches (lazy=false on blink).
-- The "*" wildcard is evaluated lazily at attach time, so load order is fine.

return {

  -- ── 1. mason.nvim ──────────────────────────────────────────────────────────
  {
    "mason-org/mason.nvim",
    lazy = false,
    priority = 100,       -- load before mason-lspconfig
    opts = {
      ui = {
        border = "rounded",
        icons = {
          package_installed   = "✓",
          package_pending     = "➜",
          package_uninstalled = "✗",
        },
      },
    },
  },

  -- ── 2. nvim-lspconfig ──────────────────────────────────────────────────────
  -- Load this as a dependency to put its lsp/ directory onto runtimepath.
  -- You never require() it directly. It works passively.
  {
    "neovim/nvim-lspconfig",
    lazy = false,
    priority = 90,
  },

  -- ── 3. mason-lspconfig.nvim ────────────────────────────────────────────────
  {
    "mason-org/mason-lspconfig.nvim",
    lazy = false,
    priority = 80,
    dependencies = {
      "mason-org/mason.nvim",
      "neovim/nvim-lspconfig",    -- must be in runtimepath first
    },
    opts = {
      -- Servers to install automatically if missing.
      -- mason-lspconfig translates these names to mason package names for you.
      -- e.g. "lua_ls" → installs "lua-language-server" binary via mason.
      ensure_installed = {
        "lua_ls",         -- Lua
        "ts_ls",          -- TypeScript / JavaScript
        "pyright",        -- Python
        "gopls",          -- Go
        "rust_analyzer",  -- Rust
        "jsonls",         -- JSON
        "yamlls",         -- YAML
        "html",           -- HTML
        "cssls",          -- CSS
        "bashls",         -- Bash / Shell
        "marksman",       -- Markdown
      },

      -- automatic_enable = true is the DEFAULT in mason-lspconfig v2.
      -- It calls vim.lsp.enable() for every server installed via Mason.
      -- You do not need to call vim.lsp.enable() yourself for these servers.
      -- To exclude a specific server (e.g. managed by another plugin like rustaceanvim):
      --   automatic_enable = { exclude = { "rust_analyzer" } }
      automatic_enable = true,
    },
  },

  -- ── 4. Global capabilities + LspAttach ────────────────────────────────────
  -- This is not a real plugin entry — it piggybacks on nvim-lspconfig
  -- to run setup code after the plugin stack is ready.
  {
    "neovim/nvim-lspconfig",    -- lazy.nvim deduplicates same plugin name
    config = function()

      -- ── Global capabilities (all servers) ──────────────────────────────────
      -- Tell every LSP server what the client (blink.cmp) can handle.
      -- blink.cmp must be loaded before any server attaches (it's lazy=false).
      vim.lsp.config("*", {
        capabilities = (function()
          local ok, blink = pcall(require, "blink.cmp")
          if ok then
            return blink.get_lsp_capabilities()
          end
          -- Fallback if blink.cmp is not loaded yet
          return vim.lsp.protocol.make_client_capabilities()
        end)(),
      })

      -- ── LspAttach: keymaps that are NOT in Neovim defaults ─────────────────
      -- Runs every time any LSP server attaches to a buffer.
      -- Only map things that Neovim does NOT already provide globally.
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

          -- gd and gD are NOT in Neovim's default keymaps.
          -- We use telescope pickers here for a UI — swap for vim.lsp.buf.*
          -- versions if you don't want a picker.
          map("gd", function()
            require("telescope.builtin").lsp_definitions()
          end, "Go to definition")

          map("gD", vim.lsp.buf.declaration, "Go to declaration")

          -- Inlay hints: toggle on/off.
          -- NOT a default. Enable by default if the server supports them.
          if client:supports_method("textDocument/inlayHint") then
            -- Enable inlay hints by default for this buffer
            vim.lsp.inlay_hint.enable(true, { bufnr = event.buf })

            map("<leader>ch", function()
              local enabled = vim.lsp.inlay_hint.is_enabled({ bufnr = event.buf })
              vim.lsp.inlay_hint.enable(not enabled, { bufnr = event.buf })
            end, "Toggle inlay hints")
          end

          -- Code lens: refresh and display if the server supports it.
          -- grx (run codelens) IS a default keymap — don't remap it.
          -- But enabling auto-refresh is not default.
          if client:supports_method("textDocument/codeLens") then
            vim.lsp.codelens.refresh()
            vim.api.nvim_create_autocmd({ "BufEnter", "CursorHold", "InsertLeave" }, {
              buffer   = event.buf,
              callback = vim.lsp.codelens.refresh,
            })
          end

          -- Highlight word under cursor (document highlight).
          -- When cursor rests on a symbol, all its references in the buffer glow.
          if client:supports_method("textDocument/documentHighlight") then
            local hl_group = vim.api.nvim_create_augroup("UserLspHighlight", { clear = false })
            vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
              buffer = event.buf,
              group  = hl_group,
              callback = vim.lsp.buf.document_highlight,
            })
            vim.api.nvim_create_autocmd("CursorMoved", {
              buffer   = event.buf,
              group    = hl_group,
              callback = vim.lsp.buf.clear_references,
            })
          end
        end,
      })
    end,
  },

}
