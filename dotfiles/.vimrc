" vim-notes
" in command-line mode
" % current filename, %:p current full filename

" ------------------------------- Basic ------------------------------------

" neccesary setup
set nocompatible
syntax on
set nobackup
set noswapfile
set clipboard=unnamedplus

set term=xterm-256color
set background=dark
au BufEnter *.wxml setlocal ft=html
au BufEnter *.wxss setlocal ft=css
au BufEnter * if &filetype == "" | setlocal ft=conf | endif

let tabIndentList = ["sh", "kotlin", "vim", "html", "css", "scss", "json", "javascript", "tex", "markdown", "toml", "vue"]
au BufWritePre * if index(tabIndentList, &ft) >= 0 | call Format("tab") | endif

" set noerrorbells visualbell t_vb=
" autocmd TabEnter * set visualbell t_vb=

" some command-line mode bindings, use ,: to enter : in command-line
cnoremap : w<space>!
cnoremap ,: :
let $BASH_ENV="~/.bash_aliases"

" use u to undo, U to redo for consistency
nnoremap U :redo<cr>

" move to line start and end quickly
nnoremap eh  ^
nnoremap el  $

" some leader bindings
let mapleader=","
nnoremap <leader>l gt
nnoremap <leader>h gT
nnoremap <leader>x :tabclose<cr>
nnoremap <leader>w :w<cr>
nnoremap <leader>q :tabfirst<cr>:tabonly<cr><c-z>

nnoremap <leader>t :YcmCompleter GoTo<cr>

" cross display
au VimEnter,WinEnter,BufWinEnter * setlocal cursorline cursorcolumn
au WinLeave * setlocal nocursorline nocursorcolumn
hi Cursorline cterm=NONE ctermbg=235
hi Cursorcolumn cterm=NONE ctermbg=235
hi CursorLineNr cterm=NONE ctermbg=235
au FileType tagbar setlocal nocursorline nocursorcolumn

" status line
set laststatus=2
set statusline=
set statusline+=%1*\ %<\ %F
set statusline+=%1*\ %m%r
" set statusline+=%1*\ %50(\ %)   "padding    %1*\  is a group for hi User1 cterm=102
" set statusline+=%2*\ %10{getcwd()}
set statusline+=%=                                "separator between left and right
set statusline+=%1*\ %-20((%P)%L\ \ %5l,%-3c%)

" status line and vertical border
set fillchars+=vert:\  "there must be a trailling blank at the end
hi User1 ctermfg=102 ctermbg=235
hi User2 ctermfg=166 ctermbg=235
hi VertSplit ctermfg=235
hi StatusLine ctermfg=235
hi StatusLine ctermbg=235
hi StatusLineNC ctermfg=235
hi StatusLineNC ctermbg=235

" sign column
hi SignColumn ctermbg=235

" tab line
hi TabLineFill ctermfg=235
hi TabLine cterm=bold ctermbg=235 ctermfg=30
hi TabLineSel ctermfg=28

" visual mode
hi Visual ctermbg=166

" pop-up menu
hi Pmenu ctermbg=235 ctermfg=173
hi PmenuSel ctermbg=237 ctermfg=173
hi PmenuSbar ctermbg=235
hi PmenuThumb ctermbg=237

" change cursor color in different modes
let &t_SI="\<Esc>]12;green\x7"
let &t_EI="\<Esc>]12;purple\x7"

" line number
set number
set numberwidth=4
set ruler

" tab
set smarttab
set expandtab
set tabstop=4
set softtabstop=4
set shiftwidth=4

" indent
set smartindent
set autoindent
set backspace=indent,eol,start
set showcmd
set showmode
set showmatch

" search
set incsearch
set hlsearch
nnoremap <space> :nohlsearch<cr>
set ignorecase
set smartcase
set isk+=-

" wrap
set wrap
set wrapmargin=0
set linebreak
set nolist
set textwidth=0

" force wrap when vimdiff
autocmd FilterWritePre * if &diff | setlocal wrap< | endif

" conceal
set conceallevel=2
hi Conceal ctermbg=NONE

" misc
set confirm
set cmdheight=1

"turn off smartindent for typing '#', see :h smartident"
inoremap # X#

" encoding
set encoding=utf-8
set fileencoding=utf-8
set fileencodings=ucs-bom,utf-8
set scrolloff=3

