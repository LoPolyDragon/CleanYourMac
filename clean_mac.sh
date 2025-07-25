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

# Global variables
total_cleaned=0
total_items=0
cleaned_paths=()
skipped_paths=()
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
            "menu_3") echo "语言 / Language" ;;
            "enter_choice") echo "输入 1, 2 或 3: " ;;
            "invalid_choice") echo "无效选择。请输入 1, 2 或 3。" ;;
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
            "menu_3") echo "Language / 语言" ;;
            "enter_choice") echo "Enter 1, 2 or 3: " ;;
            "invalid_choice") echo "Invalid choice. Please enter 1, 2 or 3." ;;
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
    if [[ -d "$path" ]]; then
        du -sh "$path" 2>/dev/null | cut -f1 || echo "0B"
    else
        echo "0B"
    fi
}

# Global variable for auto cleanup mode
auto_cleanup_mode=false
total_space_freed=0

# Function to convert size to bytes for calculation
size_to_bytes() {
    local size="$1"
    local number=$(echo "$size" | sed 's/[^0-9.]//g')
    local unit=$(echo "$size" | sed 's/[0-9.]//g' | tr '[:lower:]' '[:upper:]')
    
    case "$unit" in
        "B") printf "%.0f" "$number" ;;
        "K"|"KB") printf "%.0f" "$(echo "$number * 1024" | bc 2>/dev/null || echo "0")" ;;
        "M"|"MB") printf "%.0f" "$(echo "$number * 1024 * 1024" | bc 2>/dev/null || echo "0")" ;;
        "G"|"GB") printf "%.0f" "$(echo "$number * 1024 * 1024 * 1024" | bc 2>/dev/null || echo "0")" ;;
        *) echo "0" ;;
    esac
}

# Function to convert bytes back to human readable
bytes_to_human() {
    local bytes="$1"
    if [[ "$bytes" -ge 1073741824 ]]; then
        echo "$(echo "scale=2; $bytes / 1073741824" | bc 2>/dev/null || echo "0")GB"
    elif [[ "$bytes" -ge 1048576 ]]; then
        echo "$(echo "scale=2; $bytes / 1048576" | bc 2>/dev/null || echo "0")MB"
    elif [[ "$bytes" -ge 1024 ]]; then
        echo "$(echo "scale=2; $bytes / 1024" | bc 2>/dev/null || echo "0")KB"
    else
        echo "${bytes}B"
    fi
}

