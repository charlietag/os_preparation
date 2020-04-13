" Vim color file
" Maintainer:   Ryan Hanson
" Last Modified: February 09, 2011
" Version: 1.0
"
" GUI / 256 color terminal
"
" This color scheme started as 'lucius' and has evolved into this. 
" I created this for PHP, HTML, JS, and CSS develpment.
"
" This file also tries to have descriptive comments for each higlighting group
" so it is easy to understand what each part does.

set t_Co=256

set background=dark
hi clear
if exists("syntax_on")
    syntax reset
endif
let g:colors_name="lucid"

" blue: 3eb8e5
" green: 92d400


" Base color
" ----------
"hi Normal           guifg=#dddddd           guibg=#030303
" hi Normal           guifg=#dddddd           guibg=black
 hi Normal           guifg=#dddddd           guibg=grey15
"hi Normal           ctermfg=254             ctermbg=235
" hi Normal           ctermfg=253             ctermbg=black
" change to NONE to work with tmux pane active style (window-active-style)
 hi Normal           ctermfg=253             ctermbg=NONE


" Comment Group
" -------------
" any comment
hi Comment          guifg=#e476ff                                   gui=NONE
hi Comment          ctermfg=243                                     cterm=NONE


" Constant Group
" --------------
" any constant
hi Constant         guifg=#d18af2                                   gui=NONE
hi Constant         ctermfg=80                                      cterm=NONE
" strings
hi String           guifg=#8ad6f2                                 gui=NONE
hi String           ctermfg=117                                     cterm=NONE
" character constant
hi Character        guifg=#d18af2                                   gui=NONE
hi Character        ctermfg=117                                     cterm=NONE
" numbers decimal/hex
hi Number           guifg=#d18af2                                   gui=NONE
hi Number           ctermfg=80                                      cterm=NONE
" true, false
hi Boolean          guifg=#d18af2                                   gui=NONE
hi Boolean          ctermfg=80                                      cterm=NONE
" float
hi Float            guifg=#d18af2                                   gui=NONE
hi Float            ctermfg=80                                      cterm=NONE


" Identifier Group
" ----------------
" any variable name
hi Identifier       guifg=#c5d4fe                               gui=NONE
hi Identifier       ctermfg=215                                     cterm=NONE
" function, method, class
hi Function         guifg=#bae682                                 	gui=NONE
hi Function         ctermfg=215                                     cterm=NONE




" Statement Group
" ---------------
" any statement
hi Statement        guifg=#bae682                                   gui=NONE
hi Statement        ctermfg=150                                     cterm=NONE
" if, then, else
hi Conditional      guifg=#bae682                                   gui=NONE
hi Conditional      ctermfg=150                                     cterm=NONE
" try, catch, throw, raise
hi Exception        guifg=#bae682                                   gui=NONE
hi Exception        ctermfg=150                                     cterm=NONE
" for, while, do
hi Repeat           guifg=#bae682                                   gui=NONE
hi Repeat           ctermfg=150                                     cterm=NONE
" case, default
hi Label            guifg=#bae682                                   gui=NONE
hi Label            ctermfg=150                                     cterm=NONE
" sizeof, +, *
hi Operator         guifg=#c5d4fe                                    gui=NONE
hi Operator         ctermfg=150                                     cterm=NONE
" any other keyword - javascript
hi Keyword          guifg=#defbb8                                   gui=NONE
hi Keyword          ctermfg=150                                     cterm=NONE


" Preprocessor Group
" ------------------
" generic preprocessor
hi PreProc          guifg=#efefaf                                   gui=NONE
hi PreProc          ctermfg=229                                     cterm=NONE
" #include
hi Include          guifg=#efefaf                                   gui=NONE
hi Include          ctermfg=229                                     cterm=NONE
" #define
hi Define           guifg=#efefaf                                   gui=NONE
hi Define           ctermfg=229                                     cterm=NONE
" same as define
hi Macro            guifg=#efefaf                                   gui=NONE
hi Macro            ctermfg=229                                     cterm=NONE
" #if, #else, #endif
hi PreCondit        guifg=#efefaf                                   gui=NONE
hi PreCondit        ctermfg=229                                     cterm=NONE


