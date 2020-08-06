call_gate:

		push	ebp								
		mov		ebp, esp						
	
		pusha
		push	ds
		push	es

		;---------------------------------------
		; data用segment设定
		;---------------------------------------
		mov		ax, 0x0010						; 
		mov		ds, ax							; 
		mov		es, ax							; 

		;---------------------------------------
		; 表示文字
		;---------------------------------------
		mov		eax, dword [ebp +12]			; EAX = X(列);
		mov		ebx, dword [ebp +16]			; EBX = Y(行);
		mov		ecx, dword [ebp +20]			; ECX = 颜色;
		mov		edx, dword [ebp +24]			; EDX = 文字;
		cdecl	draw_str, eax, ebx , ecx, edx	; draw_str();


		pop		es								; 
		pop		ds								; 
		popa									; 


		mov		esp, ebp
		pop		ebp

		retf	4 * 4

