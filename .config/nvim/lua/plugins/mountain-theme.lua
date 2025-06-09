return {
  {
    "mountain-theme/vim",
    lazy = false,
    priority = 1000,
    config = function()
      vim.cmd("colorscheme mountain")
    end,
  }
}

