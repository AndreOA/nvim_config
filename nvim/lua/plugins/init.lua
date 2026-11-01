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
  { -- Highlight, edit, and navigate code
    'nvim-treesitter/nvim-treesitter',
    opts = require "configs.overrides".treesitter,
    branch = 'main',
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
    version = "^19.0.0",
    enabled = true,
    lazy = false,
    opts = require "configs.overrides".codecompanion,
    dependencies = {
      { "nvim-lua/plenary.nvim", branch = "master" },
      {
        "nvim-treesitter/nvim-treesitter",
        lazy = false,
        build = ":TSUpdate",
      },
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
  {
  "ellisonleao/dotenv.nvim",
    lazy = false,
    -- I don't know why, but this is required or it won't load.
    opts = {},
  },
  {
    "hrsh7th/nvim-cmp",
    opts = function(_, opts)
      -- Safely handle string evaluation across different Neovim runtime versions
      opts.formatting = opts.formatting or {}
      local orig_format = opts.formatting.format

      opts.formatting.format = function(entry, vim_item)
        if orig_format then
          vim_item = orig_format(entry, vim_item)
        end

        -- Convert any non-string properties to string types
        vim_item.word = type(vim_item.word) == "string" and vim_item.word or tostring(vim_item.word or "")
        vim_item.abbr = type(vim_item.abbr) == "string" and vim_item.abbr or tostring(vim_item.abbr or "")
        vim_item.menu = type(vim_item.menu) == "string" and vim_item.menu or tostring(vim_item.menu or "")

        return vim_item
      end

      return opts
    end,
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
