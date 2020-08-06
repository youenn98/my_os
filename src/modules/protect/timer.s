;************************************************************************
;timer的自发中断
;************************************************************************
int_en_timer0:
		push	eax

		;---------------------------------------
		;	8254 Timer
		;	0x2e9c(11932)=10[ms] @ CLK=1,193,182[Hz]
		;---------------------------------------
		 outp	 0x43, 0b_00_11_010_0			; // counter0, 低位/高位 写入, 模式2, binary
		 outp	 0x40, 0x9C						; // 低位
		 outp	 0x40, 0x2E						; // 高位


		pop		eax

		ret

