;************************************************************************
;timer的中断程序
;************************************************************************
int_timer:
		pusha
		push	ds
		push	es

		;---------------------------------------
		; 设置ds和es
		;---------------------------------------
		mov		ax, 0x0010						; 
		mov		ds, ax							; 
		mov		es, ax							; 

		;---------------------------------------
		; TICK
		;---------------------------------------
		inc		dword [TIMER_COUNT]				; TIMER_COUNT++; // 中断回数更新

		;---------------------------------------
		; 中断标志位清0(EOI)
		;---------------------------------------
		outp	0x20, 0x20						; // 主PIC:EOI命令

		;----------------------
		;切换任务
		;----------------------
		str  ax				;AX = TR(现在的任务寄存器)
		cmp  ax,SS_TASK_0			;case(AX)
		je .11L
		cmp  ax,SS_TASK_1
		je .12L
		cmp  ax,SS_TASK_2
		je .13L
		cmp	ax, SS_TASK_3					;   
		je	.14L							;   
		cmp	ax, SS_TASK_4					;   
		je	.15L							;   
		cmp	ax, SS_TASK_5					;   
		je	.16L							; 



		jmp		SS_TASK_0:0			;//切换task1
		jmp		.10E
	.11L:					;//case SS_TASK_1:
		jmp		SS_TASK_1:0			;//切换成task0
		jmp		.10E				;break;
	.12L:
		jmp		SS_TASK_2:0
		jmp		.10E
	.13L:
		jmp		SS_TASK_3:0
		jmp		.10E 
	.14L:											;   case SS_TASK_3:
		jmp		SS_TASK_4:0						;     // 切换task4
		jmp		.10E							;     break											;     
	.15L:											;   case SS_TASK_4:
		jmp		SS_TASK_5:0						;     // 切换task5
		jmp		.10E							;     break;												;     
	.16L:											;   case SS_TASK_5:
		jmp		SS_TASK_6:0						;     // 切换task6
		jmp		.10E							;     break;
	.10E:
		pop		es								; 
		pop		ds								; 
		popa

		iret

ALIGN 4, db 0
TIMER_COUNT:	dd	0

