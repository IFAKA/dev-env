-- Universal Neovim Configuration
-- Optimized for cross-device development

-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

-- Load lazy.nvim
require("lazy").setup({
  -- Essential plugins
  {
    "folke/lazy.nvim",
    version = "*",
    lazy = false,
    priority = 1000,
  },
  
  -- File explorer
  {
    "nvim-tree/nvim-tree.lua",
    version = "*",
    lazy = false,
    dependencies = {
      "nvim-tree/nvim-web-devicons",
    },
    config = function()
      require("nvim-tree").setup({
        view = {
          width = 30,
        },
        actions = {
          open_file = {
            quit_on_open = true,
          },
        },
      })
    end,
  },
  
  -- Fuzzy finder
  {
    "nvim-telescope/telescope.nvim",
    tag = "0.1.0",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-telescope/telescope-fzf-native.nvim",
    },
    config = function()
      require("telescope").setup({
        defaults = {
          mappings = {
            i = {
              ["<C-j>"] = "move_selection_next",
              ["<C-k>"] = "move_selection_previous",
            },
          },
        },
      })
    end,
  },
  
  -- LSP and completion
  {
    "neovim/nvim-lspconfig",
    dependencies = {
      "williamboman/mason.nvim",
      "williamboman/mason-lspconfig.nvim",
      "hrsh7th/nvim-cmp",
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-path",
      "L3MON4D3/LuaSnip",
      "saadparwaiz1/cmp_luasnip",
    },
    config = function()
      require("lsp")
    end,
  },
  
  -- Git integration
  {
    "lewis6991/gitsigns.nvim",
    config = function()
      require("gitsigns").setup()
    end,
  },
  
  -- Status line
  {
    "nvim-lualine/lualine.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      require("lualine").setup({
        options = {
          theme = "auto",
          component_separators = { left = "", right = "" },
          section_separators = { left = "", right = "" },
        },
      })
    end,
  },
  
  -- Treesitter for syntax highlighting
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    config = function()
      require("nvim-treesitter.configs").setup({
        ensure_installed = {
          "lua",
          "vim",
          "vimdoc",
          "query",
          "javascript",
          "typescript",
          "html",
          "css",
          "json",
          "yaml",
          "markdown",
          "bash",
          "python",
        },
        highlight = {
          enable = true,
        },
        indent = {
          enable = true,
        },
      })
    end,
  },
  
  -- Commenting
  {
    "numToStr/Comment.nvim",
    config = function()
      require("Comment").setup()
    end,
  },
  
  -- Auto pairs
  {
    "windwp/nvim-autopairs",
    config = function()
      require("nvim-autopairs").setup()
    end,
  },
  
  -- Terminal integration
  {
    "akinsho/toggleterm.nvim",
    version = "*",
    config = function()
      require("toggleterm").setup({
        size = 20,
        open_mapping = [[<c-\>]],
        direction = "horizontal",
      })
    end,
  },
  
  -- Jupyter integration
  {
    "jupyter-vim/jupyter-vim",
    ft = "python",
    config = function()
      -- Jupyter vim configuration
      vim.g.jupyter_mapkeys = 0
      vim.g.jupyter_auto_connect = 1
    end,
  },
  
  -- Python REPL integration
  {
    "hkupty/iron.nvim",
    config = function()
      require("iron.core").setup({
        config = {
          scratch_repl = {
            python = "python3",
          },
        },
        repl_open_cmd = {
          python = "python3",
          _DEFAULT = "python3",
        },
      })
    end,
  },
  
  -- Data visualization in Neovim
  {
    "kana/vim-textobj-user",
    dependencies = {
      "vim-scripts/ReplaceWithRegister",
    },
  },
  
  -- Plot visualization
  {
    "michaelb/sniprun",
    build = "bash install.sh",
    config = function()
      require("sniprun").setup({
        selected_interpreters = {"Python3_fifo"},
        repl_enable = {"Python3_fifo"},
        interpreter_options = {
          Python3_fifo = {
            interpreter = "python3",
          },
        },
      })
    end,
    cond = function()
      return vim.fn.executable("cargo") == 1
    end,
  },
  
  -- Image preview for plots
  {
    "3rd/image.nvim",
    dependencies = {
      "nvim-treesitter/nvim-treesitter",
    },
    config = function()
      require("image").setup({
        backend = "kitty",
        integrations = {
          markdown = {
            enabled = true,
            clear_in_insert_mode = false,
            download_remote_images = true,
            only_render_image_at_cursor = false,
            filetypes = { "markdown", "vimwiki" },
          },
        },
      })
    end,
  },
  
  -- Data table viewer
  {
    "stevearc/dressing.nvim",
    config = function()
      require("dressing").setup({
        input = {
          enabled = true,
          default_prompt = "Input:",
          win_options = {
            winblend = 0,
          },
        },
        select = {
          enabled = true,
          backend = { "telescope", "builtin" },
        },
      })
    end,
  },
})

