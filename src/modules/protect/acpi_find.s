;************************************************************************
;寻找ACPI
;************************************************************************
acpi_find:
		
		push	ebp								
		mov		ebp, esp					

		push	ebx
		push	ecx
		push	edi

		;---------------------------------------
		; 取得参数
		;---------------------------------------
		mov		edi, [ebp + 8]					; EDI  = address;
		mov		ecx, [ebp +12]					; ECX  = size;
		mov		eax, [ebp +16]					; EAX  = 搜索的数据;

		;---------------------------------------
		; 名字的搜索
		;---------------------------------------
		cld										; // DF clear（+方向）
.10L:											; for ( ; ; )
												; {
		repne	scasb							;   while (AL != *EDI) EDI++;
												;   
		cmp		ecx, 0							;   if (0 == ECX)
		jnz		.11E							;   {
		mov		eax, 0							;     EAX = 0; // 找不到
		jmp		.10E							;     break;
.11E:											;   }
												;   
		cmp		eax, [es:edi - 1]				;   if (EAX != *EDI) // 4字符相同？
		jne		.10L							;     continue;      // （不一致）
												;   
		dec		edi								;   EAX = EDI - 1;
		mov		eax, edi						;   
.10E:											; }

	
		pop		edi
		pop		ecx
		pop		ebx

		mov		esp, ebp
		pop		ebp

		ret

