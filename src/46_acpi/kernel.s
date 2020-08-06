%define USE_SYSTEM_CALL
%define USE_TEST_AND_SET

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
	set_desc GDT.tss_0,TSS_0	;//task0��TSS�趨
	set_desc GDT.tss_1,TSS_1    ;//task1��TSS�趨
	set_desc GDT.tss_2,TSS_2    ;//task2��TSS�趨
	set_desc GDT.tss_3,TSS_3    ;//task3��TSS�趨
	set_desc GDT.tss_4,TSS_4    ;//task4��TSS�趨
	set_desc GDT.tss_5,TSS_5    ;//task5��TSS�趨
	set_desc GDT.tss_6,TSS_6    ;//task6��TSS�趨
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
	cdecl init_page					;//paging�ĳ�ʼ��

	set_vect 0x00,int_zero_div		;//�жϵ�½:��0
	set_vect 0x07,int_nm			;//�жϵ�½:����ʹ���豸
	set_vect 0x0E,int_pf			;//�жϵ�½:page default
	set_vect 0x20,int_timer			;//�жϵ�½:timer
	set_vect 0x21,int_keyboard		;//�жϵ�½:KBC
	set_vect 0x28,int_rtc			;//�жϵ�½:RTC
	set_vect 0x81,trap_gate_81,word 0xEF00 ;//trap_gate�ĵ�½ : ���һ���ַ�
	set_vect 0x82,trap_gate_82,word 0xEF00 ;//trap_gate�ĵ�½ : ��һ������

	;--------------------
	;RTC�Է��ж�����
	;--------------------
	cdecl rtc_int_en,0x10			;//rtc_int_en(UIE)��������ѭ�������ж�
	cdecl int_en_timer0
	;-------------------
	;IMR(�ж����Ĵ���)���趨
	;-------------------
	outp 0x21,0b_1111_1000			;//�ж���Ч:��PIC/KBC
	outp 0xA1,0b_1111_1110			;//�ж���Ч:RTC
	;--------------------
	;��page���ܱ����Ч
	;--------------------
	mov		eax, CR3_BASE					;
	mov		cr3, eax						; // page_table��½

	mov		eax, cr0						; // set PG_bit
	or		eax, (1 << 31)					; CR0 |= PG;
	mov		cr0, eax						; 
	jmp		$ + 2							; FLUSH();

	;-----------------
	;CPU���ж�����
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
	

.10L:

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

	;---------------------------------------
	; ����key�Ĵ���
	;---------------------------------------
	mov		al, [.int_key]					;     AL = [.int_key]; // keycode
	cmp		al, 0x02						;     if ('1' == AL)
	jne		.12E							;     {

	;---------------------------------------
	; ��ȡ�ļ�
	;---------------------------------------
	call	[BOOT_LOAD + BOOT_SIZE - 16]	;       // �t�@�C���ǂݍ���

	;---------------------------------------
	; ��ʾ�ļ�����
	;---------------------------------------
	mov		esi, 0x7800						;       ESI       = �ǂݍ��ݐ�A�h���X;
	mov		[esi + 32], byte 0				;       [ESI +32] = 0; // �ő�32����
	cdecl	draw_str, 0, 0, 0x0F04, esi		;       draw_str();    // ������̕\��
.12E:											;     }
		;---------------------------------------
		; CTRL+ALD+END�L�[
		;---------------------------------------
		mov		al, [.int_key]					;     AL  = [.int_key]; // �L�[�R�[�h
		cdecl	ctrl_alt_end, eax				;     EAX = ctrl_alt_end(�L�[�R�[�h);
		cmp		eax, 0							;     if (0 != EAX)
		je		.14E							;     {
												;       
		mov		eax, 0							;       // �d�f�����͈�x�����s��
		bts		[.once], eax					;       if (0 == bts(.once))
		jc		.14E							;       {
		cdecl	power_off						;         power_off(); // �d�f����
												;       }
.14E:											;     }


.10E:
	jmp .10L
.s0 db "Hello, kernel!",0

ALIGN 4, db 0
.int_key:	dd	0
.once:		dd	0

ALIGN 4,db 0
FONT_ADR: dd 0
RTC_TIME : dd 0

%include "./descriptor.s"
%include "./tasks/task_1.s"
%include "./tasks/task_2.s"
%include "./tasks/task_3.s"
%include "./modules/int_timer.s"
%include "./modules/paging.s"
%include "./modules/int_pf.s"
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
%include "../modules/protect/timer.s"
%include "../modules/protect/draw_rotation_bar.s"
%include "../modules/protect/call_gate.s"
%include "../modules/protect/trap_gate.s"
%include "../modules/protect/test_and_set.s"
%include	"../modules/protect/int_nm.s"
%include	"../modules/protect/wait_tick.s"
%include	"../modules/protect/memcpy.s"
%include	"../modules/protect/ctrl_alt_end.s"
%include	"../modules/protect/power_off.s"
%include	"../modules/protect/acpi_find.s"
%include	"../modules/protect/find_rsdt_entry.s"
%include	"../modules/protect/acpi_package_value.s"
;********************
;padding
;********************
	times KERNEL_SIZE -($-$$) db 0;