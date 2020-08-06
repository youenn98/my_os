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
		jmp		ipl								; 0x00( 3) 跳转到boot_code的命令
		times	3 - ($ - $$) db 0x90			; 
		db		'OEM-NAME'						; 0x03( 8) OEM名
												; -------- --------------------------------
		dw		512								; 0x0B( 2) sector的字节数
		db		1								; 0x0D( 1) cluster的sector数
		dw		32								; 0x0E( 2) 预留的sector数
		db		2								; 0x10( 1) FAT数
		dw		512								; 0x11( 2) root entry数
		dw		0xFFF0							; 0x13( 2) 总sector数16
		db		0xF8							; 0x15( 1) media type
		dw		256								; 0x16( 2) FAT的sector数
		dw		0x10							; 0x18( 2) track的sector数
		dw		2								; 0x1A( 2) head数
		dd		0								; 0x1C( 4) 被隐藏的sector数
												; -------- --------------------------------
		dd		0								; 0x20( 4) 总sector数32
		db		0x80							; 0x24( 1) drive号
		db		0								; 0x25( 1) (预留)
		db		0x29							; 0x26( 1) boot flag
		dd		0xbeef							; 0x27( 4) serial number
		db		'BOOTABLE   '					; 0x2B(11) volumn label
		db		'FAT16   '						; 0x36( 8) FAT type

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
ACPI_DATA:
.adr dd 0		;ACPI data address
.len dd 0		;ACPI data length

;********************
;modules
;********************
%include "..\modules\real\itoa.s"
%include "..\modules\real\get_drive_param.s"
%include "..\modules\real\get_font_adr.s"
%include "..\modules\real\get_mem_info.s"
%include "..\modules\real\kbc.s"
%include "..\modules\real\read_lba.s"

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

	;--------------------
	;表示memory address
	;--------------------
	cdecl get_mem_info,ACPI_DATA
	cdecl puts ,.s0

	mov eax,[ACPI_DATA.adr]		;//EAX = ACPI_DATA.adr		
	cmp eax,0					;//if(eax)
	je .10E
	
	cdecl itoa,ax,.p4,4,16,0b0100	;//低位地址转换
	shr eax,16
	cdecl itoa,ax,.p3,4,16,0b0100	;//	高位地址转换

	cdecl puts ,.s2		;//打印地址

.10E:
	jmp stage_4


.s0 db "3rd stage...",0x0A,0X0D,0
.s1 db "Font Address="
.p1 db "ZZZZ"
.p2 db "ZZZZ",0x0A,0x0D,0
	db 0x0A,0X0D,0

.s2 db "ACPI_DATA="
.p3 db "ZZZZ"
.p4 db "ZZZZ",0x0A,0x0D,0

;********************
;第四阶段
;********************

stage_4:
	
	cdecl puts,.s0

	;-----------------
	;A20 gate的有效化
	;-----------------

	cli					;//中断进制
	cdecl KBC_Cmd_Write,0xAD ;//键盘无效化

	cdecl KBC_Cmd_Write,0xD0	;//读取输出端口的命令
	cdecl KBC_Data_Read,.key	;//输出端口的数据读入key

	mov bl,[.key]	;BL = key
	or bl,0x02		;BL |= 0x02 A20 gate的有效化

	cdecl KBC_Cmd_Write,0xD1	;//写入输出端口的命令
	cdecl KBC_Data_Write,bx     ;//输出端口数据

	cdecl KBC_Cmd_Write,0xAE ;//键盘有效化
	sti						;//允许中断

	cdecl puts,.s1

	;-----------------
	;键盘led测试
	;-----------------
	cdecl puts,.s2

	mov bx,0          ;//bx = led的初始值 0
.10L:
	
	mov ah,0x00		;//等待键盘输入
	int 0x16

	cmp al,'1' ;if(AL<'1') break
	jb .10E

	cmp al,'3';if(AL>'3') break
	ja .10E

	mov cl,al		;cl = 键盘输入
	dec cl
	and cl,0x03     ;cl = 0~2
	mov ax,0x0001  
	shl ax,cl		;把每个输入设置为一个位
	xor bx,ax    ;bx = bx^ax  ;//设置led值

	;----------------
	;LED命令传输
	;----------------
	cli

	cdecl KBC_Cmd_Write, 0xAD ;//无效化键盘

	cdecl KBC_Data_Write,0XED ;//LED设置
	cdecl KBC_Data_Read,.key  ;//等待键盘回复
	
	cmp [.key],byte 0xFA  ;//ACK
	jne .11F

	cdecl KBC_Data_Write,bx ;//LED 数据输出
	jmp .11E

