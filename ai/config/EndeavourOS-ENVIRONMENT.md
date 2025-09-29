# Computer and User Information

The following information is for AI Agents to learn specifics of the user and environment they are running in.

## User

- Name: Grant Carthew
- Skills: Expert in IT and a number of programming languages

## Command Restrictions

- Use RipGrep `rg` instead of grep
- Use `lsd --tree [dir]` for a directory tree

## Operating System

- OS: EndeavourOS x86_64
- Kernel: Linux 6.16.8-arch2-1
- CPU: Intel(R) Core(TM) i9-14900HX (32) @ 5.80 GHz
- Memory: 32.00 GiB
- Shell: bash 5.3.3
- Architecture: amd64
- Locale: en_AU.UTF-8

## Desktop

- GNOME Shell 49.0
- Session Type: Wayland
- Display Server: Wayland (wayland-0)

## Terminal

- Ghostty 1.2.0: Fast, feature-rich, cross-platform terminal emulator
  - Terminal type: `xterm-ghostty`
  - Color support: 256 colors + truecolor
  - Font engine: FreeType (Linux native)
  - Renderer: OpenGL (GPU-accelerated)

## CLI Tools

The following extra command-line tools are installed and at your disposal.

Please use them. If you need, run a --help argument with them to ensure you have the right syntax.

Prefer these tools over other Bash built-in tools. A good example is RipGrep vs grep.

- aichat: All-in-one AI CLI tool
- bat: A cat clone with syntax highlighting and Git integration
- curlie: The power of curl, the ease of use of httpie
- dog: A command-line DNS client
- dua: dua-cli - View disk space usage and delete unwanted data, fast
- entr: Run arbitrary commands when files change
- fastfetch: Feature-rich and performance oriented, neofetch like system information tool
- fd: A simple, fast and user-friendly alternative to 'find'
- fdupes: Identifying or deleting duplicate files
- fzf: A command-line fuzzy finder
- gdb: GNU Project debugger
- git: Source code management
- glow: Render markdown on the CLI, with pizzazz!
- gping: Ping, but with a graph
- gron: Make JSON greppable!
- hq: A HTML processor inspired by jq
- hyperfine: A command-line benchmarking tool
- jless: JSON viewer designed for reading, exploring, and searching through JSON data
- jq: Command-line JSON processor
- lsd: The next gen ls command
- lsof: List open files
- ltrace: A library call tracer
- mise: dev tools, env vars, task runner
- mtr: Combines the functionality of traceroute and ping into one tool
- nvim: neovim - Better vim
- ngrep: GNU grep applied to the network layer
- oha: HTTP load generator
- ouch: Painless compression and decompression in the terminal
- 7za: p7zip - File archiver with a high compression ratio
- pipx: Install and Run Python Applications in Isolated Environments
- procs: A modern replacement for ps written in Rust
- progress: Displays percentage of running core util commands
- rg: ripgrep - Better file text search
- rmlint: Extremely fast tool to remove duplicates and other lint from your filesystem
- rsync: Efficiently transferring and synchronizing files between a computer and a storage
- sd: Intuitive find & replace CLI (sed alternative)
- shellcheck: Finds bugs in your shell scripts
- strace: Trace system calls and signals
- tmux: Terminal multiplexer
- uv: An extremely fast Python package installer and resolver, written in Rust
- vegeta: HTTP load testing tool and library. It's over 9000!
- vnstat: A network traffic monitor for Linux and BSD
- xclip: Command line interface to the X11 clipboard
- yamllint: Linter for YAML files
- yq: YAML, JSON, XML, CSV, TOML and properties processor

## Special Commands

- `kagi <search-terms>`: Search the internet returning clean search results for AI agent use
- `ff <search-terms>`: Open a new tab in Firefox searching Kagi for the search terms for the user to view

## get-webpage

This is a special CLI tool designed for AI agents to get web pages as Markdown.

This tool will enable the ability to access pages authenticated by the user.

Usage: get-webpage <url> [options]

Seamlessly fetches webpage content and converts to Markdown using intelligent Chromium automation

Optional arguments:

- --timeout <seconds>    Page load timeout in seconds (default: 30)
- --output <file>        Save output to file instead of stdout
- --wait-for <selector>  Wait for CSS selector before extracting content
- --html                 Return raw HTML instead of Markdown (default: false)
- --debug                Enable debug output
- --port <port>          Chrome remote debugging port (default: 9222)
- --force-headless       Force headless mode even if Chromium is running
- --force-visible        Force visible mode for authentication
- -h, --help             Show this help message and exit

Workflow:

- If Chromium is running: Uses existing session (preserves authentication)
- If Chromium not running: Launches headless mode for quick fetching
- If authentication required: Automatically launches visible Chromium
- Converts HTML to clean Markdown by default

Examples:

- get-webpage example.com
- get-webpage https://example.com --output page.md
- get-webpage app.example.com/docs --wait-for ".content-loaded"
- get-webpage private.example.com --force-visible
- get-webpage localhost:3000 --html
- get-webpage 192.168.1.100:8080 --timeout 60

## Command Restrictions

- Use RipGrep `rg` instead of grep
- Use `lsd --tree [dir]` for a directory tree
- Use `fd` for finding files
