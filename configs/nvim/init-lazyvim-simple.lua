-- LazyVim-based Essential Configuration (Simplified)
-- Uses LazyVim's built-in components to avoid conflicts

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

-- Load LazyVim with minimal configuration
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

  -- Essential extras
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

-- Jupyter and data science keymaps
vim.keymap.set("n", "<leader>jp", ":JupyterConnect<CR>", { desc = "Jupyter Connect" })
vim.keymap.set("n", "<leader>jr", ":JupyterRunFile<CR>", { desc = "Jupyter Run" })
vim.keymap.set("n", "<leader>repl", ":IronRepl<CR>", { desc = "Python REPL" })
vim.keymap.set("n", "<leader>plot", ":SnipRun<CR>", { desc = "Run Plot" })

-- Dashboard keymap (using LazyVim's built-in dashboard)
vim.keymap.set("n", "<leader>d", ":LazyVim<CR>", { desc = "LazyVim Dashboard" })
