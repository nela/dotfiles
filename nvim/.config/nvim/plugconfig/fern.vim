" Disable netrw.
let g:loaded_netrw  = 1
let g:loaded_netrwPlugin = 1
let g:loaded_netrwSettings = 1
let g:loaded_netrwFileHandlers = 1

augroup my-fern-hijack
  autocmd!
  autocmd BufEnter * ++nested call s:hijack_directory()
augroup END

function! s:hijack_directory() abort
  let path = expand('%:p')
  if !isdirectory(path)
    return
  endif
  bwipeout %
  execute printf('Fern %s', fnameescape(path))
endfunction

let g:fern#drawer_width               = 35
let g:fern#default_hidden             = 1
let g:fern#disable_drawer_auto_quit   = 1
let g:fern#disable_viewer_hide_cursor = 1
let g:fern#disable_default_mappings   = 1

noremap <silent> <Leader>z :Fern . -drawer -reveal=% -toggle<CR><C-w>=
" noremap <silent> <Leader>. :Fern %:h -drawer<CR><C-w>=

function! s:init_fern() abort
  nmap <buffer><expr>
      \ <Plug>(fern-my-open-expand-collapse)
      \ fern#smart#leaf(
      \   "\<Plug>(fern-action-open:select)",
      \   "\<Plug>(fern-action-expand)",
      \   "\<Plug>(fern-action-collapse)",
      \ )
  nmap <buffer><nowait> l <Plug>(fern-my-open-expand-collapse)
  nmap <buffer> o <Plug>(fern-action-open:edit)
  nmap <buffer> H <Plug>(fern-action-open:split)
  nmap <buffer> V <Plug>(fern-action-open:vsplit)
  nmap <buffer> T <Plug>(fern-action-open:tabedit)
  nmap <buffer> R <Plug>(fern-action-rename)
	nmap <buffer> M <Plug>(fern-action-move)
	nmap <buffer> C <Plug>(fern-action-copy)
	nmap <buffer> P <Plug>(fern-action-new-path)
	nmap <buffer> N <Plug>(fern-action-new-file)
	nmap <buffer> D <Plug>(fern-action-new-dir)
	nmap <buffer> dd <Plug>(fern-action-trash)
  nmap <buffer> m <Plug>(fern-action-mark:toggle)
  nmap <buffer> d <Plug>(fern-action-remove)
  nmap <buffer> r <Plug>(fern-action-reload)
  nmap <buffer> cd <Plug>(fern-action-cd)
  nmap <buffer> I <Plug>(fern-action-hide-toggle)
  nmap <buffer> t <Plug>(fern-action-open:tabedit)
  nmap <buffer> <C-h> <C-w>h
  nmap <buffer> <C-l> <C-w>l
  nmap <buffer><nowait> < <Plug>(fern-action-leave)
  nmap <buffer><nowait> > <Plug>(fern-action-enter)
endfunction


augroup fern-custom
  autocmd! *
  autocmd FileType fern call s:init_fern()
augroup END
