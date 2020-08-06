draw_char:

		push	ebp			
		mov		ebp, esp	
											

		push	eax
		push	ebx
		push	ecx
		push	edx
		push	esi
		push	edi

		;---------------------------------------
		; 取得参数
		;---------------------------------------
		movzx	esi, byte [ebp +20]				; ESI  = 字符码
		shl		esi, 4							; CL *= 16; // 1字符16byte
		add		esi, [FONT_ADR]					; ESI = font地址;

		;---------------------------------------
		; 取得复制目的地的地址
		; Adr = 0xA0000 + (640 / 8 * 16) * y + x
		;---------------------------------------
		mov		edi, [ebp +12]					; Y(行)
		shl		edi, 8							; EDI = Y * 256;
		lea		edi, [edi * 4 + edi + 0xA0000]	; EDI = Y *   4 + Y;
		add		edi, [ebp + 8]					; X(列)
%ifdef USE_TEST_AND_SET
		cdecl test_and_set,IN_USE			;TEST_AND_SET(IN_USE);//等待资源空闲
%endif
		;---------------------------------------
		; 输出一字符的font
		;---------------------------------------
		movzx	ebx, word [ebp +16]				; // 颜色

		cdecl	vga_set_read_plane, 0x03		; // 写入plane(亮度:I)
		cdecl	vga_set_write_plane, 0x08		; // 输出plane(亮度:I)
		cdecl	vram_font_copy, esi, edi, 0x08, ebx

		cdecl	vga_set_read_plane, 0x02		; //写入plane(红:R)
		cdecl	vga_set_write_plane, 0x04		; //输出plane(红:R)
		cdecl	vram_font_copy, esi, edi, 0x04, ebx

		cdecl	vga_set_read_plane, 0x01		; // 写入plane(绿:G)
		cdecl	vga_set_write_plane, 0x02		; // 输出plane(绿:G)
		cdecl	vram_font_copy, esi, edi, 0x02, ebx

		cdecl	vga_set_read_plane, 0x00		; // 写入plane(蓝:B)
		cdecl	vga_set_write_plane, 0x01		; // 输出plane(蓝:B)
		cdecl	vram_font_copy, esi, edi, 0x01, ebx
%ifdef USE_TEST_AND_SET
		mov [IN_USE],dword 0 ;//清空值
%endif
		pop		edi
		pop		esi
		pop		edx
		pop		ecx
		pop		ebx
		pop		eax

		mov		esp, ebp
		pop		ebp

		ret
ALIGN 4,db 0x00
IN_USE: dd 0
