;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; (Space key is assumed to be pause in game on simulator)(Press 3s to cancel the move)		;;
;; Operation list : 																		;;
;; ctrl + alt + H	: Display the operation list 10 seconds									;;
;; ctrl + alt + D	: Turn developer mode on / off											;;
;; ctrl + alt + T	: Suspend / Restart all hotkeys except itself							;;
;; ctrl + alt + R	: Reload program														;;
;; ctrl + alt + L	: Exit program															;;
;; The following operations can only be performed in developer mode : 						;;
;; ctrl + alt + M	: Move the mouse to the specified position								;;
;; ctrl + alt + C	: Query the color code of the specified position						;;
;; The following operations can only be performed on the simulator : 						;;
;; R				: Return / Setting														;;
;; E				: Auto deploy / Exit Mission											;;
;; S				: Mission start / Confirm												;;
;; Space			: Pause / Resume game													;;
;; A				: Speed changing														;;
;; F				: Turn skill on / off													;;
;; D				: Retreat operators / props												;;
;; P				: Pause the game when begin												;;
;; H				: Click the operator or props with current mouse position when pause	;;
;; M				: Deploy the operator or props with current mouse position when pause	;;
;; alt + shift + S	: Start / Stop cleaning up the action points with specified level(AFK)	;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; (預設空白鍵為模擬器自帶的遊戲暫停鈕)(長按3秒可以取消操作)	;;
;; 操作列表：													;;
;; ctrl + alt + H	: 呼叫操作列表顯示10秒						;;
;; ctrl + alt + D	: 開啟 / 關閉開發人員模式					;;
;; ctrl + alt + T	: 暫停 / 重啟自身外所有熱鍵					;;
;; ctrl + alt + R	: 重啟程式									;;
;; ctrl + alt + L	: 結束程式									;;
;; 以下操作僅能在開發人員模式執行：								;;
;; ctrl + alt + M	: 鼠標移至指定座標							;;
;; ctrl + alt + C	: 指定位置的色碼查詢						;;
;; 以下操作僅能在模擬器視窗執行：								;;
;; R				: 返回上頁 / 設定							;;
;; E				: 代理指揮 / 放棄行動						;;
;; S				: 開始行動 / 確認							;;
;; Space			: 暫停 / 繼續遊戲							;;
;; A				: 倍速調整									;;
;; F				: 開啟 / 關閉技能							;;
;; D				: 撤退幹員 / 道具							;;
;; P				: 開局暫停									;;
;; H				: 暫停點選當前鼠標位置的幹員或道具			;;
;; M				: 暫停部署當前鼠標位置的幹員或道具(划火柴)	;;
;; alt + shift + S	: 開始 / 結束掛機清體力						;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

#Persistent
Global WinTitle := "BlueStacks"															;; 模擬器視窗名稱
Global Width := 1920, Height := 1080													;; 模擬器尺寸，單位:pixel
Global tempX := 960, tempY := 540														;; 當前鼠標位置，單位:pixel
Global X := 1600, Y := 900																;; 指定位置，單位:pixel
Global CancelTime := 3000																;; 熱鍵取消施放時長，單位：ms
Global Developer := false																;; 是否啟用開發人員模式
Global Canceled := false																;; 是否取消施放當前的熱鍵
Global ScriptAFK := false																;; 是否啟用 ScriptAFK
Global Toggle := false																	;; 是否暫停所有熱鍵
Global ExitLoop := false																;; 是否退出迴圈
Global Flag := ""																		;; 當前狀態 Flag
Global RX := 90, RY := 80																;; 熱鍵 R 的座標，單位:pixel
Global SX := 1727, SY := 983															;; 熱鍵 S 的座標，單位:pixel
Global EX := 1600, EY := 900															;; 熱鍵 E 的座標，單位:pixel
Global SpaceX := 1860, SpaceY := 119													;; 熱鍵 Space 的座標，單位:pixel
Global AX := 1700, AY := 70																;; 熱鍵 A 的座標，單位:pixel
Global FX := 1225, FY := 665															;; 熱鍵 F 的座標，單位:pixel
Global DX := 850, DY := 323																;; 熱鍵 D 的座標，單位:pixel

