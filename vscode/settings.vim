" packadd quickscope

" execute 'luafile ' . stdpath('config') . '/lua/settings.lua'

function! s:manageEditorSize(...)
    let count = a:1
    let to = a:2
    for i in range(1, count ? count : 1)
        call VSCodeNotify(to == 'increase' ? 'workbench.action.increaseViewSize' : 'workbench.action.decreaseViewSize')
    endfor
endfunction

function! s:vscodeCommentary(...) abort
    if !a:0
        let &operatorfunc = matchstr(expand('<sfile>'), '[^. ]*$')
        return 'g@'
    elseif a:0 > 1
        let [line1, line2] = [a:1, a:2]
    else
        let [line1, line2] = [line("'["), line("']")]
    endif

    call VSCodeCallRange("editor.action.commentLine", line1, line2, 0)
endfunction

" function! s:openVSCodeCommandsInVisualMode()
"     normal! gv
"     let visualmode = visualmode()
"     if visualmode == "V"
"         let startLine = line("v")
"         let endLine = line(".")
"         call VSCodeNotifyRange("workbench.action.showCommands", startLine, endLine, 1)
"     else
"         let startPos = getpos("v")
"         let endPos = getpos(".")
"         call VSCodeNotifyRangePos("workbench.action.showCommands", startPos[1], endPos[1], startPos[2], endPos[2], 1)
"     endif
" endfunction

function! s:openWhichKeyInVisualMode()
    normal! gv
    let visualmode = visualmode()
    if visualmode == "V"
        let startLine = line("v")
        let endLine = line(".")
        call VSCodeNotifyRange("whichkey.show", startLine, endLine, 1)
    else
        let startPos = getpos("v")
        let endPos = getpos(".")
        call VSCodeNotifyRangePos("whichkey.show", startPos[1], endPos[1], startPos[2], endPos[2], 1)
    endif
endfunction

" Better Navigation
nnoremap <silent> <C-j> :call VSCodeNotify('workbench.action.navigateDown')<CR>
xnoremap <silent> <C-j> :call VSCodeNotify('workbench.action.navigateDown')<CR>
nnoremap <silent> <C-k> :call VSCodeNotify('workbench.action.navigateUp')<CR>
xnoremap <silent> <C-k> :call VSCodeNotify('workbench.action.navigateUp')<CR>
nnoremap <silent> <C-h> :call VSCodeNotify('workbench.action.navigateLeft')<CR>
xnoremap <silent> <C-h> :call VSCodeNotify('workbench.action.navigateLeft')<CR>
nnoremap <silent> <C-l> :call VSCodeNotify('workbench.action.navigateRight')<CR>
xnoremap <silent> <C-l> :call VSCodeNotify('workbench.action.navigateRight')<CR>

nnoremap gr <Cmd>call VSCodeNotify('editor.action.goToReferences')<CR

" Open definition aside
nnoremap <C-w>gd <Cmd>call VSCodeNotify('editor.action.revealDefinitionAside')<CR>

"Which key con Space + w
nnoremap <silent> <Space>w :call VSCodeNotify('whichkey.show')<CR>
xnoremap <silent> <Space>w :<C-u>call <SID>openWhichKeyInVisualMode()<CR>
        
" Save with Space + s
" nnoremap <silent> <Space>s :call VSCodeNotify('workbench.action.files.save')<CR>
nnoremap <silent> <Space>p :call VSCodeNotify('workbench.action.quickOpen')<CR>

xmap gc  <Plug>VSCodeCommentary
nmap gc  <Plug>VSCodeCommentary
omap gc  <Plug>VSCodeCommentary
nmap gcc <Plug>VSCodeCommentaryLine

" Simulate same TAB behavior in VSCode
nmap <Tab> :Tabnext<CR>
nmap <S-Tab> :Tabprev<CR>

nnoremap ZZ <Cmd>Wq<CR>
nnoremap ZQ <Cmd>Quit!<CR>


