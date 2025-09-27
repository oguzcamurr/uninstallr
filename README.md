# 🧹 uninstallr

🔥 *"Remove apps like they never existed."*

![License](https://img.shields.io/badge/License-MIT-green.svg)
![Version](https://img.shields.io/badge/version-v0.1.0-blue.svg)
![macOS](https://img.shields.io/badge/macOS-15.6.1%2B-lightgrey.svg)
![Built by](https://img.shields.io/badge/Built%20by-Oğuz%20Çamur-red)

---

## 🚀 Features
- Clean uninstall (app bundle + caches + plist)
- Dry-run mode (preview before delete)
- Force mode (no mercy 🔨)
- Homebrew support (tap + install)

---

## 📦 Installation

### 🔹 Homebrew
```bash
brew tap oguzcamurr/uninstallr
brew install uninstallr

🔹 Manual
git clone https://github.com/oguzcamurr/uninstallr.git
cd uninstallr
chmod +x uninstallr.sh
./uninstallr.sh --dry-run "Spotify"


🛠 Usage
uninstallr --dry-run "Spotify"   # Preview delete
uninstallr "Spotify"             # Full delete
uninstallr --force "Discord"     # No questions asked

## 📸 CLI Preview

![CLI Screenshot](docs/screenshot-cli.png)

🗺 Roadmap

 CLI Base Script

 Homebrew Formula

 GUI App (coming soon)

 DMG Installer
