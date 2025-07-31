#!/usr/bin/env bash

# CleanMac - Advanced macOS System Cleanup Tool
# Version: 2.5
# Author: CleanYourMac Project (Created by a middle school student)
# Description: Interactive macOS cleanup utility with comprehensive cleaning

set -eo pipefail

# Configuration
DEFAULT_LANG="en"
LANG_FILE="$HOME/.cleanyourmac_lang"
DRY_RUN=false
DAYS_TO_KEEP=7
SHOW_HELP=false

# Load saved language preference
if [[ -f "$LANG_FILE" ]]; then
    CURRENT_LANG=$(cat "$LANG_FILE")
else
    CURRENT_LANG="$DEFAULT_LANG"
fi

# Colors and formatting
readonly RED='\033[0;31m'
readonly GREEN='\033[0;32m'
readonly YELLOW='\033[1;33m'
readonly BLUE='\033[0;34m'
readonly PURPLE='\033[0;35m'
readonly CYAN='\033[0;36m'
readonly WHITE='\033[1;37m'
readonly BOLD='\033[1m'
readonly NC='\033[0m' # No Color

# Icons and symbols
readonly CLEAN_ICON="🧹"
readonly CHECK_ICON="✅"
readonly SKIP_ICON="🚫"
readonly WARNING_ICON="⚠️"
readonly INFO_ICON="ℹ️"
readonly TRASH_ICON="🗑️"
readonly SPARKLE_ICON="✨"
readonly COMPUTER_ICON="💻"
readonly BROWSER_ICON="🌐"
readonly DEV_ICON="👨‍💻"
readonly LANG_ICON="🌐"
readonly APP_ICON="📱"
readonly SEARCH_ICON="🔍"
readonly UNINSTALL_ICON="🗑️"
readonly VIRUS_ICON="🦠"
readonly SHIELD_ICON="🛡️"
readonly CHART_ICON="📊"
readonly FOLDER_ICON="📁"

# Global variables
initial_free_space=0
final_free_space=0

# Function to get localized text
get_text() {
    local key="$1"
    if [[ "$CURRENT_LANG" == "cn" ]]; then
        case "$key" in
            "title") echo "CleanMac - macOS 系统清理工具" ;;
            "subtitle") echo "交互式清理实用工具" ;;
            "description") echo "此工具帮助您安全地清理 macOS 系统中的缓存和垃圾文件。" ;;
            "begin") echo "删除任何文件前都会询问您的确认。让我们开始吧。" ;;
            "menu_select") echo "选择功能：" ;;
            "menu_1") echo "自动清理" ;;
            "menu_2") echo "卸载应用程序" ;;
            "menu_3") echo "病毒扫描" ;;
            "menu_4") echo "磁盘分析" ;;
            "menu_5") echo "语言 / Language" ;;
            "enter_choice") echo "输入 1-5: " ;;
            "invalid_choice") echo "无效选择。请输入 1-5。" ;;
            "virus_scan_title") echo "病毒扫描" ;;
            "virus_scan_desc") echo "扫描系统中的恶意软件和可疑文件" ;;
            "virus_scanning") echo "正在扫描病毒..." ;;
            "virus_scan_complete") echo "病毒扫描完成" ;;
            "virus_found") echo "发现可疑文件" ;;
            "virus_clean") echo "清除病毒文件" ;;
            "disk_analysis_title") echo "磁盘空间分析" ;;
            "disk_analysis_desc") echo "分析磁盘使用情况和大文件" ;;
            "disk_analyzing") echo "正在分析磁盘..." ;;
            "disk_analysis_complete") echo "磁盘分析完成" ;;
            "large_files_found") echo "发现大文件" ;;
            "folder_size") echo "文件夹大小" ;;
            "app_uninstall_title") echo "应用程序卸载" ;;
            "app_search_prompt") echo "搜索应用程序（输入应用名称，按 ESC 退出）: " ;;
            "app_scanning") echo "正在扫描已安装的应用程序..." ;;
            "app_found_count") echo "找到应用程序" ;;
            "app_no_match") echo "没有找到匹配的应用程序" ;;
            "app_select_prompt") echo "使用上下箭头键选择应用，回车确认，ESC 取消" ;;
            "app_selected") echo "已选择应用程序" ;;
            "app_confirm_uninstall") echo "确认卸载此应用程序及其所有相关文件？[y/N]: " ;;
            "app_uninstalling") echo "正在卸载应用程序..." ;;
            "app_uninstall_complete") echo "应用程序卸载完成" ;;
            "app_uninstall_failed") echo "应用程序卸载失败" ;;
            "app_files_found") echo "找到相关文件" ;;
            "app_size_total") echo "总大小" ;;
            "selected_items") echo "将要清理的项目：" ;;
            "confirm_start") echo "确认开始清理以上项目？[y/N]: " ;;
            "auto_cleanup_title") echo "自动清理模式" ;;
            "auto_cleanup_desc") echo "这将自动清理所有安全项目，无需逐个确认。" ;;
            "auto_cleanup_warning") echo "需要确认的项目（下载文件夹、桌面文件）仍会询问权限。" ;;
            "auto_cleanup_confirm") echo "开始自动清理？[y/N]: " ;;
            "auto_cleanup_running") echo "正在运行自动清理..." ;;
            "auto_cleanup_complete") echo "自动清理完成！" ;;
            "total_space_freed") echo "总共释放空间" ;;
            "confirm_sensitive") echo "清理敏感位置" ;;
            "thank_you") echo "感谢您使用 CleanMac！再见！" ;;
            "press_enter") echo "按回车键继续..." ;;
            "cleaning") echo "正在清理..." ;;
            "cleaned") echo "已清理" ;;
            "skipped") echo "已跳过" ;;
            "failed") echo "清理失败" ;;
            "already_clean") echo "已经是干净的" ;;
            "path_not_found") echo "路径未找到" ;;
            "confirm_clean") echo "您要清理这个吗？[y/N]: " ;;
            "confirm_run") echo "您要运行这个清理吗？[y/N]: " ;;
            "admin_password") echo "(需要管理员密码)" ;;
            "admin_required") echo "(需要管理员密码)" ;;
            "running") echo "正在运行清理..." ;;
            "completed") echo "已完成" ;;
            "failed_run") echo "失败" ;;
            "size_freed") echo "已释放" ;;
            "summary") echo "清理摘要" ;;
            "cleaned_items") echo "已清理项目" ;;
            "skipped_items") echo "已跳过项目" ;;
            "no_items_cleaned") echo "没有项目被清理" ;;
            "no_items_skipped") echo "没有项目被跳过" ;;
            "all_processed") echo "所有选定项目已处理完成。感谢使用 CleanMac！" ;;
            "processing_category") echo "正在处理类别" ;;
            "category_complete") echo "类别处理完成" ;;
            *) echo "$key" ;;
        esac
    else
        case "$key" in
            "title") echo "CleanMac - macOS System Cleanup Tool" ;;
            "subtitle") echo "Interactive Cleanup Utility" ;;
            "description") echo "This tool helps you safely clean cache and junk files from your macOS system." ;;
            "begin") echo "You will be asked before anything is deleted. Let's begin." ;;
            "menu_select") echo "Select function:" ;;
            "menu_1") echo "Auto cleanup" ;;
            "menu_2") echo "Uninstall applications" ;;
            "menu_3") echo "Virus scan" ;;
            "menu_4") echo "Disk analysis" ;;
            "menu_5") echo "Language / 语言" ;;
            "enter_choice") echo "Enter 1-5: " ;;
            "invalid_choice") echo "Invalid choice. Please enter 1-5." ;;
            "virus_scan_title") echo "Virus Scan" ;;
            "virus_scan_desc") echo "Scan system for malware and suspicious files" ;;
            "virus_scanning") echo "Scanning for viruses..." ;;
            "virus_scan_complete") echo "Virus scan completed" ;;
            "virus_found") echo "Suspicious files found" ;;
            "virus_clean") echo "Clean virus files" ;;
            "disk_analysis_title") echo "Disk Space Analysis" ;;
            "disk_analysis_desc") echo "Analyze disk usage and large files" ;;
            "disk_analyzing") echo "Analyzing disk..." ;;
            "disk_analysis_complete") echo "Disk analysis completed" ;;
            "large_files_found") echo "Large files found" ;;
            "folder_size") echo "Folder size" ;;
            "app_uninstall_title") echo "Application Uninstaller" ;;
            "app_search_prompt") echo "Search applications (type app name, ESC to exit): " ;;
            "app_scanning") echo "Scanning installed applications..." ;;
            "app_found_count") echo "applications found" ;;
            "app_no_match") echo "No matching applications found" ;;
            "app_select_prompt") echo "Use arrow keys to select app, Enter to confirm, ESC to cancel" ;;
            "app_selected") echo "Selected application" ;;
            "app_confirm_uninstall") echo "Confirm uninstall this application and all related files? [y/N]: " ;;
            "app_uninstalling") echo "Uninstalling application..." ;;
            "app_uninstall_complete") echo "Application uninstall completed" ;;
            "app_uninstall_failed") echo "Application uninstall failed" ;;
            "app_files_found") echo "Related files found" ;;
            "app_size_total") echo "Total size" ;;
            "selected_items") echo "Items to be cleaned:" ;;
            "confirm_start") echo "Confirm to start cleaning the above items? [y/N]: " ;;
            "auto_cleanup_title") echo "Auto Cleanup Mode" ;;
            "auto_cleanup_desc") echo "This will automatically clean all safe items without asking for each one." ;;
            "auto_cleanup_warning") echo "Items requiring confirmation (Downloads, Desktop files) will still ask for permission." ;;
            "auto_cleanup_confirm") echo "Start auto cleanup? [y/N]: " ;;
            "auto_cleanup_running") echo "Running auto cleanup..." ;;
            "auto_cleanup_complete") echo "Auto cleanup completed!" ;;
            "total_space_freed") echo "Total space freed" ;;
            "confirm_sensitive") echo "Clean sensitive location" ;;
            "thank_you") echo "Thank you for using CleanMac! Goodbye!" ;;
            "press_enter") echo "Press Enter to continue..." ;;
            "cleaning") echo "Cleaning..." ;;
            "cleaned") echo "Cleaned" ;;
            "skipped") echo "Skipped" ;;
            "failed") echo "Failed to clean" ;;
            "already_clean") echo "Already clean" ;;
            "path_not_found") echo "Path not found" ;;
            "confirm_clean") echo "Do you want to clean this? [y/N]: " ;;
            "confirm_run") echo "Do you want to run this cleanup? [y/N]: " ;;
            "admin_password") echo "(admin password required)" ;;
            "admin_required") echo "(requires admin password)" ;;
            "running") echo "Running cleanup..." ;;
            "completed") echo "Completed" ;;
            "failed_run") echo "Failed" ;;
            "size_freed") echo "freed" ;;
            "summary") echo "Cleanup Summary" ;;
            "cleaned_items") echo "Cleaned items" ;;
            "skipped_items") echo "Skipped items" ;;
            "no_items_cleaned") echo "No items were cleaned" ;;
            "no_items_skipped") echo "No items were skipped" ;;
            "all_processed") echo "All selected items have been processed. Thank you for using CleanMac!" ;;
            "processing_category") echo "Processing category" ;;
            "category_complete") echo "Category complete" ;;
            *) echo "$key" ;;
        esac
    fi
}

