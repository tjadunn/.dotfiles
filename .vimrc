" :'<,'>!python -m json.tool json formatter
syntax on

" :'<,'>!xmllint --format - xml formatter

" ipdb
map <Leader>p :call InsertLine()<CR>

function! InsertLine()
  let trace = expand("import ipdb; ipdb.set_trace()")
  execute "normal o".trace
endfunction

"scroll through tabs
map <F7> :tabp <CR>
map <F8> :tabn <CR>

"stop indentline hiding json quotes
let g:indentLine_fileTypeExclude = ['json']
let g:indentguides_spacechar = '┆'
let g:black_linelength = 88



let no_flake8_maps = 1
autocmd FileType python map <buffer> <F5> :call Flake8()<CR>

" Search under cursor and plug into fzf
map <leader>A :Ag <c-r><c-w><cr>

map <F9> :NERDTreeToggle <CR>
let NERDTreeMapOpenInTab='<ENTER>'

"toggle scrolling two splits at same time
nmap <F5> :windo set scrollbind!<cr>

" toggle line numbers and listchars
nmap <leader>l :set list! <bar> :set nu!<CR>

" put double quotes around next word
nmap <leader>q ciw"<C-r>""<ESC>

" search Git commited files with fzf
map <leader>g :GFiles<cr>

" search all Files commited with fzf
map <leader>f :Files<cr>

" search all tags (classes etc) with fzf
map <leader>t :Tags<cr>

execute pathogen#infect()


