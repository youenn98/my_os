
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
		; ��ȡ����
		;---------------------------------------
		mov		eax, [ebp + 8]					; val  = ��ֵ;
		mov		esi, [ebp +12]					; dst  = buffer address;
		mov		ecx, [ebp +16]					; size = ʣ�µ�buffer address;

		mov		edi, esi						; // buffer��ĩβ
		add		edi, ecx						; dst  = &dst[size - 1];
		dec		edi								; 

		mov		ebx, [ebp +24]					; flags = option;

		;---------------------------------------
		; �ж��Ƿ��з���
		;---------------------------------------
		test	ebx, 0b0001						; if (flags & 0x01)// �з���
.10Q:	je		.10E							; {
		cmp		eax, 0							;   if (val < 0)
.12Q:	jge		.12E							;   {
		or		ebx, 0b0010						;     flags |=  2; // ��ʾ����
.12E:											;   }
.10E:											; }

		;---------------------------------------
		; ��������ж�
		;---------------------------------------
		test	ebx, 0b0010						; if (flags & 0x02)// ��������ж�
.20Q:	je		.20E							; {
		cmp		eax, 0							;   if (val < 0)
.22Q:	jge		.22F							;   {
		neg		eax								;     val *= -1;   // �������
		mov		[esi], byte '-'					;     *dst = '-';  // ��ӡ����
		jmp		.22E							;   }
.22F:											;   else
												;   {
		mov		[esi], byte '+'					;     *dst = '+';  // ����
.22E:											;   }
		dec		ecx								;   size--;        // ʣ�µ�buffer_size-1
.20E:											; }

		;---------------------------------------
		; ASCII�任
		;---------------------------------------
		mov		ebx, [ebp +20]					; BX = ����
.30L:											; do
												; {
		mov		edx, 0							;   
		div		ebx								;   DX = DX:AX % ����;
												;   AX = DX:AX / ����;
												;   
		mov		esi, edx						;   // ���
		mov		dl, byte [.ascii + esi]			;   DL = ASCII[DX];
												;   
		mov		[edi], dl						;   *dst = DL;
		dec		edi								;   dst--;
												;   
		cmp		eax, 0							;   
		loopnz	.30L							; } while (AX);
.30E:

		;---------------------------------------
		; �������
		;---------------------------------------
		cmp		ecx, 0							; if (size)
.40Q:	je		.40E							; {
		mov		al, ' '							;   AL = ' ';  // ' '���()Ĭ��ֵ
		cmp		[ebp +24], word 0b0100			;   if (flags & 0x04)
.42Q:	jne		.42E							;   {
		mov		al, '0'							;     AL = '0'; // '0'���
.42E:											;   }
		std										;   // DF = 1(-����)
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

.ascii	db		"0123456789ABCDEF"				; �任��

