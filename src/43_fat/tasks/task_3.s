;************************************************************************
;	TASK
;************************************************************************
task_3:
	
		mov		ebp, esp						; EBP+ 0| E
												; ---------------
		push	dword 0							;    - 4| x0 = 0; // X����ԭ��
		push	dword 0							;    - 8| y0 = 0; // Y����ԭ��
		push	dword 0							;    -12| x  = 0; // X�����軭
		push	dword 0							;    -16| y  = 0; // Y�����軭
		push	dword 0							;    -20| r  = 0; // �Ƕ�


		mov		esi, 0x0010_7000					; ESI = �軭parameter

		;---------------------------------------
		; ��ʾtitle
		;---------------------------------------
		mov		eax, [esi + rose.x0]			; X0����
		mov		ebx, [esi + rose.y0]			; Y0����

		shr		eax, 3							; EAX = EAX /  8; // ��X����ת�������λ��
		shr		ebx, 4							; EBX = EBX / 16; // ��Y����ת�������λ��
		dec		ebx								; // �����ƶ�һ���ַ�
		mov		ecx, [esi + rose.color_s]		; ������ɫ
		lea		edx, [esi + rose.title]			; title

		cdecl	draw_str, eax, ebx, ecx, edx	; draw_str();

		;---------------------------------------
		; X����е�
		;---------------------------------------
		mov		eax, [esi + rose.x0]			; EAX  = X0����
		mov		ebx, [esi + rose.x1]			; EBX  = X1����
		sub		ebx, eax						; EBX  = (X1 - X0);
		shr		ebx, 1							; EBX /= 2;
		add		ebx, eax						; EBX += X0
		mov		[ebp - 4], ebx					; x0 = EBX; // X����ԭ��;

		;---------------------------------------
		; Y����е�
		;---------------------------------------
		mov		eax, [esi + rose.y0]			; EAX  = Y0����
		mov		ebx, [esi + rose.y1]			; EBX  = Y1����
		sub		ebx, eax						; EBX  = (Y1 - Y0);
		shr		ebx, 1							; EBX /= 2;
		add		ebx, eax						; EBX += Y0
		mov		[ebp - 8], ebx					; y0 = EBX; // Y������ԭ��;

		;---------------------------------------
		; ��X��
		;---------------------------------------
		mov		eax, [esi + rose.x0]			; EAX = X0����;
		mov		ebx, [ebp - 8]					; EBX = Y����е�;
		mov		ecx, [esi + rose.x1]			; ECX = X1����;

		cdecl	draw_line, eax, ebx, ecx, ebx, dword [esi + rose.color_x]	; X��

		;---------------------------------------
		; ��Y��
		;---------------------------------------
		mov		eax, [esi + rose.y0]			; Y0����
		mov		ebx, [ebp - 4]					; EBX = X����е�;
		mov		ecx, [esi + rose.y1]			; Y1����

		cdecl	draw_line, ebx, eax, ebx, ecx, dword [esi + rose.color_y]	; Y��

		;---------------------------------------
		; ���軭
		;---------------------------------------
		mov		eax, [esi + rose.x0]			; X0����
		mov		ebx, [esi + rose.y0]			; Y0����
		mov		ecx, [esi + rose.x1]			; X1����
		mov		edx, [esi + rose.y1]			; Y1����

		cdecl	draw_rect, eax, ebx, ecx, edx, dword [esi + rose.color_z]	; ��

		;---------------------------------------
		; ���������ΪX���Լ95%
		;---------------------------------------
		mov		eax, [esi + rose.x1]			; EAX  = X1����;
		sub		eax, [esi + rose.x0]			; EAX -= X0����;
		shr		eax, 1							; EAX /= 2;      // һ��
		mov		ebx, eax						; EBX  = EAX;
		shr		ebx, 4							; EBX /= 16;
		sub		eax, ebx						; EAX -= EBX;

		;---------------------------------------
		; FPU�ĳ�ʼ��(õ�����ߵĳ�ʼ��)
		;---------------------------------------
		cdecl	fpu_rose_init					\
					, eax						\
					, dword [esi + rose.n]		\
					, dword [esi + rose.d]

		;---------------------------------------
		; 
		;---------------------------------------
