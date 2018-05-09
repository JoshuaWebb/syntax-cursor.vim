" NOTE: There's a hate triangle between
"       CursorLine, Error, and Empty Lines;
"       when CursorLine has a bg, Error is borked
"       on the current line, when CursorLine has
"       no bg (cleared) then CharUnderCursor is
"       invisible on empty lines
let s:match_id = 1524891851
function! s:Highlight_Char_Under_Cursor()
  silent! call matchdelete(s:match_id)
  if pumvisible() || (&t_Co < 8 && !has("gui_running"))
    return
  endif
  let c_lnum = line('.')
  let c_col = col('.')

  call matchaddpos('CharUnderCursor', [[c_lnum, c_col]], 11, s:match_id)
endfunction

function! s:No_Highlight_Char_Under_Cursor()
  silent! call matchdelete(s:match_id)
endfunction

let s:visible_cursor = "\<Esc>[?25h"
let s:hidden_cursor = ''
augroup cursor_highlight
  autocmd!
  autocmd InsertEnter * call s:No_Highlight_Char_Under_Cursor()
  " hack to turn the cursor fully invisible
  " when in Normal mode, this lets us implement
  " the cursor purely using the background colour.
  " * Doesn't work when you exit insert mode via
  " <C-c>
  autocmd VimEnter * let &t_ve=s:hidden_cursor
  autocmd VimLeave * let &t_ve=s:visible_cursor
  autocmd InsertEnter * let &t_ve=s:visible_cursor
  autocmd InsertLeave * let &t_ve=s:hidden_cursor
  autocmd CmdLineEnter * let &t_ve=s:visible_cursor
  autocmd CmdLineLeave * let &t_ve=s:hidden_cursor
  autocmd CursorMoved,InsertLeave,WinEnter * call s:Highlight_Char_Under_Cursor()

  " hack to make cursor visible on <C-z>
  " and invisible again when we return
  nnoremap <silent> <C-z> :let &t_ve="\033[?25h"<CR><C-z>:let &t_ve=''<CR>
augroup END

" Set IBeam shape in insert mode
let &t_SI = "\<Esc>[6 q"
" Underline shape in replace mode
let &t_SR = "\<Esc>[4 q"
" Set IBeam shape in normal mode
" (closest thing to invisible that still works
" in the command line)
"     let &t_EI = "\<Esc>[?25h"
" doesn't seem to work, presumably it is being
" overridden by something.. &v_te(?)
let &t_EI = "\<Esc>[6 q"
