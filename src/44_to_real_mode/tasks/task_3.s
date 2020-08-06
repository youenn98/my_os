;************************************************************************
;	TASK
;************************************************************************
task_3:
	
		mov		ebp, esp						; EBP+ 0| E
												; ---------------
		push	dword 0							;    - 4| x0 = 0; // X坐标原点
		push	dword 0							;    - 8| y0 = 0; // Y坐标原点
		push	dword 0							;    -12| x  = 0; // X坐标描画
		push	dword 0							;    -16| y  = 0; // Y坐标描画
		push	dword 0							;    -20| r  = 0; // 角度


		mov		esi, 0x0010_7000					; ESI = 描画parameter

		;---------------------------------------
		; 表示title
		;---------------------------------------
		mov		eax, [esi + rose.x0]			; X0坐标
		mov		ebx, [esi + rose.y0]			; Y0坐标

		shr		eax, 3							; EAX = EAX /  8; // 将X坐标转变成文字位置
		shr		ebx, 4							; EBX = EBX / 16; // 将Y坐标转变成文字位置
		dec		ebx								; // 往上移动一个字符
		mov		ecx, [esi + rose.color_s]		; 文字颜色
		lea		edx, [esi + rose.title]			; title

		cdecl	draw_str, eax, ebx, ecx, edx	; draw_str();

		;---------------------------------------
		; X轴的中点
		;---------------------------------------
		mov		eax, [esi + rose.x0]			; EAX  = X0坐标
		mov		ebx, [esi + rose.x1]			; EBX  = X1坐标
		sub		ebx, eax						; EBX  = (X1 - X0);
		shr		ebx, 1							; EBX /= 2;
		add		ebx, eax						; EBX += X0
		mov		[ebp - 4], ebx					; x0 = EBX; // X坐标原点;

		;---------------------------------------
		; Y轴的中点
		;---------------------------------------
		mov		eax, [esi + rose.y0]			; EAX  = Y0坐标
		mov		ebx, [esi + rose.y1]			; EBX  = Y1坐标
		sub		ebx, eax						; EBX  = (Y1 - Y0);
		shr		ebx, 1							; EBX /= 2;
		add		ebx, eax						; EBX += Y0
		mov		[ebp - 8], ebx					; y0 = EBX; // Y轴坐标原点;

		;---------------------------------------
		; 画X轴
		;---------------------------------------
		mov		eax, [esi + rose.x0]			; EAX = X0坐标;
		mov		ebx, [ebp - 8]					; EBX = Y轴的中点;
		mov		ecx, [esi + rose.x1]			; ECX = X1坐标;

		cdecl	draw_line, eax, ebx, ecx, ebx, dword [esi + rose.color_x]	; X轴

		;---------------------------------------
		; 画Y轴
		;---------------------------------------
		mov		eax, [esi + rose.y0]			; Y0坐标
		mov		ebx, [ebp - 4]					; EBX = X轴的中点;
		mov		ecx, [esi + rose.y1]			; Y1坐标

		cdecl	draw_line, ebx, eax, ebx, ecx, dword [esi + rose.color_y]	; Y轴

		;---------------------------------------
		; 框描画
		;---------------------------------------
		mov		eax, [esi + rose.x0]			; X0坐标
		mov		ebx, [esi + rose.y0]			; Y0坐标
		mov		ecx, [esi + rose.x1]			; X1坐标
		mov		edx, [esi + rose.y1]			; Y1坐标

		cdecl	draw_rect, eax, ebx, ecx, edx, dword [esi + rose.color_z]	; 框

		;---------------------------------------
		; 将振幅设置为X轴的约95%
		;---------------------------------------
		mov		eax, [esi + rose.x1]			; EAX  = X1坐标;
		sub		eax, [esi + rose.x0]			; EAX -= X0坐标;
		shr		eax, 1							; EAX /= 2;      // 一半
		mov		ebx, eax						; EBX  = EAX;
		shr		ebx, 4							; EBX /= 16;
		sub		eax, ebx						; EAX -= EBX;

		;---------------------------------------
		; FPU的初始化(玫瑰曲线的初始化)
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
		; 坐标计算
		;---------------------------------------
		lea		ebx, [ebp -12]					;   EBX = &x;
		lea		ecx, [ebp -16]					;   ECX = &y;
		mov		eax, [ebp -20]					;   EAX = r;

		cdecl	fpu_rose_update	,ebx,ecx,eax

		;---------------------------------------
		; 角度更新(r = r % 36000)
		;---------------------------------------
		mov		edx, 0							;   EDX = 0;
		inc		eax								;   EAX++;
		mov		ebx, 360 * 100					;   DBX = 36000
		div		ebx								;   EDX = EDX:EAX % EBX;
		mov		[ebp -20], edx

		;---------------------------------------
		; 坐标更新
		;---------------------------------------
		mov		ecx, [ebp -12]					;   ECX = X坐标
		mov		edx, [ebp -16]					;   ECX = Y坐标

		add		ecx, [ebp - 4]					;   ECX += X坐标原点;
		add		edx, [ebp - 8]					;   EDX += Y坐标原点;

		mov		ebx, [esi + rose.color_f]		;   EBX = 表示颜色;
		int		0x82							;   sys_call_82(表示颜色, X, Y);

		;---------------------------------------
		; wait
		;---------------------------------------
		cdecl	wait_tick, 2					;   wait_tick(2);

		;---------------------------------------
		; dot描画(消去)
		;---------------------------------------
		mov		ebx, [esi + rose.color_b]		;   EBX = 背景色;
		int		0x82							;   sys_call_82(表示色, X, Y);


        jmp     .10L                            ; }


