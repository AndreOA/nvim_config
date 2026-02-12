return {
  {
    "stevearc/conform.nvim",
    -- event = 'BufWritePre', -- uncomment for format on save
    opts = require "configs.conform",
  },

  -- These are some examples, uncomment them if you want to see them work!
  {
    "neovim/nvim-lspconfig",
    config = function()
      require "configs.lspconfig"
    end,
  },

  -- override plugin configs
  {
    "williamboman/mason.nvim",
    opts = require "configs.overrides".mason
  },
  {
    "nvim-treesitter/nvim-treesitter",
    opts = function(_, opts)
      -- Force Treesitter to use clang instead of GCC 15
      require("nvim-treesitter.install").compilers = { "zig" }

      -- Keep your existing ensure_installed list
      opts.ensure_installed = vim.tbl_extend("force", opts.ensure_installed or {}, {
        "yaml",
        "lua",
      })
    end,
    lazy = false,
    enabled = true,
    build = ':TSUpdate'
  },
  {
    "nvim-tree/nvim-tree.lua",
    opts = require "configs.overrides".nvimtree
  },
  {
    "ray-x/go.nvim",
    dependencies = {  -- optional packages
      "ray-x/guihua.lua",
      "neovim/nvim-lspconfig",
      "nvim-treesitter/nvim-treesitter",
    },
    config = function()
      require("go").setup()
    end,
    event = {"CmdlineEnter"},
    ft = {"go", 'gomod'},
    build = ':lua require("go.install").update_all_sync()' -- if you need to install/update all binaries
  },
  {
    "olimorris/codecompanion.nvim",
    version = "^18.0.0",
    enabled = true,
    lazy = false,
    opts = require "configs.overrides".codecompanion,
    dependencies = {
      { "nvim-lua/plenary.nvim", branch = "master" },
      "nvim-treesitter/nvim-treesitter",
    },
  },
  {
    "MeanderingProgrammer/render-markdown.nvim",
    ft = { "markdown", "codecompanion" }
  },
  {
    "HakonHarnes/img-clip.nvim",
    opts = {
      filetypes = {
        codecompanion = {
          prompt_for_file_name = false,
          template = "[Image]($FILE_PATH)",
          use_absolute_path = true,
        },
      },
    },
  },

  -- test new blink
  -- { import = "nvchad.blink.lazyspec" },

  -- {
  -- 	"nvim-treesitter/nvim-treesitter",
  -- 	opts = {
  -- 		ensure_installed = {
  -- 			"vim", "lua", "vimdoc",
  --      "html", "css"
  -- 		},
  -- 	},
  -- },
}
