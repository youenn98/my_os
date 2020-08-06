draw_line:


		push	ebp								
		mov		ebp, esp					
												; ---------------
		push	dword 0							;    - 4| sum   = 0; // �����Ļ���ֵ
		push	dword 0							;    - 8| x0    = 0; // X����
		push	dword 0							;    -12| dx    = 0; // X���ӷ�
		push	dword 0							;    -16| inc_x = 0; // X�������ӷ�(1 or -1)
		push	dword 0							;    -20| y0    = 0; // Y����
		push	dword 0							;    -24| dy    = 0; // Y���ӷ�
		push	dword 0							;    -28| inc_y = 0; // Y�������ӷ�(1 or -1)
												; ------|--------
		push	eax
		push	ebx
		push	ecx
		push	edx
		push	esi
		push	edi

		;---------------------------------------
		; �����(X��)
		;---------------------------------------
		mov		eax, [ebp + 8]					; EAX = X0;
		mov		ebx, [ebp +16]					; EBX = X1;
		sub		ebx, eax						; EBX = X1 - X0; //��
		jge		.10F							; if (�� < 0)
												; {
		neg		ebx								;   ��   *= -1;
		mov		esi, -1							;   // X��������ӷ�
		jmp		.10E							; }
.10F:											; else
												; {
		mov		esi, 1							;   // X��������ӷ�
.10E:											; }

		;---------------------------------------
		; �����(Y��)
		;---------------------------------------
		mov		ecx, [ebp +12]					; ECX = Y0
		mov		edx, [ebp +20]					; EDX = Y1
		sub		edx, ecx						; EDX = Y1 - Y0; // ��
		jge		.20F							; if (�� < 0)
												; {
		neg		edx								;   �� *= -1;
		mov		edi, -1							;   // Y��������ӷ�
		jmp		.20E							; }
.20F:											; else
												; {
		mov		edi, 1							;   // Y��������ӷ�
.20E:											; }

		;---------------------------------------
		; X��
		;---------------------------------------
		mov		[ebp - 8], eax					;   // X��:��ʼ����
		mov		[ebp -12], ebx					;   // X��:��
		mov		[ebp -16], esi					;   // X��:���ӷ�(��׼��1 or -1)

		;---------------------------------------
		; Y��
		;---------------------------------------
		mov		[ebp -20], ecx					;   // Y��:��ʼ����
		mov		[ebp -24], edx					;   // Y��:��
		mov		[ebp -28], edi					;   // Y��:���ӷ�(��׼�� 1 or -1)

		;---------------------------------------
		; �����ĸ��ǻ�׼��
		;---------------------------------------
		cmp		ebx, edx						; if (�� <= ��)
		jg		.22F							; {
												;   
		lea		esi, [ebp -20]					;   // Y���ǻ�׼��
		lea		edi, [ebp - 8]					;   // X���������
												;   
		jmp		.22E							; }
.22F:											; else
												; {
		lea		esi, [ebp - 8]					;   // X���ǻ�׼��
		lea		edi, [ebp -20]					;   // Y���������
.22E:											; }

		;---------------------------------------
		; ѭ��ִ�д���(��׼��ĵ���)
		;---------------------------------------
		mov		ecx, [esi - 4]					; ECX = ��׼�ử����;
		cmp		ecx, 0							; if (0 == ECX)
		jnz		.30E							; {
		mov		ecx, 1							;   ECX = 1;
.30E:											; }

		;---------------------------------------
		; ����
		;---------------------------------------
.50L:	
%ifdef  USE_SYSTEM_CALL
        mov eax, ecx

        mov ebx, [ebp + 24]
        mov ecx, [ebp - 8]
        mov edx, [ebp - 20]
        int 0x82

        mov ecx, eax
%else												; do
												; {
		cdecl	draw_pixel, dword [ebp - 8],dword [ebp -20],dword [ebp +24]		; //����
%endif
												;   // ��׼�����(1����)
		mov		eax, [esi - 8]					;   EAX = ��׼�����ӷ�(1 or -1);
		add		[esi - 0], eax					;   

												;   // ��������
		mov		eax, [ebp - 4]					;   EAX  = sum; // �����Ļ���ֵ;
		add		eax, [edi - 4]					;   EAX += dy;  // ���ӵķ�(�����Ļ���ֵ)
		mov		ebx, [esi - 4]					;   EBX  = dx;  // ���ӵķ�(��׼��Ļ���)

		cmp		eax, ebx						;   if (����ֵ <= ���������ӷ�)
		jl		.52E							;   {
		sub		eax, ebx						;     EAX -= EBX; // ����ֵ��ȥ���������ӷ�
												;     
												;     // ���ֵ�������(1����)
		mov		ebx, [edi - 8]					;     EBX =  ��������ӵķ�;
		add		[edi - 0], ebx					;		
.52E:											;   }
		mov		[ebp - 4], eax					;   // ����ֵ����
												;   
		loop	.50L							;   
.50E:											; } while (��������--);


		pop		edi
		pop		esi
		pop		edx
		pop		ecx
		pop		ebx
		pop		eax

		mov		esp, ebp
		pop		ebp

		ret

