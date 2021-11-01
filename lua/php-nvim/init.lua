local function getWindowSize()
  local ui_config = vim.api.nvim_list_uis()[1];

  local win_width = ui_config.width;
  local win_height = ui_config.height;

  return {
    w = win_width,
    h = win_height
  };
end

local function onResize()
  local win_size = getWindowSize();

  print(win_size["w"], win_size["h"]);
end


local function createFloatingWindow()
  local win_size = getWindowSize();

  -- print('Print window size', win_width, win_height)

  local rest_width = win_size["w"] - 70;
  local rest_height = win_size["h"] - 20;

  print("w ", win_size["w"])
  local bufh = vim.api.nvim_create_buf(false, true);

  vim.api.nvim_open_win(bufh, true, {
    relative = "editor",
    width = 70,
    height = 20,
    col = rest_width / 2,
    row = rest_height / 2 ,
  })

  content = {
    "first line",
    "second line",
    "third line",
    "fourth line",
    "fifth line",
  }

  vim.api.nvim_buf_set_lines(bufh, 0, #content, false, content)


  --print(vim.g["php_nvim_value"])
  --print(vim.g["php_nvim_value2"])
end

return {
  createFloatingWindow = createFloatingWindow,
  onResize = onResize
}
