" Settings for editing plain text. These are loaded automatically (on top of
" existing settings) when editing files vim autodetects as mail.
"
" This corresponds conveniently to writing messages in mutt.
"
" Michael Kelly
" Mon Apr 14 22:20:57 EDT 2014

set textwidth=72
set comments=nb:>
" t = auto-wrap text at textwidth
" c = auto-wrap comments at textwidth
" q = allow formatting comments with "gq"
" a = automatic paragraph formatting
" w = only lines ending in whitespace indicate paragraph continuation
set formatoptions=tcqaw
