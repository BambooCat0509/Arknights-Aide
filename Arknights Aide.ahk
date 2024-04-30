;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Operation list : Press 1.5s to cancel the operating						;;
;; ctrl + alt + H : Display the operation list 10 seconds					;;
;; ctrl + alt + R : Reload program											;;
;; ctrl + alt + L : Exit program											;;
;; ctrl + alt + M : Move the mouse to the specified position				;;
;; ctrl + alt + C : Query the color code of the specified position			;;
;; The following operations can only be performed on the simulator :		;;
;; P : Pause the game when begin											;;
;; H : Click the operator or props with current mouse position when pause	;;
;; M : Deploy the operator or props with current mouse position when pause	;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; 操作列表：(長按1.5秒可以取消操作)				;;
;; ctrl + alt + H : 呼叫操作列表顯示10秒			;;
;; ctrl + alt + R : 重啟程式						;;
;; ctrl + alt + L : 結束程式						;;
;; ctrl + alt + M : 鼠標移至指定座標				;;
;; ctrl + alt + C : 指定位置的色碼查詢				;;
;; 以下操作僅能在模擬器視窗執行：					;;
;; P : 開局暫停										;;
;; H : 暫停點選當前鼠標位置的幹員或道具				;;
;; M : 暫停部署當前鼠標位置的幹員或道具(划火柴)		;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

#Persistent
Global Canceled := false
Global WinTitle := "BlueStacks"											;; 模擬器視窗名稱
Global CancelTime := 1500												;; 熱鍵取消施放時長，單位：ms
Global X := 960															;; 指定位置
Global Y := 540															;; 指定位置
Global Flag := ""

^!H::																	;; ctrl+alt+H 顯示操作列表10秒
	Gosub, CanceledReset
	SetTimer, Cancel, %CancelTime%
	KeyWait, H, %CancelTime%
	SetTimer, Cancel, Off
	if (!Canceled) {
		Gosub, CanceledReset
		ToolTip, 1.   ctrl + alt + H`t: Display the operation list 10 seconds`n2.   ctrl + alt + R`t: Reload program`n3.   ctrl + alt + L`t: Exit program`n4.   ctrl + alt + M`t: Move the mouse to the specified position`n5.   ctrl + alt + C`t: Query the color code of the specified position`nThe following operations can only be performed on the simulator : `n6.   P`t: Pause the game when begin`n7.   H`t: Click the operator or props with current mouse position when pause`n8.   M`t: Deploy the operator or props with current mouse position when pause
		SetTimer, ToolTipReset, 10000
	}
	return

^!C::																	;; ctrl+alt+C 指定位置的色碼查詢
	Gosub, CanceledReset
	SetTimer, Cancel, %CancelTime%
	KeyWait, C, %CancelTime%
	SetTimer, Cancel, Off
	if (!Canceled) {													;; 取消施放
		Gosub, CanceledReset
		Color1 := "0xFFFFFF"											;; 指定檢查顏色(白1)
		Color2 := "0xF5F5F5"											;; 指定檢查顏色(白2)
		PixelGetColor, ColorP1, 1625, 50								;; 倍速 數字
		PixelGetColor, ColorP2, 1810, 60								;; 暫停 右上
		if (ColorP1 = Color1 && ColorP2 != Color1 && ColorP2 != Color2)
			Flag := "Pause1X"
		MouseGetPos, mouseX, mouseY
		PixelGetColor, Color, %mouseX%, %mouseY%
		PixelGetColor, ColorS, %X%, %Y%
		ToolTip, Current is "%Color%"`nSpecified is "%ColorS%"`nColorP1 is "%ColorP1%"`nColorP2 is "%ColorP2%"`nColorP3 is "%ColorP3%"`nColorP4 is "%ColorP4%"`nColorP5 is "%ColorP5%"`nColorP6 is "%ColorP6%"`nFlag is "%Flag%"
		SetTimer, ToolTipReset, 5000
	}
	return