" Windows commands
function! s:split(...) abort
    let direction = a:1
    let file = exists('a:2') ? a:2 : ''
    call VSCodeCall(direction ==# 'h' ? 'workbench.action.splitEditorDown' : 'workbench.action.splitEditorRight')
    if !empty(file)
        call VSCodeExtensionNotify('open-file', expand(file), 'all')
    endif
endfunction

function! s:splitNew(...)
    let file = a:2
    call s:split(a:1, empty(file) ? '__vscode_new__' : file)
endfunction

" window/splits management
nnoremap <C-w>q <Cmd>call VSCodeNotify('workbench.action.closeActiveEditor')<CR>
xnoremap <C-w>q <Cmd>call VSCodeNotify('workbench.action.closeActiveEditor')<CR>
nnoremap <C-w>o <Cmd>call VSCodeNotify('workbench.action.closeOtherEditors')<CR>

nnoremap <C-w>h <Cmd>call <SID>split('h')<CR>
xnoremap <C-w>h <Cmd>call <SID>split('h')<CR>
nnoremap <C-w><C-h> <Cmd>call <SID>split('h')<CR>
xnoremap <C-w><C-h> <Cmd>call <SID>split('h')<CR>

nnoremap <C-w>v <Cmd>call <SID>split('v')<CR>
xnoremap <C-w>v <Cmd>call <SID>split('v')<CR>
nnoremap <C-w><C-v> <Cmd>call <SID>split('v')<CR>
xnoremap <C-w><C-v> <Cmd>call <SID>split('v')<CR>

" buffer management
nnoremap <C-w>n <Cmd>call <SID>splitNew('v', '__vscode_new__')<CR>
xnoremap <C-w>n <Cmd>call <SID>splitNew('v', '__vscode_new__')<CR>

" Move lines up and down without loosing the cursor position
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
xnoremap <Up> dkP`[V`]
xnoremap <Down> dp`[V`]


" allows to wrap selected text in some tags
function! s:wrapSelection()
    let mode = mode()
    if mode ==# 'V'
        let startLine = line('v')
        let endLine = line('.')
        call VSCodeNotifyRange('editor.emmet.action.wrapWithAbbreviation', startLine, endLine, 1)
    else
        let startPos = getpos('v')
        let endPos = getpos('.')
        call VSCodeNotifyRangePos('editor.emmet.action.wrapWithAbbreviation', startPos[1], endPos[1], startPos[2], endPos[2] + 1, 1)
    endif
endfunction

xnoremap <Leader>r <Cmd>call <SID>wrapSelection()<CR>

function! s:sortSelectionInVisualMode()
    normal! gv
    let visualmode = visualmode()
    if visualmode == "V"
        let startLine = line("v")
        let endLine = line(".")
        call VSCodeNotifyRange("editor.action.sortLinesAscending", startLine, endLine, 1)
    else
        let startPos = getpos("v")
        let endPos = getpos(".")
        call VSCodeNotifyRangePos("editor.action.sortLinesAscending", startPos[1], endPos[1], startPos[2], endPos[2], 1)
    endif
endfunction

xnoremap <Leader>s <Cmd>call <SID>sortSelectionInVisualMode()<CR>

" Envolver la palabra en elr elemento escrito
:nnoremap <Leader>a" ciw""<Esc>P
:vnoremap <Leader>a" c""<Esc>P
:nnoremap <Leader>a' ciw''<Esc>P
:vnoremap <Leader>a' c''<Esc>P
:nnoremap <Leader>a( ciw()<Esc>P
:vnoremap <Leader>a( c()<Esc>P
:nnoremap <Leader>a{ ciw{}<Esc>P
:vnoremap <Leader>a{ c{}<Esc>P
:nnoremap <Leader>a[ ciw[]<Esc>P
:vnoremap <Leader>a[ c[]<Esc>P


// Fold-unfold
nnoremap <silent> <space>[ :call VSCodeNotify('editor.fold')<CR>
nnoremap <silent> <space>] :call VSCodeNotify('editor.unfold')<CR>
nnoremap <silent> <space>fa :call VSCodeNotify('editor.foldAll')<CR>
nnoremap <silent> <space>ua :call VSCodeNotify('editor.unfoldAll')<CR>

//Se queada colgado en visual code
noremap Q <Nop>