$^!H::																					;; ctrl+alt+H 顯示操作列表10秒
	Gosub, CanceledReset
	SetTimer, Cancel, %CancelTime%
	KeyWait, H, %CancelTime%
	SetTimer, Cancel, delete
	if (!Canceled) {																	;; 正常施放
		ToolTip, 1.   ctrl + alt + H`t: Display the operation list 10 seconds`n2.   ctrl + alt + D`t: Turn developer mode on / off`n3.   ctrl + alt + T`t: Suspend / Restart all hotkeys except itself`n4.   ctrl + alt + R`t: Reload program`n5.   ctrl + alt + L`t: Exit program`nThe following operations can only be performed in developer mode : `n6.   ctrl + alt + M`t: Move the mouse to the specified position`n7.   ctrl + alt + C`t: Query the color code of the specified position`nThe following operations can only be performed on the simulator : `n8.   R`t`t`t: Return / Setting`n9.   E`t`t`t: Auto deploy / Exit Mission`n10. S`t`t`t: Mission start / Confirm`n11. Space`t`t: Pause / Resume game`n12. A`t`t`t: Speed changing`n13. F`t`t`t: Turn skill on / off`n14. D`t`t`t: Retreat operators / props`n15. P`t`t`t: Pause the game when begin`n16. H`t`t`t: Click the operator or props with current mouse position when pause`n17. M`t`t`t: Deploy the operator or props with current mouse position when pause`n18. alt + shift + S`t: Start / Stop cleaning up the action points with specified level(AFK)
		SetTimer, ToolTipReset, 10000
	}
	Gosub, CanceledReset
	return
$^!D::																					;; ctrl+alt+D 開發人員模式
	Gosub, CanceledReset
	SetTimer, Cancel, %CancelTime%
	KeyWait, D, %CancelTime%
	SetTimer, Cancel, delete
	if (!Canceled) {																	;; 正常施放
		Developer := !Developer
		if (Developer) {																;; 啟用開發人員模式
			ToolTip, Developer mode on!
		} else {																		;; 關閉開發人員模式
			ToolTip, Developer mode off!
		}
		SetTimer, ToolTipReset, 2000
	}
	Gosub, CanceledReset
	return
$^!T::																					;; ctrl+alt+P 暫停 / 重啟熱鍵
	Gosub, CanceledReset
	SetTimer, Cancel, %CancelTime%
	KeyWait, T, %CancelTime%
	SetTimer, Cancel, delete
	if (!Canceled) {																	;; 正常施放
		Toggle := !Toggle
		if (Toggle) {
			ToolTip, Hotkey suspend!
			Hotkey, ^!H, off
			Hotkey, ^!D, off
			Hotkey, ^!R, off
			Hotkey, ^!L, off
		} else {
			ToolTip, Hotkey enable!
			Hotkey, ^!H, on
			Hotkey, ^!D, on
			Hotkey, ^!R, on
			Hotkey, ^!L, on
		}
		SetTimer, ToolTipReset, 2000
	}
	Gosub, CanceledReset
	return
$^!R::																					;; ctrl+alt+R 重啟程式
	Gosub, CanceledReset
	SetTimer, Cancel, %CancelTime%
	KeyWait, R, %CancelTime%
	SetTimer, Cancel, delete
	if (!Canceled) {																	;; 正常施放
		ToolTip, Restarting app ...
		Sleep, 500
		Gosub, ToolTipReset
		Reload
	}
	Gosub, CanceledReset
	return
$^!L::																					;; ctrl+alt+L 結束程式
	Gosub, CanceledReset
	SetTimer, Cancel, %CancelTime%
	KeyWait, L, %CancelTime%
	SetTimer, Cancel, delete
	if (!Canceled) {																	;; 正常施放
		ToolTip, Exiting app...
		Sleep, 500
		Gosub, ToolTipReset
		ExitApp
	}
	Gosub, CanceledReset
	return

#If (!Toggle && Developer)
	$^!M::																				;; ctrl+alt+M 鼠標移至指定座標
		Gosub, CanceledReset
		SetTimer, Cancel, %CancelTime%
		targetX := X, targetY := Y
		KeyWait, M, %CancelTime%
		SetTimer, Cancel, delete
		if (!Canceled)																	;; 正常施放
			MouseMove, %targetX%, %targetY%, 0
		Gosub, CanceledReset
		return
	$^!C::																				;; ctrl+alt+C 指定位置的色碼查詢
		Gosub, CanceledReset
		SetTimer, Cancel, %CancelTime%
		KeyWait, C, %CancelTime%
		SetTimer, Cancel, delete
		if (!Canceled) {																;; 正常施放
			Color1 := "0xFFFFFF", Color2 := "0xF5F5F5"										;; 指定檢查顏色
			PixelGetColor, ColorP1, 1780, 65												;; 暫停 左上
			PixelGetColor, ColorP2, 1810, 65												;; 暫停 右上
			if (ColorP1 = Color1 && ColorP2 != Color1 && ColorP2 != Color2)
				Flag := "Pause"
			if (ColorP1 = Color1 && (ColorP2 = Color1 || ColorP2 = Color2))
				Flag := "Resume"
			MouseGetPos, tempX, tempY
			PixelGetColor, Color, %tempX%, %tempY%
			PixelGetColor, ColorS, %X%, %Y%
			ToolTip, Current is "%Color%"`nSpecified is "%ColorS%"`nColorP1 is "%ColorP1%"`nColorP2 is "%ColorP2%"`nColorP3 is "%ColorP3%"`nColorP4 is "%ColorP4%"`nColorP5 is "%ColorP5%"`nColorP6 is "%ColorP6%"`nFlag is "%Flag%"
			SetTimer, ToolTipReset, 5000
		}
		Gosub, CanceledReset
		return
