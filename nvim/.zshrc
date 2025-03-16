" Enable syntax highlighting
syntax on

" Line numbers and appearance
set rnu                   " Relative line numbers
set nu                    " Absolute line numbers
set numberwidth=1         " Minimize number column width
set nowrap                " Disable line wrapping
set mouse=a               " Enable mouse support

" Folding settings
set foldmethod=syntax     " Use syntax-based folding
set foldlevel=999         " Keep folds open by default

" Improved fold toggle mapping (keeps cursor in place)
inoremap <C-f> <Esc>:execute 'normal! za'<CR>a
nnoremap <C-f> :execute 'normal! za'<CR>

" Tab settings
set tabstop=2             " Set tab width

" General settings
set noswapfile            " Disable swap files
set shortmess+=I          " Ignore startup message
set autoread              " Auto-reload files changed outside Vim

" Enable filetype detection and plugins
filetype plugin on
filetype indent on

" Custom fold text display
function! MyFoldText()
    let l:first_line = getline(v:foldstart)   " Get first line of fold
    return l:first_line . ' … '               " Add ellipsis for clarity
endfunction
set foldtext=MyFoldText()

" Fix Shift+Tab behavior for tab switching
inoremap <Esc>[Z <Esc>:normal! gT<CR>i
nnoremap <Esc>[Z :normal! gT<CR>

" Timer for status line
let g:start_time = localtime()
function! CurrentTime()
    return strftime("%I:%M %p")  " Format time as HH:MM AM/PM
endfunction

function! UpdateTimer()
    let elapsed = localtime() - g:start_time
    let hours = elapsed / 3600
    let minutes = (elapsed % 3600) / 60
    let seconds = elapsed % 60
    return printf(" %02d:%02d:%02d", hours, minutes, seconds)
endfunction

" Update status line with timer
function! UpdateStatusLine(timer)
    let &statusline = ' %{UpdateTimer()}  %f  %=%F  %{CurrentTime()}  '
    redrawstatus
endfunction

" Auto-update status line every second
let g:timer = timer_start(1000, 'UpdateStatusLine', {'repeat': v:true})
set laststatus=2    " Ensure status line is always visible

