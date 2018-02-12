" Vim settings
if has('vim_starting')
    set nocompatible

    set runtimepath+=~/.vim/bundle/neobundle.vim/
endif

" Neobundle
call neobundle#begin(expand('~/.vim/bundle'))

" Let NeoBundle manage NeoBundle
NeoBundleFetch 'Shougo/neobundle.vim'

NeoBundle 'Shougo/vimproc.vim', {
\ 'build' : {
\     'windows' : 'tools\\update-dll-mingw',
\     'cygwin' : 'make -f make_cygwin.mak',
\     'mac' : 'make',
\     'linux' : 'make',
\     'unix' : 'gmake',
\    },
\ }

NeoBundle 'bling/vim-airline'
NeoBundle 'vim-airline/vim-airline-themes'
NeoBundle 'flazz/vim-colorschemes'
NeoBundle 'tomasr/molokai'

NeoBundle 'scrooloose/syntastic'

NeoBundle 'Shougo/neosnippet.vim'
NeoBundle 'honza/vim-snippets'
" NeoBundle 'Shougo/neosnippet-snippets'
NeoBundle 'ant1441/neosnippet-snippets'
NeoBundle 'Shougo/neocomplete.vim'

NeoBundle 'kien/ctrlp.vim'

NeoBundle 'michaeljsmith/vim-indent-object'

NeoBundle 'tpope/vim-fugitive'

NeoBundle 'ngn/vim-select-by-syntax'

" Jinja2
NeoBundle 'Glench/Vim-Jinja2-Syntax'

" TOML
NeoBundle 'cespare/vim-toml'

" Coffeescript
NeoBundle 'kchmck/vim-coffee-script'

" Javascript
NeoBundle 'jelera/vim-javascript-syntax'

" Scala
NeoBundle 'derekwyatt/vim-scala'

if executable('go')
    NeoBundle 'fatih/vim-go'
    let g:go_metalinter_autosave = 1
endif

" Haskell
if executable('ghc')
    NeoBundle 'eagletmt/ghcmod-vim'
    NeoBundle 'eagletmt/neco-ghc'
endif

" Rust
if executable('rustc')
    NeoBundle 'rust-lang/rust.vim'
    NeoBundle 'mattn/webapi-vim'
    NeoBundle 'racer-rust/vim-racer'
    " let g:rustfmt_autosave = 1
    let g:racer_cmd = "~/.cargo/bin/racer"
    let g:racer_experimental_completer = 1
endif

if executable('ag')
    NeoBundle 'rking/ag.vim'
endif

if executable('pdflatex')
    NeoBundle 'lervag/vimtex'
    let g:Tex_DefaultTargetFormat = 'pdf'
    let g:vimtex_compiler_latexmk = {'callback' : 0}
endif

" NeoBundle 'jmcantrell/vim-virtualenv'

" Required:
call neobundle#end()
" If there are uninstalled bundles found on startup,
" this will conveniently prompt you to install them.
NeoBundleCheck

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
