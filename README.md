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
	## boot功能扩充过程 
	
		1.01_bpb 预留Boot Parameter Block的空间(90 bytes)
		2.02_save_data 设置段寄存器为0,保存boot程序驱动番号,设置对齐(2)
		3.03_boot_putc 系统调动打印字符
		4.04_func_putc 使用函数打印字符
		5.05_func_puts 使用函数打印字符串 
		6.06_itoa  使用函数打印数值
		7.08_stage_2 读取下一个sector
		8.09_read_chs 将剩下来所有的boot程序需要的sector都读取了
		9.10_drive_param 获得drive参数并保存
		10.11_get_fontinfo 获得BIOS的font参数
		11.12_get_meminfo 获得内存的信息
		12.13_a20 a20Gate的有效化(需要将输出端口读出并设置A20 Gate信号有效,再将这个值重新设置到输出端口)
		13.14_key_board_led 用小键盘1,2,3控制3个键盘的led灯
		14.15_load_kernel 将kernel需要的内存读取出来,加载kernel
		15.16_protect_mode 从real mode 转换到 protect mode
	### real_mode 辅助函数 src/modules/real
		1.putc.s 打印一个字符的函数
		2.puts.s 打印一个字符串的函数
		3.itoa.s 将数值转换成字符串 
		4.reboot.s 重启
		5.read_chs.s 读取chs指定长度的sector到指定地址的函数
		6.get_drive_param.s 获得drive参数的函数
		7.get_font_adr.s 获得font参数的函数
		8.get_mem_info.s 获得内存信息函数
		9.kbc.s  对keyboard的buffer进行读取的函数
		10.read_lba.s 将lba指定的方式转换成chs指定,再通过chs读取出sector到指定地址
	## 辅助宏 src/include/
		1.macro.s 
			定义cdecl(使用类似于c语言的调用方式调用函数的宏)
			定义drive结构体
		2.define.s
			定义一些OS的常数
			
	#### 难点:
		1.debug非常麻烦,比如说,我在打印字符时打算用' '填充字符串,结果打成了''(空字符),因为没办法像很多语言一样
		使用print函数直接debug,只能在虚拟机上看找到对应内存的数据,对着ASCII表一个个找过来,才发现了一个非常
		简单的失误.
		2.在实行各种设定时,很多时候要保证不能发生中断.比如在设置A20 Gate和key_board_LED的时候,需要先设置不能中断,
		  并且需要让键盘无效化,处理结束之后不能忘记复原
		
__________________
#保护模式

	##画面输出
	1.17_draw_plane 测试用plane画点和线
	2.18_draw_char  测试打印字符
	3.19_draw_font  字符一览
	4.20_draw_str   测试打印字符串
	5.21_draw_color_bar   测试打印color_bar
	6.22_draw_pixel	测试打印pixel
	7.23_draw_line 测试打印线
	8.24_draw_rect 测试打印矩形
	9.25_draw_time 测试打印时间
    
	###辅助函数 src/modules/protect
	1.vga.s  选取输入输出用的plane,font的数据写入vram,在vram中的比特拷贝
	
	2.draw_char.s  在指定行列上输出指定前景/背景颜色的字符(可选择是否透明)
	3.draw_font.s  打印256个字符的一览
	4.draw_str.s   打印字符串函数
	5.draw_color_bar.s 打印colorbar
	6.draw_pixel.s	打印点   
	7.draw_line.s	打印线
	8.draw_rect.s   打印矩形
	9.itoa.s 		32位数字转换成字符串
	10.rtc.s		获取时间的函数
	
	###难点:
	1.用寄存器操作画面的时候,一次操作会影响到至少8个bit,所以需要用mask保证其他像素不收到影响
	2.打印的线的时候,由于没有实装小数的运算,所以要用整数的运算,判断设定哪些像素点
_______________________________________________________________________________________________
	##中断服务
	1.26_int_default 						测试default中断
	2.27_int_div_zero						测试除0中断
	3.28_int_rtc							测试rtc中断
	4.29_int_keyboard						测试键盘中断
	5.30_int_timer							测试计时器中断
	6.31_multi_task							使用call
	7.32_non_pre_task						在任务中跳转
	8.33_task_pre_emptive					使用timer的中断实现任务切换 
	9.34_call_gate 							用call_gate为低特权级别任务提供调用高特权任务的接口
											(将参数保存在stack里面)
	10.35_trap_gate							用trap_gate实现系统调用(将参数保存在寄存器里调用)
	11.36_test_and_set						为了防止资源竞争,使用一个变数作为资源是否被占用的标志
	
	###辅助函数 src/modules/protect
	1.iterrept.s  							 中断服务
	3.pic.s									 初始化programable interrupt controller
	4.int_rtc.s								 RTC的中断程序
	5.int_keyboard.s						 键盘的中断程序
	6.int_timer.s                            timer的中断程序
	7.ring_buff.s      						 键盘的环形缓存
	8.timer.s								 记录timer中断次数
	9.draw_rotarion_bar.s                    根据timer中断次数画旋转的棒
	10.descriptor.s							 描述表
	11.call_gate.s							 call_gate的实现							 
	12.trap_gate.s							 trap_gate的实现
	13.test_and_set.s						 test_and_set的实现
	
	###难点
	1.处理键盘中断的时候,需要给键盘的数据使用环装的buffer,防止还未被读取的数据被新的输入覆盖
	
	
	
_________________________________________________________________________________________________
	#浮点数计算
	
	
	
	
	
	