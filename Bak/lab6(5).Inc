
include windows.inc
include kernel32.inc
include user32.inc
include Comctl32.inc
include shell32.inc

includelib kernel32.lib
includelib user32.lib
includelib Comctl32.lib
includelib shell32.lib

DlgProc			PROTO	:HWND,:UINT,:WPARAM,:LPARAM

.const

IDD_DIALOG1			equ 101
START_GAME			equ 1001

TIMER_LEFT			equ 1111
TIMER_RIGHT			equ 1112
TIMER_UP			equ 1113
TIMER_DOWN			equ 1114

MAZEBM				equ 10001
;#########################################################################

.data
	hdc dd 0
	hdcBitmap dd 0
	hBitmap dd 0
	
	hdcControllerBitmap dd 0
	hControllerBitmap dd 0
	
	;mazeImage db 'E:\Programs\ASM\ASM\Masm\Projects\lab6\Res\maze.bmp',0
	
	x1 dd 10
	x2 dd 20
	y1 dd 90
	y2 dd 100

.data?

hInstance			dd ?

;#########################################################################
