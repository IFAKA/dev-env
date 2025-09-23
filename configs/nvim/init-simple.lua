-- Simplified Neovim Configuration
-- Avoids problematic plugins for initial setup

-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable",
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

-- Load lazy.nvim
require("lazy").setup({
  -- Essential plugins only
  {
    "folke/lazy.nvim",
    version = "*",
    lazy = false,
    priority = 1000,
  },
  
  -- LazyVim-style Dashboard using alpha-nvim
  {
    "goolord/alpha-nvim",
    event = "VimEnter",
    config = function()
      local alpha = require("alpha")
      local dashboard = require("alpha.themes.dashboard")
      
      -- Header
      dashboard.section.header.val = {
        "                                                              ",
        "    ███╗   ██╗███████╗██╗   ██╗██╗███╗   ███╗                 ",
        "    ████╗  ██║██╔════╝██║   ██║██║████╗ ████║                 ",
        "    ██╔██╗ ██║█████╗  ██║   ██║██║██╔████╔██║                 ",
        "    ██║╚██╗██║██╔══╝  ╚██╗ ██╔╝██║██║╚██╔╝██║                 ",
        "    ██║ ╚████║███████╗ ╚████╔╝ ██║██║ ╚═╝ ██║                 ",
        "    ╚═╝  ╚═══╝╚══════╝  ╚═══╝  ╚═╝╚═╝     ╚═╝                 ",
        "                                                              ",
        "              Universal Development Environment               ",
        "                                                              ",
      }
      
      -- Buttons
      dashboard.section.buttons.val = {
        dashboard.button("f", "📁 Find Files", ":Telescope find_files<CR>"),
        dashboard.button("g", "🔍 Live Grep", ":Telescope live_grep<CR>"),
        dashboard.button("b", "📋 Buffers", ":Telescope buffers<CR>"),
        dashboard.button("e", "📂 File Explorer", ":NvimTreeToggle<CR>"),
        dashboard.button("r", "📄 Recent Files", ":Telescope oldfiles<CR>"),
        dashboard.button("po", "📂 Open Project", ":terminal ~/dev-env/scripts/project-manager.sh open<CR>"),
        dashboard.button("pn", "🆕 Create New Project", ":terminal ~/dev-env/scripts/project-manager.sh create<CR>"),
        dashboard.button("pg", "🐙 List GitHub Projects", ":terminal ~/dev-env/scripts/project-manager.sh list-github<CR>"),
        dashboard.button("pl", "🦊 List GitLab Projects", ":terminal ~/dev-env/scripts/project-manager.sh list-gitlab<CR>"),
        dashboard.button("t", "💻 Terminal", ":ToggleTerm<CR>"),
        dashboard.button("lg", "📊 Lazygit", ":terminal lazygit<CR>"),
        dashboard.button("ai", "🤖 AI Assistant", ":terminal cursor chat<CR>"),
        dashboard.button("lc", "💡 LeetCode", ":terminal leetcode-cli<CR>"),
        dashboard.button("tk", "📝 Tasks", ":terminal task<CR>"),
        dashboard.button("sc", "🧹 Clean Cartridges", ":terminal ~/dev-env/scripts/sfcc-prophet.sh clean<CR>"),
        dashboard.button("su", "⬆️ Upload Cartridges", ":terminal ~/dev-env/scripts/sfcc-prophet.sh upload<CR>"),
        dashboard.button("sa", "🔄 Clean & Upload All", ":terminal ~/dev-env/scripts/sfcc-prophet.sh clean-upload<CR>"),
        dashboard.button("ss", "📊 SFCC Status", ":terminal ~/dev-env/scripts/sfcc-prophet.sh status<CR>"),
        dashboard.button("jp", "📓 Jupyter Connect", ":JupyterConnect<CR>"),
        dashboard.button("jr", "▶️ Jupyter Run", ":JupyterRunFile<CR>"),
        dashboard.button("repl", "🐍 Python REPL", ":IronRepl<CR>"),
        dashboard.button("plot", "📈 Run Plot", ":SnipRun<CR>"),
        dashboard.button("h", "❓ Help", ":Telescope help_tags<CR>"),
        dashboard.button("q", "🚪 Quit", ":qa!<CR>"),
        dashboard.button("u", "🔄 Update Plugins", ":Lazy sync<CR>"),
        dashboard.button("c", "🏥 Check Health", ":checkhealth<CR>"),
        dashboard.button("s", "⚙️ Settings", ":edit ~/.config/nvim/init.lua<CR>"),
      }
      
      -- Footer
      dashboard.section.footer.val = {
        "                                                              ",
        "  Press any key to execute action, or ESC to close dashboard. ",
        "                                                              ",
      }
      
      -- Setup alpha
      alpha.setup(dashboard.config)
    end,
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
        pickers = {
          find_files = {
            theme = "dropdown",
          },
          live_grep = {
            theme = "dropdown",
          },
          buffers = {
            theme = "dropdown",
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
      require("lsp-simple")
    end,
  },

  -- Terminal
  {
    "akinsho/toggleterm.nvim",
    version = "*",
    config = function()
      require("toggleterm").setup({
        size = 20,
        open_mapping = [[<c-\>]],
        direction = "horizontal",
        shell = vim.o.shell,
      })
    end,
  },

  -- Git signs
  {
    "lewis6991/gitsigns.nvim",
    config = function()
      require("gitsigns").setup()
    end,
  },

  -- Treesitter
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    config = function()
      require("nvim-treesitter.configs").setup({
        ensure_installed = { "lua", "javascript", "typescript", "html", "css", "python", "json" },
        highlight = {
          enable = true,
        },
        indent = {
          enable = true,
        },
      })
    end,
  },
})

-- Basic settings
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.expandtab = true
vim.opt.shiftwidth = 2
vim.opt.tabstop = 2
vim.opt.smartindent = true
vim.opt.wrap = false
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.hlsearch = false
vim.opt.incsearch = true
vim.opt.termguicolors = true
vim.opt.scrolloff = 8
vim.opt.signcolumn = "yes"
vim.opt.updatetime = 50
vim.opt.colorcolumn = "80"
vim.opt.undodir = os.getenv("HOME") .. "/.vim/undodir"
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
keymap("n", "<leader>d", ":Alpha<CR>", opts)

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

-- SFCC Prophet-like functionality
keymap("n", "<leader>sfcc-clean", ":terminal ./scripts/sfcc-prophet.sh clean<CR>", opts)
keymap("n", "<leader>sfcc-upload", ":terminal ./scripts/sfcc-prophet.sh upload<CR>", opts)
keymap("n", "<leader>sfcc-all", ":terminal ./scripts/sfcc-prophet.sh clean-upload<CR>", opts)
keymap("n", "<leader>sfcc-status", ":terminal ./scripts/sfcc-prophet.sh status<CR>", opts)
keymap("n", "<leader>sfcc-config", ":terminal ./scripts/sfcc-prophet.sh config<CR>", opts)

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

-- Colorscheme
vim.cmd("colorscheme default")