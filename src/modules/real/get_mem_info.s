get_mem_info:
	push eax
	push ebx
	push ecx
	push edx
	push si
	push di
	push bp

	cdecl puts,.s0

	mov bp,0			;//lines = 0
	mov ebx,0			;//index = 0

.10L:
	;//cdecl puts,.s0
	mov eax,0x0000E820
	mov ecx,E820_RECORD_SIZE ;//ECX = 需要的byte数
	mov edx, 'PAMS' ;//EDX = 'SMAP'
	mov di,.b0      ;//ES:DI = buffer
	int 0x15

	cmp eax,'PAMS'
	je     .12E
	jmp    .10E	;//如果不支持SMAP则退出

.12E:

	jnc .14E	;//如果出问题了CF会被set
	jmp .10E	

.14E:
	
	cdecl put_mem_info, di	;//打印信息

	mov eax,[di + 16]		;//eax = record type 
	cmp eax,3				;//if(3 == eax) ACPI data
	jne .15E

	mov eax,[di + 0]		; EAX = BASE ADDRESS
	mov [ACPI_DATA.adr],eax ; ACPI_DATA.adr = EAX

	mov eax,[di + 8]		;EAX = length
	mov [ACPI_DATA.len],eax ; ACPI_DATA.len = EAX
.15E:
	cmp ebx,0			;//if(ebx != 0)
	jz .16E

	inc bp
	and bp,0x07			;//line每8个命令需要用户按下回车继续
	jnz .16E			;//if(lines == 0)	inc bp				;//lines++


	cdecl puts,.s2		;//中断命令

	mov ah,0x10			;//等待keyboard输入
	int 0x16

	cdecl puts,.s3		;//删除中断信息

.16E:
	cmp ebx,0
	jne .10L
.10E:
	pop bp
	pop di
	pop si
	pop edx
	pop ecx
	pop ebx
	pop eax
	ret;

.s0:	db " E820 Memory Map:", 0x0A, 0x0D
		db " Base_____________ Length___________ Type____", 0x0A, 0x0D, 0
.s1:	db " ----------------- ----------------- --------", 0x0A, 0x0D, 0
.s2:	db " <more...>", 0
.s3:	db 0x0D, "          ", 0x0D, 0

ALIGN 4, db 0
.b0:	times E820_RECORD_SIZE db 0

put_mem_info:
	push bp
	mov bp,sp

	push bx
	push si

	;----------------
	;获得参数
	;----------------
	mov si,[bp + 4] ;//buffer_address
	;Base(64bit)
	cdecl itoa,word[si + 6],.p2+0,4,16,0b0100
	cdecl itoa,word[si + 4],.p2+4,4,16,0b0100
	cdecl itoa,word[si + 2],.p3+0,4,16,0b0100
	cdecl itoa,word[si + 0],.p3+4,4,16,0b0100
	;Length(64bit)
	cdecl itoa,word[si + 14],.p4+0,4,16,0b0100
	cdecl itoa,word[si + 12],.p4+4,4,16,0b0100
	cdecl itoa,word[si + 10],.p5+0,4,16,0b0100
	cdecl itoa,word[si + 8] ,.p5+4,4,16,0b0100
	;Type(32bit)
	cdecl itoa,word[si + 18],.p4+0,4,16,0b0100
	cdecl itoa,word[si + 16],.p4+0,4,16,0b0100

	cdecl puts,.s1 ;//显示record信息


mov bx,[si+16]			;//type的字符串表示
and bx,0x07				;BX = Type(0~5)
shl bx,1				;BX *= 2
add bx,.t0				;BX += .t0 ;//加上table的地址
cdecl puts,word[bx]

pop si
pop bx

mov sp,bp
pop bp

ret;

.s1:	db " "
.p2:	db "ZZZZZZZZ_"
.p3:	db "ZZZZZZZZ "
.p4:	db "ZZZZZZZZ_"
.p5:	db "ZZZZZZZZ "
.p6:	db "ZZZZZZZZ",0

.s4:	db " (Unknown)", 0x0A, 0x0D, 0
.s5:	db " (usable)", 0x0A, 0x0D, 0
.s6:	db " (reserved)", 0x0A, 0x0D, 0
.s7:	db " (ACPI data)", 0x0A, 0x0D, 0
.s8:	db " (ACPI NVS)", 0x0A, 0x0D, 0
.s9:	db " (bad memory)", 0x0A, 0x0D, 0

.t0:	dw .s4, .s5, .s6, .s7, .s8, .s9, .s4, .s4