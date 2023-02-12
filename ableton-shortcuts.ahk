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

; Auto Switch to English IME when Ableton Live 11 is activated
     ;; You can change the process name below, such as "Ableton Live 11 Suite.exe"
     ;; If you want to add any other process, please follow this format and type the command on the next line
     ;; GroupAdd "English", "ahk_exe [ProcessName]"
GroupAdd "English", "ahk_exe Ableton Live 11 Suite.exe"

MapIME := Map("EN", 67699721)
GetCurrentIMEID()
{
     WinID := WinGetID("A")
     ThreadID := DllCall("GetWindowThreadProcessId", "UInt", WinID, "UInt", 0)
     InputLocaleID := DllCall("GetKeyboardLayout", "UInt", ThreadID, "UInt")
     Return InputLocaleID
}
SetIME(ime_id)
{
     WinTitle := WinGetTitle("ahk_group English")
     PostMessage(0x50, 0, ime_id,, WinTitle )
}
~LButton::
{
     SetIME(MapIME["EN"])
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
     ;; [KeyName]::SendInput Device("[Device Name]")
     1::SendInput Device("EQ Eight")
     2::SendInput Device("Bass Phat Rack.adg")
     3::SendInput Device("OTT.adv")
     4::SendInput Device("Granulator II.amxd")
     5::SendInput Device("")
     6::SendInput Device("")
     7::SendInput Device("")
     8::SendInput Device("")
     9::SendInput Device("")
     0::SendInput Device("")
     q::SendInput Device("")
     w::SendInput Device("")
     e::SendInput Device("vst Nexus")
     r::SendInput Device("vst3 Serum")

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

; Change the Value of Knobs or Transpose MIDI Note Pitch with Mousewheel
     ;; SHIFT + [WheelUp/Dn], Increment/Decrement the Value, Move MIDI Notes by 1 Semitone
     +WheelUp::
     {
         Send "{Up}"
     }

     +WheelDown::
     {
         Send "{Down}"
     }

     ;; CTRL + SHIFT + [WheelUp/Dn], Finer Resolution, Move MIDI Notes by 1 Octave
     ^+WheelUp::
     {
         Send "+{Up}"
     }

     ^+WheelDown::
     {
         Send "+{Down}"
     }

; Key Mapping Optimization (Only for self-use Effect Racks and M4L Devices, you can delete it later)
!z::[
!x::]
!m::;
!n::'

; ----

#HotIf