" Type Group
" ----------
" int, long, char
hi Type             guifg=#bae682                                  gui=NONE
hi Type             ctermfg=114                                     cterm=NONE
" static, register, volative
hi StorageClass     guifg=#bae682                                  gui=NONE
hi StorageClass     ctermfg=114                                     cterm=NONE
" struct, union, enum
hi Structure        guifg=#bae682                                  gui=NONE
hi Structure        ctermfg=114                                     cterm=NONE
" typedef
hi Typedef          guifg=#bae682                                  gui=NONE
hi Typedef          ctermfg=114                                     cterm=NONE


" Special Group
" -------------
" any special symbol
hi Special          guifg=#e4e4e4                                  gui=NONE
hi Special          ctermfg=182                                     cterm=NONE
" special character in a constant
hi SpecialChar      guifg=#fea3a0                                  gui=NONE
hi SpecialChar      ctermfg=182                                     cterm=NONE
" things you can CTRL-]
hi Tag              guifg=#ff0000                                  gui=NONE
hi Tag              ctermfg=182                                     cterm=NONE
" character that needs attention
hi Delimiter        guifg=#fea3a0                                  gui=NONE
hi Delimiter        ctermfg=182                                     cterm=NONE
" special things inside a comment
hi SpecialComment   guifg=#fc003b                                   gui=NONE
hi SpecialComment   ctermfg=182                                     cterm=NONE
" debugging statements
hi Debug            guifg=#fea3a0           guibg=NONE              gui=NONE
hi Debug            ctermfg=182             ctermbg=NONE            cterm=NONE


" Underlined Group
" ----------------
" text that stands out, html links
" hi Underlined       guifg=fg                                        gui=underline
" hi Underlined       ctermfg=fg                                      cterm=underline
hi Underline    ctermfg=147         ctermbg=None        cterm=Italic


" Ignore Group
" ------------
" left blank, hidden
hi Ignore           guifg=bg
" change to NONE to work with tmux pane active style (window-active-style)
"hi Ignore           ctermfg=bg
hi Ignore           ctermfg=NONE


" Error Group
" -----------
" any erroneous construct
hi Error            guifg=#dd4040           guibg=NONE              gui=NONE
hi Error            ctermfg=160             ctermbg=NONE            cterm=NONE


" Todo Group
" ----------
" todo, fixme, note, xxx
hi Todo             guifg=#deee33           guibg=NONE              gui=underline
hi Todo             ctermfg=190             ctermbg=NONE            cterm=underline


" Spelling
" --------
" word not recognized
hi SpellBad         guisp=#ee0000                                   gui=undercurl
hi SpellBad                                 ctermbg=9               cterm=undercurl
" word not capitalized
hi SpellCap         guisp=#eeee00                                   gui=undercurl
hi SpellCap                                 ctermbg=12              cterm=undercurl
" rare word
hi SpellRare        guisp=#ffa500                                   gui=undercurl
hi SpellRare                                ctermbg=13              cterm=undercurl
" wrong spelling for selected region
hi SpellLocal       guisp=#ffa500                                   gui=undercurl
hi SpellLocal                               ctermbg=14              cterm=undercurl


" Cursor
" ------
" character under the cursor
"hi Cursor           guifg=bg                guibg=#8ac6f2
" change to NONE to work with tmux pane active style (window-active-style)
"hi Cursor           ctermfg=bg              ctermbg=117
"hi Cursor           ctermfg=NONE
" like cursor, but used when in IME mode
"hi CursorIM         guifg=bg                guibg=#96cdcd
" change to NONE to work with tmux pane active style (window-active-style)
"hi CursorIM         ctermfg=bg              ctermbg=116
"hi CursorIM         ctermfg=NONE
" cursor column
" hi CursorColumn                             guibg=#3d3d4d
" hi CursorColumn     cterm=NONE              ctermbg=236
"hi CursorColumn term=reverse ctermbg=Black guibg=grey40
" cursor line/row
"hi CursorLine                               guibg=#3d3d4d
"hi CursorLine       cterm=NONE              ctermbg=236             
"hi CursorLine term=underline cterm=underline guibg=grey40

