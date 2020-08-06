
itoa:

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
		mov		eax, [ebp + 8]					; val  = 数值;
		mov		esi, [ebp +12]					; dst  = buffer address;
		mov		ecx, [ebp +16]					; size = 剩下的buffer address;

		mov		edi, esi						; // buffer的末尾
		add		edi, ecx						; dst  = &dst[size - 1];
		dec		edi								; 

		mov		ebx, [ebp +24]					; flags = option;

		;---------------------------------------
		; 判定是否有符号
		;---------------------------------------
		test	ebx, 0b0001						; if (flags & 0x01)// 有符号
.10Q:	je		.10E							; {
		cmp		eax, 0							;   if (val < 0)
.12Q:	jge		.12E							;   {
		or		ebx, 0b0010						;     flags |=  2; // 表示符号
.12E:											;   }
.10E:											; }

		;---------------------------------------
		; 符号输出判定
		;---------------------------------------
		test	ebx, 0b0010						; if (flags & 0x02)// 符号输出判定
.20Q:	je		.20E							; {
		cmp		eax, 0							;   if (val < 0)
.22Q:	jge		.22F							;   {
		neg		eax								;     val *= -1;   // 变成正数
		mov		[esi], byte '-'					;     *dst = '-';  // 打印负号
		jmp		.22E							;   }
.22F:											;   else
												;   {
		mov		[esi], byte '+'					;     *dst = '+';  // 正号
.22E:											;   }
		dec		ecx								;   size--;        // 剩下的buffer_size-1
.20E:											; }

		;---------------------------------------
		; ASCII变换
		;---------------------------------------
		mov		ebx, [ebp +20]					; BX = 基数
.30L:											; do
												; {
		mov		edx, 0							;   
		div		ebx								;   DX = DX:AX % 基数;
												;   AX = DX:AX / 基数;
												;   
		mov		esi, edx						;   // 查表
		mov		dl, byte [.ascii + esi]			;   DL = ASCII[DX];
												;   
		mov		[edi], dl						;   *dst = DL;
		dec		edi								;   dst--;
												;   
		cmp		eax, 0							;   
		loopnz	.30L							; } while (AX);
.30E:

		;---------------------------------------
		; 空栏填充
		;---------------------------------------
		cmp		ecx, 0							; if (size)
.40Q:	je		.40E							; {
		mov		al, ' '							;   AL = ' ';  // ' '填充()默认值
		cmp		[ebp +24], word 0b0100			;   if (flags & 0x04)
.42Q:	jne		.42E							;   {
		mov		al, '0'							;     AL = '0'; // '0'填充
.42E:											;   }
		std										;   // DF = 1(-方向)
		rep stosb								;   while (--CX) *DI-- = ' ';
.40E:											; }


		pop		edi
		pop		esi
		pop		edx
		pop		ecx
		pop		ebx
		pop		eax


		mov		esp, ebp
		pop		ebp

		ret

.ascii	db		"0123456789ABCDEF"				; 变换表

