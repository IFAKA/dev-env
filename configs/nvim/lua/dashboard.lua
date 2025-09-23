-- Custom Neovim Dashboard
-- Similar to Lazygit's interface

local M = {}

-- Dashboard configuration
local config = {
  header = {
    "╔══════════════════════════════════════════════════════════════╗",
    "║                                                              ║",
    "║    ███╗   ██╗███████╗██╗   ██╗██╗███╗   ███╗                 ║",
    "║    ████╗  ██║██╔════╝██║   ██║██║████╗ ████║                 ║",
    "║    ██╔██╗ ██║█████╗  ██║   ██║██║██╔████╔██║                 ║",
    "║    ██║╚██╗██║██╔══╝  ╚██╗ ██╔╝██║██║╚██╔╝██║                 ║",
    "║    ██║ ╚████║███████╗ ╚████╔╝ ██║██║ ╚═╝ ██║                 ║",
    "║    ╚═╝  ╚═══╝╚══════╝  ╚═══╝  ╚═╝╚═╝     ╚═╝                 ║",
    "║                                                              ║",
    "║              Universal Development Environment               ║",
    "║                                                              ║",
    "╚══════════════════════════════════════════════════════════════╝",
  },
  sections = {
    {
      title = "🚀 Quick Start",
      items = {
        { key = "f", desc = "Find Files", action = ":Telescope find_files<CR>" },
        { key = "g", desc = "Live Grep", action = ":Telescope live_grep<CR>" },
        { key = "b", desc = "Buffers", action = ":Telescope buffers<CR>" },
        { key = "e", desc = "File Explorer", action = ":NvimTreeToggle<CR>" },
      }
    },
    {
      title = "📂 Project Management",
      items = {
        { key = "pg", desc = "List GitHub Projects", action = ":terminal ~/dev-env/scripts/project-manager.sh list-github<CR>" },
        { key = "pl", desc = "List GitLab Projects", action = ":terminal ~/dev-env/scripts/project-manager.sh list-gitlab<CR>" },
        { key = "po", desc = "Open Project", action = ":terminal ~/dev-env/scripts/project-manager.sh open<CR>" },
        { key = "pn", desc = "Create New Project", action = ":terminal ~/dev-env/scripts/project-manager.sh create<CR>" },
      }
    },
    {
      title = "📁 File Operations",
      items = {
        { key = "n", desc = "New File", action = ":enew<CR>" },
        { key = "o", desc = "Open File", action = ":Telescope find_files<CR>" },
        { key = "r", desc = "Recent Files", action = ":Telescope oldfiles<CR>" },
        { key = "s", desc = "Save File", action = ":w<CR>" },
      }
    },
    {
      title = "🔧 Development",
      items = {
        { key = "t", desc = "Terminal", action = ":ToggleTerm<CR>" },
        { key = "lg", desc = "Lazygit", action = ":terminal lazygit<CR>" },
        { key = "ai", desc = "AI Debug", action = ":terminal cursor debug<CR>" },
        { key = "lc", desc = "LeetCode", action = ":terminal leetcode-cli<CR>" },
      }
    },
    {
      title = "🛒 SFCC Development",
      items = {
        { key = "sc", desc = "Clean Cartridges", action = ":terminal ./scripts/sfcc-prophet.sh clean<CR>" },
        { key = "su", desc = "Upload Cartridges", action = ":terminal ./scripts/sfcc-prophet.sh upload<CR>" },
        { key = "sa", desc = "Clean & Upload All", action = ":terminal ./scripts/sfcc-prophet.sh clean-upload<CR>" },
        { key = "ss", desc = "SFCC Status", action = ":terminal ./scripts/sfcc-prophet.sh status<CR>" },
      }
    },
    {
      title = "🤖 AI & Data Science",
      items = {
        { key = "jp", desc = "Jupyter Connect", action = ":JupyterConnect<CR>" },
        { key = "jr", desc = "Jupyter Run", action = ":JupyterRunFile<CR>" },
        { key = "repl", desc = "Python REPL", action = ":IronRepl<CR>" },
        { key = "plot", desc = "Run Plot", action = ":SnipRun<CR>" },
      }
    },
    {
      title = "⚙️ System",
      items = {
        { key = "h", desc = "Help", action = ":help<CR>" },
        { key = "q", desc = "Quit", action = ":qa<CR>" },
        { key = "u", desc = "Update Plugins", action = ":Lazy update<CR>" },
        { key = "c", desc = "Check Health", action = ":checkhealth<CR>" },
      }
    }
  },
  footer = {
    "Press any key to start coding...",
    "",
    "💡 Tip: Use <leader> + key for quick actions",
    "🔧 <leader> = Space (default)",
  }
}

-- Create dashboard buffer
function M.create_dashboard()
  local buf = vim.api.nvim_create_buf(false, true)
  vim.api.nvim_buf_set_option(buf, "buftype", "nofile")
  vim.api.nvim_buf_set_option(buf, "bufhidden", "wipe")
  vim.api.nvim_buf_set_option(buf, "swapfile", false)
  vim.api.nvim_buf_set_option(buf, "filetype", "dashboard")
  
  local lines = {}
  
  -- Add header
  for _, line in ipairs(config.header) do
    table.insert(lines, line)
  end
  
  -- Add sections
  for _, section in ipairs(config.sections) do
    table.insert(lines, "")
    table.insert(lines, "  " .. section.title)
    table.insert(lines, "  " .. string.rep("─", 50))
    
    for _, item in ipairs(section.items) do
      local line = string.format("  %s  %s", item.key, item.desc)
      table.insert(lines, line)
    end
  end
  
  -- Add footer
  for _, line in ipairs(config.footer) do
    table.insert(lines, "")
    table.insert(lines, "  " .. line)
  end
  
  vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)
  
  -- Set key mappings
  for _, section in ipairs(config.sections) do
    for _, item in ipairs(section.items) do
      vim.api.nvim_buf_set_keymap(buf, "n", item.key, item.action, { silent = true, nowait = true })
    end
  end
  
  -- Add dashboard-specific keymaps
  vim.api.nvim_buf_set_keymap(buf, "n", "<leader>d", ":lua require('dashboard').show_dashboard()<CR>", { silent = true })
  vim.api.nvim_buf_set_keymap(buf, "n", "<Esc>", ":bdelete<CR>", { silent = true })
  
  -- Set buffer as current
  vim.api.nvim_set_current_buf(buf)
  
  -- Highlight groups
  vim.api.nvim_set_hl(0, "DashboardHeader", { fg = "#61afef", bold = true })
  vim.api.nvim_set_hl(0, "DashboardSection", { fg = "#e06c75", bold = true })
  vim.api.nvim_set_hl(0, "DashboardKey", { fg = "#98c379", bold = true })
  vim.api.nvim_set_hl(0, "DashboardDesc", { fg = "#abb2bf" })
  vim.api.nvim_set_hl(0, "DashboardFooter", { fg = "#56b6c2", italic = true })
  
  return buf
end

-- Show dashboard
function M.show_dashboard()
  -- Check if we're already in dashboard
  if vim.bo.filetype == "dashboard" then
    return
  end
  
  -- Create new dashboard
  M.create_dashboard()
end

-- Auto show dashboard on startup
function M.setup()
  -- Show dashboard when Neovim starts with no arguments
  if vim.fn.argc() == 0 then
    vim.api.nvim_create_autocmd("VimEnter", {
      callback = function()
        M.show_dashboard()
      end,
      once = true,
    })
  end
end

return M
