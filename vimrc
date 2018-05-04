"dein Scripts-----------------------------
if &compatible
  set nocompatible               " Be iMproved
endif

" Required:
set runtimepath+=/home/ahodgen/.vim/bundles/repos/github.com/Shougo/dein.vim

" Required:
if dein#load_state(expand('~/.vim/bundles'))
  call dein#begin(expand('~/.vim/bundles'))

  " Let dein manage dein
  " Required:
  call dein#add(expand('~/.vim/bundles/repos/github.com/Shougo/dein.vim'))

  " Code snippet suggestions
  call dein#add('Shougo/neocomplete.vim')
  call dein#add('Shougo/neosnippet.vim')
  call dein#add('Shougo/neosnippet-snippets')

  " Appearance
  call dein#add('vim-airline/vim-airline')
  call dein#add('vim-airline/vim-airline-themes')
  call dein#add('tomasr/molokai')

  " Syntax checking with various linters
  call dein#add('scrooloose/syntastic')

  " Indent highlighting
  call dein#add('Yggdroot/indentLine')

  " File finder
  call dein#add('ctrlpvim/ctrlp.vim')

  " Git wrapper
  call dein#add('tpope/vim-fugitive')

  " TOML
  call dein#add('cespare/vim-toml')

  " YAML folding
  call dein#add('digitalrounin/vim-yaml-folds')

  " Java
  if executable('javac')
    " call dein#add('artur-shaik/vim-javacomplete2')
  endif
  " Scala
  if executable('sbt')
    call dein#add('derekwyatt/vim-scala')
  endif

  " Markdown
  if executable('livedown')
    call dein#add('shime/vim-livedown')
  endif
  call dein#add('godlygeek/tabular')
  call dein#add('plasticboy/vim-markdown')

  " You can specify revision/branch/tag.
  " call dein#add('Shougo/vimshell', { 'rev': '3787e5' })

  if executable('go')
    call dein#add('fatih/vim-go')
    let g:go_metalinter_autosave = 1
    let g:go_fmt_command = "goimports"
  endif

  " Rust
  if executable('rustc')
    call dein#add('rust-lang/rust.vim')
    call dein#add('mattn/webapi-vim')
    call dein#add('racer-rust/vim-racer')
    " let g:rustfmt_autosave = 1
    let g:racer_cmd = "~/.cargo/bin/racer"
    let g:racer_experimental_completer = 1
  endif

  call dein#add('leafgarland/typescript-vim')

  " Required:
  call dein#end()
  call dein#save_state()
endif

" Required:
filetype plugin indent on
syntax enable

" Install not installed plugins on startup.
if dein#check_install()
   echom 'dein has found plugins to install'
   echom 'Would you like to continue?'
    while 1
        let choice = inputlist(['1. yes', '2. no', '3. quit'])
        if choice == 0 || choice > 3
            redraw!
            echohl WarningMsg
            echo 'Please enter a number between 1 and 3'
            echohl None
            continue
        elseif choice == 1
            call dein#install()
        elseif choice == 3
            quit!
        endif
        break
    endwhile
endif

"End dein Scripts-------------------------

set t_Co=256                    " Let vim use 256 colours

let mapleader = "," " Rebind <Leader> key

" bind Ctrl+<movement> keys to move around the windows, instead of using Ctrl+w + <movement>
map <c-j> <c-w>j
map <c-k> <c-w>k
map <c-l> <c-w>l
map <c-h> <c-w>h

" Colourscheme
colorscheme molokai

" File stuff
syntax on                   " Turn on syntax highlighting
filetype indent plugin on   " Turn on filetype detection and load the indent and plugin file
set synmaxcol=1000          " only highlight for the first n cols (lags on big files)

" Higlight current line and set <leader>c to toggle
hi CursorLine cterm=bold
hi CursorColumn cterm=bold ctermbg=darkmagenta guibg=darkmagenta
noremap <Leader>c :set cursorline!<CR>
noremap <Leader>C :set cursorcolumn!<CR>
set cursorline

set encoding=utf-8              " Set the default encoding

set number                      " show line numbers
set nowrap                      " don't automatically wrap on load

set history=700                 " Remember everything
set undolevels=700              " Remember everything

" Editing stuff
set tabstop=8                   " Set tabs to 8 char wide
set expandtab                   " Convert tabs to spaces
set shiftwidth=4                " Spaces used for (auto)indent
set softtabstop=4               " Number of spaces a tab counts for when doing editing (ie. when doing a <BS>)
set formatoptions+=lj           " Dont break long lines, and join comment lines

set bs=2                        " make backspace behave like normal again

set hlsearch                    " Highlight search results
set incsearch                   " Search for a pattern as it is typed
set ignorecase                  " Ignore case in search patterns
set smartcase                   " Override ignorecase if the pattern contains upper case letters

