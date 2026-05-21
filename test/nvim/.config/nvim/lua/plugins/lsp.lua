-- lua/plugins/lsp.lua
--
-- ─── ARCHITECTURE ─────────────────────────────────────────────────────────────
--
--   mason-org/mason.nvim          → installs binaries (lua-language-server, gopls, etc.)
--   neovim/nvim-lspconfig         → contributes lsp/*.lua onto runtimepath (data only)
--   mason-org/mason-lspconfig     → calls vim.lsp.enable() for installed servers
--
-- ─── require('lspconfig') IS DEPRECATED ───────────────────────────────────────
--
--   require('lspconfig').gopls.setup({})   ← DEPRECATED, will error in future
--   nvim-lspconfig (the plugin)            ← NOT deprecated, still needed as data
--
--   nvim-lspconfig now works passively: it puts lsp/*.lua files on runtimepath
--   that Neovim reads automatically. You never call require('lspconfig') again.
--
-- ─── YOUR lsp/ FILES ──────────────────────────────────────────────────────────
--
--   ~/.config/nvim/lsp/<server>.lua  → only your custom overrides
--   nvim-lspconfig lsp/<server>.lua  → cmd, filetypes, root_markers (base)
--   Neovim MERGES both automatically.
--
--   Use "after/lsp/" if you need your file to win over nvim-lspconfig.
--   Regular "lsp/" merges with nvim-lspconfig (lspconfig takes precedence on conflicts).
--
-- ─── DEFAULT KEYMAPS IN 0.11/0.12 (DO NOT REMAP) ────────────────────────────
--
--   These exist globally, do nothing without LSP, no need to set in LspAttach:
--     K        → hover
--     grn      → rename
--     gra      → code_action (normal + visual)
--     grr      → references
--     gri      → implementation
--     grt      → type_definition
--     grx      → codelens run
--     gO       → document symbols
--     <C-s>    → signature_help (insert mode)
--
--   NOT in defaults → set in LspAttach below:
--     gd       → definition
--     gD       → declaration
--     <leader>ch → toggle inlay hints
--
-- ─── nvim-lsp-file-operations ────────────────────────────────────────────────
--
--   Handles workspace/willRenameFiles + workspace/didRenameFiles LSP notifications.
--   This is what tells ts_ls to update imports when you rename a file.
--   Neovim core has no native vim.lsp.buf.rename_file — this fills that gap.
--   Works with: oil.nvim (via its own integration), neo-tree, nvim-tree.
--   NOTE: oil.nvim v2.3.0+ has its own willRenameFiles implementation.
--   Keep this plugin if you want didRenameFiles support too (oil only does will).

return {

  -- ── 1. mason.nvim ──────────────────────────────────────────────────────────
  {
    "mason-org/mason.nvim",
    lazy     = false,
    priority = 100,
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
  -- Passive data provider. Never require() it directly.
  -- Its lsp/*.lua files are merged automatically by Neovim.
  {
    "neovim/nvim-lspconfig",
    lazy     = false,
    priority = 90,
  },

  -- ── 3. mason-lspconfig ─────────────────────────────────────────────────────
  {
    "mason-org/mason-lspconfig.nvim",
    lazy     = false,
    priority = 80,
    dependencies = {
      "mason-org/mason.nvim",
      "neovim/nvim-lspconfig",   -- must be on runtimepath before mason-lspconfig runs
    },
    opts = {
      ensure_installed = {
        "lua_ls",
        "ts_ls",
        "html",
        "cssls",
        "tailwindcss",
        "graphql",
        "rust_analyzer",
        "clangd",
        "jsonls",
        "yamlls",
        "bashls",
        "marksman",
      },

      -- Default: true. Calls vim.lsp.enable() for every server installed by Mason.
      -- You never need to call vim.lsp.enable() yourself for these.
      -- Exclude servers managed by dedicated plugins (e.g. rustaceanvim for rust):
      --   automatic_enable = { exclude = { "rust_analyzer" } }
      automatic_enable = true,
    },
  },

  -- ── 4. lazydev.nvim ────────────────────────────────────────────────────────
  -- Dynamically configures lua_ls workspace libraries for Neovim config editing.
  -- Better than the static workspace.library approach in lsp/lua_ls.lua because
  -- it only loads type libraries for plugins you actually require() in open files.
  -- IMPORTANT: remove the workspace.library setting from lsp/lua_ls.lua if you
  -- use this — they conflict and lazydev wins more gracefully.
  {
    "folke/lazydev.nvim",
    ft   = "lua",    -- only loads on lua files, zero cost otherwise
    opts = {
      library = {
        -- Load luvit types when vim.uv is used (async I/O)
        { path = "${3rd}/luv/library", words = { "vim%.uv" } },
      },
    },
  },

  -- ── 5. nvim-lsp-file-operations ────────────────────────────────────────────
  -- Notifies LSP servers when files are renamed/moved so they can update imports.
  -- Fills the gap: Neovim core has no vim.lsp.buf.rename_file.
  -- Works with oil.nvim, neo-tree, nvim-tree, triptych.
  {
    "antosha417/nvim-lsp-file-operations",
    dependencies = { "nvim-lua/plenary.nvim" },
    event        = "BufReadPost",
    config       = true,    -- calls require("lsp-file-operations").setup() with defaults
  },

  -- ── 6. tiny-inline-diagnostic.nvim ─────────────────────────────────────────
  -- Replaces Neovim's default virtual_text diagnostics with inline overlays
  -- that don't push code around. Actively maintained.
  -- MUST disable vim.diagnostic virtual_text after setup to avoid duplication.
  {
    "rachartier/tiny-inline-diagnostic.nvim",
    event    = "LspAttach",    -- no point loading before LSP runs
    priority = 1000,
    opts = {
      -- Preset options: "default", "modern", "minimal", "powerline",
      -- "ghost", "simple", "nonerdfont", "amongus"
      preset = "modern",
      options = {
        -- Show the source (which linter/LSP produced this diagnostic)
        show_source = {
          enabled   = true,
          if_many   = true,   -- only show source when there are multiple sources
        },
        -- Multilines: show full message when it wraps
        multilines = {
          enabled        = true,
          always_show    = false,   -- only expand on current line
        },
        -- Show all diagnostics on the line, not just the most severe
        multiple_diag_under_cursor = true,
        -- Show a count badge when there are multiple diagnostics on a line
        show_all_diags_on_cursorline = false,
        overflow = {
          mode = "wrap",   -- "wrap" | "none" | "oneline"
        },
      },
    },
    config = function(_, opts)
      require("tiny-inline-diagnostic").setup(opts)
      -- Disable Neovim's default virtual_text to avoid duplication.
      -- tiny-inline-diagnostic handles all diagnostic display.
      vim.diagnostic.config({ virtual_text = false })
    end,
  },

  -- ── 7. Global capabilities + LspAttach ────────────────────────────────────
  {
    "neovim/nvim-lspconfig",   -- deduped by lazy.nvim
    config = function()

      -- ── Global capabilities ─────────────────────────────────────────────────
      -- Sent to every LSP server at attach time. blink.cmp must be loaded first
      -- (it is, since it's lazy=false in completion.lua).
      vim.lsp.config("*", {
        capabilities = (function()
          local ok, blink = pcall(require, "blink.cmp")
          if ok then
            return blink.get_lsp_capabilities()
          end
          return vim.lsp.protocol.make_client_capabilities()
        end)(),
      })

      -- ── LspAttach ───────────────────────────────────────────────────────────
      -- Only map things NOT already in Neovim's default keymaps.
      -- K, grn, gra, grr, gri, grt, grx, gO, <C-s> are already mapped globally.
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

          -- gd: go to definition — NOT in Neovim defaults, use telescope picker
          map("gd", function()
            require("telescope.builtin").lsp_definitions()
          end, "Go to definition")

          -- gD: declaration — NOT in defaults
          map("gD", vim.lsp.buf.declaration, "Go to declaration")

          -- Inlay hints: enable by default if supported, with toggle keymap
          if client:supports_method("textDocument/inlayHint") then
            vim.lsp.inlay_hint.enable(true, { bufnr = event.buf })
            map("<leader>ch", function()
              local enabled = vim.lsp.inlay_hint.is_enabled({ bufnr = event.buf })
              vim.lsp.inlay_hint.enable(not enabled, { bufnr = event.buf })
            end, "Toggle inlay hints")
          end

          -- Code lens: auto-refresh if supported (grx to run is already default)
          if client:supports_method("textDocument/codeLens") then
            vim.lsp.codelens.refresh()
            vim.api.nvim_create_autocmd({ "BufEnter", "CursorHold", "InsertLeave" }, {
              buffer   = event.buf,
              callback = vim.lsp.codelens.refresh,
            })
          end

          -- Document highlight: glow all references to symbol under cursor
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
