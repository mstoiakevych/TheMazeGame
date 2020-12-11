.386
.model flat, stdcall  ;32 bit memory model
option casemap :none  ;case sensitive

include lab6.inc

include RADbg.inc

include gdi32.inc
includelib gdi32.lib

.code

start:

	invoke GetModuleHandle,NULL
	mov		hInstance,eax

    invoke InitCommonControls
	invoke DialogBoxParam,hInstance,IDD_DIALOG1,NULL,addr DlgProc,NULL
	invoke ExitProcess,0

;########################################################################

draw proc
	
	invoke BitBlt,hdcControllerBitmap,0,0,600,500,hdcBitmap,0,0,MERGEPAINT
	invoke BitBlt,hdc,0,0,600,500,hdcControllerBitmap,0,0,SRCCOPY
	ret

draw endp

TimerRight proc
	
	mov eax, x2
	inc eax
	invoke GetPixel,hdc,eax,y2
	
	.if eax==0
		inc x1
		inc x2
		invoke Rectangle,hdcControllerBitmap,x1,y1,x2,y2
	.endif
	
	
	ret

TimerRight endp

TimerLeft proc
	
	mov eax, x1
	dec eax
	invoke GetPixel,hdc,eax,y2
	
	.if eax==0
		dec x1
		dec x2
		invoke Rectangle,hdcControllerBitmap,x1,y1,x2,y2
	.endif
	ret

TimerLeft endp

TimerDown proc
	
	mov eax, y2
	inc eax
	invoke GetPixel,hdc,x1,eax
	
	.if eax==0
		inc y1
		inc y2
		invoke Rectangle,hdcControllerBitmap,x1,y1,x2,y2
	.endif
	ret

TimerDown endp

TimerUp proc
	
	mov eax, y1
	dec eax
	invoke GetPixel,hdc,x1,eax
	
	.if eax==0
		dec y1
		dec y2
		invoke Rectangle,hdcControllerBitmap,x1,y1,x2,y2
	.endif
	ret

TimerUp endp


DlgProc proc hWin:HWND,uMsg:UINT,wParam:WPARAM,lParam:LPARAM
	mov		eax,uMsg
	.if eax==WM_INITDIALOG
		invoke GetDC,hWin
		mov hdc, eax
	
		; Create maze
		invoke CreateCompatibleDC, hdc
		mov hdcBitmap, eax
		invoke LoadBitmap,hInstance,MAZEBIN
		mov hBitmap, eax
		invoke SelectObject,hdcBitmap,hBitmap 
		invoke DeleteObject, eax
		
		invoke CreateCompatibleDC, hdc
		mov hdcControllerBitmap, eax
		invoke CreateCompatibleBitmap,hdcBitmap,600,500
		mov hControllerBitmap, eax
		invoke SelectObject,hdcControllerBitmap,hControllerBitmap
		invoke DeleteObject, eax
		
		invoke SetTimer,hWin,12,10,addr draw
		
	.elseif eax==WM_COMMAND
	
	.elseif eax==WM_KEYDOWN
		mov		eax,lParam
		shr		eax,16
		and		eax,7FFFh
		.if eax==32
			;Right
			invoke SetTimer,hWin,TIMER_RIGHT,10,addr TimerRight
		.elseif eax==30
			;Left
			invoke SetTimer,hWin,TIMER_LEFT,10,addr TimerLeft
		.elseif eax==31
			;Down
			invoke SetTimer,hWin,TIMER_DOWN,10,addr TimerDown
		.elseif eax==17
			;Up
			invoke SetTimer,hWin,TIMER_UP,10,addr TimerUp

		.endif
	.elseif eax==WM_KEYUP
		mov		eax,wParam
		
		.if eax==68
			;Right
			invoke KillTimer,hWin,TIMER_RIGHT
		.elseif eax==65
			;Left
			invoke KillTimer,hWin,TIMER_LEFT
		.elseif eax==83
			;Down
			invoke KillTimer,hWin,TIMER_DOWN
		.elseif eax==87
			;Up
			invoke KillTimer,hWin,TIMER_UP
		.endif
		
		.if x2>560 && y1>380
			invoke MessageBox,0,addr endTitle, addr endTitle, MB_OK
			invoke SendMessage,hWin,WM_CLOSE,0,0
			;560,380      560,400
		.endif
	.elseif eax==WM_CLOSE
		invoke DeleteObject,hBitmap
		invoke DeleteDC,hdcBitmap
		invoke DeleteObject,hControllerBitmap
		invoke DeleteDC,hdcControllerBitmap
		invoke ReleaseDC,hWin,hdc
		invoke EndDialog,hWin,0
	.else
		mov		eax,FALSE
		ret
	.endif
	mov		eax,TRUE
	ret

DlgProc endp

end start
