#SingleInstance Force
#NoEnv
SetBatchLines -1
Global WinTitle := "BlueStacks"																	;; 模擬器視窗名稱
Global Width := 1920, Height := 1080															;; 模擬器尺寸，單位:pixel
Global CancelTime := 3000																		;; 熱鍵取消施放時長，單位：ms
Global Zero := 0																				;; 常數0
Global X := 1200, Y := 800																		;; 指定位置，單位:pixel
Global currentX := 960, currentY := 540															;; 當前鼠標位置，單位:pixel
Global Developer := false																		;; 是否啟用開發人員模式
Global Canceled := false																		;; 是否取消施放當前的熱鍵
Global Toggle := false																			;; 是否暫停所有熱鍵
Global ExitLoop := false																		;; 是否退出迴圈
Global Flag := ""																				;; 當前狀態 Flag
$^!H::																							;; ctrl+alt+H 顯示操作列表10秒
	Key := "H"
	Gosub, CanceledReset
	SetTimer, Cancel, %CancelTime%
	KeyWait, %Key%, %CancelTime%
	SetTimer, Cancel, delete
	if (!Canceled) {																			;; 正常施放
		ToolTip, 1.   ctrl + alt + H`t: Display the operation list 10 seconds`n2.   ctrl + alt + D`t: Turn developer mode on / off`n3.   ctrl + alt + T`t: Suspend / Restart all hotkeys except itself`n4.   ctrl + alt + R`t: Reload program`n5.   ctrl + alt + L`t: Exit program`nThe following operations can only be performed in developer mode : `n6.   ctrl + alt + M`t: Move the mouse to the specified position`n7.   ctrl + alt + G`t: Get the current values of each variable`n8.   ctrl + alt + C`t: Query the color code of the specified position`nThe following operations can only be performed on the simulator : `n9.   P`t`t`t: Pause the game at beginning`n10. K`t`t`t: Pause the game after it goes about 1 frame`n11. H`t`t`t: Click the operator or props by current mouse position while game paused`n12. M`t`t`t: Deploy the operator or props by current mouse position while game paused
		SetTimer, ToolTipReset, 10000
	}
	return
$^!D::																							;; ctrl+alt+D 開發人員模式
	Key := "D"
	Gosub, CanceledReset
	SetTimer, Cancel, %CancelTime%
	KeyWait, %Key%, %CancelTime%
	SetTimer, Cancel, delete
	if (!Canceled) {																			;; 正常施放
		Developer := !Developer
		if (Developer)																			;; 啟用開發人員模式
			ToolTip, Developer mode on!
		if (!Developer)																			;; 關閉開發人員模式
			ToolTip, Developer mode off!
		SetTimer, ToolTipReset, 2000
	}
	return
$^!T::																							;; ctrl+alt+P 暫停 / 重啟熱鍵
	Key := "T"
	Gosub, CanceledReset
	SetTimer, Cancel, %CancelTime%
	KeyWait, %Key%, %CancelTime%
	SetTimer, Cancel, delete
	if (!Canceled) {																			;; 正常施放
		Toggle := !Toggle
		if (Toggle) {																			;; 暫停除自身外的所有 Hotkey
			ToolTip, Hotkey suspend!
			Hotkey, ^!H, off
			Hotkey, ^!D, off
			Hotkey, ^!R, off
			Hotkey, ^!L, off
		} else {																				;; 恢復所有 Hotkey
			ToolTip, Hotkey enable!
			Hotkey, ^!H, on
			Hotkey, ^!D, on
			Hotkey, ^!R, on
			Hotkey, ^!L, on
		}
		SetTimer, ToolTipReset, 2000
	}
	return
$^!R::																							;; ctrl+alt+R 重啟程式
	Key := "R"
	Gosub, CanceledReset
	SetTimer, Cancel, %CancelTime%
	KeyWait, %Key%, %CancelTime%
	SetTimer, Cancel, delete
	if (!Canceled) {																			;; 正常施放
		ToolTip, Restarting app ...
		Sleep, 500
		Gosub, ToolTipReset
		Reload
	}
	return
$^!L::																							;; ctrl+alt+L 結束程式
	Key := "L"
	Gosub, CanceledReset
	SetTimer, Cancel, %CancelTime%
	KeyWait, %Key%, %CancelTime%
	SetTimer, Cancel, delete
	if (!Canceled) {																			;; 正常施放
		ToolTip, Exiting app...
		Sleep, 500
		Gosub, ToolTipReset
		ExitApp
	}
	return
#If (!Toggle && Developer)
	$^!M::																						;; ctrl+alt+M 鼠標移至指定座標
		Key := "M"
		targetX := X, targetY := Y
		Gosub, CanceledReset
		SetTimer, Cancel, %CancelTime%
		KeyWait, M, %CancelTime%
		SetTimer, Cancel, delete
		if (!Canceled)																			;; 正常施放
			MouseMove, %targetX%, %targetY%, 0
		return
	$^!G::																						;; ctrl+alt+G 取得當前各變數值
		Key := "G"
		Gosub, CanceledReset
		SetTimer, Cancel, %CancelTime%
		KeyWait, %Key%, %CancelTime%
		SetTimer, Cancel, delete
		if (!Canceled) {																		;; 正常施放
			ToolTip, Toggle : "%Toggle%"`nDeveloper : "%Developer%"`nCanceled : "%Canceled%"`nExitLoop : "%ExitLoop%"`nFlag : "%Flag%"
			SetTimer, ToolTipReset, 5000
		}
		return
	$^!C::																						;; ctrl+alt+C 指定位置的色碼查詢
		Key := "C"
		Gosub, CanceledReset
		SetTimer, Cancel, %CancelTime%
		KeyWait, %Key%, %CancelTime%
		SetTimer, Cancel, delete
		if (!Canceled) {																		;; 正常施放
			Color1 := "0xFFFFFF", Color2 := "0xF5F5F5"												;; 指定檢查顏色
			PixelGetColor, ColorP1, 1645, 80, %WinID%												;; 倍速 數字
			PixelGetColor, ColorP2, 1645, 110, %WinID%												;; 倍速 三角
			PixelGetColor, ColorP3, 1780, 65														;; 暫停 左上
			PixelGetColor, ColorP4, 1810, 65														;; 暫停 右上
			if ((ColorP1 != Color1 && ColorP2 != Color1) || (ColorP1 != Color2 && ColorP2 != Color2))
				Flag := "2X"
			if ((ColorP1 = Color1 && ColorP2 = Color1) || (ColorP1 = Color2 && ColorP2 = Color2))
				Flag := "1X"
			MouseGetPos, currentX, currentY
			PixelGetColor, ColorCurrent, %currentX%, %currentY%
			PixelGetColor, ColorSpecified, %X%, %Y%
			ToolTip, Current is "%ColorCurrent%"`nSpecified is "%ColorSpecified%"`nColorP1 is "%ColorP1%"`nColorP2 is "%ColorP2%"`nColorP3 is "%ColorP3%"`nColorP4 is "%ColorP4%"`nColorP5 is "%ColorP5%"`nColorP6 is "%ColorP6%"`nFlag is "%Flag%"
			SetTimer, ToolTipReset, 5000
		}
		return
#If
#If (!Toggle && WinActive(WinTitle))
	$K::																						;; K 遊戲行進約1幀後暫停
		Gosub, isInBattle
		if (Flag = "Resume") {																	;; 暫停遊戲
			SendEvent, {Esc}
			Sleep, 300
		}
		Key := "K"
		targetX := 1700, targetY := 70
		ExitLoop := false
		Gosub, CanceledReset
		SetTimer, Cancel, %CancelTime%
		SetKeyDelay, 0
		SetMouseDelay, 0
		KeyWait, %Key%, %CancelTime%
		SetTimer, Cancel, delete
		if (!Canceled) {																		;; 正常施放
			Gosub, Times
			if (Flag = "2X") {
				MouseGetPos, currentX, currentY
				mouseMove, %Width%, %Zero%, 0
				SendEvent, {Click %Width% %Zero%}
				mouseMove, %targetX%, %targetY%, 0
				SendEvent, {Click %targetX% %targetY%}
				mouseMove, %currentX%, %currentY%, 0
			}
			freq := 0, start := 0, end := 0
			DllCall("QueryPerformanceFrequency", "Int64 *", freq)
			SendEvent, {Space Down}
			DllCall("QueryPerformanceCounter", "Int64 *", start)
			SendEvent, {Space Up}
			Loop {
				DllCall("QueryPerformanceCounter", "Int64 *", end)
				if (end - start > 399980)
					break
			}
			SendEvent, {Esc}
			Sleep, 300
		}
		SetKeyDelay, 10
		SetMouseDelay, 10
		return
	$P::																						;; P 開局暫停
		Key := "P"
		ExitLoop := false
		Gosub, CanceledReset
		SetTimer, Cancel, %CancelTime%
		SetKeyDelay, 0
		SetMouseDelay, 0
		KeyWait, %Key%, %CancelTime%
		SetTimer, Cancel, delete
		if (!Canceled) {																		;; 正常施放
			ToolTip, Script start...
			SetTimer, ToolTipReset, 1500
			SetTimer, ForceExitLoop, 20000
			Loop {
				SendEvent, {Esc}
				Gosub, isInBattle
				if (Flag = "Pause" || ExitLoop || Toggle || !WinActive(WinTitle))
					break
			}
			SetTimer, isInBattle, delete
			SetTimer, ForceExitLoop, delete
			ToolTip, Script end...
			SetTimer, ToolTipReset, 1500
		}
		SetKeyDelay, 10
		SetMouseDelay, 10
		return
	$H::																						;; H 暫停點選
		Gosub, isInBattle
		if (Flag = "Resume") {																	;; 暫停遊戲
			SendEvent, {Esc}
			Sleep, 300
		}
		Key := "H"
		Gosub, CanceledReset
		SetTimer, Cancel, %CancelTime%
		SetKeyDelay, 0
		SetMouseDelay, 0
		MouseGetPos, currentX, currentY
		KeyWait, %Key%, %CancelTime%
		SetTimer, Cancel, delete
		if (!Canceled) {																		;; 正常施放
			SendEvent, {Space Down}
			Sleep, 1
			MouseMove, %currentX%, %currentY%
			Sleep, 1
			SendEvent, {Click %currentX% %currentY% Down}
			Sleep, 1
			SendEvent, {Space UP}
			SendEvent, {Click %currentX% %currentY% Up}											;; 點擊欲選擇單位
			SendEvent, {Esc Down}
			Sleep, 1
			SendEvent, {Esc Up}
			Sleep, 300
		}
		SetKeyDelay, 10
		SetMouseDelay, 10
		return
	$M::																						;; M 暫停部署
		Gosub, isInBattle
		if (Flag = "Resume") {																	;; 暫停遊戲
			SendEvent, {Esc}
			Sleep, 300
		}
		Key := "M"
		Gosub, CanceledReset
		SetTimer, Cancel, %CancelTime%
		SetKeyDelay, 0
		SetMouseDelay, 0
		MouseGetPos, currentX, currentY
		KeyWait, %Key%, %CancelTime%
		SetTimer, Cancel, delete
		if (!Canceled) {																		;; 正常施放
			SendEvent, {Space Down}
			Sleep, 1
			MouseMove, %currentX%, %currentY%
			Sleep, 1
			SendEvent, {Click %currentX% %currentY% Down}										;; 按住欲部署單位
			Sleep, 1
			SendEvent, {Space Up}
			mouseMove, 0, -10, 0, R																;; 拖動欲部署單位
			SendEvent, {Esc Down}
			Sleep, 1
			SendEvent, {Esc Up}
			Sleep, 1
			mouseMove, 1200, 800, 0
			Sleep, 300
		}
		SetKeyDelay, 10
		SetMouseDelay, 10
		return
	isInBattle:																					;; 關卡是否已開始
		Gosub, FlagReset
		Color1 := "0xFFFFFF", Color2 := "0xF5F5F5"												;; 指定檢查顏色
		PixelGetColor, ColorP1, 1780, 65														;; 暫停 左上
		PixelGetColor, ColorP2, 1810, 65														;; 暫停 右上
		if ((ColorP1 = Color1 || ColorP1 = Color2) && ColorP2 != Color1 && ColorP2 != Color2)
			Flag := "Pause"
		if ((ColorP1 = Color1 || ColorP1 = Color2) && (ColorP2 = Color1 || ColorP2 = Color2))
			Flag := "Resume"
		return
	Times:
		Gosub, FlagReset
		Color1 := "0xFFFFFF", Color2 := "0xF5F5F5"												;; 指定檢查顏色
		PixelGetColor, ColorP1, 1645, 80, %WinID%												;; 倍速 數字
		PixelGetColor, ColorP2, 1645, 110, %WinID%												;; 倍速 三角
		if ((ColorP1 != Color1 && ColorP2 != Color1) || (ColorP1 != Color2 && ColorP2 != Color2))
			Flag := "2X"
		if ((ColorP1 = Color1 && ColorP2 = Color1) || (ColorP1 = Color2 && ColorP2 = Color2))
			Flag := "1X"
		return
	ForceExitLoop:
		ExitLoop := true
		return
#If
CanceledReset:
	Canceled := false
	return
FlagReset:
	Flag := ""
	return
ToolTipReset:
	SetTimer, ToolTipReset, delete
	ToolTip
	return
Cancel:
	Canceled := true
	SetTimer, Cancel, delete
	ToolTip, Canceled!
	SetTimer, ToolTipReset, 1000
	return