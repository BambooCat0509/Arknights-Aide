#SingleInstance Force
#NoEnv
SetBatchLines -1
Global WinTitle := "BlueStacks"																	;; 模擬器視窗名稱
Global Width := 1920, Height := 1080															;; 螢幕尺寸，單位：pixel
Global CancelTime := 1500																		;; 熱鍵取消施放時長，單位：ms
Global FrameTime := 39.998																		;; 遊戲內一幀的時長，單位：ms
Global X := 1200, Y := 800																		;; 指定位置，單位：pixel
Global KeycaH := true, KeycaD := true, KeycaR := true, KeycaL := true, KeycaM := false			;; 各熱鍵是否啟用
Global KeycaG := false, KeycaC := false, KeyR := true, KeyS := true, KeyE := true				;; 各熱鍵是否啟用
Global KeySpace := true, KeyA := true, KeyF := true, KeyD := true, KeyP := true					;; 各熱鍵是否啟用
Global KeyK := true, KeyH := true, KeyM := true, KeyasS := true									;; 各熱鍵是否啟用
Global StdWidth := 1920, StdHeight := 1080														;; 標準長寬，單位：pixel
Global RX := 90, RY := 80, SX := 1727, SY := 983, EX := 1600, EY := 900, SpaceX := 1860			;; 各熱鍵點擊座標，單位：pixel
Global SpaceY := 119, AX := 1600, AY := 70, FX := 1225, FY := 665, DX := 850, DY := 323			;; 各熱鍵點擊座標，單位：pixel
Global currentX := 960, currentY := 540															;; 當前鼠標位置，單位：pixel
Global Developer := false																		;; 是否啟用開發人員模式
Global Canceled := false																		;; 是否取消施放當前的熱鍵
Global ScriptAFK := false																		;; 是否啟用 ScriptAFK
Global Toggle := false																			;; 是否暫停所有熱鍵
Global ExitLoop := false																		;; 是否退出迴圈
Global Flag := ""																				;; 當前狀態 Flag
Configration()																					;; 讀取 config 檔案

