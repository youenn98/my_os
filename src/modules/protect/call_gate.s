call_gate:

		push	ebp								
		mov		ebp, esp						
	
		pusha
		push	ds
		push	es

		;---------------------------------------
		; data��segment�趨
		;---------------------------------------
		mov		ax, 0x0010						; 
		mov		ds, ax							; 
		mov		es, ax							; 

		;---------------------------------------
		; ��ʾ����
		;---------------------------------------
		mov		eax, dword [ebp +12]			; EAX = X(��);
		mov		ebx, dword [ebp +16]			; EBX = Y(��);
		mov		ecx, dword [ebp +20]			; ECX = ��ɫ;
		mov		edx, dword [ebp +24]			; EDX = ����;
		cdecl	draw_str, eax, ebx , ecx, edx	; draw_str();


		pop		es								; 
		pop		ds								; 
		popa									; 


		mov		esp, ebp
		pop		ebp

		retf	4 * 4

