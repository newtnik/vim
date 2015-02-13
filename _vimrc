""" see also 
" https://github.com/derekwyatt/vim-config/blob/master/vimrc
" https://bitbucket.org/sjl/dotfiles/src/tip/vim/vimrc
" github.com/sashahart/.vim/blob/master/vimrc

noremap Q <Nop>
set nocompatible    " Must be first. Use Vim settings, rather then Vi settings (much better!).

" lcd C:\temp       " stop doing this. it screws up loading of files from command line
set viminfo+=n$VIM\\viminfo

" ********************  autocommands ******************** "

" maximize 
" au GUIEnter * simalt ~x

" this takes a long time when loading many files 
if !exists("autocommands_loaded")
  let autocommands_loaded = 1
  autocmd FileChangedShell *
     \ echohl WarningMsg |
     \ echo "File has been changed outside of vim." |
     \ echohl None
endif
 
" When editing a file, always jump to the last known cursor position.
" Don't do it when the position is invalid or when inside an event handler
" (happens when dropping a file on gvim).
" Also don't do it when the mark is in the first line, that is the default
" position when opening a file.
autocmd BufReadPost * silent!
    \ if line("'\"") > 1 && line("'\"") <= line("$") |
    \   exe "normal! g`\"" |
    \ endif
 
autocmd BufEnter * silent! :lcd %:p:h   " autochdir, for older vims

"" set autochdir                       " for modern vims. 
                                       " at some point (_vimrc rev 1.12) this setting started breaking my 
                                       " ability to load files like so: gvim dir/dir/file.c

" treat other archives as zip
autocmd BufRead,BufNewFile *.jar,*.war,*.ear,*.sar,*.rar set filetype=zip
autocmd BufNewFile,BufRead *.gy  setf groovy

" Let highlighting changes show up immediately after leaving insert
autocmd InsertLeave * redraw!

" ********************  general ******************** "
" highlight current word, don't jump and don't add to jump list 
nnoremap * *``


set nospell             " annoying for code, usefull for other things
set encoding=utf-8      " Set default encoding to UTF-8
set guifont=Courier_new " show Cyrillic! 
set backspace=indent,eol,start " allow backspacing over everything in insert mode
set hidden             " Hide buffers rather than unloading it
set history=200        " How many entries may be stored in : and / histories
set visualbell         " flash the screen 
set clipboard=unnamed  " get yank to work with system clipboard
set linebreak        " break lines
let &showbreak='\ '  " Precede continued screen lines
filetype indent on
filetype plugin on   " load filetype plugins
syntax on            " syntax highlighting on
set synmaxcol=300    " only search 300 chars per line when determining syntax
set cindent          " for C coding
set nojoinspaces     " see also gJ to join with no space
set autoindent
" set copyindent       " use the same chars that the old line used
set expandtab        " use spaces instead of tab
set tabstop=2        " # of spaces to use in place of tab
set shiftwidth=2     " Number of spaces to use for each step of (auto)indent
set showmatch         " show bracket match 
set matchtime=1       " brief 
set nobackup
set nowritebackup
set diffopt+=vertical,context:10
set tw=0              " do not wrap lines 

" ********************  sessions ******************** "
" set ssop=buffers,folds,globals,options,resize,tabpages,winsize,localoptions "leave out curdir and sesdir to store absolute file paths 

" ********************  viminfo ******************** "
 " Store marks for 100 files, but don't store registers
"set viminfo='100,<0
"set viminfo-=h " Retain search highlights
 
" ********************  search/grep/tags ******************** "
" for :find
set path=.,,$SRC_PATH1\\**,$SRC_PATH2\\**,$WORKDIR\\**

" set noignorecase     " NEVER ignore case for searches  -- don't forget about IBM p1s1
set ignorecase

set incsearch        " perform incremental search
set hlsearch         " highlight search matches, use 'nohls' to unhighlight
set nowrapscan       " turn off search wrapping 
set sua=.c,.h,.java,.xml,.js " suffixes added during 'gf' search  

set grepprg=grep\ -nH\ $*
" for grep output 
" These don't work. why??
" map <silent> <Leader>f :cnext<CR>
" map <silent> <Leader>b :cprev<CR>
nnoremap <silent> <F4> :copen<CR>

" set tags=$WORKDIR/tags;./tags;/,tags;/
"" set tags=$WORKDIR/tags,./tags;/
set tags=$WORKDIR/tags,./tags
set complete=.,t,w,b,u  " ,i  " put tags at top of list 
" set completeopt=menuone,preview
set tagstack
"""""""""" cscope 
" load matches into quickfix window 
set csqf=s-,g-,d-,c-,t-,e-,f-,i-
set cst     " use cscopetags
set csto=0  " if ctags is around, use cscope first

