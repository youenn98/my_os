;************************************************************************
;	TASK-1
;************************************************************************
task_1:
		;---------------------------------------
		; 打印字符串
		;---------------------------------------
		cdecl	draw_str, 63, 0, 0x07, .s0		; draw_str();

		;---------------------
		;打印时间
		;---------------------
		mov eax,[RTC_TIME]
		cdecl draw_time,72,0,0x0700,eax

		;--------------------
		;返回task0(kernel)
		;--------------------
		jmp   SS_TASK_0:0
		
		jmp	  .10L

		iret

.s0		db	"Task-1", 0

