rtc_get_time:
		push	ebp								
		mov		ebp, esp
										
		push	ebx

		;---------------------------------------
		; RTC时间信息获得
		;---------------------------------------
		mov		al, 0x0A						; // 寄存器A
		out		0x70, al						; outp(0x70, AL);
		in		al, 0x71						; AL = 寄存器A;
		test	al, 0x80						; if (DM & UIP) // 更新中
		je		.10F							; {
		mov		eax, 1							;   ret = 1; // 数据更新中
		jmp		.10E							; }
.10F:											; else
												; {
												;   // RAM[0x04]:时
		mov		al, 0x04						;   AL = 0x04;
		out		0x70, al						;   outp(0x70, AL);
		in		al, 0x71						;   AL = inp(0x71); // 时data
												;   
		shl		eax, 8							;   EAX <<= 8;      // bit移位
												;   
												;   // RAM[0x02]:分
		mov		al, 0x02						;   AL = 0x02;
		out		0x70, al						;   outp(0x70, AL);
		in		al, 0x71						;   AL = inp(0x71); // 分data
												;   
		shl		eax, 8							;   EAX <<= 8;      // bit移位
												;   
												;   // RAM[0x00]:秒
		mov		al, 0x00						;   AL = 0x00;
		out		0x70, al						;   outp(0x70, AL);
		in		al, 0x71						;   AL = inp(0x71); //秒data
												;   
		and		eax, 0x00_FF_FF_FF				;   // 只有低位的3byte有效
												;   
		mov		ebx, [ebp + 8]					;   ebx = 保存地址;
		mov		[ebx], eax						;   [dst] = 时间;
												;   
		mov		eax, 0							;   ret = 0; // 正常
.10E:											; }

		pop		ebx

		mov		esp, ebp
		pop		ebp

		ret

