-- LazyVim-style Dashboard using alpha-nvim
local M = {}

function M.setup()
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
    dashboard.button("", "", ""),
    dashboard.button("po", "📂 Open Project", ":terminal ~/dev-env/scripts/project-manager.sh open<CR>"),
    dashboard.button("pn", "🆕 Create New Project", ":terminal ~/dev-env/scripts/project-manager.sh create<CR>"),
    dashboard.button("pg", "🐙 List GitHub Projects", ":terminal ~/dev-env/scripts/project-manager.sh list-github<CR>"),
    dashboard.button("pl", "🦊 List GitLab Projects", ":terminal ~/dev-env/scripts/project-manager.sh list-gitlab<CR>"),
    dashboard.button("", "", ""),
    dashboard.button("t", "💻 Terminal", ":ToggleTerm<CR>"),
    dashboard.button("lg", "📊 Lazygit", ":terminal lazygit<CR>"),
    dashboard.button("ai", "🤖 AI Assistant", ":terminal cursor chat<CR>"),
    dashboard.button("lc", "💡 LeetCode", ":terminal leetcode-cli<CR>"),
    dashboard.button("tk", "📝 Tasks", ":terminal task<CR>"),
    dashboard.button("", "", ""),
    dashboard.button("sc", "🧹 Clean Cartridges", ":terminal ~/dev-env/scripts/sfcc-prophet.sh clean<CR>"),
    dashboard.button("su", "⬆️ Upload Cartridges", ":terminal ~/dev-env/scripts/sfcc-prophet.sh upload<CR>"),
    dashboard.button("sa", "🔄 Clean & Upload All", ":terminal ~/dev-env/scripts/sfcc-prophet.sh clean-upload<CR>"),
    dashboard.button("ss", "📊 SFCC Status", ":terminal ~/dev-env/scripts/sfcc-prophet.sh status<CR>"),
    dashboard.button("", "", ""),
    dashboard.button("jp", "📓 Jupyter Connect", ":JupyterConnect<CR>"),
    dashboard.button("jr", "▶️ Jupyter Run", ":JupyterRunFile<CR>"),
    dashboard.button("repl", "🐍 Python REPL", ":IronRepl<CR>"),
    dashboard.button("plot", "📈 Run Plot", ":SnipRun<CR>"),
    dashboard.button("", "", ""),
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
end

function M.show_dashboard()
  vim.cmd("Alpha")
end

return M