#If

#If (!Toggle && WinActive(WinTitle))
	SetTimer, ScriptAFK, 0
	Key := "", targetX := X, targetY := Y
	$R::																				;; R 返回上頁 / 設定
		Key := "R"
		targetX := RX, targetY := RY
		Gosub, CanceledReset
		SetTimer, Cancel, %CancelTime%
		SetKeyDelay, 0
		SetMouseDelay, 0
		MouseGetPos, tempX, tempY
		mouseMove, %targetX%, %targetY%, 0
		SendEvent, {Click %targetX% %targetY% Down}
		mouseMove, %tempX%, %tempY%, 0
		KeyWait, %Key%, %CancelTime%
		SetTimer, Cancel, delete
		if (Canceled) {																	;; 取消施放
			MouseGetPos, tempX, tempY
			SendEvent, {Click %tempX% %tempY% Up}
		} else {																		;; 正常施放
			MouseGetPos, tempX, tempY
			mouseMove, %targetX%, %targetY%, 0
			SendEvent, {Click %targetX% %targetY% Up}
			mouseMove, %tempX%, %tempY%, 0
		}
		SetKeyDelay, 10
		SetMouseDelay, 10
		Gosub, CanceledReset
		return
	$S::																				;; S 開始行動 / 確認
		Key := "S"
		targetX := SX, targetY := SY
		Gosub, CanceledReset
		SetTimer, Cancel, %CancelTime%
		SetKeyDelay, 0
		SetMouseDelay, 0
		MouseGetPos, tempX, tempY
		mouseMove, %targetX%, %targetY%, 0
		SendEvent, {Click %targetX% %targetY% Down}
		mouseMove, %tempX%, %tempY%, 0
		KeyWait, %Key%, %CancelTime%
		SetTimer, Cancel, delete
		if (Canceled) {																	;; 取消施放
			MouseGetPos, tempX, tempY
			SendEvent, {Click %tempX% %tempY% Up}
		} else {																		;; 正常施放
			MouseGetPos, tempX, tempY
			mouseMove, %targetX%, %targetY%, 0
			SendEvent, {Click %targetX% %targetY% Up}
			mouseMove, %tempX%, %tempY%, 0
		}
		SetKeyDelay, 10
		SetMouseDelay, 10
		Gosub, CanceledReset
		return
	$E::																				;; E 代理指揮 / 放棄行動
		Key := "E"
		targetX := EX, targetY := EY
		Gosub, CanceledReset
		SetTimer, Cancel, %CancelTime%
		SetKeyDelay, 0
		SetMouseDelay, 0
		MouseGetPos, tempX, tempY
		mouseMove, %targetX%, %targetY%, 0
		SendEvent, {Click %targetX% %targetY% Down}
		mouseMove, %tempX%, %tempY%, 0
		KeyWait, %Key%, %CancelTime%
		SetTimer, Cancel, delete
		if (Canceled) {																	;; 取消施放
			MouseGetPos, tempX, tempY
			SendEvent, {Click %tempX% %tempY% Up}
		} else {																		;; 正常施放
			MouseGetPos, tempX, tempY
			mouseMove, %targetX%, %targetY%, 0
			SendEvent, {Click %targetX% %targetY% Up}
			mouseMove, %tempX%, %tempY%, 0
		}
		SetKeyDelay, 10
		SetMouseDelay, 10
		Gosub, CanceledReset
		return
	$Space::																			;; Space 暫停 / 繼續遊戲
		Key := "Space"
		targetX := SpaceX, targetY := SpaceY
		Gosub, CanceledReset
		SetTimer, Cancel, %CancelTime%
		SetKeyDelay, 0
		SetMouseDelay, 0
		MouseGetPos, tempX, tempY
		mouseMove, %targetX%, %targetY%, 0
		SendEvent, {Click %targetX% %targetY% Down}
		mouseMove, %tempX%, %tempY%, 0
		KeyWait, %Key%, %CancelTime%
		SetTimer, Cancel, delete
		if (Canceled) {																	;; 取消施放
			MouseGetPos, tempX, tempY
			SendEvent, {Click %tempX% %tempY% Up}
		} else {																		;; 正常施放
			MouseGetPos, tempX, tempY
			mouseMove, %targetX%, %targetY%, 0
			SendEvent, {Click %targetX% %targetY% Up}
			mouseMove, %tempX%, %tempY%, 0
		}
		SetKeyDelay, 10
		SetMouseDelay, 10
		Gosub, CanceledReset
		return
	$A::																				;; A 倍速調整
		Key := "A"
		targetX := AX, targetY := AY
		Gosub, CanceledReset
		SetTimer, Cancel, %CancelTime%
		SetKeyDelay, 0
		SetMouseDelay, 0
		MouseGetPos, tempX, tempY
		mouseMove, %targetX%, %targetY%, 0
		SendEvent, {Click %targetX% %targetY% Down}
		mouseMove, %tempX%, %tempY%, 0
		KeyWait, %Key%, %CancelTime%
		SetTimer, Cancel, delete
		if (Canceled) {																	;; 取消施放
			MouseGetPos, tempX, tempY
			SendEvent, {Click %tempX% %tempY% Up}
		} else {																		;; 正常施放
			MouseGetPos, tempX, tempY
			mouseMove, %targetX%, %targetY%, 0
			SendEvent, {Click %targetX% %targetY% Up}
			mouseMove, %tempX%, %tempY%, 0
		}
		SetKeyDelay, 10
		SetMouseDelay, 10
		Gosub, CanceledReset
		return
	$F::																				;; F 施放技能
		Key := "F"
		targetX := FX, targetY := FY
		Gosub, CanceledReset
		SetTimer, Cancel, %CancelTime%
		SetKeyDelay, 0
		SetMouseDelay, 0
		MouseGetPos, tempX, tempY
		mouseMove, %targetX%, %targetY%, 0
		SendEvent, {Click %targetX% %targetY% Down}
		mouseMove, %tempX%, %tempY%, 0
		KeyWait, %Key%, %CancelTime%
		SetTimer, Cancel, delete
		if (Canceled) {																	;; 取消施放
			MouseGetPos, tempX, tempY
			SendEvent, {Click %tempX% %tempY% Up}
		} else {																		;; 正常施放
			MouseGetPos, tempX, tempY
			mouseMove, %targetX%, %targetY%, 0
			SendEvent, {Click %targetX% %targetY% Up}
			mouseMove, %tempX%, %tempY%, 0
		}
		SetKeyDelay, 10
		SetMouseDelay, 10
		Gosub, CanceledReset
		return
	$D::																				;; D 撤退幹員 / 道具
		Key := "D"
		targetX := DX, targetY := DY
		Gosub, CanceledReset
		SetTimer, Cancel, %CancelTime%
		SetKeyDelay, 0
		SetMouseDelay, 0
		MouseGetPos, tempX, tempY
		mouseMove, %targetX%, %targetY%, 0
		SendEvent, {Click %targetX% %targetY% Down}
		mouseMove, %tempX%, %tempY%, 0
		KeyWait, %Key%, %CancelTime%
		SetTimer, Cancel, delete
		if (Canceled) {																	;; 取消施放
			MouseGetPos, tempX, tempY
			SendEvent, {Click %tempX% %tempY% Up}
		} else {																		;; 正常施放
			MouseGetPos, tempX, tempY
			mouseMove, %targetX%, %targetY%, 0
			SendEvent, {Click %targetX% %targetY% Up}
			mouseMove, %tempX%, %tempY%, 0
		}
		SetKeyDelay, 10
		SetMouseDelay, 10
		Gosub, CanceledReset
		return
	$P::																				;; P 開局暫停
		Key := "P"
		Gosub, CanceledReset
		SetTimer, Cancel, %CancelTime%
		SetKeyDelay, 0
		SetMouseDelay, 0
		KeyWait, %Key%, %CancelTime%
		SetTimer, Cancel, delete
		if (!Canceled) {																;; 正常施放
			ToolTip, Script start...
			SetTimer, ToolTipReset, 1000
			ExitLoop := false
			SetTimer, ForceExitLoop, 20000
			SetTimer, isInBattle, 0
			Loop {
				if (Flag = "Pause" || ExitLoop)
					break
				SendEvent, {Esc}
			}
			SetTimer, isInBattle, delete
			SetTimer, ForceExitLoop, delete
			ToolTip, Script end...
			SetTimer, ToolTipReset, 1000
			Gosub, FlagReset
		}
		SetKeyDelay, 10
		SetMouseDelay, 10
		Gosub, CanceledReset
		return
	$H::																				;; H 暫停點選
		Key := "H"
		targetX := SpaceX, targetY := SpaceY
		Gosub, CanceledReset
		SetTimer, Cancel, %CancelTime%
		SetKeyDelay, 0
		SetMouseDelay, 0
		MouseGetPos, tempX, tempY
		Gosub, isInBattle
		if (Flag = "Resume") {															;; 暫停遊戲
			SendEvent, {Esc}
			Sleep, 300
		}
		KeyWait, %Key%, %CancelTime%
		SetTimer, Cancel, delete
		if (!Canceled) {																;; 正常施放
			Gosub, isInBattle
			SendEvent, {Space Down}
			Sleep, 1
			MouseMove, %tempX%, %tempY%
			Sleep, 1
			SendEvent, {LButton Down}
			Sleep, 1
			SendEvent, {Space UP}
			SendEvent, {LButton Up}
			SendEvent, {Esc Down}
			Sleep, 1
			SendEvent, {Esc Up}
		}
		SetKeyDelay, 10
		SetMouseDelay, 10
		Gosub, CanceledReset
		return
	$M::																				;; M 暫停部署
		Key := "M"
		targetX := SpaceX, targetY := SpaceY
		Gosub, CanceledReset
		SetTimer, Cancel, %CancelTime%
		SetKeyDelay, 0
		SetMouseDelay, 0
		MouseGetPos, tempX, tempY
		Gosub, isInBattle
		if (Flag = "Resume") {															;; 暫停遊戲
			SendEvent, {Esc}
			Sleep, 300
		}
		KeyWait, %Key%, %CancelTime%
		SetTimer, Cancel, delete
		if (!Canceled) {																;; 正常施放
			SendEvent, {Space Down}
			Sleep, 1
			MouseMove, %tempX%, %tempY%
			Sleep, 1
			SendEvent, {LButton Down}
			Sleep, 1
			SendEvent, {Space Up}
			mouseMove, -5, -5, 0, R
			SendEvent, {Esc Down}
			Sleep, 1
			SendEvent, {Esc Up}
			mouseMove, 1200, 800, 0
		}
		SetKeyDelay, 10
		SetMouseDelay, 10
		Gosub, CanceledReset
		return
	$!+S::																				;; 單一關卡掛機清體力
		Gosub, CanceledReset
		SetTimer, Cancel, %CancelTime%
		KeyWait, S, %CancelTime%
		SetTimer, Cancel, delete
		if (!Canceled) {																;; 正常施放
			ScriptAFK := !ScriptAFK
			if (ScriptAFK) {
				SetTimer, ScriptAFK, 0
				ToolTip, Script "AFK" is now in progress!
			} else {
				SetTimer, ScriptAFK, delete
				ToolTip, Script "AFK" had end up!
			}
			SetTimer, ToolTipReset, 5000
		}
		Gosub, CanceledReset
		return
	isInBattle:																			;; 關卡是否已開始
		Color1 := "0xFFFFFF", Color2 := "0xF5F5F5"										;; 指定檢查顏色
		PixelGetColor, ColorP1, 1780, 65												;; 暫停 左上
		PixelGetColor, ColorP2, 1810, 65												;; 暫停 右上
		if (ColorP1 = Color1 && ColorP2 != Color1 && ColorP2 != Color2)
			Flag := "Pause"
		if (ColorP1 = Color1 && (ColorP2 = Color1 || ColorP2 = Color2))
			Flag := "Resume"
		return
	ScriptAFK:																			;; 每隔5秒按5次S鍵
		if (!Toggle && ScriptAFK && WinActive(WinTitle)) {
			SendEvent, {S}
			Sleep, 250
			SendEvent, {S}
			Sleep, 250
			SendEvent, {S}
			Sleep, 250
			SendEvent, {S}
			Sleep, 250
			SendEvent, {S}
			Sleep, 4000
			SetTimer, ScriptAFK, 0
		}
		return
	ForceExitLoop:
		ExitLoop := true
		return
#If

Cancel:
	Canceled := true
	SetTimer, Cancel, delete
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
