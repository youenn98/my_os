acpi_package_value:

		push	ebp							
		mov		ebp, esp					

		push	esi

		;---------------------------------------
		; 参数的取得
		;---------------------------------------
		mov		esi, [ebp + 8]					; ESI = package的地址;

		;---------------------------------------
		; 跳过package的头部
		;---------------------------------------
		inc		esi								; ESI++; // Skip 'PackageOp'
		inc		esi								; ESI++; // Skip 'PkgLength'
		inc		esi								; ESI++; // Skip 'NumElements'
												; ESI = PackageElemantList;

		;---------------------------------------
		; 只获取2byte
		;---------------------------------------
		mov		al, [esi]						; AL = *ESI;
		cmp		al, 0x0B						; switch (AL)
		je		.C0B							; {
		cmp		al, 0x0C						; 
		je		.C0C							; 
		cmp		al, 0x0E						; 
		je		.C0E							; 
		jmp		.C0A							; 
.C0B:											; case 0x0B: // 'WordPrefix'
.C0C:											; case 0x0C: // 'DWordPrefix'
.C0E:											; case 0x0E: // 'QWordPrefix'
		mov		al, [esi + 1]					;   AL = ESI[1];
		mov		ah, [esi + 2]					;   AH = ESI[2];
		jmp		.10E							;   break;
												;   
.C0A:											; default:   // 'BytePrefix' | 'ConstObj'
												;   // 最初的1byte
		cmp		al, 0x0A						;   if (0x0A == AL)
		jne		.11E							;   {
		mov		al, [esi + 1]					;     AL = *ESI;
		inc		esi								;     ESI++;
.11E:											;   }
												;   
												;   // 接下来的1byte
		inc		esi								;   ESI++;
												;   
		mov		ah, [esi]						;   AH = *ESI;
		cmp		ah, 0x0A						;   if (0x0A == AL)
		jne		.12E							;   {
		mov		ah, [esi + 1]					;     AH = ESI[1];
.12E:											;   }
.10E:											; }

		
		pop		esi

		mov		esp, ebp
		pop		ebp

		ret

