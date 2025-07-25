# 🧼 CleanMac - macOS 系统清理工具

<div align="center">

[![Language](https://img.shields.io/badge/Language-English-blue.svg)](README.md)
[![语言](https://img.shields.io/badge/语言-中文-red.svg)](README_CN.md)

**[🇺🇸 English](README.md) | [🇨🇳 中文](README_CN.md)**

</div>

一个强大的、交互式的 macOS 系统清理实用工具，帮助您安全地清理缓存和垃圾文件。

## 👨 更新

由于我是一名初中生，可能并不能及时更新，尽情谅解

## ✨ 特性

- 🎨 **美观的交互界面** - 彩色终端界面，直观易用
- 🛡️ **安全可靠** - 在删除任何文件前都会询问用户确认
- 📊 **实时大小显示** - 显示每个清理项目的磁盘占用大小
- 🎯 **多选支持** - 通过复选框样式界面一次选择多个清理类别
- 📈 **详细摘要** - 显示清理结果和节省的磁盘空间
- ⚡ **智能检测** - 自动检测已安装的应用程序和开发工具

## 🧹 清理类别

### 1. 用户级缓存和日志

- 用户应用程序缓存 (`~/Library/Caches`)
- 用户应用程序日志 (`~/Library/Logs`)
- 崩溃报告 (`~/Library/Application Support/CrashReporter`)
- 保存的应用程序状态 (`~/Library/Saved Application State`)
- 共享文件列表 (`~/Library/Application Support/com.apple.sharedfilelist`)
- QuickLook 缩略图 (`~/Library/Caches/com.apple.QuickLook.thumbnailcache`)
- 字体缓存 (`~/Library/Caches/com.apple.ATS`)

### 2. 系统级缓存 (需要管理员权限)

- 系统应用程序缓存 (`/Library/Caches`)
- 系统临时文件 (`/private/var/folders`)
- 系统日志 (`/private/var/log`)
- 系统诊断报告 (`/Library/Logs/DiagnosticReports`)
- 内核扩展缓存 (`/System/Library/Caches/com.apple.kext.caches`)
- 启动服务数据库 (`/Library/Caches/com.apple.LaunchServices`)

### 3. 浏览器缓存

- **Safari** - 缓存文件、Cookie、历史记录、下载记录
- **Google Chrome** - 缓存、应用程序缓存、Cookie、历史记录
- **Firefox** - 所有配置文件的缓存、Cookie、历史记录
- **Microsoft Edge** - 缓存和浏览数据
- **Opera** - 缓存和临时文件

### 4. 开发工具

- **Xcode** - DerivedData、Archives、iOS Device Support、CoreSimulator 缓存
- **Visual Studio Code** - 日志和缓存数据
- **npm/Node.js** - npm 缓存和 node-gyp 缓存
- **Homebrew** - 包缓存和清理
- **Python pip** - pip 缓存
- **Rust Cargo** - Cargo 缓存
- **Docker** - 镜像、容器和构建缓存
- **Git** - 全局 git 缓存和临时文件
- **CocoaPods** - Pod 缓存和规范

### 5. 应用程序缓存

- Adobe Media Cache 和临时文件
- Zoom 缓存和日志
- Discord 缓存和日志
- Spotify 缓存
- Slack 缓存和日志
- Microsoft Teams 缓存
- Dropbox 缓存
- Google Drive 缓存
- OneDrive 缓存
- Steam 缓存
- VLC 媒体缓存

### 6. 垃圾箱和其他

- 用户垃圾箱 (`~/.Trash`)
- 外部驱动器垃圾箱 (`/Volumes/*/.Trashes`)
- iOS 设备备份 (`~/Library/Application Support/MobileSync/Backup`)
- 下载文件夹 (谨慎操作)
- 桌面截图
- 邮件附件缓存
- iMessage 附件缓存

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

### 直接多选的交互式菜单

运行脚本后，您可以直接输入数字来清理多个类别：

```
选择清理类别：

[1] 用户级缓存和日志
[2] 系统级缓存 (需要管理员权限)
[3] 浏览器缓存
[4] 开发工具
[5] 应用程序缓存
[6] 垃圾箱和其他
[7] 全选 (清理所有项目)
[8] 语言 / 退出

提示：输入数字选择清理项目，多个数字用空格分隔

输入数字（可多选，用空格分隔，如: 1 3 5）或 8 进入语言菜单:
```

### 使用示例

```bash
# 快速启动
./clean_mac.sh

# 直接多选示例：
1 3 5          # 清理用户缓存、浏览器缓存和应用缓存
7              # 清理所有项目（全选）
2              # 仅清理系统缓存
1 2 3 4 5 6    # 手动清理所有类别

# 选择后，您会看到确认信息，然后是具体的清理提示：
将要清理的项目：
  ✅ 用户级缓存和日志
  ✅ 浏览器缓存
  ✅ 应用程序缓存

确认开始清理以上项目？[y/N]: y

User application caches
  → Path: /Users/username/Library/Caches
  → Size: 2.3GB
您要清理这个吗？[y/N]: y
🧹 正在清理...
✅ 已清理: User application caches (2.3GB 已释放)
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
5. **浏览器数据** - 清理浏览器缓存会使您退出网站登录，如未同步会删除保存的密码
6. **iOS 备份** - 删除 iOS 设备备份将无法从本地备份恢复
7. **Xcode 数据** - 清理 Xcode DerivedData 可能需要重新构建项目
8. **Docker 镜像** - 清理 Docker 缓存会删除下载的镜像，需要重新下载

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
- 🚀 减少内存使用
- 🔧 应用启动速度加快
- 📱 iOS 设备同步性能改善

## 🔍 清理内容说明

CleanMac 安全清理：

- **缓存文件** - 应用程序会自动重新创建的临时数据
- **日志文件** - 系统和应用程序日志（保留最近的）
- **临时文件** - 临时目录中不再需要的文件
- **缩略图** - 可以重新生成的预览图像
- **下载历史** - 浏览器下载记录（不是实际文件）
- **崩溃报告** - 旧的崩溃转储和诊断数据
- **构建产物** - 可以重新构建的编译代码

CleanMac **绝不会**删除：

- 个人文档或文件
- 应用程序偏好设置或配置
- 密码或钥匙串数据
- 照片、音乐或媒体文件
- 活跃的项目文件

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

## 🎉 致谢

感谢所有贡献者和用户的支持！

---

**⚠️ 免责声明：** 请在使用前备份重要数据。虽然本工具设计为安全工具，但作者不对数据丢失承担责任。
