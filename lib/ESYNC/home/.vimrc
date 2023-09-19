"All key mappings should be integrated in  KEY_MAP

"==========================================
"COMMON {
syntax on
set tabstop=4
set shiftwidth=4
set expandtab
set hlsearch
set autochdir


"FUNCTION_00 bundle related functions
set runtimepath^=~/.vim/bundle/tagbar
helptags ~/.vim/bundle/tagbar/doc
if v:version > 700
    set runtimepath^=~/.vim/bundle/vim-conque
    helptags ~/.vim/bundle/vim-conque/doc
endif
if v:version > 800
    packadd termdebug
endif
function! BundleInstall()
  let repo1 = "git clone https://github.com/goballooning/vim-conque.git ~/.vim/bundle/vim-conque"  
  let repo2 = "git clone https://github.com/preservim/tagbar.git ~/.vim/bundle/tagbar"  
  let output = system(repo1)  " Execute the shell command
  echo output  
  let output = system(repo2)  " Execute the shell command
  echo output  
endfunction


"FUNCTION_FF Disable Compile, But Enable Debug
au BufRead,BufNewFile *.c.ref set syntax=c
au BufRead,BufNewFile *.h.ref set syntax=c

"FUNCTION_01 function for debug
function! ToggleVerbose()
    if !&verbose
        set verbosefile=~/vim.log
        set verbose=15
    else
        set verbose=0
        set verbosefile=
    endif
endfunction

"Trimming F3 search value... useful when loading it into terminal
function! TrimExactMatch()
    let @/ = substitute(@/, '\\[<>]' , "", "g")
endfunction

"FUNCTION_?? toggle buffer on ...
let g:hnrbnum = -1
function! ToggleHideAndRestoreBuffer()
    if g:hnrbnum == -1
        let g:hnrbnum = bufnr('%')
        hide
    else 
        execute "buffer". g:hnrbnum
        let g:hnrbnum = -1
    endif
endfunction 





"FUNCTION_?? Ranger style marks command
function! Marks()
    marks
    echo('Mark: ')

    " getchar() - prompts user for a single character and returns the chars
    " ascii representation
    " nr2char() - converts ASCII `NUMBER TO CHAR'

    let s:mark = nr2char(getchar())
    " remove the `press any key prompt'
    redraw

    " build a string which uses the `normal' command plus the var holding the
    " mark - then eval it.
    execute "normal! '" . s:mark
endfunction

" FUNCTION_ Peaking function.. 
" https://stackoverflow.com/questions/63299580/make-vim-keyword-completion-menu-show-function-parameters
" get the parameters of a function and put it in a popup using ctags
func GetFuncParamsFromTag()
    silent write
    " jump to tag under cursor
    silent execute "normal \<c-]>"
