#!/bin/bash

# CleanMac - Advanced macOS System Cleanup Tool
# Version: 2.2
# Author: CleanYourMac Project (Created by a middle school student)
# Description: Interactive macOS cleanup utility with multi-language and multi-selection support

set -eo pipefail

# Language configuration
DEFAULT_LANG="en"
LANG_FILE="$HOME/.cleanyourmac_lang"

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
readonly SELECT_ICON="☑️"
readonly UNSELECT_ICON="☐"

# Global variables
total_cleaned=0
total_items=0
cleaned_paths=()
skipped_paths=()

# Multi-selection variables
declare -a selected_options=()

# Function to get localized text
get_text() {
    local key="$1"
    if [[ "$CURRENT_LANG" == "cn" ]]; then
        case "$key" in
            "title") echo "CleanMac - macOS 系统清理工具" ;;
            "subtitle") echo "交互式清理实用工具" ;;
            "description") echo "此工具帮助您安全地清理 macOS 系统中的缓存和垃圾文件。" ;;
            "begin") echo "删除任何文件前都会询问您的确认。让我们开始吧。" ;;
            "menu_select") echo "选择清理类别（支持多选）：" ;;
            "menu_1") echo "用户级缓存和日志" ;;
            "menu_2") echo "系统级缓存" ;;
            "menu_3") echo "浏览器缓存" ;;
            "menu_4") echo "开发工具" ;;
            "menu_5") echo "应用程序缓存" ;;
            "menu_6") echo "垃圾箱和其他" ;;
            "menu_7") echo "全选" ;;
            "menu_8") echo "开始清理" ;;
            "menu_9") echo "语言 / 退出" ;;
            "requires_admin") echo "(需要管理员权限)" ;;
            "interactive") echo "(交互式)" ;;
            "enter_choice") echo "请输入选项编号来切换选择 [1-9], 或按 Enter 查看选项: " ;;
            "enter_number") echo "输入数字 [1-9]: " ;;
            "invalid_choice") echo "无效选择。请选择 1-9。" ;;
            "no_selection") echo "请至少选择一个清理类别。" ;;
            "selected_items") echo "已选择的清理项目：" ;;
            "confirm_start") echo "确认开始清理以上选中的项目？[y/N]: " ;;
            "thank_you") echo "感谢您使用 CleanMac！再见！" ;;
            "press_enter") echo "按回车键继续或 Ctrl+C 退出..." ;;
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
            "user_caches") echo "用户级缓存和日志" ;;
            "system_caches") echo "系统级缓存" ;;
            "browser_caches") echo "浏览器缓存" ;;
            "dev_tools") echo "开发工具" ;;
            "app_caches") echo "应用程序缓存" ;;
            "trash_misc") echo "垃圾箱和其他" ;;
            "lang_menu") echo "语言和退出菜单" ;;
            "select_lang") echo "选择语言：" ;;
            "lang_english") echo "English" ;;
            "lang_chinese") echo "中文 (Chinese)" ;;
            "exit_program") echo "退出程序" ;;
            "lang_changed") echo "语言切换成功！" ;;
            "lang_saved") echo "语言偏好已保存。" ;;
            "toggle_hint") echo "提示：输入数字来切换选择，8=开始清理，9=语言/退出" ;;
            "current_selection") echo "当前选择" ;;
            *) echo "$key" ;;
        esac
    else
        case "$key" in
            "title") echo "CleanMac - macOS System Cleanup Tool" ;;
            "subtitle") echo "Interactive Cleanup Utility" ;;
            "description") echo "This tool helps you safely clean cache and junk files from your macOS system." ;;
            "begin") echo "You will be asked before anything is deleted. Let's begin." ;;
            "menu_select") echo "Select cleanup categories (Multi-selection supported):" ;;
            "menu_1") echo "User-level caches & logs" ;;
            "menu_2") echo "System-level caches" ;;
            "menu_3") echo "Browser caches" ;;
            "menu_4") echo "Development tools" ;;
            "menu_5") echo "Application caches" ;;
            "menu_6") echo "Trash & miscellaneous" ;;
            "menu_7") echo "Select all" ;;
            "menu_8") echo "Start cleaning" ;;
            "menu_9") echo "Language / Exit" ;;
            "requires_admin") echo "(requires admin)" ;;
            "interactive") echo "(interactive)" ;;
            "enter_choice") echo "Enter option number to toggle selection [1-9], or press Enter to see options: " ;;
            "enter_number") echo "Enter number [1-9]: " ;;
            "invalid_choice") echo "Invalid choice. Please select 1-9." ;;
            "no_selection") echo "Please select at least one cleanup category." ;;
            "selected_items") echo "Selected cleanup items:" ;;
            "confirm_start") echo "Confirm to start cleaning the selected items? [y/N]: " ;;
            "thank_you") echo "Thank you for using CleanMac! Goodbye!" ;;
            "press_enter") echo "Press Enter to continue or Ctrl+C to exit..." ;;
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
            "user_caches") echo "User-Level Caches & Logs" ;;
            "system_caches") echo "System-Level Caches" ;;
            "browser_caches") echo "Browser Caches" ;;
            "dev_tools") echo "Development Tools" ;;
            "app_caches") echo "Application Caches" ;;
            "trash_misc") echo "Trash & Miscellaneous" ;;
            "lang_menu") echo "Language & Exit Menu" ;;
            "select_lang") echo "Select Language:" ;;
            "lang_english") echo "English" ;;
            "lang_chinese") echo "中文 (Chinese)" ;;
            "exit_program") echo "Exit Program" ;;
            "lang_changed") echo "Language changed successfully!" ;;
            "lang_saved") echo "Language preference saved." ;;
            "toggle_hint") echo "Tip: Enter numbers to toggle selection, 8=Start cleaning, 9=Language/Exit" ;;
            "current_selection") echo "Current Selection" ;;
            *) echo "$key" ;;
        esac
    fi
}