.10L:											; for ( ; ; )
												; {
		;---------------------------------------
		; �������
		;---------------------------------------
		lea		ebx, [ebp -12]					;   EBX = &x;
		lea		ecx, [ebp -16]					;   ECX = &y;
		mov		eax, [ebp -20]					;   EAX = r;

		cdecl	fpu_rose_update	,ebx,ecx,eax

		;---------------------------------------
		; �Ƕȸ���(r = r % 36000)
		;---------------------------------------
		mov		edx, 0							;   EDX = 0;
		inc		eax								;   EAX++;
		mov		ebx, 360 * 100					;   DBX = 36000
		div		ebx								;   EDX = EDX:EAX % EBX;
		mov		[ebp -20], edx

		;---------------------------------------
		; �������
		;---------------------------------------
		mov		ecx, [ebp -12]					;   ECX = X����
		mov		edx, [ebp -16]					;   ECX = Y����

		add		ecx, [ebp - 4]					;   ECX += X����ԭ��;
		add		edx, [ebp - 8]					;   EDX += Y����ԭ��;

		mov		ebx, [esi + rose.color_f]		;   EBX = ��ʾ��ɫ;
		int		0x82							;   sys_call_82(��ʾ��ɫ, X, Y);

		;---------------------------------------
		; wait
		;---------------------------------------
		cdecl	wait_tick, 2					;   wait_tick(2);

		;---------------------------------------
		; dot�軭(��ȥ)
		;---------------------------------------
		mov		ebx, [esi + rose.color_b]		;   EBX = ����ɫ;
		int		0x82							;   sys_call_82(��ʾɫ, X, Y);


        jmp     .10L                            ; }


ALIGN 4, db 0
DRAW_PARAM:											;// �軭parameter
.t3:
	istruc	rose
		at	rose.x0,		dd		 32			; ��������:X0
		at	rose.y0,		dd		 32			; ��������:Y0
		at	rose.x1,		dd		208			; ��������:X1
		at	rose.y1,		dd		208			; ��������:Y1

		at	rose.n,			dd		2			; ����:n
		at	rose.d,			dd		1			; ����:d

		at	rose.color_x,	dd		0x0007		; �軭��ɫ:X��
		at	rose.color_y,	dd		0x0007		; �軭��ɫ:Y��
		at	rose.color_z,	dd		0x000F		; �軭ɫ:����
		at	rose.color_s,	dd		0x030F		; �軭ɫ:����
		at	rose.color_f,	dd		0x000F		; �軭ɫ:graph�軭ɫ
		at	rose.color_b,	dd		0x0003		; �軭ɫ:graph��ȥɫ

		at	rose.title,		db		"Task-3", 0	; title

	iend

.t4:
	istruc	rose
		at	rose.x0,		dd		 248		; ��������:X0
		at	rose.y0,		dd		 32			; ��������:Y0
		at	rose.x1,		dd		424			; ��������:X1
		at	rose.y1,		dd		208			; ��������:Y1

		at	rose.n,			dd		3			; ����:n
		at	rose.d,			dd		1			; ����:d

		at	rose.color_x,	dd		0x0007		; �軭��ɫ:X��
		at	rose.color_y,	dd		0x0007		; �軭��ɫ:Y��
		at	rose.color_z,	dd		0x000F		; �軭ɫ:����
		at	rose.color_s,	dd		0x040F		; �軭ɫ:����
		at	rose.color_f,	dd		0x000F		; �軭ɫ:graph�軭ɫ
		at	rose.color_b,	dd		0x0004		; �軭ɫ:graph��ȥɫ

		at	rose.title,		db		"Task-4", 0	; title

	iend

.t5:
	istruc	rose
		at	rose.x0,		dd		 32			; ��������:X0
		at	rose.y0,		dd		272			; ��������:Y0
		at	rose.x1,		dd		208			; ��������:X1
		at	rose.y1,		dd		448			; ��������:Y1

		at	rose.n,			dd		2			; ����:n
		at	rose.d,			dd		6			; ����:d

		at	rose.color_x,	dd		0x0007		; �軭��ɫ:X��
		at	rose.color_y,	dd		0x0007		; �軭��ɫ:Y��
		at	rose.color_z,	dd		0x000F		; �軭ɫ:����
		at	rose.color_s,	dd		0x050F		; �軭ɫ:����
		at	rose.color_f,	dd		0x000F		; �軭ɫ:graph�軭ɫ
		at	rose.color_b,	dd		0x0005		; �軭ɫ:graph��ȥɫ

		at	rose.title,		db		"Task-5", 0	; title

	iend

.t6:
	istruc	rose
		at	rose.x0,		dd		248			; ��������:X0
		at	rose.y0,		dd		272			; ��������:Y0
		at	rose.x1,		dd		424			; ��������:X1
		at	rose.y1,		dd		448			; ��������:Y1

		at	rose.n,			dd		4			; ����:n
		at	rose.d,			dd		6			; ����:d

		at	rose.color_x,	dd		0x0007		; �軭��ɫ:X��
		at	rose.color_y,	dd		0x0007		; �軭��ɫ:Y��
		at	rose.color_z,	dd		0x000F		; �軭ɫ:����
		at	rose.color_s,	dd		0x060F		; �軭ɫ:����
		at	rose.color_f,	dd		0x000F		; �軭ɫ:graph�軭ɫ
		at	rose.color_b,	dd		0x0006		; �軭ɫ:graph��ȥɫ

		at	rose.title,		db		"Task-6", 0	; title

	iend
