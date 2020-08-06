;************************************************************************

;************************************************************************
wait_tick:
		
		push	ebp								
		mov		ebp, esp						
											

		push	eax
		push	ecx

		;---------------------------------------
		; wait
		;---------------------------------------
		mov		ecx, [ebp +  8]					; ECX = wait次数
		mov		eax, [TIMER_COUNT]				; EAX = TIMER;
												; do
												; {
.10L:	cmp		[TIMER_COUNT], eax				;   while (TIMER != EAX) TIMER的值在其他程序被更改
		je		.10L							;     ;
		inc		eax								;   EAX++;
		loop	.10L							; } while (--ECX);

		pop		ecx
		pop		eax


		mov		esp, ebp
		pop		ebp

		ret

