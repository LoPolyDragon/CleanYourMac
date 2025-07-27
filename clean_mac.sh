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
    
    # System memory cleanup
    echo "Purging system memory cache..."
    sudo purge || echo "Error purging system memory."
    
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