" by slate
"hi Cursor guibg=khaki guifg=slategrey
" hi CursorColumn                             guibg=#3d3d4d
" hi CursorColumn     cterm=NONE              ctermbg=236


" by laravel
hi Cursor ctermfg=NONE ctermbg=231 cterm=NONE guifg=NONE guibg=#f8f8f0 gui=NONE
hi CursorLine ctermfg=NONE ctermbg=237 cterm=NONE guifg=NONE guibg=#403e3d gui=NONE
hi CursorColumn ctermfg=NONE ctermbg=237 cterm=NONE guifg=NONE guibg=#403e3d gui=NONE


" Misc
" ----
" directory names and other special names in listings
hi Directory        guifg=#95e494                                   gui=NONE
hi Directory        ctermfg=114                                     cterm=NONE
" error messages on the command line
hi ErrorMsg         guifg=#ee0000           guibg=NONE              gui=NONE
hi ErrorMsg         ctermfg=196             ctermbg=NONE            cterm=NONE
" column separating vertically split windows
hi VertSplit        guifg=#777777           guibg=#444444           gui=NONE
hi VertSplit        ctermfg=244             ctermbg=238             cterm=NONE
" columns where signs are displayed (used in IDEs)
hi SignColumn       guifg=#9fafaf           guibg=#181818           gui=NONE
hi SignColumn       ctermfg=145             ctermbg=233             cterm=NONE
" line numbers
hi LineNr           guifg=#857b6f           guibg=#444444
hi LineNr           ctermfg=darkgray             ctermbg=NONE
"hi LineNr           ctermfg=101             ctermbg=238
" match parenthesis, brackets  
hi MatchParen       guifg=#fd544e           guibg=NONE              gui=NONE
hi MatchParen       ctermfg=46              ctermbg=NONE            cterm=NONE
" text showing what mode you are in
hi MoreMsg          guifg=#2e8b57                                   gui=NONE
hi MoreMsg          ctermfg=29                                      cterm=NONE
" the '~' and '@' and showbreak, '>' double wide char doesn't fit on line
hi ModeMsg          guifg=#90ee90           guibg=NONE              gui=NONE
hi ModeMsg          ctermfg=120             ctermbg=NONE            cterm=NONE
" the 'more' prompt when output takes more than one line
hi NonText          guifg=#444444
"hi NonText          ctermfg=238                                     cterm=NONE
" by laravel
hi NonText ctermfg=59 ctermbg=59 cterm=NONE guifg=#3b3a32 guibg=#373534 gui=NONE
" the hit-enter prompt (show more output) and yes/no questions
hi Question         guifg=fg                                        gui=NONE
hi Question         ctermfg=fg                                      cterm=NONE
" meta and special keys used with map, unprintable characters
hi SpecialKey       guifg=#505050
hi SpecialKey       ctermfg=238
" titles for output from :set all, :autocmd, etc
hi Title            guifg=#ffe3b2	                                gui=NONE
hi Title            ctermfg=38                                      cterm=NONE
"hi Title            guifg=#5ec8e5                                   gui=NONE
" warning messages
hi WarningMsg       guifg=#e5786d                                   gui=NONE
hi WarningMsg       ctermfg=173                                     cterm=NONE
" current match in the wildmenu completion
hi WildMenu         guifg=#000000           guibg=#cae682
hi WildMenu         ctermfg=16              ctermbg=186             