" ********************  UI ******************** "
set wildmenu                " Enable wild menus
set wildignore+=CVS,*.o,*.a,*.class,*.so,*.obj,*.swp,*.jpg,*.png,*.xpm,*.gif,*.jxo,*.rxo,*.ser
set wildmode=list:longest   " To have the completion behave similarly to a shell,
                            " i.e. complete only up to the point of ambiguity (while
                            " still showing you what your options are)

set sbo=ver,hor,jump        " scrollbind windows sync on everything
set guioptions+=bh          " enable bottom scroll 'b'. Also include 'h' to reduce CPU churn to calculate longest line.
set ruler                   " show the cursor position all the time
set number                  " turn on line numbers
set cursorline              " highlight current line
highlight CursorLine gui=underline guibg=NONE
" highlight Search gui=underline guibg=Green
set laststatus=2            " always show status line
"               file,line ending, line, col, file %
set statusline=%<%F\ (%{&ff})\ %m%=[%04l,\ %03v,\ %3p%%]
set scrolloff=3             " When the cursor is moved outside the viewport of the current window,
                            " the buffer is scrolled by a single line. Setting the option below 
                            " will start the scrolling three lines before the border, keeping 
                            " more context around where you?re working

" set ttyfast
set lazyredraw  " make macros faster
set nowrap

" ******************** key mappings ******************** "
let mapleader=","

" make overloaded mappings more responsive  
:set timeout timeoutlen=750 ttimeoutlen=75

" scroll Lock
nnoremap <silent> <Leader>l :windo :set scb!<CR>

" Wrap lock
nnoremap <silent> <Leader>w :set wrap!<CR>
" only show horiz scroll when nowrap is enabled: 
" nnoremap <silent><expr> <Leader>W ':set wrap! go'.'-+'[&wrap]."=b\r"

" find merge Conflict markers
nnoremap <silent> <leader>c <ESC>/\v^[<=>]{7}( .*\|$)<CR>

" find diff File markers
nnoremap <silent> <leader>f <ESC>/\v^Index:.*<CR>

" diff visible windows
nnoremap <silent> <leader>d :windo diffthis<CR>
nnoremap <silent> <leader>o :diffoff!<CR>
  
" save and delete buffer (quit)
nnoremap <silent> <leader>q :w\|bd<CR>

function! Wipeout()
  " list of *all* buffer numbers
  let l:buffers = range(1, bufnr('$'))

  " what tab page are we in?
  let l:currentTab = tabpagenr()
  try
    " go through all tab pages
    let l:tab = 0
    while l:tab < tabpagenr('$')
      let l:tab += 1

      " go through all windows
      let l:win = 0
      while l:win < winnr('$')
        let l:win += 1
        " whatever buffer is in this window in this tab, remove it from
        " l:buffers list
        let l:thisbuf = winbufnr(l:win)
        call remove(l:buffers, index(l:buffers, l:thisbuf))
      endwhile
    endwhile

    " if there are any buffers left, delete them
    if len(l:buffers)
      execute 'bwipeout' join(l:buffers)
    endif
  finally
    " go back to our original tab page
    execute 'tabnext' l:currentTab
  endtry
endfunction

""" taglist 
let Tlist_Compact_Format=1
let Tlist_Show_One_File=1
let Tlist_Auto_Highlight_Tag=1
" this option REALLY slowed down opening buffers
let Tlist_Highlight_Tag_On_BufEnter=1
let Tlist_Ctags_Cmd='C:\opt\ctags58\ctags.exe'
nnoremap <silent> <F3> :TlistToggle<CR>

""" quick fix navigation
nnoremap <silent> [q :cprev<CR>
nnoremap <silent> ]q :cnext<CR>
nnoremap <silent> [Q :cfirst<CR>
nnoremap <silent> ]Q :clast<CR>

let g:DirDiffExcludes = "CVS,\\.\\#*,*.class,*.swp,*.jxo,*.rxo"

colo _wheatpuff    " my customer colorscheme based on peachpuff
" better colors for vimdiff when using default colorscheme
" highlight DiffAdd gui=NONE guibg=LightGreen
" highlight DiffDelete gui=NONE guibg=LightRed
" highlight DiffChange gui=NONE guibg=LightGrey
" highlight DiffText gui=NONE guibg=LightCyan
