itoa:
		;	+12|����
		;	+10|����
		;	+8 |����Ĵ�С
		;	+6 |����ĵ�ַ
		;	+4 |��ֵ
		;	+2 |IP (���ص�ַ)
		; BP+0 | ԭ����BP

	push bp
	mov bp,sp

	push ax
	push bx
	push cx
	push dx
	push si
	push di


	mov ax,[bp + 4] ;//ax = ��ֵ
	mov si,[bp + 6] ;//si = �����ַ
	mov cx,[bp + 8] ;//cx = �����ַ����
	mov di , si	  ;//di = ��������
	add di , cx
	dec di

	mov bx,word[bp+12] ;//bx = flag

	;--------------
	;�ж��Ƿ����з�����
	;--------------
	test bx,0b0001   ;//(bx&0x01) ������һλ��1,˵���Ǵ����ŵ�
.10Q: je .10E       
	 cmp ax,0        ;//��� ax < 0
.12Q: jge  .12E
	or   bx,0b0010  ;//��ʾ����
.12E:
.10E:


	;-------------------
	;�ж����ʲô����
	;--------------------
	test bx,0b0010 ;//(bx&0x02) ����ǲ���0,��˵����Ҫ���÷���
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
	;ASCII�任
	;--------------------
	mov bx,[bp+10] ;//BX = ����
.30L:
	
	mov dx,0
	div bx      ;//dx = AX%����
				;//ax = AX/����
	mov si,dx
	mov dl,byte[.ascii+si] ;//dl = ASCII[DX]

	mov [di],dl  ;//*dst = dl

	dec di		; dst--;

	cmp ax,0             ;
	loopnz .30L   ;//while(ax)
.30E:
	
	;-------------------
	;����������ʣ��ո�
	;-------------------

	cmp cx,0  ;//���û�л���ʣ�������
.40Q: je   .40E
	  mov  al,' ' ;//���ַ����
	  cmp [bp+12],word 0b0100 
.42Q jne .42E
	 mov al,'0'  ;// ��0���
.42E:
	std       ;//DF = 1 (��ַ�ݼ�)
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