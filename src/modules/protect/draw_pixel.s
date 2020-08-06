
draw_pixel:

		push	ebp			
		mov		ebp, esp						
		push	eax
		push	ebx
		push	ecx
		push	edi

		;---------------------------------------
		; 将Y坐标扩大80倍(640/8)
		;---------------------------------------
		mov		edi, [ebp +12]					; EDI  = Y坐标
		shl		edi, 4							; EDI *= 16;
		lea		edi, [edi * 4 + edi + 0xA_0000]	; EDI  = 0xA00000[EDI * 4 + EDI];

		;---------------------------------------
		; 加上X坐标的1/8
		;---------------------------------------
		mov		ebx, [ebp + 8]					; EBX  = X坐标
		mov		ecx, ebx						; ECX  = X坐标;(暂存)
		shr		ebx, 3							; EBX /= 8;
		add		edi, ebx						; EDI += EBX;

		;---------------------------------------
		; X坐标除8的余数来计算bit位置
		; (0=0x80, 1=0x40,... 7=0x01)
		;---------------------------------------
		and		ecx, 0x07						; ECX = X & 0x07;
		mov		ebx, 0x80						; EBX = 0x80;
		shr		ebx, cl							; EBX >>= ECX;

		;---------------------------------------
		; 指定颜色
		;---------------------------------------
		mov		ecx, [ebp +16]					; // 昞帵怓
%ifdef	USE_TEST_AND_SET
		cdecl	test_and_set, IN_USE			; TEST_AND_SET(IN_USE); 
%endif
		;---------------------------------------
		; 输出plane
		;---------------------------------------
		cdecl	vga_set_read_plane, 0x03		; 
		cdecl	vga_set_write_plane, 0x08		;
		cdecl	vram_bit_copy, ebx, edi, 0x08, ecx

		cdecl	vga_set_read_plane, 0x02		; 
		cdecl	vga_set_write_plane, 0x04		; 
		cdecl	vram_bit_copy, ebx, edi, 0x04, ecx

		cdecl	vga_set_read_plane, 0x01		; 
		cdecl	vga_set_write_plane, 0x02		; 
		cdecl	vram_bit_copy, ebx, edi, 0x02, ecx

		cdecl	vga_set_read_plane, 0x00		; 
		cdecl	vga_set_write_plane, 0x01		; 
		cdecl	vram_bit_copy, ebx, edi, 0x01, ecx
%ifdef	USE_TEST_AND_SET
		mov		[IN_USE], dword 0				; 清空位
%endif

		pop		edi
		pop		ecx
		pop		ebx
		pop		eax

		mov		esp, ebp
		pop		ebp

		ret

