# my_os
_______
## 开发环境
1. 编译环境:nasm-2.12.02-win32
2. 虚拟机:QEMU
3. x86模拟器:Bochs-2.6.11

### detail:  
    1.env\env.bat 设置编译的系统路径等
    2.env\mk.bat win的make
    3.src\00_boot_only\dev.bat 
    4.env\boot.bat 启动qemu的批处理文件
    5.env\box.bat ,bochsrc.bxrc ,cmd.init 启动Bochs的批处理文件
________
## 实模式
	### boot功能扩充过程 
		1.01_bpb 预留Boot Parameter Block的空间(90 bytes)
		2.02_save_data 设置段寄存器为0,保存boot程序驱动番号,设置对齐(2)
		3.03_boot_putc 系统调动打印字符
		4.04_func_putc 使用函数打印字符
		5.05_func_puts 使用函数打印字符串 
		6.06_itoa  使用函数打印数值
	### 辅助函数和宏
		1.src/include/macro.s 定义cdecl(使用类似于c语言的调用方式调用函数的宏)
		2.src/modules/real/putc.s 打印一个字符的函数
		3.src/modules/real/puts.s 打印一个字符串的函数
		4.src/modules/real/itoa.s 将数值转换成字符串 
	
	
	
	#### 难点:
		debug非常麻烦,比如说,我在打印字符时打算用' '填充字符串,结果打成了''(空字符),因为没办法像很多语言一样
		使用print函数直接debug,只能在虚拟机上看找到对应内存的数据,对着ASCII表一个个找过来,才发现了一个非常
		简单的失误.
	
	
	
	
	