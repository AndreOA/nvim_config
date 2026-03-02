require "nvchad.mappings"

-- add yours here

local map = vim.keymap.set

map({ "v" }, "<leader>fm", function()
  require("conform").format { lsp_fallback = true, timeout_ms = 5000 }
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
