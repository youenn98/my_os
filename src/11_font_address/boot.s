;**************************
; 宏设定
;*************************
%include "../include/macro.s"
%include "../include/define.s"

ORG BOOT_LOAD               ;向编译器指示加载地址

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

	mov [BOOT + drive.no], dl;//dl是保存启动程序的外部设备的序号

	cdecl puts,.s0

	;-------------------
	;读取接下来所有的sector
	;-------------------
	
	mov bx,BOOT_SECT-1
	mov cx,BOOT_LOAD + SECT_SIZE

	cdecl read_chs,BOOT,bx,cx   ;AX = read_chs(.chs,bx,cx)

	cmp ax,bx    ;//if(AX != 剩下的sector数)
.10Q: jz .10E
.10T: cdecl puts, .e0 ;//发生错误
	call reboot      ;//重启

.10E:
	jmp stage_2    ;//启动程序第二位置

.s0 db "Booting...",0x0A,0x0D,0 ;//0x0A是下一行,0x0D是将kernel移到最左端,0代表字符串的终结
.e0 db "Error:sector read",0 ;//错误信息

;*******************
;启动驱动信息
;*******************
ALIGN 2, db 0
BOOT:
	istruc drive
		at drive.no, dw 0
		at drive.cyln, dw 0
		at drive.head, dw 0
		at drive.sect, dw 2
	iend

;**********************
;module
;***********************
%include "../modules/real/puts.s"
%include "../modules/real/reboot.s"
%include "../modules/real/read_chs.s"
;******************
;boot_flag
;*******************
	times 510 -($-$$) db 0x00
	db 0x55,0xAA

;*********************
;boot处理的第二阶段
;*********************

FONT:
.seg dw 0
.off dw 0


;********************
;modules
;********************
%include "..\modules\real\itoa.s"
%include "..\modules\real\get_drive_param.s"
%include "..\modules\real\get_font_adr.s"

stage_2:
	cdecl puts, .s0

	;-----------------
	;取得drive的信息
	;---------------;

	cdecl get_drive_param,BOOT ;(get_drive_param(DX,BOOT.CYLN))
	cmp ax,0
.10Q: jne .10E
.10T: cdecl puts,.e0
	call reboot
.10E:
	mov ax,[BOOT + drive.no]
	cdecl itoa,ax,.p1,2,16,0b0100
	mov ax,[BOOT + drive.cyln]
	cdecl itoa,ax,.p2,2,16,0b0100
	mov ax,[BOOT + drive.head]
	cdecl itoa,ax,.p3,2,16,0b0100
	mov ax,[BOOT + drive.sect]
	cdecl itoa,ax,.p4,2,16,0b0100

	cdecl puts, .s1

	jmp stage_3rd

.s0 db "2nd stage...",0X0A,0x0D,0

.s1 db " Drive:0x"
.p1 db " , C:0x" 
.p2 db " , H:0x" 
.p3 db " , S:0x" 
.p4 db " ", 0X0A,0X0D,0 
.e0 db "Can' t get drive parameter.", 0

;**************************
;stage3
;**************************

stage_3rd:
	cdecl puts,.s0
	
	cdecl get_font_adr,FONT

	;------------
	;//表示font address
	;------------

	cdecl itoa, word[FONT.seg],.p1,4,16,0b0100
	cdecl itoa, word[FONT.off],.p2,4,16,0b0100
	cdecl puts ,.s1

	jmp $

.s0 db "3rd stage...",0x0A,0X0D,0
.s1 db "Font Address="
.p1 db "ZZZZ"
.p2 db "ZZZZ",0x0A,0x0D,0
	db 0x0A,0X0D,0

;**********************
;padding
;**********************
	times BOOT_SIZE-($-$$) db 0 ;//8KB
