get_drive_param:
	


	push bp
	mov bp,sp


	push bx
	push cx
	push es
	push si
	push di



	mov si,[bp+4]

	mov ax,0   ;//Disk Base Table Pointer�γ��ڻ�
	mov es,ax
	mov di,ax  

	mov ah,8 ;//ȡ��drive parameters
	mov dl,[si+drive.no] ;//dl = drive��
	int 0x13
.10Q: jc   .10F
.10T:
	mov al,cl
	and ax,0x3F ;//�����λ

	shr  cl,6;    CX = cylinder��
	ror cx,8;	
	inc cx ;	cylinder��1����

	movzx bx,dh     ;bx = head��
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