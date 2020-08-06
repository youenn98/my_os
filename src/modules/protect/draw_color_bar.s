draw_color_bar:
		push	ebp						
		mov		ebp, esp						

		push	eax
		push	ebx
		push	ecx
		push	edx
		push	esi
		push	edi

		mov		esi, [ebp + 8]					; ESI = X乮楍乯
		mov		edi, [ebp +12]					; EDI = Y乮峴乯

		;---------------------------------------
		; 表示colorbar
		;---------------------------------------
		mov		ecx, 0							; for (ECX = 0;
.10L:	cmp		ecx, 16							;      ECX < 16;
		jae		.10E							; 
												;      ECX++)
												; {
												;   // 偶数列在左边,奇数列在右边
		mov		eax, ecx						;   EAX  = ECX;
		and		eax, 0x01						;   EAX &= 0x01;;//奇数
		shl		eax, 3							;   EAX *= 8;  // 往右移动8个字符
		add		eax, esi						;   EAX += X;
												;   
												;   // 每两个颜色10E行
		mov		ebx, ecx						;   EBX  = ECX;
		shr		ebx, 1							;   EBX /= 2
		add		ebx, edi						;   EBX += Y;
												;   
												;   //输出的颜色
		mov		edx, ecx						;   EDX  = ECX;
		shl		edx, 1							;   EDX *= 2;
		mov		edx, [.t0 + edx]				;   EDX += Y;

		cdecl	draw_str, eax, ebx, edx, .s0	;   draw_str();

		inc		ecx								;   // for (... ECX++)
		jmp		.10L							; 
.10E:											; }

		pop		edi
		pop		esi
		pop		edx
		pop		ecx
		pop		ebx
		pop		eax

		mov		esp, ebp
		pop		ebp

		ret

.s0:	db '        ', 0						;8个空白字符

.t0:	dw	0x0000, 0x0800						; colorbar的背景色
		dw	0x0100, 0x0900
		dw	0x0200, 0x0A00
		dw	0x0300, 0x0B00
		dw	0x0400, 0x0C00
		dw	0x0500, 0x0D00
		dw	0x0600, 0x0E00
		dw	0x0700, 0x0F00

