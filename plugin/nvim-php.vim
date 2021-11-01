"fun! PHP()
"    " dont forget to remove this one....
"    lua for k in pairs(package.loaded) do if k:match("^nvim%-php") then package.loaded[k] = nil end end
"
"    lua require("nvim-php").generateGetters();
"endfun

let g:php_nvim_value = 42
let g:php_nvim_value2 = 666

nnoremap <leader>pg :lua require("nvim-php").generateGetters()<CR>

augroup PHP
    autocmd!
    autocmd VimResized * :lua require("nvim-php").onWindowResize()
augroup END

