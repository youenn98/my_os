draw_str:

		push	ebp							
		mov		ebp, esp					


		push	eax
		push	ebx
		push	ecx
		push	edx
		push	esi

		;---------------------------------------
		; ��ȡ����
		;---------------------------------------
		mov		ecx, [ebp + 8]					; ECX = ��;
		mov		edx, [ebp +12]					; EDX = ��;
		movzx	ebx, word [ebp + 16]			; EBX = ��ɫ;
		mov		esi, [ebp +20]					; ESI = �ַ�����ַ;

		cld										; DF = 0; // ������
.10L:											; do
												; {
		lodsb									;   AL = *ESI++; // �������擾
		cmp		al, 0							;   if (0 == AL)
		je		.10E							;     break;

%ifdef USE_SYSTEM_CALL
		int 0x81								;sys_call(1,X,Y,��ɫ,�ַ�)
%else
		cdecl	draw_char, ecx, edx, ebx, eax	;   draw_char();
%endif
		; ���̕����̈ʒu�𒲐�
		inc		ecx								;   ECX++;           // ��+1
		cmp		ecx, 80							;   if (80 <= ECX)   // 80�г����Ļ�Ҫ����
		jl		.12E							;   {
		mov		ecx, 0							;     ECX = 0;       // �� = 0
		inc		edx								;     EDX++;         // �� + 1
		cmp		edx, 30							;     if (30 <= EDX) // 30�����ϻ�ҳ
		jl		.12E							;     {
		mov		edx, 0							;       EDX = 0;     // �� = 0
												;     }
.12E:											;   }
		jmp		.10L							;   
.10E:											; } while (1);

		pop		esi
		pop		edx
		pop		ecx
		pop		ebx
		pop		eax

		mov		esp, ebp
		pop		ebp

		ret

