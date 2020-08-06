%macro cdecl 1-*.nolist  ;//1-*是一个以上的参数

	%rep %0 - 1         ;//%0是参数的个数
		push %{-1:-1}  ;//%将参数倒着压栈
		%rotate -1   
	%endrep
	%rotate -1      ;//恢复原来的参数

	call %1
	%if 1 < %0
		add sp,(__BITS__ >> 3)*(%0 - 1)     ;//__BITS__是表示16比特模式还是32比特模式
	%endif									;//给每个参数分配栈空间
%endmacro

struc drive
	.no resw 1	 ;驱动号
	.cyln resw 1 ;cylinder
	.head resw 1 ;head
	.sect resw 1 ;sector
endstruc

%macro set_vect 1-*.nolist
		push eax
		push edi

		mov edi,VECT_BASE + (%1 * 8)  ;向量地址
		mov eax, %2

	%if 3 == %0
		mov [edi + 4],%3
	%endif

		mov  [edi + 0],ax		;例外地址[15:0]
		shr eax,16
		mov  [edi + 6],ax		;例外地址[31:16]

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

;设置call_gate

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
		.x0				resd	1				; 左上坐标:X0
		.y0				resd	1				; 左上坐标:Y0
		.x1				resd	1				; 右下坐标:X1
		.y1				resd	1				; 右下坐标:Y1

		.n				resd	1				; 变数:n
		.d				resd	1				; 变数:d

		.color_x		resd	1				; 颜色:X轴
		.color_y		resd	1				; 颜色:Y轴
		.color_z		resd	1				; 颜色:轮廓
		.color_s		resd	1				; 颜色:文字
		.color_f		resd	1				; 颜色:graph描画颜色
		.color_b		resd	1				; 颜色:graph消去颜色

		.title			resb	16				; title
endstruc
