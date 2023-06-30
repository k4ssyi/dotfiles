set t_Co=256
set tabstop=2
set shiftwidth=2
set softtabstop=2
set autoindent
set expandtab    "タブをスペースにする
"set noet          "タブをタブ文字にする
set backspace=2 " バックスペース有効化
set title " タイトルを表示
set number " 行番号の表示
set nobackup                   " バックアップを作らない
set noswapfile                 " swapファイルを作らない
set autoread                   " 他で書き換えられたら自動で読み直す
set laststatus=2               " 常にステータス行を表示
set encoding=utf-8
set fileencodings=utf-8,iso-2022-jp,euc-jp,sjis
set fileformats=unix,dos,mac
set hlsearch
set incsearch
set mouse=
" Escの2回押しでハイライト消去
nnoremap <Esc><Esc> :nohlsearch<CR><ESC>
" Escの代わりにjjでinsertから抜ける
inoremap <silent> jj <ESC>
" シンタックスハイライト
syntax on
" 行をまたいで移動
set whichwrap=b,s,h,l,<,>,[,],~
" clipboardにコピー
set clipboard=unnamed,unnamedplus
set guioptions+=a

" コマンドラインの履歴を10000件保存する
set history=10000
" 対応する括弧を強調表示
set showmatch

" バッファの移動をマッピング
set hidden

filetype off

set guifont=Nard\Droid\ Sans\ Mono\ for\ Powerline\ Font\ Complete\ 12
set encoding=utf-8

"vim-plug Scripts-----------------------------

call plug#begin("~/.config/nvim/plugged")
Plug 'Shougo/vimproc.vim', {'do' : 'make'}
Plug 'junegunn/fzf', {'dir': '~/.fzf','do': './install --all'}
Plug 'junegunn/fzf.vim'

Plug 'fatih/vim-go', { 'do': ':GoUpdateBinaries' }
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'github/copilot.vim'
Plug 'glidenote/memolist.vim'
Plug 'reireias/vim-cheatsheet'

Plug 'ryanoasis/vim-devicons'
Plug 'nathanaelkane/vim-indent-guides'

Plug 'tpope/vim-fugitive'
Plug 'airblade/vim-gitgutter'

" NeoVim限定のplugin
if has('nvim')
Plug 'neoclide/coc.nvim', { 'branch': 'release' }
Plug 'antoinemadec/coc-fzf', {'branch': 'release'}
Plug 'navarasu/onedark.nvim'

Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
endif
call plug#end()

"end vim-plug Scripts-------------------------

" NeoVim限定の設定
if has('nvim')
endif

let g:memolist_path = "~/.cache/memolist" " メモの保存先
let g:cheatsheet#cheat_file = '~/.cheatsheet.md' " cheatsheetの保存先
let g:airline#extensions#tabline#enabled = 1 "タブラインを有効化
let g:airline#extensions#tabline#buffer_idx_mode = 1 "バッファ番号を表示


" fzf settings
let $FZF_DEFAULT_OPTS="--layout=reverse"
let g:fzf_layout = {'up':'~90%', 'window': { 'width': 0.8, 'height': 0.8,'yoffset':0.5,'xoffset': 0.5, 'border': 'sharp' } }

let mapleader = "\<Space>"

" fzf
nnoremap <silent> <leader>f :Files<CR>
nnoremap <silent> <leader>g :GFiles<CR>
nnoremap <silent> <leader>G :GFiles?<CR>
nnoremap <silent> <leader>b :Buffers<CR>
nnoremap <silent> <leader>h :History<CR>
nnoremap <silent> <leader>r :Rg<CR>


"vim-go setting
"ref. https://github.com/hnakamur/vim-go-tutorial-ja/blob/master/README.md
let g:go_highlight_types = 1
let g:go_highlight_fields = 1
let g:go_highlight_functions = 1
let g:go_highlight_function_calls = 1
let g:go_metalinter_autosave = 1
let g:go_fmt_command = "gopls"
let g:go_gopls_gofumpt=1


" if you don't set this option, this color might not correct
set termguicolors

colorscheme onedark

" lightline
let g:lightline = {}
let g:lightline.colorscheme = 'onedark'

" or this line
let g:lightline = {'colorscheme' : 'onedark'}

nnoremap s <Nop>