" Diff
" ----
" added line
hi DiffAdd          guifg=fg                guibg=#008b8b
hi DiffAdd          ctermfg=fg              ctermbg=30
" changed line
hi DiffChange       guifg=fg                guibg=#008b00
hi DiffChange       ctermfg=fg              ctermbg=28
" deleted line
hi DiffDelete       guifg=fg                guibg=#000000
hi DiffDelete       ctermfg=fg              ctermbg=16
" changed text within line
hi DiffText         guifg=fg
hi DiffText         ctermfg=fg


" Folds
" -----
" line used for closed folds
hi Folded           guifg=#f6f6f6           guibg=#777777           gui=NONE
hi Folded           ctermfg=145             ctermbg=238             cterm=NONE
" column on side used to indicated open and closed folds
hi FoldColumn       guifg=#b0d0e0           guibg=#305060           gui=NONE
hi FoldColumn       ctermfg=152             ctermbg=23              cterm=NONE

" Search
" ------
" highlight incremental search text; also highlight text replaced with :s///c
hi IncSearch        guifg=#66ffff                                   gui=reverse
hi IncSearch        ctermfg=87                                      cterm=reverse
" hlsearch (last search pattern), also used for quickfix
hi Search                                    guibg=#ffaa33          gui=NONE
hi Search                                    ctermbg=214            cterm=NONE

" Popup Menu
" ----------
" normal item in popup
hi Pmenu            guifg=#f6f3e8           guibg=#444444           gui=NONE
hi Pmenu            ctermfg=254             ctermbg=238             cterm=NONE
" selected item in popup
hi PmenuSel         guifg=#000000           guibg=#cae682           gui=NONE
hi PmenuSel         ctermfg=16              ctermbg=186             cterm=NONE
" scrollbar in popup
hi PMenuSbar                                guibg=#607b8b           gui=NONE
hi PMenuSbar                                ctermbg=66              cterm=NONE
" thumb of the scrollbar in the popup
hi PMenuThumb                               guibg=#aaaaaa           gui=NONE
hi PMenuThumb                               ctermbg=247             cterm=NONE


" Status Line
" -----------
" status line for current window
hi StatusLine       guifg=#e0e0e0           guibg=#444444           gui=NONE
hi StatusLine       ctermfg=254             ctermbg=238             cterm=NONE
" status line for non-current windows
hi StatusLineNC     guifg=#777777           guibg=#444444           gui=NONE
hi StatusLineNC     ctermfg=244             ctermbg=238             cterm=NONE


" Tab Lines
" ---------
" tab pages line, not active tab page label
hi TabLine          guifg=#b6bf98           guibg=#181818           gui=NONE
hi TabLine          ctermfg=244             ctermbg=233             cterm=NONE
" tab pages line, where there are no labels
hi TabLineFill      guifg=#cfcfaf           guibg=#181818           gui=NONE
hi TabLineFill      ctermfg=187             ctermbg=233             cterm=NONE
" tab pages line, active tab page label
hi TabLineSel       guifg=#efefef           guibg=#1c1c1b           gui=NONE
hi TabLineSel       ctermfg=233             ctermbg=187             cterm=NONE


" Visual
" ------
" visual mode selection
hi Visual           guifg=NONE              guibg=#445566
hi Visual           ctermfg=NONE            ctermbg=60
" visual mode selection when vim is 'not owning the selection' (x11 only)
hi VisualNOS        guifg=fg                                        gui=underline
hi VisualNOS        ctermfg=fg                                      cterm=underline

"------------Plugin: gitgutter------------
highlight GitGutterAdd     guifg=#009900 guibg=NONE ctermfg=2 ctermbg=NONE cterm=bold
highlight GitGutterChange  guifg=#bbbb00 guibg=NONE ctermfg=3 ctermbg=NONE cterm=bold
highlight GitGutterDelete  guifg=#ff2222 guibg=NONE ctermfg=1 ctermbg=NONE cterm=bold
"------------Plugin: gitgutter------------
