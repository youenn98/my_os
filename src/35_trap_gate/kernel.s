%define USE_SYSTEM_CALL

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
	;TSS descriptor���趨
	;------------------------
	set_desc GDT.tss_0,TSS_0
	set_desc GDT.tss_1,TSS_1
	
	;--------------------
	;����call gate
	;--------------------
	set_gate GDT.call_gate,call_gate	;//call gate���趨

	;----------------------
	;LDT���趨
	;----------------------
	set_desc	GDT.ldt, LDT, word LDT_LIMIT

	;-----------------------
	;����GDT(�����趨)
	;-----------------------

	lgdt  [GDTR]			;//global descriptor table���趨

	;---------------------
	;ջ�趨
	;---------------------
	mov esp,SP_TASK_0	;//task0��ջ�趨

	;---------------------
	;task�Ĵ����ĳ�ʼ��
	;---------------------
	mov ax,SS_TASK_0
	ltr ax				;//task�Ĵ������趨

    ;------------------------
	;�ж��������ɺ͵�½
	;------------------------
	cdecl init_int					;//�ж�������ʼ��
	cdecl init_pic					;//�ж�����controller��ʼ��

	set_vect 0x00,int_zero_div		;//�жϵ�½:��0
	set_vect 0x20,int_timer			;//�жϵ�½:timer
	set_vect 0x21,int_keyboard		;//�жϵ�½:KBC
	set_vect 0x28,int_rtc			;//�жϵ�½:RTC
	set_vect 0x81,trap_gate_81,word 0xEF00 ;//trap_gate�ĵ�½ : ���һ���ַ�
	set_vect 0x82,trap_gate_82,word 0xEF00 ;//trap_gate�ĵ�½ : ��һ������

	;--------------------
	;RTC�Է��ж����
	;--------------------
	cdecl rtc_int_en,0x10			;//rtc_int_en(UIE)�������ѭ�������ж�
	cdecl int_en_timer0
	;-------------------
	;IMR(�ж����Ĵ���)���趨
	;-------------------
	outp 0x21,0b_1111_1000			;//�ն���Ч:��PIC/KBC
	outp 0xA1,0b_1111_1110			;//�ж���Ч:RTC

	;-----------------
	;CPU���ж����
	;-----------------
	sti

	;----------------
	;��ӡcolorbar���ַ�
	;----------------
	cdecl draw_font,63,13
	cdecl draw_color_bar,63,4

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
%include "./descriptor.s"
%include "./tasks/task_1.s"
%include	"../modules/protect/call_gate.s"
%include	"../modules/protect/trap_gate.s"

;********************
;padding
;********************
	times KERNEL_SIZE -($-$$) db 0;
