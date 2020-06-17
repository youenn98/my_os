reboot:
	;---------------------
	;表示重启信息
	;--------------------
	cdecl puts, .s0

	;-----------------
	;等待输入
	;-----------------

.10L:
	
	mov ah,0x10
	int 0x16

	cmp al,''  ;//如果缓冲区有数据,等待用户输入回车
	jne .10L  

	;------------------------------
	;换行
	;-----------------------------

	cdecl puts, .s1

	int 0x19 ;//重启

.s0 db 0x0A,0x0D,"PUSH SPACE key to reboot...",0x0A
.s1 db 0x0A,0x0D,0x0A,0x0D,0