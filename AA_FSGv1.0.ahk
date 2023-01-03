;;Made by PodX12
;;
;;HOW THIS WORKS
;;This macro requires you have a browser window open focused on AAFSG to work.
;;
;;When you press your hotkey while focused on minecraft it tab into aafsg.com, get a seed, tab into minecraft and create that world.
;;
;;REQUIRES Atum mod

#SingleInstance, Force

global delay := 50 ; if something is not working try increasing the delay.
global SavesDirectory := "C:\Users\PodX1\Downloads\MultiMC\instances\MULTI1\.minecraft\saves\" ; directory of instance you are using for fsg


CreateWorld(){
    WinActivate, Minecraft*
    SetKeyDelay, delay
    send {Esc 3}
    send {Shift Down}{Tab}{Enter}{Shift Up}
    send ^a
    send ^v
    send {Tab 5}
    send {Enter}
    SetKeyDelay, delay
    send {Shift Down}{Tab}{Shift Up}{Enter}
}

GetSeed(){
    IfWinExist, AAFSG
    {
        WinActivate, AAFSG
        Send, {]}
        Sleep, 500
    }
    Else
    {
        MsgBox % "Could not find AAFSG browser window. Open an aafsg.com window and run again."
    }
}

ExitWorld()
{
    SetKeyDelay, 0
    send {Esc}{Tab 6}{Enter}+{Tab 3}{Enter}
}

RunMacro(){
    WinGetActiveTitle, Title
    IfNotInString Title, -
    {
        GetSeed()
        CreateWorld()
    }
    else
    {
        ExitWorld()
        HasGameSaved()
        Sleep, 100
        GetSeed()
        CreateWorld()
    }
}

HasGameSaved() {
    rawLogFile := StrReplace(SavesDirectory, "saves", "logs\latest.log")
    StringTrimRight, logFile, rawLogFile, 1
    numLines := 0
    Loop, Read, %logFile%
    {
        numLines += 1
    }
    saved := False
    maxCounter := 500
    counter := 0
    while (!saved && counter < maxCounter)
    {
        Loop, Read, %logFile%
        {
            if ((numLines - A_Index) < 2)
            {
                if (InStr(A_LoopReadLine, "Stopping worker threads")) {
                    saved := True
                    break
                }
            }
        }
        counter++
        Sleep, 100
    }
    return saved
}


#IfWinActive, Minecraft*
{
    RAlt::
        RunMacro()
    return
}