^!M::																	;; ctrl+alt+M 鼠標移至指定座標
	Gosub, CanceledReset
	SetTimer, Cancel, %CancelTime%
	KeyWait, M, %CancelTime%
	SetTimer, Cancel, Off
	if (!Canceled) {													;; 取消施放
		Gosub, CanceledReset
		MouseMove, 1625, 50, 0
	}
	return

^!R::																	;; ctrl+alt+R 重啟程式
	Gosub, CanceledReset
	SetTimer, Cancel, %CancelTime%
	KeyWait, R, %CancelTime%
	SetTimer, Cancel, Off
	if (!Canceled) {													;; 取消施放
		Gosub, CanceledReset
		Reload
	}
	return

^!L::																	;; ctrl+alt+L 結束程式
	Gosub, CanceledReset
	SetTimer, Cancel, %CancelTime%
	KeyWait, L, %CancelTime%
	SetTimer, Cancel, Off
	if (!Canceled) {													;; 取消施放
		Gosub, CanceledReset
		ExitApp
	}
	return
	
#If WinActive(WinTitle)
P::																		;; P 開局暫停
	Gosub, CanceledReset
	SetTimer, Cancel, %CancelTime%
	KeyWait, P, %CancelTime%
	SetTimer, Cancel, Off
	if (!Canceled) {													;; 取消施放
		Gosub, CanceledReset
		ToolTip, Script start...
		SetTimer, ToolTipReset, 2000
		SetTimer, isInBattle, 0
		Loop {
			if (Flag = "Pause1X")
				break
			SendEvent, {esc}
		}
		SetTimer, isInBattle, Delete
		ToolTip, Script end...
		SetTimer, ToolTipReset, 2000
		Gosub, FlagReset
	}
	return

H::																		;; H 暫停點選
	Gosub, CanceledReset
	SetTimer, Cancel, %CancelTime%
	KeyWait, H, %CancelTime%
	SetTimer, Cancel, Off
	if (!Canceled) {													;; 取消施放
		Gosub, CanceledReset
		SetKeyDelay, 0
		SetMouseDelay, 0
		SendEvent, {Space Down}
		Sleep, 1
		SendEvent, {LButton Down}
		Sleep, 1
		SendEvent, {Space UP}
		SendEvent, {LButton Up}
		SendEvent, {Esc Up}
		Sleep, 1
		SendEvent, {Esc Down}
		SetKeyDelay, 10
		SetMouseDelay, 10
	}
	return

M::																		;; M 暫停部署
	Gosub, CanceledReset
	SetTimer, Cancel, %CancelTime%
	KeyWait, M, %CancelTime%
	SetTimer, Cancel, Off
	if (!Canceled) {													;; 取消施放
		Gosub, CanceledReset
		SetKeyDelay, 0
		SetMouseDelay, 0
		SendEvent, {Space Down}
		Sleep, 1
		SendEvent, {LButton Down}
		Sleep, 1
		SendEvent, {Space UP}
		mouseMove, -5, -5, , R
		SendEvent, {Esc Up}
		Sleep, 1
		SendEvent, {Esc Down}
		Sleep, 1
		SetKeyDelay, 10
		SetMouseDelay, 10
		mouseMove, 1200, 800, 0
	}
	return
#If

isInBattle:																;; 關卡是否已開始
	Color1 := "0xFFFFFF"												;; 指定檢查顏色(白1)
	Color2 := "0xF5F5F5"												;; 指定檢查顏色(白2)
	PixelGetColor, ColorP1, 1625, 50									;; 倍速 數字
	PixelGetColor, ColorP2, 1810, 60									;; 暫停 右上
	if (ColorP1 = Color1 && ColorP2 != Color1 && ColorP2 != Color2)
		Flag := "Pause1X"
	return

Cancel:
	Canceled := true
	SetTimer, Cancel, Off
	ToolTip, Canceled!
	SetTimer, ToolTipReset, 1000
	return

CanceledReset:
	Canceled := false
	return

FlagReset:
	Flag := ""
	return

ToolTipReset:
	ToolTip
	return
