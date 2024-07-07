---@type MappingsTable
local M = {}
local map = vim.keymap.set

M.general = {
  n = {
    [";"] = { ":", "enter command mode", opts = { nowait = true } },

    --  format with conform
    ["<leader>fm"] = {
      function()
        require("conform").format()
      end,
      "formatting",
    }

  },
  v = {
    [">"] = { ">gv", "indent"},
  },
}
map("n", "<A-j>", ":m .+1<CR>==", {desc = "move line up"}) -- move line up(n)
map("n", "<A-k>", ":m .-2<CR>==", { desc = "move line down"}) -- move line down(n)
map("v", "<A-j>", ":m '>+1<CR>gv=gv", {desc = "move line up"}) -- move line up(v)
map("v", "<A-k>", ":m '<-2<CR>gv=gv", {desc = "move line down"}) -- move line down(v)

-- more keybinds!

return M
