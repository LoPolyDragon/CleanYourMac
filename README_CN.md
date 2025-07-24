# 🧼 CleanMac - macOS 系统清理工具

<div align="center">

[![Language](https://img.shields.io/badge/Language-English-blue.svg)](README.md)
[![语言](https://img.shields.io/badge/语言-中文-red.svg)](README_CN.md)

**[🇺🇸 English](README.md) | [🇨🇳 中文](README_CN.md)**

</div>

一个强大的、交互式的 macOS 系统清理实用工具，帮助您安全地清理缓存和垃圾文件。

## ✨ 特性

- 🎨 **美观的交互界面** - 彩色终端界面，直观易用
- 🛡️ **安全可靠** - 在删除任何文件前都会询问用户确认
- 📊 **实时大小显示** - 显示每个清理项目的磁盘占用大小
- 🎯 **模块化清理** - 可选择性清理不同类别的文件
- 📈 **详细摘要** - 显示清理结果和节省的磁盘空间
- ⚡ **智能检测** - 自动检测已安装的应用程序和开发工具

## 🧹 清理类别

### 1. 用户级缓存和日志
- 用户应用程序缓存 (`~/Library/Caches`)
- 用户应用程序日志 (`~/Library/Logs`)
- 崩溃报告 (`~/Library/Application Support/CrashReporter`)
- 保存的应用程序状态 (`~/Library/Saved Application State`)
- 共享文件列表 (`~/Library/Application Support/com.apple.sharedfilelist`)

### 2. 系统级缓存 (需要管理员权限)
- 系统应用程序缓存 (`/Library/Caches`)
- 系统临时文件 (`/private/var/folders`)
- 系统日志 (`/private/var/log`)
- 系统诊断报告 (`/Library/Logs/DiagnosticReports`)

### 3. 浏览器缓存
- **Safari** - 缓存文件
- **Google Chrome** - 缓存和应用程序缓存
- **Firefox** - 所有配置文件的缓存

### 4. 开发工具
- **Xcode** - DerivedData、Archives、iOS Device Support、CoreSimulator 缓存
- **Visual Studio Code** - 日志和缓存数据
- **npm/Node.js** - npm 缓存和 node-gyp 缓存
- **Homebrew** - 包缓存和清理
- **Python pip** - pip 缓存
- **Rust Cargo** - Cargo 缓存

### 5. 应用程序缓存
- Adobe Media Cache
- Zoom 缓存
- Discord 缓存
- Spotify 缓存
- Slack 缓存
- Microsoft Teams 缓存

### 6. 垃圾箱和其他
- 用户垃圾箱
- 外部驱动器垃圾箱
- iOS 设备备份
- 下载文件夹 (谨慎操作)

## 🚀 使用方法

### 基本使用

1. **下载脚本**
   ```bash
   git clone https://github.com/your-username/CleanYourMac.git
   cd CleanYourMac
   ```

2. **添加执行权限**
   ```bash
   chmod +x clean_mac.sh
   ```

3. **运行脚本**
   ```bash
   ./clean_mac.sh
   ```

### 语言支持

脚本支持中英文界面：

```bash
# 使用英文界面运行（默认）
./clean_mac.sh --lang=en

# 使用中文界面运行
./clean_mac.sh --lang=cn

# 可在菜单选项 [8] 中进行交互式语言切换
```

### 交互式菜单

运行脚本后，您将看到以下菜单选项：

```
[1] 用户级缓存和日志
[2] 系统级缓存 (需要管理员权限)
[3] 浏览器缓存
[4] 开发工具
[5] 应用程序缓存
[6] 垃圾箱和其他
[7] 清理所有项目 (交互式)
[8] 退出
```

### 使用示例

```bash
# 快速启动
./clean_mac.sh

# 对于每个清理项目，您将看到如下提示：
User application caches
  → Path: /Users/username/Library/Caches
  → Size: 2.3GB
Do you want to clean this? [y/N]: y
🧹 Cleaning...
✅ Cleaned: User application caches (2.3GB freed)
```

## 🛡️ 安全特性

- **确认提示** - 删除任何文件前都会要求确认
- **大小显示** - 显示每个项目占用的磁盘空间
- **路径验证** - 验证路径存在性，避免误删
- **错误处理** - 妥善处理权限错误和其他异常
- **只读检查** - 不会删除系统关键文件

## ⚠️ 注意事项

1. **管理员权限** - 清理系统级缓存需要 sudo 权限
2. **备份重要数据** - 虽然脚本很安全，但建议定期备份重要数据
3. **开发环境** - 清理开发工具缓存可能需要重新下载依赖
4. **应用程序设置** - 某些应用可能需要重新配置偏好设置

## 🔧 系统要求

- macOS 10.12 或更高版本
- Bash 4.0 或更高版本
- 基本的 Unix 工具 (du, rm, sudo)

## 📊 性能提升

使用 CleanMac 后，您可能会看到：

- ⚡ 系统启动速度提升
- 💾 释放大量磁盘空间 (通常 1-10GB)
- 🔄 应用程序响应速度改善
- 🗂️ Finder 性能提升

## 🤝 贡献

欢迎贡献代码！请：

1. Fork 本仓库
2. 创建功能分支 (`git checkout -b feature/amazing-feature`)
3. 提交更改 (`git commit -m 'Add amazing feature'`)
4. 推送到分支 (`git push origin feature/amazing-feature`)
5. 创建 Pull Request

## 📝 许可证

本项目采用 MIT 许可证。详见 [LICENSE](LICENSE) 文件。

## 🆘 支持

如果您遇到问题或有建议：

- 📧 提交 [Issue](https://github.com/your-username/CleanYourMac/issues)
- 💬 参与 [Discussions](https://github.com/your-username/CleanYourMac/discussions)

## 👨‍💻 关于作者

这个项目是由一名**初中生**开发的，他对编程和 macOS 系统优化充满热情。尽管年纪尚小，但作者投入了大量精力来创建一个专业级的清理工具，能够媲美商业软件。

## 🎉 致谢

感谢所有贡献者和用户的支持！

---

**⚠️ 免责声明：** 请在使用前备份重要数据。虽然本工具设计为安全工具，但作者不对数据丢失承担责任。