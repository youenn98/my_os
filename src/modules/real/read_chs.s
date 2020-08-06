read_chs:	
			; +8 ���Ƶ�Ŀ�ĵ�
			; +6 sector��
			; +4 parameter  buffer
	push bp
	mov bp,sp
	push 3 ;//���ԵĴ���
	push 0 ;//�����sector��

	push bx
	push cx
	push dx
	push es
	push si

	mov si,[bp+4]    ;SI = SRC����

	;------------------
	;CX�Ĵ������趨
	;------------------
	mov ch,[si + drive.cyln+0]  ;//ch = cylinder��
	mov cl,[si + drive.cyln+1]  ;//cl = cylinder��
	shl cl,6 ;// ch << 6 ���������λ����(cylinder��10λ)
	or cl,[si + drive.sect]    ;//��6λ��sector�����õ�cx�Ĵ����ĵ���λ

	;--------------------
	;��ȡsector
	;---------------------
	mov dh,[si + drive.head] ;//head��
	mov dl,[si+0];         ;//������
	mov ax,0x0000        
	mov es,ax
	mov bx,[bp+8]      ;//���Ƶ�Ŀ�ĵ�
.10L:
	
	mov ah,0x02     ;//��ȡsector������
	mov al,[bp+6] ;//sector��

	int 0X13
	jnc .11E		;//���CF��������
	mov al,0		;//al = 0
	jmp .10E

.11E:

	cmp al,0		
	jne .10E  ;//����ж���sector,����������,��������

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







