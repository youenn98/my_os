;************************************************************************
;	KBC中断程序
;************************************************************************
int_keyboard:

		pusha
		push	ds
		push	es

		;---------------------------------------
		; 设置ds,es为数据用segment selector
		;---------------------------------------
		mov		ax, 0x0010						; 
		mov		ds, ax							; 
		mov		es, ax							; 

		;---------------------------------------
		; KBC的缓存读取
		;---------------------------------------
		in		al, 0x60						; AL = 获取keycode

		;---------------------------------------
		; keycode保存
		;---------------------------------------
		cdecl	ring_wr, _KEY_BUFF, eax			; ring_wr(_KEY_BUFF, EAX); // keycode保存

		;---------------------------------------
		; 发送中断结束信息
		;---------------------------------------
		outp	0x20, 0x20						; outp(); // 住PIC:EOI指令


		pop		es								; 
		pop		ds								; 
		popa

		iret

ALIGN 4, db 0
_KEY_BUFF:	times ring_buff_size db 0

