require("nvchad.configs.lspconfig").defaults()

local servers = { "html", "cssls", "grammarly" }
vim.lsp.enable(servers)

-- read :h vim.lsp.config for changing options of lsp servers 


-- Neovim 0.11+ native LSP config (no lspconfig.setup required for these)
-- Uses:
--   vim.lsp.config({name}, opts)
--   vim.lsp.enable({name})

-- Diagnostics: replace deprecated vim.lsp.with(...) + vim.lsp.diagnostic.*
vim.diagnostic.config({
  virtual_text = true,
  -- add whatever else you want (signs, underline, severity_sort, etc.)
}) -- :contentReference[oaicite:1]{index=1}

-- RUBOCOP
vim.lsp.config("rubocop", {
  cmd = { "rubocop", "--lsp" },
  on_attach = on_attach,
  capabilities = capabilities,
  filetypes = { "ruby" },
  -- 0.11 uses root_markers (instead of lspconfig.util.root_pattern)
  root_markers = { "Gemfile", ".git" },
}) -- :contentReference[oaicite:2]{index=2}
vim.lsp.enable("rubocop") -- :contentReference[oaicite:3]{index=3}

-- GOPLS
vim.lsp.config("gopls", {
  cmd = { "gopls" },
  on_attach = on_attach,
  capabilities = capabilities,
  filetypes = { "go", "gomod", "gowork", "gotmpl" },
  root_markers = { "go.work", "go.mod", ".git" },
  settings = {
    gopls = {
      completeUnimported = true,
      usePlaceholders = true,
      analyses = { unusedparams = true },
    },
  },
}) -- :contentReference[oaicite:4]{index=4}
vim.lsp.enable("gopls") -- :contentReference[oaicite:5]{index=5}

-- SOLARGRAPH (bundle-aware cmd)
local function solargraph_cmd()
  local ret_code
  local jid = vim.fn.jobstart("bundle info solargraph", {
    on_exit = function(_, code) ret_code = code end,
  })
  vim.fn.jobwait({ jid }, 5000)

  if ret_code == 0 then
    return { "bundle", "exec", "solargraph", "stdio" }
  end
  return { "solargraph", "stdio" }
end

vim.lsp.config("solargraph", {
  cmd = solargraph_cmd(),
  on_attach = on_attach,
  capabilities = capabilities,
  filetypes = { "ruby" },
  root_markers = { "Gemfile", ".git" },

  -- lspconfig's "flags.debounce_text_changes" doesn't exist the same way here;
  -- keep debouncing via your own autocmds if you were relying on it.

  settings = {
    solargraph = {
      completion = true,
      autoformat = false,
      formatting = true,
      symbols = true,
      definitions = true,
      references = true,
      folding = true,
      highlights = true,
      diagnostics = true,
      rename = true,
      -- transport = 'external',
      -- externalServer = { host = 'localhost', port = '7658' },
    },
  },
}) -- :contentReference[oaicite:6]{index=6}
vim.lsp.enable("solargraph") -- :contentReference[oaicite:7]{index=7}

