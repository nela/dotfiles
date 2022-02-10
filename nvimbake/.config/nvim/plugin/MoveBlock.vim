xnoremap K :move '<-2<CR>gv=gv
xnoremap J :move '>+1<CR>gv=gv

function s:Visual()
  return visualmode() == 'V'
endfunction

function s:Move(address, at_limit)
  if s:Visual() && !a:at_limit
    execute "'<,'>move " . a:address
    call feedkeys('gv=', 'n')
  endif
  call feedkeys('gv', 'n')
endfunction

function s:MoveUp()
  let l:at_top=a:firstline == 1
  call s:Move("'<-2", l:at_top)
endfunction
xnoremap <Plug>MoveUp
      \ :<C-U>call <SID>MoveUp()<CR>

function s:MoveDown()
  let l:at_bottom=a:lastline == line('$')
  call s:Move("'>+1", l:at_bottom)
endfunction
xnoremap <Plug>MoveDown
      \ :<C-U>call <SID>MoveDown()<CR>
