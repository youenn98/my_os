vga_set_read_plane:
	
		push	ebp	
		mov		ebp, esp						

		push	eax
		push	edx

		;---------------------------------------
		;选择读取的plane
		;---------------------------------------
		mov		ah, [ebp + 8]					; AH  = 指定读取的palne(----RGB)
		and		ah, 0x03						; AH &= 0x03; // mask掉不要的bit
		mov		al, 0x04						; AL  = 读取map选择寄存器
		mov		dx, 0x03CE						; DX  = 图像控制端口
		out		dx, ax							; // 端口输出

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
		; 选择写入的plane
		;---------------------------------------
		mov		ah, [ebp + 8]					; AH = 指定写入的plane(Bit:----IRGB)
		and		ah, 0x0F						; AH = 0x0F; // mask掉不需要的比特
		mov		al, 0x02						; AL = 指定写入plane
		mov		dx, 0x03C4						; DX = sequence控制端口
		out		dx, ax							; // 端口输出


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
		; 获取参数
		;---------------------------------------
		mov		esi, [ebp + 8]					; ESI = font地址
		mov		edi, [ebp +12]					; EDI = VRAM地址;
		movzx	eax, byte [ebp +16]				; EAX = plane(用比特指定);
		movzx	ebx, word [ebp +20]				; EBX = 颜色;

		;//背景色或者前景色包含plane的时候设置为0xff,不包含的时候设置为0x00

		test	bh, al							; ZF = (背景色 & plane);
		setz	dh								; AH = ZF ? 0x01 : 0x00
		dec		dh								; AH--; // 0x00 or 0xFF

		test	bl, al							; ZF = (前景色 & plane);
		setz	dl								; AL = ZF ? 0x01 : 0x00
		dec		dl								; AL--; // 0x00 or 0xFF

		;---------------------------------------
		; 复制16个点的font
		;---------------------------------------
		cld										; DF  = 0; 

		mov		ecx, 16							; ECX = 16; // 16个点
.10L:											; do
												; {
		;---------------------------------------
		; 生成font_mask
		;---------------------------------------
		lodsb									;   AL  = *ESI++; //  font
		mov		ah, al							;   AH ~= AL;     // !font(比特反转)
		not		ah								;   

		;---------------------------------------
		; 前景色
		;---------------------------------------
		and		al, dl							;   AL =前景色 & font;

		;---------------------------------------
		; 背景色
		;---------------------------------------
		test	ebx, 0x0010						;   if (透明模式)
		jz		.11F							;   {
		and		ah, [edi]						;     AH = !font & [EDI] // 现在值
		jmp		.11E							;   }
.11F:											;   else
												;   {
		and		ah, dh							;     AH = !font & 背景色;
.11E:											;   }

		;---------------------------------------
		; 前景色和背景色的合成
		;---------------------------------------
		or		al, ah							;   AL  = 前景 | 背景;

		;---------------------------------------
		; 输出新的值
		;---------------------------------------
		mov		[edi], al						;   [EDI] = AL; // 写入plane

		add		edi, 80							;   EDI += 80;(font是30x80)
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
		; 获取参数
		;---------------------------------------
		mov		edi, [ebp +12]					; EDI = VRAM地址
		movzx	eax, byte [ebp +16]				; EAX = palne(bit);
		movzx	ebx, word [ebp +20]				; EBX = 表示颜色;

		test	bl, al							; ZF = (前景色 & plane);
		setz	bl								; BL = ZF ? 0x01 : 0x00
		dec		bl								; BL--; // 0x00 or 0xFF

		;---------------------------------------
		; 输出比特模式的反
		;---------------------------------------
		mov		al, [ebp + 8]					; AL = 输出比特模式
		mov		ah, al							; AH ~= AL;     // ! 输出比特模式
		not		ah								; 

		;---------------------------------------
		; 生成输入的值
		;---------------------------------------
		and		ah, [edi]						; AH  =  ! 输出比特模式 & 现在值
		and		al, bl							; AL  = 输出比特模式 &  表示色
		or		al, ah							; AL |= AH;

		;---------------------------------------
		; 数据写入
		;---------------------------------------
		mov		[edi], al						; [EDI] = BL; // 写入palne


		pop		edi
		pop		ebx
		pop		eax

		mov		esp, ebp
		pop		ebp

		ret

