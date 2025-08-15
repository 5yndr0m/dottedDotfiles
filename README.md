# dottedDotfiles ✨

> My personal dotfiles collection for a beautiful and functional Arch Linux + Hyprland setup with Catppuccin Mocha theme

<div align="center">

![Arch Linux](https://img.shields.io/badge/OS-Arch%20Linux-1793D1?style=for-the-badge&logo=arch-linux&logoColor=white)
![Hyprland](https://img.shields.io/badge/WM-Hyprland-58E1FF?style=for-the-badge&logo=wayland&logoColor=black)
![Catppuccin](https://img.shields.io/badge/Theme-Catppuccin%20Mocha-CBA6F7?style=for-the-badge)

</div>

## 📸 Gallery

| Desktop | Applications | Lock Screen |
|---------|-------------|-------------|
| ![Desktop Screenshot](screenshots/desktop.png) | ![Apps Screenshot](screenshots/apps.png) | ![Lock Screenshot](screenshots/lock.png) |
| *Clean desktop with QuickShell widgets* | *Application launcher and terminals* | *Hyprlock with blur effects* |

---

## 🖥️ System Information

<details open>
<summary><b>Core Components</b></summary>

| Component | Application |
|-----------|-------------|
| **OS** | Arch Linux |
| **Compositor** | [Hyprland](https://github.com/hyprwm/Hyprland) |
| **Session Manager** | [UWSM](https://github.com/Vladimir-csp/uwsm) |
| **Status Bar & Widgets** | [QuickShell](https://github.com/quickshell-org/quickshell) |
| **Launcher** | [Fuzzel](https://codeberg.org/dnkl/fuzzel) |
| **Terminal** | [Foot](https://codeberg.org/dnkl/foot) |
| **Lock Screen** | [Hyprlock](https://github.com/hyprwm/hyprlock) |
| **Logout Menu** | [Wlogout](https://github.com/ArtsyMacaw/wlogout) |
| **File Manager** | [Nautilus](https://gitlab.gnome.org/GNOME/nautilus) |
| **Wallpaper Manager** | [Waypaper](https://github.com/anufrievroman/waypaper) |

</details>

<details>
<summary><b>Development & Productivity</b></summary>

| Category | Applications |
|----------|-------------|
| **Editors** | [Neovim](https://github.com/neovim/neovim), [Zed](https://github.com/zed-industries/zed) |
| **Browser** | [Zen Browser](https://github.com/zen-browser/desktop) |
| **Terminal Multiplexer** | [Tmux](https://github.com/tmux/tmux) |
| **Shell** | [Fish](https://github.com/fish-shell/fish-shell) + [Bash](https://www.gnu.org/software/bash/) |
| **Fuzzy Finder** | [fzf](https://github.com/junegunn/fzf) |
| **History** | [Atuin](https://github.com/atuinsh/atuin) |

</details>

<details>
<summary><b>System Monitoring & Audio</b></summary>

| Purpose | Application |
|---------|-------------|
| **System Monitor** | [btop](https://github.com/aristocratos/btop) |
| **Audio Visualizer** | [Cava](https://github.com/karlstav/cava) |

</details>

## 🎨 Theme

This setup uses the **Catppuccin Mocha** colorscheme throughout all applications for a cohesive and elegant dark theme experience.

---

## 🚀 Installation

> [!WARNING]
> **Work in Progress**: This configuration is tailored to my specific setup and preferences. It may require adjustments for your system.

### Prerequisites

Ensure you have the following packages installed (Arch Linux package names):

```bash
# Core system
hyprland uwsm quickshell fuzzel foot hyprlock wlogout

# Applications
neovim zed-editor zen-browser-bin nautilus waypaper-git

# Development tools
tmux fish fzf atuin btop cava

# Additional dependencies
git stow # for dotfile management
```

### Quick Setup

1. **Clone the repository:**
   ```bash
   git clone https://github.com/5yndr0m/dottedDotfiles.git
   cd dottedDotfiles
   ```

2. **Backup your existing configs:**
   ```bash
   mkdir -p ~/dotfiles-backup
   cp -r ~/.config ~/dotfiles-backup/
   ```

3. **Apply configurations:**
   ```bash
   # Method 1: Direct copy (simple)
   cp -r config/* ~/.config/

   # Method 2: Using stow (recommended)
   stow . # from the repo root
   ```

4. **Restart Hyprland or reboot**

> [!NOTE]
> A comprehensive installation script is in development for easier deployment across different systems.

---

## 🤝 Contributing

Contributions are welcome! Here's how you can help:

- **🐛 Bug Reports**: Found an issue? Please open an issue with details
- **📝 Documentation**: README improvements and configuration documentation
- **🔧 QuickShell Help**: Especially looking for guidance and contributions for QuickShell configurations
- **💡 Feature Suggestions**: Open an issue to discuss new features before implementing

### Pull Request Guidelines

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Test your changes thoroughly
4. Submit a pull request with a clear description

---

## 💝 Acknowledgments

Special thanks to these amazing projects and creators for inspiration, code snippets, and guidance:

- **[end-4/dots-hyprland](https://github.com/end-4/dots-hyprland)** - Incredible Hyprland setup inspiration
- **[caelestia-dots/caelestia](https://github.com/caelestia-dots/caelestia)** - Beautiful aesthetic references
- **[codingjerk/dotfiles](https://github.com/codingjerk/dotfiles)** - Clean configuration structure
- **AI Chatbots** - For troubleshooting and configuration assistance
- **Hyprland Community** - For the amazing compositor and continuous support
- **Catppuccin Team** - For the beautiful color palette

---

## 📄 License

This project is licensed under the GNU License - see the [LICENSE](LICENSE) file for details.

---

<div align="center">

**⭐ If you found this helpful, consider giving it a star!**

*Made with ❤️ on Arch Linux*

</div>
