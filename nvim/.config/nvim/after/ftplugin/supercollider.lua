vim.g.scnvim_postwin_size = math.floor((vim.api.nvim_win_get_width(0)*2)/5)


-- (winwidth(0)/5)*2
--
-- function! s:set_sclang_statusline()
--   setlocal stl=
--   setlocal stl+=%f
--   setlocal stl+=%=
--   setlocal stl+=%(%l,%c%)
--   setlocal stl+=\ \|
--   setlocal stl+=%24.24{scnvim#statusline#server_status()}
-- endfunction
--
-- augroup scnvim_stl
--   autocmd!
--   autocmd FileType supercollider call <SID>set_sclang_statusline()
-- augroup END
