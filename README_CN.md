# 🧹 CleanYourMac - 高级 macOS 系统清理工具

<div align="center">

[![Language](https://img.shields.io/badge/Language-English-blue.svg)](README.md)
[![语言](https://img.shields.io/badge/语言-中文-red.svg)](README_CN.md)

**[🇺🇸 English](README.md) | [🇨🇳 中文](README_CN.md)**

</div>

一个强大的、交互式的 macOS 系统清理实用工具，帮助您安全地清理缓存和垃圾文件。由一名初中生创建。

## 👨 更新

由于我是一名初中生，可能并不能及时更新，尽情谅解

## ✨ 特性

- 🎨 **美观的交互界面** - 彩色终端界面，直观易用
- 🛡️ **安全可靠** - 在删除任何文件前都会询问用户确认
- 📊 **实时大小显示** - 显示每个清理项目的磁盘占用大小
- 🎯 **多选支持** - 通过复选框样式界面一次选择多个清理类别
- 📈 **详细摘要** - 显示清理结果和节省的磁盘空间
- ⚡ **智能检测** - 自动检测已安装的应用程序和开发工具

## 🧹 功能特点

### 自动清理
- 系统和用户缓存文件（早于指定天数）
- 应用程序日志
- 临时文件
- Homebrew 清理和优化
- 垃圾箱（早于指定天数的文件）
- 浏览器缓存（Safari）
- 应用程序缓存（Spotify）
- 开发工具缓存（Xcode、npm、yarn）
- Docker 系统清理
- 系统内存缓存清理

### 应用程序卸载工具
- 扫描已安装的应用程序
- 带交互式选择的搜索功能
- 完整移除应用程序包和相关文件：
  - 应用程序包
  - 用户数据（偏好设置、缓存、保存状态）
  - 系统数据
  - 基于包标识符的文件

### 其他功能
- 双语界面（英文和中文）
- 预览模式，可查看将要清理的内容而不实际删除
- 可配置的保留期限（默认：7天）
- 实时磁盘空间监控
- 交互式彩色终端界面

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

# 可在菜单选项 [3] 中进行交互式语言切换
```

### 交互式菜单

运行脚本后，您将看到一个简单的菜单，包含以下选项：

```
选择功能：

[1] 自动清理
[2] 卸载应用程序
[3] 语言 / Language

输入 1, 2 或 3:
```

### 使用示例

```bash
# 快速启动
./clean_mac.sh

# 使用特定选项运行
./clean_mac.sh --auto         # 直接运行自动清理
./clean_mac.sh --lang=cn      # 使用中文界面
./clean_mac.sh --dry-run      # 预览将要清理的内容而不实际删除
./clean_mac.sh 30             # 保留30天内的文件（默认为7天）

# 选择自动清理后，您会看到：
自动清理模式
这将自动清理所有安全项目，无需逐个确认。
需要确认的项目（下载文件夹、桌面文件）仍会询问权限。

开始自动清理？[y/N]: y
```

## 🛡️ 安全特性

- **确认提示** - 删除任何文件前都会要求确认
- **选择性清理** - 只删除早于指定天数的文件（默认：7天）
- **路径验证** - 验证路径存在性，避免误删
- **错误处理** - 妥善处理权限错误和其他异常
- **受保护路径** - 排除关键系统路径，避免清理

## ⚠️ 注意事项

1. **管理员权限** - 清理系统级缓存需要 sudo 权限
2. **备份重要数据** - 虽然脚本很安全，但建议定期备份重要数据
3. **开发环境** - 清理开发工具缓存可能需要重新下载依赖
4. **Docker 上下文** - 脚本会检查 Docker 上下文，避免清理远程 Docker 实例
5. **基于时间的清理** - 只删除早于指定天数（默认：7天）的文件
6. **Homebrew 包** - 运行清理可能会删除旧版本的包
7. **Xcode 数据** - 清理 Xcode DerivedData 可能需要重新构建项目

## 🔧 系统要求

- macOS 10.12 或更高版本
- Bash 4.0 或更高版本
- 基本的 Unix 工具 (du, rm, sudo)

## 📊 性能提升

使用 CleanYourMac 后，您可能会看到：

- ⚡ 系统启动速度提升
- 💾 释放大量磁盘空间 (通常 1-10GB)
- 🔄 应用程序响应速度改善
- 🚀 清理系统内存缓存后内存使用减少
- 🔧 应用启动速度加快
- 🧹 系统更加整洁，减少杂乱

## 🔍 清理内容说明

CleanYourMac 安全清理：

- **缓存文件** - 应用程序会自动重新创建的临时数据（早于指定天数）
- **日志文件** - 系统和应用程序日志（早于指定天数）
- **临时文件** - 临时目录中不再需要的文件
- **Homebrew** - 旧版本的包和未使用的依赖
- **开发工具缓存** - npm、yarn、Xcode derived data
- **Docker** - 未使用的镜像、容器和卷（仅限本地 Docker 上下文）
- **垃圾箱** - 垃圾箱中的文件（早于指定天数）
- **应用程序数据** - 使用卸载工具时，所有相关的应用程序文件

CleanYourMac **绝不会**删除：

- 个人文档或文件
- 最近的应用程序数据（在指定天数阈值内）
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

本项目由一名初中生创建。感谢所有贡献者和用户的支持！

---

**⚠️ 免责声明：** 请在使用前备份重要数据。虽然本工具设计为安全工具，但作者不对数据丢失承担责任。