call plug#begin()
Plug 'Yggdroot/indentLine'
Plug 'kien/ctrlp.vim'
Plug 'nvie/vim-flake8'
Plug 'janko/vim-test'
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'
"Plug 'psf/black' -> install this via pip3 plug installation is messy
Plug 'derekwyatt/vim-scala'
Plug 'neoclide/coc.nvim', {'do': { -> coc#util#install()}}
Plug 'pappasam/coc-jedi', { 'do': 'yarn install --frozen-lockfile && yarn build', 'branch': 'main' }

" ctrl t to open new tab
" ctrl v to open in vert split
" ctrl x to open horizontally
call plug#end()

" Make <CR> to accept selected completion item or notify coc.nvim to format
" <C-g>u breaks current undo, please make your own choice.
inoremap <silent><expr> <CR> coc#pum#visible() ? coc#pum#confirm()
                              \: "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"
" config for vim scala
au BufRead,BufNewFile *.sbt set filetype=scala

" enable json syntax highlighting
autocmd FileType json syntax match Comment +\/\/.\+$+




"grep stuff
"nnoremap <leader>w viw"hy:grep! -i -r <C-r>h .
"vnoremap <leader>v "hy:grep! -i -r <C-r>h . <CR><bar> :copen <CR>
"nnoremap <leader>w viw"hy :grep! -i -r <C-r>h . "<CR><bar> :copen <CR>

" bind K to grep word under cursor
"nnoremap K :grep! "\b<C-R><C-W>\b"<CR>:cw<CR>
nnoremap K :grep! "\b<C-R><C-W>\b"<CR>:copen<CR>

vnoremap <leader>w y/<C-R>"<CR>

" Madting fast grep
" The Silver Searcher
if executable('ag')
  " Use ag over grep
  set grepprg=ag\ --nogroup\ --nocolor

  " Use ag in CtrlP for listing files. Lightning fast and respects .gitignore
  let g:ctrlp_user_command = 'ag %s -l --nocolor -g ""'

  " ag is fast enough that CtrlP doesn't need to cache
  let g:ctrlp_use_caching = 0
endif


" map enter to open in new tab, local only to qf buffer
autocmd FileType qf nnoremap <buffer> <Enter> <C-W><Enter><C-W>T

""" BLACK / ISORT
"disable  enter
autocmd FileType python map <leader>i :Isort<cr>
command! -range=% Isort :<line1>,<line2>! isort -


autocmd FileType python map <leader>b :Black<cr>
command! -range=% Black :<line1>,<line2>! black - 2> /dev/null

if has("autocmd")
  au BufReadPost * if line("'\"") > 0 && line("'\"") <= line("$") | exe "normal! g`\"" | endif
endif
" exec black and isort on save
"autocmd BufWritePre *.py silent! execute OnSave() | silent! exe "g;" | silent! exe "g;"

"""
"
function OnSave()
    execute ':Isort'
    execute ':Black'
endfunction

"
" space mapping for normal mode
nnoremap <space> i<space><esc>

" replace the next word with whatever is in buffer 0 (i.e. reuslt of yw)
map <C-l> cw<C-r>0<ESC>

" copy to system clipboard
set clipboard=unnamed

" move lines
map <C-k> :m-2<CR>
map <C-j> :m+1<CR>

"allows you to open files on different git branches eg :vsp B_CI:./docker-compose.yml
function! s:gotoline()
	let buf = bufnr("%")
	let file = bufname("%")

	if ! filereadable(file) && line('$')==1
                let cmd = "git show " . file
		exec 'normal :r!LANG=C ' . cmd . "\n:1d\n"

                " TODO: the mode of the file is not set to RO/no-modify
                "       but I cannot figure out why
                exec 'normal :set readonly nomodifiable\n'
	endif

endfunction

autocmd! BufNewFile [^~/]*:*,[^~/]*:**/*,[^~/]**/*:*,[^~/]**/*:**/* call s:gotoline()
"style things

"to stop tmux fucking up the colours
set t_ut=
set t_vb=

set background=dark
set t_Co=256
set backspace=indent,eol,start
set nu                          " Line numbers on
set showmatch                   " Show matching brackets/parenthesis
set incsearch                   " Find as you type search
set hlsearch                    " Highlight search terms
set winminheight=0              " Windows can be 0 line high
set ignorecase                  " Case insensitive search
set smartcase                   " Case sensitive when uc present
set wildmenu                    " Show list instead of just completing
set wildmode=list:longest,full  " Command <Tab> completion, list matches, then longest common part, then all.
set whichwrap=b,s,h,l,<,>,[,]   " Backspace and cursor keys wrap too
set scrolljump=5                " Lines to scroll when cursor leaves screen
set scrolloff=3                 " Minimum lines to keep above and below cursor
set guioptions-=T               " Remove the toolbar
set nobackup                    " no backup - (use git)
set noswapfile                  " no swap file
set splitbelow                  " horizontal windows always split below
set splitright                  " vertical windows always split right
set completeopt-=preview
set title                       " show window title
set autoindent                   "autoindent when pressing Enter
set tabstop=4                   " use 4 spaces for tabs
set shiftwidth=4
set softtabstop=4
set shiftwidth=4
set expandtab
set incsearch
set ignorecase
set smartcase
set ls=2
set ruler
set showtabline=2
set formatoptions=qroct
set showcmd
set spelllang=en_uk            " current language
set cursorline                  " highlight the current line
set fileformat=unix             " unix file format by default
set fileformats=unix,dos,mac    " available formats
set nowrap                      " Continue line outside of view
set colorcolumn=88              " set ruler at 80
set list
set listchars=tab:»·,trail:.,extends:#,nbsp:.
"set list listchars=tab:→\ ,trail:·

autocmd FileType python set tabstop=4


" Kill sounds
set vb

"Pretty stuff not by me...
" This scheme was created by CSApproxSnapshot
" on Sat, 11 Jun 2016

hi clear
"if exists("syntax_on")
"    syntax reset
"endif

    hi Normal term=NONE cterm=NONE ctermbg=235 ctermfg=188 gui=NONE guibg=#000000 guifg=#dcdccc
    hi vimIskList term=NONE cterm=NONE ctermbg=bg ctermfg=fg gui=NONE guibg=bg guifg=fg
    hi vimSynKeyRegion term=NONE cterm=NONE ctermbg=bg ctermfg=fg gui=NONE guibg=bg guifg=fg
    hi vimSynMatchRegion term=NONE cterm=NONE ctermbg=bg ctermfg=fg gui=NONE guibg=bg guifg=fg
    hi hsVarSym term=NONE cterm=NONE ctermbg=bg ctermfg=fg gui=NONE guibg=bg guifg=fg
    hi hs_DeclareFunction term=NONE cterm=NONE ctermbg=bg ctermfg=fg gui=NONE guibg=bg guifg=fg
    hi hs_OpFunctionName term=NONE cterm=NONE ctermbg=bg ctermfg=fg gui=NONE guibg=bg guifg=fg
    hi hs_hlFunctionName term=NONE cterm=NONE ctermbg=bg ctermfg=fg gui=NONE guibg=bg guifg=fg
    "hi htmlArg term=NONE cterm=NONE ctermbg=bg ctermfg=fg gui=NONE guibg=bg guifg=fg
    "hi htmlEndTag term=NONE cterm=NONE ctermbg=bg ctermfg=fg gui=NONE guibg=bg guifg=fg
    "hi htmlSpecialTagName term=NONE cterm=NONE ctermbg=bg ctermfg=fg gui=NONE guibg=bg guifg=fg
    "hi htmlTag term=NONE cterm=NONE ctermbg=bg ctermfg=fg gui=NONE guibg=bg guifg=fg
    "hi htmlTagN term=NONE cterm=NONE ctermbg=bg ctermfg=fg gui=NONE guibg=bg guifg=fg
    "hi htmlTagName term=NONE cterm=NONE ctermbg=bg ctermfg=fg gui=NONE guibg=bg guifg=fg
    hi ExtraWhitespace term=NONE cterm=NONE ctermbg=196 ctermfg=fg gui=NONE guibg=#ff0000 guifg=fg
    hi rubyLocalVariableOrMethod term=NONE cterm=NONE ctermbg=bg ctermfg=fg gui=NONE guibg=bg guifg=fg
    hi rubyBlockArgument term=NONE cterm=NONE ctermbg=bg ctermfg=fg gui=NONE guibg=bg guifg=fg
    hi vimStdPlugin term=NONE cterm=NONE ctermbg=bg ctermfg=fg gui=NONE guibg=bg guifg=fg
    hi vimOperParen term=NONE cterm=NONE ctermbg=bg ctermfg=fg gui=NONE guibg=bg guifg=fg
    hi vimRegion term=NONE cterm=NONE ctermbg=bg ctermfg=fg gui=NONE guibg=bg guifg=fg
    hi vimSynLine term=NONE cterm=NONE ctermbg=bg ctermfg=fg gui=NONE guibg=bg guifg=fg
    hi SpecialKey term=bold cterm=NONE ctermbg=bg ctermfg=51 gui=NONE guibg=bg guifg=#00ffff
    hi NonText term=bold cterm=bold ctermbg=bg ctermfg=21 gui=bold guibg=bg guifg=#0000ff
    hi Directory term=bold cterm=NONE ctermbg=bg ctermfg=198 gui=NONE guibg=bg guifg=#ff1493
    hi ErrorMsg term=NONE cterm=NONE ctermbg=196 ctermfg=231 gui=NONE guibg=#ff0000 guifg=#ffffff
    hi IncSearch term=reverse cterm=reverse ctermbg=bg ctermfg=fg gui=reverse guibg=bg guifg=fg
    hi Search term=reverse cterm=NONE ctermbg=226 ctermfg=16 gui=NONE guibg=#ffff00 guifg=#000000
    hi MoreMsg term=bold cterm=bold ctermbg=bg ctermfg=29 gui=bold guibg=bg guifg=#2e8b57
    hi ModeMsg term=bold cterm=bold ctermbg=bg ctermfg=fg gui=bold guibg=bg guifg=fg
    hi LineNr term=underline cterm=NONE ctermbg=16 ctermfg=151 gui=NONE guibg=#000000 guifg=#9fc59f
    hi vimUserCmd term=NONE cterm=NONE ctermbg=bg ctermfg=fg gui=NONE guibg=bg guifg=fg
    hi perlStatementIndirObjWrap term=NONE cterm=NONE ctermbg=bg ctermfg=fg gui=NONE guibg=bg guifg=fg
    hi perlVarMember term=NONE cterm=NONE ctermbg=bg ctermfg=fg gui=NONE guibg=bg guifg=fg
    hi SpellRare term=reverse cterm=undercurl ctermbg=bg ctermfg=fg gui=undercurl guibg=bg guifg=fg
    hi SpellLocal term=underline cterm=undercurl ctermbg=bg ctermfg=fg gui=undercurl guibg=bg guifg=fg
    hi Pmenu term=NONE cterm=NONE ctermbg=201 ctermfg=fg gui=NONE guibg=#ff00ff guifg=fg
    hi PmenuSel term=NONE cterm=NONE ctermbg=248 ctermfg=fg gui=NONE guibg=#a9a9a9 guifg=fg
    hi PmenuSbar term=NONE cterm=NONE ctermbg=250 ctermfg=fg gui=NONE guibg=#bebebe guifg=fg
    hi PmenuThumb term=NONE cterm=NONE ctermbg=231 ctermfg=fg gui=NONE guibg=#ffffff guifg=fg
    hi TabLine term=underline cterm=underline ctermbg=248 ctermfg=fg gui=underline guibg=#a9a9a9 guifg=fg
    hi TabLineSel term=bold cterm=bold ctermbg=bg ctermfg=fg gui=bold guibg=bg guifg=fg
    hi TabLineFill term=reverse cterm=reverse ctermbg=bg ctermfg=fg gui=reverse guibg=bg guifg=fg
    hi CursorColumn term=reverse cterm=NONE ctermbg=241 ctermfg=fg gui=NONE guibg=#666666 guifg=fg
    hi vimSynMtchCchar term=NONE cterm=NONE ctermbg=bg ctermfg=fg gui=NONE guibg=bg guifg=fg
    hi vimSynMtchGroup term=NONE cterm=NONE ctermbg=bg ctermfg=fg gui=NONE guibg=bg guifg=fg
    hi vimSynRegion term=NONE cterm=NONE ctermbg=bg ctermfg=fg gui=NONE guibg=bg guifg=fg
    hi vimSynPatMod term=NONE cterm=NONE ctermbg=bg ctermfg=fg gui=NONE guibg=bg guifg=fg
    hi javaScript term=NONE cterm=NONE ctermbg=bg ctermfg=fg gui=NONE guibg=bg guifg=fg
    hi pandocBlockQuote term=NONE cterm=NONE ctermbg=bg ctermfg=fg gui=NONE guibg=bg guifg=fg
    hi pandocBlockQuoteLeader1 term=NONE cterm=NONE ctermbg=bg ctermfg=fg gui=NONE guibg=bg guifg=fg
    hi pandocBlockQuoteLeader2 term=NONE cterm=NONE ctermbg=bg ctermfg=fg gui=NONE guibg=bg guifg=fg
    hi pandocBlockQuoteLeader3 term=NONE cterm=NONE ctermbg=bg ctermfg=fg gui=NONE guibg=bg guifg=fg
    hi pandocBlockQuoteLeader4 term=NONE cterm=NONE ctermbg=bg ctermfg=fg gui=NONE guibg=bg guifg=fg
    hi pandocBlockQuoteLeader5 term=NONE cterm=NONE ctermbg=bg ctermfg=fg gui=NONE guibg=bg guifg=fg
    hi pandocBlockQuoteLeader6 term=NONE cterm=NONE ctermbg=bg ctermfg=fg gui=NONE guibg=bg guifg=fg
    hi pandocCitation term=NONE cterm=NONE ctermbg=bg ctermfg=fg gui=NONE guibg=bg guifg=fg
    hi pandocCitationDelim term=NONE cterm=NONE ctermbg=bg ctermfg=fg gui=NONE guibg=bg guifg=fg
    hi rubyBlockParameterList term=NONE cterm=NONE ctermbg=bg ctermfg=fg gui=NONE guibg=bg guifg=fg
    hi rubyHeredocStart term=NONE cterm=NONE ctermbg=bg ctermfg=fg gui=NONE guibg=bg guifg=fg
    hi rubyRegexpBrackets term=NONE cterm=NONE ctermbg=bg ctermfg=fg gui=NONE guibg=bg guifg=fg
    hi perlVarBlock term=NONE cterm=NONE ctermbg=bg ctermfg=fg gui=NONE guibg=bg guifg=fg
    hi perlVarBlock2 term=NONE cterm=NONE ctermbg=bg ctermfg=fg gui=NONE guibg=bg guifg=fg
    hi CursorLine term=underline cterm=NONE ctermbg=236 ctermfg=fg gui=NONE guibg=#333333 guifg=fg
    hi ColorColumn term=reverse cterm=NONE ctermbg=88 ctermfg=fg gui=NONE guibg=#8b0000 guifg=fg
    hi MatchParen term=reverse cterm=NONE ctermbg=30 ctermfg=fg gui=NONE guibg=#008b8b guifg=fg
    hi Comment term=bold cterm=NONE ctermbg=bg ctermfg=245 gui=NONE guibg=bg guifg=#8b8989
    hi Constant term=underline cterm=NONE ctermbg=bg ctermfg=69 gui=NONE guibg=bg guifg=#4c83ff
    hi Special term=bold cterm=NONE ctermbg=bg ctermfg=214 gui=NONE guibg=bg guifg=#ffa500
    hi Identifier term=underline cterm=NONE ctermbg=bg ctermfg=191 gui=NONE guibg=bg guifg=#d8fa3c
    hi Statement term=bold cterm=bold ctermbg=bg ctermfg=227 gui=bold guibg=bg guifg=#ffff60
    hi PreProc term=underline cterm=NONE ctermbg=bg ctermfg=246 gui=NONE guibg=bg guifg=#919191
    hi Type term=underline cterm=bold ctermbg=bg ctermfg=191 gui=bold guibg=bg guifg=#d8fa3c
    hi vimSyncLines term=NONE cterm=NONE ctermbg=bg ctermfg=fg gui=NONE guibg=bg guifg=fg
    hi vimSyncMatch term=NONE cterm=NONE ctermbg=bg ctermfg=fg gui=NONE guibg=bg guifg=fg
    hi vimSyncLinebreak term=NONE cterm=NONE ctermbg=bg ctermfg=fg gui=NONE guibg=bg guifg=fg
    hi vimSyncLinecont term=NONE cterm=NONE ctermbg=bg ctermfg=fg gui=NONE guibg=bg guifg=fg
    hi vimSyncRegion term=NONE cterm=NONE ctermbg=bg ctermfg=fg gui=NONE guibg=bg guifg=fg
    hi pandocCitationID term=NONE cterm=NONE ctermbg=bg ctermfg=fg gui=NONE guibg=bg guifg=fg
    hi pandocCitationRef term=NONE cterm=NONE ctermbg=bg ctermfg=fg gui=NONE guibg=bg guifg=fg
    hi pandocComment term=NONE cterm=NONE ctermbg=bg ctermfg=fg gui=NONE guibg=bg guifg=fg
    hi pandocDefinitionBlock term=NONE cterm=NONE ctermbg=bg ctermfg=fg gui=NONE guibg=bg guifg=fg
    hi pandocDefinitionIndctr term=NONE cterm=NONE ctermbg=bg ctermfg=fg gui=NONE guibg=bg guifg=fg
    hi pandocDefinitionTerm term=NONE cterm=NONE ctermbg=bg ctermfg=fg gui=NONE guibg=bg guifg=fg
    hi pandocEmphasis term=NONE cterm=NONE ctermbg=bg ctermfg=fg gui=NONE guibg=bg guifg=fg
    hi pandocEmphasisDefinition term=NONE cterm=NONE ctermbg=bg ctermfg=fg gui=NONE guibg=bg guifg=fg
    hi pandocEmphasisHeading term=NONE cterm=NONE ctermbg=bg ctermfg=fg gui=NONE guibg=bg guifg=fg
    hi pandocEmphasisNested term=NONE cterm=NONE ctermbg=bg ctermfg=fg gui=NONE guibg=bg guifg=fg
    hi rubyMethodDeclaration term=NONE cterm=NONE ctermbg=bg ctermfg=fg gui=NONE guibg=bg guifg=fg
    hi rubyClassDeclaration term=NONE cterm=NONE ctermbg=bg ctermfg=fg gui=NONE guibg=bg guifg=fg
    hi rubyModuleDeclaration term=NONE cterm=NONE ctermbg=bg ctermfg=fg gui=NONE guibg=bg guifg=fg
    hi vimEcho term=NONE cterm=NONE ctermbg=bg ctermfg=fg gui=NONE guibg=bg guifg=fg
    hi vimIf term=NONE cterm=NONE ctermbg=bg ctermfg=fg gui=NONE guibg=bg guifg=fg
    hi rubyAliasDeclaration2 term=NONE cterm=NONE ctermbg=bg ctermfg=fg gui=NONE guibg=bg guifg=fg
    hi perlPackageConst term=NONE cterm=NONE ctermbg=bg ctermfg=fg gui=NONE guibg=bg guifg=fg
    hi NONE term=NONE cterm=NONE ctermbg=bg ctermfg=fg gui=NONE guibg=bg guifg=fg
    hi Underlined term=underline cterm=underline ctermbg=bg ctermfg=111 gui=underline guibg=bg guifg=#80a0ff
    hi Ignore term=NONE cterm=NONE ctermbg=bg ctermfg=16 gui=NONE guibg=bg guifg=#000000
    hi Error term=reverse cterm=NONE ctermbg=196 ctermfg=231 gui=NONE guibg=#ff0000 guifg=#ffffff
    hi Todo term=NONE cterm=NONE ctermbg=226 ctermfg=21 gui=NONE guibg=#ffff00 guifg=#0000ff
    hi String term=NONE cterm=NONE ctermbg=bg ctermfg=77 gui=NONE guibg=bg guifg=#61ce3c
    hi Number term=NONE cterm=NONE ctermbg=bg ctermfg=188 gui=NONE guibg=bg guifg=#dcdccc
    hi Float term=NONE cterm=NONE ctermbg=bg ctermfg=188 gui=NONE guibg=bg guifg=#dcdccc
    hi Function term=NONE cterm=NONE ctermbg=bg ctermfg=198 gui=NONE guibg=bg guifg=#ff1493
    hi pandocVerbatimInlineTable term=NONE cterm=NONE ctermbg=bg ctermfg=fg gui=NONE guibg=bg guifg=fg
    hi vimHiKeyList term=NONE cterm=NONE ctermbg=bg ctermfg=fg gui=NONE guibg=bg guifg=fg
    hi vimHiBang term=NONE cterm=NONE ctermbg=bg ctermfg=fg gui=NONE guibg=bg guifg=fg
    hi vimHiCtermColor term=NONE cterm=NONE ctermbg=bg ctermfg=fg gui=NONE guibg=bg guifg=fg
    hi vimHiFontname term=NONE cterm=NONE ctermbg=bg ctermfg=fg gui=NONE guibg=bg guifg=fg
    hi vimHiGuiFontname term=NONE cterm=NONE ctermbg=bg ctermfg=fg gui=NONE guibg=bg guifg=fg
    hi pandocEmphasisNestedDefinition term=NONE cterm=NONE ctermbg=bg ctermfg=fg gui=NONE guibg=bg guifg=fg
    hi pandocEmphasisNestedHeading term=NONE cterm=NONE ctermbg=bg ctermfg=fg gui=NONE guibg=bg guifg=fg
    hi pandocEmphasisNestedTable term=NONE cterm=NONE ctermbg=bg ctermfg=fg gui=NONE guibg=bg guifg=fg
    hi pandocEmphasisTable term=NONE cterm=NONE ctermbg=bg ctermfg=fg gui=NONE guibg=bg guifg=fg
    hi pandocEscapePair term=NONE cterm=NONE ctermbg=bg ctermfg=fg gui=NONE guibg=bg guifg=fg
    hi pandocFootnote term=NONE cterm=NONE ctermbg=bg ctermfg=fg gui=NONE guibg=bg guifg=fg
    hi pandocFootnoteDefLink term=NONE cterm=NONE ctermbg=bg ctermfg=fg gui=NONE guibg=bg guifg=fg
    hi pandocFootnoteInline term=NONE cterm=NONE ctermbg=bg ctermfg=fg gui=NONE guibg=bg guifg=fg
    hi pandocFootnoteLink term=NONE cterm=NONE ctermbg=bg ctermfg=fg gui=NONE guibg=bg guifg=fg
    hi pandocHeading term=NONE cterm=NONE ctermbg=bg ctermfg=fg gui=NONE guibg=bg guifg=fg
    hi rubyAliasDeclaration term=NONE cterm=NONE ctermbg=bg ctermfg=fg gui=NONE guibg=bg guifg=fg
    hi rubyMethodBlock term=NONE cterm=NONE ctermbg=bg ctermfg=fg gui=NONE guibg=bg guifg=fg
    hi rubyBlock term=NONE cterm=NONE ctermbg=bg ctermfg=fg gui=NONE guibg=bg guifg=fg
    hi rubyDoBlock term=NONE cterm=NONE ctermbg=bg ctermfg=fg gui=NONE guibg=bg guifg=fg
    hi vimFuncBody term=NONE cterm=NONE ctermbg=bg ctermfg=fg gui=NONE guibg=bg guifg=fg
    hi vimFuncBlank term=NONE cterm=NONE ctermbg=bg ctermfg=fg gui=NONE guibg=bg guifg=fg
    hi vimEscapeBrace term=NONE cterm=NONE ctermbg=bg ctermfg=fg gui=NONE guibg=bg guifg=fg
    hi vimSubstRep term=NONE cterm=NONE ctermbg=bg ctermfg=fg gui=NONE guibg=bg guifg=fg
    hi vimSubstRange term=NONE cterm=NONE ctermbg=bg ctermfg=fg gui=NONE guibg=bg guifg=fg
    hi perlSync term=NONE cterm=NONE ctermbg=bg ctermfg=fg gui=NONE guibg=bg guifg=fg
    hi perlSyncPOD term=NONE cterm=NONE ctermbg=bg ctermfg=fg gui=NONE guibg=bg guifg=fg
    hi pythonSync term=NONE cterm=NONE ctermbg=bg ctermfg=fg gui=NONE guibg=bg guifg=fg
    hi Conditional term=NONE cterm=NONE ctermbg=bg ctermfg=220 gui=NONE guibg=bg guifg=#fbde2d
    hi Repeat term=NONE cterm=NONE ctermbg=bg ctermfg=220 gui=NONE guibg=bg guifg=#fbde2d
    hi Label term=NONE cterm=NONE ctermbg=bg ctermfg=220 gui=NONE guibg=bg guifg=#fbde2d
    hi Operator term=NONE cterm=NONE ctermbg=bg ctermfg=220 gui=NONE guibg=bg guifg=#fbde2d
    hi Keyword term=NONE cterm=NONE ctermbg=bg ctermfg=220 gui=NONE guibg=bg guifg=#fbde2d
    hi rubyRepeatExpression term=NONE cterm=NONE ctermbg=bg ctermfg=fg gui=NONE guibg=bg guifg=fg
    hi vimHiTermcap term=NONE cterm=NONE ctermbg=bg ctermfg=fg gui=NONE guibg=bg guifg=fg
    hi pandocHeadingMarker term=NONE cterm=NONE ctermbg=bg ctermfg=fg gui=NONE guibg=bg guifg=fg
    hi pandocImageCaption term=NONE cterm=NONE ctermbg=bg ctermfg=fg gui=NONE guibg=bg guifg=fg
    hi pandocLinkDefinition term=NONE cterm=NONE ctermbg=bg ctermfg=fg gui=NONE guibg=bg guifg=fg
    hi pandocLinkDefinitionID term=NONE cterm=NONE ctermbg=bg ctermfg=fg gui=NONE guibg=bg guifg=fg
    hi pandocLinkDelim term=NONE cterm=NONE ctermbg=bg ctermfg=fg gui=NONE guibg=bg guifg=fg
    hi pandocLinkLabel term=NONE cterm=NONE ctermbg=bg ctermfg=fg gui=NONE guibg=bg guifg=fg
    hi pandocLinkText term=NONE cterm=NONE ctermbg=bg ctermfg=fg gui=NONE guibg=bg guifg=fg
    hi pandocLinkTitle term=NONE cterm=NONE ctermbg=bg ctermfg=fg gui=NONE guibg=bg guifg=fg
    hi pandocLinkTitleDelim term=NONE cterm=NONE ctermbg=bg ctermfg=fg gui=NONE guibg=bg guifg=fg
    hi pandocLinkURL term=NONE cterm=NONE ctermbg=bg ctermfg=fg gui=NONE guibg=bg guifg=fg
    hi rubyArrayLiteral term=NONE cterm=NONE ctermbg=bg ctermfg=fg gui=NONE guibg=bg guifg=fg
    hi rubyBlockExpression term=NONE cterm=NONE ctermbg=bg ctermfg=fg gui=NONE guibg=bg guifg=fg
    hi rubyCaseExpression term=NONE cterm=NONE ctermbg=bg ctermfg=fg gui=NONE guibg=bg guifg=fg
    hi rubyConditionalExpression term=NONE cterm=NONE ctermbg=bg ctermfg=fg gui=NONE guibg=bg guifg=fg
    hi rubyOptionalDoLine term=NONE cterm=NONE ctermbg=bg ctermfg=fg gui=NONE guibg=bg guifg=fg
    hi vimPatRegion term=NONE cterm=NONE ctermbg=bg ctermfg=fg gui=NONE guibg=bg guifg=fg
    hi perlAutoload term=NONE cterm=NONE ctermbg=bg ctermfg=fg gui=NONE guibg=bg guifg=fg
    hi StorageClass term=NONE cterm=NONE ctermbg=bg ctermfg=220 gui=NONE guibg=bg guifg=#fbde2d
    hi Structure term=NONE cterm=NONE ctermbg=bg ctermfg=220 gui=NONE guibg=bg guifg=#fbde2d
    hi Typedef term=NONE cterm=NONE ctermbg=bg ctermfg=220 gui=NONE guibg=bg guifg=#fbde2d
    hi Delimiter term=NONE cterm=NONE ctermbg=bg ctermfg=188 gui=NONE guibg=bg guifg=#dcdccc
    hi ConId term=NONE cterm=NONE ctermbg=bg ctermfg=fg gui=NONE guibg=bg guifg=fg
    "hi SyntasticErrorLine term=NONE cterm=NONE ctermbg=bg ctermfg=fg gui=NONE guibg=bg guifg=fg
    hi rubyCurlyBlockDelimiter term=NONE cterm=NONE ctermbg=bg ctermfg=fg gui=NONE guibg=bg guifg=fg
    hi vimCommentTitleLeader term=NONE cterm=NONE ctermbg=bg ctermfg=fg gui=NONE guibg=bg guifg=fg
    hi rubyCurlyBlock term=NONE cterm=NONE ctermbg=bg ctermfg=fg gui=NONE guibg=bg guifg=fg
    "hi SyntasticWarningLine term=NONE cterm=NONE ctermbg=bg ctermfg=fg gui=NONE guibg=bg guifg=fg
    hi rubyArrayDelimiter term=NONE cterm=NONE ctermbg=bg ctermfg=fg gui=NONE guibg=bg guifg=fg
    hi pandocListMarker term=NONE cterm=NONE ctermbg=bg ctermfg=fg gui=NONE guibg=bg guifg=fg
    hi pandocListReference term=NONE cterm=NONE ctermbg=bg ctermfg=fg gui=NONE guibg=bg guifg=fg
    hi pandocMetadata term=NONE cterm=NONE ctermbg=bg ctermfg=fg gui=NONE guibg=bg guifg=fg
    hi pandocMetadataDelim term=NONE cterm=NONE ctermbg=bg ctermfg=fg gui=NONE guibg=bg guifg=fg
    hi pandocMetadataKey term=NONE cterm=NONE ctermbg=bg ctermfg=fg gui=NONE guibg=bg guifg=fg
    hi pandocNonBreakingSpace term=NONE cterm=NONE ctermbg=bg ctermfg=fg gui=NONE guibg=bg guifg=fg
    hi pandocRule term=NONE cterm=NONE ctermbg=bg ctermfg=fg gui=NONE guibg=bg guifg=fg
    hi pandocRuleLine term=NONE cterm=NONE ctermbg=bg ctermfg=fg gui=NONE guibg=bg guifg=fg
    hi pandocStrikeout term=NONE cterm=NONE ctermbg=bg ctermfg=fg gui=NONE guibg=bg guifg=fg
    hi pandocStrikeoutDefinition term=NONE cterm=NONE ctermbg=bg ctermfg=fg gui=NONE guibg=bg guifg=fg
    hi rubyMultilineComment term=NONE cterm=NONE ctermbg=bg ctermfg=fg gui=NONE guibg=bg guifg=fg
    hi rubyDelimEscape term=NONE cterm=NONE ctermbg=bg ctermfg=fg gui=NONE guibg=bg guifg=fg
    hi vimCollection term=NONE cterm=NONE ctermbg=bg ctermfg=fg gui=NONE guibg=bg guifg=fg
    hi vimSubstPat term=NONE cterm=NONE ctermbg=bg ctermfg=fg gui=NONE guibg=bg guifg=fg
    hi vimSubstRep4 term=NONE cterm=NONE ctermbg=bg ctermfg=fg gui=NONE guibg=bg guifg=fg
    hi rubyNestedParentheses term=NONE cterm=NONE ctermbg=bg ctermfg=fg gui=NONE guibg=bg guifg=fg
    hi CursorLineNr term=bold cterm=bold ctermbg=bg ctermfg=226 gui=bold guibg=bg guifg=#ffff00
    hi perlFormat term=NONE cterm=NONE ctermbg=bg ctermfg=fg gui=NONE guibg=bg guifg=fg
    hi helpLeadBlank term=NONE cterm=NONE ctermbg=bg ctermfg=fg gui=NONE guibg=bg guifg=fg
    hi helpNormal term=NONE cterm=NONE ctermbg=bg ctermfg=fg gui=NONE guibg=bg guifg=fg
    hi Cursor term=NONE cterm=NONE ctermbg=220 ctermfg=188 gui=NONE guibg=#fbde2d guifg=#dcdccc
    hi HelpExample term=NONE cterm=NONE ctermbg=bg ctermfg=fg gui=NONE guibg=bg guifg=fg
    hi VarId term=NONE cterm=NONE ctermbg=bg ctermfg=fg gui=NONE guibg=bg guifg=fg
    hi cPreCondit term=NONE cterm=NONE ctermbg=bg ctermfg=fg gui=NONE guibg=bg guifg=fg
    hi gitcommitBranch term=NONE cterm=NONE ctermbg=bg ctermfg=fg gui=NONE guibg=bg guifg=fg
    hi gitcommitComment term=NONE cterm=NONE ctermbg=bg ctermfg=fg gui=NONE guibg=bg guifg=fg
    hi gitcommitDiscardedFile term=NONE cterm=NONE ctermbg=bg ctermfg=fg gui=NONE guibg=bg guifg=fg
    hi gitcommitDiscardedType term=NONE cterm=NONE ctermbg=bg ctermfg=fg gui=NONE guibg=bg guifg=fg
    hi gitcommitFile term=NONE cterm=NONE ctermbg=bg ctermfg=fg gui=NONE guibg=bg guifg=fg
    hi gitcommitHeader term=NONE cterm=NONE ctermbg=bg ctermfg=fg gui=NONE guibg=bg guifg=fg
    hi podBoldItalic term=NONE cterm=NONE ctermbg=bg ctermfg=fg gui=NONE guibg=bg guifg=fg
    hi podBoldOpen term=NONE cterm=NONE ctermbg=bg ctermfg=fg gui=NONE guibg=bg guifg=fg
    hi podBoldAlternativeDelimOpen term=NONE cterm=NONE ctermbg=bg ctermfg=fg gui=NONE guibg=bg guifg=fg
    hi podItalicBold term=NONE cterm=NONE ctermbg=bg ctermfg=fg gui=NONE guibg=bg guifg=fg
    hi podItalicOpen term=NONE cterm=NONE ctermbg=bg ctermfg=fg gui=NONE guibg=bg guifg=fg
    hi pandocStrikeoutHeading term=NONE cterm=NONE ctermbg=bg ctermfg=fg gui=NONE guibg=bg guifg=fg
    hi pandocStrikeoutTable term=NONE cterm=NONE ctermbg=bg ctermfg=fg gui=NONE guibg=bg guifg=fg
    hi pandocStrongEmphasis term=NONE cterm=NONE ctermbg=bg ctermfg=fg gui=NONE guibg=bg guifg=fg
    hi pandocStrongEmphasisDefinition term=NONE cterm=NONE ctermbg=bg ctermfg=fg gui=NONE guibg=bg guifg=fg
    hi pandocStrongEmphasisEmphasis term=NONE cterm=NONE ctermbg=bg ctermfg=fg gui=NONE guibg=bg guifg=fg
    hi pandocStrongEmphasisEmphasisDefinition term=NONE cterm=NONE ctermbg=bg ctermfg=fg gui=NONE guibg=bg guifg=fg
    hi pandocStrongEmphasisEmphasisHeading term=NONE cterm=NONE ctermbg=bg ctermfg=fg gui=NONE guibg=bg guifg=fg
    hi pandocStrongEmphasisEmphasisTable term=NONE cterm=NONE ctermbg=bg ctermfg=fg gui=NONE guibg=bg guifg=fg
    hi pandocStrongEmphasisHeading term=NONE cterm=NONE ctermbg=bg ctermfg=fg gui=NONE guibg=bg guifg=fg
    hi pandocStrongEmphasisNested term=NONE cterm=NONE ctermbg=bg ctermfg=fg gui=NONE guibg=bg guifg=fg
    hi vimRubyRegion term=NONE cterm=NONE ctermbg=bg ctermfg=fg gui=NONE guibg=bg guifg=fg
    hi vimCollClass term=NONE cterm=NONE ctermbg=bg ctermfg=fg gui=NONE guibg=bg guifg=fg
    hi vimMapLhs term=NONE cterm=NONE ctermbg=bg ctermfg=fg gui=NONE guibg=bg guifg=fg
    hi gitcommitOnBranch term=NONE cterm=NONE ctermbg=bg ctermfg=fg gui=NONE guibg=bg guifg=fg
    hi gitcommitSelectedFile term=NONE cterm=NONE ctermbg=bg ctermfg=fg gui=NONE guibg=bg guifg=fg
    hi gitcommitSelectedType term=NONE cterm=NONE ctermbg=bg ctermfg=fg gui=NONE guibg=bg guifg=fg
    hi gitcommitUnmerged term=NONE cterm=NONE ctermbg=bg ctermfg=fg gui=NONE guibg=bg guifg=fg
    hi gitcommitUnmergedFile term=NONE cterm=NONE ctermbg=bg ctermfg=fg gui=NONE guibg=bg guifg=fg
    hi gitcommitUntrackedFile term=NONE cterm=NONE ctermbg=bg ctermfg=fg gui=NONE guibg=bg guifg=fg
    hi helpHyperTextEntry term=NONE cterm=NONE ctermbg=bg ctermfg=fg gui=NONE guibg=bg guifg=fg
    hi helpHyperTextJump term=NONE cterm=NONE ctermbg=bg ctermfg=fg gui=NONE guibg=bg guifg=fg
    hi helpNote term=NONE cterm=NONE ctermbg=bg ctermfg=fg gui=NONE guibg=bg guifg=fg
    hi helpOption term=NONE cterm=NONE ctermbg=bg ctermfg=fg gui=NONE guibg=bg guifg=fg
    hi rubyKeywordAsMethod term=NONE cterm=NONE ctermbg=bg ctermfg=fg gui=NONE guibg=bg guifg=fg
    hi podItalicAlternativeDelimOpen term=NONE cterm=NONE ctermbg=bg ctermfg=fg gui=NONE guibg=bg guifg=fg
    hi podNoSpaceOpen term=NONE cterm=NONE ctermbg=bg ctermfg=fg gui=NONE guibg=bg guifg=fg
    hi podNoSpaceAlternativeDelimOpen term=NONE cterm=NONE ctermbg=bg ctermfg=fg gui=NONE guibg=bg guifg=fg
    hi podIndexOpen term=NONE cterm=NONE ctermbg=bg ctermfg=fg gui=NONE guibg=bg guifg=fg
    hi podIndexAlternativeDelimOpen term=NONE cterm=NONE ctermbg=bg ctermfg=fg gui=NONE guibg=bg guifg=fg
    hi podBold term=NONE cterm=NONE ctermbg=bg ctermfg=fg gui=NONE guibg=bg guifg=fg
    hi podBoldAlternativeDelim term=NONE cterm=NONE ctermbg=bg ctermfg=fg gui=NONE guibg=bg guifg=fg
    hi podItalic term=NONE cterm=NONE ctermbg=bg ctermfg=fg gui=NONE guibg=bg guifg=fg
    hi podItalicAlternativeDelim term=NONE cterm=NONE ctermbg=bg ctermfg=fg gui=NONE guibg=bg guifg=fg
    hi pandocStrongEmphasisNestedDefinition term=NONE cterm=NONE ctermbg=bg ctermfg=fg gui=NONE guibg=bg guifg=fg
    hi pandocStrongEmphasisNestedHeading term=NONE cterm=NONE ctermbg=bg ctermfg=fg gui=NONE guibg=bg guifg=fg
    hi pandocStrongEmphasisNestedTable term=NONE cterm=NONE ctermbg=bg ctermfg=fg gui=NONE guibg=bg guifg=fg
    hi pandocStrongEmphasisTable term=NONE cterm=NONE ctermbg=bg ctermfg=fg gui=NONE guibg=bg guifg=fg
    hi pandocStyleDelim term=NONE cterm=NONE ctermbg=bg ctermfg=fg gui=NONE guibg=bg guifg=fg
    hi pandocSubscript term=NONE cterm=NONE ctermbg=bg ctermfg=fg gui=NONE guibg=bg guifg=fg
    hi pandocSubscriptDefinition term=NONE cterm=NONE ctermbg=bg ctermfg=fg gui=NONE guibg=bg guifg=fg
    hi pandocSubscriptHeading term=NONE cterm=NONE ctermbg=bg ctermfg=fg gui=NONE guibg=bg guifg=fg
    hi pandocSubscriptTable term=NONE cterm=NONE ctermbg=bg ctermfg=fg gui=NONE guibg=bg guifg=fg
    hi pandocSuperscript term=NONE cterm=NONE ctermbg=bg ctermfg=fg gui=NONE guibg=bg guifg=fg
    hi vimAutoCmdSpace term=NONE cterm=NONE ctermbg=bg ctermfg=fg gui=NONE guibg=bg guifg=fg
    hi vimAutoEventList term=NONE cterm=NONE ctermbg=bg ctermfg=fg gui=NONE guibg=bg guifg=fg
    hi vimAutoCmdSfxList term=NONE cterm=NONE ctermbg=bg ctermfg=fg gui=NONE guibg=bg guifg=fg
    hi vimPerlRegion term=NONE cterm=NONE ctermbg=bg ctermfg=fg gui=NONE guibg=bg guifg=fg
    hi Visual term=reverse cterm=NONE ctermbg=89 ctermfg=188 gui=NONE guibg=#7f073f guifg=#dcdccc
    hi vimMapRhs term=NONE cterm=NONE ctermbg=bg ctermfg=fg gui=NONE guibg=bg guifg=fg
    hi vimMapRhsExtend term=NONE cterm=NONE ctermbg=bg ctermfg=fg gui=NONE guibg=bg guifg=fg
    hi vimMenuBang term=NONE cterm=NONE ctermbg=bg ctermfg=fg gui=NONE guibg=bg guifg=fg
    hi perlBraces term=NONE cterm=NONE ctermbg=bg ctermfg=fg gui=NONE guibg=bg guifg=fg
    hi vimGlobal term=NONE cterm=NONE ctermbg=bg ctermfg=fg gui=NONE guibg=bg guifg=fg
    hi perlFakeGroup term=NONE cterm=NONE ctermbg=bg ctermfg=fg gui=NONE guibg=bg guifg=fg
    hi vimExtCmd term=NONE cterm=NONE ctermbg=bg ctermfg=fg gui=NONE guibg=bg guifg=fg
    hi vimFilter term=NONE cterm=NONE ctermbg=bg ctermfg=fg gui=NONE guibg=bg guifg=fg
    hi pythonSpaceError term=NONE cterm=NONE ctermbg=bg ctermfg=fg gui=NONE guibg=bg guifg=fg
    hi pythonAttribute term=NONE cterm=NONE ctermbg=bg ctermfg=fg gui=NONE guibg=bg guifg=fg
    hi vimMenuPriority term=NONE cterm=NONE ctermbg=bg ctermfg=fg gui=NONE guibg=bg guifg=fg
    hi pandocSuperscriptDefinition term=NONE cterm=NONE ctermbg=bg ctermfg=fg gui=NONE guibg=bg guifg=fg
    hi pandocSuperscriptHeading term=NONE cterm=NONE ctermbg=bg ctermfg=fg gui=NONE guibg=bg guifg=fg
    hi pandocSuperscriptTable term=NONE cterm=NONE ctermbg=bg ctermfg=fg gui=NONE guibg=bg guifg=fg
    hi pandocTable term=NONE cterm=NONE ctermbg=bg ctermfg=fg gui=NONE guibg=bg guifg=fg
    hi pandocTableStructure term=NONE cterm=NONE ctermbg=bg ctermfg=fg gui=NONE guibg=bg guifg=fg
    hi pandocTableZebraDark term=NONE cterm=NONE ctermbg=bg ctermfg=fg gui=NONE guibg=bg guifg=fg
    hi pandocTableZebraLight term=NONE cterm=NONE ctermbg=bg ctermfg=fg gui=NONE guibg=bg guifg=fg
    hi pandocTitleBlock term=NONE cterm=NONE ctermbg=bg ctermfg=fg gui=NONE guibg=bg guifg=fg
    hi pandocTitleBlockTitle term=NONE cterm=NONE ctermbg=bg ctermfg=fg gui=NONE guibg=bg guifg=fg
    hi pandocTitleComment term=NONE cterm=NONE ctermbg=bg ctermfg=fg gui=NONE guibg=bg guifg=fg
    hi rubyInterpolation term=NONE cterm=NONE ctermbg=bg ctermfg=fg gui=NONE guibg=bg guifg=fg
    hi vimMenuMap term=NONE cterm=NONE ctermbg=bg ctermfg=fg gui=NONE guibg=bg guifg=fg
    hi pandocTableStructre term=NONE cterm=NONE ctermbg=bg ctermfg=fg gui=NONE guibg=bg guifg=fg
    hi vimMenuRhs term=NONE cterm=NONE ctermbg=bg ctermfg=fg gui=NONE guibg=bg guifg=fg
    hi Warning term=NONE cterm=NONE ctermbg=bg ctermfg=205 gui=NONE guibg=bg guifg=#ff69b4
    hi vimPythonRegion term=NONE cterm=NONE ctermbg=bg ctermfg=fg gui=NONE guibg=bg guifg=fg
    hi vimNormCmds term=NONE cterm=NONE ctermbg=bg ctermfg=fg gui=NONE guibg=bg guifg=fg
    hi perlFiledescStatementNocomma term=NONE cterm=NONE ctermbg=bg ctermfg=fg gui=NONE guibg=bg guifg=fg
    hi perlFiledescStatementComma term=NONE cterm=NONE ctermbg=bg ctermfg=fg gui=NONE guibg=bg guifg=fg
    hi Folded term=NONE cterm=NONE ctermbg=248 ctermfg=51 gui=NONE guibg=#a9a9a9 guifg=#00ffff
    hi pandocVerbatimBlock term=NONE cterm=NONE ctermbg=bg ctermfg=fg gui=NONE guibg=bg guifg=fg
    hi pandocVerbatimInline term=NONE cterm=NONE ctermbg=bg ctermfg=fg gui=NONE guibg=bg guifg=fg
    hi pandocVerbatimInlineDefinition term=NONE cterm=NONE ctermbg=bg ctermfg=fg gui=NONE guibg=bg guifg=fg
    hi pandocVerbatimInlineHeading term=NONE cterm=NONE ctermbg=bg ctermfg=fg gui=NONE guibg=bg guifg=fg
    hi Question term=NONE cterm=bold ctermbg=bg ctermfg=46 gui=bold guibg=bg guifg=#00ff00
    hi StatusLine term=bold,reverse cterm=bold,reverse ctermbg=236 ctermfg=69 gui=bold,reverse guibg=#4c83ff guifg=#333333
    hi StatusLineNC term=reverse cterm=reverse ctermbg=234 ctermfg=239 gui=reverse guibg=#4d4d4d guifg=#1a1a1a
    hi VertSplit term=reverse cterm=reverse ctermbg=236 ctermfg=236 gui=reverse guibg=#333333 guifg=#333333
    hi Title term=bold cterm=bold ctermbg=bg ctermfg=201 gui=bold guibg=bg guifg=#ff00ff
    hi texMathMatcher term=NONE cterm=NONE ctermbg=bg ctermfg=fg gui=NONE guibg=bg guifg=fg
    hi VisualNOS term=bold,underline cterm=bold,underline ctermbg=bg ctermfg=fg gui=bold,underline guibg=bg guifg=fg
    hi WarningMsg term=NONE cterm=NONE ctermbg=bg ctermfg=196 gui=NONE guibg=bg guifg=#ff0000
    hi WildMenu term=NONE cterm=NONE ctermbg=226 ctermfg=16 gui=NONE guibg=#ffff00 guifg=#000000
    hi vimGroupList term=NONE cterm=NONE ctermbg=bg ctermfg=fg gui=NONE guibg=bg guifg=fg
    hi vimHiLink term=NONE cterm=NONE ctermbg=bg ctermfg=fg gui=NONE guibg=bg guifg=fg
    hi vimAuSyntax term=NONE cterm=NONE ctermbg=bg ctermfg=fg gui=NONE guibg=bg guifg=fg
    hi SignColumn term=NONE cterm=NONE ctermbg=250 ctermfg=51 gui=NONE guibg=#bebebe guifg=#00ffff
    hi vimClusterName term=NONE cterm=NONE ctermbg=bg ctermfg=fg gui=NONE guibg=bg guifg=fg
    hi helpVim term=NONE cterm=NONE ctermbg=bg ctermfg=fg gui=NONE guibg=bg guifg=fg
    hi hsImport term=NONE cterm=NONE ctermbg=bg ctermfg=fg gui=NONE guibg=bg guifg=fg
    hi hsImportLabel term=NONE cterm=NONE ctermbg=bg ctermfg=fg gui=NONE guibg=bg guifg=fg
    hi hsModuleName term=NONE cterm=NONE ctermbg=bg ctermfg=fg gui=NONE guibg=bg guifg=fg
    hi hsNiceOperator term=NONE cterm=NONE ctermbg=bg ctermfg=fg gui=NONE guibg=bg guifg=fg
    hi hsStatement term=NONE cterm=NONE ctermbg=bg ctermfg=fg gui=NONE guibg=bg guifg=fg
    hi hsString term=NONE cterm=NONE ctermbg=bg ctermfg=fg gui=NONE guibg=bg guifg=fg
    hi hsStructure term=NONE cterm=NONE ctermbg=bg ctermfg=fg gui=NONE guibg=bg guifg=fg
    hi hsType term=NONE cterm=NONE ctermbg=bg ctermfg=fg gui=NONE guibg=bg guifg=fg
    hi hsTypedef term=NONE cterm=NONE ctermbg=bg ctermfg=fg gui=NONE guibg=bg guifg=fg
    hi rubyNestedCurlyBraces term=NONE cterm=NONE ctermbg=bg ctermfg=fg gui=NONE guibg=bg guifg=fg
    hi rubyNestedAngleBrackets term=NONE cterm=NONE ctermbg=bg ctermfg=fg gui=NONE guibg=bg guifg=fg
    hi rubyNestedSquareBrackets term=NONE cterm=NONE ctermbg=bg ctermfg=fg gui=NONE guibg=bg guifg=fg
    hi rubyRegexpParens term=NONE cterm=NONE ctermbg=bg ctermfg=fg gui=NONE guibg=bg guifg=fg
    hi vimFiletype term=NONE cterm=NONE ctermbg=bg ctermfg=fg gui=NONE guibg=bg guifg=fg
    hi vimAugroup term=NONE cterm=NONE ctermbg=bg ctermfg=fg gui=NONE guibg=bg guifg=fg
    hi vimExecute term=NONE cterm=NONE ctermbg=bg ctermfg=fg gui=NONE guibg=bg guifg=fg
    hi vimFunction term=NONE cterm=NONE ctermbg=bg ctermfg=fg gui=NONE guibg=bg guifg=fg
    hi vimAugroupSyncA term=NONE cterm=NONE ctermbg=bg ctermfg=fg gui=NONE guibg=bg guifg=fg
    hi texMathZoneX term=NONE cterm=NONE ctermbg=bg ctermfg=fg gui=NONE guibg=bg guifg=fg
    hi texRefLabel term=NONE cterm=NONE ctermbg=bg ctermfg=fg gui=NONE guibg=bg guifg=fg
    hi texStatement term=NONE cterm=NONE ctermbg=bg ctermfg=fg gui=NONE guibg=bg guifg=fg
    hi vimCmdSep term=NONE cterm=NONE ctermbg=bg ctermfg=fg gui=NONE guibg=bg guifg=fg
    hi FoldColumn term=NONE cterm=NONE ctermbg=250 ctermfg=51 gui=NONE guibg=#bebebe guifg=#00ffff
    hi DiffAdd term=bold cterm=NONE ctermbg=16 ctermfg=46 gui=NONE guibg=#000000 guifg=#00ff00
    hi DiffChange term=bold cterm=NONE ctermbg=16 ctermfg=226 gui=NONE guibg=#000000 guifg=#ffff00
    hi DiffDelete term=bold cterm=bold ctermbg=16 ctermfg=196 gui=bold guibg=#000000 guifg=#ff0000
    hi DiffText term=reverse cterm=bold ctermbg=196 ctermfg=fg gui=bold guibg=#ff0000 guifg=fg
    hi vimIsCommand term=NONE cterm=NONE ctermbg=bg ctermfg=fg gui=NONE guibg=bg guifg=fg
    hi Conceal term=NONE cterm=NONE ctermbg=248 ctermfg=252 gui=NONE guibg=#a9a9a9 guifg=#d3d3d3
    hi SpellBad term=reverse cterm=undercurl ctermbg=bg ctermfg=fg gui=undercurl guibg=bg guifg=fg
	hi SpellCap term=reverse cterm=undercurl ctermbg=bg ctermfg=fg gui=undercurl guibg=bg guifg=fg


"	class ApiClient(object):
"
"	__metaclass__ = abc.ABCMeta
"
"	# Stores Playtech APIs against the attribute
"	# they should be accessed with
"	_registered = {}
"
"	def __init__(self, host, port=80, base_path='', ssl_ctx=None):
"		self.host = host
"		self.port = port
"		self.base_path = base_path
"		self.ssl_ctx = ssl_ctx
"
"	@property
"	def is_https(self):
"		return self.ssl_ctx is not None
"
"	@classmethod
"	def register(cls, name, api):
"		"""
"		Register a Playtech API to the class, so that it can be accessed as
"		an attribute with the given name.
"
"		i.e. once an `api` is registered with `name` then the action of the
"		`api` will be accessed by `self.name`.
"
"		Arguments:
"			name (string): attribute name to register
"			api (Api): Api class to register
"
"		Returns:
"			api (Api): Registered Api class
"		"""
"		assert name not in cls._registered, "attribute %r already exists" % name
"		assert issubclass(api, Api)
"
"		cls._registered[name] = api
"
"		return api
"
"	@abc.abstractmethod
"	def create(self, req):
"		pass
"
"	@abc.abstractmethod
"	def send(self, req):
"		pass
"
"	def uri(self, req):
"		query = [
"			(name, value)
"			for name, values in req.query.iteritems()
"			if values is not None
"			for value in values
"		]
"
"		uri = urlparse.urlunsplit(urlparse.SplitResult(
"			scheme='https' if self.is_https else 'http',
"			netloc='%s:%d' % (self.host, self.port),
"			path=urlparse.urljoin(self.base_path, req.path),
"			query=urllib.urlencode(query),
"			fragment='',
"		))
"
"		return uri
"
"	def do(self, api):
"		prefix = 'playtech:%s' % type(api).__name__
"
"		with log_util.log_block_prefix(prefix):
"			req = self.create(api)
"
"			self.log_request(req)
"
"			resp = self.send(req)
"
"			if utils.is_future(resp):
"				decoded = utils.Future()
"
"				@log_util.log_prefix(prefix)
"				def _decode(ft):
"					try:
"						exc_info = ft.exc_info()
"
"						if exc_info is None:
"							response = ft.result()
"							self.log_response(response)
"
"							decoded.set_result(api.process(response))
"
"						else:
"							decoded.set_exc_info(exc_info)
"
"					# catch all the exceptions and reraise when
"					# the future is used.
"					except: # pylint: disable=bare-except
"						decoded.set_exc_info(sys.exc_info())
"
"				resp.add_done_callback(_decode)
"
"			else:
"				self.log_response(resp)
"				decoded = api.process(resp)
"
"			return decoded
"
"	def log_request(self, req):
"		# pylint: disable=no-self-use
"		log.info("sending request: %r", req)
"
"	def log_response(self, resp):
"		# pylint: disable=no-self-use
"		log.info("received response: %r", resp)
"
"	def __getattr__(self, name):
"		"""
"		This is overridden so that registered Apis can be accessed
"		by attribute on this class.
"
"		`self.name(*args, **kwargs)` will construct and call the Api registered
"		as `name`.
"
"		If the name isn't registered, this will act as usual.
"		"""
"		if name in self._registered:
"
"			def _do(*args, **kwargs):
"				a = api(*args, **kwargs)
"				return self.do(a)
"
"			api = self._registered[name]
"			return _do
"
"		else:
"			raise AttributeError(
"				"%r object has no attribute %r" % (
"					self.__class__.__name__,
"					name,
"				)
"			)
"
"
"class Api(object):
"
"	__metaclass__ = abc.ABCMeta
"
"	def __init__(self, **data):
"		self.data = self.params(**data)
"		self.validate()
"
"	@abc.abstractproperty
"	def method(self):
"		"""
"		Gets the accepted HTTP method for this API.
"		It could also return non-standard methods if the
"		server allows them.
"		"""
"		return 'GET'
"
"	@abc.abstractproperty
"	def path(self):
"		"""
"		Composes the resource path. In a RESTful API the path could
"		contain variable parameters to identify the resource
"		(i.e. `/image/{id}`), these parameters MUST be injected in
"		the path in this property.
"
"		Returns:
"			str: resource's path.
"		"""
"		# TODO support a list of path parts that will be joined in the client
"		return '/'
"
"	params = utils.NoParams
"
"	@abc.abstractproperty
"	def headers(self):
"		"""
"		Creates the header needed by this API call.
"		It MUST return only the headers specified in the API
"		(e.g. ``max-age`` shouldn't be defined in this property).
"
"		Returns:
"			dict: contains all the headers as list of values
"				(i.e. ``{'Accept-Language': ['en-GB', 'en-US']}``).
"		"""
"		return {
"			'Accept': [self.accept],
"			'Content-Type': [self.content_type],
"		}
"
"	@property
"	def query(self):
"		"""
"		Creates the query for the request's URI.
"
"		Returns:
"			dict: contains all the queries parameters as list of values
"				(i.e. ``{'name': ['john', 'doe']}``).
"		"""
"		return {}
"
"	def validate(self):
"		"""
"		Validates the request and yields all the errors in the requests.
"		"""
"		# pylint: disable=no-self-use
"		while 0:
"			yield
"
"	@abc.abstractproperty
"	def accept(self):
"		"""
"		Gets the content types acceptable for the response.
"
"		Returns:
"		"""
"		return ''
"
"	@abc.abstractproperty
"	def content_type(self):
"		"""
"		Gets the content type to use for this request. An API
"		can accept different content types but only one must
"		be chosen before making the request.
"
"		Returns:
"			str: MIME template for the content type.
"		"""
"		return ''
"
"	@property
"	def body(self):
"		return None
"
"	def process(self, resp):
"		# pylint: disable=no-self-use,unused-argument
"		return None
"
"
"	class PlaytechApiClient(ApiClient):
"	# pylint: disable=too-few-public-methods
"	pass

"	def _register(api):
"		PlaytechApiClient.register(name, api)
"		return api
"
"	return _register
"
"
"class PlaytechAuth(types.Record):
"	"""
"	Contains all the information used to identify the customer and
"	authorise their request.
"
"	Arguments:
"		username (str): customer's username.
"		casino (str): customer's casino.
"		session_token (str or None): auth token (optional).
"	"""
"	# pylint: disable=too-few-public-methods
"
"	username = str
"	casino = str
"	session_token = types.OptionalNullable(str)
"
"
"class PymTxnApi(Api):
"	"""
"	Base class for all the *Playtech PymTxn API*.
"
"	All the APIs supports only `application/xml` content types.
"	They expect an auth layer as defined in `PlaytechAuth`, these
"	information are used in the property `headers` to update the final
"	headers dictionary.
"
"	The common error handling is done in `process`, if no error occurs
"	it will parse the body and return a `lxml.objectify.Element`.
"	"""
"
"	accept = content_type = utils.MIME_APP_XML
"
"	@property
"	def headers(self):
"		headers = super(PymTxnApi, self).headers
"
"		headers.update({
"			'X-Identity-Type': ['PlayerIdentityByCasinoAndUsername'],
"			'X-Player-Username': [self.data.username],
"			'X-Casinoname': [self.data.casino],
"			'X-Auth-Type': ['AuthenticationBySessionToken'],
"			'X-Auth-Session-Token': [self.data.session_token],
"			'X-Message-Id': [str(uuid.uuid4())],
"		})
"
"		return headers
"
"	@abc.abstractmethod
"	def process(self, resp):
"		# TODO use buffer
"		if resp.body:
"			try:
"				root = objectify.fromstring(resp.body)
"
"			except etree.XMLSyntaxError as err:
"				log.debug("response is not a valid XML document")
"				root = None
"
"			else:
"				log.debug("received object: %r", root.tag)
"
"		else:
"			root = None
"
"		if not utils.is_2xx(resp.code):
"			err = errors.create_error(resp.code, root)
"			log.info("received an error: %r", err)
"
"			raise err
"
"		return root
"
"
"class PymTransactionApi(PymTxnApi):
"
"	def process(self, resp):
"		txn = super(PymTransactionApi, self).process(resp)
"
"		return txn
"
"
"@register('withdraw')
"class Withdraw(PymTransactionApi):
"
"	method = 'POST'
"
"	@property
"	def path(self):
"		return '/product/ums/service/pymtransactions/operation'\
"			'/CreateWithdrawRequest'
"
"	class params(PlaytechAuth):
"
"		no_player_msg_to_gs = bool
"		amount = Amount
"		ccy_code = str
"		method_code = str
"		remote_withdraw_id = str
"
"	@property
"	def body(self):
"
"		nsmap = OrderedDict([("ns2", NS_COMMON), ("ns3", NS_PYMTRANS)])
"
"		payments = etree.Element(
"			'{%s}createWithdrawRequest' % NS_PYMTRANS, nsmap=nsmap
"		)
"
"		no_player_msg_to_gs = etree.SubElement(
"			payments, '{%s}noPlayermessageToGs' % NS_PYMTRANS, nsmap=nsmap
"		)
"		no_player_msg_to_gs.text = str(self.data.no_player_msg_to_gs)
"
"		amount = etree.SubElement(
"			payments, '{%s}amount' % NS_PYMTRANS, nsmap=nsmap
"		)
"		common_amount = etree.SubElement(
"			amount, '{%s}amount' % NS_COMMON, nsmap=nsmap
"		)
"		common_amount.text = str(self.data.amount)
"
"		ccy_code = etree.SubElement(
"			amount, '{%s}currencyCode' % NS_COMMON, nsmap=nsmap
"		)
"		ccy_code.text = str(self.data.ccy_code)
"
"		method_code = etree.SubElement(
"			payments, '{%s}methodCode' % NS_PYMTRANS, nsmap=nsmap
"		)
"		method_code.text = self.data.method_code
"
"		remote_withdraw_id = etree.SubElement(
"			payments, '{%s}remoteWithdrawId' % NS_PYMTRANS, nsmap=nsmap
"		)
"		remote_withdraw_id.text = str(self.data.remote_withdraw_id)
"
"		return etree.tostring(payments, xml_declaration=True, encoding='utf-8')
"
"
"@register('approve_withdraw')
"class ApproveWithdraw(PymTransactionApi):
"
"	method = 'POST'
"
"	path = '/product/ums/service/pymtransactions/operation/approveWithdrawRequest'
"
"	class params(PlaytechAuth):
"
"		local_withdraw_id = str
"
"	@property
"	def body(self):
"
"		nsmap = OrderedDict([("ns14", NS_PYMTRANS), ("ns27", NS_COMMON)])
"
"		payments = etree.Element(
"			'{%s}approveWithdrawRequest' % NS_PYMTRANS, nsmap=nsmap
"		)
"
"		local_id = etree.SubElement(
"			payments, '{%s}localWithdrawId' % NS_PYMTRANS, nsmap=nsmap
"		)
"		local_id.text = str(self.data.local_withdraw_id)
"
"		return etree.tostring(payments, xml_declaration=True, encoding='utf-8')
"
"
"@register('cancel_withdraw')
"class CancelWithdraw(PymTransactionApi):
"
"	method = 'POST'
"
"	path = '/product/ums/service/pymtransactions/operation/cancelWithdrawRequest'
"
"	class params(PlaytechAuth):
"
"		remote_withdraw_id = str
"		local_withdraw_id = str
"		cancel_all = bool
"
"	@property
"	def body(self):
"
"		nsmap = OrderedDict([("ns14", NS_PYMTRANS), ("ns27", NS_COMMON)])
"
"		payments = etree.Element(
"			'{%s}cancelWithdrawRequest' % NS_PYMTRANS, nsmap=nsmap
"		)
"
"		message_id = etree.SubElement(
"			payments, '{%s}remoteWithdrawId' % NS_PYMTRANS, nsmap=nsmap
"		)
"		message_id.text = str(self.data.remote_withdraw_id)
"
"		cancel_all = etree.SubElement(
"			payments, '{%s}cancelAllWithdrawals' % NS_PYMTRANS, nsmap=nsmap
"		)
"		cancel_all.text = str(self.data.cancel_all)
"
"		local_id = etree.SubElement(
"			payments, '{%s}localWithdrawId' % NS_PYMTRANS, nsmap=nsmap
"		)
"		local_id.text = str(self.data.local_withdraw_id)
"
"		return etree.tostring(payments, xml_declaration=True, encoding='utf-8')
"
"
"@register('transaction_history')
"class GetTransactionHistory(api.UMSApi):
"
"	method = 'POST'
"
"	path = '/product/ums/service/pymtransactions/operation/getTransactionHistoryRequest'
"
"	accept = content_type = utils.MIME_APP_XML
"
"	class params(ums_types.HeaderTypes):
"
"		start_time = types.OptionalNullable(datetime)
"		end_time = types.OptionalNullable(datetime)
"		total_count = types.OptionalNullable(bool)
"		page_size = types.OptionalNullable(int)
"		page_id = types.OptionalNullable(int)
"		return_all_page_ids = types.OptionalNullable(bool)
"		trans_type = types.Enum(const.TYPE_DEPOSIT, const.TYPE_WITHDRAW)
"		remote_transaction_id = types.OptionalNullable(str)
"		status = types.Enum(
"			const.STATUS_PENDING,
"			const.STATUS_WAITING,
"			const.STATUS_APPROVED,
"			const.STATUS_DECLINED,
"			const.STATUS_CANCELLED
"		)
"
"	response_schema = schema.GET_TXN_HISTORY_RESP_SCHEMA
"
"	def process(self, resp):
"		resp = super(GetTransactionHistory, self).process(resp)
"
"		remote_txns = [
"			RemoteTxn(
"				status=txn['status'],
"				type=txn['type'],
"				method_code=txn['method_code'],
"				remote_transaction_id=txn.get('remote_transaction_id'),
"				amount=txn['amount']['amount'],
"			)
"			for txn in resp.get('txns', {}).get('txns', [])
"		]
"		next_page_id = resp['page'].get('next_page_id')
"
"		return RemoteTxns(
"			txns=remote_txns,
"			next_page_id=next_page_id,
"		)
"
"	@property
"	def body(self):
"
"		nsmap = OrderedDict([('ns8', NS_PYMTRANS), ('ns2', NS_COMMON)])
"
"		transactionreq = etree.Element(
"			'{%s}getTransactionHistoryRequest' % NS_PYMTRANS, nsmap=nsmap
"		)
"
"		trans_type = etree.SubElement(
"			transactionreq, '{%s}type' % NS_PYMTRANS, nsmap=nsmap
"		)
"		trans_type.text = str(self.data.trans_type)
"
"		if self.data.start_time is not None:
"			start_time = etree.SubElement(
"				transactionreq, '{%s}startTime' % NS_PYMTRANS, nsmap=nsmap
"			)
"			start_time.text = self.data.start_time.strftime("%Y-%m-%d %H:%M:%S")
"
"		if self.data.end_time is not None:
"			end_time = etree.SubElement(
"				transactionreq, '{%s}endTime' %  NS_PYMTRANS, nsmap=nsmap
"			)
"			end_time.text = self.data.end_time.strftime("%Y-%m-%d %H:%M:%S")
"
"		if self.data.remote_transaction_id is not None:
"			remote_transaction_id = etree.SubElement(
"				transactionreq, '{%s}remoteTransactionId' % NS_PYMTRANS, nsmap=nsmap
"			)
"			remote_transaction_id.text = str(self.data.remote_transaction_id)
"
"		status = etree.SubElement(
"			transactionreq, '{%s}status' % NS_PYMTRANS, nsmap=nsmap
"		)
"		status.text = str(self.data.status)
"
"		paging_params= etree.SubElement(
"			transactionreq, '{%s}pagingRequestParams' %  NS_PYMTRANS, nsmap=nsmap
"		)
"
"		if self.data.total_count is not None:
"			total_count = etree.SubElement(
"				paging_params, '{%s}returnTotalCount' %  NS_COMMON, nsmap=nsmap
"			)
"			total_count.text = str(self.data.total_count)
"
"		if self.data.page_size is not None:
"			page_size = etree.SubElement(
"				paging_params, '{%s}pageSize' %  NS_COMMON, nsmap=nsmap
"			)
"			page_size.text = str(self.data.page_size)
"
"		if self.data.page_id is not None:
"			page_id = etree.SubElement(
"				paging_params, '{%s}pageId' %  NS_COMMON, nsmap=nsmap
"			)
"			page_id.text = str(self.data.page_id)
"
"		if self.data.return_all_page_ids is not None:
"			return_all_page_ids = etree.SubElement(
"				paging_params, '{%s}returnAllPageIds' %  NS_COMMON, nsmap=nsmap
"			)
"			return_all_page_ids.text = str(self.data.return_all_page_ids)
"
"		return etree.tostring(transactionreq, xml_declaration=True, encoding='utf-8')
"
