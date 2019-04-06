" ~/.config/nvim/function.vim

" ファイルタイプを返す
function! GetFileType()
    " Alphabet order
    let l:name = {
                \'c'         : 'C',
                \'coffee'    : 'CoffeeScript',
                \'cpp'       : 'C++',
                \'cpanfile'  : 'Perl',
                \'crystal'   : 'Crystal',
                \'css'       : 'CSS',
                \'elixir'    : 'Elixir',
                \'java'      : 'Java',
                \'javascript': 'JavaScript',
                \'json'      : 'JSON',
                \'kotlin'    : 'Kotlin',
                \'less'      : 'LESS',
                \'markdown'  : 'Markdown',
                \'perl'      : 'Perl',
                \'php'       : 'PHP',
                \'python'    : 'Python',
                \'ruby'      : 'Ruby',
                \'scala'     : 'Scala',
                \'sh'        : 'Shell',
                \'sql'       : 'SQL',
                \'swift'     : 'Swift',
                \'tex'       : 'TeX',
                \'text'      : 'Text',
                \'tf'        : 'Terraform',
                \'typescript': 'TypeScript',
                \'vim'       : 'Vim',
                \'xslate'    : 'Xslate',
                \'yaml'      : 'YAML',
                \}

    retu get(l:name, &ft, &ft)
endfunction

" 文字コードを返す
function! GetFileEncoding()
    let l:fenc = &fenc


    " fenc が設定されていない場合 enc を使用する
    if l:fenc == ''
        let l:fenc = &enc
    endif

    if l:fenc == 'cp932'
        return 'S'
    elseif l:fenc == 'iso-2022-jp'
        return 'J'
    elseif l:fenc == 'euc-jp'
        return 'E'
    elseif l:fenc == 'utf-8'
        return 'U'
    else
        return l:fenc
    endif
endfunction

" 改行コードを返す
function! GetFileFormat()
    if &ff == 'unix'
        return 'U'
    elseif &ff == 'dos'
        return 'D'
    else
        return 'M'
    endif
endfunction

" ステータスラインを生成する
function! GetStatusLine()
    let l:line = 'vim: se'

    if &et
        let l:line .= ' et'
    else
        let l:line .= ' noet'
    endif

    let l:line .= ' ts='.&ts
    let l:line .= ' sw='.&sw
    let l:line .= ' sts='.&sts

    if &ft != ''
        let l:line .= ' ft='.&ft
    endif

    let l:line .= ' :'

    return l:line
endfunction
