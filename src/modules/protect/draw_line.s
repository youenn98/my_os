draw_line:


		push	ebp								
		mov		ebp, esp					
												; ---------------
		push	dword 0							;    - 4| sum   = 0; // 相对轴的积算值
		push	dword 0							;    - 8| x0    = 0; // X坐标
		push	dword 0							;    -12| dx    = 0; // X增加份
		push	dword 0							;    -16| inc_x = 0; // X坐标增加份(1 or -1)
		push	dword 0							;    -20| y0    = 0; // Y坐标
		push	dword 0							;    -24| dy    = 0; // Y增加份
		push	dword 0							;    -28| inc_y = 0; // Y坐标增加份(1 or -1)
												; ------|--------
		push	eax
		push	ebx
		push	ecx
		push	edx
		push	esi
		push	edi

		;---------------------------------------
		; 计算宽(X轴)
		;---------------------------------------
		mov		eax, [ebp + 8]					; EAX = X0;
		mov		ebx, [ebp +16]					; EBX = X1;
		sub		ebx, eax						; EBX = X1 - X0; //宽
		jge		.10F							; if (宽 < 0)
												; {
		neg		ebx								;   宽   *= -1;
		mov		esi, -1							;   // X坐标的增加份
		jmp		.10E							; }
.10F:											; else
												; {
		mov		esi, 1							;   // X坐标的增加份
.10E:											; }

		;---------------------------------------
		; 计算高(Y轴)
		;---------------------------------------
		mov		ecx, [ebp +12]					; ECX = Y0
		mov		edx, [ebp +20]					; EDX = Y1
		sub		edx, ecx						; EDX = Y1 - Y0; // 高
		jge		.20F							; if (高 < 0)
												; {
		neg		edx								;   高 *= -1;
		mov		edi, -1							;   // Y坐标的增加份
		jmp		.20E							; }
.20F:											; else
												; {
		mov		edi, 1							;   // Y坐标的增加份
.20E:											; }

		;---------------------------------------
		; X轴
		;---------------------------------------
		mov		[ebp - 8], eax					;   // X轴:开始坐标
		mov		[ebp -12], ebx					;   // X轴:宽
		mov		[ebp -16], esi					;   // X轴:增加份(基准轴1 or -1)

		;---------------------------------------
		; Y轴
		;---------------------------------------
		mov		[ebp -20], ecx					;   // Y轴:开始坐标
		mov		[ebp -24], edx					;   // Y轴:长
		mov		[ebp -28], edi					;   // Y轴:增加份(基准轴 1 or -1)

		;---------------------------------------
		; 决定哪个是基准轴
		;---------------------------------------
		cmp		ebx, edx						; if (宽 <= 高)
		jg		.22F							; {
												;   
		lea		esi, [ebp -20]					;   // Y轴是基准轴
		lea		edi, [ebp - 8]					;   // X轴是相对轴
												;   
		jmp		.22E							; }
.22F:											; else
												; {
		lea		esi, [ebp - 8]					;   // X轴是基准轴
		lea		edi, [ebp -20]					;   // Y轴是相对轴
.22E:											; }

		;---------------------------------------
		; 循环执行次数(基准轴的点数)
		;---------------------------------------
		mov		ecx, [esi - 4]					; ECX = 基准轴画面宽度;
		cmp		ecx, 0							; if (0 == ECX)
		jnz		.30E							; {
		mov		ecx, 1							;   ECX = 1;
.30E:											; }

		;---------------------------------------
		; 划线
		;---------------------------------------
.50L:	
%ifdef  USE_SYSTEM_CALL
        mov eax, ecx

        mov ebx, [ebp + 24]
        mov ecx, [ebp - 8]
        mov edx, [ebp - 20]
        int 0x82

        mov ecx, eax
%else												; do
												; {
		cdecl	draw_pixel, dword [ebp - 8],dword [ebp -20],dword [ebp +24]		; //画点
%endif
												;   // 基准轴更新(1个点)
		mov		eax, [esi - 8]					;   EAX = 基准轴增加份(1 or -1);
		add		[esi - 0], eax					;   

												;   // 相对轴更新
		mov		eax, [ebp - 4]					;   EAX  = sum; // 相对轴的积算值;
		add		eax, [edi - 4]					;   EAX += dy;  // 增加的分(相对轴的积算值)
		mov		ebx, [esi - 4]					;   EBX  = dx;  // 增加的分(基准轴的画幅)

		cmp		eax, ebx						;   if (积算值 <= 相对轴的增加份)
		jl		.52E							;   {
		sub		eax, ebx						;     EAX -= EBX; // 积算值减去相对轴的增加份
												;     
												;     // 相对值坐标更新(1个点)
		mov		ebx, [edi - 8]					;     EBX =  相对轴增加的分;
		add		[edi - 0], ebx					;		
.52E:											;   }
		mov		[ebp - 4], eax					;   // 积算值更新
												;   
		loop	.50L							;   
.50E:											; } while (迭代次数--);


		pop		edi
		pop		esi
		pop		edx
		pop		ecx
		pop		ebx
		pop		eax

		mov		esp, ebp
		pop		ebp

		ret

