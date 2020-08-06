KBC_Data_Write:

		push	bp								
		mov		bp, sp							

	
		push	cx

		mov		cx, 0							; CX = 0; 
.10L:											; do
												; {
		in		al, 0x64						;   AL = inp(0x64);
		test    al, 0x02						;   ZF = AL & 0x02;
		loopnz	.10L							; } while (--CX && !ZF);
												; 
		cmp		cx, 0							; if (CX)
		jz		.20E							; {
												;   
		mov		al, [bp + 4]					; 
		out    	0x60, al						;   outp(0x60, AL);
.20E:											; }
												; 
		mov		ax, cx							; return CX;

		pop		cx

		mov		sp, bp
		pop		bp

		ret


KBC_Data_Read:
	
												
		push	bp								
		mov		bp, sp							

	
		push	cx
		push	di

	
		mov		cx, 0							; CX = 0;
.10L:											; do
												; {
		in		al, 0x64						;   AL = inp(0x64);
		test    al, 0x01						;   ZF = AL & 0x01; 
		loopz	.10L							; } while (--CX && ZF);
												;   
		cmp		cx, 0							; if (CX) 
		jz		.20E							; {
												;   
		mov		ah, 0x00						;   AH = 0x00;
		in     	al, 0x60						;   AL = inp(0x60);
												;   
		mov		di, [bp + 4]					;   DI    = adr;
		mov		[di + 0], ax					;   DI[0] = AX;
.20E:											; }
												; 
		mov		ax, cx							; return CX;

	
		pop		di
		pop		cx


		mov		sp, bp
		pop		bp

		ret

KBC_Cmd_Write:

												
											
		push	bp							
		mov		bp, sp							

	
		push	cx

	
		mov		cx, 0							
.10L:											
											
		in		al, 0x64					
		test    al, 0x02						
		loopnz	.10L							
												
		cmp		cx, 0							
		jz		.20E							
												
		mov		al, [bp + 4]					
		out    	0x64, al						
.20E:											

		mov		ax, cx							

		pop		cx

		mov		sp, bp
		pop		bp

		ret

