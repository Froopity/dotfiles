let mapleader = ' '

" Line numbers
set number
set relativenumber

" Searches ignore case unless a capital letter is present
set ignorecase
set smartcase
set hlsearch
set incsearch

" Highlight current line
set cursorline

" Keep lines of context above/below cursor when scrolling
set scrolloff=10

" Show tab characters and trailing spaces
set list
set listchars=tab:>\ ,trail:-,nbsp:+

" Break long lines on word boundaries, not mid-word
set linebreak

" Tabs as 2 spaces
set tabstop=2
set shiftwidth=2
set expandtab

" Show dialog when exiting without saving
set confirm

set splitbelow
set splitright

" Use jk to exit insert mode
inoremap jk <Esc>

" Unbind cmd-line window to stop accidental invocation. Use :<C-f> to open.
nnoremap q: <Nop>

" Use alt-j/k to navigate QuickFix menu
nnoremap <A-j> :cnext<CR>
nnoremap <A-k> :cprevious<CR>

" Enter empty lines without switching to insert mode
nnoremap <CR> o<Esc>
nnoremap <S-CR> m`O<Esc>``
autocmd FileType qf nnoremap <buffer> <CR> <CR>

" Select the last pasted text
nnoremap gp '[v`]

" Set cwd to current file
nnoremap <leader>gd :cd %:h<CR>

" Actions on entire buffer
nnoremap <leader>ya mqggyG'q
nnoremap <leader>da gg"_dG

" Clear search highlights
nnoremap <leader><Esc> :nohlsearch<CR>
