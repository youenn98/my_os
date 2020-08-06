read_chs:	
			; +8 复制的目的地
			; +6 sector数
			; +4 parameter  buffer
	push bp
	mov bp,sp
	push 3 ;//重试的次数
	push 0 ;//读入的sector数

	push bx
	push cx
	push dx
	push es
	push si

	mov si,[bp+4]    ;SI = SRC缓存

	;------------------
	;CX寄存器的设定
	;------------------
	mov ch,[si + drive.cyln+0]  ;//ch = cylinder号
	mov cl,[si + drive.cyln+1]  ;//cl = cylinder号
	shl cl,6 ;// ch << 6 数据向最高位对齐(cylinder号10位)
	or cl,[si + drive.sect]    ;//将6位的sector号设置到cx寄存器的低六位

	;--------------------
	;读取sector
	;---------------------
	mov dh,[si + drive.head] ;//head号
	mov dl,[si+0];         ;//驱动号
	mov ax,0x0000        
	mov es,ax
	mov bx,[bp+8]      ;//复制的目的地
.10L:
	
	mov ah,0x02     ;//读取sector的命令
	mov al,[bp+6] ;//sector数

	int 0X13
	jnc .11E		;//如果CF被设置了
	mov al,0		;//al = 0
	jmp .10E

.11E:

	cmp al,0		
	jne .10E  ;//如果有读到sector,则正常运行,否走重试

	mov ax,0
	dec word[bp-2]
	jnz .10L
.10E:
	mov ah,0

	pop si
	pop es
	pop dx
	pop cx
	pop bx

	mov sp,bp
	pop bp
	ret







