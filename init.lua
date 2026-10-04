-- 1. General Vim Options
vim.opt.expandtab = true
vim.opt.tabstop = 2
vim.opt.softtabstop = 2
vim.opt.shiftwidth = 2

-- 2. Leader Keys (MUST be set before loading lazy.nvim)
vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

-- 3. Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = "https://github.com"
  local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({
      { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
      { out, "WarningMsg" },
      { "\nPress any key to exit..." },
    }, true, {})
    vim.fn.getchar()
    os.exit(1)
  end
end
vim.opt.rtp:prepend(lazypath)

-- 4. Setup plugins via lazy.nvim
require("lazy").setup({
  spec = {
    -- Colorscheme
    { "catppuccin/nvim", name = "catppuccin", priority = 1000 },

    -- Telescope
    {
      'nvim-telescope/telescope.nvim', 
      tag = '0.1.8', 
      dependencies = { 'nvim-lua/plenary.nvim' },
      config = function()
        require('telescope').setup({})
        local builtin = require('telescope.builtin')
        vim.keymap.set('n', '<leader>ff', builtin.find_files, { desc = 'Telescope find files' })
        vim.keymap.set('n', '<leader>fg', builtin.live_grep, { desc = 'Telescope live grep' })
        vim.keymap.set('n', '<leader>fb', builtin.buffers, { desc = 'Telescope buffers' })
      end
    },

    -- TreeSitter (Fixed to use safe initialization options)
    {
      'nvim-treesitter/nvim-treesitter',
      lazy = false,
      build = ':TSUpdate',
      opts = {
        ensure_installed = { "lua", "javascript" },
        highlight = { enable = true },
        indent = { enable = true },
      },
      config = function(_, opts)
        -- Safe check: only try to run setup if the module exists on disk
        local status, ts = pcall(require, "nvim-treesitter.configs")
        if status then
          ts.setup(opts)
        end
      end
    },
  },
  ui = { backdrop = 100 },
  install = { colorscheme = { "habamax" } },
  checker = { enabled = true },
})

-- 5. Finalize Theme Settings
require("catppuccin").setup()
vim.cmd.colorscheme "catppuccin"
