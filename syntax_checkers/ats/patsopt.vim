if exists('g:loaded_syntastic_ats_patsopt_checker')
    finish
endif
let g:loaded_syntastic_ats_patsopt_checker = 1

let g:syntastic_ats_patsopt_exec = 'patsopt'

function! SyntaxCheckers_ats_patsopt_GetLocList() dict
    " current buffer's file extension
    let fext = expand('%:e')

    " patsopt uses separate flags for `.dats` vs `.sats` files...
    let args = '--typecheck'
    if fext ==# 'dats'
        let args = args . ' --dynamic'
    elseif fext ==# 'sats'
        let args = args . ' --static'
    endif

    let makeprg = self.makeprgBuild({
                \   'exe': self.getExec(),
                \   'args': args,
                \   'fname': shellescape(expand('%'))
                \ })

    let errorformat =
        \ 'exit(ATS):%m,' .
        \ '%f:\ %\d%#(line=%l\,\ offs=%c) --%m'

    let loclist = SyntasticMake({ 
            \   'makeprg': makeprg,
            \   'errorformat': errorformat
            \ })

    return loclist

endfunction

call g:SyntasticRegistry.CreateAndRegisterChecker({
    \   'filetype': 'ats',
    \   'name': 'patsopt'
    \ })
