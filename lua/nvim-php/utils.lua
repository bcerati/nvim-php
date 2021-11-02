local ts_utils = require("nvim-treesitter.ts_utils")
local ts_parsers = require("nvim-treesitter.parsers")

local M = {}

M.getProperties = function(bufnr)
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

M.getWindowSize = function()
  local ui_config = vim.api.nvim_list_uis()[1];

  return {
    w = ui_config.width,
    h = ui_config.height
  };
end

return M;
