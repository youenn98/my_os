BOOT_LOAD equ 0x7C00        ;启动程序的加载位置

ORG BOOT_LOAD               ;向编译器指示加载地址

;**************************
; 宏设定
;*************************
%include "../include/macro.s"


entry:
	jmp ipl
	;------------------
	;BPB(BIOS Parameter Block)
	;------------------
	times 90 -($-$$) db 0x90

	;----------------------------
	;IPL(Initial Pragram Loader)
ipl:
	cli ;//禁止中断

	mov ax,0x0000
	mov ds , ax        ;//将段寄存器都先设置为0
	mov es , ax
	mov ss , ax
	mov sp , BOOT_LOAD   ;//将栈底设置为boot程序开始的地方

	sti ;//允许中断

	mov [BOOT.DRIVE], dl;//dl是保存启动程序的外部设备的序号

	cdecl putc, word 'X'
	cdecl putc, word 'Y'
	cdecl putc, word 'Z'


	jmp $
ALIGN 2, db 0
BOOT:
.DRIVE: dw 0   ;//drive的序号

;**********************
;module
;***********************
%include "../modules/real/putc.s"

;******************
;boot_flag
;*******************
	times 510 -($-$$) db 0x00
	db 0x55,0xAA
