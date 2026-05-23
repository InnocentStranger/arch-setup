-- lua/plugins/git/diffview.lua

return {
  "dlyongemallo/diffview.nvim",
  version = "*",
  cmd = {
    "DiffviewOpen",
    "DiffviewClose",
    "DiffviewToggleFiles",
    "DiffviewFocusFiles",
    "DiffviewRefresh",
    "DiffviewFileHistory",
    "DiffviewDiffFiles",
  },
  opts = {},
}
