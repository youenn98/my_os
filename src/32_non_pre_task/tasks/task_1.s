;************************************************************************
;	TASK-1
;************************************************************************
task_1:
		;---------------------------------------
		; ��ӡ�ַ���
		;---------------------------------------
		cdecl	draw_str, 63, 0, 0x07, .s0		; draw_str();


		iret

.s0		db	"Task-1", 0

