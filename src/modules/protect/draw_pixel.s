
draw_pixel:

		push	ebp			
		mov		ebp, esp						
		push	eax
		push	ebx
		push	ecx
		push	edi

		;---------------------------------------
		; ��Y��������80��(640/8)
		;---------------------------------------
		mov		edi, [ebp +12]					; EDI  = Y����
		shl		edi, 4							; EDI *= 16;
		lea		edi, [edi * 4 + edi + 0xA_0000]	; EDI  = 0xA00000[EDI * 4 + EDI];

		;---------------------------------------
		; ����X�����1/8
		;---------------------------------------
		mov		ebx, [ebp + 8]					; EBX  = X����
		mov		ecx, ebx						; ECX  = X����;(�ݴ�)
		shr		ebx, 3							; EBX /= 8;
		add		edi, ebx						; EDI += EBX;

		;---------------------------------------
		; X�����8������������bitλ��
		; (0=0x80, 1=0x40,... 7=0x01)
		;---------------------------------------
		and		ecx, 0x07						; ECX = X & 0x07;
		mov		ebx, 0x80						; EBX = 0x80;
		shr		ebx, cl							; EBX >>= ECX;

		;---------------------------------------
		; ָ����ɫ
		;---------------------------------------
		mov		ecx, [ebp +16]					; // �\���F
%ifdef	USE_TEST_AND_SET
		cdecl	test_and_set, IN_USE			; TEST_AND_SET(IN_USE); 
%endif
		;---------------------------------------
		; ���plane
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
		mov		[IN_USE], dword 0				; ���λ
%endif

		pop		edi
		pop		ecx
		pop		ebx
		pop		eax

		mov		esp, ebp
		pop		ebp

		ret