" Search for visually selected text
vnoremap // y/<C-R>"<CR>

" Bind nohl
noremap <C-n> :nohl<CR>
vnoremap <C-n> :nohl<CR>
inoremap <C-n> <ESC>:nohl<CR>

" Show trailing whitespace and tabs
highlight BadWhitespace ctermbg=red guibg=red
au BufRead,BufNewFile * match BadWhitespace /\s\+$/
highlight Tab ctermbg=blue guibg=blue
au BufRead,BufNewFile *.py match Tab /^\t\+/
" Highlight non-braking-space
au VimEnter,BufWinEnter * syn match ErrorMsg " "

" Editing commands
set pastetoggle=<F2>            " Press F2 before pasting to make pasting better

" Remap ESC
inoremap jk <ESC>
inoremap kj <ESC>

" Toggle spellchecker with F6 and F7
map <silent> <F6> <ESC>:setlocal spell spelllang=en_gb<CR>
map <silent> <F7> <ESC>:setlocal nospell<CR>

" Set ctrlp to use best availabe search program
if executable('rg')
  " Use ripgrep for speed
  set grepprg=rg\ --color=never

  " Use rg in CtrlP for listing files. Lightning fast and respects .gitignore
  let g:ctrlp_user_command = 'rg %s --files --color=never --glob ""'
  " rg is fast enough that CtrlP doesn't need to cache
  let g:ctrlp_use_caching = 0
endif

set wildignore+=*/.git/*,*/tmp/*,*.swp
let g:ctrlp_custom_ignore = { 'dir':  'vendor$\|node_modules$' }

" NeoComplete config
let g:acp_enableAtStartup = 0               " Disable AutoComplPop.
let g:neocomplete#enable_at_startup = 1     " Use neocomplete.
let g:neocomplete#enable_smart_case = 1     " Use smartcase.
let g:neocomplete#sources#syntax#min_keyword_length = 3 " Set minimum syntax keyword length.
let g:neocomplete#lock_buffer_name_pattern = '\*ku\*'

" syntastic config
let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_loc_list = 1
let g:syntastic_check_on_open = 1
let g:syntastic_check_on_wq = 0

" Enable omni completion.
autocmd FileType css setlocal omnifunc=csscomplete#CompleteCSS
autocmd FileType html,markdown setlocal omnifunc=htmlcomplete#CompleteTags
autocmd FileType javascript setlocal omnifunc=javascriptcomplete#CompleteJS
autocmd FileType python setlocal omnifunc=pythoncomplete#Complete
autocmd FileType xml setlocal omnifunc=xmlcomplete#CompleteTags

"" neosnippet key-mappings.
imap <C-k>     <Plug>(neosnippet_expand_or_jump)
smap <C-k>     <Plug>(neosnippet_expand_or_jump)
xmap <C-k>     <Plug>(neosnippet_expand_target)

" SuperTab like snippets behavior.
imap <expr><TAB> neosnippet#expandable_or_jumpable() ?
\ "\<Plug>(neosnippet_expand_or_jump)"
\: pumvisible() ? "\<C-n>" : "\<TAB>"
smap <expr><TAB> neosnippet#expandable_or_jumpable() ?
\ "\<Plug>(neosnippet_expand_or_jump)"
\: "\<TAB>"

" For snippet_complete marker.
if has('conceal')
  set conceallevel=2 concealcursor=i
endif

" Enable snipMate compatibility feature.
let g:neosnippet#enable_snipmate_compatibility = 1

" Tell Neosnippet about the other snippets
let g:neosnippet#snippets_directory='~/.vim/bundle/vim-snippets/snippets'

" airline config
set laststatus=2                            " Enable Airline by default
let g:airline_powerline_fonts = 1
let g:airline#extensions#tabline#enabled = 1
let g:airline_theme = 'powerlineish'

" Rust
au FileType rust nmap gd <Plug>(rust-def)
au FileType rust nmap gs <Plug>(rust-def-split)
au FileType rust nmap gx <Plug>(rust-def-vertical)
au FileType rust nmap <leader>gd <Plug>(rust-doc)

" " Latex
" if executable('pdflatex')
"   " TODO pdflatex -output-directory
"   if executable('chronic')
"     autocmd BufWritePost *.tex !chronic pdflatex -halt-on-error %
"   else
"     autocmd BufWritePost *.tex silent !pdflatex -halt-on-error % >/dev/null
"   endif
" endif

" Set for vim-racer, need to better understand
set hidden

" Java
if executable('javac')
  " autocmd FileType java setlocal omnifunc=javacomplete#Complete
  let g:syntastic_java_javac_config_file_enabled = 1
endif

" Work yaml.j2 Kubernetes template files
au BufNewFile,BufRead *.yaml.j2 set filetype=yaml
au BufNewFile,BufRead *.yml.j2 set filetype=yaml
