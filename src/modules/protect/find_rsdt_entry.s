find_rsdt_entry:
		push	ebp						
		mov		ebp, esp						

		push	ebx
		push	ecx
		push	esi
		push	edi

		;---------------------------------------
		; 获取参数
		;---------------------------------------
		mov		esi, [ebp + 8]					; EDI  = RSDT;
		mov		ecx, [ebp +12]					; ECX  = table的识别子;

		mov		ebx, 0							; adr = 0;

		;---------------------------------------
		; ACPI table的搜索处理
		;---------------------------------------
		mov		edi, esi						; 
		add		edi, [esi + 4]					; EDI = &ENTRY[MAX];
		add		esi, 36							; ESI = &ENTRY[0];
.10L:											; 
		cmp		esi, edi						; while (ESI < EDI)
		jge		.10E							; {
												;   
		lodsd									;   EAX = [ESI++];   // entry
												;   
		cmp		[eax], ecx						;   if (ECX == *EAX) // table名和比较
		jne		.12E							;   {
		mov		ebx, eax						;     adr = EAX;     // FACP的地址
		jmp		.10E							;     break;
.12E:	jmp		.10L							;   }
.10E:											; }

		mov		eax, ebx						; return adr;

		
		pop		edi
		pop		esi
		pop		ecx
		pop		ebx

		mov		esp, ebp
		pop		ebp

		ret

