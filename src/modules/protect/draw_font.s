draw_font:
		push	ebp		
		mov		ebp, esp		
							

		push	eax
		push	ebx
		push	ecx
		push	edx
		push	esi
		push	edi

		mov		esi, [ebp + 8]					; ESI = X(ﾁﾐ)
		mov		edi, [ebp +12]					; EDI = Y(ﾐﾐ)

		;---------------------------------------
		; フォント一覧を表示
		;---------------------------------------
		mov		ecx, 0							; for (ECX = 0;
.10L:	cmp		ecx, 256						;      ECX < 256;
		jae		.10E							; 
												;      ECX++)
												; {
												;   // ﾒｻﾐﾐｱ�ﾊｾ16ｸ�ﾗﾖｷ�,ﾁﾐﾎｻﾖﾃ
		mov		eax, ecx						;   EAX  = ECX;
		and		eax, 0x0F						;   EAX &= 0x0F
		add		eax, esi						;   EAX += X;
												;   
												;   // ﾐﾐﾎｻﾖﾃ
		mov		ebx, ecx						;   EBX  = ECX;
		shr		ebx, 4							;   EBX /= 16
		add		ebx, edi						;   EBX += Y;

		cdecl	draw_char, eax, ebx, 0x07, ecx	;   draw_char();

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

