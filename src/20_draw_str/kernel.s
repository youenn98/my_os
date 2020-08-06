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
	;��ʾ����һ��
	;------------------------------
	cdecl draw_font, 63,13
	;------------------
	;��ӡ�ַ���
	;-------------------
	cdecl draw_str,25,14,0x010F,.s0 ; 


	jmp $
.s0 db "Hello, kernel!",0

ALIGN 4,db 0
FONT_ADR: dd 0


;*************************
;model
;*************************
%include "../modules/protect/vga.s"
%include "../modules/protect/draw_char.s"
%include "../modules/protect/draw_font.s"
%include "../modules/protect/draw_str.s"

;********************
;padding
;********************
	times KERNEL_SIZE -($-$$) db 0;
