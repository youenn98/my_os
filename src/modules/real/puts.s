puts:
	push bp
	mov bp,sp

	push ax
	push bx
	push si

	;**************
	;ȡ���ַ����Ŀ�ʼ��ַ
	;**************
	mov si,[bp+4]

	mov ah,0x0E
	mov bx,0x0000
	cld    ;//DF = 0 ��ַ����

.10L:
	
	lodsb ;//AL = *SI++

	cmp al,0	;//if(AL == 0)
	je	.10E	;//breal

	int 0x10
	jmp .10L
.10E:

	pop si
	pop bx
	pop ax

	mov sp,bp
	pop bp

	ret