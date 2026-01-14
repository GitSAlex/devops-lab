import pyfiglet
from rich.console import console
from rich.progress import track
import time

console = Console()

def banner(text="Console Command"):
    ascii_banner = pyfiglet.figlet_format(text)
    console.print(f"[bold red]{ascii_banner}[/bold red]")

def loading(message="Processing", steps=10):
    for _ in track(range(steps), description=f"{message}..."):
        time.sleep(0.2)