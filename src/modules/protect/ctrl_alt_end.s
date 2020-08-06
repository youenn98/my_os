ctrl_alt_end:
	
		push	ebp					
		mov		ebp, esp

		;---------------------------------------
		; key״̬����
		;---------------------------------------
		mov		eax, [ebp + 8]					; EAX = key;
		btr		eax, 7							; CF  = EAX & 0x80;
		jc		.10F							; if (0 == CF)
		bts		[.key_state], eax				; {
		jmp		.10E							;   // set flag
.10F:											; } else {
		btr		[.key_state], eax				;   // clear flag
.10E:											; }

		;---------------------------------------
		; �Ƿ���key���ж�
		;---------------------------------------
												; do
												; {
		mov		eax, 0x1D						;   // [Ctrl]���Ƿ񱻰���
		bt		[.key_state], eax				;   if (0 == key)
		jnc		.20E							;     break;
												;     
		mov		eax, 0x38						;   // [Alt]���Ƿ񱻰���
		bt		[.key_state], eax				;   if ('ALT' != key)
		jnc		.20E							;     break;
												;     
		mov		eax, 0x4F						;   // [End]���Ƿ񱻰���
		bt		[.key_state], eax				;   if ('End' != key)
		jnc		.20E							;     break;
												;   
		mov		eax, -1							;   ret = -1;
												;   
.20E:											; } while (0);

		sar		eax, 8							; ret >>= 8;

		mov		esp, ebp
		pop		ebp

		ret

.key_state:	times 32 db 0

