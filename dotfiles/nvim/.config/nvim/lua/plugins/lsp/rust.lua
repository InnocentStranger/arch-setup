return {
  {
    "mrcjkb/rustaceanvim",
    version = "^9", -- You were right!
    lazy = false, -- Must be false, it has its own lazy-loading mechanism based on filetype
    ft = { "rust" },
    config = function()
      -- Configure rustaceanvim settings globally
      vim.g.rustaceanvim = {
        server = {
          -- Your global LspAttach in attach.lua will handle standard keymaps and inlay hints.
          -- We only need to map rustaceanvim-specific tools here.
          on_attach = function(_, bufnr)
            local map = function(keys, func, desc)
              vim.keymap.set("n", keys, func, { buffer = bufnr, desc = "Rust: " .. desc })
            end

            -- rustaceanvim provides a custom UI for grouped code actions
            map("<leader>ca", function()
              vim.cmd.RustLsp("codeAction")
            end, "Code Action")

            -- Debugging and running targets
            map("<leader>rr", function()
              vim.cmd.RustLsp("runnables")
            end, "Runnables")
            map("<leader>rd", function()
              vim.cmd.RustLsp("debuggables")
            end, "Debuggables")
            map("<leader>rt", function()
              vim.cmd.RustLsp("testables")
            end, "Testables")

            -- Expand macros recursively
            map("<leader>rm", function()
              vim.cmd.RustLsp("expandMacro")
            end, "Expand Macro")
          end,
        },
      }
    end,
  },
}
