# 🧹 uninstallr

Modern lightweight app uninstaller for macOS (CLI + GUI planned).  
Alternative to AppCleaner, but fully open-source.

---

![License](https://img.shields.io/badge/License-MIT-green.svg) 
![Shell](https://img.shields.io/badge/made%20with-Shell-blue)
![PRs Welcome](https://img.shields.io/badge/PRs-welcome-brightgreen.svg)

---

## ✨ Features
- Remove apps *and* their leftover files (Preferences, Caches, Logs, LaunchAgents, etc.)
- Dry-run mode: preview what will be deleted before running
- Force mode: skip confirmation prompts
- Generates a report of removed files
- CLI ready ✅, SwiftUI GUI (AppCleaner alternative) coming soon

---

## 📦 Installation

Clone the repo:
git clone git@github.com:oguzcamurr/uninstallr.git
cd uninstallr
chmod +x uninstallr.sh
(📌 Homebrew support and DMG installer coming soon)

## 🍺 Install via Homebrewn
n
```bashn
brew tap oguzcamurr/uninstallrn
brew install uninstallrn
```n
n
Then run:n
n
```bashn
uninstallr --dry-run "Spotify"n
```n
n
✅ Tested on macOS 15.6.1 (Apple Silicon, ARM64)n
