function s:ClearQuickfixList()
  call setqflist([])
endfunction
nnoremap <Plug>ClearQuickFixList
      \ :<C-U>call <SID>ClearQuickFixList()<CR>