ALIGN 4, db 0
DRAW_PARAM:											;// 描画parameter
.t3:
	istruc	rose
		at	rose.x0,		dd		 32			; 左上坐标:X0
		at	rose.y0,		dd		 32			; 左上坐标:Y0
		at	rose.x1,		dd		208			; 右下坐标:X1
		at	rose.y1,		dd		208			; 右下坐标:Y1

		at	rose.n,			dd		2			; 变数:n
		at	rose.d,			dd		1			; 变数:d

		at	rose.color_x,	dd		0x0007		; 描画颜色:X轴
		at	rose.color_y,	dd		0x0007		; 描画颜色:Y轴
		at	rose.color_z,	dd		0x000F		; 描画色:轮廓
		at	rose.color_s,	dd		0x030F		; 描画色:文字
		at	rose.color_f,	dd		0x000F		; 描画色:graph描画色
		at	rose.color_b,	dd		0x0003		; 描画色:graph消去色

		at	rose.title,		db		"Task-3", 0	; title

	iend

.t4:
	istruc	rose
		at	rose.x0,		dd		 248		; 左上坐标:X0
		at	rose.y0,		dd		 32			; 左上坐标:Y0
		at	rose.x1,		dd		424			; 右下坐标:X1
		at	rose.y1,		dd		208			; 右下坐标:Y1

		at	rose.n,			dd		3			; 变数:n
		at	rose.d,			dd		1			; 变数:d

		at	rose.color_x,	dd		0x0007		; 描画颜色:X轴
		at	rose.color_y,	dd		0x0007		; 描画颜色:Y轴
		at	rose.color_z,	dd		0x000F		; 描画色:轮廓
		at	rose.color_s,	dd		0x040F		; 描画色:文字
		at	rose.color_f,	dd		0x000F		; 描画色:graph描画色
		at	rose.color_b,	dd		0x0004		; 描画色:graph消去色

		at	rose.title,		db		"Task-4", 0	; title

	iend

.t5:
	istruc	rose
		at	rose.x0,		dd		 32			; 左上坐标:X0
		at	rose.y0,		dd		272			; 左上坐标:Y0
		at	rose.x1,		dd		208			; 右下坐标:X1
		at	rose.y1,		dd		448			; 右下坐标:Y1

		at	rose.n,			dd		2			; 变数:n
		at	rose.d,			dd		6			; 变数:d

		at	rose.color_x,	dd		0x0007		; 描画颜色:X轴
		at	rose.color_y,	dd		0x0007		; 描画颜色:Y轴
		at	rose.color_z,	dd		0x000F		; 描画色:轮廓
		at	rose.color_s,	dd		0x050F		; 描画色:文字
		at	rose.color_f,	dd		0x000F		; 描画色:graph描画色
		at	rose.color_b,	dd		0x0005		; 描画色:graph消去色

		at	rose.title,		db		"Task-5", 0	; title

	iend

