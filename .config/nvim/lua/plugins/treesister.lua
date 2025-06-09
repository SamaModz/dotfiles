return {
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    config = function()
      require("nvim-treesitter.configs").setup({
        ensure_installed = { 
          "c", 
          "lua", 
          "vim", 
          "python",
          "typescript",
          "javascript",
          "html",
          "css",
          "scss",
          "json",
          "yaml",
        }, -- List of languages to install parsers for
        highlight = {
          enable = true,    -- Enable syntax highlighting
        },
        indent = {
          enable = true,    -- Enable indentation based on treesitter
        },
      })
    end,
  },
}