# Save language preference
save_language() {
    echo "$CURRENT_LANG" > "$LANG_FILE"
}

# Function to check if option is selected
is_selected() {
    local option="$1"
    for selected in "${selected_options[@]}"; do
        if [[ "$selected" == "$option" ]]; then
            return 0
        fi
    done
    return 1
}

# Function to toggle selection
toggle_selection() {
    local option="$1"
    local found=false
    local new_array=()
    
    # Remove if already selected
    for selected in "${selected_options[@]}"; do
        if [[ "$selected" == "$option" ]]; then
            found=true
        else
            new_array+=("$selected")
        fi
    done
    
    # Add if not found (was not selected)
    if ! $found; then
        new_array+=("$option")
    fi
    
    selected_options=("${new_array[@]}")
}

# Function to select all options
select_all() {
    selected_options=(1 2 3 4 5 6)
}

# Function to get selection icon
get_selection_icon() {
    local option="$1"
    if is_selected "$option"; then
        echo "$SELECT_ICON"
    else
        echo "$UNSELECT_ICON"
    fi
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

# Function to safely remove directory contents
safe_clean() {
    local path="$1"
    local description="$2"
    local size
    
    if [[ ! -d "$path" ]]; then
        print_info "$(get_text "path_not_found"): $path"
        return 0
    fi
    
    size=$(get_size "$path")
    
    if [[ "$size" == "0B" ]]; then
        print_info "$(get_text "already_clean"): $description"
        return 0
    fi
    
    echo -e "${BOLD}${YELLOW}$description${NC}"
    echo -e "  ${CYAN}→ Path: $path${NC}"
    echo -e "  ${CYAN}→ Size: $size${NC}"
    
    read -p "$(echo -e ${WHITE}$(get_text "confirm_clean")${NC})" -n 1 -r
    echo
    
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        echo -e "${CLEAN_ICON} $(get_text "cleaning")..."
        if rm -rf "$path"/* "$path"/.[^.]* 2>/dev/null; then
            print_success "$(get_text "cleaned"): $description ($size $(get_text "size_freed"))"
            cleaned_paths+=("$description: $size")
            ((total_cleaned++))
        else
            print_error "$(get_text "failed"): $description"
        fi
    else
        print_skip "$(get_text "skipped"): $description"
        skipped_paths+=("$description")
    fi
    echo
    ((total_items++))
}

# Function to clean with sudo
sudo_clean() {
    local path="$1"
    local description="$2"
    local size
    
    if [[ ! -d "$path" ]]; then
        print_info "$(get_text "path_not_found"): $path"
        return 0
    fi
    
    size=$(get_size "$path")
    
    if [[ "$size" == "0B" ]]; then
        print_info "$(get_text "already_clean"): $description"
        return 0
    fi
    
    echo -e "${BOLD}${YELLOW}$description${NC} ${RED}$(get_text "admin_required")${NC}"
    echo -e "  ${CYAN}→ Path: $path${NC}"
    echo -e "  ${CYAN}→ Size: $size${NC}"
    
    read -p "$(echo -e ${WHITE}$(get_text "confirm_clean")${NC})" -n 1 -r
    echo
    
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        echo -e "${CLEAN_ICON} $(get_text "cleaning") $(get_text "admin_password")..."
        if sudo rm -rf "$path"/* "$path"/.[^.]* 2>/dev/null; then
            print_success "$(get_text "cleaned"): $description ($size $(get_text "size_freed"))"
            cleaned_paths+=("$description: $size")
            ((total_cleaned++))
        else
            print_error "$(get_text "failed"): $description"
        fi
    else
        print_skip "$(get_text "skipped"): $description"
        skipped_paths+=("$description")
    fi
    echo
    ((total_items++))
}

# Function to run command-based cleanup
command_clean() {
    local command="$1"
    local description="$2"
    
    echo -e "${BOLD}${YELLOW}$description${NC}"
    echo -e "  ${CYAN}→ Command: $command${NC}"
    
    read -p "$(echo -e ${WHITE}$(get_text "confirm_run")${NC})" -n 1 -r
    echo
    
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        echo -e "${CLEAN_ICON} $(get_text "running")..."
        if eval "$command" >/dev/null 2>&1; then
            print_success "$(get_text "completed"): $description"
            cleaned_paths+=("$description")
            ((total_cleaned++))
        else
            print_error "$(get_text "failed_run"): $description"
        fi
    else
        print_skip "$(get_text "skipped"): $description"
        skipped_paths+=("$description")
    fi
    echo
    ((total_items++))
}

# Check if application exists
app_exists() {
    local app_name="$1"
    [[ -d "/Applications/$app_name.app" ]] || [[ -d "$HOME/Applications/$app_name.app" ]]
}

# Main cleanup functions
clean_user_caches() {
    print_separator
    echo -e "${BOLD}${COMPUTER_ICON} $(get_text "user_caches")${NC}"
    print_separator
    
    safe_clean "$HOME/Library/Caches" "User application caches"
    safe_clean "$HOME/Library/Logs" "User application logs"
    safe_clean "$HOME/Library/Application Support/CrashReporter" "Crash reports"
    safe_clean "$HOME/Library/Saved Application State" "Saved application states"
    safe_clean "$HOME/Library/Application Support/com.apple.sharedfilelist" "Shared file lists"
}

clean_system_caches() {
    print_separator
    echo -e "${BOLD}${COMPUTER_ICON} $(get_text "system_caches")${NC}"
    print_separator
    
    sudo_clean "/Library/Caches" "System application caches"
    sudo_clean "/private/var/folders" "System temporary files"
    sudo_clean "/private/var/log" "System logs"
    sudo_clean "/Library/Logs/DiagnosticReports" "System diagnostic reports"
}

clean_browser_caches() {
    print_separator
    echo -e "${BOLD}${BROWSER_ICON} $(get_text "browser_caches")${NC}"
    print_separator
    
    safe_clean "$HOME/Library/Caches/com.apple.Safari" "Safari cache"
    
    if app_exists "Google Chrome"; then
        safe_clean "$HOME/Library/Caches/Google/Chrome" "Chrome cache"
        safe_clean "$HOME/Library/Application Support/Google/Chrome/Default/Application Cache" "Chrome application cache"
    fi
    
    if [[ -d "$HOME/Library/Application Support/Firefox/Profiles" ]]; then
        for profile in "$HOME/Library/Application Support/Firefox/Profiles"/*.default*; do
            if [[ -d "$profile/cache2" ]]; then
                safe_clean "$profile/cache2" "Firefox cache ($(basename "$profile"))"
            fi
        done
    fi
}

clean_dev_tools() {
    print_separator
    echo -e "${BOLD}${DEV_ICON} $(get_text "dev_tools")${NC}"
    print_separator
    
    if app_exists "Xcode"; then
        safe_clean "$HOME/Library/Developer/Xcode/DerivedData" "Xcode DerivedData"
        safe_clean "$HOME/Library/Developer/Xcode/Archives" "Xcode Archives"
        safe_clean "$HOME/Library/Developer/Xcode/iOS DeviceSupport" "iOS Device Support"
        safe_clean "$HOME/Library/Developer/CoreSimulator/Caches" "CoreSimulator caches"
    fi
    
    if app_exists "Visual Studio Code" || app_exists "VSCodium"; then
        safe_clean "$HOME/Library/Application Support/Code/logs" "VSCode logs"
        safe_clean "$HOME/Library/Application Support/Code/CachedData" "VSCode cached data"
    fi
    
    if command -v npm >/dev/null 2>&1; then
        safe_clean "$HOME/.npm" "npm cache"
        safe_clean "$HOME/.node-gyp" "node-gyp cache"
    fi
    
    if command -v brew >/dev/null 2>&1; then
        command_clean "brew cleanup --prune=all" "Homebrew cleanup"
        safe_clean "$(brew --cache)" "Homebrew cache"
    fi
    
    if command -v pip3 >/dev/null 2>&1 || command -v pip >/dev/null 2>&1; then
        safe_clean "$HOME/Library/Caches/pip" "Python pip cache"
    fi
    
    if command -v cargo >/dev/null 2>&1; then
        safe_clean "$HOME/.cargo/registry/cache" "Rust Cargo cache"
    fi
}

clean_app_caches() {
    print_separator
    echo -e "${BOLD}🧩 $(get_text "app_caches")${NC}"
    print_separator
    
    safe_clean "$HOME/Library/Application Support/Adobe/Common/Media Cache Files" "Adobe Media Cache"
    safe_clean "$HOME/Library/Application Support/zoom.us/data" "Zoom cache"
    safe_clean "$HOME/Library/Application Support/discord/Cache" "Discord cache"
    safe_clean "$HOME/Library/Application Support/Spotify/PersistentCache" "Spotify cache"
    safe_clean "$HOME/Library/Application Support/Slack/Cache" "Slack cache"
    safe_clean "$HOME/Library/Application Support/Microsoft/Teams/Cache" "Microsoft Teams cache"
}

clean_trash_and_misc() {
    print_separator
    echo -e "${BOLD}${TRASH_ICON} $(get_text "trash_misc")${NC}"
    print_separator
    
    safe_clean "$HOME/.Trash" "User Trash"
    
    # Check for external drive trash
    for volume in /Volumes/*; do
        if [[ -d "$volume/.Trashes" ]]; then
            safe_clean "$volume/.Trashes" "Trash on $(basename "$volume")"
        fi
    done
    
    safe_clean "$HOME/Library/Application Support/MobileSync/Backup" "iOS Device Backups"
    safe_clean "$HOME/Downloads" "Downloads folder (be careful!)"
}

# Function to show language menu
show_language_menu() {
    print_separator
    echo -e "${BOLD}${LANG_ICON} $(get_text "lang_menu")${NC}"
    print_separator
    
    echo -e "${BOLD}${WHITE}$(get_text "select_lang")${NC}"
    echo ""
    echo -e "${CYAN}[1]${NC} $(get_text "lang_english")"
    echo -e "${CYAN}[2]${NC} $(get_text "lang_chinese")"
    echo -e "${CYAN}[3]${NC} $(get_text "exit_program")"
    echo ""
    
    read -p "$(echo -e ${WHITE}$(get_text "enter_choice")${NC})" lang_choice
    echo ""
    
    case $lang_choice in
        1)
            CURRENT_LANG="en"
            save_language
            print_success "$(get_text "lang_changed")"
            print_info "$(get_text "lang_saved")"
            sleep 2
            ;;
        2)
            CURRENT_LANG="cn"
            save_language
            print_success "$(get_text "lang_changed")"
            print_info "$(get_text "lang_saved")"
            sleep 2
            ;;
        3)
            echo -e "${BOLD}${GREEN}$(get_text "thank_you") ${SPARKLE_ICON}${NC}"
            exit 0
            ;;
        *)
            print_error "$(get_text "invalid_choice")"
            sleep 2
            ;;
    esac
}

# Function to show current selection
show_current_selection() {
    if [[ ${#selected_options[@]} -gt 0 ]]; then
        echo ""
        echo -e "${BOLD}${GREEN}$(get_text "current_selection"):${NC}"
        for option in "${selected_options[@]}"; do
            case $option in
                1) echo -e "  ${SELECT_ICON} $(get_text "menu_1")" ;;
                2) echo -e "  ${SELECT_ICON} $(get_text "menu_2") ${RED}$(get_text "requires_admin")${NC}" ;;
                3) echo -e "  ${SELECT_ICON} $(get_text "menu_3")" ;;
                4) echo -e "  ${SELECT_ICON} $(get_text "menu_4")" ;;
                5) echo -e "  ${SELECT_ICON} $(get_text "menu_5")" ;;
                6) echo -e "  ${SELECT_ICON} $(get_text "menu_6")" ;;
            esac
        done
        echo ""
    fi
}

# Function to execute selected cleanups
execute_selected_cleanups() {
    if [[ ${#selected_options[@]} -eq 0 ]]; then
        print_error "$(get_text "no_selection")"
        sleep 2
        return
    fi
    
    # Show selected items
    show_current_selection
    
    # Confirm before starting
    read -p "$(echo -e ${WHITE}$(get_text "confirm_start")${NC})" -n 1 -r
    echo
    
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        print_info "$(get_text "skipped")"
        sleep 2
        return
    fi
    
    # Execute selected cleanup functions
    for option in "${selected_options[@]}"; do
        case $option in
            1) clean_user_caches ;;
            2) clean_system_caches ;;
            3) clean_browser_caches ;;
            4) clean_dev_tools ;;
            5) clean_app_caches ;;
            6) clean_trash_and_misc ;;
        esac
    done
}

# Function to show final summary
show_summary() {
    print_separator
    echo -e "${BOLD}${SPARKLE_ICON} $(get_text "summary")${NC}"
    print_separator
    
    echo -e "${BOLD}${GREEN}$(get_text "cleaned_items") ($total_cleaned/$total_items):${NC}"
    if [[ ${#cleaned_paths[@]} -gt 0 ]]; then
        for item in "${cleaned_paths[@]}"; do
            echo -e "  ${CHECK_ICON} $item"
        done
    else
        echo -e "  ${INFO_ICON} $(get_text "no_items_cleaned")"
    fi
    
    echo ""
    echo -e "${BOLD}${YELLOW}$(get_text "skipped_items"):${NC}"
    if [[ ${#skipped_paths[@]} -gt 0 ]]; then
        for item in "${skipped_paths[@]}"; do
            echo -e "  ${SKIP_ICON} $item"
        done
    else
        echo -e "  ${INFO_ICON} $(get_text "no_items_skipped")"
    fi
    
    echo ""
    echo -e "${BOLD}${SPARKLE_ICON} $(get_text "all_processed")${NC}"
    echo ""
}

# Main menu function
show_menu() {
    echo -e "${BOLD}${WHITE}$(get_text "menu_select")${NC}"
    echo ""
    echo -e "${CYAN}[1]${NC} $(get_selection_icon 1) $(get_text "menu_1")"
    echo -e "${CYAN}[2]${NC} $(get_selection_icon 2) $(get_text "menu_2") ${RED}$(get_text "requires_admin")${NC}"
    echo -e "${CYAN}[3]${NC} $(get_selection_icon 3) $(get_text "menu_3")"
    echo -e "${CYAN}[4]${NC} $(get_selection_icon 4) $(get_text "menu_4")"
    echo -e "${CYAN}[5]${NC} $(get_selection_icon 5) $(get_text "menu_5")"
    echo -e "${CYAN}[6]${NC} $(get_selection_icon 6) $(get_text "menu_6")"
    echo -e "${CYAN}[7]${NC} ${YELLOW}$(get_text "menu_7")${NC}"
    echo -e "${CYAN}[8]${NC} ${GREEN}$(get_text "menu_8")${NC}"
    echo -e "${CYAN}[9]${NC} $(get_text "menu_9")"
    echo ""
    echo -e "${YELLOW}$(get_text "toggle_hint")${NC}"
    
    show_current_selection
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
            -h|--help)
                echo "Usage: $0 [--lang=en|cn]"
                echo "  --lang=en    Set language to English"
                echo "  --lang=cn    Set language to Chinese"
                exit 0
                ;;
            *)
                echo "Unknown option: $1"
                exit 1
                ;;
        esac
    done
    
    while true; do
        print_header
        show_menu
        read -p "$(echo -e ${WHITE}$(get_text "enter_number")${NC})" choice
        echo ""
        
        case $choice in
            1|2|3|4|5|6)
                toggle_selection "$choice"
                ;;
            7)
                select_all
                ;;
            8)
                execute_selected_cleanups
                if [[ ${#selected_options[@]} -gt 0 ]]; then
                    show_summary
                    echo ""
                    read -p "$(echo -e ${WHITE}$(get_text "press_enter")${NC})"
                    # Reset selections after cleanup
                    selected_options=()
                    total_cleaned=0
                    total_items=0
                    cleaned_paths=()
                    skipped_paths=()
                fi
                ;;
            9)
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