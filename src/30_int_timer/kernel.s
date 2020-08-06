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


    ;------------------------
	;�ж��������ɺ͵�½
	;------------------------
	cdecl init_int					;//�ж�������ʼ��
	cdecl init_pic					;//�ж�����controller��ʼ��

	set_vect 0x00,int_zero_div		;//�жϵ�½:��0
	set_vect 0x20,int_timer			;//�жϵ�½:timer
	set_vect 0x21,int_keyboard		;//�жϵ�½:KBC
	set_vect 0x28,int_rtc			;//�жϵ�½:RTC

	;--------------------
	;RTC�Է��ж����
	;--------------------
	cdecl rtc_int_en,0x10			;//rtc_int_en(UIE)�������ѭ�������ж�

	;-------------------
	;IMR(�ж����Ĵ���)���趨
	;-------------------
	outp 0x21,0b_1111_1000			;//�ն���Ч:��PIC/KBC
	outp 0xA1,0b_1111_1110			;//�ж���Ч:RTC

	;-----------------
	;CPU���ж����
	;-----------------
	sti

	;---------------
	;��ʾ�ַ���
	;---------------
	cdecl draw_str,25,14,0x010F,.s0;

	;----------------
	;��ʾʱ��
	;----------------
.10L:
	mov eax,[RTC_TIME]		;//��ȡʱ��
	cdecl draw_time,72,0,0x0700,eax  ;//ʱ�����ʾ

	;-------------------------
	;��ӡrotation_bar
	;-------------------------
	cdecl draw_rotation_bar

	;-------------------------
	;�����ж�
	;--------------------------
	cdecl	ring_rd, _KEY_BUFF, .int_key	;   EAX = ring_rd(buff, &int_key);
	cmp		eax, 0							;   if (EAX == 0)
	je		.10E							;   {
												;   
	;---------------------------------------
	; ��ӡbuffer����
	;---------------------------------------
	cdecl	draw_key, 2, 29, _KEY_BUFF		;     ring_show(key_buff); // ��ӡ�ַ���



.10E:
	jmp .10L
.s0 db "Hello, kernel!",0

ALIGN 4, db 0
.int_key:	dd	0

ALIGN 4,db 0
FONT_ADR: dd 0
RTC_TIME : dd 0

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
%include "../modules/protect/interrupt.s"
%include "../modules/protect/pic.s"
%include "../modules/protect/int_rtc.s"
%include "../modules/protect/int_keyboard.s"
%include "../modules/protect/ring_buff.s"
%include "./modules/int_timer.s"
%include "../modules/protect/timer.s"
%include "../modules/protect/draw_rotation_bar.s"

;********************
;padding
;********************
	times KERNEL_SIZE -($-$$) db 0;
