;************************************************************************
;通过画旋转的条来显示TIMER_COUNT的值
;************************************************************************
draw_rotation_bar:
		push	eax

		;---------------------------------------
		; counter值增加16,rotation_bar转一次
		;---------------------------------------
		mov		eax, [TIMER_COUNT]				; EAX  = timer_count值
		shr		eax, 4							; EAX /= 16;    // 除16
		cmp		eax, [.index]					; if (EAX != 之前的值)
		je		.10E							; {
												;   
		mov		[.index], eax					;   之前的值 = EAX;
		and		eax, 0x03						;   EAX &= 0x03; // 0~3限定
												;   
		mov		al, [.table + eax]				;   AL = table[index];
		cdecl	draw_char, 0, 29, 0x000F, eax	;   draw_char(); // 表示文字
												;   
.10E:											; }

		pop		eax

		ret

ALIGN 4, db 0
.index:		dd 0								; 之前的值
.table:		db	"|/-\"							; 表示字符