$^!H::																							;; ctrl+alt+H 顯示操作列表10秒
	if (!KeycaH)
		return
	Key := "H"
	Gosub, CanceledReset
	SetTimer, Cancel, % CancelTime
	KeyWait, % Key, % CancelTime
	SetTimer, Cancel, delete
	if (!Canceled) {																			;; 正常施放
		ToolTip, 1.   ctrl+alt+H`t: Display the operation list 10 seconds`n2.   ctrl+alt+D`t: Turn developer mode on / off`n3.   ctrl+alt+T`t: Suspend / Restart all hotkeys except itself`n4.   ctrl+alt+R`t: Reload program`n5.   ctrl+alt+L`t: Exit program`nThe following operations can only be performed in developer mode : `n6.   ctrl+alt+M`t: Move the mouse to the specified position`n7.   ctrl+alt+G`t: Get the current values of each variable`n8.   ctrl+alt+C`t: Query the color code of the specified position`nThe following operations can only be performed on the simulator(Full Screen1920*1080) : `n9.   R`t`t: Return / Setting`n10. E`t`t: Auto deploy / Exit Mission`n11. S`t`t: Mission start / Confirm`n12. Space`t: Pause / Resume game`n13. A`t`t: Speed changing`n14. F`t`t: Turn skill on / off`n15. D`t`t: Retreat operators / props`n16. P`t`t: Pause the game at beginning`n17. K`t`t: Pause the game after it goes about 1 frame`n18. H`t`t: Click the operator or props by current mouse position while game paused`n19. M`t`t: Deploy the operator or props by current mouse position while game paused`n20. alt+shift+S`t: Start / Stop cleaning up the action points with specified level(AFK)
		SetTimer, ToolTipReset, 10000
	}
	return
$^!D::																							;; ctrl+alt+D 開發人員模式
	if (!KeycaD)
		return
	Key := "D"
	Gosub, CanceledReset
	SetTimer, Cancel, % CancelTime
	KeyWait, % Key, % CancelTime
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
	SetTimer, Cancel, % CancelTime
	KeyWait, % Key, % CancelTime
	SetTimer, Cancel, delete
	if (!Canceled) {																			;; 正常施放
		Toggle := !Toggle
		if (Toggle) {																			;; 暫停除自身外的所有 hotkey
			ToolTip, Hotkey suspend!
			KeycaH := false, KeycaD := false, KeycaR := false, KeycaL := false
			KeycaM := false, KeycaG := false, KeycaC := false, KeyR := false, KeyS := false
			KeyE := false, KeySpace := false, KeyA := false, KeyF := false, KeyD := false
			KeyP := false, KeyK := false, KeyH := false, KeyM := false, KeyasS := false
		} else {																				;; 恢復所有 hotkey
			ToolTip, Hotkey enable!
			Configration()
		}
		SetTimer, ToolTipReset, 2000
	}
	return
$^!R::																							;; ctrl+alt+R 重啟程式
	if (!KeycaR)
		return
	Key := "R"
	Gosub, CanceledReset
	SetTimer, Cancel, % CancelTime
	KeyWait, % Key, % CancelTime
	SetTimer, Cancel, delete
	if (!Canceled) {																			;; 正常施放
		ToolTip, Restarting app ...
		Sleep, 500
		Gosub, ToolTipReset
		Reload
	}
	return
$^!L::																							;; ctrl+alt+L 結束程式
	if (!KeycaL)
		return
	Key := "L"
	Gosub, CanceledReset
	SetTimer, Cancel, % CancelTime
	KeyWait, % Key, % CancelTime
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
		if (!KeycaM)
			return
		Key := "M"
		targetX := X*Width/StdWidth, targetY := Y*Height/StdHeight
		Gosub, CanceledReset
		SetTimer, Cancel, % CancelTime
		KeyWait, % Key, % CancelTime
		SetTimer, Cancel, delete
		if (!Canceled)																			;; 正常施放
			MouseMove, % targetX, % targetY, 0
		return
	$^!G::																						;; ctrl+alt+G 取得當前各變數值
		if (!KeycaG)
			return
		Key := "G"
		Gosub, CanceledReset
		SetTimer, Cancel, % CancelTime
		KeyWait, % Key, % CancelTime
		SetTimer, Cancel, delete
		if (!Canceled) {																		;; 正常施放
			ToolTip, True : 1`, False : 0`nToggle : "%Toggle%"`nDeveloper : "%Developer%"`nCanceled : "%Canceled%"`nExitLoop : "%ExitLoop%"`nScriptAFK : "%ScriptAFK%"`nFlag : "%Flag%"`nKeycaH : "%KeycaH%"`nKeycaD : "%KeycaD%"`nKeycaR : "%KeycaR%"`nKeycaL : "%KeycaL%"`nKeycaM : "%KeycaM%"`nKeycaG : "%KeycaG%"`nKeycaC : "%KeycaC%"`nKeyR : "%KeyR%"`nKeyS : "%KeyS%"`nKeyE : "%KeyE%"`nKeySpace : "%KeySpace%"`nKeyA : "%KeyA%"`nKeyF : "%KeyF%"`nKeyD : "%KeyD%"`nKeyP : "%KeyP%"`nKeyK : "%KeyK%"`nKeyH : "%KeyH%"`nKeyM : "%KeyM%"`nKeyasS : "%KeyasS%"
			SetTimer, ToolTipReset, 5000
		}
		return
	$^!C::																						;; ctrl+alt+C 指定位置的色碼查詢
		if (!KeycaC)
			return
		Key := "C"
		Gosub, CanceledReset
		SetTimer, Cancel, % CancelTime
		KeyWait, % Key, % CancelTime
		SetTimer, Cancel, delete
		if (!Canceled) {																		;; 正常施放
			Color1 := "0xFFFFFF", Color2 := "0xF5F5F5"												;; 指定檢查顏色
			PixelGetColor, ColorP1, % 1645*Width/StdWidth, % 80*Height/StdHeight					;; 倍速 數字
			PixelGetColor, ColorP2, % 1645*Width/StdWidth, % 110*Height/StdHeight					;; 倍速 三角
			PixelGetColor, ColorP3, % 1780*Width/StdWidth, % 65*Height/StdHeight					;; 暫停 左上
			PixelGetColor, ColorP4, % 1810*Width/StdWidth, % 65*Height/StdHeight					;; 暫停 右上
			if ((ColorP1 != Color1 && ColorP2 != Color1) || (ColorP1 != Color2 && ColorP2 != Color2))
				Flag := "2X"
			if ((ColorP1 = Color1 && ColorP2 = Color1) || (ColorP1 = Color2 && ColorP2 = Color2))
				Flag := "1X"
			if ((ColorP3 = Color1 || ColorP3 = Color2) && ColorP4 != Color1 && ColorP4 != Color2)
				Flag := "Pause"
			if ((ColorP3 = Color1 || ColorP3 = Color2) && (ColorP4 = Color1 || ColorP4 = Color2))
				Flag := "Resume"
			MouseGetPos, currentX, currentY
			PixelGetColor, ColorCurrent, % currentX, % currentY
			PixelGetColor, ColorSpecified, % X, % Y
			ToolTip, Current is "%ColorCurrent%"`nSpecified is "%ColorSpecified%"`nColorP1 is "%ColorP1%"`nColorP2 is "%ColorP2%"`nColorP3 is "%ColorP3%"`nColorP4 is "%ColorP4%"`nColorP5 is "%ColorP5%"`nColorP6 is "%ColorP6%"`nFlag is "%Flag%"
			SetTimer, ToolTipReset, 5000
		}
		return
#If

#If (!Toggle && WinActive(WinTitle))
	SetTimer, ScriptAFK, 0
	Key := "", targetX := X, targetY := Y
	$R::																						;; R 返回上頁 / 設定
		if (!KeyR)
			return
		Key := "R"
		targetX := RX*Width/StdWidth, targetY := RY*Height/StdHeight
		Gosub, CanceledReset
		SetTimer, Cancel, % CancelTime
		SetKeyDelay, 0
		SetMouseDelay, 0
		MouseGetPos, currentX, currentY
		MouseMove, % targetX, % targetY, 0
		SendEvent, {Click %targetX% %targetY% Down}
		MouseMove, % currentX, % currentY, 0
		KeyWait, % Key, % CancelTime
		SetTimer, Cancel, delete
		if (Canceled) {																			;; 取消施放
			MouseGetPos, currentX, currentY
			SendEvent, {Click %currentX% %currentY% Up}
		} else {																				;; 正常施放
			MouseGetPos, currentX, currentY
			MouseMove, % targetX, % targetY, 0
			SendEvent, {Click %targetX% %targetY% Up}
			MouseMove, % currentX, % currentY, 0
		}
		SetKeyDelay, 10
		SetMouseDelay, 10
		return
	$S::																						;; S 開始行動 / 確認
		if (!KeyS)
			return
		Key := "S"
		targetX := SX*Width/StdWidth, targetY := SY*Height/StdHeight
		Gosub, CanceledReset
		SetTimer, Cancel, % CancelTime
		SetKeyDelay, 0
		SetMouseDelay, 0
		MouseGetPos, currentX, currentY
		MouseMove, % targetX, % targetY, 0
		SendEvent, {Click %targetX% %targetY% Down}
		MouseMove, % currentX, % currentY, 0
		KeyWait, % Key, % CancelTime
		SetTimer, Cancel, delete
		if (Canceled) {																			;; 取消施放
			MouseGetPos, currentX, currentY
			SendEvent, {Click %currentX% %currentY% Up}
		} else {																				;; 正常施放
			MouseGetPos, currentX, currentY
			MouseMove, % targetX, % targetY, 0
			SendEvent, {Click %targetX% %targetY% Up}
			MouseMove, % currentX, % currentY, 0
		}
		SetKeyDelay, 10
		SetMouseDelay, 10
		return
	$E::																						;; E 代理指揮 / 放棄行動
		if (!KeyE)
			return
		Key := "E"
		targetX := EX*Width/StdWidth, targetY := EY*Height/StdHeight
		Gosub, CanceledReset
		SetTimer, Cancel, % CancelTime
		SetKeyDelay, 0
		SetMouseDelay, 0
		MouseGetPos, currentX, currentY
		MouseMove, % targetX, % targetY, 0
		SendEvent, {Click %targetX% %targetY% Down}
		MouseMove, % currentX, % currentY, 0
		KeyWait, % Key, % CancelTime
		SetTimer, Cancel, delete
		if (Canceled) {																			;; 取消施放
			MouseGetPos, currentX, currentY
			SendEvent, {Click %currentX% %currentY% Up}
		} else {																				;; 正常施放
			MouseGetPos, currentX, currentY
			MouseMove, % targetX, % targetY, 0
			SendEvent, {Click %targetX% %targetY% Up}
			MouseMove, % currentX, % currentY, 0
		}
		SetKeyDelay, 10
		SetMouseDelay, 10
		return
	$Space::																					;; Space 暫停 / 繼續遊戲
		if (!KeySpace)
			return
		Key := "Space"
		targetX := SpaceX*Width/StdWidth, targetY := SpaceY*Height/StdHeight
		Gosub, CanceledReset
		SetTimer, Cancel, % CancelTime
		SetKeyDelay, 0
		SetMouseDelay, 0
		MouseGetPos, currentX, currentY
		MouseMove, % targetX, % targetY, 0
		SendEvent, {Click %targetX% %targetY% Down}
		MouseMove, % currentX, % currentY, 0
		KeyWait, % Key, % CancelTime
		SetTimer, Cancel, delete
		if (Canceled) {																			;; 取消施放
			MouseGetPos, currentX, currentY
			SendEvent, {Click %currentX% %currentY% Up}
		} else {																				;; 正常施放
			MouseGetPos, currentX, currentY
			MouseMove, % targetX, % targetY, 0
			SendEvent, {Click %targetX% %targetY% Up}
			MouseMove, % currentX, % currentY, 0
		}
		SetKeyDelay, 10
		SetMouseDelay, 10
		return
	$A::																						;; A 倍速調整
		if (!KeyA)
			return
		Key := "A"
		targetX := AX*Width/StdWidth, targetY := AY*Height/StdHeight
		Gosub, CanceledReset
		SetTimer, Cancel, % CancelTime
		SetKeyDelay, 0
		SetMouseDelay, 0
		MouseGetPos, currentX, currentY
		MouseMove, % targetX, % targetY, 0
		SendEvent, {Click %targetX% %targetY% Down}
		MouseMove, % currentX, % currentY, 0
		KeyWait, % Key, % CancelTime
		SetTimer, Cancel, delete
		if (Canceled) {																			;; 取消施放
			MouseGetPos, currentX, currentY
			SendEvent, {Click %currentX% %currentY% Up}
		} else {																				;; 正常施放
			MouseGetPos, currentX, currentY
			MouseMove, % targetX, % targetY, 0
			SendEvent, {Click %targetX% %targetY% Up}
			MouseMove, % currentX, % currentY, 0
		}
		SetKeyDelay, 10
		SetMouseDelay, 10
		return
	$F::																						;; F 施放技能
		if (!KeyF)
			return
		Key := "F"
		targetX := FX*Width/StdWidth, targetY := FY*Height/StdHeight
		Gosub, CanceledReset
		SetTimer, Cancel, % CancelTime
		SetKeyDelay, 0
		SetMouseDelay, 0
		MouseGetPos, currentX, currentY
		MouseMove, % targetX, % targetY, 0
		SendEvent, {Click %targetX% %targetY% Down}
		MouseMove, % currentX, % currentY, 0
		KeyWait, % Key, % CancelTime
		SetTimer, Cancel, delete
		if (Canceled) {																			;; 取消施放
			MouseGetPos, currentX, currentY
			SendEvent, {Click %currentX% %currentY% Up}
		} else {																				;; 正常施放
			MouseGetPos, currentX, currentY
			MouseMove, % targetX, % targetY, 0
			SendEvent, {Click %targetX% %targetY% Up}
			MouseMove, % currentX, % currentY, 0
		}
		SetKeyDelay, 10
		SetMouseDelay, 10
		return
	$D::																						;; D 撤退幹員 / 道具
		if (!KeyD)
			return
		Key := "D"
		targetX := DX*Width/StdWidth, targetY := DY*Height/StdHeight
		Gosub, CanceledReset
		SetTimer, Cancel, % CancelTime
		SetKeyDelay, 0
		SetMouseDelay, 0
		MouseGetPos, currentX, currentY
		MouseMove, % targetX, % targetY, 0
		SendEvent, {Click %targetX% %targetY% Down}
		MouseMove, % currentX, % currentY, 0
		KeyWait, % Key, % CancelTime
		SetTimer, Cancel, delete
		if (Canceled) {																			;; 取消施放
			MouseGetPos, currentX, currentY
			SendEvent, {Click %currentX% %currentY% Up}
		} else {																				;; 正常施放
			MouseGetPos, currentX, currentY
			MouseMove, % targetX, % targetY, 0
			SendEvent, {Click %targetX% %targetY% Up}
			MouseMove, % currentX, % currentY, 0
		}
		SetKeyDelay, 10
		SetMouseDelay, 10
		return
	$P::																						;; P 開局暫停
		if (!KeyP)
			return
		Key := "P"
		ExitLoop := false
		Gosub, CanceledReset
		SetTimer, Cancel, % CancelTime
		SetKeyDelay, 0
		SetMouseDelay, 0
		KeyWait, % Key, % CancelTime
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
	$K::																						;; K 遊戲行進約1幀後暫停
		if (!KeyK)
			return
		Gosub, isInBattle
		if (Flag = "Resume") {																	;; 暫停遊戲
			SendEvent, {Esc}
			Sleep, 300
		}
		Key := "K"
		targetX := AX*Width/StdWidth, targetY := AY*Height/StdHeight
		ExitLoop := false
		Gosub, CanceledReset
		SetTimer, Cancel, % CancelTime
		SetKeyDelay, 0
		SetMouseDelay, 0
		KeyWait, % Key, % CancelTime
		SetTimer, Cancel, delete
		if (!Canceled) {																		;; 正常施放
			Gosub, Times
			if (Flag = "2X") {
				MouseGetPos, currentX, currentY
				MouseMove, % targetX, % targetY, 0
				SendEvent, {Click %targetX% %targetY%}
				MouseMove, % currentX, % currentY, 0
			}
			freq := 0, start := 0, end := 0
			DllCall("QueryPerformanceFrequency", "Int64 *", freq)
			SendEvent, {Space Down}
			DllCall("QueryPerformanceCounter", "Int64 *", start)
			SendEvent, {Space Up}
			Loop {
				DllCall("QueryPerformanceCounter", "Int64 *", end)
				if ((end - start) / freq * 1000 > FrameTime)
					break
			}
			SendEvent, {Esc}
			Sleep, 300
		}
		SetKeyDelay, 10
		SetMouseDelay, 10
		return
	$H::																						;; H 暫停點選
		if (!KeyH)
			return
		Gosub, isInBattle
		if (Flag = "Resume") {																	;; 暫停遊戲
			SendEvent, {Esc}
			Sleep, 300
		}
		Key := "H"
		Gosub, CanceledReset
		SetTimer, Cancel, % CancelTime
		SetKeyDelay, 0
		SetMouseDelay, 0
		MouseGetPos, currentX, currentY
		KeyWait, % Key, % CancelTime
		SetTimer, Cancel, delete
		if (!Canceled) {																		;; 正常施放
			SendEvent, {Space Down}
			Sleep, 1
			MouseMove, % currentX, % currentY
			Sleep, 1
			SendEvent, {Click %currentX% %currentY% Down}
			Sleep, 1
			SendEvent, {Space UP}
			SendEvent, {Click %currentX% %currentY% Up}
			SendEvent, {Esc Down}
			Sleep, 1
			SendEvent, {Esc Up}
			Sleep, 300
		}
		SetKeyDelay, 10
		SetMouseDelay, 10
		return
	$M::																						;; M 暫停部署
		if (!KeyM)
			return
		Gosub, isInBattle
		if (Flag = "Resume") {																	;; 暫停遊戲
			SendEvent, {Esc}
			Sleep, 300
		}
		Key := "M"
		Gosub, CanceledReset
		SetTimer, Cancel, % CancelTime
		SetKeyDelay, 0
		SetMouseDelay, 0
		MouseGetPos, currentX, currentY
		KeyWait, % Key, % CancelTime
		SetTimer, Cancel, delete
		if (!Canceled) {																		;; 正常施放
			SendEvent, {Space Down}
			Sleep, 1
			MouseMove, % currentX, % currentY
			Sleep, 1
			SendEvent, {Click %currentX% %currentY% Down}
			Sleep, 1
			SendEvent, {Space Up}
			MouseMove, 0, -10, 0, R
			SendEvent, {Esc Down}
			Sleep, 1
			SendEvent, {Esc Up}
			Sleep, 1
			MouseMove, % 1200*Width/StdWidth, % 800*Height/StdHeight, 0
			Sleep, 300
		}
		SetKeyDelay, 10
		SetMouseDelay, 10
		return
	$!+S::																						;; 單一關卡掛機清體力
		if (!KeyasS)
			return
		Key := "S"
		Gosub, CanceledReset
		SetTimer, Cancel, % CancelTime
		KeyWait, % Key, % CancelTime
		SetTimer, Cancel, delete
		if (!Canceled) {																		;; 正常施放
			ScriptAFK := !ScriptAFK
			if (ScriptAFK) {
				SetTimer, ScriptAFK, 0
				ToolTip, Script "AFK" is now in progress!
			} else {
				SetTimer, ScriptAFK, delete
				ToolTip, Script "AFK" had end up!
			}
			SetTimer, ToolTipReset, 2000
		}
		return
	isInBattle:																					;; 關卡是否已開始
		Gosub, FlagReset
		Color1 := "0xFFFFFF", Color2 := "0xF5F5F5"												;; 指定檢查顏色
		PixelGetColor, ColorP1, % 1780*Width/StdWidth, % 65*Height/StdHeight					;; 暫停 左上
		PixelGetColor, ColorP2, % 1810*Width/StdWidth, % 65*Height/StdHeight					;; 暫停 右上
		if ((ColorP1 = Color1 || ColorP1 = Color2) && ColorP2 != Color1 && ColorP2 != Color2)
			Flag := "Pause"
		if ((ColorP1 = Color1 || ColorP1 = Color2) && (ColorP2 = Color1 || ColorP2 = Color2))
			Flag := "Resume"
		return
	Times:
		Gosub, FlagReset
		Color1 := "0xFFFFFF", Color2 := "0xF5F5F5"												;; 指定檢查顏色
		PixelGetColor, ColorP1, % 1645*Width/StdWidth, % 80*Height/StdHeight					;; 倍速 數字
		PixelGetColor, ColorP2, % 1645*Width/StdWidth, % 110*Height/StdHeight					;; 倍速 三角
		if ((ColorP1 != Color1 && ColorP2 != Color1) || (ColorP1 != Color2 && ColorP2 != Color2))
			Flag := "2X"
		if ((ColorP1 = Color1 && ColorP2 = Color1) || (ColorP1 = Color2 && ColorP2 = Color2))
			Flag := "1X"
		return
	ScriptAFK:																					;; 每隔5秒按5次S鍵
		if (!Toggle && ScriptAFK && WinActive(WinTitle)) {
			targetX := SX*Width/StdWidth, targetY := SY*Height/StdHeight
			MouseGetPos, currentX, currentY
			MouseMove, % targetX, % targetY, 0
			SendEvent, {Click %targetX% %targetY%}
			MouseMove, % currentX, % currentY, 0
			Sleep, 250
			MouseGetPos, currentX, currentY
			MouseMove, % targetX, % targetY, 0
			SendEvent, {Click %targetX% %targetY%}
			MouseMove, % currentX, % currentY, 0
			Sleep, 250
			MouseGetPos, currentX, currentY
			MouseMove, % targetX, % targetY, 0
			SendEvent, {Click %targetX% %targetY%}
			MouseMove, % currentX, % currentY, 0
			Sleep, 250
			MouseGetPos, currentX, currentY
			MouseMove, % targetX, % targetY, 0
			SendEvent, {Click %targetX% %targetY%}
			MouseMove, % currentX, % currentY, 0
			Sleep, 250
			MouseGetPos, currentX, currentY
			MouseMove, % targetX, % targetY, 0
			SendEvent, {Click %targetX% %targetY%}
			MouseMove, % currentX, % currentY, 0
			Sleep, 4000
			SetTimer, ScriptAFK, 0
		}
		return
	ForceExitLoop:
		ExitLoop := true
		return
	;SetTimer, ScriptAFK, delete
#If

Configration() {
	Loop {
		if (A_Index = 1, mod(A_Index, 2) = 0)
			continue
		FileReadLine, Line, %A_ScriptDir%\Arknights Aide.config, % A_Index
		if (ErrorLevel || (A_Index / 2 = 1 && (Line = "NO" || Line = "No" || Line = "no")))
			break
		if (Line = "")
			continue
		switch ((A_Index-1)/2) {
			case 1 : WinTitle := Line
			case 2 : Width := Line
			case 3 : Height := Line
			case 4 : X := Line
			case 5 : Y := Line
			case 6 : CancelTime := Line
			case 7 : FrameTime := Line
			case 8 : Developer := Line
			case 9 : KeycaH := Line
			case 10: KeycaD := Line
			case 11: KeycaR := Line
			case 12: KeycaL := Line
			case 13: KeycaM := Line
			case 14: KeycaG := Line
			case 15: KeycaC := Line
			case 16: KeyR := Line
			case 17: KeyS := Line
			case 18: KeyE := Line
			case 19: KeySpace := Line
			case 20: KeyA := Line
			case 21: KeyF := Line
			case 22: KeyD := Line
			case 23: KeyP := Line
			case 24: KeyK := Line
			case 25: KeyH := Line
			case 26: KeyM := Line
			case 27: KeyasS := Line
		}
	}
	return
}

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