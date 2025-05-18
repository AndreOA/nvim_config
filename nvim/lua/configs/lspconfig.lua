require("nvchad.configs.lspconfig").defaults()

local lspconfig = require "lspconfig"

-- if you just want default config for the servers then put them in a table
local servers = { "grammarly"  }

for _, lsp in ipairs(servers) do
  lspconfig[lsp].setup {
    on_attach = on_attach,
    flags = {
      debounce_text_changes = 150,
    },
    capabilities = capabilities,
  }
end

-- 
-- lspconfig.pyright.setup { blabla}
--
-- rubocop configs

lspconfig.rubocop.setup{
  cmd = { "rubocop", "--lsp" },
  on_attach = on_attach,
  capabilities = capabilities,
  filetypes = {
    "ruby"
  },
  root_dir = lspconfig.util.root_pattern("Gemfile", ".git", ".")
}

-- Solargraph configs
local handlers = {
    ["textDocument/publishDiagnostics"] = vim.lsp.with(
        vim.lsp.diagnostic.on_publish_diagnostics, {
            virtual_text = true
        }
    )
}

-- golang configs
lspconfig.gopls.setup {
  cmd = { "gopls" },
  on_attach = on_attach,
  capabilities = capabilities,
  filetypes = {
    "go",
    "gomod",
    "gowork",
    "gotmpl"
  },
  root_dir = lspconfig.util.root_pattern("go.work", ".git", "go.mod"),
  settings = {
    gopls = {
      completeUnimported = true,
      usePlaceholders = true,
      analyses = {
        unusedparams = true,
      }
    }
  }

}



local solargraph_cmd = function()
  local ret_code = nil
  local jid = vim.fn.jobstart("bundle info solargraph", { on_exit = function(_, data) ret_code = data end })
  vim.fn.jobwait({ jid }, 5000)
  if ret_code == 0 then
    return { "bundle", "exec", "solargraph", "stdio" }
  end
  return { "solargraph", "stdio" }
end

lspconfig.solargraph.setup {
    cmd = solargraph_cmd(),
    on_attach = on_attach,
    filetypes = {
        "ruby"
    },
    flags = {
        debounce_text_changes = 150
    },
    root_dir = lspconfig.util.root_pattern("Gemfile", ".git", "."),
    capabilities = capabilities,
    handlers = handlers,
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
            -- Enable this when running with docker compose
            --transport = 'external',
            --externalServer = {
            --    host = 'localhost',
            --    port = '7658',
            --}
        }
    }
}
