find_rsdt_entry:
		push	ebp						
		mov		ebp, esp						

		push	ebx
		push	ecx
		push	esi
		push	edi

		;---------------------------------------
		; ��ȡ����
		;---------------------------------------
		mov		esi, [ebp + 8]					; EDI  = RSDT;
		mov		ecx, [ebp +12]					; ECX  = table��ʶ����;

		mov		ebx, 0							; adr = 0;

		;---------------------------------------
		; ACPI table����������
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
		cmp		[eax], ecx						;   if (ECX == *EAX) // table���ͱȽ�
		jne		.12E							;   {
		mov		ebx, eax						;     adr = EAX;     // FACP�ĵ�ַ
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

