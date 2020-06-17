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