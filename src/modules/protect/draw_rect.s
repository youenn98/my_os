draw_rect:

		push	ebp								
		mov		ebp, esp						

		push		eax
		push		ebx
		push		ecx
		push		edx
		push		esi

		;---------------------------------------
		; ��ȡ����
		;---------------------------------------
		mov		eax, [ebp + 8]					; EAX = X0;
		mov		ebx, [ebp +12]					; EBX = Y0;
		mov		ecx, [ebp +16]					; ECX = X1;
		mov		edx, [ebp +20]					; EDX = Y1;
		mov		esi, [ebp +24]					; ESI = ��ɫ;

		;---------------------------------------
		; ȷ������Ĵ�С
		;---------------------------------------
		cmp		eax, ecx						; if (X1 < X0)
		jl		.10E							; {
		xchg	eax, ecx						;   ����X0��X1
.10E:											; }

		cmp		ebx, edx						; if (Y1 < Y0)
		jl		.20E							; {
		xchg	ebx, edx						;   ����Y0��Y1
.20E:											; }

		;---------------------------------------
		; ������
		;---------------------------------------
		cdecl	draw_line, eax, ebx, ecx, ebx, esi	; ����
		cdecl	draw_line, eax, ebx, eax, edx, esi	; ����

		dec		edx									; EDX--; // ��������Ųһ����
		cdecl	draw_line, eax, edx, ecx, edx, esi	; ����
		inc		edx

		dec		ecx									; ECX--; // ��������Ųһ����
		cdecl	draw_line, ecx, ebx, ecx, edx, esi	; ����


		pop		esi
		pop		edx
		pop		ecx
		pop		ebx
		pop		eax

		mov		esp, ebp
		pop		ebp

		ret

