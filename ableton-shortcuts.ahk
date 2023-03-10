#Requires AutoHotkey v2.0

; AHK Script for Ableton Live 11 by nova+z (aka. Nagrahtrev)
; ※ THIS SCRIPT REQUIRES AUTOHOTKEY V2 ※

Persistent
#SingleInstance force

; You can change any hotkey to suit your preferences
; Here is the list of keynames: https://www.autohotkey.com/docs/v2/KeyList.htm
; Please read the documentation (https://www.autohotkey.com/docs/v2/) before customizing this script

; ----

; Suspend/Unsuspend all hotkeys | SHIFT + F12
#SuspendExempt
+F12::Suspend
#SuspendExempt False

; Auto Switch to English IME when Ableton Live is activated
     ;; You can change the process name below, such as "Ableton Live 11 Suite.exe"
     ;; If you want to add any other process, please follow this format and type the command on the next line
     ;; GroupAdd "Process_EN", "ahk_exe [ProcessName]"
GroupAdd "Process_EN", "ahk_exe Ableton Live 11 Suite.exe"

MapIME := Map("EN", 67699721)
GetCurrentIMEID()
{
     WinID := WinGetID("A")
     ThreadID := DllCall("GetWindowThreadProcessId", "UInt", WinID, "UInt", 0)
     InputLocaleID := DllCall("GetKeyboardLayout", "UInt", ThreadID, "UInt")
     Return InputLocaleID
}
SetIME(IMEID)
{
     WinTitle := WinGetTitle("A")
     PostMessage 0x50, 0, IMEID, , WinTitle     
}
Loop
{
     WinWaitActive("ahk_group Process_EN")    
     CurrentWinID := WinGetID("A")
     SetIME(MapIME["EN"])
     WinWaitNotActive(CurrentWinID)
}

; Quick Insert Plugins | CAPSLOCK + [KeyName] (CapsLock will still work properly)
CapsLock::
{
     KeyWait "CapsLock"
     if (A_ThisHotkey="CapsLock")
         {
         SetCapsLockState !GetKeyState("CapsLock", "T") ? True : False
         }
}
#HotIf GetKeyState("CapsLock", "P")
Device(Name)
{
     Send "^f"
     Send Name
     Sleep 200
     Send "{Down}"
     Send "{Enter}"
}
     ;; Customize it to any plugin you want!
     ;; [KeyName]::SendInput Device("{Text}[Device Name]")
     1::SendInput Device("{Text}EQ Eight")
     2::SendInput Device("{Text}Bass Phat Rack.adg")
     3::SendInput Device("{Text}OTT.adv")
     4::SendInput Device("{Text}Granulator II.amxd")
     5::SendInput Device("{Text}")
     6::SendInput Device("{Text}")
     7::SendInput Device("{Text}")
     8::SendInput Device("{Text}[Device Name]")
     9::SendInput Device("{Text}")
     0::SendInput Device("{Text}")
     q::SendInput Device("{Text}")
     w::SendInput Device("{Text}")
     e::SendInput Device("{Text}vst Nexus")
     r::SendInput Device("{Text}vst3 Serum")

; The following directives only work on a specific process, such as "Ableton Live 11 Suite.exe", you can totally change it
#HotIf WinActive("ahk_exe Ableton Live 11 Suite.exe")

; Quick Search VST Plugins | ALT + F
!f::
{
     Send "^f"
     Send "vst"
     Send "{Space}"
}

; Swap TAB and SHIFT+TAB
Tab::+Tab
+Tab::Tab

; Redo with CTRL+SHIFT+Z
^+z::^y

; Close the Activated Plugin Window | ESC
Hotkey "Esc", MyFunc
MyFunc(ThisHotkey)
{
     P_Process := WinGetProcessName("A")
     P_Class := WinGetClass("A")
     P_Title := WinGetTitle("A")
     SetTitleMatchMode 3
     if RegExMatch(P_Process,"Ableton")
     {
         if RegExMatch(P_Class,"AbletonVstPlugClass") or RegExMatch(P_Class,"Vst3PlugWindow") or RegExMatch(P_Class,"JUCE_")
	 {
	     WinClose P_Title 
             SetTitleMatchMode 2
	 }
     }
}

; Duplicate to 1 Bar | ALT + D
!d::
{
     Send "^{d 7}"
}

; Create a Non-looped Midi Clip | XButton2 (If your mouse doesn't have side buttons, just change it to another key)
XButton2::
{
     Send "^+m"
     Sleep 1
     Send "^j"
}

; Deactivate Selected Clips | XButton1
XButton1::
{
     Send "{Numpad0}"
}

; Toggle Grid Snapping | F1 ~ F4
F1::^1
F2::^2
F3::^3
F4::^4

; Transpose MIDI Note Pitch or Change the Knob Value
     ;; SHIFT + [WheelUp/Dn], Transpose Notes by Semitone, Increment/Decrement Value
     +WheelUp::
     {
         Send "{Up}"
     }

     +WheelDown::
     {
         Send "{Down}"
     }

     ;; CTRL + SHIFT + [WheelUp/Dn], Transpose Notes by Octave, Finer Resolution
     ^+WheelUp::
     {
         Send "+{Up}"
     }

     ^+WheelDown::
     {
         Send "+{Down}"
     }
     ;; SHIFT + [XBUTTON2/XBUTTON1], Extend/Retract Notes, Finer Resolution
     +XButton2::
     {
         Loop
         {
             Send "+{Right}"
             Sleep 200
             State := GetKeyState("XButton2", "P")
             if (State = 0)
                 Break
             if (A_TimeSinceThisHotkey > 3000)
                 Break
         }
     }
     +XButton1::
     {
         Loop
         {
             Send "+{Left}"
             Sleep 200
             State := GetKeyState("XButton1", "P")
             if (State = 0)
                 Break
             if (A_TimeSinceThisHotkey > 3000)
                 Break
         }
     }     

; Key Mapping Optimization (Only for self-use Racks and M4L Devices, you can delete it later)
!z::[
!x::]
!m::;
!n::'

; ----

#HotIf