" 画面分割
nnoremap ss :<C-u>sp<CR>
nnoremap sv :<C-u>vs<CR>
" 分割した画面間の移動
nnoremap sj <C-w>j
nnoremap sk <C-w>k
nnoremap sl <C-w>l
nnoremap sh <C-w>h
" 分割した画面を移動
nnoremap sJ <C-w>J
nnoremap sK <C-w>K
nnoremap sL <C-w>L
nnoremap sH <C-w>H

" for HHKB
nnoremap ; :

" for coc

" Remap keys for gotos
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)

" coc explorer
let g:coc_explorer_global_presets = {
\   '.vim': {
\     'root-uri': '~/.vim',
\   },
\   'cocConfig': {
\      'root-uri': '~/.config/coc',
\   },
\   'tab': {
\     'position': 'tab',
\     'quit-on-open': v:false,
\     'open-action-strategy': 'sourceWindow',
\   },
\   'tab:$': {
\     'position': 'tab:$',
\     'quit-on-open': v:true,
\   },
\   'floating': {
\     'position': 'floating',
\     'open-action-strategy': 'sourceWindow',
\   },
\   'floatingTop': {
\     'position': 'floating',
\     'floating-position': 'center-top',
\     'open-action-strategy': 'sourceWindow',
\   },
\   'floatingLeftside': {
\     'position': 'floating',
\     'floating-position': 'left-center',
\     'floating-width': 50,
\     'open-action-strategy': 'sourceWindow',
\   },
\   'floatingRightside': {
\     'position': 'floating',
\     'floating-position': 'right-center',
\     'floating-width': 50,
\     'open-action-strategy': 'sourceWindow',
\   },
\   'simplify': {
\     'file-child-template': '[selection | clip | 1] [indent][icon | 1] [filename omitCenter 1]'
\   },
\   'buffer': {
\     'sources': [{'name': 'buffer', 'expand': v:true}]
\   },
\ }

" スペースe でエクスプローラが立ち上がる
nmap <space>e <Cmd>CocCommand explorer<CR>


function! s:explorer_cur_dir()
  let node_info = CocAction('runCommand', 'explorer.getNodeInfo', 0)
  return fnamemodify(node_info['fullpath'], ':h')
endfunction

function! s:exec_cur_dir(cmd)
  let dir = s:explorer_cur_dir()
  execute 'cd ' . dir
  execute a:cmd
endfunction

function! s:init_explorer()
  set winblend=10

  " Integration with other plugins

  " CocList
  nmap <buffer> <Leader>fg <Cmd>call <SID>exec_cur_dir('CocList -I grep')<CR>
  nmap <buffer> <Leader>fG <Cmd>call <SID>exec_cur_dir('CocList -I grep -regex')<CR>
  nmap <buffer> <C-p> <Cmd>call <SID>exec_cur_dir('CocList files')<CR>

  " vim-floaterm
  nmap <buffer> <Leader>ft <Cmd>call <SID>exec_cur_dir('FloatermNew --wintype=floating')<CR>
endfunction

function! s:enter_explorer()
  if &filetype == 'coc-explorer'
    " statusline
    setl statusline=coc-explorer
  endif
endfunction

augroup CocExplorerCustom
  autocmd!
  autocmd BufEnter * call <SID>enter_explorer()
  autocmd FileType coc-explorer call <SID>init_explorer()
augroup END


" memolist
nnoremap <Leader>mn  :MemoNew<CR>
nnoremap <Leader>ml  :MemoList<CR>
nnoremap <Leader>mg  :MemoGrep<CR>

" airline
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#buffer_idx_mode = 1
let g:airline#extensions#tabline#buffer_idx_format = {
	\ '0': '0 ',
	\ '1': '1 ',
	\ '2': '2 ',
	\ '3': '3 ',
	\ '4': '4 ',
	\ '5': '5 ',
	\ '6': '6 ',
	\ '7': '7 ',
	\ '8': '8 ',
	\ '9': '9 '
	\}
nmap <C-p> <Plug>AirlineSelectPrevTab
nmap <C-n> <Plug>AirlineSelectNextTab

" gitgutter 
set updatetime=100
let g:gitgutter_highlight_lines = 1

" indent guide
let g:indent_guides_enable_on_vim_startup = 1

