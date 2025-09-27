# 🧹 uninstallr  

🔥 *"Remove apps like they never existed."*  

██╗ ██╗███╗ ██╗██╗███╗ ██╗███████╗████████╗ █████╗ ██╗ ██╗
██║ ██║████╗ ██║██║████╗ ██║██╔════╝╚══██╔══╝██╔══██╗██║ ██║
██║ ██║██╔██╗ ██║██║██╔██╗ ██║█████╗ ██║ ███████║██║ ██║
██║ ██║██║╚██╗██║██║██║╚██╗██║██╔══╝ ██║ ██╔══██║██║ ██║
╚██████╔╝██║ ╚████║██║██║ ╚████║███████╗ ██║ ██║ ██║███████╗███████╗
╚═════╝ ╚═╝ ╚═══╝╚═╝╚═╝ ╚═══╝╚══════╝ ╚═╝ ╚═╝ ╚═╝╚══════╝╚══════╝

yaml
Kodu kopyala

[![License: MIT](https://img.shields.io/badge/License-MIT-green.svg)](LICENSE)
[![Version](https://img.shields.io/badge/version-v0.1.0-blue.svg)](https://github.com/oguzcamurr/uninstallr/releases/tag/v0.1.0)
[![macOS](https://img.shields.io/badge/macOS-15.6.1+-black.svg?logo=apple)]()
[![Built by Oğuz Çamur](https://img.shields.io/badge/Built%20by-Oğuz%20Çamur-darkred.svg)](https://github.com/oguzcamurr)

---

## 🚀 Features
- Clean uninstall (app bundle + caches + plist)  
- Dry-run mode (preview before delete)  
- Force mode (no mercy 🪓)  
- Homebrew support (tap + install)  

---

## 🛠 Installation  

**Homebrew**:  
```bash
brew tap oguzcamurr/uninstallr
brew install uninstallr
Manual:

bash
Kodu kopyala
git clone https://github.com/oguzcamurr/uninstallr.git
cd uninstallr
chmod +x uninstallr.sh
⚡ Usage
bash
Kodu kopyala
uninstallr --dry-run "Spotify"   # Preview delete
uninstallr "Spotify"             # Full delete
uninstallr --force "Discord"     # No questions asked
🗺 Roadmap
 CLI Base Script

 Homebrew Formula

 GUI App (coming soon)

 DMG Installer

👤 Author
Built with ☕, ⚡ and zero mercy by Oğuz Çamur
