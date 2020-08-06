%macro cdecl 1-*.nolist  ;//1-*��һ�����ϵĲ���

	%rep %0 - 1         ;//%0�ǲ����ĸ���
		push %{-1:-1}  ;//%����������ѹջ
		%rotate -1   
	%endrep
	%rotate -1      ;//�ָ�ԭ���Ĳ���

	call %1
	%if 1 < %0
		add sp,(__BITS__ >> 3)*(%0 - 1)     ;//__BITS__�Ǳ�ʾ16����ģʽ����32����ģʽ
	%endif									;//��ÿ����������ջ�ռ�
%endmacro

struc drive
	.no resw 1	 ;������
	.cyln resw 1 ;cylinder
	.head resw 1 ;head
	.sect resw 1 ;sector
endstruc

%macro set_vect 1-*.nolist
		push eax
		push edi

		mov edi,VECT_BASE + (%1 * 8)  ;������ַ
		mov eax, %2

	%if 3 == %0
		mov [edi + 4],%3
	%endif

		mov  [edi + 0],ax		;�����ַ[15:0]
		shr eax,16
		mov  [edi + 6],ax		;�����ַ[31:16]

		pop edi
		pop eax
%endmacro


%macro outp 2
	mov al,%2
	out %1,al
%endmacro

%define RING_ITEM_SIZE (1<<4)
%define RING_INDEX_MASK (RING_ITEM_SIZE - 1)

struc ring_buff
	.rp		resd 1
	.wp		resd 1
	.item   resb RING_ITEM_SIZE
endstruc

%macro  set_desc 2-* 
		push	eax
		push	edi

		mov		edi, %1							
		mov		eax, %2							

	%if 3 == %0
		mov		[edi + 0], %3		
	%endif

		mov		[edi + 2], ax					; [15: 0]
		shr		eax, 16							; 
		mov		[edi + 4], al					; [23:16]
		mov		[edi + 7], ah					; [31:24]

		pop		edi
		pop		eax
%endmacro

;����call_gate

%macro  set_gate 2-* 
		push	eax
		push	edi

		mov		edi, %1							; descriptor address
		mov		eax, %2							; base address

		mov		[edi + 0], ax					; base([15: 0])
		shr		eax, 16							; 
		mov		[edi + 6], ax					; base([31:16])

		pop		edi
		pop		eax
%endmacro

struc rose
		.x0				resd	1				; ��������:X0
		.y0				resd	1				; ��������:Y0
		.x1				resd	1				; ��������:X1
		.y1				resd	1				; ��������:Y1

		.n				resd	1				; ����:n
		.d				resd	1				; ����:d

		.color_x		resd	1				; ��ɫ:X��
		.color_y		resd	1				; ��ɫ:Y��
		.color_z		resd	1				; ��ɫ:����
		.color_s		resd	1				; ��ɫ:����
		.color_f		resd	1				; ��ɫ:graph�軭��ɫ
		.color_b		resd	1				; ��ɫ:graph��ȥ��ɫ

		.title			resb	16				; title
endstruc
