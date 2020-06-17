entry:
	jmp ipl
	;------------------
	;BPB(BIOS Parameter Block)
	;------------------
	times 90 -($-$$) db 0x90

	;----------------------------
	;IPL(Initial Pragram Loader)
ipl:

	;------------------
	;结束处理
	;------------------

	times 510 -($-$$) db 0x00
	db 0x55,0xAA
