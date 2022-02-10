function! QuickfixToggle()
    for i in range(1, winnr('$'))
        let bnum = winbufnr(i)
        if getbufvar(bnum, '&buftype') == 'quickfix'
            cclose
            return
        endif
    endfor

    copen
endfunction

xnoremap <Plug>QuickfixToggle
      \ :<C-U>call <SID>QuickfixToggle()<CR>
