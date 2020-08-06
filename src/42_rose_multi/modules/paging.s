;************************************************************************

;************************************************************************
init_page:
		
		pusha

		;---------------------------------------
		; 生成page变换的table
		;---------------------------------------
		cdecl	page_set_4m, CR3_BASE			; // page变换:task3
		cdecl	page_set_4m, CR3_TASK_4         ; // page变换:task4
		cdecl	page_set_4m, CR3_TASK_5			; // page变换:task5
		cdecl	page_set_4m, CR3_TASK_6			; // page变换:task6

		mov [0x0010_6000 + 0x107 * 4],dword 0    ;//设定0x0010_7000不存在
		mov [0x0020_1000 + 0x107 * 4],dword PARAM_TASK_4 + 7;地址变换:task4用
		mov [0x0020_3000 + 0x107 * 4],dword PARAM_TASK_5 + 7;地址变换:task5用
		mov [0x0020_5000 + 0x107 * 4],dword PARAM_TASK_6 + 7;地址变换:task6用

		;---------------------------------------
		; 描画parameter的设定
		;---------------------------------------
		cdecl	memcpy, PARAM_TASK_4, DRAW_PARAM.t4, rose_size	; 描画parameter的设定task4用
		cdecl	memcpy, PARAM_TASK_5, DRAW_PARAM.t5, rose_size	; 描画parameter的设定task5用
		cdecl	memcpy, PARAM_TASK_6, DRAW_PARAM.t6, rose_size	; 描画parameter的设定task6用

		popa

		ret


;************************************************************************
;设置4M的page
;************************************************************************
page_set_4m:
	
		push	ebp								
		mov		ebp, esp						
												
		pusha

		;---------------------------------------
		; 生成page_directory(P=0)
		;---------------------------------------
		cld										; // DF僋儕傾乮+曽岦乯
		mov		edi, [ebp + 8]					; EDI = page_directory;
		mov		eax, 0x00000000					; EAX = 0 ; // P = 0
		mov		ecx, 1024						; count = 1024;
		rep stosd								; whlie (count--) *dst++ = 属性;

		;---------------------------------------
		; 最开始的entry设定
		;---------------------------------------
		mov		eax, edi						; EAX  = EDI;   // page_directory的
		and		eax, ~0x0000_0FFF				; EAX &= ~0FFF; // 指定物理地址
		or		eax,  7							; EAX |=  7;    // RW的许可
		mov		[edi - (1024 * 4)], eax			; // 最开始的entry设定

		;---------------------------------------
		; page_table的设定(线性)
		;---------------------------------------
		mov		eax, 0x00000007					; // 物理地址的指定和RW的许可
		mov		ecx, 1024						; count = 1024;
												; do
.10L:											; {
		stosd									;   *dst++  = 懏惈;
		add		eax, 0x00001000					;    adr   += 0x1000;
		loop	.10L							; } while (--count);


		popa

		mov		esp, ebp
		pop		ebp

		ret

