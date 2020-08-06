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
	;表示文字
	;------------------------------
	cdecl draw_char, 0,0,0x010F,'A'
	cdecl draw_char, 1,0,0x010F,'B'
	cdecl draw_char, 2,0,0x010F,'C'

	cdecl draw_char, 0,1,0x0402,'0'
	cdecl draw_char, 1,1,0x0212,'1'
	cdecl draw_char, 2,1,0x0212,'_'
	jmp $

ALIGN 4,db 0
FONT_ADR: dd 0


;*************************
;model
;*************************
%include "../modules/protect/vga.s"
%include "../modules/protect/draw_char.s"



;********************
;padding
;********************
	times KERNEL_SIZE -($-$$) db 0;
