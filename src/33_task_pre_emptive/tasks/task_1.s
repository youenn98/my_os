;************************************************************************
;	TASK-1
;************************************************************************
task_1:
		;---------------------------------------
		; ��ӡ�ַ���
		;---------------------------------------
		cdecl	draw_str, 63, 0, 0x07, .s0		; draw_str();
.10L:											; while (;;)
												; {
		;---------------------------------------
		; ��ӡʱ��
		;---------------------------------------
		mov		eax, [RTC_TIME]					; 
		cdecl	draw_time, 72, 0, 0x0700, eax	; 

		jmp		.10L	

		iret

.s0		db	"Task-1", 0

