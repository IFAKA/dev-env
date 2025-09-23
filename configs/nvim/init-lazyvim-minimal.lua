-- LazyVim Minimal Configuration
-- Only essential plugins, no optional ones

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
  -- LazyVim core (essential only)
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

  -- Essential language support
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
  {
    "LazyVim/LazyVim",
    import = "lazyvim.plugins.extras.lang.markdown",
  },

  -- Essential UI features (must be imported first)
  {
    "LazyVim/LazyVim",
    import = "lazyvim.plugins.extras.ui.edgy",
  },

  -- Essential editor features
  {
    "LazyVim/LazyVim",
    import = "lazyvim.plugins.extras.editor.outline",
  },
  {
    "LazyVim/LazyVim",
    import = "lazyvim.plugins.extras.editor.illuminate",
  },

  -- Essential coding features
  {
    "LazyVim/LazyVim",
    import = "lazyvim.plugins.extras.coding.yanky",
  },

  -- Essential formatting and linting
  {
    "LazyVim/LazyVim",
    import = "lazyvim.plugins.extras.formatting.prettier",
  },
  {
    "LazyVim/LazyVim",
    import = "lazyvim.plugins.extras.linting.eslint",
  },

  -- Essential terminal and debugging
  {
    "LazyVim/LazyVim",
    import = "lazyvim.plugins.extras.dap.core",
  },
  {
    "LazyVim/LazyVim",
    import = "lazyvim.plugins.extras.dap.nlua",
  },

  -- Essential testing
  {
    "LazyVim/LazyVim",
    import = "lazyvim.plugins.extras.test.core",
  },

  -- Essential file management
  {
    "LazyVim/LazyVim",
    import = "lazyvim.plugins.extras.editor.neo-tree",
  },

  -- Disable optional plugins we don't need
  {
    "catppuccin/nvim",
    enabled = false,
  },
  {
    "stevearc/conform.nvim",
    enabled = false,
  },
  {
    "grug-far.nvim",
    enabled = false,
  },
  {
    "lazydev.nvim",
    enabled = false,
  },
  {
    "mfussenegger/nvim-lint",
    enabled = false,
  },
  {
    "windwp/nvim-ts-autotag",
    enabled = false,
  },
  {
    "persistence.nvim",
    enabled = false,
  },
  {
    "b0o/SchemaStore.nvim",
    enabled = false,
  },
  {
    "folke/todo-comments.nvim",
    enabled = false,
  },
  {
    "linux-cultist/venv-selector.nvim",
    enabled = false,
  },
})

-- Custom keymaps for SFCC Prophet-like functionality
vim.keymap.set("n", "<leader>sfcc-clean", ":terminal ~/dev-env/scripts/sfcc-prophet.sh clean<CR>", { desc = "SFCC Clean Cartridges" })
vim.keymap.set("n", "<leader>sfcc-upload", ":terminal ~/dev-env/scripts/sfcc-prophet.sh upload<CR>", { desc = "SFCC Upload Cartridges" })
vim.keymap.set("n", "<leader>sfcc-all", ":terminal ~/dev-env/scripts/sfcc-prophet.sh clean-upload<CR>", { desc = "SFCC Clean & Upload All" })
vim.keymap.set("n", "<leader>sfcc-status", ":terminal ~/dev-env/scripts/sfcc-prophet.sh status<CR>", { desc = "SFCC Status" })
vim.keymap.set("n", "<leader>sfcc-config", ":terminal ~/dev-env/scripts/sfcc-prophet.sh config<CR>", { desc = "SFCC Config" })

-- Project management keymaps
vim.keymap.set("n", "<leader>po", ":terminal cd " .. vim.fn.getcwd() .. " && ~/dev-env/scripts/project-manager.sh open<CR>", { desc = "Open Project" })
vim.keymap.set("n", "<leader>pn", ":terminal cd " .. vim.fn.getcwd() .. " && ~/dev-env/scripts/project-manager.sh create<CR>", { desc = "Create New Project" })
vim.keymap.set("n", "<leader>pg", ":terminal cd " .. vim.fn.getcwd() .. " && ~/dev-env/scripts/project-manager.sh list-github<CR>", { desc = "List GitHub Projects" })
vim.keymap.set("n", "<leader>pl", ":terminal cd " .. vim.fn.getcwd() .. " && ~/dev-env/scripts/project-manager.sh list-gitlab<CR>", { desc = "List GitLab Projects" })

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

-- Custom LSP configuration for additional language support
vim.api.nvim_create_autocmd("LspAttach", {
  group = vim.api.nvim_create_augroup("UserLspConfig", {}),
  callback = function(ev)
    local opts = { buffer = ev.buf }
    vim.keymap.set("n", "gD", vim.lsp.buf.declaration, opts)
    vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
    vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
    vim.keymap.set("n", "gi", vim.lsp.buf.implementation, opts)
    vim.keymap.set("n", "<C-k>", vim.lsp.buf.signature_help, opts)
    vim.keymap.set("n", "<leader>wa", vim.lsp.buf.add_workspace_folder, opts)
    vim.keymap.set("n", "<leader>wr", vim.lsp.buf.remove_workspace_folder, opts)
    vim.keymap.set("n", "<leader>wl", function()
      print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
    end, opts)
    vim.keymap.set("n", "<leader>D", vim.lsp.buf.type_definition, opts)
    vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts)
    vim.keymap.set({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, opts)
    vim.keymap.set("n", "<leader>f", function()
      vim.lsp.buf.format { async = true }
    end, opts)
  end,
})
