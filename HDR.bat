@echo off
setlocal

rem 获取传入的参数
set param=%1

rem 调用 PowerShell 脚本并将参数传递给它
powershell -NoProfile -ExecutionPolicy Bypass -File "F:\code\MyUtilities\ManageHDR.ps1" %param%

endlocal