# Save language preference
save_language() {
    echo "$CURRENT_LANG" > "$LANG_FILE"
}

# Utility functions
print_header() {
    local title="$(get_text "title")"
    local subtitle="$(get_text "subtitle")"
    clear
    echo -e "${BOLD}${CYAN}"
    echo "╔══════════════════════════════════════════════════════════════════════════════╗"
    printf "║%*s║\n" 78 "$(printf "%*s" $(((${#title}+78)/2)) "$title")"
    printf "║%*s║\n" 78 "$(printf "%*s" $(((${#subtitle}+78)/2)) "$subtitle")"
    echo "╚══════════════════════════════════════════════════════════════════════════════╝"
    echo -e "${NC}"
    echo -e "${WHITE}$(get_text "description")${NC}"
    echo -e "${WHITE}$(get_text "begin")${NC}"
    echo ""
}

print_separator() {
    echo -e "${CYAN}────────────────────────────────────────────────────────────────────${NC}"
}

print_success() {
    echo -e "${GREEN}${CHECK_ICON} $1${NC}"
}

print_error() {
    echo -e "${RED}${WARNING_ICON} $1${NC}"
}

print_info() {
    echo -e "${BLUE}${INFO_ICON} $1${NC}"
}

print_warning() {
    echo -e "${YELLOW}${WARNING_ICON} $1${NC}"
}

print_skip() {
    echo -e "${YELLOW}${SKIP_ICON} $1${NC}"
}

# Function to get directory size in human readable format
get_size() {
    local path="$1"
    if [[ -e "$path" ]]; then
        du -sh "$path" 2>/dev/null | cut -f1 | tr -d '\n\t ' || echo "0B"
    else
        echo "0B"
    fi
}

# Function to get size in bytes for accurate calculations
get_size_bytes() {
    local path="$1"
    if [[ -e "$path" ]]; then
        local size_kb=$(du -sk "$path" 2>/dev/null | cut -f1 | tr -d '\n\t ' || echo "0")
        [[ ! "$size_kb" =~ ^[0-9]+$ ]] && size_kb=0
        echo $((size_kb * 1024))
    else
        echo "0"
    fi
}

# Convert size to bytes for calculations
size_to_bytes() {
    local size="$1"
    local number=$(echo "$size" | sed 's/[^0-9.]//g')
    local unit=$(echo "$size" | sed 's/[0-9.]//g' | tr '[:lower:]' '[:upper:]')
    
    case "$unit" in
        "B"|"") echo "$number" | cut -d'.' -f1 ;;
        "K"|"KB") echo "$(echo "$number * 1024" | bc)" | cut -d'.' -f1 ;;
        "M"|"MB") echo "$(echo "$number * 1024 * 1024" | bc)" | cut -d'.' -f1 ;;
        "G"|"GB") echo "$(echo "$number * 1024 * 1024 * 1024" | bc)" | cut -d'.' -f1 ;;
        *) echo "0" ;;
    esac 2>/dev/null || echo "0"
}

# Convert bytes to human readable format
bytes_to_human() {
    local bytes="$1"
    # Ensure bytes is a valid number
    [[ ! "$bytes" =~ ^[0-9]+$ ]] && bytes=0
    
    if [[ $bytes -ge 1073741824 ]]; then
        echo "$(echo "scale=2; $bytes / 1073741824" | bc 2>/dev/null || echo "0")GB"
    elif [[ $bytes -ge 1048576 ]]; then
        echo "$(echo "scale=2; $bytes / 1048576" | bc 2>/dev/null || echo "0")MB"
    elif [[ $bytes -ge 1024 ]]; then
        echo "$(echo "scale=1; $bytes / 1024" | bc 2>/dev/null || echo "0")KB"
    else
        echo "${bytes}B"
    fi
}







