-- return {
  -- "neovim/nvim-lspconfig",  -- O plugin principal para configurar servidores LSP
  -- dependencies = {
    -- "williamboman/mason.nvim",         -- Gerenciador de LSPs, DAPs e Linters
    -- "williamboman/mason-lspconfig.nvim", -- Integra Mason ao LSPConfig
    -- "j-hui/fidget.nvim",               -- Exibe status do LSP
  -- },
  -- config = function()
    -- require("mason").setup()

    -- local lspconfig = require("lspconfig")

    -- -- Configuração padrão para LSPs
    -- local on_attach = function(client, bufnr)
      -- local bufmap = function(mode, lhs, rhs)
        -- vim.api.nvim_buf_set_keymap(bufnr, mode, lhs, rhs, { noremap = true, silent = true })
      -- end

      -- -- Atalhos úteis para navegação LSP
      -- bufmap("n", "gd", "<cmd>lua vim.lsp.buf.definition()<CR>") -- Ir para definição
      -- bufmap("n", "gr", "<cmd>lua vim.lsp.buf.references()<CR>") -- Referências
      -- bufmap("n", "K", "<cmd>lua vim.lsp.buf.hover()<CR>") -- Mostrar documentação
      -- bufmap("n", "<leader>rn", "<cmd>lua vim.lsp.buf.rename()<CR>") -- Renomear símbolo
      -- bufmap("n", "[d", "<cmd>lua vim.diagnostic.goto_prev()<CR>") -- Diagnóstico anterior
      -- bufmap("n", "]d", "<cmd>lua vim.diagnostic.goto_next()<CR>") -- Próximo diagnóstico
    -- end

    -- -- Configurando servidores LSP
    -- local servers = { "cssls" }

    -- for _, server in ipairs(servers) do
      -- lspconfig[server].setup({
        -- on_attach = on_attach,
      -- })
    -- end

    -- -- Exibir status do LSP
    -- require("fidget").setup({})
  -- end,
-- }



return {
  -- Configuração do LSP com lazy-lsp e lsp-zero para facilitar setup
  {
    "dundalek/lazy-lsp.nvim",
    dependencies = {
      "neovim/nvim-lspconfig",
      { "VonHeikemen/lsp-zero.nvim", branch = "v3.x" },
      "hrsh7th/nvim-cmp",
      "hrsh7th/cmp-nvim-lsp",
      "L3MON4D3/LuaSnip",
      "saadparwaiz1/cmp_luasnip",
      "rafamadriz/friendly-snippets",
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-path",
      "onsails/lspkind.nvim",
    },
    config = function()
      local lsp_zero = require("lsp-zero").preset({})

      -- Configuração do on_attach para keymaps do LSP
      lsp_zero.on_attach(function(client, bufnr)
        lsp_zero.default_keymaps({ buffer = bufnr })
      end)

      -- Configuração do lazy-lsp para iniciar os servidores automaticamente
      require("lazy-lsp").setup {}

      -- Configuração do nvim-cmp para autocompletar
      local cmp = require("cmp")
      local luasnip = require("luasnip")
      local lspkind = require("lspkind")

      -- Carregar snippets do friendly-snippets
      require("luasnip.loaders.from_vscode").lazy_load()

      cmp.setup({
        snippet = {
          expand = function(args)
            luasnip.lsp_expand(args.body)
          end,
        },
        mapping = cmp.mapping.preset.insert({
          ["<C-d>"] = cmp.mapping.scroll_docs(-4),
          ["<C-f>"] = cmp.mapping.scroll_docs(4),
          ["<C-Space>"] = cmp.mapping.complete(),
          ["<C-e>"] = cmp.mapping.close(),
          ["<CR>"] = cmp.mapping.confirm({ select = true }),
          -- Jump para próximo placeholder do snippet
          ["<DOWN>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_next_item()
            elseif luasnip.expand_or_jumpable() then
              luasnip.expand_or_jump()
            else
              fallback()
            end
          end, { "i", "s" }),
          -- Jump para placeholder anterior
          ["<S-Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_prev_item()
            elseif luasnip.jumpable(-1) then
              luasnip.jump(-1)
            else
              fallback()
            end
          end, { "i", "s" }),
        }),
        sources = cmp.config.sources({
          { name = "nvim_lsp" },
          { name = "luasnip" },
          { name = "buffer" },
          { name = "path" },
        }),
        formatting = {
          format = lspkind.cmp_format({ with_text = true, maxwidth = 50 }),
        },
        experimental = {
          ghost_text = true,
        },
      })

      -- Ajustes visuais para o menu de completions
      vim.cmd([[
        set completeopt=menuone,noinsert,noselect
        highlight! default link CmpItemKind CmpItemMenuDefault
      ]])
    end,
  },
}
