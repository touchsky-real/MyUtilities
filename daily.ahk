#Requires AutoHotkey v2.0

CapsLock & a::   ; Tab + q 热键,input string
{
    temp := EnvGet("mytemp")
    if !temp  ; 如果环境变量不存在
    {
        MsgBox "mytemp环境变量不存在"
    }
    SendInput temp . "{Enter}"
}




^!a::  ; Ctrl+Alt+A 热键
{
    ClipSaved := ClipboardAll()  ; 保存当前剪贴板内容
    A_Clipboard := ""  ; 清空剪贴板
    Send "^c"  ; 发送 Ctrl+C 来复制选中内容
    if !ClipWait(1)  ; 等待剪贴板内容变化，最多等待2秒
    {
        MsgBox "未能获取选中的文本或没有选文本"
        return
    }
    SelectedText := A_Clipboard  ; 获取选中的文本

    ; URL 编码选中的文本
    EncodedText := UrlEncode(SelectedText)

    ; 构造 Google 搜索 URL
    SearchUrl := "https://www.google.com/search?q=" . EncodedText . "&ie=UTF-8"

    ; 用 Chrome 打开搜索 URL
    Run "chrome.exe " . SearchUrl

    ; 等待Chrome窗口出现
    WinWait "ahk_exe chrome.exe"

    ; 激活Chrome窗口
    WinActivate "ahk_exe chrome.exe"

    ; 最大化Chrome窗口
    WinMaximize "ahk_exe chrome.exe"

    A_Clipboard := ClipSaved  ; 恢复原来的剪贴板内容
    ClipSaved := ""  ; 释放内存
}

; URL 编码函数
UrlEncode(String)
{
    EncStr := ""
    Loop Parse, String
    {
        if RegExMatch(A_LoopField, "^[a-zA-Z0-9]$")
        {
            EncStr .= A_LoopField
            continue
        }
        Hex := Format("{:02X}", Ord(A_LoopField))
        EncStr .= "%" . Hex
    }
    return EncStr
}

; 每天自动打开热搜
; =================================================================================

#Requires AutoHotkey v2.0
#SingleInstance Force

; 定义全局变量
iniFile := A_Temp "\chrome_open_tracker.ini"
todayDate := FormatTime(A_Now, "yyyyMMdd")

; 使用 WinEvent 监听进程创建
pCallback := CallbackCreate(OnProcessStart)
DllCall("SetWinEventHook"
    , "UInt", 0xA ; EVENT_OBJECT_CREATE
    , "UInt", 0xA
    , "Ptr", 0
    , "Ptr", pCallback
    , "UInt", 0
    , "UInt", 0
    , "UInt", 0x0003) ; WINEVENT_OUTOFCONTEXT | WINEVENT_SKIPOWNPROCESS

OnProcessStart(hWinEventHook, event, hwnd, idObject, idChild, dwEventThread, dwmsEventTime) {
    if !hwnd
        return

    pid := 0
    DllCall("GetWindowThreadProcessId", "Ptr", hwnd, "UInt*", &pid)
    if !pid
        return

    procName := GetProcessName(pid)
    if (procName = "chrome.exe")
        OpenWebOnFirstLaunch()
}

GetProcessName(pid) {
    ; 获取进程名称
    size := 260
    name := Buffer(size * 2)
    if hProcess := DllCall("OpenProcess", "UInt", 0x1000, "Int", 0, "UInt", pid, "Ptr") {
        DllCall("QueryFullProcessImageName", "Ptr", hProcess, "UInt", 0, "Ptr", name, "UInt*", &size)
        DllCall("CloseHandle", "Ptr", hProcess)
        return StrSplit(StrGet(name), "\").Pop()
    }
    return ""
}

OpenWebOnFirstLaunch() {
    static launched := false
    if launched
        return

    launched := true
    lastRunDate := IniRead(iniFile, "Settings", "LastRunDate", "0")

    if (lastRunDate != todayDate) {
        IniWrite(todayDate, iniFile, "Settings", "LastRunDate")
        Sleep(2000)
        Run("chrome.exe https://newsnow.busiyi.world/c/hottest")
    }
}

; =================================================================================
; 每天自动打开热搜