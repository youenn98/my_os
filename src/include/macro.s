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