;************************************************************************
;��ȡԪ��
;************************************************************************
ring_rd:

		push	ebp								
		mov		ebp, esp						

		push	ebx
		push	esi
		push	edi

		;---------------------------------------
		; ��ȡ����
		;---------------------------------------
		mov		esi, [ebp + 8]					; ESI = buffer��ַ;
		mov		edi, [ebp +12]					; EDI = �����ַ;

		;---------------------------------------
		; ȷ������λ��
		;---------------------------------------
		mov		eax, 0							; EAX = 0;          // û������
		mov		ebx, [esi + ring_buff.rp]		; EBX = rp;         // ����λ��
		cmp		ebx, [esi + ring_buff.wp]		; if (EBX != wp)    // ��д��λ�ò�ͬ
		je		.10E							; {
												;   
		mov		al, [esi + ring_buff.item + ebx] ;   AL = BUFF[rp]; // ����key_code
												;   
		mov		[edi], al						;   [EDI] = AL;     // ��������
												;   
		inc		ebx								;   EBX++;          // �¸���ȡλ��
		and		ebx, RING_INDEX_MASK			;   EBX &= 0x0F     // ��С������
		mov		[esi + ring_buff.rp], ebx		;   rp = EBX;       // �����ȡλ��
												;   
		mov		eax, 1							;   EAX = 1;        // ������
.10E:											; }


		pop		edi
		pop		esi
		pop		ebx


		mov		esp, ebp
		pop		ebp

		ret

;************************************************************************
;д������
;************************************************************************
ring_wr:
											
		push	ebp								
		mov		ebp, esp						

		push	ebx
		push	ecx
		push	esi

		;---------------------------------------
		; ��ȡ����
		;---------------------------------------
		mov		esi, [ebp + 8]					; ESI = ring_buffer��ַ;

		;---------------------------------------
		; �������݈ʒu���m�F
		;---------------------------------------
		mov		eax, 0							; EAX  = 0;         // ʧ��
		mov		ebx, [esi + ring_buff.wp]		; EBX  = wp;        // д��λ��
		mov		ecx, ebx						; ECX  = EBX;
		inc		ecx								; ECX++;            // ��һ��д��λ��
		and		ecx, RING_INDEX_MASK			; ECX &= 0x0F       // ��С����
												; 
		cmp		ecx, [esi + ring_buff.rp]		; if (ECX != rp)    // ���ȡλ�ò�ͬ
		je		.10E							; {
												; 
		mov		al, [ebp +12]					;   AL = �f�[�^;
												; 
		mov		[esi + ring_buff.item + ebx], al ;   BUFF[wp] = AL; // ����keycode
		mov		[esi + ring_buff.wp], ecx		;   wp = ECX;       // ����д��λ��
		mov		eax, 1							;   EAX = 1;        // �ɹ�
.10E:											; }

	
		pop		esi
		pop		ecx
		pop		ebx

		mov		esp, ebp
		pop		ebp

		ret

;************************************************************************
;��ʾring_buff�����Ե�keycode
;************************************************************************
draw_key:

		push	ebp								
		mov		ebp, esp						

		pusha

		;---------------------------------------
		; ��ȡ����
		;---------------------------------------
		mov		edx, [ebp + 8]					; EDX = X����;
		mov		edi, [ebp +12]					; EDI = Y����;
		mov		esi, [ebp +16]					; ESI = ring_buff��ַ;

		;---------------------------------------
		; ȡ��ring_buffer���鱨
		;---------------------------------------
		mov		ebx, [esi + ring_buff.rp]		; EBX = rp;             // ����λ��
		lea		esi, [esi + ring_buff.item]		; ESI = &KEY_BUFF[EBX];
		mov		ecx, RING_ITEM_SIZE				; ECX = RING_ITEM_SIZE; // Ԫ�صĸ���

		;---------------------------------------
		; �����ɕϊ����Ȃ���\��
		;---------------------------------------
.10L:											; do
												; {
		dec		ebx								;   EBX--; // ����λ��
		and		ebx, RING_INDEX_MASK			;   EBX &= RING_INDEX_MASK;
		mov		al, [esi + ebx]					;   EAX  = KEY_BUFF[EBX];
												;   
		cdecl	itoa, eax, .tmp, 2, 16, 0b0100	;   // ��keycodeת��Ϊ�ַ���
		cdecl	draw_str, edx, edi, 0x02, .tmp	;   // ��ʾת������ַ���
												;   
		add		edx, 3							;   // ���±�ʾ��λ��
												;   
		loop	.10L							;   
.10E:											; } while (ECX--);

		popa

		mov		esp, ebp
		pop		ebp

		ret

.tmp	db "-- ", 0

