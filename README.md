# 🧹 uninstallr  

🔥 *"Remove apps like they never existed."*  

[![License: MIT](https://img.shields.io/badge/License-MIT-green.svg)](LICENSE)  
![Version](https://img.shields.io/badge/version-v0.1.0-blue)  
![macOS](https://img.shields.io/badge/macOS-15.6.1%2B-lightgrey)  
![Built by](https://img.shields.io/badge/Built%20by-Oğuz%20Çamur-orange)  

---

## ⚡ Quick Start  

```bash
# Install via Homebrew
brew tap oguzcamurr/uninstallr
brew install uninstallr

# Remove Spotify safely
uninstallr "Spotify"
```
## 📦 Features

✅ Clean uninstall (app bundle + caches + plist)

🔍 Dry-run mode (preview before delete)

🛠️ Force mode (no mercy 🔨)

🍺 Homebrew support (tap + install)

🖥️ GUI App (coming soon)

# 📸 CLI Preview

![CLI Screenshot](docs/screenshot-cli.png)

## 🗺️ Roadmap  

- [x] CLI Base Script  
- [x] Homebrew Formula  
- [ ] [GUI App (v0.2.0 – Q4 2025)](https://github.com/oguzcamurr/uninstallr/milestone/1)  
- [ ] [DMG Installer (v0.3.0 – Q1 2026)](https://github.com/oguzcamurr/uninstallr/milestone/2)  

---

## 🤝 Contributing

Contributions are welcome! 🎉  
Please check out the [CONTRIBUTING.md](CONTRIBUTING.md) file for guidelines.

### 🏷️  Labels & Roadmap
We use `labels.json` to keep GitHub labels consistent across the repo.  
You can sync them with:

```bash
github-label-sync --access-token <TOKEN> --labels labels.json oguzcamurr/uninstallr
'''

### 🧪 Testing

Before opening a Pull Request, please test your changes locally:
```bash
./uninstallr.sh --dry-run "Spotify"
```