" bind <esc> to hl in Insert mode and Visual
inoremap hl <esc>
vnoremap hl <esc>
" unmap <esc> to adapt to hl movement
" inoremap <esc> <nop>
" vnoremap <esc> <nop>

" to move in long lines
nnoremap j  gj
nnoremap k  gk
nnoremap <C-h>  zH
nnoremap <C-l>  zL

" change bindings for moving between windows
nnoremap J  <C-w>j
nnoremap K  <C-w>k
nnoremap H  <C-w>h
nnoremap L  <C-w>l

" change bindings for joining lines
nnoremap M  :join<cr>
vnoremap M  :join<cr>
nnoremap S  :call MHF_Split()<cr>

" set colorcolumn=85

" ------------------------------- Plug ------------------------------------
call plug#begin('~/.vim/bundle')

Plug 'ycm-core/YouCompleteMe'
Plug 'scrooloose/nerdtree'
Plug 'jistr/vim-nerdtree-tabs'
Plug 'scrooloose/nerdcommenter'
Plug 'ctrlpvim/ctrlp.vim'
Plug 'dense-analysis/ale'
Plug 'majutsushi/tagbar'
Plug 'kshenoy/vim-signature'
Plug 'junegunn/vim-easy-align'
Plug 'mhf-air/auto-pairs'

Plug 'tpope/vim-dadbod'
Plug 'kristijanhusak/vim-dadbod-ui'

Plug 'mhf-air/vim-u'
Plug 'rust-lang/rust.vim'
Plug 'maxmellon/vim-jsx-pretty'
Plug 'mhf-air/vim-vue'
Plug 'digitaltoad/vim-pug'

" Plug 'fatih/vim-go'
" Plug 'lervag/vimtex'
" Plug 'xuhdev/vim-latex-live-preview', { 'for': 'tex' }

call plug#end()
filetype indent off
" ------------------------------- Plugin ------------------------------------

" disable automatic comment insertion, must put after filetype plugin on
au FileType * setlocal fo-=c fo-=r fo-=o

" dbui
" run :DBUI to open db-list, press o to open a db, press R to refresh db,
" press <cr> on 'New query', write query on left window, save file to run query
" run :qa to quit vim
let g:dbs = [
\ { 'name': 'dev-db', 'url': 'postgresql://mhf:mhf@localhost/mhf' },
\ { 'name': 'dev-redis', 'url': 'redis://localhost:6379' },
\
\ { 'name': 'production-db', 'url': 'postgresql://mhf:mhf@localhost/mhf' },
\ { 'name': 'production-redis', 'url': 'redis://localhost:6379' },
\]
let g:db_ui_win_position = 'right'
let g:db_ui_auto_execute_table_helpers = 1
let g:db_ui_force_echo_notifications = 1
let g:db_ui_disable_mappings = 1
autocmd FileType dbui nmap <buffer> o <Plug>(DBUI_SelectLine)
autocmd FileType dbui nmap <buffer> <cr> <Plug>(DBUI_SelectLine)
autocmd FileType dbui nmap <buffer> d <Plug>(DBUI_DeleteLine)
autocmd FileType dbui nmap <buffer> R <Plug>(DBUI_Redraw)
autocmd FileType dbui set previewheight=24
autocmd FileType dbout set nofoldenable

" auto-pairs
let g:AutoPairs = {'(':')', '[':']', '{':'}','"':'"', '|':'|'}
let g:AutoPairsCenterLine = 0
let g:AutoPairsMultilineClose = 0

" vim-vue
" To disable pre-processor languages altogether (only highlight HTML, JavaScript, and CSS)
let g:vue_pre_processors = ["pug", "stylus"]

" tex
let g:tex_flavor = 'latex'
let g:tex_conceal = 'abdmg'

" latex-live-preview
let g:livepreview_engine = 'lualatex'
let g:livepreview_previewer = 'zathura'
let g:livepreview_cursorhold_recompile = 0

" rust
let g:rustfmt_autosave=1
let g:rustfmt_fail_silently=1

" nerdtree
let NERDTreeWinPos="right"
" let NERDTreeCaseSensitiveSort=1
let NERDTreeSortOrder=['\/$', '^\l', '*', '\.swp$',  '\.bak$', '\~$']
let NERDTreeIgnore=['\~$', '^zz-']
" let NERDTreeMapToggleFilters='I' " not working
" nerdtree-tabs
map <leader>n <plug>NERDTreeTabsToggle<cr>

