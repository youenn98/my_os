;************************************************************************
;ͨ������ת��������ʾTIMER_COUNT��ֵ
;************************************************************************
draw_rotation_bar:
		push	eax

		;---------------------------------------
		; counterֵ����16,rotation_barתһ��
		;---------------------------------------
		mov		eax, [TIMER_COUNT]				; EAX  = timer_countֵ
		shr		eax, 4							; EAX /= 16;    // ��16
		cmp		eax, [.index]					; if (EAX != ֮ǰ��ֵ)
		je		.10E							; {
												;   
		mov		[.index], eax					;   ֮ǰ��ֵ = EAX;
		and		eax, 0x03						;   EAX &= 0x03; // 0~3�޶�
												;   
		mov		al, [.table + eax]				;   AL = table[index];
		cdecl	draw_char, 0, 29, 0x000F, eax	;   draw_char(); // ��ʾ����
												;   
.10E:											; }

		pop		eax

		ret

ALIGN 4, db 0
.index:		dd 0								; ֮ǰ��ֵ
.table:		db	"|/-\"							; ��ʾ�ַ�

