# 获取传入的参数
if ($args.Count -eq 0) {
    Write-Host "No parameter passed. Use 1 to enable HDR or 0 to disable HDR."
    exit
}

$hdrStatus = $args[0]  # 获取第一个参数（0 或 1）

Import-Module WindowsDisplayManager

# 获取主显示器
$primaryDisplay = WindowsDisplayManager\GetPrimaryDisplay

if ($primaryDisplay -eq $null) {
    Write-Host "Error: Unable to retrieve primary display."
    exit 1
}

if ($hdrStatus -eq 1) {
    # 启用 HDR
    $result = $primaryDisplay.EnableHdr()
    if ($result) {
        Write-Host "HDR successfully enabled."
    } else {
        Write-Host "Failed to enable HDR. Check system settings or hardware support."
    }
} elseif ($hdrStatus -eq 0) {
    # 禁用 HDR
    $result = $primaryDisplay.DisableHdr()
    if ($result) {
        Write-Host "HDR successfully disabled."
    } else {
        Write-Host "Failed to disable HDR. Check system settings or hardware support."
    }
} else {
    Write-Host "Invalid parameter! Use 1 to enable HDR or 0 to disable HDR."
}

# 等待用户按下任意键后关闭 PowerShell
# Write-Host "Press any key to exit..."
# Read-Host
