import pyautogui,subprocess,time

# 执行命令并获取输出
netinterfaces = subprocess.run(['netsh','interface', 'show','interface'], capture_output=True, text=True)
netinterfaces = netinterfaces.stdout.split('\n')

for netinterface in netinterfaces:
    if netinterface.endswith('以太网') and netinterface.startswith('已启用'):
        



