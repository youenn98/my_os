get_drive_param:
	


	push bp
	mov bp,sp


	push bx
	push cx
	push es
	push si
	push di



	mov si,[bp+4]

	mov ax,0   ;//Disk Base Table Pointerの初期化
	mov es,ax
	mov di,ax  

	mov ah,8 ;//取得drive parameters
	mov dl,[si+drive.no] ;//dl = drive号
	int 0x13
.10Q: jc   .10F
.10T:
	mov al,cl
	and ax,0x3F ;//最低六位

	shr  cl,6;    CX = cylinder数
	ror cx,8;	
	inc cx ;	cylinder从1计数

	movzx bx,dh     ;bx = head数
	inc bx			

	mov  [si+drive.cyln],cx
	mov  [si+drive.head],bx
	mov  [si+drive.sect],ax

	jmp .10E
.10F:
	mov ax,0
.10E:
	pop di
	pop si
	pop es
	pop cx
	pop bx

	mov sp,bp
	pop bp

	ret