;************************************************************************
;
;	Z = A * sin(n��)
;	  = A * sin( (n/d) * ((��/180) * t) )
;
;	x = A * sin(n��) * cos(��)
;	y = A * sin(n��) * sin(��)
;************************************************************************
fpu_rose_init:
		
												
		push	ebp								
		mov		ebp, esp						
												
		push	dword 180

		;---------------------------------------
		; FPU���g��������
		;
		; A(�U��), k(n/d),r(�x�����f�B�A��)��
		; FPU���̃��W�X�^�ɃX�^�b�N���Ă���
		;---------------------------------------
												; ---------+---------+---------|---------|---------|---------|
												;       ST0|      ST1|      ST2|      ST3|      ST4|      ST5|
												; ---------+---------+---------|---------|---------|---------|
		fldpi									;   pi     |xxxxxxxxx|xxxxxxxxx|xxxxxxxxx|xxxxxxxxx|xxxxxxxxx|
		fidiv	dword [ebp - 4]					;   pi/180 |xxxxxxxxx|xxxxxxxxx|xxxxxxxxx|xxxxxxxxx|xxxxxxxxx|
		fild	dword [ebp +12]					;        n |  pi/180 |xxxxxxxxx|xxxxxxxxx|xxxxxxxxx|xxxxxxxxx|
		fidiv	dword [ebp +16]					;      n/d |         |xxxxxxxxx|xxxxxxxxx|xxxxxxxxx|xxxxxxxxx|
		fild	dword [ebp + 8]					;        A |     n/d |  pi/180 |xxxxxxxxx|xxxxxxxxx|xxxxxxxxx|
												; ---------+---------+---------|---------|---------|---------|
												;        A |       k |       r |xxxxxxxxx|xxxxxxxxx|xxxxxxxxx|
												; ---------+---------+---------|---------|---------|---------|
	
		mov		esp, ebp
		pop		ebp

		ret

;************************************************************************

;************************************************************************
fpu_rose_update:
	
												
		push	ebp								
		mov		ebp, esp			
												

	
		push	eax
		push	ebx

		;---------------------------------------
		; X/Y�������
		;---------------------------------------
		mov		eax, [ebp +  8]					; EAX = pX; // X����
		mov		ebx, [ebp + 12]					; EBX = pY; // Y����

		;---------------------------------------
		;
		;---------------------------------------
												; ---------+---------+---------|---------|---------|---------|
												;       ST0|      ST1|      ST2|      ST3|      ST4|      ST5|
												; ---------+---------+---------|---------|---------|---------|
		fild	dword [ebp +16]					;        t |       A |       k |       r |xxxxxxxxx|xxxxxxxxx|
		fmul	st0, st3						;       rt |         |         |         |         |         |
		fld		st0								;       rt |      rt |       A |       k |       r |xxxxxxxxx|
												; ---------+---------+---------|---------|---------|---------|
		;										;       �� |      �� |       A |       k |       r |         |
												; ---------+---------+---------|---------|---------|---------|
		fsincos									;   cos(��)|  sin(��)|      �� |       A |       k |       r |
		fxch	st2								;       �� |         |  cos(��)|         |         |         |
		fmul	st0, st4						;      k�� |         |         |         |         |         |
		fsin									;  sin(k��)|         |         |         |         |         |
		fmul	st0, st3						; Asin(k��)|         |         |         |         |         |
												; ---------+---------+---------|---------|---------|---------|
												; Asin(k��)|  sin(��)|  cos(��)|       A |       k |       r |
												; ---------+---------+---------|---------|---------|---------|
		;---------------------------------------
		; x =  A * sin(k��) * cos(��);
		;---------------------------------------
												; ---------+---------+---------|---------|---------|---------|
												;       ST0|      ST1|      ST2|      ST3|      ST4|      ST5|
												; ---------+---------+---------|---------|---------|---------|
												; Asin(k��)|  sin(��)|  cos(��)|       A |       k |       r |
		fxch	st2								;   cos(��)|         |Asin(k��)|         |         |         |
		fmul	st0, st2						;        x |         |         |         |         |         |
		fistp	dword [eax]						;   sin(��)|Asin(k��)|       A |       k |       r |xxxxxxxxx|
												; ---------+---------+---------|---------|---------|---------|
		;---------------------------------------
		; y = -A * sin(k��) * sin(��);
		;---------------------------------------
												; ---------+---------+---------|---------|---------|---------|
												;       ST0|      ST1|      ST2|      ST3|      ST4|      ST5|
												; ---------+---------+---------|---------|---------|---------|
												;   sin(��)|Asin(k��)|       A |       k |       r |xxxxxxxxx|
		fmulp	st1, st0						;        y |       A |       k |       r |xxxxxxxxx|xxxxxxxxx|
		fchs									;       -y |         |         |         |xxxxxxxxx|xxxxxxxxx|
		fistp	dword [ebx]						;        A |       k |       r |xxxxxxxxx|xxxxxxxxx|xxxxxxxxx|
												; ---------+---------+---------|---------|---------|---------|
		pop		ebx
		pop		eax

		mov		esp, ebp
		pop		ebp

		ret

