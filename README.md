# 🧼 CleanMac - macOS System Cleanup Tool

<div align="center">

[![Language](https://img.shields.io/badge/Language-English-blue.svg)](README.md)
[![语言](https://img.shields.io/badge/语言-中文-red.svg)](README_CN.md)

**[🇺🇸 English](README.md) | [🇨🇳 中文](README_CN.md)**

</div>

A powerful, interactive macOS system cleanup utility that helps you safely clean cache and junk files from your system.

## ✨ Features

- 🎨 **Beautiful Interactive Interface** - Colorful terminal interface that's intuitive and user-friendly
- 🛡️ **Safe & Reliable** - Always asks for confirmation before deleting anything
- 📊 **Real-time Size Display** - Shows disk usage for each cleanup category
- 🎯 **Modular Cleaning** - Selectively clean different types of files
- 📈 **Detailed Summary** - Shows cleanup results and space saved
- ⚡ **Smart Detection** - Automatically detects installed applications and dev tools

## 🧹 Cleanup Categories

### 1. User-Level Caches & Logs
- User application caches (`~/Library/Caches`)
- User application logs (`~/Library/Logs`)
- Crash reports (`~/Library/Application Support/CrashReporter`)
- Saved application states (`~/Library/Saved Application State`)
- Shared file lists (`~/Library/Application Support/com.apple.sharedfilelist`)

### 2. System-Level Caches (Requires Admin)
- System application caches (`/Library/Caches`)
- System temporary files (`/private/var/folders`)
- System logs (`/private/var/log`)
- System diagnostic reports (`/Library/Logs/DiagnosticReports`)

### 3. Browser Caches
- **Safari** - Cache files
- **Google Chrome** - Cache and application cache
- **Firefox** - Cache for all profiles

### 4. Development Tools
- **Xcode** - DerivedData, Archives, iOS Device Support, CoreSimulator caches
- **Visual Studio Code** - Logs and cached data
- **npm/Node.js** - npm cache and node-gyp cache
- **Homebrew** - Package cache and cleanup
- **Python pip** - pip cache
- **Rust Cargo** - Cargo cache

### 5. Application Caches
- Adobe Media Cache
- Zoom cache
- Discord cache
- Spotify cache
- Slack cache
- Microsoft Teams cache

### 6. Trash & Miscellaneous
- User Trash
- External drive trash
- iOS device backups
- Downloads folder (use with caution)

## 🚀 Usage

### Basic Usage

1. **Download the script**
   ```bash
   git clone https://github.com/your-username/CleanYourMac.git
   cd CleanYourMac
   ```

2. **Make it executable**
   ```bash
   chmod +x clean_mac.sh
   ```

3. **Run the script**
   ```bash
   ./clean_mac.sh
   ```

### Language Support

The script supports both English and Chinese interfaces:

```bash
# Run with English interface (default)
./clean_mac.sh --lang=en

# Run with Chinese interface
./clean_mac.sh --lang=cn

# Interactive language switching available in menu option [8]
```

### Interactive Menu

After running the script, you'll see the following menu options:

```
[1] User-level caches & logs
[2] System-level caches (requires admin)
[3] Browser caches
[4] Development tools
[5] Application caches
[6] Trash & miscellaneous
[7] Clean everything (interactive)
[8] Exit
```

### Example Usage

```bash
# Quick start
./clean_mac.sh

# For each cleanup item, you'll see prompts like:
User application caches
  → Path: /Users/username/Library/Caches
  → Size: 2.3GB
Do you want to clean this? [y/N]: y
🧹 Cleaning...
✅ Cleaned: User application caches (2.3GB freed)
```

## 🛡️ Safety Features

- **Confirmation Prompts** - Always asks before deleting anything
- **Size Display** - Shows disk space used by each item
- **Path Validation** - Verifies paths exist before attempting cleanup
- **Error Handling** - Gracefully handles permission errors and other issues
- **Read-only Check** - Won't delete critical system files

## ⚠️ Important Notes

1. **Admin Privileges** - System-level cache cleanup requires sudo access
2. **Backup Important Data** - While the script is safe, always backup important data
3. **Development Environment** - Cleaning dev tool caches may require re-downloading dependencies
4. **App Settings** - Some applications may need to reconfigure preferences

## 🔧 System Requirements

- macOS 10.12 or later
- Bash 4.0 or later
- Basic Unix tools (du, rm, sudo)

## 📊 Performance Benefits

After using CleanMac, you may experience:

- ⚡ Faster system startup
- 💾 Significant disk space recovery (typically 1-10GB)
- 🔄 Improved application responsiveness
- 🗂️ Better Finder performance

## 🤝 Contributing

Contributions are welcome! Please:

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

## 📝 License

This project is licensed under the MIT License. See the [LICENSE](LICENSE) file for details.

## 🆘 Support

If you encounter issues or have suggestions:

- 📧 Submit an [Issue](https://github.com/your-username/CleanYourMac/issues)
- 💬 Join [Discussions](https://github.com/your-username/CleanYourMac/discussions)

## 👨‍💻 About the Author

This project was created by **a middle school student** who is passionate about programming and macOS system optimization. Despite being young, the author has put significant effort into creating a professional-grade cleanup tool that rivals commercial software.

## 🎉 Acknowledgments

Thanks to all contributors and users for their support!

---

**⚠️ Disclaimer:** Please backup important data before use. While this tool is designed to be safe, the author is not responsible for any data loss.