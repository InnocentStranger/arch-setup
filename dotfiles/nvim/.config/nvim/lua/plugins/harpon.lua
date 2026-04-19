return {
  "ThePrimeagen/harpoon",
  branch = "harpoon2",
  dependencies = { "nvim-lua/plenary.nvim" },
  config = function()
    local harpoon = require("harpoon")
    harpoon.setup({
      menu = {
        width = vim.api.nvim_get_option("columns") - 4,
      },
    })
    local map = vim.keymap.set
    map("n", "<leader>af", function() harpoon:list():add() end, { desc = "Harpoon Add File" })
    map("n", "<leader>om", function() harpoon.ui:toggle_quick_menu(harpoon:list()) end, { desc = "Harpoon Menu" })

    map("n", "<leader>h1", function() harpoon:list():select(1) end, { desc = "Harpoon File 1" })
    map("n", "<leader>h2", function() harpoon:list():select(2) end, { desc = "Harpoon File 2" })
    map("n", "<leader>h3", function() harpoon:list():select(3) end, { desc = "Harpoon File 3" })
    map("n", "<leader>h4", function() harpoon:list():select(4) end, { desc = "Harpoon File 4" })
  end
}
