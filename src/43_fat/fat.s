;************************************************************************
;	FAT:FAT-1
;************************************************************************
		times (FAT1_START) - ($ - $$)	db	0x00
;------------------------------------------------------------------------
FAT1:
		db		0xFF, 0xFF												; cluster:0
		dw		0xFFFF													; cluster:1
		dw		0xFFFF													; cluster:2

;************************************************************************
;	FAT:FAT-2
;************************************************************************
		times (FAT2_START) - ($ - $$)	db	0x00
;------------------------------------------------------------------------
FAT2:
		db		0xFF, 0xFF												; cluster:0
		dw		0xFFFF													; cluster:1
		dw		0xFFFF													; cluster:2

;************************************************************************
;	FAT:根目录做成
;************************************************************************
		times (ROOT_START) - ($ - $$)	db	0x00
;------------------------------------------------------------------------
FAT_ROOT:
		db		'BOOTABLE', 'DSK'										; + 0:volumn lable
		db		ATTR_ARCHIVE | ATTR_VOLUME_ID							; +11:属性
		db		0x00													; +12:（保留）
		db		0x00													; +13:TS
		dw		( 0 << 11) | ( 0 << 5) | (0 / 2)						; +14:生成的时间
		dw		( 0 <<  9) | ( 0 << 5) | ( 1)							; +16:生成的日期
		dw		( 0 <<  9) | ( 0 << 5) | ( 1)							; +18:访问日
		dw		0x0000													; +20:（保留）
		dw		( 0 << 11) | ( 0 << 5) | (0 / 2)						; +22:更新时间
		dw		( 0 <<  9) | ( 0 << 5) | ( 1)							; +24:更新日
		dw		0														; +26:先头cluster
		dd		0														; +28:文件大小

		db		'SPECIAL ', 'TXT'										; + 0:volumn level
		db		ATTR_ARCHIVE											; +11:属性
		db		0x00													; +12:（保留）
		db		0x00													; +13:TS
		dw		( 0 << 11) | ( 0 << 5) | (0 / 2)						; +14:生成的时间
		dw		( 0 <<  9) | ( 1 << 5) | ( 1)							; +16:生成的日期
		dw		( 0 <<  9) | ( 1 << 5) | ( 1)							; +18:访问日
		dw		0x0000													; +20:（保留）
		dw		( 0 << 11) | ( 0 << 5) | (0 / 2)						; +22:更新时间
		dw		( 0 <<  9) | ( 1 << 5) | ( 1)							; +24:更新日
		dw		2														; +26:先头cluster
		dd		FILE.end - FILE											; +28:文件大小

;************************************************************************
;	FAT:数据领域的生成
;************************************************************************
		times FILE_START - ($ - $$)	db	0x00
;------------------------------------------------------------------------
FILE:	db		'hello, FAT!'
.end:	db		0

ALIGN 512, db 0x00


