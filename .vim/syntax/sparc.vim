syntax match  asmComment	"!.*"
syntax region asmComment	start="/\*" end="\*/"
syntax match  asmDirective	"	[a-z][a-z]\+\(	\|,a	\|\)"
syntax match  asmLabel		"^[a-zA-Z_][a-zA-Z_]*:"he=e-1
syntax region asmString		start=+L\="+ skip=+\\\\\|\\"+ end=+"+

" surely these are called something other than "dot commands"...
syntax match  asmDotCmd		"\.\(section\|global\|ascii\|asciz\|byte\|halfword\|word\|dword\|single\|double\)[	 ]"he=e-1

" registers: we disallow %i6 and %o6 in favor of %sp and %fp
syntax match  asmReg		"%\(g[0-7]\|o[0-5]\|sp\|o7\|l[0-7]\|i[0-5]\|fp\|i7\)"

" some of these are highly suspect
highlight link asmString	Constant
highlight link asmLabel		PreProc
highlight link asmReg		Constant
highlight link asmDotCmd	Keyword

