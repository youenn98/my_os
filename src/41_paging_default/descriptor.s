;************************************************************************
;	TSS
;************************************************************************
TSS_0:
.link:			dd	0							;   0:֮ǰ�����link
.esp0:			dd	SP_TASK_0 - 512				;*  4:ESP0
.ss0:			dd	DS_KERNEL					;*  8:
.esp1:			dd	0							;* 12:ESP1
.ss1:			dd	0							;* 16:
.esp2:			dd	0							;* 20:ESP2
.ss2:			dd	0							;* 24:
.cr3:			dd	CR3_BASE					;  28:CR3(PDBR)
.eip:			dd	0							;  32:EIP
.eflags:		dd	0							;  36:EFLAGS
.eax:			dd	0							;  40:EAX
.ecx:			dd	0							;  44:ECX
.edx:			dd	0							;  48:EDX
.ebx:			dd	0							;  52:EBX
.esp:			dd	0							;  56:ESP
.ebp:			dd	0							;  60:EBP
.esi:			dd	0							;  64:ESI
.edi:			dd	0							;  68:EDI
.es:			dd	0							;  72:ES
.cs:			dd	0							;  76:CS
.ss:			dd	0							;  80:SS
.ds:			dd	0							;  84:DS
.fs:			dd	0							;  88:FS
.gs:			dd	0							;  92:GS
.ldt:			dd	0							;* 96:LDT segment selector
.io:			dd	0							; 100:I/O map base address 
.fp_save:		times 108 + 4 db 0				;FPUǰ���ı�������

TSS_1:
.link:			dd	0							;   0:֮ǰ�����link
.esp0:			dd	SP_TASK_1 - 512				;*  4:ESP0
.ss0:			dd	DS_KERNEL					;*  8:
.esp1:			dd	0							;* 12:ESP1
.ss1:			dd	0							;* 16:
.esp2:			dd	0							;* 20:ESP2
.ss2:			dd	0							;* 24:
.cr3:			dd	CR3_BASE					;  28:CR3(PDBR)
.eip:			dd	task_1						;  32:EIP
.eflags:		dd	0x0202						;  36:EFLAGS
.eax:			dd	0							;  40:EAX
.ecx:			dd	0							;  44:ECX
.edx:			dd	0							;  48:EDX
.ebx:			dd	0							;  52:EBX
.esp:			dd	SP_TASK_1					;  56:ESP
.ebp:			dd	0							;  60:EBP
.esi:			dd	0							;  64:ESI
.edi:			dd	0							;  68:EDI
.es:			dd	DS_TASK_1					;  72:ES
.cs:			dd	CS_TASK_1					;  76:CS
.ss:			dd	DS_TASK_1					;  80:SS
.ds:			dd	DS_TASK_1					;  84:DS
.fs:			dd	DS_TASK_1					;  88:FS
.gs:			dd	DS_TASK_1					;  92:GS
.ldt:			dd	SS_LDT						;* 96:LDT segment selector
.io:			dd	0							; 100:I/O map base address 
.fp_save:		times 108 + 4 db 0				;FPUǰ���ı�������

TSS_2:
.link:			dd	0							;   0:֮ǰ��task��link
.esp0:			dd	SP_TASK_2 - 512				;*  4:ESP0
.ss0:			dd	DS_KERNEL					;*  8:
.esp1:			dd	0							;* 12:ESP1
.ss1:			dd	0							;* 16:
.esp2:			dd	0							;* 20:ESP2
.ss2:			dd	0							;* 24:
.cr3:			dd	CR3_BASE					;  28:CR3(PDBR)
.eip:			dd	task_2						;  32:EIP
.eflags:		dd	0x0202						;  36:EFLAGS
.eax:			dd	0							;  40:EAX
.ecx:			dd	0							;  44:ECX
.edx:			dd	0							;  48:EDX
.ebx:			dd	0							;  52:EBX
.esp:			dd	SP_TASK_2					;  56:ESP
.ebp:			dd	0							;  60:EBP
.esi:			dd	0							;  64:ESI
.edi:			dd	0							;  68:EDI
.es:			dd	DS_TASK_2					;  72:ES
.cs:			dd	CS_TASK_2					;  76:CS
.ss:			dd	DS_TASK_2					;  80:SS
.ds:			dd	DS_TASK_2					;  84:DS
.fs:			dd	DS_TASK_2					;  88:FS
.gs:			dd	DS_TASK_2					;  92:GS
.ldt:			dd	SS_LDT						;* 96:LDT segment selector
.io:			dd	0							; 100:I/O map base address
.fp_save:	times 108 + 4 db 0					; FPUǰ���ı�������

