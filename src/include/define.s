BOOT_LOAD equ 0x7C00      ;//boot程序加载地址
BOOT_SIZE equ (1024 * 8)  ;//boot代码段大小
BOOT_END  equ (BOOT_LOAD + BOOT_SIZE) ;

SECT_SIZE equ (512)       ;//sector大小
BOOT_SECT equ (BOOT_SIZE / SECT_SIZE)   ;//boot的sector数

E820_RECORD_SIZE equ 20

KERNEL_LOAD equ 0x0010_1000
KERNEL_SIZE equ (1024 * 8) ;//kernel的大小仍然是8k
KERNEL_SECT equ (KERNEL_SIZE / SECT_SIZE)

VECT_BASE			equ		0x0010_0000		;	0010_0000:0010_07FF

		STACK_BASE		equ		 0x0010_3000
		STACK_SIZE		equ		 1024

		SP_TASK_0			equ		STACK_BASE + (STACK_SIZE * 1)
		SP_TASK_1			equ		STACK_BASE + (STACK_SIZE * 2)
		SP_TASK_2			equ		STACK_BASE + (STACK_SIZE * 3)
		SP_TASK_3			equ		STACK_BASE + (STACK_SIZE * 4)
		SP_TASK_4			equ		STACK_BASE + (STACK_SIZE * 5)
		SP_TASK_5			equ		STACK_BASE + (STACK_SIZE * 6)
		SP_TASK_6			equ		STACK_BASE + (STACK_SIZE * 7)

	CR3_BASE		equ			0x0010_5000 ;

PARAM_TASK_4 equ  0x0010_8000	;//描画parameter : task4用
PARAM_TASK_5 equ  0x0010_9000	;//描画parameter : task5用
PARAM_TASK_6 equ  0x0010_A000	;//描画parameter : task6用

CR3_TASK_4  equ		0x0020_0000
CR3_TASK_5  equ     0x0020_2000
CR3_TASK_6  equ     0x0020_4000