" nerdcommenter
let g:NERDSpaceDelims=1
let g:NERDCommentEmptyLines=1
let g:NERDTrimTrailingWhitespace=1
" let g:NERDCompactSexyComs=1
let g:NERDCustomDelimiters = {
	\ 'c': { 'left': '//', 'leftAlt': '/*', 'rightAlt': '*/' },
	\ 'u': { 'left': '//', 'leftAlt': '/*', 'rightAlt': '*/' },
	\ 'kotlin': { 'left': '//', 'leftAlt': '/*', 'rightAlt': '*/' },
	\ 'python': { 'left': '#', 'leftAlt': '"""', 'rightAlt': '"""' },
	\ 'vue': { 'left': '//', 'leftAlt': '/*', 'rightAlt': '*/' },
\ }

" ctrlp
let g:ctrlp_map='<leader>p'
let g:ctrlp_cmd='CtrlP'
let g:ctrlp_use_caching=1
" let g:ctrlp_by_filename = 1
let g:ctrlp_regexp = 1
let g:ctrlp_clear_cache_on_exit=1
let g:ctrlp_prompt_mappings = {
	\ 'PrtSelectMove("j")':   ['<s-tab>'],
	\ 'PrtSelectMove("k")':   ['<tab>'],
	\ 'AcceptSelection("t")': ['<cr>'],
	\ 'PrtClearCache()':      ['<F5>'],
	\ 'AcceptSelection("e")': ['<2-LeftMouse>'],
	\ 'ToggleFocus()':        ['<c-j>'],
	\ 'PrtExpandDir()':       ['<c-k>'],
	\ }
let g:ctrlp_custom_ignore = {
	\'dir':'\v[\/](node_modules|platforms|plugins|target)$',
	\ }
	" \'func':'CtrlpIgnore',
" let g:ctrlp_user_command="fzf -e -f ''"
" let g:ctrlp_user_command="find %s -type f"

function! CtrlpIgnore(item, type) abort
	let m = {
	  \ "node_modules": "",
	  \ "platforms": "",
	  \ "plugins": "",
	  \ "target": "",
	\ }
	let cwdLen = len(getcwd()) + 1
	if (a:type == "dir")
		if has_key(m, a:item[cwdLen:])
			return 1
		endif
	endif
	return 0
endfunction

" vim-go
let g:go_highlight_functions=1
let g:go_highlight_methods=1
let g:go_highlight_structs=1
let g:go_highlight_interfaces=1
let g:go_highlight_operators=1
let g:go_highlight_build_constrants=1
let g:go_echo_go_info = 0
let g:go_gocode_unimported_packages=1
let g:go_fmt_command='goimports'
" let g:go_fmt_autosave=0

" tagbar
let g:tagbar_left=1
let g:tagbar_width=30
let g:tagbar_iconchars=['▸', '▾']
" au FileType go nested :TagbarOpen
au FileType u,rust,go,java,c nested call ResizeTagbar()
au VimResized *.u,*.rs,*.go,*.c call ResizeTagbar()
let g:tagbar_type_javascript = {
	\ 'ctagstype' : 'javascript',
	\ 'kinds' : [
		\'a:const',
		\'b:let',
		\'d:var',
		\'e:function',
		\'h:class',
	\],
	\ 'sro' : '.',
	\ 'kind2scope' : {
		\ 't' : 'ctype',
		\ 'n' : 'ntype'
	\ },
	\ 'scope2kind' : {
		\ 'ctype' : 't',
		\ 'ntype' : 'n'
	\ },
\}

" ycm
set completeopt -=preview
set completeopt=longest,menu
let g:ycm_collect_identifiers_from_comments_and_strings=1
let g:ycm_goto_buffer_command='new-or-existing-tab'
let g:ycm_enable_diagnostic_signs=0
let g:ycm_enable_diagnostic_highlighting=0
let g:ycm_echo_current_diagnostic=0
let g:ycm_python_binary_path='python3'
let g:ycm_global_ycm_extra_conf='~/c/.ycm_extra_conf.py'
let g:ycm_auto_hover=''

" if ycm's rust-analyzer has errors, do the following
" the toolchain root path is `rustc --print sysroot`
" download the latest binary: https://github.com/rust-analyzer/rust-analyzer/releases
" extract the binary rust-analyzer
" cd `rustc --print sysroot`
" mv ~/download/rust-analyzer bin/rust-analyzer
" chmod +x bin/rust-analyzer
" let g:ycm_rust_toolchain_root='/home/mhf/.rustup/toolchains/stable-x86_64-unknown-linux-gnu'

