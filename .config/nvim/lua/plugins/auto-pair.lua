return {
  "windwp/nvim-autopairs",
  event = "InsertEnter", -- Carregar apenas quando entrar no modo de inserção
  config = function()
    require("nvim-autopairs").setup({
      check_ts = true, -- Ativar suporte para Treesitter
      disable_filetype = { "TelescopePrompt", "spectre_panel" }, -- Evitar conflitos
    })
  end,
}