.t6:
	istruc	rose
		at	rose.x0,		dd		248			; 左上坐标:X0
		at	rose.y0,		dd		272			; 左上坐标:Y0
		at	rose.x1,		dd		424			; 右下坐标:X1
		at	rose.y1,		dd		448			; 右下坐标:Y1

		at	rose.n,			dd		4			; 变数:n
		at	rose.d,			dd		6			; 变数:d

		at	rose.color_x,	dd		0x0007		; 描画颜色:X轴
		at	rose.color_y,	dd		0x0007		; 描画颜色:Y轴
		at	rose.color_z,	dd		0x000F		; 描画色:轮廓
		at	rose.color_s,	dd		0x060F		; 描画色:文字
		at	rose.color_f,	dd		0x000F		; 描画色:graph描画色
		at	rose.color_b,	dd		0x0006		; 描画色:graph消去色

		at	rose.title,		db		"Task-6", 0	; title

	iend
;************************************************************************
;
;	Z = A * sin(nθ)
;	  = A * sin( (n/d) * ((θ/180) * t) )
;
;	x = A * sin(nθ) * cos(θ)
;	y = A * sin(nθ) * sin(θ)
;************************************************************************
fpu_rose_init:
		
												
		push	ebp								
		mov		ebp, esp						
												
		push	dword 180

		;---------------------------------------
		; FPU傪巊偭偨張棟
		;
		; A(怳暆), k(n/d),r(搙仺儔僨傿傾儞)傪
		; FPU撪偺儗僕僗僞偵僗僞僢僋偟偰偍偔
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
		; X/Y坐标计算
		;---------------------------------------
		mov		eax, [ebp +  8]					; EAX = pX; // X坐标
		mov		ebx, [ebp + 12]					; EBX = pY; // Y坐标

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
		;										;       θ |      θ |       A |       k |       r |         |
												; ---------+---------+---------|---------|---------|---------|
		fsincos									;   cos(θ)|  sin(θ)|      θ |       A |       k |       r |
		fxch	st2								;       θ |         |  cos(θ)|         |         |         |
		fmul	st0, st4						;      kθ |         |         |         |         |         |
		fsin									;  sin(kθ)|         |         |         |         |         |
		fmul	st0, st3						; Asin(kθ)|         |         |         |         |         |
												; ---------+---------+---------|---------|---------|---------|
												; Asin(kθ)|  sin(θ)|  cos(θ)|       A |       k |       r |
												; ---------+---------+---------|---------|---------|---------|
		;---------------------------------------
		; x =  A * sin(kθ) * cos(θ);
		;---------------------------------------
												; ---------+---------+---------|---------|---------|---------|
												;       ST0|      ST1|      ST2|      ST3|      ST4|      ST5|
												; ---------+---------+---------|---------|---------|---------|
												; Asin(kθ)|  sin(θ)|  cos(θ)|       A |       k |       r |
		fxch	st2								;   cos(θ)|         |Asin(kθ)|         |         |         |
		fmul	st0, st2						;        x |         |         |         |         |         |
		fistp	dword [eax]						;   sin(θ)|Asin(kθ)|       A |       k |       r |xxxxxxxxx|
												; ---------+---------+---------|---------|---------|---------|
		;---------------------------------------
		; y = -A * sin(kθ) * sin(θ);
		;---------------------------------------
												; ---------+---------+---------|---------|---------|---------|
												;       ST0|      ST1|      ST2|      ST3|      ST4|      ST5|
												; ---------+---------+---------|---------|---------|---------|
												;   sin(θ)|Asin(kθ)|       A |       k |       r |xxxxxxxxx|
		fmulp	st1, st0						;        y |       A |       k |       r |xxxxxxxxx|xxxxxxxxx|
		fchs									;       -y |         |         |         |xxxxxxxxx|xxxxxxxxx|
		fistp	dword [ebx]						;        A |       k |       r |xxxxxxxxx|xxxxxxxxx|xxxxxxxxx|
												; ---------+---------+---------|---------|---------|---------|
		pop		ebx
		pop		eax

		mov		esp, ebp
		pop		ebp

		ret

