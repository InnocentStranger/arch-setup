-- lua/plugins/lint.lua
--
-- ─── WHY nvim-lint ────────────────────────────────────────────────────────────
--
-- nvim-lint is complementary to LSP — it runs external linter binaries and
-- feeds results into vim.diagnostic (same system LSP uses). Results appear
-- inline via tiny-inline-diagnostic automatically.
--
-- LSP vs linter — when to use which:
--   LSP diagnostics   → type errors, undefined variables, semantic issues
--   nvim-lint         → style rules, code quality, opinionated checks
--                       (eslint rules, ruff's pyflakes checks, shellcheck)
--
-- Some servers double up (e.g. ts_ls has some eslint-like checks). That's fine —
-- nvim-lint diagnostics and LSP diagnostics coexist in vim.diagnostic.
--
-- ─── TRIGGER STRATEGY ────────────────────────────────────────────────────────
--
-- BufWritePost  → lint on save (always correct, all linters support this)
-- BufReadPost   → lint when opening an existing file (so you see issues immediately)
-- InsertLeave   → lint after leaving insert mode (only works for linters that
--                 support stdin; file-based linters like golangci-lint need a save)
--
-- NOT TextChanged/TextChangedI — too aggressive, most linters spawn a process
-- per trigger. On every keystroke this would cause visible lag.
--
-- ─── eslint / eslint_d ────────────────────────────────────────────────────────
--
-- eslint_d errors in non-eslint projects are a known pain point.
-- nvim-lint has no built-in condition field. The solution is to check for
-- eslint config files before calling try_lint() for JS/TS filetypes.
--
-- eslint config file names (covers both legacy and flat config):
--   .eslintrc | .eslintrc.js | .eslintrc.cjs | .eslintrc.json | .eslintrc.yaml
--   .eslintrc.yml | eslint.config.js | eslint.config.mjs | eslint.config.cjs
--
-- eslint_d also checks package.json "eslintConfig" field, but vim.fs.find()
-- cannot check inside file contents — we only check for the config files.
-- In practice this covers nearly all projects.
--
-- ─── LINTER BINARIES ─────────────────────────────────────────────────────────
--
-- All linters here should be installed via mason-tool-installer.nvim or manually.
-- Add them to ensure_installed in your mason-tool-installer config:
--
--   eslint_d      → npm install -g eslint_d   or mason
--   ruff          → pip install ruff          or mason
--   shellcheck    → pacman -S shellcheck       or mason (Arch)
--   golangci-lint → go install ...             or mason
--   markdownlint  → npm install -g markdownlint-cli  or mason
--   yamllint      → pip install yamllint       or mason
--
-- Check which linters are active on the current buffer:
--   :lua print(vim.inspect(require("lint").linters_by_ft[vim.bo.filetype]))

return {
  {
    "mfussenegger/nvim-lint",
    event = { "BufReadPost", "BufWritePost" },

    keys = {
      -- Manual lint trigger — useful when you want to lint on demand
      {
        "<leader>cl",
        function()
          require("lint").try_lint()
        end,
        desc = "Lint current buffer",
      },
    },

    config = function()
      local lint = require("lint")

      -- ── Linters by filetype ───────────────────────────────────────────────
      lint.linters_by_ft = {
        -- JavaScript / TypeScript
        -- eslint_d is a long-running daemon — fast after first invocation.
        -- Reads from ./node_modules/.bin/eslint if present, falls back to PATH.
        javascript = { "eslint_d" },
        javascriptreact = { "eslint_d" },
        typescript = { "eslint_d" },
        typescriptreact = { "eslint_d" },
        vue = { "eslint_d" },

        -- Python
        -- ruff covers pyflakes, pycodestyle, isort checks, and more.
        -- Much faster than flake8/pylint. Reads pyproject.toml or ruff.toml.
        python = { "ruff" },

        -- Go
        -- golangci-lint is slow on first run (compiles analyzers).
        -- Only triggered on BufWritePost to avoid blocking UI.
        go = { "golangci-lint" },

        -- Shell
        bash = { "shellcheck" },
        sh = { "shellcheck" },

        -- Markdown
        markdown = { "markdownlint" },

        -- YAML
        yaml = { "yamllint" },
      }

      -- ── eslint_d: only run when an eslint config exists ───────────────────
      -- eslint_d throws a hard error (not a lint warning) when no config is
      -- found — this pollutes diagnostics in non-eslint projects.
      -- We wrap try_lint to skip eslint_d when no config file is found.
      local eslint_config_names = {
        ".eslintrc",
        ".eslintrc.js",
        ".eslintrc.cjs",
        ".eslintrc.json",
        ".eslintrc.yaml",
        ".eslintrc.yml",
        "eslint.config.js",
        "eslint.config.mjs",
        "eslint.config.cjs",
      }

      local function eslint_config_exists()
        return vim.fs.find(eslint_config_names, {
          upward = true,
          path = vim.fn.expand("%:p:h"),
          stop = vim.env.HOME,
          limit = 1,
        })[1] ~= nil
      end

      -- ── Autocmd trigger ───────────────────────────────────────────────────
      local group = vim.api.nvim_create_augroup("UserLint", { clear = true })

      vim.api.nvim_create_autocmd({ "BufReadPost", "BufWritePost", "InsertLeave" }, {
        group = group,
        callback = function()
          local ft = vim.bo.filetype

          -- For JS/TS filetypes, only run if eslint config exists
          local eslint_fts = {
            javascript = true,
            javascriptreact = true,
            typescript = true,
            typescriptreact = true,
            vue = true,
          }

          if eslint_fts[ft] and not eslint_config_exists() then
            return
          end

          -- try_lint() silently skips linters whose binary is not installed.
          -- No error is thrown for missing binaries.
          lint.try_lint()
        end,
      })
    end,
  },
}
