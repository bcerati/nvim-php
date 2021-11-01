local popup = require("popup")
local ts_utils = require("nvim-treesitter.ts_utils")
local ts_parsers = require("nvim-treesitter.parsers")

local M = {};

local function getWindowSize()
  local ui_config = vim.api.nvim_list_uis()[1];

  return {
    w = ui_config.width,
    h = ui_config.height
  };
end

local function getProperties(bufnr)
  local parser = ts_parsers.get_parser(bufnr, "php")
  local tree = parser:parse()[1]

  local query = vim.treesitter.parse_query('php', [[
  (property_declaration
    (type_list) @types
    (property_element
      (variable_name
        (name) @property_name
      )
    )
  )
  ]])
  local root = tree:root();

  local properties = {}
  local i = 0;
  for _, captures in query:iter_matches(root, bufnr) do
    i = i + 1;
    properties[i] = {
      name = ts_utils.get_node_text(captures[2], bufnr)[1],
      types = ts_utils.get_node_text(captures[1], bufnr)[1]
    };
  end

  return properties;
end

M.onWindowResize = function()
  print("Helo World");
end

M.generateGetters = function ()
  local bufnr = vim.api.nvim_get_current_buf();
  local properties = getProperties(bufnr);
  local win_size = getWindowSize();

  local rest_width = win_size["w"] - 70;
  local rest_height = win_size["h"] - (#properties + 5);

  local bufh = vim.api.nvim_create_buf(false, true);

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
end

return M;
