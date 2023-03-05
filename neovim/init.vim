lua require('plugins')

" Rebind <Leader> key
let mapleader = ","

" Revert neovim to yank a whole line
nnoremap Y Y

" bind Ctrl+<movement> keys to move around the windows, instead of using Ctrl+w + <movement>
map <c-j> <c-w>j
map <c-k> <c-w>k
map <c-l> <c-w>l
map <c-h> <c-w>h

" Disable Ex mode
nnoremap Q <nop>

" Colourscheme
" colorscheme molokai
" colorscheme dracula
colorscheme terafox

" Higlight current line and set <leader>c to toggle
hi CursorLine cterm=bold
hi CursorColumn cterm=bold ctermbg=darkmagenta guibg=darkmagenta
noremap <Leader>c :set cursorline!<CR>
noremap <Leader>C :set cursorcolumn!<CR>
set cursorline

" Highlight tab chars and trailing whitespace
"set listchars=eol:$,tab:▷⋅,space:·,multispace:-,lead:·,trail:·,extends:⇨,precedes:⇦,conceal:!,nbsp:Ø
set listchars=tab:▷⋅,trail:·,extends:⇨,precedes:⇦,nbsp:Ø
set list

set number                      " show line numbers
set nowrap                      " don't automatically wrap on load

" Editing stuff
set tabstop=8                   " Set tabs to 8 char wide [neovim default]
set expandtab                   " Convert tabs to spaces
set shiftwidth=4                " Spaces used for (auto)indent
set softtabstop=4               " Number of spaces a tab counts for when doing editing (ie. when doing a <BS>)

" Search
set hlsearch                    " Highlight search results [neovim default]
set incsearch                   " Search for a pattern as it is typed [neovim default]
set ignorecase                  " Ignore case in search patterns
set smartcase                   " Override ignorecase if the pattern contains upper case letters

" ignore these files when completing names and in explorer
set wildignore=.svn,CVS,.git,.hg,*.o,*.a,*.class,*.mo,*.la,*.so,*.obj,*.swp,*.jpg,*.png,*.xpm,*.gif

" Show trailing whitespace and tabs
highlight BadWhitespace ctermbg=red guibg=red
au BufRead,BufNewFile * match BadWhitespace /\s\+$/
" highlight Tab ctermbg=blue guibg=blue
" au BufRead,BufNewFile *.py match Tab /^\t\+/
" " Highlight non-braking-space
" au VimEnter,BufWinEnter * syn match ErrorMsg " "

" Remap ESC
inoremap jk <ESC>
inoremap kj <ESC>

" Spellchecker
set spelllang=en_gb

" nvim-cmp
set completeopt=menu,menuone,noselect

" Avoid showing extra messages when using completion
set shortmess+=c

" Will this conflict with nvim-cmp?
" set complete+=kspell

" Snippets
let g:snips_author = "adam"

:nnoremap <C-p> :Telescope find_files<cr>
:nnoremap "" :Telescope registers<cr>

if isdirectory(expand('~/.neovim-env'))
    let g:python3_host_prog = expand('~/.neovim-env/bin/python')
else
    lua vim.notify('failed to find NeoVim python virtualenv', vim.log.levels.ERROR)
    " python -m venv .neovim-env
endif
