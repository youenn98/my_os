draw_rect:

		push	ebp								
		mov		ebp, esp						

		push		eax
		push		ebx
		push		ecx
		push		edx
		push		esi

		;---------------------------------------
		; 获取参数
		;---------------------------------------
		mov		eax, [ebp + 8]					; EAX = X0;
		mov		ebx, [ebp +12]					; EBX = Y0;
		mov		ecx, [ebp +16]					; ECX = X1;
		mov		edx, [ebp +20]					; EDX = Y1;
		mov		esi, [ebp +24]					; ESI = 颜色;

		;---------------------------------------
		; 确定坐标的大小
		;---------------------------------------
		cmp		eax, ecx						; if (X1 < X0)
		jl		.10E							; {
		xchg	eax, ecx						;   交换X0和X1
.10E:											; }

		cmp		ebx, edx						; if (Y1 < Y0)
		jl		.20E							; {
		xchg	ebx, edx						;   交换Y0和Y1
.20E:											; }

		;---------------------------------------
		; 画矩形
		;---------------------------------------
		cdecl	draw_line, eax, ebx, ecx, ebx, esi	; 上线
		cdecl	draw_line, eax, ebx, eax, edx, esi	; 左线

		dec		edx									; EDX--; // 下线往上挪一个点
		cdecl	draw_line, eax, edx, ecx, edx, esi	; 下线
		inc		edx

		dec		ecx									; ECX--; // 右线向左挪一个点
		cdecl	draw_line, ecx, ebx, ecx, edx, esi	; 右线


		pop		esi
		pop		edx
		pop		ecx
		pop		ebx
		pop		eax

		mov		esp, ebp
		pop		ebp

		ret

