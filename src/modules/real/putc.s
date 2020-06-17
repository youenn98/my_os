putc:
	
					;+4 | 输出字符
					;+2 | IP 返回地址
	push bp			;BP + 0|BP(原来的值)
	mov bp,sp       

	;----------------
	;保存寄存器的值
	;-----------------
	push ax
	push bx
	;-----------------------
	;打印字符
	;-----------------------
	mov al,[bp+4]
	mov ah,0x0E
	mov bx,0x0000
	int 0x10
	;----------------
	;复原寄存器的值
	;----------------

	pop bx
	pop ax

	mov sp,bp
	pop bp

	ret