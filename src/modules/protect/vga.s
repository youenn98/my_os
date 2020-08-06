vga_set_read_plane:
	
		push	ebp	
		mov		ebp, esp						

		push	eax
		push	edx

		;---------------------------------------
		;ѡ���ȡ��plane
		;---------------------------------------
		mov		ah, [ebp + 8]					; AH  = ָ����ȡ��palne(----RGB)
		and		ah, 0x03						; AH &= 0x03; // mask����Ҫ��bit
		mov		al, 0x04						; AL  = ��ȡmapѡ��Ĵ���
		mov		dx, 0x03CE						; DX  = ͼ����ƶ˿�
		out		dx, ax							; // �˿����

		pop		edx
		pop		eax
		mov		esp, ebp
		pop		ebp

		ret

vga_set_write_plane:
											
		push	ebp								
		mov		ebp, esp						
											
		push	eax
		push	edx

		;---------------------------------------
		; ѡ��д���plane
		;---------------------------------------
		mov		ah, [ebp + 8]					; AH = ָ��д���plane(Bit:----IRGB)
		and		ah, 0x0F						; AH = 0x0F; // mask������Ҫ�ı���
		mov		al, 0x02						; AL = ָ��д��plane
		mov		dx, 0x03C4						; DX = sequence���ƶ˿�
		out		dx, ax							; // �˿����


		pop		edx
		pop		eax

		mov		esp, ebp
		pop		ebp

		ret

;
vram_font_copy:


		push	ebp							
		mov		ebp, esp						

		push	eax
		push	ebx
		push	ecx
		push	edx
		push	esi
		push	edi

		;---------------------------------------
		; ��ȡ����
		;---------------------------------------
		mov		esi, [ebp + 8]					; ESI = font��ַ
		mov		edi, [ebp +12]					; EDI = VRAM��ַ;
		movzx	eax, byte [ebp +16]				; EAX = plane(�ñ���ָ��);
		movzx	ebx, word [ebp +20]				; EBX = ��ɫ;

		;//����ɫ����ǰ��ɫ����plane��ʱ������Ϊ0xff,��������ʱ������Ϊ0x00

		test	bh, al							; ZF = (����ɫ & plane);
		setz	dh								; AH = ZF ? 0x01 : 0x00
		dec		dh								; AH--; // 0x00 or 0xFF

		test	bl, al							; ZF = (ǰ��ɫ & plane);
		setz	dl								; AL = ZF ? 0x01 : 0x00
		dec		dl								; AL--; // 0x00 or 0xFF

		;---------------------------------------
		; ����16�����font
		;---------------------------------------
		cld										; DF  = 0; 

		mov		ecx, 16							; ECX = 16; // 16����
.10L:											; do
												; {
		;---------------------------------------
		; ����font_mask
		;---------------------------------------
		lodsb									;   AL  = *ESI++; //  font
		mov		ah, al							;   AH ~= AL;     // !font(���ط�ת)
		not		ah								;   

		;---------------------------------------
		; ǰ��ɫ
		;---------------------------------------
		and		al, dl							;   AL =ǰ��ɫ & font;

		;---------------------------------------
		; ����ɫ
		;---------------------------------------
		test	ebx, 0x0010						;   if (͸��ģʽ)
		jz		.11F							;   {
		and		ah, [edi]						;     AH = !font & [EDI] // ����ֵ
		jmp		.11E							;   }
.11F:											;   else
												;   {
		and		ah, dh							;     AH = !font & ����ɫ;
.11E:											;   }

		;---------------------------------------
		; ǰ��ɫ�ͱ���ɫ�ĺϳ�
		;---------------------------------------
		or		al, ah							;   AL  = ǰ�� | ����;

		;---------------------------------------
		; ����µ�ֵ
		;---------------------------------------
		mov		[edi], al						;   [EDI] = AL; // д��plane

		add		edi, 80							;   EDI += 80;(font��30x80)
		loop	.10L							; } while (--ECX);
.10E:											; 
		pop		edi
		pop		esi
		pop		edx
		pop		ecx
		pop		ebx
		pop		eax

		mov		esp, ebp
		pop		ebp

		ret

vram_bit_copy:

		push	ebp							
		mov		ebp, esp						
												
		push	eax
		push	ebx
		push	edi

		;---------------------------------------
		; ��ȡ����
		;---------------------------------------
		mov		edi, [ebp +12]					; EDI = VRAM��ַ
		movzx	eax, byte [ebp +16]				; EAX = palne(bit);
		movzx	ebx, word [ebp +20]				; EBX = ��ʾ��ɫ;

		test	bl, al							; ZF = (ǰ��ɫ & plane);
		setz	bl								; BL = ZF ? 0x01 : 0x00
		dec		bl								; BL--; // 0x00 or 0xFF

		;---------------------------------------
		; �������ģʽ�ķ�
		;---------------------------------------
		mov		al, [ebp + 8]					; AL = �������ģʽ
		mov		ah, al							; AH ~= AL;     // ! �������ģʽ
		not		ah								; 

		;---------------------------------------
		; ���������ֵ
		;---------------------------------------
		and		ah, [edi]						; AH  =  ! �������ģʽ & ����ֵ
		and		al, bl							; AL  = �������ģʽ &  ��ʾɫ
		or		al, ah							; AL |= AH;

		;---------------------------------------
		; ����д��
		;---------------------------------------
		mov		[edi], al						; [EDI] = BL; // д��palne


		pop		edi
		pop		ebx
		pop		eax

		mov		esp, ebp
		pop		ebp

		ret

