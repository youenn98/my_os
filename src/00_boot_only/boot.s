entry:
	jmp	$			;while(1);//无限循环
	;***********什么都不做的boot***********
	times 510 - ($ - $$)  db 0x00
	db 0x55, 0xAA 