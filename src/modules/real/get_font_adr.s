get_font_adr:
	
	push bp
	mov bp,sp

	push ax
	push bx
	push si
	push es
	push bp


	mov si,[bp + 4]

	mov ax,0x1130 ;//��ȡfont address 
	mov bh,0x06	  ;//8x16
	int 10h       ;//������ES:BP��

	;//����font address
	mov [si + 0],es
	mov [si + 2],bp

	pop		bp
	pop		es
	pop		si
	pop		bx
	pop		ax

	mov sp,bp
	pop bp

	ret
