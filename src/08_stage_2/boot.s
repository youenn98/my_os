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
	;----------------
ipl:
	cli ;//禁止中断

	mov ax,0x0000
	mov ds , ax        ;//将段寄存器都先设置为0
	mov es , ax
	mov ss , ax
	mov sp , BOOT_LOAD   ;//将栈底设置为boot程序开始的地方

	sti ;//允许中断

	mov [BOOT.DRIVE], dl;//dl是保存启动程序的外部设备的序号
	;-------------------
	;读取接下来的512字节
	;-------------------
	
	mov ah,0x02  ;//读取命令
	mov al,1	;//读取的sector数
	mov cx, 0x0002 ;// clinder/sector
	mov dh, 0x00   ;// head
	mov dl, [BOOT.DRIVE] ;//驱动编号
	mov bx, 0x7C00 + 512 ;//offset
	int 0x13
.10Q: jnc .10E
.10T: cdecl puts, .e0 ;//发生错误
	call reboot      ;//重启

.10E:
	jmp stage_2    ;//启动程序第二位置

.s0 db "Booting...",0x0A,0x0D,0 ;//0x0A是下一行,0x0D是将kernel移到最左端,0代表字符串的终结
.e0 db "Error:sector read",0 ;//错误信息

ALIGN 2, db 0
BOOT:
.DRIVE: dw 0   ;//drive的序号

;**********************
;module
;***********************
%include "../modules/real/puts.s"
%include "../modules/real/reboot.s"

;******************
;boot_flag
;*******************
	times 510 -($-$$) db 0x00
	db 0x55,0xAA

;*********************
;boot处理的第二阶段
;*********************
stage_2:
	cdecl puts, .s0

	;-----------------
	;处理结束
	;---------------;

	jmp $
.s0 db "2nd stage...",0X0A,0x0D,0

;**********************
;padding
;**********************
	times (1024 * 8)-($-$$) db 0;    8KB