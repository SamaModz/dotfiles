return {
  "xiyaowong/transparent.nvim",
  config = function()
    require("transparent").setup({
      extra_groups = {
        "Normal",           -- Janela principal
        "NormalNC",         -- Janela que não está em foco
        "NormalFloat",      -- Janelas flutuantes
        "FloatBorder",      -- Bordas de janelas flutuantes
        "VertSplit",        -- Divisões verticais
        "WinSeparator",     -- Separadores de janelas (Neovim 0.9+)
        "SignColumn",       -- Coluna de sinais (à esquerda do número da linha)
        "StatusLine",       -- Linha de status
        "StatusLineNC",     -- Linha de status inativa
        "TabLine",          -- Linha de abas
        "TabLineFill",      -- Espaço preenchido na linha de abas
        "TabLineSel",       -- Aba selecionada
        "LineNr",           -- Números das linhas
        "CursorLineNr",     -- Número da linha do cursor
        "FoldColumn",       -- Coluna de dobra
        "EndOfBuffer",      -- Tildes (~) no final do buffer

        -- Plugins
        "NvimTreeNormal",       -- NvimTree
        "NvimTreeNormalNC",
        "NvimTreeEndOfBuffer",
        "TelescopeNormal",      -- Telescope
        "TelescopeBorder",
        "TelescopePromptNormal",
        "TelescopePromptBorder",
        "TelescopeResultsNormal",
        "TelescopeResultsBorder",
        "TelescopePreviewNormal",
        "TelescopePreviewBorder",
        "FloatTitle",
        "WhichKeyFloat",        -- WhichKey
        "LspInfoBorder",        -- LSP Info window
        "CmpDocumentation",     -- nvim-cmp
        "CmpDocumentationBorder",
        "Pmenu",                -- Popup menu
        "PmenuSel",
        "PmenuSbar",
        "PmenuThumb",
        "NotifyBackground",     -- nvim-notify

        -- Dashboard / Startify / Alpha
        "AlphaNormal",
        "DashboardNormal",
        "StartifyNormal",

        -- Lazy & Mason
        "LazyNormal",
        "MasonNormal",

        -- Trouble plugin
        "TroubleNormal",
      },
      
      exclude_groups = {}, -- Exclua aqui se quiser preservar a opacidade de algo específico
    })
  end
}
