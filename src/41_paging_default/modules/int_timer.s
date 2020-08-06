;************************************************************************
;timer���жϳ���
;************************************************************************
int_timer:
		pusha
		push	ds
		push	es

		;---------------------------------------
		; ����ds��es
		;---------------------------------------
		mov		ax, 0x0010						; 
		mov		ds, ax							; 
		mov		es, ax							; 

		;---------------------------------------
		; TICK
		;---------------------------------------
		inc		dword [TIMER_COUNT]				; TIMER_COUNT++; // �жϻ�������

		;---------------------------------------
		; �жϱ�־λ��0(EOI)
		;---------------------------------------
		outp	0x20, 0x20						; // ��PIC:EOI����

		;----------------------
		;�л�����
		;----------------------
		str  ax				;AX = TR(���ڵ�����Ĵ���)
		cmp  ax,SS_TASK_0			;case(AX)
		je .11L
		cmp  ax,SS_TASK_1
		je .12L
		cmp  ax,SS_TASK_2
		je .13L

		jmp SS_TASK_0:0			;//�л�task1
		jmp .10E
	.11L:					;//case SS_TASK_1:
		jmp SS_TASK_1:0			;//�л���task0
		jmp  .10E				;break;
	.12L:
		jmp SS_TASK_2:0
		jmp .10E
	.13L:
		jmp SS_TASK_3:0
		jmp .10E 
	.10E:
		pop		es								; 
		pop		ds								; 
		popa

		iret

ALIGN 4, db 0
TIMER_COUNT:	dd	0
