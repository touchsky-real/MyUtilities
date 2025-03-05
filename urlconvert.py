import tkinter as tk
from tkinter import messagebox
import pyperclip,re


def extract_last_part(url):
    pattern = r'/([^/]+)/?$'
    match = re.search(pattern, url)
    if match:
        return match.group(1)
    return None

def main():
    urltext = str(pyperclip.paste())
    types = {'track','album','artist','label','playlist'}
    intypes = False
    for type in types:
        if type in urltext:
            intypes = True
            urltext = r"https://play.qobuz.com/"+type+"/"+extract_last_part(urltext)
            pyperclip.copy(urltext)
            break
    if not intypes:
        root = tk.Tk()
        root.withdraw()  # 隐藏主窗口
        messagebox.showwarning("警告", "不支持的url格式！")


if __name__ == "__main__":
    main()