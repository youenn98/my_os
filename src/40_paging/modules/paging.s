;************************************************************************

;************************************************************************
init_page:
		
		pusha

		;---------------------------------------
		; 生成page变换的table
		;---------------------------------------
		cdecl	page_set_4m, CR3_BASE			; // page变换

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

