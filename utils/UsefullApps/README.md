# Hyprland Modernization Manifest

## 1. Screenshot & Annotation Stack (Wayland-Native)

- `grim`: Backend camera tool
- `slurp`: Region selection overlay
- `wl-clipboard`: Direct-to-memory clipboard piping
- `satty`: Rust-based annotation studio (arrows, blurs, highlights)
- `jq`: CLI JSON processor (used for active-window coordinates)

## 2. File & Image Management (GTK4 Synergy)

- `nautilus`: Standard GNOME file manager
- `loupe`: Modern GNOME image viewer (native Nautilus hook)

## 3. Core Desktop Utilities & Shell

- `walker`: Application launcher and native Wayland clipboard manager (via `elephant` backend)
- `ashell`: Wayland status bar and UI shell
- `overskride`: Modern, native Bluetooth manager
- `nm-applet`: Standard NetworkManager GUI for Wi-Fi and network configuration
- `mpv`: Hardware-accelerated media player
- `evince`: GNOME document and PDF viewer
- `pavucontrol`: GUI audio mixer for PipeWire
- `file-roller`: GUI archive manager (`.zip` / `.tar.gz`)
