let g:scnvim_postwin_size = (winwidth(0)/5)*2

function! s:set_sclang_statusline()
  setlocal stl=
  setlocal stl+=%f
  setlocal stl+=%=
  setlocal stl+=%(%l,%c%)
  setlocal stl+=\ \|
  setlocal stl+=%24.24{scnvim#statusline#server_status()}
endfunction

augroup scnvim_stl
  autocmd!
  autocmd FileType supercollider call <SID>set_sclang_statusline()
augroup END
