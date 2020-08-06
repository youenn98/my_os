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
	;中断向量生成登陆
	;------------------------
	cdecl init_int					;//中断向量初始化
	set_vect 0x00,int_zero_div		;//中断登陆:除0

	;--------------------
	;除0中断测试
	;--------------------
	mov al,0
	div al
		
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
