%include "../include/define.s"
%include "../include/macro.s"
	
	ORG KERNEL_LOAD

[BITS 32]
;*******************
;entry  point
;*******************
kernel:
	;----------------------
	;获取font address
	;----------------------
	mov esi,BOOT_LOAD + SECT_SIZE ;ESI = 0x7C00 + 512
	movzx eax,word[esi + 0]				;//eax = segment
	movzx ebx,word[esi + 2]				;//ebx = offset
	shl eax,4
	add eax,ebx
	mov [FONT_ADR],eax					;FONT_ADR[0] = eax

	;------------------------------
	;8bit的横线
	;------------------------------
	mov ah,0x07			;//读入plane(Bit:----IRGB)
	mov al,0x02			;//AL = mapmask寄存器

	mov dx,0x03c4		;//dx = sequence控制端口
	out dx,ax			;//端口输出

	mov [0x000A_0000 + 1],byte 0xFF	;//8个点的横线

	mov ah,0x02						;//(Bit:----IRGB)
	out dx,ax

	mov [0x000A_0000 + 2],byte 0xFF	;//8个点的横线

	mov ah,0x01						;//(Bit:----IRGB)
	out dx,ax
	
	mov [0x000A_0000 + 3],byte 0xFF	;//8个点的横线

	;-----------------------------------
	;横跨画面的横线
	;-----------------------------------
	mov      ah,0x02
	out		 dx,ax

	lea		edi,[0x000A_0000 + 80]	;EDI = VRAM地址
	mov		ecx,80				;//ECX = 反复的回数
	mov		al,0xFF				;//al = bit_pattern
	rep		stosb				;//*edi++ = al

	;-----------------------
	;第2行,8 dot的矩形
	;-----------------------
	mov   edi,1					;//edi = 行数

	shl   edi,8					;//edi *= 256
	lea	  edi,[edi * 4 + edi +0xA_0000];//EDI = VRAM地址

	mov		[edi + (80*0)],word 0xFF
	mov		[edi + (80*1)],word 0xFF
	mov		[edi + (80*2)],word 0xFF
	mov		[edi + (80*3)],word 0xFF
	mov		[edi + (80*4)],word 0xFF
	mov		[edi + (80*5)],word 0xFF
	mov		[edi + (80*6)],word 0xFF
	mov		[edi + (80*7)],word 0xFF
	
	;------------------------------
	;第3行文字
	;------------------------------
	mov esi,'A'
	shl esi,4
	add esi,[FONT_ADR]		;//esi = FONT_ADR['A']

	mov edi,2				;// edi - 行数
	shl edi,8				;//EDI*=256
	lea	  edi,[edi * 4 + edi +0xA_0000];//EDI = VRAM地址
	mov ecx,16
.10L:
	movsb			;//*edi++ =*esi++
	add edi,80-1	;//edi += 79
	loop .10L

	jmp $

ALIGN 4,db 0
FONT_ADR: dd 0
;********************
;padding
;********************
	times KERNEL_SIZE -($-$$) db 0;
