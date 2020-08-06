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
	;获取font address
	;----------------------
	mov esi,BOOT_LOAD + SECT_SIZE ;ESI = 0x7C00 + 512
	movzx eax,word[esi + 0]				;//eax = segment
	movzx ebx,word[esi + 2]				;//ebx = offset
	shl eax,4
	add eax,ebx
	mov [FONT_ADR],eax					;FONT_ADR[0] = eax


	;------------------------
	;TSS descriptor的设定
	;------------------------
	set_desc GDT.tss_0,TSS_0
	set_desc GDT.tss_1,TSS_1
	
	;--------------------
	;设置call gate
	;--------------------
	set_gate GDT.call_gate,call_gate	;//call gate的设定

	;----------------------
	;LDT的设定
	;----------------------
	set_desc	GDT.ldt, LDT, word LDT_LIMIT

	;-----------------------
	;加载GDT(重新设定)
	;-----------------------

	lgdt  [GDTR]			;//global descriptor table的设定

	;---------------------
	;栈设定
	;---------------------
	mov esp,SP_TASK_0	;//task0的栈设定

	;---------------------
	;task寄存器的初始化
	;---------------------
	mov ax,SS_TASK_0
	ltr ax				;//task寄存器的设定

    ;------------------------
	;中断向量生成和登陆
	;------------------------
	cdecl init_int					;//中断向量初始化
	cdecl init_pic					;//中断向量controller初始化

	set_vect 0x00,int_zero_div		;//中断登陆:除0
	set_vect 0x20,int_timer			;//中断登陆:timer
	set_vect 0x21,int_keyboard		;//中断登陆:KBC
	set_vect 0x28,int_rtc			;//中断登陆:RTC
	set_vect 0x81,trap_gate_81,word 0xEF00 ;//trap_gate的登陆 : 输出一个字符
	set_vect 0x82,trap_gate_82,word 0xEF00 ;//trap_gate的登陆 : 画一个像素

	;--------------------
	;RTC自发中断许可
	;--------------------
	cdecl rtc_int_en,0x10			;//rtc_int_en(UIE)允许更新循环结束中断
	cdecl int_en_timer0
	;-------------------
	;IMR(中断主寄存器)的设定
	;-------------------
	outp 0x21,0b_1111_1000			;//终端有效:从PIC/KBC
	outp 0xA1,0b_1111_1110			;//中断有效:RTC

	;-----------------
	;CPU的中断许可
	;-----------------
	sti

	;----------------
	;打印colorbar和字符
	;----------------
	cdecl draw_font,63,13
	cdecl draw_color_bar,63,4

	;---------------
	;表示字符串
	;---------------
	cdecl draw_str,25,14,0x010F,.s0;

	;----------------
	;表示时间
	;----------------
.10L:
	mov eax,[RTC_TIME]		;//获取时间
	cdecl draw_time,72,0,0x0700,eax  ;//时间的显示

	;-------------------------
	;打印rotation_bar
	;-------------------------
	cdecl draw_rotation_bar

	;-------------------------
	;键盘中断
	;--------------------------
	cdecl	ring_rd, _KEY_BUFF, .int_key	;   EAX = ring_rd(buff, &int_key);
	cmp		eax, 0							;   if (EAX == 0)
	je		.10E							;   {
												;   
	;---------------------------------------
	; 打印buffer内容
	;---------------------------------------
	cdecl	draw_key, 2, 29, _KEY_BUFF		;     ring_show(key_buff); // 打印字符串



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
