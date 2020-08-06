;************************************************************************
;读取元素
;************************************************************************
ring_rd:

		push	ebp								
		mov		ebp, esp						

		push	ebx
		push	esi
		push	edi

		;---------------------------------------
		; 获取参数
		;---------------------------------------
		mov		esi, [ebp + 8]					; ESI = buffer地址;
		mov		edi, [ebp +12]					; EDI = 保存地址;

		;---------------------------------------
		; 确定读入位置
		;---------------------------------------
		mov		eax, 0							; EAX = 0;          // 没有数据
		mov		ebx, [esi + ring_buff.rp]		; EBX = rp;         // 读入位置
		cmp		ebx, [esi + ring_buff.wp]		; if (EBX != wp)    // 和写入位置不同
		je		.10E							; {
												;   
		mov		al, [esi + ring_buff.item + ebx] ;   AL = BUFF[rp]; // 保存key_code
												;   
		mov		[edi], al						;   [EDI] = AL;     // 保存数据
												;   
		inc		ebx								;   EBX++;          // 下个读取位置
		and		ebx, RING_INDEX_MASK			;   EBX &= 0x0F     // 大小的限制
		mov		[esi + ring_buff.rp], ebx		;   rp = EBX;       // 保存读取位置
												;   
		mov		eax, 1							;   EAX = 1;        // 有数据
.10E:											; }


		pop		edi
		pop		esi
		pop		ebx


		mov		esp, ebp
		pop		ebp

		ret

;************************************************************************
;写入数据
;************************************************************************
ring_wr:
											
		push	ebp								
		mov		ebp, esp						

		push	ebx
		push	ecx
		push	esi

		;---------------------------------------
		; 读取参数
		;---------------------------------------
		mov		esi, [ebp + 8]					; ESI = ring_buffer地址;

		;---------------------------------------
		; 彂偒崬傒埵抲傪妋擣
		;---------------------------------------
		mov		eax, 0							; EAX  = 0;         // 失败
		mov		ebx, [esi + ring_buff.wp]		; EBX  = wp;        // 写入位置
		mov		ecx, ebx						; ECX  = EBX;
		inc		ecx								; ECX++;            // 下一个写入位置
		and		ecx, RING_INDEX_MASK			; ECX &= 0x0F       // 大小限制
												; 
		cmp		ecx, [esi + ring_buff.rp]		; if (ECX != rp)    // 与读取位置不同
		je		.10E							; {
												; 
		mov		al, [ebp +12]					;   AL = 僨乕僞;
												; 
		mov		[esi + ring_buff.item + ebx], al ;   BUFF[wp] = AL; // 保存keycode
		mov		[esi + ring_buff.wp], ecx		;   wp = ECX;       // 保存写入位置
		mov		eax, 1							;   EAX = 1;        // 成功
.10E:											; }

	
		pop		esi
		pop		ecx
		pop		ebx

		mov		esp, ebp
		pop		ebp

		ret

;************************************************************************
;显示ring_buff里所以的keycode
;************************************************************************
draw_key:

		push	ebp								
		mov		ebp, esp						

		pusha

		;---------------------------------------
		; 获取参数
		;---------------------------------------
		mov		edx, [ebp + 8]					; EDX = X坐标;
		mov		edi, [ebp +12]					; EDI = Y坐标;
		mov		esi, [ebp +16]					; ESI = ring_buff地址;

		;---------------------------------------
		; 取得ring_buffer的情报
		;---------------------------------------
		mov		ebx, [esi + ring_buff.rp]		; EBX = rp;             // 读入位置
		lea		esi, [esi + ring_buff.item]		; ESI = &KEY_BUFF[EBX];
		mov		ecx, RING_ITEM_SIZE				; ECX = RING_ITEM_SIZE; // 元素的个数

		;---------------------------------------
		; 暥帤偵曄姺偟側偑傜昞帵
		;---------------------------------------
.10L:											; do
												; {
		dec		ebx								;   EBX--; // 读入位置
		and		ebx, RING_INDEX_MASK			;   EBX &= RING_INDEX_MASK;
		mov		al, [esi + ebx]					;   EAX  = KEY_BUFF[EBX];
												;   
		cdecl	itoa, eax, .tmp, 2, 16, 0b0100	;   // 将keycode转换为字符串
		cdecl	draw_str, edx, edi, 0x02, .tmp	;   // 表示转换后的字符串
												;   
		add		edx, 3							;   // 更新表示的位置
												;   
		loop	.10L							;   
.10E:											; } while (ECX--);

		popa

		mov		esp, ebp
		pop		ebp

		ret

.tmp	db "-- ", 0

