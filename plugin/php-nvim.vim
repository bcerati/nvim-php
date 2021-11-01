fun! PhpNvim()
    " dont forget to remove this one....
    lua for k in pairs(package.loaded) do if k:match("^php%-nvim") then package.loaded[k] = nil end end
    lua require("php-nvim").createFloatingWindow()
endfun

let g:php_nvim_value = 42
let g:php_nvim_value2 = 666

augroup PhpNvim
    autocmd!
    autocmd VimResized * :lua require("php-nvim").onResize()
augroup END

