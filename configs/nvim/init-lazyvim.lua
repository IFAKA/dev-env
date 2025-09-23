-- LazyVim-based Essential Configuration
-- Stripped down to essentials with custom project management

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

-- Load LazyVim
require("lazy").setup({
  -- LazyVim core
  {
    "LazyVim/LazyVim",
    import = "lazyvim.plugins",
    opts = {
      colorscheme = "tokyonight",
      news = {
        lazyvim = true,
        neovim = true,
      },
    },
  },

  -- Essential plugins only
  {
    "LazyVim/LazyVim",
    import = "lazyvim.plugins.extras.coding.copilot",
  },
  {
    "LazyVim/LazyVim", 
    import = "lazyvim.plugins.extras.lang.typescript",
  },
  {
    "LazyVim/LazyVim",
    import = "lazyvim.plugins.extras.lang.python",
  },
  {
    "LazyVim/LazyVim",
    import = "lazyvim.plugins.extras.lang.json",
  },
  {
    "LazyVim/LazyVim",
    import = "lazyvim.plugins.extras.lang.yaml",
  },

  -- Custom project management
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
        dashboard.button("e", "📂 File Explorer", ":Neotree toggle<CR>"),
        dashboard.button("r", "📄 Recent Files", ":Telescope oldfiles<CR>"),
        dashboard.button("po", "📂 Open Project", ":terminal ~/dev-env/scripts/project-manager.sh open<CR>"),
        dashboard.button("pn", "🆕 Create New Project", ":terminal ~/dev-env/scripts/project-manager.sh create<CR>"),
        dashboard.button("pg", "🐙 List GitHub Projects", ":terminal ~/dev-env/scripts/project-manager.sh list-github<CR>"),
        dashboard.button("pl", "🦊 List GitLab Projects", ":terminal ~/dev-env/scripts/project-manager.sh list-gitlab<CR>"),
        dashboard.button("t", "💻 Terminal", ":terminal<CR>"),
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

  -- SFCC Prophet-like functionality
  {
    "nvim-lua/plenary.nvim",
    lazy = true,
  },
  {
    "nvim-telescope/telescope.nvim",
    cmd = "Telescope",
    keys = {
      { "<leader>,", "<cmd>Telescope buffers show_all_buffers=true<cr>", desc = "Switch Buffer" },
      { "<leader>/", "<cmd>Telescope live_grep<cr>", desc = "Find in Files (Grep)" },
      { "<leader>:", "<cmd>Telescope command_history<cr>", desc = "Command History" },
      { "<leader><space>", "<cmd>Telescope find_files<cr>", desc = "Find Files (Root Dir)" },
      { "<leader>fb", "<cmd>Telescope buffers<cr>", desc = "Buffers" },
      { "<leader>ff", "<cmd>Telescope find_files<cr>", desc = "Find Files (Root Dir)" },
      { "<leader>fF", "<cmd>Telescope find_files cwd=false<cr>", desc = "Find Files (cwd)" },
      { "<leader>fr", "<cmd>Telescope oldfiles<cr>", desc = "Recent" },
      { "<leader>fR", "<cmd>Telescope oldfiles cwd_only=true<cr>", desc = "Recent (cwd)" },
      { "<leader>gc", "<cmd>Telescope git_commits<cr>", desc = "Git Commits" },
      { "<leader>gs", "<cmd>Telescope git_status<cr>", desc = "Git Status" },
      { "<leader>sa", "<cmd>Telescope autocommands<cr>", desc = "Auto Commands" },
      { "<leader>sb", "<cmd>Telescope current_buffer_fuzzy_find<cr>", desc = "Buffer" },
      { "<leader>sc", "<cmd>Telescope command_history<cr>", desc = "Command History" },
      { "<leader>sC", "<cmd>Telescope commands<cr>", desc = "Commands" },
      { "<leader>sd", "<cmd>Telescope diagnostics<cr>", desc = "Diagnostics" },
      { "<leader>sD", "<cmd>Telescope diagnostics bufnr=0<cr>", desc = "Document Diagnostics" },
      { "<leader>sg", "<cmd>Telescope live_grep<cr>", desc = "Live Grep" },
      { "<leader>sG", "<cmd>Telescope live_grep cwd=false<cr>", desc = "Live Grep (Root Dir)" },
      { "<leader>sh", "<cmd>Telescope help_tags<cr>", desc = "Help Pages" },
      { "<leader>sH", "<cmd>Telescope highlights<cr>", desc = "Search Highlight Groups" },
      { "<leader>sk", "<cmd>Telescope keymaps<cr>", desc = "Key Maps" },
      { "<leader>sM", "<cmd>Telescope man_pages<cr>", desc = "Man Pages" },
      { "<leader>sm", "<cmd>Telescope marks<cr>", desc = "Jump to Mark" },
      { "<leader>so", "<cmd>Telescope vim_options<cr>", desc = "Options" },
      { "<leader>sR", "<cmd>Telescope resume<cr>", desc = "Resume" },
      { "<leader>sw", "<cmd>Telescope grep_string<cr>", desc = "Word (Root Dir)" },
      { "<leader>sW", "<cmd>Telescope grep_string cwd=false<cr>", desc = "Word (cwd)" },
      { "<leader>uC", "<cmd>Telescope colorscheme<cr>", desc = "Colorscheme with Preview" },
      { "<leader>ss", "<cmd>Telescope lsp_document_symbols<cr>", desc = "Goto Symbol" },
      { "<leader>sS", "<cmd>Telescope lsp_dynamic_workspace_symbols<cr>", desc = "Goto Symbol (Workspace)" },
    },
    opts = function()
      local actions = require("telescope.actions")
      return {
        defaults = {
          prompt_prefix = " ",
          selection_caret = " ",
          path_display = { "truncate" },
          sorting_strategy = "ascending",
          layout_config = {
            horizontal = {
              prompt_position = "top",
              preview_width = 0.55,
              results_width = 0.8,
            },
            vertical = {
              mirror = false,
            },
            width = 0.87,
            height = 0.80,
            preview_cutoff = 120,
          },
          mappings = {
            i = {
              ["<C-n>"] = actions.cycle_history_next,
              ["<C-p>"] = actions.cycle_history_prev,
              ["<C-j>"] = actions.move_selection_next,
              ["<C-k>"] = actions.move_selection_previous,
            },
            n = {
              ["q"] = actions.close,
            },
          },
        },
      }
    end,
  },
})

