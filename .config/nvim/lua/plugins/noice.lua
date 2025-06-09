return {{
  "folke/noice.nvim",
  event = "VeryLazy",
  dependencies = {
    "MunifTanjim/nui.nvim",
    "rcarriga/nvim-notify",
  },
  max_length = 5,
  opts = {
    lsp = {
      progress = {
        enabled = true,
      },
      signature = {
        enabled = true,
      },
      message = {
        enabled = true,
      },
    },
    messages = {
      enabled = true,
      view = "notify", -- redireciona mensagens para notify
      view_error = "notify",
      view_warn = "notify",
      view_history = "messages",
      view_search = "virtualtext",
    },
    notify = {
      enabled = true,
    },
    presets = {
      bottom_search = true,
      command_palette = true,
      long_message_to_split = true,
      inc_rename = false,
      lsp_doc_border = false,
    },
  },
}
}
