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
-- nvim-cmp setup (Preserves NvChad defaults)
  {
    "hrsh7th/nvim-cmp",
    opts = function(_, opts)
      -- Optional: Set to false if you want to completely disable float documentation windows
      -- opts.documentation = false
      return opts
    end,
  },

  -- nvim-autopairs setup with safety guards
  {
    "windwp/nvim-autopairs",
    opts = {
      fast_wrap = {},
      disable_filetype = { "TelescopePrompt", "vim" },
    },
    config = function(_, opts)
      local npairs = require("nvim-autopairs")
      npairs.setup(opts)

      local cmp_autopairs = require("nvim-autopairs.completion.cmp")
      local cmp = require("cmp")

      cmp.event:on("confirm_done", function(event)
        -- Guard against missing or vim.NIL event payloads from Solargraph
        if not event or not event.entry or event.entry == vim.NIL then
          return
        end

        local completion_item = event.entry:get_completion_item()
        if not completion_item or completion_item == vim.NIL or type(completion_item) ~= "table" then
          return
        end

        local handler = cmp_autopairs.on_confirm_done()
        if handler then
          handler(event)
        end
      end)
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