" \       'cmdline': [ 'u-analyzer', '--no-log-buffering', '--log-file', '/tmp/u' ],
let g:ycm_language_server = [
\   {
\       'name': 'u',
\       'filetypes': [ 'u' ],
\       'cmdline': [ 'u-analyzer' ],
\       'project_root_files': [ 'u.toml' ],
\   }
\]

if !exists('g:ycm_semantic_triggers')
	let g:ycm_semantic_triggers = {}
endif
let g:ycm_semantic_triggers.u = ['.']

" ale
" let g:ale_sign_column_always = 1
" let g:ale_set_highlights = 0
let g:ale_set_loclist = 0
hi ALEErrorSign ctermbg=235 ctermfg=red
hi ALEWarningSign ctermbg=235 ctermfg=190
let g:ale_lint_on_text_changed = "never"
let g:ale_linters = {
\   "u":["u"],
\   "go":["go build", "gometalinter"],
\   "c":[],
\   "javascript":[],
\   "kotlin":[],
\   "java":[],
\   "vue":[],
\}
let ale_go_gometalinter_options="
\ --disable=golint
\ --disable=errcheck
\"
let ale_python_pylint_executable="python $(which pylint3)"
let ale_python_pylint_options="
\ -d bad-indentation
\ -d no-self-argument
\ -d invalid-name
\ -d missing-docstring
\ -d too-few-public-methods
\"
let g:ale_c_parse_compile_commands=1

" ---------------------------- Language Specific ------------------------------

" go
augroup go
	autocmd!
	au FileType go nnoremap <buffer> <leader>r :w !go run %<cr>
	au FileType go setlocal expandtab
augroup END

" kotlin
augroup kotlin
	autocmd!
	au BufRead *.kt nnoremap <buffer> <leader>r :w !kotlinc % -include-runtime -d /tmp/kt.jar && java -jar /tmp/kt.jar<cr>
	au BufWritePre *.kt call Format("kt")
	au BufRead *.kt setlocal expandtab
augroup END

" rust
augroup rust
	autocmd!
	au FileType rust nnoremap <buffer> <leader>r :w !echo && RUST_BACKTRACE=1 cargo run<cr>
	au FileType rust setlocal expandtab
augroup END

