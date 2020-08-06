draw_str:

		push	ebp							
		mov		ebp, esp					


		push	eax
		push	ebx
		push	ecx
		push	edx
		push	esi

		;---------------------------------------
		; 获取参数
		;---------------------------------------
		mov		ecx, [ebp + 8]					; ECX = 列;
		mov		edx, [ebp +12]					; EDX = 行;
		movzx	ebx, word [ebp + 16]			; EBX = 颜色;
		mov		esi, [ebp +20]					; ESI = 字符串地址;

		cld										; DF = 0; // 正方向
.10L:											; do
												; {
		lodsb									;   AL = *ESI++; // 暥帤傪庢摼
		cmp		al, 0							;   if (0 == AL)
		je		.10E							;     break;

%ifdef USE_SYSTEM_CALL
		int 0x81								;sys_call(1,X,Y,颜色,字符)
%else
		cdecl	draw_char, ecx, edx, ebx, eax	;   draw_char();
%endif
		; 師偺暥帤偺埵抲傪挷惍
		inc		ecx								;   ECX++;           // 列+1
		cmp		ecx, 80							;   if (80 <= ECX)   // 80列超过的话要换行
		jl		.12E							;   {
		mov		ecx, 0							;     ECX = 0;       // 列 = 0
		inc		edx								;     EDX++;         // 行 + 1
		cmp		edx, 30							;     if (30 <= EDX) // 30行以上换页
		jl		.12E							;     {
		mov		edx, 0							;       EDX = 0;     // 行 = 0
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

