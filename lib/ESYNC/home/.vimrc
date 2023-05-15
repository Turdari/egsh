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

function! CsRegister()
"FUNCTION_FF cscope
""check csocpe functionality available
"if has('cscope')
"  set cscopetag cscopeverbose
"
"  if has('quickfix')
"    set cscopequickfix=s-,c-,d-,i-,t-,e-
"  endif
"
"  cnoreabbrev csa cs add
"  cnoreabbrev csf cs find
"  cnoreabbrev csk cs kill
"  cnoreabbrev csr cs reset
"  cnoreabbrev css cs show
"  cnoreabbrev csh cs help
"
"  command -nargs=0 Cscope cs add $VIMSRC/src/cscope.out $VIMSRC/src
"endif

" This tests to see if vim was configured with the '--enable-cscope' option
" when it was compiled.  If it wasn't, time to recompile vim... 
"   if has("cscope")
"   	" first add default directory for cs...
"   	cs add $HOME/.csdir
"   
"       """"""""""""" Standard cscope/vim boilerplate
"   
"       " use both cscope and ctag for 'ctrl-]', ':ta', and 'vim -t'
"       "set cscopetag
"   
"       " check cscope for definition of a symbol before checking ctags: set to 1
"       " if you want the reverse search order.
"       set csto=0
"   
"       " add any cscope database in current directory
"       if filereadable("cscope.out")
"           cs add cscope.out  
"       " else add the database pointed to by environment variable 
"       elseif $CSCOPE_DB != ""
"           cs add $CSCOPE_DB
"       endif
"   
"       " show msg when any other cscope db added
"       set cscopeverbose  
"   
"   
"       """"""""""""" My cscope/vim key mappings
"       "
"       " The following maps all invoke one of the following cscope search types:
"       "
"       "   's'   symbol: find all references to the token under cursor
"       "   'g'   global: find global definition(s) of the token under cursor
"       "   'c'   calls:  find all calls to the function name under cursor
"       "   't'   text:   find all instances of the text under cursor
"       "   'e'   egrep:  egrep search for the word under cursor
"       "   'f'   file:   open the filename under cursor
"       "   'i'   includes: find files that include the filename under cursor
"       "   'd'   called: find functions that function under cursor calls
"       "
"       " Below are three sets of the maps: one set that just jumps to your
"       " search result, one that splits the existing vim window horizontally and
"       " diplays your search result in the new window, and one that does the same
"       " thing, but does a vertical split instead (vim 6 only).
"       "
"       " I've used CTRL-\ and CTRL-@ as the starting keys for these maps, as it's
"       " unlikely that you need their default mappings (CTRL-\'s default use is
"       " as part of CTRL-\ CTRL-N typemap, which basically just does the same
"       " thing as hitting 'escape': CTRL-@ doesn't seem to have any default use).
"       " If you don't like using 'CTRL-@' or CTRL-\, , you can change some or all
"       " of these maps to use other keys.  One likely candidate is 'CTRL-_'
"       " (which also maps to CTRL-/, which is easier to type).  By default it is
"       " used to switch between Hebrew and English keyboard mode.
"       "
"       " All of the maps involving the <cfile> macro use '^<cfile>$': this is so
"       " that searches over '#include <time.h>" return only references to
"       " 'time.h', and not 'sys/time.h', etc. (by default cscope will return all
"       " files that contain 'time.h' as part of their name).
"   
"   
"       " To do the first type of search, hit 'CTRL-\', followed by one of the
"       " cscope search types above (s,g,c,t,e,f,i,d).  The result of your cscope
"       " search will be displayed in the current window.  You can use CTRL-T to
"       " go back to where you were before the search.  
"       "
"   
"       nmap <C-\>s :cs find s <C-R>=expand("<cword>")<CR><CR>	
"       nmap <C-\>g :cs find g <C-R>=expand("<cword>")<CR><CR>	
"       nmap <C-\>c :cs find c <C-R>=expand("<cword>")<CR><CR>	
"       nmap <C-\>t :cs find t <C-R>=expand("<cword>")<CR><CR>	
"       nmap <C-\>e :cs find e <C-R>=expand("<cword>")<CR><CR>	
"       nmap <C-\>f :cs find f <C-R>=expand("<cfile>")<CR><CR>	
"       nmap <C-\>i :cs find i ^<C-R>=expand("<cfile>")<CR>$<CR>
"       nmap <C-\>d :cs find d <C-R>=expand("<cword>")<CR><CR>	
"   
"   
"       " Using 'CTRL-spacebar' (intepreted as CTRL-@ by vim) then a search type
"       " makes the vim window split horizontally, with search result displayed in
"       " the new window.
"       "
"       " (Note: earlier versions of vim may not have the :scs command, but it
"       " can be simulated roughly via:
"       "    nmap <C-@>s <C-W><C-S> :cs find s <C-R>=expand("<cword>")<CR><CR>	
"   
"       nmap <C-@>s :scs find s <C-R>=expand("<cword>")<CR><CR>	
"       nmap <C-@>g :scs find g <C-R>=expand("<cword>")<CR><CR>	
"       nmap <C-@>c :scs find c <C-R>=expand("<cword>")<CR><CR>	
"       nmap <C-@>t :scs find t <C-R>=expand("<cword>")<CR><CR>	
"       nmap <C-@>e :scs find e <C-R>=expand("<cword>")<CR><CR>	
"       nmap <C-@>f :scs find f <C-R>=expand("<cfile>")<CR><CR>	
"       nmap <C-@>i :scs find i ^<C-R>=expand("<cfile>")<CR>$<CR>	
"       nmap <C-@>d :scs find d <C-R>=expand("<cword>")<CR><CR>	
"   
"   
"       " Hitting CTRL-space *twice* before the search type does a vertical 
"       " split instead of a horizontal one (vim 6 and up only)
"       "
"       " (Note: you may wish to put a 'set splitright' in your .vimrc
"       " if you prefer the new window on the right instead of the left
"   
"       nmap <C-@><C-@>s :vert scs find s <C-R>=expand("<cword>")<CR><CR>
"       nmap <C-@><C-@>g :vert scs find g <C-R>=expand("<cword>")<CR><CR>
"       nmap <C-@><C-@>c :vert scs find c <C-R>=expand("<cword>")<CR><CR>
"       nmap <C-@><C-@>t :vert scs find t <C-R>=expand("<cword>")<CR><CR>
"       nmap <C-@><C-@>e :vert scs find e <C-R>=expand("<cword>")<CR><CR>
"       nmap <C-@><C-@>f :vert scs find f <C-R>=expand("<cfile>")<CR><CR>	
"       nmap <C-@><C-@>i :vert scs find i ^<C-R>=expand("<cfile>")<CR>$<CR>	
"       nmap <C-@><C-@>d :vert scs find d <C-R>=expand("<cword>")<CR><CR>
"   
"   
"       """"""""""""" key map timeouts
"       "
"       " By default Vim will only wait 1 second for each keystroke in a mapping.
"       " You may find that too short with the above typemaps.  If so, you should
"       " either turn off mapping timeouts via 'notimeout'.
"       "
"       "set notimeout 
"       "
"       " Or, you can keep timeouts, by uncommenting the timeoutlen line below,
"       " with your own personal favorite value (in milliseconds):
"       "
"       "set timeoutlen=4000
"       "
"       " Either way, since mapping timeout settings by default also set the
"       " timeouts for multicharacter 'keys codes' (like <F1>), you should also
"       " set ttimeout and ttimeoutlen: otherwise, you will experience strange
"       " delays as vim waits for a keystroke after you hit ESC (it will be
"       " waiting to see if the ESC is actually part of a key code like <F1>).
"       "
"       "set ttimeout 
"       "
"       " personally, I find a tenth of a second to work well for key code
"       " timeouts. If you experience problems and have a slow terminal or network
"       " connection, set it higher.  If you don't set ttimeoutlen, the value for
"       " timeoutlent (default: 1000 = 1 second, which is sluggish) is used.
"       "
"       "set ttimeoutlen=100
"   
"   endif
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
"CTAGS {
" Set ctags directory
let ctag_dirname = $HOME . "/.vim/ctag-files"
if !isdirectory(ctag_dirname)
    call mkdir(ctag_dirname, "p")
endif
execute "set tags+=" . expand(ctag_dirname) . "/*"

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
nmap <F8> :TagbarToggle<CR>
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


