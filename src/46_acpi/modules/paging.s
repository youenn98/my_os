;************************************************************************

;************************************************************************
init_page:
		
		pusha

		;---------------------------------------
		; ����page�任��table
		;---------------------------------------
		cdecl	page_set_4m, CR3_BASE			; // page�任:task3
		cdecl	page_set_4m, CR3_TASK_4         ; // page�任:task4
		cdecl	page_set_4m, CR3_TASK_5			; // page�任:task5
		cdecl	page_set_4m, CR3_TASK_6			; // page�任:task6

		mov [0x0010_6000 + 0x107 * 4],dword 0    ;//�趨0x0010_7000������
		mov [0x0020_1000 + 0x107 * 4],dword PARAM_TASK_4 + 7;��ַ�任:task4��
		mov [0x0020_3000 + 0x107 * 4],dword PARAM_TASK_5 + 7;��ַ�任:task5��
		mov [0x0020_5000 + 0x107 * 4],dword PARAM_TASK_6 + 7;��ַ�任:task6��

		;---------------------------------------
		; �軭parameter���趨
		;---------------------------------------
		cdecl	memcpy, PARAM_TASK_4, DRAW_PARAM.t4, rose_size	; �軭parameter���趨task4��
		cdecl	memcpy, PARAM_TASK_5, DRAW_PARAM.t5, rose_size	; �軭parameter���趨task5��
		cdecl	memcpy, PARAM_TASK_6, DRAW_PARAM.t6, rose_size	; �軭parameter���趨task6��

		popa

		ret


;************************************************************************
;����4M��page
;************************************************************************
page_set_4m:
	
		push	ebp								
		mov		ebp, esp						
												
		pusha

		;---------------------------------------
		; ����page_directory(P=0)
		;---------------------------------------
		cld										; // DF�N���A�i+�����j
		mov		edi, [ebp + 8]					; EDI = page_directory;
		mov		eax, 0x00000000					; EAX = 0 ; // P = 0
		mov		ecx, 1024						; count = 1024;
		rep stosd								; whlie (count--) *dst++ = ����;

		;---------------------------------------
		; �ʼ��entry�趨
		;---------------------------------------
		mov		eax, edi						; EAX  = EDI;   // page_directory��
		and		eax, ~0x0000_0FFF				; EAX &= ~0FFF; // ָ�������ַ
		or		eax,  7							; EAX |=  7;    // RW�����
		mov		[edi - (1024 * 4)], eax			; // �ʼ��entry�趨

		;---------------------------------------
		; page_table���趨(����)
		;---------------------------------------
		mov		eax, 0x00000007					; // �����ַ��ָ����RW�����
		mov		ecx, 1024						; count = 1024;
												; do
.10L:											; {
		stosd									;   *dst++  = ����;
		add		eax, 0x00001000					;    adr   += 0x1000;
		loop	.10L							; } while (--count);


		popa

		mov		esp, ebp
		pop		ebp

		ret