-- Custom keymaps for SFCC Prophet-like functionality
vim.keymap.set("n", "<leader>sfcc-clean", ":terminal ~/dev-env/scripts/sfcc-prophet.sh clean<CR>", { desc = "SFCC Clean Cartridges" })
vim.keymap.set("n", "<leader>sfcc-upload", ":terminal ~/dev-env/scripts/sfcc-prophet.sh upload<CR>", { desc = "SFCC Upload Cartridges" })
vim.keymap.set("n", "<leader>sfcc-all", ":terminal ~/dev-env/scripts/sfcc-prophet.sh clean-upload<CR>", { desc = "SFCC Clean & Upload All" })
vim.keymap.set("n", "<leader>sfcc-status", ":terminal ~/dev-env/scripts/sfcc-prophet.sh status<CR>", { desc = "SFCC Status" })
vim.keymap.set("n", "<leader>sfcc-config", ":terminal ~/dev-env/scripts/sfcc-prophet.sh config<CR>", { desc = "SFCC Config" })

-- Project management keymaps
vim.keymap.set("n", "<leader>po", ":terminal ~/dev-env/scripts/project-manager.sh open<CR>", { desc = "Open Project" })
vim.keymap.set("n", "<leader>pn", ":terminal ~/dev-env/scripts/project-manager.sh create<CR>", { desc = "Create New Project" })
vim.keymap.set("n", "<leader>pg", ":terminal ~/dev-env/scripts/project-manager.sh list-github<CR>", { desc = "List GitHub Projects" })
vim.keymap.set("n", "<leader>pl", ":terminal ~/dev-env/scripts/project-manager.sh list-gitlab<CR>", { desc = "List GitLab Projects" })

-- AI and development keymaps
vim.keymap.set("n", "<leader>ai", ":terminal cursor chat<CR>", { desc = "AI Assistant" })
vim.keymap.set("n", "<leader>lg", ":terminal lazygit<CR>", { desc = "Lazygit" })
vim.keymap.set("n", "<leader>lc", ":terminal leetcode-cli<CR>", { desc = "LeetCode" })
vim.keymap.set("n", "<leader>tk", ":terminal task<CR>", { desc = "Tasks" })

-- Dashboard keymap
vim.keymap.set("n", "<leader>d", ":Alpha<CR>", { desc = "Dashboard" })
