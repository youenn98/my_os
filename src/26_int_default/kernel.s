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

	cdecl draw_str,25,14,0x010F,.s0;
	;------------------------------
	;打印时间
	;------------------------------
.10L:
		cdecl rtc_get_time,RCT_TIME
		cdecl draw_time,72,0,0x0700,dword[RCT_TIME]
    ;------------------------
	;中断测试
	;------------------------
	push 0x11223344 ;//任意
	pushf           ;//保存状态标志
	call 0x0008:int_default   ;//调用default中断

		jmp	.10L
			
		
	jmp $
.s0 db "Hello, kernel!",0

ALIGN 4,db 0
FONT_ADR: dd 0
RCT_TIME : dd 0

;*************************
;model
;*************************
%include "../modules/protect/vga.s"
%include "../modules/protect/draw_char.s"
%include "../modules/protect/draw_font.s"
%include "../modules/protect/draw_str.s"
%include "../modules/protect/draw_color_bar.s"
%include "../modules/protect/draw_pixel.s"
%include "../modules/protect/draw_line.s"
%include "../modules/protect/draw_rect.s"
%include "../modules/protect/itoa.s"
%include "../modules/protect/rtc.s"
%include "../modules/protect/draw_time.s"
%include "modules/interrupt.s"

;********************
;padding
;********************
	times KERNEL_SIZE -($-$$) db 0;
