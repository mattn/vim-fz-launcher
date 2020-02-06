let s:config_file = get(g:, 'fz_launcher_file', '~/.fz-launcher')

function! s:fz_callback(list, ctx)
  redraw!
  for l:item in a:ctx.items
    for l:found in filter(copy(a:list), 'v:val[0] ==# l:item')
      let l:cmd = l:found[1]
      if l:cmd =~# '^!'
        silent exe l:cmd
      else
        exe l:cmd
      endif
    endfor
  endfor
endfunction

function! s:fz_launcher() abort
  let l:file = fnamemodify(expand(s:config_file), ':p')
  let s:list = filereadable(file) ? filter(map(readfile(file), 'split(iconv(v:val, "utf-8", &encoding), "\\t\\+")'), 'len(v:val) > 0 && v:val[0]!~"^#"') : []
  let s:list += [['--edit-menu--', printf('split %s', s:config_file)]]
  call fz#run({'type': 'list', 'list': map(copy(s:list), 'v:val[0]'), 'accept': function('s:fz_callback', [s:list])})
endfunction

command -nargs=0 FzLauncher call s:fz_launcher()
nnoremap <plug>(fz-launcher) :<c-u>FzLauncher<cr>
