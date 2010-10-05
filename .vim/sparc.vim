syntax match asmComment	"!.*"hs=s+1
syntax region asmComment	start="/\*" end="\*/"
syntax match asmDirective	"	[a-z][a-z]\+	"
syntax match asmLabel	"^[a-z_][a-z_]*:"he=e-1
syntax region asmString	start=+L\="+ skip=+\\\\\|\\"+ end=+"+

highlight link asmString Constant
highlight link asmLabel PreProc

