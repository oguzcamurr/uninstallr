# uninstallr

🚀 Modern lightweight app uninstaller for macOS (CLI + GUI planned)

## ✨ Features
- Remove apps *and* their leftover files (Preferences, Caches, Logs, LaunchAgents, etc.)
- Dry-run mode: preview what will be deleted before running
- Force mode: skip confirmation prompts
- Generates a report of removed files
- CLI ready ✅, SwiftUI GUI (AppCleaner alternative) coming soon

## 📥 Installation

Clone the repo:
git clone https://github.com/oguzcamurr/uninstallr.git
cd uninstallr
chmod +x uninstallr.sh
(📌 Homebrew support and DMG installer coming soon.)

🛠 Usage
Preview files that would be removed:

./uninstallr.sh --dry-run "Spotify"
Actually remove the app:

./uninstallr.sh "Spotify"
Remove without confirmation:

./uninstallr.sh --force "Discord"
🗺 Roadmap
 CLI base script

 Homebrew formula (brew install oguz/uninstallr/uninstallr)

 SwiftUI GUI prototype

 DMG installer

 Pro features: bulk uninstall, rollback, auto-updates

## 📸 Screenshots

**CLI Preview**  
![CLI Screenshot](docs/screenshot-cli.png)

🤝 Contributing
Pull requests are welcome!
For major changes, please open an issue first to discuss what you would like to change.

📄 License
MIT License
