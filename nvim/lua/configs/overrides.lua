local M = {}

M.treesitter = {
  ensure_installed = {
    "vim",
    "lua",
    "html",
    "css",
    "javascript",
    "typescript",
    "tsx",
    "c",
    "yaml",
    "markdown",
    "markdown_inline",
    "ruby",
    "go",
  },
  indent = {
    enable = true,
    -- disable = {
    --   "python"
    -- },
  },
}

M.codecompanion = {
  interactions = {
        --NOTE: Change the adapter as required
        chat = { adapter = "claude_code" },
        inline = { adapter = "claude_code" },
        agent = { adapter = "claude_code"}
  },
  adapters = {
      acp = {
        claude_code = function()
          return require("codecompanion.adapters").extend("claude_code", {
            env = {
              CLAUDE_CODE_OAUTH_TOKEN = os.getenv("CLAUDE_CODE_OAUTH_TOKEN"),
            },
          })
        end,
      },
    },
  prompt_library = {
    ["Fill YARD Tags"] = {
      strategy = "chat",
      description = "Add or complete YARD documentation tags for the selected code",
      opts = {
        modes = { "v" },
        short_name = "yard",
        auto_submit = true,
      },
      prompts = {
        {
          role = "system",
          content = "You are an expert Ruby developer. Your task is to add or complete YARD documentation tags to the provided Ruby code. Add @param, @return, @raise, @yield, @example and other relevant YARD tags as appropriate. Only output the documented code, no explanations.",
        },
        {
          role = "user",
          content = function(context)
            local code = require("codecompanion.helpers.actions").get_code(
              context.start_line,
              context.end_line
            )
            return "Add YARD documentation tags to the following Ruby code:\n\n```ruby\n" .. code .. "\n```"
          end,
        },
      },
    },
  },
}

M.mason = {
  ensure_installed = {
    -- lua stuff
    "lua-language-server",
    "stylua",

    -- web dev stuff
    "css-lsp",
    "html-lsp",
    "typescript-language-server",
    "deno",
    "prettier",

    -- c/cpp stuff
    "clangd",
    "clang-format",

    -- shell stuff
    "shfmt",

    -- golang
    "gopls",
  },
}

-- git support in nvimtree
M.nvimtree = {
  git = {
    enable = true,
  },

  renderer = {
    highlight_git = true,
    icons = {
      show = {
        git = true,
      },
    },
  },
}

return M
