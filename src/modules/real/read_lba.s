lba_chs:

	push	bp
	mov		bp, sp
	
	push	ax
	push	bx
	push	dx
	push	si
	push	di

	mov		si, [bp + 4] ;//si  = drive
	mov		di, [bp + 6] ;//di = drv_chs

	mov al,[si + drive.head] ;//AL = maxhead
	mul byte[si+drive.sect]	 ;//AL = maxhead * maxsector
	mov bx,ax			;//BX = 每个cylinder的sector数

	mov dx,0
	mov ax,[bp + 8]
	div bx  ;//DX = AX%BX
			;//AX = AX/BX
	mov [di+drive.cyln],ax   ;drv_ch.cyln = cylinder番号

	mov ax,dx
	div byte[si + drive.sect]    ;AH = AX % maxsector
								 ;al = ax / maxsector
	movzx dx , ah
	inc dx

	mov ah,0x00

	mov [di + drive.head],ax
	mov [di + drive.sect],dx 

	pop di
	pop si
	pop dx
	pop bx
	pop ax

	mov sp,bp
	pop bp
	ret

read_lba:
											
		push	bp							
		mov		bp, sp			

		
		push	si

		mov		si, [bp + 4]					; SI = drive信息
		;------------------
		;将lba指定变为chs指定
		;------------------
		mov		ax, [bp + 6]					; AX = LBA;
		cdecl	lba_chs, si, .chs, ax			; lba_chs(drive, .chs, AX);

		;---------------------------------------
		; drive number的拷贝
		;---------------------------------------
		mov		al, [si + drive.no]				; 
		mov		[.chs + drive.no], al			; drive number

		;---------------------------------------
		; 读取sector
		;---------------------------------------
		cdecl	read_chs, .chs, word [bp + 8], word [bp +10] ;AX = read_chs(.chs, sector数, ofs);

		pop		si

		mov		sp, bp
		pop		bp

		ret

ALIGN 2
.chs:	times drive_size	db	0				;读取的sector的情报