-- Basic settings
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.tabstop = 2
vim.opt.shiftwidth = 2
vim.opt.expandtab = true
vim.opt.autoindent = true
vim.opt.smartindent = true
vim.opt.wrap = false
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.incsearch = true
vim.opt.hlsearch = true
vim.opt.mouse = "a"
vim.opt.clipboard = "unnamedplus"
vim.opt.undofile = true
vim.opt.backup = false
vim.opt.writebackup = false
vim.opt.swapfile = false

-- Key mappings
local keymap = vim.keymap.set
local opts = { noremap = true, silent = true }

-- Leader key
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- File operations
keymap("n", "<leader>e", ":NvimTreeToggle<CR>", opts)
keymap("n", "<leader>ff", ":Telescope find_files<CR>", opts)
keymap("n", "<leader>fg", ":Telescope live_grep<CR>", opts)
keymap("n", "<leader>fb", ":Telescope buffers<CR>", opts)
keymap("n", "<leader>fh", ":Telescope help_tags<CR>", opts)

-- Dashboard
keymap("n", "<leader>d", ":lua require('dashboard').show_dashboard()<CR>", opts)

-- Buffer navigation
keymap("n", "<C-h>", "<C-w>h", opts)
keymap("n", "<C-j>", "<C-w>j", opts)
keymap("n", "<C-k>", "<C-w>k", opts)
keymap("n", "<C-l>", "<C-w>l", opts)

-- Terminal
keymap("n", "<leader>t", ":ToggleTerm<CR>", opts)
keymap("t", "<Esc>", "<C-\\><C-n>", opts)

-- Git operations
keymap("n", "<leader>gs", ":Gitsigns stage_hunk<CR>", opts)
keymap("n", "<leader>gu", ":Gitsigns undo_stage_hunk<CR>", opts)
keymap("n", "<leader>gp", ":Gitsigns preview_hunk<CR>", opts)
keymap("n", "<leader>gb", ":Gitsigns blame_line<CR>", opts)

-- Development workflow
keymap("n", "<leader>su", ":terminal ~/dev-env/scripts/sfcc-upload.sh<CR>", opts)
keymap("n", "<leader>ai", ":terminal cursor debug \"Current file\"<CR>", opts)
keymap("n", "<leader>lg", ":terminal lazygit<CR>", opts)
keymap("n", "<leader>lc", ":terminal leetcode-cli<CR>", opts)
keymap("n", "<leader>tt", ":terminal timetrap t in \"Code\"<CR>", opts)

-- SFCC Prophet-like functionality
keymap("n", "<leader>sfcc-clean", ":terminal ./scripts/sfcc-prophet.sh clean<CR>", opts)
keymap("n", "<leader>sfcc-upload", ":terminal ./scripts/sfcc-prophet.sh upload<CR>", opts)
keymap("n", "<leader>sfcc-all", ":terminal ./scripts/sfcc-prophet.sh clean-upload<CR>", opts)
keymap("n", "<leader>sfcc-status", ":terminal ./scripts/sfcc-prophet.sh status<CR>", opts)
keymap("n", "<leader>sfcc-config", ":terminal ./scripts/sfcc-prophet.sh config<CR>", opts)

