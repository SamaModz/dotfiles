return {{
  "rcarriga/nvim-notify",
  config = function()
    local notify = require("notify")

    notify.setup({
      background_colour = "#000000",
      render = "minimal",
      stages = "fade_in_slide_out",
      timeout = 250,
    })
    vim.notify = notify
  end,
}}
