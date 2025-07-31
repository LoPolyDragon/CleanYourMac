# 🧹 CleanYourMac - Advanced macOS System Cleanup Tool

<div align="center">

[![Language](https://img.shields.io/badge/Language-English-blue.svg)](README.md)
[![语言](https://img.shields.io/badge/语言-中文-red.svg)](README_CN.md)

**[🇺🇸 English](README.md) | [🇨🇳 中文](README_CN.md)**

</div>

A powerful, interactive macOS system cleanup utility that helps you safely clean cache and junk files from your system. Created by a middle school student.

## Updates

Since I am a middle school student, I may not be able to update this project in a timely manner. Please understand.

## ✨ Features

- 🎨 **Beautiful Interactive Interface** - Colorful terminal interface that's intuitive and user-friendly
- 🛡️ **Safe & Reliable** - Always asks for confirmation before deleting anything
- 📊 **Real-time Size Display** - Shows disk usage for each cleanup category
- 🎯 **Multi-Selection Support** - Select multiple cleanup categories at once with checkbox-style interface
- 📈 **Detailed Summary** - Shows cleanup results and space saved
- ⚡ **Smart Detection** - Automatically detects installed applications and dev tools
- 🦠 **Virus Scanner** - Comprehensive malware detection and removal
- 📊 **Disk Analysis** - Advanced disk space analysis and large file detection
- 🧹 **Enhanced Cache Cleanup** - Deep cleaning of browser caches, system caches, and temporary files
- 🔒 **Security Features** - Startup item analysis and suspicious file detection

## 🧹 Features

### Auto Cleanup
- System and user cache files (older than configurable days)
- Application logs
- Temporary files
- Homebrew cleanup and optimization
- Trash (files older than configurable days)
- Browser caches (Safari)
- Application caches (Spotify)
- Development tool caches (Xcode, npm, yarn)
- Docker system cleanup
- System memory cache purging

### Application Uninstaller
- Scan installed applications
- Search functionality with interactive selection
- Complete removal of application bundles and related files:
  - Application bundle
  - User data (preferences, caches, saved states)
  - System data
  - Bundle identifier based files
  - Enhanced cache cleanup with comprehensive file search
  - Deep scan for app-related files by name patterns

### Virus Scanner
- Comprehensive malware detection using signature-based scanning
- Suspicious process monitoring
- Startup item analysis for potential threats
- Network connection monitoring
- Real-time threat assessment
- Safe removal of detected malware

### Disk Analysis
- Detailed disk usage breakdown by directories
- Large file detection (>100MB) with interactive deletion
- Cache directory analysis and size reporting
- Duplicate file detection based on file size
- Interactive file management with size calculations
- Comprehensive storage optimization recommendations

### Additional Features
- Bilingual interface (English and Chinese)
- Dry run mode to preview cleanup
- Configurable retention period (default: 7 days)
- Real-time disk space monitoring
- Interactive color-coded terminal interface
- Enhanced browser cache cleanup (Chrome, Firefox, Safari, Edge)
- DNS cache flushing and system optimization
- Font cache cleanup and Launch Services database rebuilding
- Comprehensive system log and crash report cleanup

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

After running the script, you'll see a simple menu with the following options:

```
Select function:

[1] Auto cleanup
[2] Uninstall applications
[3] Virus scan
[4] Disk analysis
[5] Language / 语言

Enter 1-5:
```

### Example Usage

```bash
# Quick start
./clean_mac.sh

# Run with specific options
./clean_mac.sh --auto         # Run auto cleanup directly
./clean_mac.sh --lang=cn      # Use Chinese interface
./clean_mac.sh --dry-run      # Preview what would be cleaned without deleting
./clean_mac.sh 30             # Keep files newer than 30 days (default is 7)

# After selecting auto cleanup, you'll see:
Auto Cleanup Mode
This will automatically clean all safe items without asking for each one.
Items requiring confirmation (Downloads, Desktop files) will still ask for permission.

Start auto cleanup? [y/N]: y
```

## 🛡️ Safety Features

- **Confirmation Prompts** - Always asks before deleting anything
- **Selective Cleaning** - Only removes files older than a specified number of days (default: 7)
- **Path Validation** - Verifies paths exist before attempting cleanup
- **Error Handling** - Gracefully handles permission errors and other issues
- **Protected Paths** - Excludes critical system paths from cleanup

## ⚠️ Important Notes

1. **Admin Privileges** - System-level cache cleanup requires sudo access
2. **Backup Important Data** - While the script is safe, always backup important data
3. **Development Environment** - Cleaning dev tool caches may require re-downloading dependencies
4. **Docker Context** - The script checks Docker context to avoid cleaning remote Docker instances
5. **Age-Based Cleaning** - Only files older than the specified days (default: 7) are removed
6. **Homebrew Packages** - Running cleanup may remove old versions of packages
7. **Xcode Data** - Cleaning Xcode DerivedData may require rebuilding projects

## 🔧 System Requirements

- macOS 10.12 or later
- Bash 4.0 or later
- Basic Unix tools (du, rm, sudo)

## 📊 Performance Benefits

After using CleanYourMac, you may experience:

- ⚡ Faster system startup
- 💾 Significant disk space recovery (typically 1-10GB)
- 🔄 Improved application responsiveness
- 🚀 Reduced memory usage after purging system memory cache
- 🔧 Faster app launches
- 🧹 More organized system with less clutter

## 🔍 What Gets Cleaned

CleanYourMac safely removes:

- **Cache Files** - Temporary data that apps recreate automatically (older than specified days)
- **Log Files** - System and application logs (older than specified days)
- **Temporary Files** - Files in temp directories that are no longer needed
- **Homebrew** - Old versions of packages and unused dependencies
- **Development Tool Caches** - npm, yarn, Xcode derived data
- **Docker** - Unused images, containers, and volumes (only for local Docker contexts)
- **Trash** - Files in the trash (older than specified days)
- **Application Data** - When using the uninstaller, all related application files

CleanYourMac **NEVER** removes:
- Personal documents or files
- Recent application data (within the specified days threshold)
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

This project was created by a middle school student. Thanks to all contributors and users for their support!

---

**⚠️ Disclaimer:** Please backup important data before use. While this tool is designed to be safe, the author is not responsible for any data loss.