-- AI and Data Science workflow
keymap("n", "<leader>jupyter", ":terminal jupyter notebook<CR>", opts)
keymap("n", "<leader>python", ":terminal python %<CR>", opts)
keymap("n", "<leader>cursor", ":terminal cursor<CR>", opts)
keymap("n", "<leader>ai-chat", ":terminal cursor chat<CR>", opts)
keymap("n", "<leader>ai-gen", ":terminal cursor generate<CR>", opts)
keymap("n", "<leader>ai-debug", ":terminal cursor debug<CR>", opts)

-- Jupyter integration keymaps
keymap("n", "<leader>jp", ":JupyterConnect<CR>", opts)
keymap("n", "<leader>jr", ":JupyterRunFile<CR>", opts)
keymap("n", "<leader>jc", ":JupyterClear<CR>", opts)
keymap("n", "<leader>js", ":JupyterSendRange<CR>", opts)
keymap("v", "<leader>js", ":JupyterSendRange<CR>", opts)

-- Python REPL keymaps
keymap("n", "<leader>repl", ":IronRepl<CR>", opts)
keymap("n", "<leader>rs", ":IronSend<CR>", opts)
keymap("v", "<leader>rs", ":IronSend<CR>", opts)
keymap("n", "<leader>rr", ":IronRestart<CR>", opts)

-- Data visualization keymaps
keymap("n", "<leader>plot", ":SnipRun<CR>", opts)
keymap("v", "<leader>plot", ":SnipRun<CR>", opts)
keymap("n", "<leader>data", ":terminal python -c \"import pandas as pd; print('Pandas available')\"<CR>", opts)
keymap("n", "<leader>viz", ":terminal python -c \"import matplotlib.pyplot as plt; print('Matplotlib available')\"<CR>", opts)
keymap("n", "<leader>table", ":terminal python -c \"import pandas as pd; df = pd.read_csv('data.csv'); print(df.head())\"<CR>", opts)

-- Image preview keymaps
keymap("n", "<leader>img", ":Image<CR>", opts)
keymap("n", "<leader>img-close", ":ImageClose<CR>", opts)
keymap("n", "<leader>img-refresh", ":ImageRefresh<CR>", opts)

-- Mobile optimizations
if vim.fn.has("android") == 1 or vim.fn.has("ios") == 1 then
  -- Touch-friendly mappings
  keymap("n", "<leader>1", ":buffer 1<CR>", opts)
  keymap("n", "<leader>2", ":buffer 2<CR>", opts)
  keymap("n", "<leader>3", ":buffer 3<CR>", opts)
  keymap("n", "<leader>4", ":buffer 4<CR>", opts)
  keymap("n", "<leader>5", ":buffer 5<CR>", opts)
  
  -- Swipe gestures (if supported)
  keymap("n", "<SwipeLeft>", ":bnext<CR>", opts)
  keymap("n", "<SwipeRight>", ":bprev<CR>", opts)
end

-- Auto commands
vim.api.nvim_create_autocmd("FileType", {
  pattern = { "javascript", "typescript", "html", "css" },
  callback = function()
    vim.opt_local.tabstop = 2
    vim.opt_local.shiftwidth = 2
  end,
})

vim.api.nvim_create_autocmd("FileType", {
  pattern = { "python" },
  callback = function()
    vim.opt_local.tabstop = 4
    vim.opt_local.shiftwidth = 4
  end,
})

-- LSP configuration
require("lspconfig").ts_ls.setup({})
require("lspconfig").html.setup({})
require("lspconfig").cssls.setup({})
require("lspconfig").jsonls.setup({})
require("lspconfig").yamlls.setup({})

-- Colorscheme
vim.cmd("colorscheme default")

-- Custom Dashboard
local dashboard = require("dashboard")
dashboard.setup()

-- Show dashboard when opening Neovim with no arguments
vim.api.nvim_create_autocmd("VimEnter", {
  callback = function()
    if vim.fn.argc() == 0 then
      dashboard.show_dashboard()
    end
  end,
  once = true,
})

