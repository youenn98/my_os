trap_gate_81:
		;---------------------------------------
		; 1个字符的输出
		;---------------------------------------
		cdecl	draw_char, ecx, edx, ebx, eax

		iret


trap_gate_82:
		;---------------------------------------
		; 一个像素的描画
		;---------------------------------------
		cdecl	draw_pixel, ecx, edx, ebx

		iret

