local lspconfig = require("lspconfig")
local nvchad_on_attach = require("nvchad.configs.lspconfig").on_attach
local capabilities = require("cmp_nvim_lsp").default_capabilities()
-- 1. Align position encodings across RuboCop and Solargraph
capabilities.offsetEncoding = { "utf-16" }
capabilities.general = capabilities.general or {}
capabilities.general.positionEncodings = { "utf-16" }

-- 2. Restrict markup to plain structures
capabilities.textDocument.completion.completionItem.documentationFormat = { "markdown", "plaintext" }
capabilities.textDocument.completion.snippetSupport = false

local servers = { "html", "cssls" }
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
  cmd = { "bundle", "exec", "rubocop", "--lsp" },
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
  -- Check if Gemfile exists and contains solargraph, or if bundle exec solargraph runs cleanly
  local has_gemfile = vim.fn.filereadable(vim.fn.getcwd() .. "/Gemfile") == 1
  if has_gemfile then
    -- Fast, synchronous check to see if solargraph is available in the current Bundle
    local check = vim.fn.system("bundle exec solargraph --version 2>/dev/null")
    if vim.v.shell_error == 0 then
      return { "bundle", "exec", "solargraph", "stdio" }
    end
  end

  -- Fall back to global solargraph executable
  return { "solargraph", "stdio" }
end




-- 1. Align position encodings across RuboCop and Solargraph
capabilities.offsetEncoding = { "utf-16" }
capabilities.general = capabilities.general or {}
capabilities.general.positionEncodings = { "utf-16" }

-- 2. Restrict markup to plain structures
capabilities.textDocument.completion.completionItem.documentationFormat = { "markdown", "plaintext" }
capabilities.textDocument.completion.snippetSupport = false

-- 3. Configure Solargraph with custom completion sanitizer
vim.lsp.config("solargraph", {
  cmd = { "bundle", "exec", "solargraph", "stdio" },
  on_attach = nvchad_on_attach,
  capabilities = capabilities,
  filetypes = { "ruby" },
  root_markers = { "Gemfile", ".git" },
  handlers = {
    ["textDocument/completion"] = function(err, result, ctx, config)
      if not err and result then
        local items = result.items or result
        if type(items) == "table" then
          for _, item in ipairs(items) do
            if type(item) == "table" then
              -- Ensure string types across all cmp-matched properties
              if item.label and type(item.label) ~= "string" then
                item.label = tostring(item.label or "")
              end
              if item.insertText and type(item.insertText) ~= "string" then
                item.insertText = tostring(item.insertText or "")
              end
              if item.filterText and type(item.filterText) ~= "string" then
                item.filterText = tostring(item.filterText or "")
              end
              if item.sortText and type(item.sortText) ~= "string" then
                item.sortText = tostring(item.sortText or "")
              end

              -- Normalize nested documentation objects
              if item.documentation then
                if type(item.documentation) == "table" then
                  item.documentation = item.documentation.value or tostring(item.documentation)
                elseif type(item.documentation) ~= "string" then
                  item.documentation = tostring(item.documentation)
                end
              end
            end
          end
        end
      end
      return vim.lsp.handlers["textDocument/completion"](err, result, ctx, config)
    end,
  },
  init_options = {
    formatting = true,
  },
  settings = {
    solargraph = {
      completion = true,
      diagnostics = true,
      hover = true,
    },
  },
})

vim.lsp.enable("solargraph")