TSS_3:
.link:			dd	0							;   0:֮ǰ��task��link
.esp0:			dd	SP_TASK_3 - 512				;*  4:ESP0
.ss0:			dd	DS_KERNEL					;*  8:
.esp1:			dd	0							;* 12:ESP1
.ss1:			dd	0							;* 16:
.esp2:			dd	0							;* 20:ESP2
.ss2:			dd	0							;* 24:
.cr3:			dd	CR3_BASE					;  28:CR3(PDBR)
.eip:			dd	task_3						;  32:EIP
.eflags:		dd	0x0202						;  36:EFLAGS
.eax:			dd	0							;  40:EAX
.ecx:			dd	0							;  44:ECX
.edx:			dd	0							;  48:EDX
.ebx:			dd	0							;  52:EBX
.esp:			dd	SP_TASK_3					;  56:ESP
.ebp:			dd	0							;  60:EBP
.esi:			dd	0							;  64:ESI
.edi:			dd	0							;  68:EDI
.es:			dd	DS_TASK_3					;  72:ES
.cs:			dd	CS_TASK_3					;  76:CS
.ss:			dd	DS_TASK_3					;  80:SS
.ds:			dd	DS_TASK_3					;  84:DS
.fs:			dd	DS_TASK_3					;  88:FS
.gs:			dd	DS_TASK_3					;  92:GS
.ldt:			dd	SS_LDT						;* 96:LDT segment selector
.io:			dd	0							; 100:I/O map base address
.fp_save:	times 108 + 4 db 0					; FPUǰ���ı�������

;************************************************************************
;	global descriptor table
;************************************************************************
GDT:			dq	0x0000000000000000			; NULL
.cs_kernel:		dq	0x00CF9A000000FFFF			; CODE 4G
.ds_kernel:		dq	0x00CF92000000FFFF			; DATA 4G
.ldt			dq	0x0000820000000000			; LDT	descriptor
.tss_0:			dq	0x0000890000000067			; TSS descriptor
.tss_1:			dq	0x0000890000000067			; TSS descriptor
.tss_2:			dq	0x0000890000000067			; TSS descriptor
.tss_3:			dq	0x0000890000000067			; TSS descriptor
.call_gate:		dq	0x0000EC0400080000			; 386 call_gate(DPL=3, count=4, SEL=8)
.end:

CS_KERNEL		equ	.cs_kernel	- GDT
DS_KERNEL		equ	.ds_kernel	- GDT
SS_LDT			equ	.ldt		- GDT
SS_TASK_0		equ	.tss_0		- GDT
SS_TASK_1		equ	.tss_1		- GDT
SS_TASK_2		equ	.tss_2		- GDT
SS_TASK_3		equ	.tss_3		- GDT
SS_GATE_0		equ .call_gate  - GDT

GDTR:	dw 		GDT.end - GDT - 1
		dd 		GDT


;************************************************************************
;local descriptor table
;************************************************************************
LDT:			dq	0x0000000000000000			; NULL
.cs_task_0:		dq	0x00CF9A000000FFFF			; CODE 4G
.ds_task_0:		dq	0x00CF92000000FFFF			; DATA 4G
.cs_task_1:		dq	0x00CFFA000000FFFF			; CODE 4G
.ds_task_1:		dq	0x00CFF2000000FFFF			; DATA 4G
.cs_task_2:		dq	0x00CFFA000000FFFF			; CODE 4G
.ds_task_2:		dq	0x00CFF2000000FFFF			; DATA 4G
.cs_task_3:		dq	0x00CFFA000000FFFF			; CODE 4G
.ds_task_3:		dq	0x00CFF2000000FFFF			; DATA 4G
.end:

CS_TASK_0		equ	(.cs_task_0 - LDT) | 4		; task0��CS �μĴ��� 
DS_TASK_0		equ	(.ds_task_0 - LDT) | 4		; task0��DS	�μĴ���
CS_TASK_1		equ	(.cs_task_1 - LDT) | 4 | 3	; task1��CS�μĴ���
DS_TASK_1		equ	(.ds_task_1 - LDT) | 4 | 3	; task1��DS�μĴ���
CS_TASK_2		equ	(.cs_task_2 - LDT) | 4 | 3	; task2��CS�μĴ���
DS_TASK_2		equ	(.ds_task_2 - LDT) | 4 | 3	; task2��DS�μĴ���
CS_TASK_3		equ	(.cs_task_3 - LDT) | 4 | 3	; task3��CS�μĴ���
DS_TASK_3		equ	(.ds_task_3 - LDT) | 4 | 3	; task3��DS�μĴ���

LDT_LIMIT		equ	.end		- LDT - 1

