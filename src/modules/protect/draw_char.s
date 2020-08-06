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
		; ȡ�ò���
		;---------------------------------------
		movzx	esi, byte [ebp +20]				; ESI  = �ַ���
		shl		esi, 4							; CL *= 16; // 1�ַ�16byte
		add		esi, [FONT_ADR]					; ESI = font��ַ;

		;---------------------------------------
		; ȡ�ø���Ŀ�ĵصĵ�ַ
		; Adr = 0xA0000 + (640 / 8 * 16) * y + x
		;---------------------------------------
		mov		edi, [ebp +12]					; Y(��)
		shl		edi, 8							; EDI = Y * 256;
		lea		edi, [edi * 4 + edi + 0xA0000]	; EDI = Y *   4 + Y;
		add		edi, [ebp + 8]					; X(��)
%ifdef USE_TEST_AND_SET
		cdecl test_and_set,IN_USE			;TEST_AND_SET(IN_USE);//�ȴ���Դ����
%endif
		;---------------------------------------
		; ���һ�ַ���font
		;---------------------------------------
		movzx	ebx, word [ebp +16]				; // ��ɫ

		cdecl	vga_set_read_plane, 0x03		; // д��plane(����:I)
		cdecl	vga_set_write_plane, 0x08		; // ���plane(����:I)
		cdecl	vram_font_copy, esi, edi, 0x08, ebx

		cdecl	vga_set_read_plane, 0x02		; //д��plane(��:R)
		cdecl	vga_set_write_plane, 0x04		; //���plane(��:R)
		cdecl	vram_font_copy, esi, edi, 0x04, ebx

		cdecl	vga_set_read_plane, 0x01		; // д��plane(��:G)
		cdecl	vga_set_write_plane, 0x02		; // ���plane(��:G)
		cdecl	vram_font_copy, esi, edi, 0x02, ebx

		cdecl	vga_set_read_plane, 0x00		; // д��plane(��:B)
		cdecl	vga_set_write_plane, 0x01		; // ���plane(��:B)
		cdecl	vram_font_copy, esi, edi, 0x01, ebx
%ifdef USE_TEST_AND_SET
		mov [IN_USE],dword 0 ;//���ֵ
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
