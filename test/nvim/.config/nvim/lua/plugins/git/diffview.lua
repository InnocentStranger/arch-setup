-- lua/plugins/git/diffview.lua

return {
  "dlyongemallo/diffview.nvim",
  lazy = true,
  cmd = {
    "DiffviewOpen",
    "DiffviewClose",
    "DiffviewToggleFiles",
    "DiffviewFocusFiles",
    "DiffviewRefresh",
    "DiffviewFileHistory",
  },
  opts = {},
}