"    " if there is '(' on the same line, it may be a function
"    if search('(', "n") == winsaveview()["lnum"]
"        " yank the function's name and parameters
"        silent execute "normal v/)\<cr>y\<c-t>"
"        " remove any previously present popup
"        call popup_clear()
"        " make the popup spawn above/below the cursor
"        call popup_atcursor(getreg('0'), #{moved: [0, 80], highlight: 'WildMenu'})
"    endif

    silent execute "normal vjjjy"


    " remove any previously present popup
    call popup_clear()
    " make the popup spawn above/below the cursor
    call popup_atcursor(getreg('0'), #{moved: [0, 80], highlight: 'WildMenu'})
    silent execute "normal \<c-t>"
endfunc


"}
"==========================================
"CSCOPE {
"========= cscope set  =========
set csprg=/usr/bin/cscope
set csto=0
set cst
set nocsverb

set cscopetag
set cscoperelative

if filereadable("./cscope.out")
    cs add cscope.out
endif
set csverb
"======= cscope func define ==============
" cs find s ??? --> find this c symbol
func! Css()
    let css = expand("<cword>")
    new
    exe "cs find s ".css
    if line('$') == 1 && getline(1) == ''
        exe "q!"
    endif
endfunc
nmap ,css :call Css()<cr>

" cs find c ??? --> find functions calling this functions
func! Csc()
    let csc = expand("<cword>")
    new
    exe "cs find c ".csc
    if line('$') == 1 && getline(1) == ''
        exe "q!"
    endif
endfunc
nmap ,csc :call Csc()<cr>

" cs find d ??? --> find functions called by this functions
func! Csd()
    let csd = expand("<cword>")
    new
    exe "cs find d ".csd
    if line('$') == 1 && getline(1) == ''
        exe "q!"
    endif
endfunc
nmap ,csd :call Csd()<cr>

" cs find g ??? --> find this definition
func! Csg()
    let csg = expand("<cword>")
    new
    exe "cs find g ".csg
    if line('$') == 1 && getline(1) == ''
        exe "q!"
    endif
endfunc
nmap ,csg :call Csg()<cr>

func! Csf()
    let csf = expand("<cword>")
    new
    exe "cs find f ".csf
    if line('$') == 1 && getline(1) == ''
        exe "q!"
    endif
endfunc
nmap ,csf :call Csf()<cr>

func! Csi()
    let csi = expand("%:t")
    new
    exe "cs find i ".csi
    if line('$') == 1 && getline(1) == ''
        exe "q!"
    endif
endfunc
nmap ,csi :call Csi()<cr>
"}
"==========================================
"CTAGS {
" Set ctags directory
let ctag_dirname = $HOME . "/.vim/ctag-files"

if isdirectory(ctag_dirname)
    for tagfile in split(glob(ctag_dirname . '/*'), '\n')
        execute "set tags+=" . fnameescape(tagfile)
    endfor
else
    call mkdir(ctag_dirname, "p")
endif

"FUNCTION_00 search-tag-from directory
function! RecursiveTagSearch(startdir) abort
    " Get absolute path of startdir
    let abs_startdir = glob(a:startdir)

    " Loop through all files and directories in startdir
    for file in split(globpath(abs_startdir, "*"), "\n")
        if isdirectory(file)
            " If file is a directory, recursively call this function
            "echo "Loop Dir : " . abs_startdir
            call RecursiveTagSearch( file )
        elseif file =~ 'tags'
            " If file is a tag file with the naming convention 'tag-/dir/name', do something
            "echo "Found tag file: " . file
            execute "set tags+=" . file
        else
            "echo "else : " . file
        endif
    endfor
endfunction

function! CleanTags()
    set tags =
endfunction

function! CleanSetTags() abort
    call CleanTags()
    set tags +=tags
    set tags +=TAGS
    set tags +=./tags
    set tags +=./TAGS
    let ctag_dirname = $HOME . "/.vim/ctag-files"
    execute "set tags+=" . expand(ctag_dirname) . "/*"

    let tstartdir = glob( getcwd() )

    call RecursiveTagSearch( tstartdir )
endfunction

"}
"==========================================
"NETRW {
if v:version > 600
    "FUNCTION netrw toggle feature
    let g:netrw_liststyle = 3   " tree style
    let g:netrw_altv = 1        " split right side
    function! ToggleExplorerTerm() 
        if v:version > 800
            let t:curjob = term_getjob( bufnr('%') )
        endif
            let t:tab_buf_arr = []
            let t:tab_buf_arr += tabpagebuflist()
        
        if v:version > 800
            if t:curjob != v:null
                let t:curpid = job_info(t:curjob).process
                let t:curcwd = system("readlink /proc/".t:curpid."/cwd")
            else 
                let t:curcwd = expand('%:p:h')
            endif
        else
            let t:curcwd = expand('%:p:h')
        endif 
    " copied from other function
        if exists('t:NetrwIsOpen') && t:NetrwIsOpen == 1
            for tnum in t:tab_buf_arr
           		if (getbufvar(tnum, "&filetype") == "netrw")
    	                silent exe "bwipeout " . tnum
    		endif
            endfor
            let t:NetrwIsOpen=0
        else
            let t:NetrwIsOpen=1
            execute "Vexplore ".t:curcwd
            vertical resize 40
        endif
    endfunction

    
    "FUNCTION netrw cd to 
    let g:netrw_getdir = ""
    function! NetrwGetdir()
        let g:netrw_getdir = b:netrw_curdir
        let tab_buf_arr = []
        let tab_buf_arr += tabpagebuflist()
        for tnum in tab_buf_arr
            let bt = getbufvar(tnum, "&buftype")
            if bt == "terminal"
                "echo "buffer type == ".bt.",g:netrw_getdir == ".g:netrw_getdir
                call term_sendkeys(tnum, "\<c-c>\<c-c>\<CR>")
                call term_sendkeys(tnum, "cd ".g:netrw_getdir."\<CR>")
                break
                echo "works?"
            endif 
        endfor
    endfunction
    function! NetrwSetTermTodir()
        let g:netrw_getdir = b:netrw_curdir
        let tab_buf_arr = []
        let tab_buf_arr += tabpagebuflist()
    
        execute "rightb vert terminal "
    
        for tnum in tab_buf_arr
            let bt = getbufvar(tnum, "&buftype")
            if bt == "terminal"
                echo "buffer type == ".bt.",g:netrw_getdir == ".g:netrw_getdir
    	    "call term_sendkeys(tnum, "\<c-c>\<c-c>\<CR>")
                call term_sendkeys(tnum, "cd ".g:netrw_getdir."\<CR>")
                break
            endif 
        endfor
    endfunction
    function! NetrwMapping()
        "noremap <buffer><silent> <F5> :call NetrwSetTermTodir()<CR>
        noremap <buffer><silent> <F6> :call NetrwGetdir()<CR>
        noremap <buffer><silent> <c-l> :tabn<CR>
    endfunction
     
    "FUNCTION_06 autocomplete shortcut to ctrl + k
    set completeopt=longest,menuone
    inoremap <C-k> <C-n>
    
endif
"}
"==========================================
"TAB{
if v:version > 700

    " Switch to last-active tab
"    autocmd! TabLeave * let g:Lasttab_backup = g:Lasttab | let g:Lasttab = tabpagenr()
"    autocmd! TabClosed * let g:Lasttab = g:Lasttab_backup
"    nmap <silent> <C-k>` :exe "tabn " . g:Lasttab<cr>
if !exists('g:Lasttab')
    let g:Lasttab = 1
    let g:Lasttab_backup = 1
endif


endif
"}
"==========================================
"TERMINAL{
if v:version > 800
    "FUNCTION when just starting.. there is no tab assigned so ...
    autocmd TabNew * let t:term_buf_nr = -1
    let t:term_buf_nr = -1
    function! s:ToggleTerminal() abort
        if t:term_buf_nr == -1
            execute "botright terminal"
            let t:term_buf_nr = bufnr("$")
        else
            try
                execute "bdelete! " . t:term_buf_nr
            catch
                let t:term_buf_nr = -1
                call <SID>ToggleTerminal()
                return
            endtry
            let t:term_buf_nr = -1
        endif
    endfunction
   
    function! OpenInTerminal()
        let item = netrw#Call('NetrwFile', netrw#Call('NetrwGetWord'))
        if isdirectory(item)
            echo 'Directory: ' . item
            execute 'tabnew'
            execute 'terminal ++curwin sh -c "cd '. shellescape(item) .' && exec $SHELL"'
        elseif filereadable(item)
            echo 'File: ' . item
            execute 'tabedit ' . item
        elseif item =~ '/.*/.*/$'
            " Handle the exception case
            let parent_dir = fnamemodify(item, ':h')
            let parent_dir_no_slash = substitute(parent_dir, '/[^/]\+$', '', '')
    "        echo 'directory: ' . parent_dir
    "        echo 'no slash directory: ' . parent_dir_no_slash
            if isdirectory(parent_dir_no_slash)
                echo 'Exception directory: ' . parent_dir
                execute 'tabnew'
                execute 'terminal ++curwin sh -c "cd '. shellescape(parent_dir_no_slash) .' && exec $SHELL"'
            else
                echo 'Unknown item: ' . item
            endif
        else
            echo 'Unknown item: ' . item
        endif 
    endfunction

    augroup NetrwMappings
        autocmd!
        autocmd FileType netrw nnoremap <buffer> t :call OpenInTerminal()<CR>
    augroup END
 
    function! MkSession(...)
        " Handle the argument
        if empty(a:000)
            let filename = "Session.vim"
        else
            let filename = fnameescape(a:1)
        endif
        " Create the session file according to the argument passed
        execute 'mksession! ' . filename
        " The list containing the lines on the unnmaed buffers
        let noname_buffers = []
        " Get the lines of all the unnamed buffers in the list
        execute "silent! bufdo \| if expand('%')=='' \| call add(noname_buffers, getline(1, '$')) \| endif"
        " For each set of lines
        " Add into the session file a line creating an empty buffer
        " and a line adding its content
        for lines in noname_buffers
            call system('echo "enew" >> '.filename)
            call system('echo "call append(0, [\"'. join(lines, '\",\"') .'\"])" >>'. filename)
        endfor
    endfunction
    command! -nargs=? Mksession call MkSession(<f-args>)
endif

"}
"==========================================
"KEY_MAP {

"Netrw related registration
nnoremap <silent> <F7> :call ToggleExplorerTerm()<CR>
if v:version > 800
    tnoremap <silent> <F7> <c-w>:call ToggleExplorerTerm()<CR>
endif

"TAB related registration
augroup my_netrw_maps
    autocmd!
    autocmd FileType netrw nnoremap <buffer> <C-l> <C-PageDown>
    autocmd FileType netrw nnoremap <buffer> <C-h> <C-PageUp>
augroup END

if v:version > 700
    nnoremap <silent> <C-l> <C-PageDown>
    nnoremap <silent> <C-h> <C-PageUp>
    nnoremap <silent> <C-k>l :tabm +1<CR>
    nnoremap <silent> <C-k>h :tabm -1<CR>
    "nnoremap <silent> <C-k>k :tabnew<CR>
    nnoremap <silent> <C-k>k :tab split<CR>

    nnoremap <silent> <C-k>1 :tabnext 1<CR>
    nnoremap <silent> <C-k>2 :tabnext 2<CR>
    nnoremap <silent> <C-k>3 :tabnext 3<CR>
    nnoremap <silent> <C-k>4 :tabnext 4<CR>
    nnoremap <silent> <C-k>5 :tabnext 5<CR>
    nnoremap <silent> <C-k>6 :tabnext 6<CR>
    nnoremap <silent> <C-k>7 :tabnext 7<CR>
    nnoremap <silent> <C-k>8 :tabnext 8<CR>
    nnoremap <silent> <C-k>9 :tabnext 9<CR>
    if v:version > 800
        tnoremap <silent> <C-l> <C-w>:tabn<CR>
        tnoremap <silent> <C-h> <C-w>:tabp<CR>
        tnoremap <silent> <C-k>l <C-w>:tabm +1<CR>
        tnoremap <silent> <C-k>h <C-w>:tabm -1<CR>
        "tnoremap <silent> <C-k>k <C-w>:tabnew<CR>
        tnoremap <silent> <C-k>k <C-w>:tab split<CR>
    
        tnoremap <silent> <C-k>1 <C-w>:tabnext 1<CR>
        tnoremap <silent> <C-k>2 <C-w>:tabnext 2<CR>
        tnoremap <silent> <C-k>3 <C-w>:tabnext 3<CR>
        tnoremap <silent> <C-k>4 <C-w>:tabnext 4<CR>
        tnoremap <silent> <C-k>5 <C-w>:tabnext 5<CR>
        tnoremap <silent> <C-k>6 <C-w>:tabnext 6<CR>
        tnoremap <silent> <C-k>7 <C-w>:tabnext 7<CR>
        tnoremap <silent> <C-k>8 <C-w>:tabnext 8<CR>
        tnoremap <silent> <C-k>9 <C-w>:tabnext 9<CR>
    endif
endif

"Term related registeration 
if v:version > 800
    nnoremap <silent> <C-k><C-k> :call <SID>ToggleTerminal()<CR>
    tnoremap <silent> <C-k><C-k> <C-w>:call <SID>ToggleTerminal()<CR>
    nnoremap <silent> <C-k>t :terminal ++curwin<cr>
    tnoremap <silent> <C-k>t <C-w>:terminal ++curwin<cr>
elseif v:version > 700
    nnoremap <silent> <C-k>t :ConqueTerm bash <CR>
    nnoremap <silent> <C-k><C-k> :ConqueTermVSplit bash<CR>
endif

"Clean and Set tag recursively
nnoremap <silent> <F2> :call CleanTags()<CR>
nnoremap <silent> <F3> :call CleanSetTags()<CR>
if v:version > 800
    tnoremap <silent> <F2> <C-w>:call CleanTags()<CR>
    tnoremap <silent> <F3> <C-w>:call CleanSetTags()<CR>
endif

"Tagbar Toggle
nnoremap <F9> :TagbarToggle<CR>
"Toggle log
nnoremap <silent> <C-k>v :call ToggleVerbose()<cr>
"Set another close in specific mapping
nnoremap <silent> <C-k>q :q!<cr>
if v:version > 800
tnoremap <silent> <C-k>q <C-w>:q!<cr>
endif
"Trick to write in file when open as none sudo
cnoremap w!! execute 'silent! write !sudo tee % >/dev/null' <bar> edit!
"Trimming # search value... useful when loading it into terminal
nnoremap <silent> <C-k>/ :call TrimExactMatch()<cr>
"Implement Full/Minimal screen feature
nnoremap <silent> <C-k>= <C-w>_
nnoremap <silent> <C-k>- :resize 1<cr>
if v:version > 800
    tnoremap <silent> <C-k>= <C-w>_
    tnoremap <silent> <C-k>- <C-w>:resize 1<cr>
endif
"Make buffer save and restore with F5
nnoremap <silent> <F5> :call ToggleHideAndRestoreBuffer()<CR>
if v:version > 800
	tnoremap <silent> <F5> <C-w>:call ToggleHideAndRestoreBuffer()<CR>
endif
"Unknown features ... forgot
nnoremap <silent> <C-k>m :call Marks()<CR>
nnoremap <silent> <C-k>p :call GetFuncParamsFromTag()<cr>

nnoremap <silent> <F4> :call BundleInstall()<cr>

"}
"==========================================


