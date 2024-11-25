from rich import print as rprint
from rich.console import Console
console = Console()

def print_title(title: str) -> None:
    console.rule()
    console.print(title, style='bold')
    console.rule()

def print_line() -> None:
    console.rule()
