---@type MappingsTable
require "nvchad.mappings"
local map = vim.keymap.set

map({ "v" }, "<leader>fm", function()
  require("conform").format { lsp_fallback = true }
end, { desc = "format selected lines" })
map("v", ">", ">gv", {desc= "indent right"})
map("v", "<", "<gv", {desc= "indent left"})
map("n","<;>",":",{desc =  "enter command mode"})
map("n", "<A-j>", ":m .+1<CR>==", {desc = "move line up"}) -- move line up(n)
map("n", "<A-k>", ":m .-2<CR>==", { desc = "move line down"}) -- move line down(n)
map("v", "<A-j>", ":m '>+1<CR>gv=gv", {desc = "move line up"}) -- move line up(v)
map("v", "<A-k>", ":m '<-2<CR>gv=gv", {desc = "move line down"}) -- move line down(v)
-- more keybinds!

--golang keybinds

M.gonvim = {
  plugin = true,
  n = {
    ["<leader>gsj"] = {
      "<cmd> GoTagAdd json <CR>",
      "Add json struct tags"
    },
    ["<leader>gsy"] = {
      "<cmd> GoTagAdd yaml <CR>",
      "Add yaml struct tags"
    },
    ["<leader>gsi"] = {
      "<cmd> GoIfErr <CR>",
      "Add err handle boiler plater"
    }

  }
}

return M
