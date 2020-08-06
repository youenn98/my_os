rtc_get_time:
		push	ebp								
		mov		ebp, esp
										
		push	ebx

		;---------------------------------------
		; RTCʱ����Ϣ���
		;---------------------------------------
		mov		al, 0x0A						; // �Ĵ���A
		out		0x70, al						; outp(0x70, AL);
		in		al, 0x71						; AL = �Ĵ���A;
		test	al, 0x80						; if (DM & UIP) // ������
		je		.10F							; {
		mov		eax, 1							;   ret = 1; // ���ݸ�����
		jmp		.10E							; }
.10F:											; else
												; {
												;   // RAM[0x04]:ʱ
		mov		al, 0x04						;   AL = 0x04;
		out		0x70, al						;   outp(0x70, AL);
		in		al, 0x71						;   AL = inp(0x71); // ʱdata
												;   
		shl		eax, 8							;   EAX <<= 8;      // bit��λ
												;   
												;   // RAM[0x02]:��
		mov		al, 0x02						;   AL = 0x02;
		out		0x70, al						;   outp(0x70, AL);
		in		al, 0x71						;   AL = inp(0x71); // ��data
												;   
		shl		eax, 8							;   EAX <<= 8;      // bit��λ
												;   
												;   // RAM[0x00]:��
		mov		al, 0x00						;   AL = 0x00;
		out		0x70, al						;   outp(0x70, AL);
		in		al, 0x71						;   AL = inp(0x71); //��data
												;   
		and		eax, 0x00_FF_FF_FF				;   // ֻ�е�λ��3byte��Ч
												;   
		mov		ebx, [ebp + 8]					;   ebx = �����ַ;
		mov		[ebx], eax						;   [dst] = ʱ��;
												;   
		mov		eax, 0							;   ret = 0; // ����
.10E:											; }

		pop		ebx

		mov		esp, ebp
		pop		ebp

		ret

