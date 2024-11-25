import subprocess
from rich import print as rprint

def send_to_clipboard(text):
    try:
        subprocess.run(['xclip', '-selection', 'clipboard'], input=text.encode('utf-8'))
    except:
        rprint('[red]Unable to send content to the clipboard[/]')