.11F:
	cdecl itoa,word[.key],.e1,2,16,0b100
	cdecl puts,.e0
.11E:
	
	cdecl KBC_Cmd_Write,0xAE ;//键盘有效化
	sti
	jmp .10L
.10E:
	cdecl puts,.s3

	jmp stage_5

.s0 db "4rd stage...",0x0A,0X0D,0
.s1 db "A20 Gate Enabled.",0x0A,0x0D,0
.s2 db "KeyBoard LED Test...",0
.s3 db "(done)",0x0A,0x0D,0
.e0 db "["
.e1 db "ZZ]",0

.key dw 0

stage_5:
	cdecl puts,.s0

	;------------
	;读入kernel
	;------------

	cdecl read_lba,BOOT,BOOT_SECT,KERNEL_SECT,BOOT_END

	cmp ax,KERNEL_SECT ;//if(没有读取完) 则reboot 
.10Q: jz	.10E
.10T: cdecl puts,.e0
	call reboot	
.10E:

	jmp		stage_6

.s0		db	"5th stage...", 0x0A, 0x0D, 0
.e0		db	" Failure load kernel...", 0x0A, 0x0D, 0

stage_6:
	
	cdecl puts,.s0
.10L:				;//等待键盘输入
	mov ah,0x00
	int 0x16
	cmp al,' '
	jne .10L

	;-----------------------
	;video mode设定
	;-----------------------
	mov ax,0x0012
	int 0x10

	jmp stage_7

.s0 db "6th stage...",0x0A,0X0D,0X0A,0x0D
	db "[Push SPACE key to protect mode...]",0x0A,0x0D,0

;************************************************
;global descriptor table
;segment descriptor 数组
;************************************************

ALIGN 4,db 0
GDT:			dq	0x00_0_0_0_0_000000_0000	;// NULL table
.cs:			dq	0x00_C_F_9_A_000000_FFFF	;//CODE_table 4G
.ds:			dq	0x00_C_F_9_2_000000_FFFF	;//DATA_table 4G
.gdt_end:

;-----------------------
;selector
;-----------------------
SEL_CODE equ .cs - GDT    ;//Code selector
SEL_DATA equ .ds - GDT    ;//Data selector

;------------------
;GDT
;------------------
GDTR: dw GDT.gdt_end - GDT - 1		;//descriptor table 的限制
	dd GDT							;//descriptor table 的地址

;----------------------------------
;IDT(为了禁止中断)
;----------------------------------
IDTR: dw 0			;IDT limit
	dd 0			;IDT address

;***********************************
;stage7
;***********************************
stage_7:
	cli
	
	;---------------
	;load GDT
	;---------------
	lgdt [GDTR]				;// load global descriptor table
	lidt [IDTR]				;//load interepter descriptor table
	
	;----------------
	;进入保护模式
	;----------------
	mov eax,cr0 ;//设置PE位
	or ax,1		;// CR0 |=1;
	mov cr0,eax	;


	jmp $ + 2
	
	;--------------------
	;segment之间跳转
	;--------------------
[BITS 32]
	DB 0x66     ;//操作数大小overide前缀
	jmp SEL_CODE:CODE_32

;--------------------------------
;32bit代码段的开始
;--------------------------------

CODE_32:

	;---------------------
	;selector 初始化
	;---------------------

	mov ax,SEL_DATA
	mov ds,ax
	mov es,ax
	mov fs,ax
	mov gs,ax
	mov ss,ax

	;------------------
	;复制kernel部分
	;------------------
	mov ecx,(KERNEL_SIZE)/4  ;4byte作为一个单位复制
	mov esi,BOOT_END		 ;ESI = 0x0000_9C90 ;//kernel部分
	mov edi,KERNEL_LOAD      ;EDI = 0x0010_1000;//高位内存
	cld						 ;//正方向
	rep movsd				 ;while(--ecx)*EDI++ = *ESI++

	;---------------------
	;跳转到kernel处理
	;--------------------
	jmp KERNEL_LOAD		

;**********************
;padding
;**********************
	times BOOT_SIZE-($-$$) db 0 ;//8KB