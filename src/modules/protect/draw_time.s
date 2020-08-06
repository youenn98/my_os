draw_time:
		push	ebp	
		mov		ebp, esp
											

		push	eax
		push	ebx

		;---------------------------------------
		; 获取时间数据
		;---------------------------------------
	    mov		eax, [ebp +20]					; EAX = 时间数据;
		cmp		eax, [.last]					; if (崱夞 != 慜夞)
		je		.10E							; {
												;   
		mov		[.last], eax					;   // 慜夞偺帪崗抣傪峏怴

		mov		ebx, 0							;   EBX = 0;
		mov		bl, al							;   EBX = 秒;
		cdecl	itoa, ebx, .sec, 2, 16, 0b0100	;   //转换成字符串

		mov		bl, ah							;   EBX = 分;
		cdecl	itoa, ebx, .min, 2, 16, 0b0100	;   // 转换成字符串

		shr		eax, 16							;   EBX = 时;
		cdecl	itoa, eax, .hour, 2, 16, 0b0100	;   // 转换成字符串

												;   // 输出时间
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

