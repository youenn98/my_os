draw_time:
		push	ebp	
		mov		ebp, esp
											

		push	eax
		push	ebx

		;---------------------------------------
		; ��ȡʱ������
		;---------------------------------------
	    mov		eax, [ebp +20]					; EAX = ʱ������;
		cmp		eax, [.last]					; if (���� != �O��)
		je		.10E							; {
												;   
		mov		[.last], eax					;   // �O��̎����l���X�V

		mov		ebx, 0							;   EBX = 0;
		mov		bl, al							;   EBX = ��;
		cdecl	itoa, ebx, .sec, 2, 16, 0b0100	;   //ת�����ַ���

		mov		bl, ah							;   EBX = ��;
		cdecl	itoa, ebx, .min, 2, 16, 0b0100	;   // ת�����ַ���

		shr		eax, 16							;   EBX = ʱ;
		cdecl	itoa, eax, .hour, 2, 16, 0b0100	;   // ת�����ַ���

												;   // ���ʱ��
		cdecl	draw_str, dword [ebp + 8], dword [ebp +12], dword [ebp +16], .hour
												;     
												;   }
.10E:											; }

		pop		ebx
		pop		eax

		mov		esp, ebp
		pop		ebp

		ret

ALIGN 2, db 0
.temp:	dq	0
.last:	dq	0
.hour:	db	"ZZ:"
.min:	db	"ZZ:"
.sec:	db	"ZZ", 0

