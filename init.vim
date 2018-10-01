" Syntax{{{
set modelines=1
set backspace=indent,eol,start
set number
set pastetoggle=<F3>
set scrolloff=10
syntax enable
" }}}
" Functions {{{
function! StripTrailingWhitespaces()
	" save last search & cursor position
	let _s=@/
	let l = line(".")
	let c = col(".")
	%s/\s\+$//e
	let @/=_s
	call cursor(l, c)
endfunction

nnoremap <leader>s :call StripTrailingWhitespaces()<CR>

function! DecryptFilePre()
	set viminfo=
	set noswapfile
	set nowritebackup
	set nobackup
	set bin
	set spell
	set scrolloff=16
	let g:deoplete#disable_auto_complete=1
	nnoremap <buffer> <F3> o<ESC>o<ESC>i-<ESC>44.o<C-R>=strftime("%a %d %b %Y %H:%M:%S %p %Z")<CR><ESC>kyyjpoTITLE:
	inoremap *shrug* ¯\_ツ_/¯
endfunction

function! DecryptFilePost()
	:%!gpg -d 2>/dev/null
	set nobin
endfunction

function! EncryptFilePre()
	set bin
	:%!gpg --symmetric --cipher-algo AES256 2>/dev/null
endfunction

function! EncryptFilePost()
	silent u
	set nobin
endfunction

function! BufSel(pattern)
	let bufcount = bufnr("$")
	let currbufnr = 1
	let nummatches = 0
	let firstmatchingbufnr = 0
	while currbufnr <= bufcount
		if(bufexists(currbufnr))
			let currbufname = bufname(currbufnr)
			if(match(currbufname, a:pattern) > -1)
				echo currbufnr . ": ". bufname(currbufnr)
				let nummatches += 1
				let firstmatchingbufnr = currbufnr
			endif
		endif
		let currbufnr = currbufnr + 1
	endwhile
	if(nummatches == 1)
		execute ":buffer ". firstmatchingbufnr
	elseif(nummatches > 1)
		let desiredbufnr = input("Enter buffer number: ")
		if(strlen(desiredbufnr) != 0)
			execute ":buffer ". desiredbufnr
		endif
	else
		echo "No matching buffers"
	endif
endfunction
function! Comment() 
	" iterate over lines, if comment, than insert comment
	let commentChar = "/"
	let s=line("'<")
	let e=line("'>")
	let index = s
	while index <= e
		call cursor(index,1)
		:normal ^
		let currentChar = strcharpart(getline('.')[col('.') - 1:], 0, 1)		
		if currentChar == ""
		elseif currentChar == commentChar
			" uncomment
			:.s:^\(\s*\)//:\1:
		else
			"comment
			:.s:^://:
		endif
		let index = index + 1
	endwhile
endfunction
function! InsertTabWrapper(direction)
    let col = col('.') - 1
    if !col || getline('.')[col - 1] !~ '\k'
        return "\<tab>"
    elseif "backward" == a:direction
        return "\<c-p>"
    else
        return "\<c-n>"
    endif
endfunction
" }}}
" Spaces and tabs {{{
set tabstop=4
set softtabstop=4
set shiftwidth=4
set linebreak
set whichwrap=[,]
" }}}
" Highlighting {{{
colorscheme elflord
set hlsearch
set wildmenu
set showmatch
highlight DiffAdd    cterm=bold ctermfg=10 ctermbg=17 gui=none guifg=bg guibg=Red
highlight DiffDelete cterm=bold ctermfg=10 ctermbg=17 gui=none guifg=bg guibg=Red
highlight DiffChange cterm=bold ctermfg=10 ctermbg=17 gui=none guifg=bg guibg=Red
highlight DiffText   cterm=bold ctermfg=10 ctermbg=88 gui=none guifg=bg guibg=Red

syn match OpenBraces /{{/ conceal
syn match CloseBraces /}}/ conceal
set conceallevel=2
hi MyItalics gui=italic cterm=italic term=italic ctermfg=Blue
hi SpellBad ctermbg=0 ctermfg=3
hi MatchParen term=reverse ctermbg=1 guibg=DarkCyan
 highlight Conceal ctermfg=255 ctermbg=0
"}}}
" Mapleader {{{
nnoremap <SPACE> <Nop>
let mapleader="\<SPACE>"
let maplocalleader="\<SPACE>"
"}}}
" Normal Mode mappings {{{
nnoremap j gj
nnoremap k gk
" Highlight the last inserted text
nnoremap gV `[v`]

nnoremap <C-E> :tabn<CR>
" Switch windows
nnoremap <C-h> <C-W>h
nnoremap <C-l> <C-W>l
nnoremap <C-k> <C-W>k
nnoremap <C-j> <C-W>j

