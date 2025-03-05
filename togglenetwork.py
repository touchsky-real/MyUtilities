import pyautogui,subprocess,time

# 执行命令并获取输出
netinterfaces = subprocess.run(['control','netconnections'])

time.sleep(1)

pyautogui.hotkey('alt', 'space','x')
time.sleep(1)

pyautogui.rightClick(pyautogui.center(pyautogui.locateOnScreen(r'F:\code\togglenetwork\images\WLAN.png')))
pyautogui.moveRel(5,5)
pyautogui.click()

pyautogui.rightClick(pyautogui.center(pyautogui.locateOnScreen(r'F:\code\togglenetwork\images\Ethernet.png')))
pyautogui.moveRel(5,5)
pyautogui.click()

time.sleep(3.5)
# pyautogui.hotkey('alt', 'f4')


while 1:
    if pyautogui.pixelMatchesColor(1345,700, (255, 255, 255)):
        pyautogui.hotkey('alt', 'f4')
        break