" u
augroup u
	autocmd!
	au FileType u nnoremap <buffer> <leader>r :w !echo && RUST_BACKTRACE=1 u run<cr>
	au FileType u setlocal expandtab

	au BufWritePre *.u call Format("u")

	" align struct and where fields, gap is 3 spaces
	au FileType u nnoremap <leader>{ vi{:EasyAlign l2<cr><space>
	au FileType u nnoremap <leader>( vi(:EasyAlign l2<cr><space>
	let g:easy_align_ignore_groups = ['String', 'Comment', 'uComment', 'uString', 'uAttr']

	" au FileType u setlocal foldmethod=marker
	" au FileType u setlocal fmr={,}
	" au FileType u setlocal foldlevel=99
	" au FileType u setlocal foldopen=block,mark,percent,quickfix,search,tag,undo

	au FileType u setlocal foldmethod=expr
	au FileType u setlocal foldexpr=FoldTopImport()
	au FileType u setlocal foldclose=all
augroup END

" sh
augroup sh
	autocmd!
	au BufRead *.sh nnoremap <buffer> <leader>r :w !bash %<cr>
augroup END

" llvm ir
augroup llvm
	autocmd!
	au BufRead *.ll nnoremap <buffer> <leader>r :w !lli %<cr>
augroup END

" node.js
augroup node
	autocmd!
	au BufRead *.js nnoremap <buffer> <leader>r :w !node %<cr>
	" au BufWritePre *.js call Format("js")
	au BufRead *.js setlocal expandtab
augroup END

" html
augroup html
	autocmd!
	" au BufWritePre *.html call Format("html")
augroup END

" css
augroup css
	autocmd!
	" au BufWritePre *.css call Format("css")
augroup END

" vue
augroup vue
	autocmd!
	au FileType vue setlocal nowrap
	au BufRead *.vue call OpenVueVsp()
	au BufRead,BufWritePost *.vue syntax sync fromstart
	" vim regex lookbehind (atom)\@<=
	au BufRead,BufWritePost *.vue call matchadd('Conceal', '\(\s\)\@<=style=".\{-}"', 0, -1, {'conceal': '.'})
augroup END

" c
augroup c
	autocmd!
	au FileType c,c++ setlocal isk-=-
	" au BufRead *.c nnoremap <buffer> <leader>r :w !gcc % -o /tmp/c-compiled-random-string && /tmp/c-compiled-random-string<cr>
	au BufRead *.c nnoremap <buffer> <leader>r :w !clang % -o /tmp/c-compiled-random-string && /tmp/c-compiled-random-string<cr>
	au BufRead *.c setlocal expandtab
	au BufWritePre *.c call Format("c")
	au BufRead,BufNewFile *.h set filetype=c
augroup END

" python
augroup python
	autocmd!
	au BufRead *.py nnoremap <buffer> <leader>r :w !python3 %<cr>
	" au FileType python setlocal expandtab cindent
	au FileType python setlocal expandtab
	au FileType python setlocal ts=4 sw=4 sts=4
	" because somehow yapf doesn't change spaces to tabs
	au BufWritePre *.py call Format("tab")
augroup END

" -------------------------------  tagbar  ------------------------------------
" resize tagbar according to main window's size
function! ResizeTagbar()
	" debug
	" echom winwidth(0).":".winwidth(1)
	if winwidth(0) < 100
	  execute "TagbarClose"
	else
	  execute "TagbarOpen"
	endif
endfunction

" ----------------------------------------------------------------------
function! OpenVueVsp()
 if winnr("$") > 1
	return
 endif
 execute "vsp"
 execute "silent! normal! \<C-W>l/<script\rztj\<C-W>h"
endfunction

" ----------------------   toggle max split window   --------------------------
nnoremap <leader>z :call ToggleMaxWindows()<cr>
" now only supports 2 windows, and I don't think it's necessary to support
" more windows
function! ToggleMaxWindows()
	if exists("t:maximize_session")
		execute "vsp"
		execute "normal! \<C-W>l"
		call winrestview(t:maximize_session)
		execute "normal! \<C-W>h"
		if t:curw == 2
			execute "normal! \<C-W>L"
		endif
		unlet t:maximize_session
		unlet t:curw
	else
		if winnr("$") != 2
			return
		endif
		let t:curw = winnr()
		if t:curw == 1
			execute "normal! \<C-W>l"
			let t:maximize_session = winsaveview()
			execute "normal! \<C-W>h"
		else
			execute "normal! \<C-W>h"
			let t:maximize_session = winsaveview()
			execute "normal! \<C-W>l"
		endif
		only
	endif
endfunction

" -------------------------------    fmt   ------------------------------------
function! Format(arg)

	if a:arg == "u"
		let l:cmd = "u u-fmt"
	elseif a:arg == "tab"
		let l:cmd = "tab-indent --tab-width=4 --inplace --input"
	elseif a:arg == "js"
		let l:cmd = "js-beautify -r -n -t -m 2 -k -b collapse,preserve-inline"
	elseif a:arg == "go"
		let l:cmd = "goimports -w"
	elseif a:arg == "py"
		let l:cmd = "yapf -i -p --style='{
				\ based_on_style: google,
				\ blank_line_before_nested_class_or_def: False,
				\ blank_lines_around_top_level_definition: 1,
				\ use_tabs: 1,
			\ }'"
	elseif a:arg == "c"
		let l:cmd = "clang-format -i -style='{
				\ BasedOnStyle: Google,
				\ TabWidth: 4,
				\ IndentWidth: 4,
				\ UseTab: ForContinuationAndIndentation,
				\ AlignOperands: false,
				\ AllowAllArgumentsOnNextLine: false,
				\ AllowAllParametersOfDeclarationOnNextLine: false,
				\ AlwaysBreakBeforeMultilineStrings: false,
				\ PenaltyBreakAssignment: 21,
			\ }' -sort-includes=false"
	elseif a:arg == "kt"
		let l:cmd = "ktlint -F"
	elseif a:arg == "html"
		let l:cmd = "js-beautify --html -r -n -t -m 2"
	elseif a:arg == "css"
		let l:cmd = "js-beautify --css -r -n -t"
	endif

	let l:curw = winsaveview()

	" Write current unsaved buffer to a temp file
	let l:tmpname = tempname()
	call writefile(getline(1, '$'), l:tmpname)
	call system(l:cmd ." ". l:tmpname)

	try | silent undojoin | catch | endtry

	" Replace current file with temp file, then reload buffer
	let old_fileformat = &fileformat
	if exists("*getfperm")
		" save old file permissions
		let original_fperm = getfperm(expand('%'))
	endif
	call rename(l:tmpname, expand('%'))
	" restore old file permissions
	if exists("*setfperm") && original_fperm != ''
		call setfperm(expand('%'), original_fperm)
	endif
	silent edit!
	let &fileformat = old_fileformat
	let &syntax = &syntax

	call winrestview(l:curw)

	" Syntax highlighting breaks less often.
	syntax sync fromstart

endfunction

" --------------------------------- fold --------------------------------------
" augroup remember_folds
	" autocmd!
	" autocmd BufWritePost *
	" \   if expand('%') != '' && &buftype !~ 'nofile'
	" \|      mkview
	" \|  endif
	" autocmd BufRead *
	" \   if expand('%') != '' && &buftype !~ 'nofile'
	" \|      silent loadview
	" \|  endif
" augroup END

hi Folded cterm=bold ctermbg=none ctermfg=166
hi FoldColumn cterm=bold ctermbg=235 ctermfg=166
set foldcolumn=0
set foldopen-=hor
set foldtext=MyFoldText()
function! MyFoldText()
	let indent_level = indent(v:foldstart)
	let indent = repeat(' ', indent_level)
	let text = substitute(getline(v:foldstart), '^\s*', '', '')
	let line = indent . text . repeat(" ", winwidth(0))
	return line
endfunction

function! FoldTopImport()
	let line = getline(v:lnum)
	let prev_line = getline(v:lnum-1)
	if match(line, '^import\s*{$') >= 0
		return 1
	elseif match(prev_line, '^}$') >= 0
		return 0
	else
		return "="
endfunction

" this solution is a little slow
" function! FoldImport()
	" let line = getline(v:lnum)
	" let prev_line = getline(v:lnum-1)
	" if match(line, '^\t*import\s*{$') >= 0
		" return ">1"
	" elseif match(prev_line, '^\t*}$') >= 0
		" if FoldImportPrevLineIsEnd()
			" return 0
		" else
			" return "="
		" endif
	" else
		" return "="
	" endif
" endfunction
" function! FoldImportPrevLineIsEnd()
	" let initIndent = indent(v:lnum - 1)
	" let lineNo = v:lnum - 2
	" while lineNo > 0
		" let line = getline(lineNo)
		" " skip empty lines
		" if match(line, '^\s*$') >= 0
			" let lineNo -= 1
			" continue
		" endif
		" if indent(lineNo) == initIndent
			" return match(line, '^\t*import\s*{$') >= 0
		" endif
		" let lineNo -= 1
	" endwhile
	" return 0
" endfunction

" nnoremap zi :call FoldIndent()<cr>
function! FoldIndent()
	let curLineNo = line(".")
	let maxLineNo = line("$")
	let curIndent = indent(curLineNo)
	let n = 0

	let i = curLineNo + 1
	while i <= maxLineNo
		if len(getline(i)) > 0
			if curIndent < indent(i)
				let n += 1
			else
				break
			endif
		endif
		let i += 1
	endwhile

	if n > 0
		execute "normal! zf" . n . "\r"
	endif
endfunction

" split the current line into multiple lines with the charactor under the cursor
" as the separator
function! MHF_Split()
	let curLineNo = line(".")
	let curLine = getline(".")
	let curChar = matchstr(curLine, '\%'.col('.').'c.')
	let aList = split(curLine, curChar)
	let sepCount = len(aList) - 1
	let i = 0
	while i <= sepCount
		execute "normal! ^f" . curChar . "r\r"
		let i += 1
	endwhile
	call cursor(curLineNo, 0)
endfunction

" --------------------------------- keymap --------------------------------------
function! Keymap_russian()
	execute "set keymap=russian-yawerty"
endfunction
function! Keymap_default()
	execute "set keymap="
endfunction

" --------------------------------- other --------------------------------------
" add // ----- above the current line
nnoremap <leader>c- :call CommentDashLine()<cr>
function! CommentDashLine()
	execute "normal! O//  \<esc>70i-\<esc>lxj^"
endfunction
