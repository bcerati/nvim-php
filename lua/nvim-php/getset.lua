local M = {}

M.generateGetters = function()
  local bufnr = vim.api.nvim_get_current_buf();
  local properties = getProperties(bufnr);
  local win_size = getWindowSize();
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

  vim.api.nvim_buf_set_lines(bufh, 0, #content, false, content)

  vim.api.nvim_buf_set_keymap(
      bufh,
      "n",
      "<CR>",
      ":lua print(\"Hello World Boris!\")<CR>",
      {}
  )
end

return M;
