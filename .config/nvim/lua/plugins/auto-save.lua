return {
  "GlennMm/autosaver",
  ---@class AutosaveOptions
  ---@field excluded_filetypes table<string, boolean> List of filetypes to exclude from autosave
  ---@field autosave_function? fun() Custom function to handle autosavin
  opts = {
    excluded_filetypes = { markdown = true, gitcommit = true },
  },
  config = true,
}
