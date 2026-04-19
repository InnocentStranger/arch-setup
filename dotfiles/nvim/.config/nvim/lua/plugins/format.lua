return {
  "stevearc/conform.nvim",
  event = { "BufReadPre", "BufNewFile" },
  config = function()
    local conform = require("conform")

    conform.setup({
      formatters_by_ft = {
        lua = { "stylua" },
        javascript = { "prettierd" },
        typescript = { "prettierd" },
        javascriptreact = { "prettierd" },
        typescriptreact = { "prettierd" },
        css = { "prettierd" },
        yaml = { "prettierd" },
        markdown = { "prettierd" },
        graphql = { "prettierd" },
        java = { "google-java-format" },
        c = { "clang-format" },
        cpp = { "clang-format" },
        jsonc = { "prettierd" },
        json = { "prettierd" },
      },
      default_format_opts = {
        lsp_format = "fallback",
      },
      format_on_save = function()
        if vim.g.conform_disable then
          return
        end
        return {
          lsp_fallback = true,
          async = false,
          timeout_ms = 1000,
        }
      end,
    })

    -- Commands to enable/disable conform formatting
    vim.api.nvim_create_user_command("ConformEnable", function()
      vim.g.conform_disable = false
      vim.notify("Conform formatting enabled", vim.log.levels.INFO)
    end, {})

    vim.api.nvim_create_user_command("ConformDisable", function()
      vim.g.conform_disable = true
      vim.notify("Conform formatting disabled", vim.log.levels.INFO)
    end, {})
  end,
}