# Function to clean multiple paths at once (batch cleaning)
batch_clean() {
    local category_name="$1"
    shift
    local paths=("$@")
    local total_size="0B"
    local valid_paths=()
    
    print_separator
    echo -e "${BOLD}${COMPUTER_ICON} $category_name${NC}"
    print_separator
    
    # Check which paths exist and show total size
    for path_desc in "${paths[@]}"; do
        IFS='|' read -r path desc <<< "$path_desc"
        if [[ -d "$path" ]]; then
            local size=$(get_size "$path")
            if [[ "$size" != "0B" ]]; then
                valid_paths+=("$path_desc")
                echo -e "${YELLOW}  ✓ $desc${NC} - $path ($size)"
            fi
        fi
    done
    
    if [[ ${#valid_paths[@]} -eq 0 ]]; then
        print_info "No items found to clean in this category"
        return 0
    fi
    
    # Auto cleanup mode or manual confirmation
    local should_clean=false
    if [[ "$auto_cleanup_mode" == "true" ]]; then
        should_clean=true
        echo ""
        echo -e "${GREEN}$(get_text "auto_cleanup_running")${NC}"
    else
        echo ""
        read -p "$(echo -e ${WHITE}Clean all items in this category? [y/N]: ${NC})" -n 1 -r
        echo
        if [[ $REPLY =~ ^[Yy]$ ]]; then
            should_clean=true
        fi
    fi
    
    if [[ "$should_clean" == "true" ]]; then
        for path_desc in "${valid_paths[@]}"; do
            IFS='|' read -r path desc <<< "$path_desc"
            echo -e "${CLEAN_ICON} $(get_text "cleaning") $desc..."
            
            local size=$(get_size "$path")
            local size_bytes=$(size_to_bytes "$size")
            
            if sudo rm -rf "$path"/* "$path"/.[^.]* 2>/dev/null || rm -rf "$path"/* "$path"/.[^.]* 2>/dev/null; then
                print_success "$(get_text "cleaned"): $desc ($size $(get_text "size_freed"))"
                cleaned_paths+=("$desc: $size")
                total_space_freed=$((total_space_freed + size_bytes))
                ((total_cleaned++))
            else
                print_error "$(get_text "failed"): $desc"
            fi
            ((total_items++))
        done
    else
        print_skip "$(get_text "skipped") category: $category_name"
        skipped_paths+=("$category_name")
    fi
    echo ""
}

# Function for auto cleanup with sensitive path confirmation
auto_batch_clean() {
    local category_name="$1"
    shift
    local paths=("$@")
    local sensitive_paths=("Downloads" "Desktop" "Screenshots")
    local valid_paths=()
    
    print_separator
    echo -e "${BOLD}${COMPUTER_ICON} $category_name${NC}"
    print_separator
    
    # Check which paths exist and show total size
    for path_desc in "${paths[@]}"; do
        IFS='|' read -r path desc <<< "$path_desc"
        if [[ -d "$path" ]]; then
            local size=$(get_size "$path")
            if [[ "$size" != "0B" ]]; then
                valid_paths+=("$path_desc")
                echo -e "${YELLOW}  ✓ $desc${NC} - $path ($size)"
            fi
        fi
    done
    
    if [[ ${#valid_paths[@]} -eq 0 ]]; then
        print_info "No items found to clean in this category"
        return 0
    fi
    
    echo ""
    
    for path_desc in "${valid_paths[@]}"; do
        IFS='|' read -r path desc <<< "$path_desc"
        
        # Check if this is a sensitive path
        local is_sensitive=false
        for sensitive in "${sensitive_paths[@]}"; do
            if [[ "$desc" == *"$sensitive"* ]]; then
                is_sensitive=true
                break
            fi
        done
        
        local should_clean=false
        if [[ "$is_sensitive" == "true" ]]; then
            echo -e "${YELLOW}${WARNING_ICON} $(get_text "confirm_sensitive"): $desc${NC}"
            read -p "$(echo -e ${WHITE}$(get_text "confirm_clean")${NC})" -n 1 -r
            echo
            if [[ $REPLY =~ ^[Yy]$ ]]; then
                should_clean=true
            fi
        else
            should_clean=true
        fi
        
        if [[ "$should_clean" == "true" ]]; then
            echo -e "${CLEAN_ICON} $(get_text "cleaning") $desc..."
            
            local size=$(get_size "$path")
            local size_bytes=$(size_to_bytes "$size")
            
            if sudo rm -rf "$path"/* "$path"/.[^.]* 2>/dev/null || rm -rf "$path"/* "$path"/.[^.]* 2>/dev/null; then
                print_success "$(get_text "cleaned"): $desc ($size $(get_text "size_freed"))"
                cleaned_paths+=("$desc: $size")
                total_space_freed=$((total_space_freed + size_bytes))
                ((total_cleaned++))
            else
                print_error "$(get_text "failed"): $desc"
            fi
        else
            print_skip "$(get_text "skipped"): $desc"
            skipped_paths+=("$desc")
        fi
        ((total_items++))
    done
    echo ""
}

# Clean system caches and logs
clean_system_caches() {
    local paths=(
        "/Library/Caches|System application caches"
        "/System/Library/Caches|System library caches"
        "/var/log|System logs"
        "/private/var/log|Private system logs"
        "/Library/Logs|System application logs"
        "/Library/Logs/DiagnosticReports|Diagnostic reports"
        "/var/folders|System temporary folders"
        "/private/tmp|Private temporary files"
    )
    batch_clean "$(get_text "menu_1")" "${paths[@]}"
}

# Clean user application caches
clean_user_caches() {
    local paths=(
        "$HOME/Library/Caches|User application caches"
        "$HOME/Library/Logs|User application logs"
        "$HOME/Library/Application Support/CrashReporter|Crash reports"
        "$HOME/Library/Saved Application State|Saved application states"
        "$HOME/Library/Application Support/com.apple.sharedfilelist|Shared file lists"
        "$HOME/Library/Preferences/ByHost|Host-specific preferences cache"
        "$HOME/Library/Application Support/SyncServices|Sync services cache"
        "$HOME/Library/Caches/com.apple.helpd|Help system cache"
        "$HOME/Library/Caches/com.apple.iconservices|Icon services cache"
    )
    batch_clean "$(get_text "menu_2")" "${paths[@]}"
}

# Clean browser data
clean_browser_data() {
    local paths=(
        "$HOME/Library/Caches/com.apple.Safari|Safari cache"
        "$HOME/Library/Safari/History.db|Safari history"
        "$HOME/Library/Safari/TopSites.plist|Safari top sites"
        "$HOME/Library/Caches/Google/Chrome|Chrome cache"
        "$HOME/Library/Application Support/Google/Chrome/Default/History|Chrome history"
        "$HOME/Library/Application Support/Firefox/Profiles|Firefox profiles cache"
        "$HOME/Library/Caches/Firefox|Firefox cache"
        "$HOME/Library/Application Support/Microsoft Edge|Edge cache"
        "$HOME/Library/Caches/com.operasoftware.Opera|Opera cache"
    )
    batch_clean "$(get_text "menu_3")" "${paths[@]}"
}

# Clean development tools
clean_dev_tools() {
    local paths=(
        "$HOME/Library/Developer/Xcode/DerivedData|Xcode DerivedData"
        "$HOME/Library/Developer/Xcode/Archives|Xcode Archives"
        "$HOME/Library/Developer/Xcode/iOS DeviceSupport|iOS Device Support"
        "$HOME/Library/Developer/CoreSimulator|iOS Simulator data"
        "$HOME/.npm|npm cache"
        "$HOME/.yarn|Yarn cache"
        "$HOME/.node-gyp|node-gyp cache"
        "$(brew --cache 2>/dev/null || echo '/tmp/homebrew')|Homebrew cache"
        "$HOME/Library/Caches/pip|Python pip cache"
        "$HOME/.cache/pip|Python pip user cache"
        "$HOME/.cargo/registry/cache|Rust Cargo cache"
        "$HOME/Library/Application Support/Code/logs|VSCode logs"
        "$HOME/Library/Application Support/Code/CachedData|VSCode cache"
        "$HOME/.docker|Docker cache"
        "$HOME/Library/Containers/com.docker.docker|Docker containers"
    )
    batch_clean "$(get_text "menu_4")" "${paths[@]}"
}

# Clean trash and downloads
clean_trash_downloads() {
    local paths=(
        "$HOME/.Trash|User Trash"
        "$HOME/Downloads|Downloads folder"
        "/Volumes/*/.Trashes|External drive trash"
        "$HOME/Library/Application Support/MobileSync/Backup|iOS device backups"
        "$HOME/Desktop/Screenshot*|Desktop screenshots"
        "$HOME/Movies/Screenshots|Movie screenshots"
    )
    batch_clean "$(get_text "menu_5")" "${paths[@]}"
}

# Clean system temporary files
clean_system_temp() {
    local paths=(
        "/private/var/folders|System temp folders"
        "/tmp|Temporary files"
        "/var/tmp|Variable temp files"
        "/private/tmp|Private temp files"
        "$HOME/Library/Caches/Cleanup At Startup|Startup cleanup cache"
        "/Library/Caches/com.apple.bootstubs|Boot stub cache"
        "/System/Library/Caches/com.apple.coreservices.uiagent|UI agent cache"
        "/var/db/receipts|Package receipts"
    )
    batch_clean "$(get_text "menu_6")" "${paths[@]}"
}

# Function to execute auto cleanup
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
    
    # Set auto cleanup mode
    auto_cleanup_mode=true
    total_space_freed=0
    
    echo ""
    echo -e "${BOLD}${GREEN}$(get_text "auto_cleanup_running")${NC}"
    echo ""
    
    # Execute all cleanup categories automatically
    echo -e "${BOLD}${BLUE}$(get_text "processing_category") 1: $(get_text "menu_1")${NC}"
    clean_system_caches
    
    echo -e "${BOLD}${BLUE}$(get_text "processing_category") 3: $(get_text "menu_3")${NC}"
    clean_user_caches
    
    echo -e "${BOLD}${BLUE}$(get_text "processing_category") 4: $(get_text "menu_4")${NC}"
    clean_browser_data
    
    echo -e "${BOLD}${BLUE}$(get_text "processing_category") 5: $(get_text "menu_5")${NC}"
    clean_dev_tools
    
    echo -e "${BOLD}${BLUE}$(get_text "processing_category") 6: $(get_text "menu_6")${NC}"
    # Use special function for sensitive paths
    clean_trash_downloads_auto
    
    echo -e "${BOLD}${BLUE}$(get_text "processing_category") 7: $(get_text "menu_7")${NC}"
    clean_system_temp
    
    # Reset auto cleanup mode
    auto_cleanup_mode=false
    
    # Show auto cleanup summary
    show_auto_cleanup_summary
    
    echo ""
    read -p "$(echo -e ${WHITE}$(get_text "press_enter")${NC})"
    
    # Reset counters for next round
    total_cleaned=0
    total_items=0
    cleaned_paths=()
    skipped_paths=()
    total_space_freed=0
}

# Special function for trash and downloads with auto cleanup
clean_trash_downloads_auto() {
    local paths=(
        "$HOME/.Trash|User Trash"
        "$HOME/Downloads|Downloads folder"
        "/Volumes/*/.Trashes|External drive trash"
        "$HOME/Library/Application Support/MobileSync/Backup|iOS device backups"
        "$HOME/Desktop/Screenshot*|Desktop screenshots"
        "$HOME/Movies/Screenshots|Movie screenshots"
    )
    auto_batch_clean "$(get_text "menu_5")" "${paths[@]}"
}

# Function to show auto cleanup summary
show_auto_cleanup_summary() {
    print_separator
    echo -e "${BOLD}${SPARKLE_ICON} $(get_text "auto_cleanup_complete")${NC}"
    print_separator
    
    # Convert total space freed to human readable
    local total_freed_human=$(bytes_to_human "$total_space_freed")
    
    echo -e "${BOLD}${GREEN}$(get_text "total_space_freed"): ${total_freed_human}${NC}"
    echo ""
    
    echo -e "${BOLD}${GREEN}$(get_text "cleaned_items") ($total_cleaned/$total_items):${NC}"
    if [[ ${#cleaned_paths[@]} -gt 0 ]]; then
        for item in "${cleaned_paths[@]}"; do
            echo -e "  ${CHECK_ICON} $item"
        done
    else
        echo -e "  ${INFO_ICON} $(get_text "no_items_cleaned")"
    fi
    
    echo ""
    if [[ ${#skipped_paths[@]} -gt 0 ]]; then
        echo -e "${BOLD}${YELLOW}$(get_text "skipped_items"):${NC}"
        for item in "${skipped_paths[@]}"; do
            echo -e "  ${SKIP_ICON} $item"
        done
        echo ""
    fi
    
    echo -e "${BOLD}${SPARKLE_ICON} $(get_text "all_processed")${NC}"
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

# Function to find all application-related files
find_app_files() {
    local app_name="$1"
    local app_path="$2"
    local related_files=()
    
    # Main application bundle
    if [[ -d "$app_path" ]]; then
        related_files+=("$app_path|Application Bundle")
    fi
    
    # User Library locations
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
    )
    
    # System Library locations (if admin)
    local system_locations=(
        "/Library/Application Support/$app_name"
        "/Library/Caches/$app_name"
        "/Library/Preferences/$app_name"
        "/Library/LaunchDaemons/com.$app_name"
        "/Library/LaunchAgents/com.$app_name"
        "/Library/PrivilegedHelperTools/$app_name"
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
    
    # Look for bundle identifier based files
    local bundle_id=$(defaults read "$app_path/Contents/Info.plist" CFBundleIdentifier 2>/dev/null || echo "")
    if [[ -n "$bundle_id" ]]; then
        local bundle_locations=(
            "$HOME/Library/Preferences/$bundle_id.plist"
            "$HOME/Library/Caches/$bundle_id"
            "$HOME/Library/Application Support/$bundle_id"
            "$HOME/Library/Containers/$bundle_id"
            "$HOME/Library/Group Containers/group.$bundle_id"
            "/Library/Preferences/$bundle_id.plist"
            "/Library/Application Support/$bundle_id"
            "/Library/LaunchDaemons/$bundle_id.plist"
            "/Library/LaunchAgents/$bundle_id.plist"
        )
        
        for location in "${bundle_locations[@]}"; do
            if [[ -e "$location" ]] && ! printf '%s\n' "${related_files[@]}" | grep -q "^$location|"; then
                local size=$(get_size "$location")
                related_files+=("$location|Bundle ID Data ($size)")
            fi
        done
    fi
    
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
            local size_bytes=$(size_to_bytes "$size")
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
    echo -e "${CYAN}[3]${NC} ${LANG_ICON} $(get_text "menu_3")"
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