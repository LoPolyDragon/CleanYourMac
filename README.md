# 🧼 CleanMac - macOS System Cleanup Tool

<div align="center">

[![Language](https://img.shields.io/badge/Language-English-blue.svg)](README.md)
[![语言](https://img.shields.io/badge/语言-中文-red.svg)](README_CN.md)

**[🇺🇸 English](README.md) | [🇨🇳 中文](README_CN.md)**

</div>

A powerful, interactive macOS system cleanup utility that helps you safely clean cache and junk files from your system.

## Updates

Since I am a middle school student, I may not be able to update this project in a timely manner. Please understand.

## ✨ Features

- 🎨 **Beautiful Interactive Interface** - Colorful terminal interface that's intuitive and user-friendly
- 🛡️ **Safe & Reliable** - Always asks for confirmation before deleting anything
- 📊 **Real-time Size Display** - Shows disk usage for each cleanup category
- 🎯 **Multi-Selection Support** - Select multiple cleanup categories at once with checkbox-style interface
- 📈 **Detailed Summary** - Shows cleanup results and space saved
- ⚡ **Smart Detection** - Automatically detects installed applications and dev tools

## 🧹 Cleanup Categories

### 1. User-Level Caches & Logs
- User application caches (`~/Library/Caches`)
- User application logs (`~/Library/Logs`)
- Crash reports (`~/Library/Application Support/CrashReporter`)
- Saved application states (`~/Library/Saved Application State`)
- Shared file lists (`~/Library/Application Support/com.apple.sharedfilelist`)
- QuickLook thumbnails (`~/Library/Caches/com.apple.QuickLook.thumbnailcache`)
- Font cache (`~/Library/Caches/com.apple.ATS`)

### 2. System-Level Caches (Requires Admin)
- System application caches (`/Library/Caches`)
- System temporary files (`/private/var/folders`)
- System logs (`/private/var/log`)
- System diagnostic reports (`/Library/Logs/DiagnosticReports`)
- Kernel extension cache (`/System/Library/Caches/com.apple.kext.caches`)
- Launch services database (`/Library/Caches/com.apple.LaunchServices`)

### 3. Browser Caches
- **Safari** - Cache files, cookies, history, downloads
- **Google Chrome** - Cache, application cache, cookies, history
- **Firefox** - Cache for all profiles, cookies, history
- **Microsoft Edge** - Cache and browsing data
- **Opera** - Cache and temporary files

### 4. Development Tools
- **Xcode** - DerivedData, Archives, iOS Device Support, CoreSimulator caches
- **Visual Studio Code** - Logs and cached data
- **npm/Node.js** - npm cache and node-gyp cache
- **Homebrew** - Package cache and cleanup
- **Python pip** - pip cache
- **Rust Cargo** - Cargo cache
- **Docker** - Images, containers, and build cache
- **Git** - Global git cache and temporary files
- **CocoaPods** - Pod cache and specs

### 5. Application Caches
- Adobe Media Cache and temporary files
- Zoom cache and logs
- Discord cache and logs
- Spotify cache
- Slack cache and logs
- Microsoft Teams cache
- Dropbox cache
- Google Drive cache
- OneDrive cache
- Steam cache
- VLC media cache

### 6. Trash & Miscellaneous
- User Trash (`~/.Trash`)
- External drive trash (`/Volumes/*/.Trashes`)
- iOS device backups (`~/Library/Application Support/MobileSync/Backup`)
- Downloads folder (use with caution)
- Desktop screenshots
- Mail attachments cache
- iMessage attachments cache

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

### Interactive Menu with Direct Multi-Selection

After running the script, you can directly input numbers to clean multiple categories:

```
Select cleanup categories:

[1] User-level caches & logs
[2] System-level caches (requires admin)
[3] Browser caches
[4] Development tools
[5] Application caches
[6] Trash & miscellaneous
[7] Select all (clean everything)
[8] Language / Exit

Tip: Enter numbers to select cleanup items, separate with spaces

Enter numbers (multi-select with spaces, e.g.: 1 3 5) or 8 for language menu:
```

### Example Usage

```bash
# Quick start
./clean_mac.sh

# Direct multi-selection examples:
1 3 5          # Clean user caches, browser caches, and app caches
7              # Clean everything (all categories)
2              # Clean only system caches
1 2 3 4 5 6    # Clean all categories manually

# After selection, you'll see confirmation and then prompts like:
Items to be cleaned:
  ✅ User-level caches & logs
  ✅ Browser caches
  ✅ Application caches

Confirm to start cleaning the above items? [y/N]: y

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
5. **Browser Data** - Cleaning browser caches will log you out of websites and remove saved passwords if not synced
6. **iOS Backups** - Removing iOS device backups will prevent restoring from local backups
7. **Xcode Data** - Cleaning Xcode DerivedData may require rebuilding projects
8. **Docker Images** - Cleaning Docker cache will remove downloaded images and require re-downloading

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
- 🚀 Reduced memory usage
- 🔧 Faster app launches
- 📱 Better iOS device sync performance

## 🔍 What Gets Cleaned

CleanMac safely removes:

- **Cache Files** - Temporary data that apps recreate automatically
- **Log Files** - System and application logs (keeping recent ones)
- **Temporary Files** - Files in temp directories that are no longer needed
- **Thumbnails** - Preview images that can be regenerated
- **Download History** - Browser download records (not the actual files)
- **Crash Reports** - Old crash dumps and diagnostic data
- **Build Artifacts** - Compiled code that can be rebuilt

CleanMac **NEVER** removes:
- Personal documents or files
- Application preferences or settings
- Passwords or keychain data
- Photos, music, or media files
- Active project files

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

## 🎉 Acknowledgments

Thanks to all contributors and users for their support!

---

**⚠️ Disclaimer:** Please backup important data before use. While this tool is designed to be safe, the author is not responsible for any data loss.