" Cut and paste
vnoremap <C-C> "+y
vnoremap < <gv
vnoremap > >gv
nnoremap <C-V><C-V> "+p

" json format
nnoremap <F5> :%!python -m json.tool<CR> 
nnoremap <F4> :%!xmllint --format -<CR> 
nnoremap <F6> :tabn<CR> 
nnoremap <C-[> <C-t>

nnoremap <leader>n :bNext<CR>
nnoremap <leader>m :bprevious<CR>

" quit window
nnoremap <leader>q :q<CR>

"turn off highlighting
nnoremap <leader>/ :set hlsearch!<CR>
" }}}
" {{{ Terminal Mode
nnoremap <leader>z :new<CR>:terminal<CR>asource $HOME/.bash_profile<CR>PS1="\h:\W \u$ "<CR>source ~/python/neovim/bin/activate<CR>clear<CR>
tnoremap jk <C-\><C-n>
tnoremap <C-E> <C-\><C-n>:tabn<CR>
" }}}
" Folding {{{
set foldenable
set foldlevelstart=10
set foldmethod=indent

" }}}
" Insert Mode mappings {{{
inoremap jk <ESC>

" }}}
" Plugins{{{
source ~/.config/nvim/plugin.vim
" }}}
" Cscope {{{
source ~/.config/nvim/cscope.vim
" }}}
" Unicode aliases {{{
" }}}
" Autocommands {{{
autocmd FileType cpp set keywordprg=:term\ cppman
autocmd! BufWritePost ~/.config/nvim/init.vim source %
augroup filetype_go
	au!
	let g:go_term_mode = "10split"
	autocmd FileType go nnoremap <buffer> <F3> :GoRun<CR>
	autocmd FileType go nnoremap <buffer> <localleader>d :GoDef<CR>
	autocmd FileType go nnoremap <buffer> <localleader>b :GoDoc<CR>
	autocmd FileType go nnoremap <buffer> <localleader>o <C-o>
	autocmd FileType go nnoremap <buffer> <localleader>i <C-i>
	autocmd FileType go set foldlevel=5
	autocmd FileType go nnoremap <buffer> <F3> :GoRun<CR>
	autocmd FileType go nnoremap <buffer> <F12> :TagbarToggle<CR>
	autocmd FileType go call neomake#configure#automake('nrwi', 500)
	autocmd FileType go nnoremap GA :GoAlternate<CR>
	autocmd FileType go vnoremap <C-A> <ESC>:call Comment()<CR>'<
	autocmd BufWritePost *.go normal! zR
augroup end
augroup encrypted_dia
	autocmd!
	autocmd FileReadPre,BufReadPre *.dia.gpg call DecryptFilePre()
	autocmd FileReadPost,BufReadPost *.dia.gpg call DecryptFilePost()
	autocmd FileWritePre,BufWritePre *.dia.gpg call EncryptFilePre()
	autocmd FileWritePost,BufWritePost *.dia.gpg call EncryptFilePost()
augroup end
augroup filetype_rust
	au!
	autocmd BufWritePre,FileWritePre *.rs :%!rustfmt
augroup end
augroup filetyp wiki
	au!
	autocmd!
	vmap 4 S$
	let @o='F)2lv$hyi[[#jkA|jkpa]]jkGo=== jkpa ===jko[[#Table of contents:|Back to TOC]]jkojko'
augroup end
augroup filetype_java
	au!
	autocmd FileType java nnoremap <F12> :TagbarToggle<CR>
	set sidescrolloff=20
	set nowrap
augroup end
augroup filetype_python
	au!
	autocmd FileType python nnoremap <F12> :TagbarToggle<CR>
	autocmd FileType python map <leader>g :RopeGotoDefinition()<CR>
	autocmd FileType python let ropevim_enable_shortcuts = 1
	autocmd FileType python let g:pymode_rope_goto_def_newwin = "vnew"
	autocmd FileType python let g:pymode_rope_extended_complete = 1
	autocmd FileType python let g:pymode_breakpoint = 0
	autocmd FileType python let g:pymode_syntax = 1
	autocmd FileType python let g:pymode_syntax_builtin_objs = 0
	autocmd FileType python let g:pymode_syntax_builtin_funcs = 0
	inoremap <tab> <c-r>=InsertTabWrapper ("forward")<cr>
	inoremap <s-tab> <c-r>=InsertTabWrapper ("backward")<cr>
augroup end
" }}} vim:foldmethod=marker:foldlevel=0
let g:python3_host_prog = '/home/aditya/python/neovim/bin/python'
