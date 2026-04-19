return {
  "nvim-neo-tree/neo-tree.nvim",
  branch = "v3.x",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-tree/nvim-web-devicons", -- not strictly required, but recommended
    "MunifTanjim/nui.nvim",
    -- {"3rd/image.nvim", opts = {}}, -- Optional image support in preview window: See `# Preview Mode` for more information
  },
  lazy = false, -- neo-tree will lazily load itself
  opts = {
    -- fill any relevant options here
    vim.keymap.set("n", "<leader>e", ":Neotree toggle<CR>", { silent = true }),

    filesystem = {
      hijack_netrw_behavior = "disabled",       -- Prevent Neo-tree from auto-opening on directory launch
      filtered_items = {
        hide_gitignored = true,                 -- Optional: hide gitignored files
      },
      window = {
        mappings = {
          ["f"] = "noop",           -- Disable fuzzy filter (default is `f`)
          ["/"] = "noop"
        }
      },
    },
    -- Autocommand to close directory buffer and open a blank buffer on startup
    vim.api.nvim_create_autocmd("VimEnter", {
      callback = function()
        local arg = vim.fn.argv(0)
        if arg and vim.fn.isdirectory(arg) == 1 then
          vim.cmd("enew")           -- open a new, empty buffer
        end
      end,
    })
  },
}
