%include "../include/define.s"
%include "../include/macro.s"
	
	ORG KERNEL_LOAD

[BITS 32]
;*******************
;entry  point
;*******************
kernel:
	;----------------------
	;��ȡfont address
	;----------------------
	mov esi,BOOT_LOAD + SECT_SIZE ;ESI = 0x7C00 + 512
	movzx eax,word[esi + 0]				;//eax = segment
	movzx ebx,word[esi + 2]				;//ebx = offset
	shl eax,4
	add eax,ebx
	mov [FONT_ADR],eax					;FONT_ADR[0] = eax

	;------------------------------
	;8bit�ĺ���
	;------------------------------
	mov ah,0x07			;//����plane(Bit:----IRGB)
	mov al,0x02			;//AL = mapmask�Ĵ���

	mov dx,0x03c4		;//dx = sequence���ƶ˿�
	out dx,ax			;//�˿����

	mov [0x000A_0000 + 1],byte 0xFF	;//8����ĺ���

	mov ah,0x02						;//(Bit:----IRGB)
	out dx,ax

	mov [0x000A_0000 + 2],byte 0xFF	;//8����ĺ���

	mov ah,0x01						;//(Bit:----IRGB)
	out dx,ax
	
	mov [0x000A_0000 + 3],byte 0xFF	;//8����ĺ���

	;-----------------------------------
	;��续��ĺ���
	;-----------------------------------
	mov      ah,0x02
	out		 dx,ax

	lea		edi,[0x000A_0000 + 80]	;EDI = VRAM��ַ
	mov		ecx,80				;//ECX = �����Ļ���
	mov		al,0xFF				;//al = bit_pattern
	rep		stosb				;//*edi++ = al

	;-----------------------
	;��2��,8 dot�ľ���
	;-----------------------
	mov   edi,1					;//edi = ����

	shl   edi,8					;//edi *= 256
	lea	  edi,[edi * 4 + edi +0xA_0000];//EDI = VRAM��ַ

	mov		[edi + (80*0)],word 0xFF
	mov		[edi + (80*1)],word 0xFF
	mov		[edi + (80*2)],word 0xFF
	mov		[edi + (80*3)],word 0xFF
	mov		[edi + (80*4)],word 0xFF
	mov		[edi + (80*5)],word 0xFF
	mov		[edi + (80*6)],word 0xFF
	mov		[edi + (80*7)],word 0xFF
	
	;------------------------------
	;��3������
	;------------------------------
	mov esi,'A'
	shl esi,4
	add esi,[FONT_ADR]		;//esi = FONT_ADR['A']

	mov edi,2				;// edi - ����
	shl edi,8				;//EDI*=256
	lea	  edi,[edi * 4 + edi +0xA_0000];//EDI = VRAM��ַ
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
