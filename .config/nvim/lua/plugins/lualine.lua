return {
  {
    'nvim-lualine/lualine.nvim',
    dependencies = { 'nvim-tree/nvim-web-devicons' }, -- Ícones opcionais
    config = function()
      require('lualine').setup({
        options = {
          theme = 'auto',
          transparent = true, -- Permite fundo transparente
          section_separators = { left = '', right = '' },
          component_separators = { left = '', right = '' },
        },
      })
    end,
  },
}