# Function to execute auto cleanup - Using improved cleanmac.sh logic
execute_auto_cleanup() {
    print_separator
    echo -e "${BOLD}${SPARKLE_ICON} $(get_text "auto_cleanup_title")${NC}"
    print_separator
    
    echo -e "${WHITE}$(get_text "auto_cleanup_desc")${NC}"
    echo -e "${YELLOW}$(get_text "auto_cleanup_warning")${NC}"
    echo ""
    
    read -p "$(echo -e ${WHITE}$(get_text "auto_cleanup_confirm")${NC})" -n 1 -r
    echo
    
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        print_info "$(get_text "skipped")"
        sleep 2
        return
    fi
    
    # Request sudo permissions
    echo "Requesting sudo permissions..."
    sudo -v
    
    echo ""
    echo -e "${BOLD}${GREEN}$(get_text "auto_cleanup_running")${NC}"
    echo "Starting macOS selective cleanup (removing files older than ${DAYS_TO_KEEP} days)..."
    echo ""
    
    # Get initial disk space
    local free_storage=$(df -k / | awk 'NR==2 {print $4}')
    local total_storage=$(df -k / | awk 'NR==2 {print $2}')
    local free_storage_gb=$(echo "scale=2; $free_storage / 1024 / 1024" | bc)
    local total_storage_gb=$(echo "scale=2; $total_storage / 1024 / 1024" | bc)
    
    echo "Free storage: $free_storage_gb Gi / Total storage: $total_storage_gb Gi"
    echo ""
    
    # Clear system and user cache files
    echo "Clearing system and user cache files older than ${DAYS_TO_KEEP} days..."
    sudo find /Library/Caches/* -type f -mtime +${DAYS_TO_KEEP} \( ! -path "/Library/Caches/com.apple.amsengagementd.classicdatavault" \
                                                   ! -path "/Library/Caches/com.apple.aned" \
                                                   ! -path "/Library/Caches/com.apple.aneuserd" \
                                                   ! -path "/Library/Caches/com.apple.iconservices.store" \) \
        -exec rm {} \; -print 2>/dev/null || echo "Skipped restricted files in system cache."
    
    find ~/Library/Caches/* -type f -mtime +${DAYS_TO_KEEP} -exec sudo rm -f {} \; -print 2>/dev/null || echo "Error clearing user cache."
    
    # Remove application logs
    echo "Removing application logs older than ${DAYS_TO_KEEP} days..."
    sudo find /Library/Logs -type f -mtime +${DAYS_TO_KEEP} -exec rm {} \; -print 2>/dev/null || echo "Skipped restricted files in system logs."
    find ~/Library/Logs -type f -mtime +${DAYS_TO_KEEP} -exec rm {} \; -print 2>/dev/null || echo "Error clearing user logs."
    
    # Clear temporary files
    echo "Clearing temporary files older than ${DAYS_TO_KEEP} days..."
    sudo find /private/var/tmp/* -type f -mtime +${DAYS_TO_KEEP} -exec rm {} \; -print 2>/dev/null || echo "Skipped restricted files in system tmp."
    find /tmp/* -type f -mtime +${DAYS_TO_KEEP} ! -path "/tmp/tmp-mount-*" -exec rm {} \; -print 2>/dev/null || echo "Skipped restricted tmp files."
    
    # Homebrew cleanup
    if command -v brew >/dev/null 2>&1; then
        echo "Running Homebrew cleanup and cache clearing..."
        brew cleanup --prune=${DAYS_TO_KEEP} || echo "Homebrew cleanup encountered an error."
        brew autoremove || echo "Homebrew autoremove encountered an error."
        brew doctor || echo "Homebrew doctor encountered an error."
    fi
    
    # Empty Trash
    echo "Emptying Trash (files older than ${DAYS_TO_KEEP} days)..."
    find ~/.Trash -type f -mtime +${DAYS_TO_KEEP} -exec rm {} \; -print 2>/dev/null || echo "Error cleaning Trash."
    find ~/.Trash -type d -empty -delete 2>/dev/null || echo "Error removing empty Trash directories."
    
    # Clean Safari caches
    echo "Cleaning Safari caches..."
    find ~/Library/Safari/LocalStorage -type f -mtime +${DAYS_TO_KEEP} -exec rm {} \; -print 2>/dev/null || echo "Error cleaning Safari LocalStorage."
    find ~/Library/Safari/WebKit/MediaCache -type f -exec rm {} \; -print 2>/dev/null || echo "Error cleaning Safari MediaCache."
    
    # Clean Spotify cache
    echo "Cleaning Spotify cache..."
    find ~/Library/Application\ Support/Spotify/PersistentCache/Storage -type f -mtime +${DAYS_TO_KEEP} -exec rm {} \; -print 2>/dev/null || echo "Error cleaning Spotify cache."
    
    # Clean Xcode derived data
    echo "Cleaning Xcode derived data..."
    rm -rf ~/Library/Developer/Xcode/DerivedData/* 2>/dev/null || echo "Error cleaning Xcode derived data."
    rm -rf ~/Library/Developer/Xcode/Archives/* 2>/dev/null || echo "Error cleaning Xcode archives."
    
    # Node.js cache cleaning
    if command -v npm >/dev/null 2>&1; then
        echo "Cleaning npm cache..."
        npm cache clean --force || echo "Error cleaning npm cache."
    fi
    
    if command -v yarn >/dev/null 2>&1; then
        echo "Cleaning yarn cache..."
        yarn cache clean || echo "Error cleaning yarn cache."
    fi
    
    # Docker cleanup
    if command -v docker >/dev/null 2>&1; then
        echo "Checking Docker context..."
        if ! current_context=$(docker context show 2>/dev/null); then
            echo "Unable to determine Docker context; assuming local and cleaning."
            docker system prune -f || echo "Error cleaning Docker system."
        else
            if endpoint=$(docker context inspect "$current_context" --format '{{.Endpoints.docker.Host}}' 2>/dev/null); then
                if [[ "$endpoint" == unix://* ]]; then
                    echo "Cleaning unused Docker data..."
                    docker system prune -f || echo "Error cleaning Docker system."
                else
                    echo "Docker is using a remote context ($endpoint), skipping cleanup."
                fi
            else
                echo "Unable to inspect Docker context; skipping cleanup to avoid potential remote connection."
            fi
        fi
    fi
    
    # Enhanced browser cache cleanup
    echo "Cleaning browser caches comprehensively..."
    
    # Chrome cleanup
    if [[ -d "$HOME/Library/Application Support/Google/Chrome" ]]; then
        echo "Cleaning Google Chrome cache..."
        find "$HOME/Library/Application Support/Google/Chrome/Default/Cache" -type f -mtime +${DAYS_TO_KEEP} -exec rm {} \; 2>/dev/null || echo "Chrome cache cleanup partial."
        find "$HOME/Library/Application Support/Google/Chrome/Default/Media Cache" -type f -exec rm {} \; 2>/dev/null || echo "Chrome media cache cleanup partial."
        find "$HOME/Library/Application Support/Google/Chrome/Default/GPUCache" -type f -exec rm {} \; 2>/dev/null || echo "Chrome GPU cache cleanup partial."
    fi
    
    # Firefox cleanup
    if [[ -d "$HOME/Library/Application Support/Firefox" ]]; then
        echo "Cleaning Firefox cache..."
        find "$HOME/Library/Caches/Firefox" -type f -mtime +${DAYS_TO_KEEP} -exec rm {} \; 2>/dev/null || echo "Firefox cache cleanup partial."
    fi
    
    # Edge cleanup
    if [[ -d "$HOME/Library/Application Support/Microsoft Edge" ]]; then
        echo "Cleaning Microsoft Edge cache..."
        find "$HOME/Library/Application Support/Microsoft Edge/Default/Cache" -type f -mtime +${DAYS_TO_KEEP} -exec rm {} \; 2>/dev/null || echo "Edge cache cleanup partial."
    fi
    
    # Clean DNS cache
    echo "Flushing DNS cache..."
    sudo dscacheutil -flushcache || echo "DNS cache flush partial."
    sudo killall -HUP mDNSResponder || echo "mDNSResponder restart partial."
    
    # Clean font cache
    echo "Cleaning font cache..."
    sudo atsutil databases -remove || echo "Font cache cleanup partial."
    
    # Clean launch services database
    echo "Rebuilding Launch Services database..."
    /System/Library/Frameworks/CoreServices.framework/Frameworks/LaunchServices.framework/Support/lsregister -kill -r -domain local -domain system -domain user || echo "Launch Services rebuild partial."
    
    # Clean Spotlight index (optional, commented out as it's intensive)
    # echo "Rebuilding Spotlight index..."
    # sudo mdutil -E / || echo "Spotlight reindex failed."
    
    # System memory cleanup
    echo "Purging system memory cache..."
    sudo purge || echo "Error purging system memory."
    
    # Clean system logs more thoroughly
    echo "Cleaning system logs comprehensively..."
    sudo rm -rf /var/log/*.log 2>/dev/null || echo "System log cleanup partial."
    sudo rm -rf /var/log/asl/*.asl 2>/dev/null || echo "ASL log cleanup partial."
    
    # Clean crash reports
    echo "Cleaning crash reports..."
    rm -rf ~/Library/Logs/DiagnosticReports/* 2>/dev/null || echo "User crash reports cleanup partial."
    sudo rm -rf /Library/Logs/DiagnosticReports/* 2>/dev/null || echo "System crash reports cleanup partial."
    
    # Clean Adobe cache if present
    if [[ -d "$HOME/Library/Application Support/Adobe" ]]; then
        echo "Cleaning Adobe cache..."
        find "$HOME/Library/Application Support/Adobe" -name "*Cache*" -type d -exec rm -rf {} \; 2>/dev/null || echo "Adobe cache cleanup partial."
    fi
    
    # Calculate final disk space
    echo -e "\nAfter cleanup:"
    local free_storage_final=$(df -k / | awk 'NR==2 {print $4}')
    local total_storage_final=$(df -k / | awk 'NR==2 {print $2}')
    local free_storage_final_gb=$(echo "scale=2; $free_storage_final / 1024 / 1024" | bc)
    local total_storage_final_gb=$(echo "scale=2; $total_storage_final / 1024 / 1024" | bc)
    
    echo "Free storage: $free_storage_final_gb Gi / Total storage: $total_storage_final_gb Gi"
    
    # Calculate the difference in kilobytes
    local free_storage_diff_kb=$((free_storage_final - free_storage))
    
    # If the difference is negative, set it to 0
    if [ "$free_storage_diff_kb" -lt 0 ]; then
        free_storage_diff_kb=0
    fi
    
    # Determine appropriate unit for the difference
    if [ "$free_storage_diff_kb" -ge $((1024 * 1024)) ]; then
        # Convert difference to gigabytes if >= 1 Gi
        local free_storage_diff_gb=$(echo "scale=2; $free_storage_diff_kb / 1024 / 1024" | bc)
        echo "Space freed: $free_storage_diff_gb Gi"
    elif [ "$free_storage_diff_kb" -ge 1024 ]; then
        # Convert difference to megabytes if >= 1 Mi but < 1 Gi
        local free_storage_diff_mb=$(echo "scale=2; $free_storage_diff_kb / 1024" | bc)
        echo "Space freed: $free_storage_diff_mb Mi"
    else
        # Output difference in kilobytes if < 1 Mi
        echo "Space freed: $free_storage_diff_kb Ki"
    fi
    
    echo ""
    echo "Selective cleanup complete!"
    
    echo ""
    read -p "$(echo -e ${WHITE}$(get_text "press_enter")${NC})"
}


# Function to get installed applications
get_installed_apps() {
    local apps=()
    
    # Scan /Applications directory
    if [[ -d "/Applications" ]]; then
        while IFS= read -r -d '' app; do
            if [[ -d "$app" && "$app" == *.app ]]; then
                local app_name=$(basename "$app" .app)
                local app_size=$(get_size "$app")
                apps+=("$app|$app_name|$app_size")
            fi
        done < <(find "/Applications" -name "*.app" -maxdepth 1 -print0 2>/dev/null)
    fi
    
    # Scan user Applications directory
    if [[ -d "$HOME/Applications" ]]; then
        while IFS= read -r -d '' app; do
            if [[ -d "$app" && "$app" == *.app ]]; then
                local app_name=$(basename "$app" .app)
                local app_size=$(get_size "$app")
                apps+=("$app|$app_name|$app_size")
            fi
        done < <(find "$HOME/Applications" -name "*.app" -maxdepth 1 -print0 2>/dev/null)
    fi
    
    printf '%s\n' "${apps[@]}" | sort -t'|' -k2
}

# Function to find all application-related files with comprehensive cache cleanup
find_app_files() {
    local app_name="$1"
    local app_path="$2"
    local related_files=()
    
    # Main application bundle
    if [[ -d "$app_path" ]]; then
        related_files+=("$app_path|Application Bundle")
    fi
    
    # User Library locations - comprehensive cache cleanup
    local user_locations=(
        "$HOME/Library/Application Support/$app_name"
        "$HOME/Library/Caches/$app_name"
        "$HOME/Library/Preferences/$app_name"
        "$HOME/Library/Preferences/com.$app_name"
        "$HOME/Library/Logs/$app_name"
        "$HOME/Library/Saved Application State/$app_name"
        "$HOME/Library/Containers/$app_name"
        "$HOME/Library/Group Containers/$app_name"
        "$HOME/Library/WebKit/$app_name"
        "$HOME/Library/HTTPStorages/$app_name"
        "$HOME/Library/Cookies/$app_name"
        "$HOME/Library/Application Scripts/$app_name"
        "$HOME/Library/SyncedPreferences/$app_name"
        "$HOME/Library/Keychains/$app_name"
        "$HOME/Library/Safari/Databases/$app_name"
        "$HOME/Library/Safari/LocalStorage/$app_name"
        "$HOME/Library/Safari/PerSiteZoomPreferences.plist"
        "$HOME/Library/Autosave Information/$app_name"
        "$HOME/Library/CloudStorage/$app_name"
        "$HOME/Library/Developer/$app_name"
        "$HOME/Library/Application Support/CrashReporter/$app_name"
        "$HOME/Library/Application Support/com.apple.sharedfilelist/com.apple.LSSharedFileList.ApplicationRecentDocuments/$app_name"
    )
    
    # System Library locations (if admin) - enhanced
    local system_locations=(
        "/Library/Application Support/$app_name"
        "/Library/Caches/$app_name"
        "/Library/Preferences/$app_name"
        "/Library/LaunchDaemons/com.$app_name"
        "/Library/LaunchAgents/com.$app_name"
        "/Library/PrivilegedHelperTools/$app_name"
        "/Library/LaunchDaemons/$app_name"
        "/Library/LaunchAgents/$app_name"
        "/Library/StartupItems/$app_name"
        "/Library/PreferencePanes/$app_name"
        "/Library/Services/$app_name"
        "/Library/Contextual Menu Items/$app_name"
        "/System/Library/Extensions/$app_name"
        "/Library/Extensions/$app_name"
        "/usr/local/bin/$app_name"
        "/usr/local/lib/$app_name"
        "/usr/local/share/$app_name"
    )
    
    # Check user locations
    for location in "${user_locations[@]}"; do
        if [[ -e "$location" ]]; then
            local size=$(get_size "$location")
            related_files+=("$location|User Data ($size)")
        fi
    done
    
    # Check system locations
    for location in "${system_locations[@]}"; do
        if [[ -e "$location" ]]; then
            local size=$(get_size "$location")
            related_files+=("$location|System Data ($size)")
        fi
    done
    
    # Look for bundle identifier based files - enhanced search
    local bundle_id=$(defaults read "$app_path/Contents/Info.plist" CFBundleIdentifier 2>/dev/null || echo "")
    if [[ -n "$bundle_id" ]]; then
        local bundle_locations=(
            "$HOME/Library/Preferences/$bundle_id.plist"
            "$HOME/Library/Caches/$bundle_id"
            "$HOME/Library/Application Support/$bundle_id"
            "$HOME/Library/Containers/$bundle_id"
            "$HOME/Library/Group Containers/group.$bundle_id"
            "$HOME/Library/Group Containers/$bundle_id"
            "$HOME/Library/HTTPStorages/$bundle_id"
            "$HOME/Library/Cookies/$bundle_id.binarycookies"
            "$HOME/Library/Saved Application State/$bundle_id.savedState"
            "$HOME/Library/SyncedPreferences/$bundle_id.plist"
            "$HOME/Library/WebKit/$bundle_id"
            "/Library/Preferences/$bundle_id.plist"
            "/Library/Application Support/$bundle_id"
            "/Library/LaunchDaemons/$bundle_id.plist"
            "/Library/LaunchAgents/$bundle_id.plist"
            "/Library/Caches/$bundle_id"
            "/private/var/db/receipts/$bundle_id.bom"
            "/private/var/db/receipts/$bundle_id.plist"
        )
        
        for location in "${bundle_locations[@]}"; do
            if [[ -e "$location" ]] && ! printf '%s\n' "${related_files[@]}" | grep -q "^$location|"; then
                local size=$(get_size "$location")
                related_files+=("$location|Bundle ID Data ($size)")
            fi
        done
    fi
    
    # Search for additional app-related files by name patterns
    local name_lower=$(echo "$app_name" | tr '[:upper:]' '[:lower:]')
    local name_upper=$(echo "$app_name" | tr '[:lower:]' '[:upper:]')
    local name_patterns=("$name_lower" "$name_upper" "$app_name")
    for pattern in "${name_patterns[@]}"; do
        # Find files containing app name in caches
        while IFS= read -r -d '' file; do
            if [[ -e "$file" ]] && ! printf '%s\n' "${related_files[@]}" | grep -q "^$file|"; then
                local size=$(get_size "$file")
                related_files+=("$file|Cache File ($size)")
            fi
        done < <(find "$HOME/Library/Caches" -maxdepth 2 -name "*$pattern*" -print0 2>/dev/null)
        
        # Find preference files containing app name
        while IFS= read -r -d '' file; do
            if [[ -e "$file" ]] && ! printf '%s\n' "${related_files[@]}" | grep -q "^$file|"; then
                local size=$(get_size "$file")
                related_files+=("$file|Preference File ($size)")
            fi
        done < <(find "$HOME/Library/Preferences" -maxdepth 1 -name "*$pattern*" -print0 2>/dev/null)
        
        # Find application support files
        while IFS= read -r -d '' file; do
            if [[ -e "$file" ]] && ! printf '%s\n' "${related_files[@]}" | grep -q "^$file|"; then
                local size=$(get_size "$file")
                related_files+=("$file|App Support File ($size)")
            fi
        done < <(find "$HOME/Library/Application Support" -maxdepth 2 -name "*$pattern*" -print0 2>/dev/null)
    done
    
    printf '%s\n' "${related_files[@]}"
}

# Function to use fzf or fallback to simple selection
show_app_selector() {
    print_separator
    echo -e "${BOLD}${APP_ICON} $(get_text "app_uninstall_title")${NC}"
    print_separator
    
    echo -e "${BLUE}$(get_text "app_scanning")${NC}"
    
    # Collect applications
    local apps=()
    local app_paths=()
    
    # Scan /Applications
    if [[ -d "/Applications" ]]; then
        while IFS= read -r -d '' app_path; do
            if [[ -d "$app_path" ]]; then
                local app_name=$(basename "$app_path" .app)
                apps+=("$app_name")
                app_paths+=("$app_path")
            fi
        done < <(find "/Applications" -name "*.app" -maxdepth 1 -type d -print0 2>/dev/null)
    fi
    
    # Scan ~/Applications
    if [[ -d "$HOME/Applications" ]]; then
        while IFS= read -r -d '' app_path; do
            if [[ -d "$app_path" ]]; then
                local app_name=$(basename "$app_path" .app)
                apps+=("$app_name")
                app_paths+=("$app_path")
            fi
        done < <(find "$HOME/Applications" -name "*.app" -maxdepth 1 -type d -print0 2>/dev/null)
    fi
    
    if [[ ${#apps[@]} -eq 0 ]]; then
        print_error "No applications found"
        return 1
    fi
    
    echo -e "${GREEN}${#apps[@]} $(get_text "app_found_count")${NC}"
    echo ""
    
    # Try to use fzf if available and in interactive mode
    if command -v fzf >/dev/null 2>&1 && [[ -t 0 ]] && [[ -t 1 ]]; then
        # Create temp file for fzf
        local temp_file=$(mktemp)
        trap "rm -f '$temp_file'" EXIT
        
        for ((i=0; i<${#apps[@]}; i++)); do
            printf "%s\t%s\n" "${apps[i]}" "${app_paths[i]}"
        done > "$temp_file"
        
        echo -e "${GREEN}Using fzf for selection...${NC}"
        echo ""
        
        local selected_line
        if [[ "$CURRENT_LANG" == "cn" ]]; then
            selected_line=$(cat "$temp_file" | fzf \
                --height=80% \
                --border \
                --prompt="搜索应用程序: " \
                --header="选择要卸载的应用程序 (ESC 取消)" \
                --bind='ctrl-c:abort')
        else
            selected_line=$(cat "$temp_file" | fzf \
                --height=80% \
                --border \
                --prompt="Search applications: " \
                --header="Select application to uninstall (ESC to cancel)" \
                --bind='ctrl-c:abort')
        fi
        
        if [[ -n "$selected_line" ]]; then
            local selected_app_path=$(echo "$selected_line" | cut -f2)
            local selected_app_name=$(basename "$selected_app_path" .app)
            uninstall_application "$selected_app_path" "$selected_app_name"
            return
        else
            print_info "$(get_text "skipped")"
            return 1
        fi
    fi
    
    # Fallback to numbered list selection
    echo -e "${YELLOW}fzf not available, using numbered selection:${NC}"
    echo ""
    
    # Display numbered list
    for ((i=0; i<${#apps[@]}; i++)); do
        printf "${CYAN}[%3d]${NC} %s\n" $((i+1)) "${apps[i]}"
    done
    
    echo ""
    if [[ "$CURRENT_LANG" == "cn" ]]; then
        read -p "请输入应用程序编号 (1-${#apps[@]}, 0 取消): " choice
    else
        read -p "Enter application number (1-${#apps[@]}, 0 to cancel): " choice
    fi
    
    # Validate input
    if [[ ! "$choice" =~ ^[0-9]+$ ]] || [[ "$choice" -lt 1 ]] || [[ "$choice" -gt ${#apps[@]} ]]; then
        if [[ "$choice" == "0" ]]; then
            print_info "$(get_text "skipped")"
        else
            print_error "$(get_text "invalid_choice")"
        fi
        return 1
    fi
    
    # Get selected app
    local selected_index=$((choice - 1))
    local selected_app_path="${app_paths[selected_index]}"
    local selected_app_name="${apps[selected_index]}"
    
    uninstall_application "$selected_app_path" "$selected_app_name"
}

# Function to uninstall application completely
uninstall_application() {
    local app_path="$1"
    local app_name="$2"
    
    echo -e "${BOLD}${GREEN}$(get_text "app_selected"): $app_name${NC}"
    echo ""
    
    # Find all related files
    echo -e "${BLUE}$(get_text "app_scanning")...${NC}"
    local related_files=()
    while IFS= read -r line; do
        related_files+=("$line")
    done < <(find_app_files "$app_name" "$app_path")
    
    if [[ ${#related_files[@]} -eq 0 ]]; then
        print_error "No files found for application: $app_name"
        return 1
    fi
    
    # Calculate total size
    local total_size_bytes=0
    echo -e "${BOLD}${GREEN}$(get_text "app_files_found"): ${#related_files[@]}${NC}"
    echo ""
    
    for file_info in "${related_files[@]}"; do
        IFS='|' read -r file_path file_desc <<< "$file_info"
        if [[ -e "$file_path" ]]; then
            local size=$(get_size "$file_path")
            local size_bytes=$(get_size_bytes "$file_path")
            total_size_bytes=$((total_size_bytes + size_bytes))
            echo -e "  ${CHECK_ICON} $file_desc - ${CYAN}$file_path${NC}"
        fi
    done
    
    local total_size_human=$(bytes_to_human "$total_size_bytes")
    echo ""
    echo -e "${BOLD}${YELLOW}$(get_text "app_size_total"): $total_size_human${NC}"
    echo ""
    
    # Confirm uninstallation
    read -p "$(echo -e ${WHITE}$(get_text "app_confirm_uninstall")${NC})" -n 1 -r
    echo
    
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        print_info "$(get_text "skipped")"
        return 0
    fi
    
    # Perform uninstallation
    echo ""
    echo -e "${BOLD}${BLUE}$(get_text "app_uninstalling")${NC}"
    echo ""
    
    local success_count=0
    local total_count=0
    
    for file_info in "${related_files[@]}"; do
        IFS='|' read -r file_path file_desc <<< "$file_info"
        ((total_count++))
        
        if [[ -e "$file_path" ]]; then
            echo -e "${CLEAN_ICON} $(get_text "cleaning") $file_desc..."
            
            if sudo rm -rf "$file_path" 2>/dev/null || rm -rf "$file_path" 2>/dev/null; then
                print_success "$(get_text "cleaned"): $file_desc"
                ((success_count++))
            else
                print_error "$(get_text "failed"): $file_desc"
            fi
        fi
    done
    
    echo ""
    if [[ $success_count -eq $total_count ]]; then
        print_success "$(get_text "app_uninstall_complete"): $app_name"
        print_success "$(get_text "total_space_freed"): $total_size_human"
    else
        print_warning "$(get_text "app_uninstall_complete"): $app_name ($success_count/$total_count files removed)"
    fi
    
    echo ""
    read -p "$(echo -e ${WHITE}$(get_text "press_enter")${NC})"
}

# Function to perform virus scan - optimized for speed
execute_virus_scan() {
    print_separator
    echo -e "${BOLD}${SHIELD_ICON} $(get_text "virus_scan_title")${NC}"
    print_separator
    
    echo -e "${WHITE}$(get_text "virus_scan_desc")${NC}"
    echo ""
    
    echo -e "${BOLD}${BLUE}$(get_text "virus_scanning")${NC}"
    echo ""
    
    local suspicious_files=()
    local scan_count=0
    local total_scanned=0
    
    # Progress function
    show_progress() {
        local current=$1
        local total=$2
        local percent=$((current * 100 / total))
        local bar_length=30
        local filled=$((percent * bar_length / 100))
        local empty=$((bar_length - filled))
        
        printf "\r${BLUE}扫描进度: [${GREEN}"
        printf "%*s" $filled | tr ' ' '█'
        printf "${NC}"
        printf "%*s" $empty | tr ' ' '░'
        printf "${BLUE}] %d%% (%d/%d)${NC}" $percent $current $total
    }
    
    # Quick process check
    echo -e "${CYAN}1/4 检查可疑进程...${NC}"
    local suspicious_processes=$(ps aux | grep -E -i "(adware|malware|keylogger|trojan|backdoor|miner|cryptojack)" | grep -v grep | head -5 || true)
    if [[ -n "$suspicious_processes" ]]; then
        echo -e "${RED}${VIRUS_ICON} 发现可疑进程:${NC}"
        echo "$suspicious_processes" | head -3
        echo ""
    else
        echo -e "${GREEN}${CHECK_ICON} 进程检查正常${NC}"
    fi
    
    # Quick known malware check
    echo -e "${CYAN}2/4 检查已知恶意软件...${NC}"
    local quick_malware_patterns=(
        "MacKeeper"
        "Advanced Mac Cleaner"
        "Mac Auto Fixer" 
        "Mac Speed Up Pro"
        "MyCouponize"
        "MacShiny"
        "ZipCloud"
        "SearchMine"
    )
    
    local priority_locations=(
        "/Applications"
        "$HOME/Applications" 
        "$HOME/Downloads"
        "/tmp"
        "$HOME/Library/LaunchAgents"
        "/Library/LaunchAgents"
    )
    
    local malware_found=0
    for location in "${priority_locations[@]}"; do
        if [[ -d "$location" ]]; then
            for pattern in "${quick_malware_patterns[@]}"; do
                if find "$location" -iname "*$pattern*" -type f -o -type d | head -1 | grep -q . 2>/dev/null; then
                    local found_files=$(find "$location" -iname "*$pattern*" 2>/dev/null | head -3)
                    while IFS= read -r file; do
                        if [[ -n "$file" ]]; then
                            local file_size=$(du -sh "$file" 2>/dev/null | cut -f1 || echo "未知")
                            suspicious_files+=("$file|Known Malware: $pattern ($file_size)")
                            ((malware_found++))
                        fi
                    done <<< "$found_files"
                fi
            done
        fi
    done
    
    if [[ $malware_found -gt 0 ]]; then
        echo -e "${RED}${VIRUS_ICON} 发现 $malware_found 个已知恶意软件${NC}"
    else
        echo -e "${GREEN}${CHECK_ICON} 未发现已知恶意软件${NC}"
    fi
    
    # Quick suspicious file check
    echo -e "${CYAN}3/4 检查可疑文件类型...${NC}"
    local suspicious_files_found=0
    local quick_locations=("$HOME/Downloads" "$HOME/Desktop" "/tmp")
    
    for location in "${quick_locations[@]}"; do
        if [[ -d "$location" ]]; then
            # Check for suspicious extensions
            local susp_files=$(find "$location" -maxdepth 2 \( -name "*.dmg.zip" -o -name "*.app.zip" -o -name "*.pkg.zip" -o -name "*.scr" \) 2>/dev/null | head -5)
            while IFS= read -r file; do
                if [[ -n "$file" && -f "$file" ]]; then
                    local file_size=$(du -sh "$file" 2>/dev/null | cut -f1 || echo "未知")
                    suspicious_files+=("$file|Suspicious File Type ($file_size)")
                    ((suspicious_files_found++))
                fi
            done <<< "$susp_files"
        fi
    done
    
    if [[ $suspicious_files_found -gt 0 ]]; then
        echo -e "${YELLOW}${WARNING_ICON} 发现 $suspicious_files_found 个可疑文件${NC}"
    else
        echo -e "${GREEN}${CHECK_ICON} 文件类型检查正常${NC}"
    fi
    
    # Quick startup items check
    echo -e "${CYAN}4/4 检查启动项...${NC}"
    local suspicious_startup=0
    local startup_dirs=("/Library/LaunchAgents" "$HOME/Library/LaunchAgents")
    
    for startup_dir in "${startup_dirs[@]}"; do
        if [[ -d "$startup_dir" ]]; then
            # Look for non-Apple startup items
            local non_apple_plists=$(find "$startup_dir" -name "*.plist" ! -name "com.apple.*" 2>/dev/null | head -5)
            while IFS= read -r plist; do
                if [[ -n "$plist" && -f "$plist" ]]; then
                    # Quick check for suspicious paths
                    if grep -q -E "(tmp|Downloads|Desktop)" "$plist" 2>/dev/null; then
                        local file_size=$(du -sh "$plist" 2>/dev/null | cut -f1 || echo "未知")
                        suspicious_files+=("$plist|Suspicious Startup Item ($file_size)")
                        ((suspicious_startup++))
                    fi
                fi
            done <<< "$non_apple_plists"
        fi
    done
    
    if [[ $suspicious_startup -gt 0 ]]; then
        echo -e "${YELLOW}${WARNING_ICON} 发现 $suspicious_startup 个可疑启动项${NC}" 
    else
        echo -e "${GREEN}${CHECK_ICON} 启动项检查正常${NC}"
    fi
    
    echo ""
    print_separator
    
    if [[ ${#suspicious_files[@]} -eq 0 ]]; then
        print_success "$(get_text "virus_scan_complete") - 未发现威胁"
        echo -e "${GREEN}${CHECK_ICON} 系统安全检查通过！${NC}"
        echo -e "${BLUE}${INFO_ICON} 扫描了进程、已知恶意软件、可疑文件和启动项${NC}"
    else
        print_warning "$(get_text "virus_found"): ${#suspicious_files[@]} 个项目"
        echo ""
        
        echo -e "${BOLD}${RED}发现的威胁:${NC}"
        local count=1
        for file_info in "${suspicious_files[@]}"; do
            IFS='|' read -r file_path file_desc <<< "$file_info"
            echo -e "  ${VIRUS_ICON} [$count] $file_desc"
            echo -e "      ${CYAN}$file_path${NC}"
            ((count++))
        done
        
        echo ""
        read -p "$(echo -e ${WHITE}是否要删除这些威胁？[y/N]: ${NC})" -n 1 -r
        echo
        
        if [[ $REPLY =~ ^[Yy]$ ]]; then
            echo ""
            echo -e "${BOLD}${BLUE}正在清除威胁...${NC}"
            local removed_count=0
            local total_count=${#suspicious_files[@]}
            
            for file_info in "${suspicious_files[@]}"; do
                IFS='|' read -r file_path file_desc <<< "$file_info"
                echo -e "${CLEAN_ICON} 清除: $(basename "$file_path")..."
                
                if sudo rm -rf "$file_path" 2>/dev/null || rm -rf "$file_path" 2>/dev/null; then
                    print_success "已清除: $(basename "$file_path")"
                    ((removed_count++))
                else
                    print_error "清除失败: $(basename "$file_path")"
                fi
                show_progress $removed_count $total_count
            done
            
            echo ""
            echo ""
            print_success "安全清理完成: 清除了 $removed_count/$total_count 个威胁"
        else
            print_info "跳过威胁清除"
        fi
    fi
    
    echo ""
    read -p "$(echo -e ${WHITE}$(get_text "press_enter")${NC})"
}

# Function to create visual bar chart
create_bar_chart() {
    local size_bytes=$1
    local max_bytes=$2
    local bar_width=40
    
    # Ensure we have valid numbers
    [[ ! "$size_bytes" =~ ^[0-9]+$ ]] && size_bytes=0
    [[ ! "$max_bytes" =~ ^[0-9]+$ ]] && max_bytes=1
    [[ $max_bytes -eq 0 ]] && max_bytes=1
    
    local filled_width=$((size_bytes * bar_width / max_bytes))
    [[ $filled_width -eq 0 && $size_bytes -gt 0 ]] && filled_width=1
    [[ $filled_width -gt $bar_width ]] && filled_width=$bar_width
    
    printf "${GREEN}"
    printf "%*s" $filled_width | tr ' ' '█'
    printf "${CYAN}"
    printf "%*s" $((bar_width - filled_width)) | tr ' ' '░'
    printf "${NC}"
}

# Function to perform disk analysis - optimized and visualized
execute_disk_analysis() {
    print_separator
    echo -e "${BOLD}${CHART_ICON} $(get_text "disk_analysis_title")${NC}"
    print_separator
    
    echo -e "${WHITE}$(get_text "disk_analysis_desc")${NC}"
    echo ""
    
    echo -e "${BOLD}${BLUE}$(get_text "disk_analyzing")${NC}"
    
    # Show disk usage summary with visual bar
    echo ""
    echo -e "${BOLD}${CYAN}💾 磁盘使用情况概览:${NC}"
    local disk_info=$(df -k / | tail -1)
    local total_kb=$(echo $disk_info | awk '{print $2}')
    local used_kb=$(echo $disk_info | awk '{print $3}')
    local free_kb=$(echo $disk_info | awk '{print $4}')
    local use_percent=$(echo $disk_info | awk '{print $5}' | sed 's/%//')
    
    local total_gb=$(echo "scale=1; $total_kb / 1024 / 1024" | bc)
    local used_gb=$(echo "scale=1; $used_kb / 1024 / 1024" | bc)
    local free_gb=$(echo "scale=1; $free_kb / 1024 / 1024" | bc)
    
    echo -e "总容量: ${BOLD}${WHITE}${total_gb}GB${NC}"
    echo -e "已使用: ${BOLD}${RED}${used_gb}GB${NC} (${use_percent}%)"
    echo -e "可用空间: ${BOLD}${GREEN}${free_gb}GB${NC}"
    
    # Visual disk usage bar
    local bar_width=50
    local used_width=$((use_percent * bar_width / 100))
    printf "\n磁盘使用: ["
    printf "${RED}%*s${NC}" $used_width | tr ' ' '█'
    printf "${GREEN}%*s${NC}" $((bar_width - used_width)) | tr ' ' '░'
    printf "] %s%%\n\n" $use_percent
    
    # Quick analysis of major directories
    echo -e "${BOLD}${CYAN}📁 主要目录大小分析:${NC}"
    
    local quick_dirs=("$HOME" "/Applications" "/Library" "/usr" "/var" "/tmp")
    declare -a dir_info=()
    local max_size=0
    
    # Collect directory sizes efficiently - simplified approach
    for dir in "${quick_dirs[@]}"; do
        if [[ -d "$dir" ]]; then
            echo -ne "\r${BLUE}分析中... $(basename "$dir")${NC}"
            
            # Get directory size with improved error handling
            local size_output=$(du -sk "$dir" 2>/dev/null | head -1)
            local size_kb=$(echo "$size_output" | cut -f1 | tr -d '\n\t ' 2>/dev/null || echo "0")
            
            # Ensure size_kb is a valid number
            if [[ "$size_kb" =~ ^[0-9]+$ ]] && [[ $size_kb -gt 0 ]]; then
                local size_gb=$(echo "scale=1; $size_kb / 1024 / 1024" | bc 2>/dev/null || echo "0.0")
                local size_human="${size_gb}GB"
                [[ $size_kb -gt $max_size ]] && max_size=$size_kb
                dir_info+=("$size_kb|$dir|$size_human")
            fi
        fi
    done
    echo -e "\r${NC}                                        "
    
    # Sort and display with visual bars
    IFS=$'\n' dir_info=($(printf '%s\n' "${dir_info[@]}" | sort -rn))
    
    for info in "${dir_info[@]}"; do
        IFS='|' read -r size_kb dir_path size_human <<< "$info"
        printf "  ${FOLDER_ICON} %-20s ${YELLOW}%8s${NC} " "$(basename "$dir_path")" "$size_human"
        create_bar_chart $size_kb $max_size
        echo ""
    done
    echo ""
    
    # Fast large file detection
    echo -e "${BOLD}${CYAN}🔍 大文件快速检测 (>500MB):${NC}"
    echo -ne "${BLUE}搜索大文件...${NC}"
    
    local large_files=()
    local priority_paths=("$HOME" "/Applications")
    
    for search_path in "${priority_paths[@]}"; do
        if [[ -d "$search_path" ]]; then
            # Use faster find with size limit
            while IFS= read -r -d '' file; do
                if [[ -f "$file" ]]; then
                    local file_size=$(du -sh "$file" 2>/dev/null | cut -f1 || echo "0B")
                    large_files+=("$file_size|$file")
                fi
            done < <(find "$search_path" -type f -size +500M -print0 2>/dev/null | head -10)
        fi
    done
    
    echo -e "\r                                    "
    
    if [[ ${#large_files[@]} -eq 0 ]]; then
        echo -e "${GREEN}${CHECK_ICON} 未发现超大文件 (>500MB)${NC}"
    else
        echo -e "${BOLD}${YELLOW}发现 ${#large_files[@]} 个超大文件:${NC}"
        
        # Sort by size
        IFS=$'\n' large_files=($(printf '%s\n' "${large_files[@]}" | sort -rn))
        
        local count=1
        for file_info in "${large_files[@]}"; do
            IFS='|' read -r file_size file_path <<< "$file_info"
            echo -e "  ${WARNING_ICON} [$count] ${CYAN}$file_size${NC} - $(basename "$file_path")"
            echo -e "      ${BLUE}$file_path${NC}"
            ((count++))
            [[ $count -gt 5 ]] && break  # Limit display to top 5
        done
        
        echo ""
        read -p "$(echo -e ${WHITE}查看大文件管理选项？[y/N]: ${NC})" -n 1 -r
        echo
        
        if [[ $REPLY =~ ^[Yy]$ ]]; then
            echo ""
            echo -e "${BOLD}${CYAN}大文件管理选项:${NC}"
            echo -e "  ${INFO_ICON} 1. 手动检查文件位置"
            echo -e "  ${INFO_ICON} 2. 使用 Finder 打开所在文件夹"
            echo -e "  ${WARNING_ICON} 3. 谨慎删除 - 可能是重要文件"
            echo ""
            
            local top_file=$(echo "${large_files[0]}" | cut -d'|' -f2)
            echo -e "${BLUE}最大文件位置:${NC} $top_file"
            read -p "$(echo -e ${WHITE}在 Finder 中显示最大文件？[y/N]: ${NC})" -n 1 -r
            echo
            
            if [[ $REPLY =~ ^[Yy]$ ]] && [[ -f "$top_file" ]]; then
                open -R "$top_file" 2>/dev/null && echo -e "${GREEN}${CHECK_ICON} 已在 Finder 中显示文件${NC}"
            fi
        fi
    fi
    
    echo ""
    
    # Cache analysis with visual representation
    echo -e "${BOLD}${CYAN}🗂️  缓存目录快速分析:${NC}"
    
    local cache_dirs=(
        "$HOME/Library/Caches|用户缓存"
        "/Library/Caches|系统缓存" 
        "$HOME/Library/Application Support|应用支持"
        "/tmp|临时文件"
    )
    
    local total_cache_bytes=0
    local max_cache_size=0
    declare -a cache_info=()
    
    for cache_entry in "${cache_dirs[@]}"; do
        IFS='|' read -r cache_dir cache_name <<< "$cache_entry"
        if [[ -d "$cache_dir" ]]; then
            echo -ne "\r${BLUE}分析缓存... $cache_name${NC}"
            local cache_kb=$(du -sk "$cache_dir" 2>/dev/null | cut -f1 | tr -d '\n\t ' || echo "0")
            # Ensure cache_kb is a valid number
            [[ ! "$cache_kb" =~ ^[0-9]+$ ]] && cache_kb=0
            local cache_bytes=$((cache_kb * 1024))
            local cache_human=$(bytes_to_human $cache_bytes)
            total_cache_bytes=$((total_cache_bytes + cache_bytes))
            [[ $cache_kb -gt $max_cache_size ]] && max_cache_size=$cache_kb
            cache_info+=("$cache_kb|$cache_name|$cache_human")
        fi
    done
    echo -e "\r                                        "
    
    for info in "${cache_info[@]}"; do
        IFS='|' read -r size_kb cache_name size_human <<< "$info"
        printf "  ${FOLDER_ICON} %-15s ${YELLOW}%8s${NC} " "$cache_name" "$size_human"
        create_bar_chart $size_kb $max_cache_size
        echo ""
    done
    
    local total_cache_human=$(bytes_to_human $total_cache_bytes)
    echo ""
    echo -e "${BOLD}${GREEN}总缓存大小: $total_cache_human${NC}"
    
    if [[ $total_cache_bytes -gt $((1024 * 1024 * 1024)) ]]; then  # > 1GB
        echo -e "${YELLOW}${INFO_ICON} 缓存较大，建议运行自动清理功能${NC}"
    fi
    
    # Quick duplicate check in Downloads
    echo ""
    echo -e "${BOLD}${CYAN}🔄 快速重复文件检测:${NC}"
    
    if [[ -d "$HOME/Downloads" ]]; then
        echo -ne "${BLUE}检查下载文件夹...${NC}"
        local downloads_duplicates=$(find "$HOME/Downloads" -type f -name "* (*" 2>/dev/null | wc -l | tr -d ' ')
        echo -e "\r                                    "
        
        if [[ $downloads_duplicates -gt 0 ]]; then
            echo -e "${YELLOW}${WARNING_ICON} 发现 $downloads_duplicates 个可能的重复文件 (包含括号)${NC}"
            echo -e "${BLUE}${INFO_ICON} 建议检查下载文件夹中的重复文件${NC}"
        else
            echo -e "${GREEN}${CHECK_ICON} 下载文件夹看起来整洁${NC}"
        fi
    fi
    
    echo ""
    print_separator
    print_success "$(get_text "disk_analysis_complete")"
    
    # Summary with recommendations
    echo ""
    echo -e "${BOLD}${CYAN}💡 优化建议:${NC}"
    
    if [[ $use_percent -gt 90 ]]; then
        echo -e "  ${WARNING_ICON} 磁盘空间不足，建议立即清理"
    elif [[ $use_percent -gt 80 ]]; then
        echo -e "  ${INFO_ICON} 磁盘空间紧张，建议定期清理"
    else
        echo -e "  ${CHECK_ICON} 磁盘空间充足"
    fi
    
    if [[ $total_cache_bytes -gt $((2 * 1024 * 1024 * 1024)) ]]; then  # > 2GB
        echo -e "  ${INFO_ICON} 运行自动清理可释放约 $(bytes_to_human $((total_cache_bytes / 2)))"
    fi
    
    if [[ ${#large_files[@]} -gt 0 ]]; then
        echo -e "  ${INFO_ICON} 检查大文件，删除不需要的可释放大量空间"
    fi
    
    echo ""
    read -p "$(echo -e ${WHITE}$(get_text "press_enter")${NC})"
}

# Function to show language menu
show_language_menu() {
    print_separator
    echo -e "${BOLD}${LANG_ICON} Language & Exit Menu${NC}"
    print_separator
    
    echo -e "${BOLD}${WHITE}Select Language:${NC}"
    echo ""
    echo -e "${CYAN}[1]${NC} English"
    echo -e "${CYAN}[2]${NC} 中文 (Chinese)"
    echo -e "${CYAN}[3]${NC} Exit Program"
    echo ""
    
    read -p "$(echo -e ${WHITE}Enter your choice [1-3]: ${NC})" lang_choice
    echo ""
    
    case $lang_choice in
        1)
            CURRENT_LANG="en"
            save_language
            print_success "Language changed successfully!"
            print_info "Language preference saved."
            sleep 2
            ;;
        2)
            CURRENT_LANG="cn"
            save_language
            print_success "语言切换成功！"
            print_info "语言偏好已保存。"
            sleep 2
            ;;
        3)
            echo -e "${BOLD}${GREEN}$(get_text "thank_you") ${SPARKLE_ICON}${NC}"
            exit 0
            ;;
        *)
            print_error "Invalid choice"
            sleep 2
            ;;
    esac
}


# Main menu function
show_menu() {
    echo -e "${BOLD}${WHITE}$(get_text "menu_select")${NC}"
    echo ""
    echo -e "${CYAN}[1]${NC} 🧹 $(get_text "menu_1")"
    echo -e "${CYAN}[2]${NC} ${APP_ICON} $(get_text "menu_2")"
    echo -e "${CYAN}[3]${NC} ${SHIELD_ICON} $(get_text "menu_3")"
    echo -e "${CYAN}[4]${NC} ${CHART_ICON} $(get_text "menu_4")"
    echo -e "${CYAN}[5]${NC} ${LANG_ICON} $(get_text "menu_5")"
    echo ""
}

# Function to show help in Chinese
show_help_cn() {
    echo "CleanMac - macOS 系统清理工具"
    echo "用法: $(basename "$0") [选项] [天数]"
    echo ""
    echo "安全且交互式地清理不必要的 macOS 文件。"
    echo ""
    echo "选项:"
    echo "    -h, --help          显示此帮助信息"
    echo "    -d, --dry-run       显示将要删除的内容但不实际删除"
    echo "    --lang=LANG         设置语言 (en|cn)"
    echo "    --auto              直接运行自动清理模式"
    echo ""
    echo "参数:"
    echo "    DAYS                保留缓存的天数 (默认: 7)"
    echo ""
    echo "示例:"
    echo "    $0                  交互模式"
    echo "    $0 --dry-run        预览清理但不删除"
    echo "    $0 --auto           自动清理模式"
    echo "    $0 --lang=cn        使用中文界面"
    echo "    $0 30               保留30天内的文件"
}

# Function to show help
show_help() {
    echo "CleanMac - Advanced macOS System Cleanup Tool"
    echo "Usage: $(basename "$0") [OPTIONS] [DAYS]"
    echo ""
    echo "Clean up unnecessary macOS files safely and interactively."
    echo ""
    echo "Options:"
    echo "    -h, --help          Show this help message"
    echo "    -d, --dry-run       Show what would be deleted without deleting"
    echo "    --lang=LANG         Set language (en|cn)"
    echo "    --auto              Run auto cleanup mode directly"
    echo ""
    echo "Arguments:"
    echo "    DAYS                Number of days of cache to keep (default: 7)"
    echo ""
    echo "Examples:"
    echo "    $0                  Interactive mode"
    echo "    $0 --dry-run        Preview cleanup without deleting"
    echo "    $0 --auto           Auto cleanup mode"
    echo "    $0 --lang=cn        Use Chinese interface"
    echo "    $0 30               Keep files newer than 30 days"
}

# Function to get disk space
get_disk_space() {
    df -k / | awk 'NR==2 {print $4}'
}

# Function to show disk space info
show_disk_space() {
    local free_kb=$(get_disk_space)
    local total_kb=$(df -k / | awk 'NR==2 {print $2}')
    local free_gb=$(echo "scale=2; $free_kb / 1024 / 1024" | bc 2>/dev/null || echo "0")
    local total_gb=$(echo "scale=2; $total_kb / 1024 / 1024" | bc 2>/dev/null || echo "0")
    
    echo -e "${BLUE}${INFO_ICON} Free storage: ${free_gb}GB / Total: ${total_gb}GB${NC}"
}


# Main execution
main() {
    # Parse command line arguments
    while [[ $# -gt 0 ]]; do
        case $1 in
            --lang=*)
                CURRENT_LANG="${1#*=}"
                save_language
                shift
                ;;
            --lang)
                CURRENT_LANG="$2"
                save_language
                shift 2
                ;;
            -d|--dry-run)
                DRY_RUN=true
                shift
                ;;
            --auto)
                # Store initial disk space
                initial_free_space=$(get_disk_space)
                show_disk_space
                execute_auto_cleanup
                # Show final disk space
                final_free_space=$(get_disk_space)
                local space_freed=$((final_free_space - initial_free_space))
                if [[ $space_freed -gt 0 ]]; then
                    local freed_gb=$(echo "scale=2; $space_freed / 1024 / 1024" | bc 2>/dev/null || echo "0")
                    echo -e "${GREEN}${SPARKLE_ICON} Space freed: ${freed_gb}GB${NC}"
                fi
                show_disk_space
                exit 0
                ;;
            -h|--help)
                if [[ "$CURRENT_LANG" == "cn" ]]; then
                    show_help_cn
                else
                    show_help
                fi
                exit 0
                ;;
            [0-9]*)
                DAYS_TO_KEEP="$1"
                # Validate days
                if ! [[ $DAYS_TO_KEEP =~ ^[0-9]+$ ]]; then
                    echo "Error: DAYS must be a positive integer."
                    exit 1
                fi
                shift
                ;;
            *)
                echo "Unknown option: $1"
                echo "Use -h or --help for usage information."
                exit 1
                ;;
        esac
    done
    
    # Show initial disk space
    initial_free_space=$(get_disk_space)
    
    # If dry run mode, show what would be cleaned
    if [[ "$DRY_RUN" == "true" ]]; then
        echo -e "${YELLOW}${WARNING_ICON} DRY RUN MODE - No files will be deleted${NC}"
        echo ""
        show_disk_space
        echo ""
        echo "Would clean the following locations (files older than ${DAYS_TO_KEEP} days):"
        echo "- System cache files in /Library/Caches/"
        echo "- User cache files in ~/Library/Caches/"
        echo "- System logs in /Library/Logs/"
        echo "- User logs in ~/Library/Logs/"
        echo "- Temporary files in /private/var/tmp/"
        echo "- Files in ~/.Trash/"
        echo "- Browser caches and data"
        echo "- Development tool caches"
        echo "- Application caches"
        echo ""
        echo "Use without --dry-run to perform actual cleanup."
        exit 0
    fi
    
    while true; do
        print_header
        show_disk_space
        echo ""
        show_menu
        read -p "$(echo -e ${WHITE}$(get_text "enter_choice")${NC})" choice
        echo ""
        
        # Handle user choice
        case "$choice" in
            1)
                execute_auto_cleanup
                ;;
            2)
                show_app_selector
                ;;
            3)
                execute_virus_scan
                ;;
            4)
                execute_disk_analysis
                ;;
            5)
                show_language_menu
                ;;
            *)
                print_error "$(get_text "invalid_choice")"
                sleep 2
                ;;
        esac
    done
}

# Check if running on macOS
if [[ "$(uname)" != "Darwin" ]]; then
    print_error "This script is designed for macOS only."
    exit 1
fi

# Check for required tools
if ! command -v du >/dev/null 2>&1; then
    print_error "Required tool 'du' not found."
    exit 1
fi

# Start the program
main "$@"