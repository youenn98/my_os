itoa:
		;	+12|符号
		;	+10|基数
		;	+8 |缓存的大小
		;	+6 |缓存的地址
		;	+4 |数值
		;	+2 |IP (返回地址)
		; BP+0 | 原来的BP

	push bp
	mov bp,sp

	push ax
	push bx
	push cx
	push dx
	push si
	push di


	mov ax,[bp + 4] ;//ax = 数值
	mov si,[bp + 6] ;//si = 缓存地址
	mov cx,[bp + 8] ;//cx = 缓存地址容量
	mov di , si	  ;//di = 缓存的最后
	add di , cx
	dec di

	mov bx,word[bp+12] ;//bx = flag

	;--------------
	;判断是否是有符号数
	;--------------
	test bx,0b0001   ;//(bx&0x01) 如果最后一位是1,说明是带符号的
.10Q: je .10E       
	 cmp ax,0        ;//如果 ax < 0
.12Q: jge  .12E
	or   bx,0b0010  ;//表示符号
.12E:
.10E:


	;-------------------
	;判定输出什么符号
	;--------------------
	test bx,0b0010 ;//(bx&0x02) 如果是不是0,则说明需要设置符号
.20Q: je .20E
	 cmp ax,0
.22Q: jge .22F
	neg ax
	mov [si],byte'-'
	jmp .22E
.22F:

	mov  [si],byte'+'
.22E:
	dec cx   ;//size--

.20E:

	;---------------------
	;ASCII变换
	;--------------------
	mov bx,[bp+10] ;//BX = 基数
.30L:
	
	mov dx,0
	div bx      ;//dx = AX%基数
				;//ax = AX/基数
	mov si,dx
	mov dl,byte[.ascii+si] ;//dl = ASCII[DX]

	mov [di],dl  ;//*dst = dl

	dec di		; dst--;

	cmp ax,0             ;
	loopnz .30L   ;//while(ax)
.30E:
	
	;-------------------
	;填满换缓存剩余空格
	;-------------------

	cmp cx,0  ;//如果没有缓存剩余则完成
.40Q: je   .40E
	  mov  al,' ' ;//空字符填充
	  cmp [bp+12],word 0b0100 
.42Q jne .42E
	 mov al,'0'  ;// 用0填充
.42E:
	std       ;//DF = 1 (地址递减)
	rep stosb    ;//while(--CX) *DI-- = al;
.40E:

	pop di
	pop si
	pop dx
	pop cx
	pop bx
	pop ax

	mov sp,bp
	pop bp

	ret

.ascii db "0123456789ABCDEF"