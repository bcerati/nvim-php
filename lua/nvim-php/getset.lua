local popup = require("popup")
local utils = require("nvim-php.utils")

local M = {}
local data = {}

M.generateGetters = function()
  local bufnr = vim.api.nvim_get_current_buf();
  local properties = utils.getProperties(bufnr);
  local win_size = utils.getWindowSize();
  local rest_width = win_size["w"] - 70;
  local rest_height = win_size["h"] - (#properties + 5);

  local bufh = vim.api.nvim_create_buf(false, false);

  popup.create(bufh, {
    title = "Generate getters",
    borderchars = { "─", "│", "─", "│", "╭", "╮", "╯", "╰" },
    line = rest_height / 2,
    col = rest_width / 2,
    minwidth = 70,
    minheight = 10,
  })

  local content = {}
  for _, property in pairs(properties) do
    table.insert(content, property["name"] .. " : " .. property["types"])
  end

  data = properties
  vim.api.nvim_buf_set_lines(bufh, 0, #content, false, content)

  vim.api.nvim_buf_set_keymap(
      bufh,
      "n",
      "<CR>",
      ":lua require('nvim-php.getset').selectGenerationLine()<CR>",
      {}
  )
end

M.selectGenerationLine = function()
  local idx = vim.fn.line(".");
  local bufContent = vim.api.nvim_buf_get_lines(vim.api.nvim_get_current_buf(), 0, 4, false);

  local property_name = string.sub(bufContent[idx], 0, string.find(bufContent[idx], ":") - 2)

  for _, property in pairs(data) do
    if property.name == property_name then
      print('Generate for ' .. property.name .. '. It\'s type is ' .. property.types)
    end
  end
end

return M;
