#!/bin/bash

# CleanMac - Advanced macOS System Cleanup Tool
# Version: 2.4
# Author: CleanYourMac Project (Created by a middle school student)
# Description: Interactive macOS cleanup utility with comprehensive cleaning

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

# Global variables
total_cleaned=0
total_items=0
cleaned_paths=()
skipped_paths=()

# Function to get localized text
get_text() {
    local key="$1"
    if [[ "$CURRENT_LANG" == "cn" ]]; then
        case "$key" in
            "title") echo "CleanMac - macOS 系统清理工具" ;;
            "subtitle") echo "交互式清理实用工具" ;;
            "description") echo "此工具帮助您安全地清理 macOS 系统中的缓存和垃圾文件。" ;;
            "begin") echo "删除任何文件前都会询问您的确认。让我们开始吧。" ;;
            "menu_select") echo "选择清理类别：" ;;
            "menu_1") echo "系统缓存和日志" ;;
            "menu_2") echo "用户应用缓存" ;;
            "menu_3") echo "浏览器数据" ;;
            "menu_4") echo "开发工具缓存" ;;
            "menu_5") echo "垃圾箱和下载" ;;
            "menu_6") echo "系统临时文件" ;;
            "menu_7") echo "全选 (清理所有项目)" ;;
            "menu_8") echo "语言 / 退出" ;;
            "requires_admin") echo "(需要管理员权限)" ;;
            "enter_choice") echo "输入数字（可多选，用空格分隔，如: 1 3 5）或 8 进入语言菜单: " ;;
            "invalid_choice") echo "无效选择。请输入 1-8 的数字。" ;;
            "selected_items") echo "将要清理的项目：" ;;
            "confirm_start") echo "确认开始清理以上项目？[y/N]: " ;;
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
            "menu_select") echo "Select cleanup categories:" ;;
            "menu_1") echo "System caches & logs" ;;
            "menu_2") echo "User app caches" ;;
            "menu_3") echo "Browser data" ;;
            "menu_4") echo "Development tools" ;;
            "menu_5") echo "Trash & downloads" ;;
            "menu_6") echo "System temp files" ;;
            "menu_7") echo "Select all (clean everything)" ;;
            "menu_8") echo "Language / Exit" ;;
            "requires_admin") echo "(requires admin)" ;;
            "enter_choice") echo "Enter numbers (multi-select with spaces, e.g.: 1 3 5) or 8 for language menu: " ;;
            "invalid_choice") echo "Invalid choice. Please enter numbers 1-8." ;;
            "selected_items") echo "Items to be cleaned:" ;;
            "confirm_start") echo "Confirm to start cleaning the above items? [y/N]: " ;;
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
    
    echo ""
    read -p "$(echo -e ${WHITE}Clean all items in this category? [y/N]: ${NC})" -n 1 -r
    echo
    
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        for path_desc in "${valid_paths[@]}"; do
            IFS='|' read -r path desc <<< "$path_desc"
            echo -e "${CLEAN_ICON} Cleaning $desc..."
            
            local size=$(get_size "$path")
            if sudo rm -rf "$path"/* "$path"/.[^.]* 2>/dev/null || rm -rf "$path"/* "$path"/.[^.]* 2>/dev/null; then
                print_success "Cleaned: $desc ($size freed)"
                cleaned_paths+=("$desc: $size")
                ((total_cleaned++))
            else
                print_error "Failed to clean: $desc"
            fi
            ((total_items++))
        done
    else
        print_skip "Skipped category: $category_name"
        skipped_paths+=("$category_name")
    fi
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

# Function to execute selected cleanups
execute_selected_cleanups() {
    local selections=($1)
    
    # Show selected items
    echo ""
    echo -e "${BOLD}${GREEN}$(get_text "selected_items")${NC}"
    for choice in "${selections[@]}"; do
        case $choice in
            1) echo -e "  ${CHECK_ICON} $(get_text "menu_1")" ;;
            2) echo -e "  ${CHECK_ICON} $(get_text "menu_2")" ;;
            3) echo -e "  ${CHECK_ICON} $(get_text "menu_3")" ;;
            4) echo -e "  ${CHECK_ICON} $(get_text "menu_4")" ;;
            5) echo -e "  ${CHECK_ICON} $(get_text "menu_5")" ;;
            6) echo -e "  ${CHECK_ICON} $(get_text "menu_6")" ;;
        esac
    done
    echo ""
    
    # Confirm before starting
    read -p "$(echo -e ${WHITE}$(get_text "confirm_start")${NC})" -n 1 -r
    echo
    
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        print_info "$(get_text "skipped")"
        sleep 2
        return
    fi
    
    # Execute selected cleanup functions
    for choice in "${selections[@]}"; do
        echo -e "${BOLD}${BLUE}$(get_text "processing_category") $choice...${NC}"
        case $choice in
            1) clean_system_caches ;;
            2) clean_user_caches ;;
            3) clean_browser_data ;;
            4) clean_dev_tools ;;
            5) clean_trash_downloads ;;
            6) clean_system_temp ;;
        esac
        echo -e "${BOLD}${GREEN}$(get_text "category_complete") $choice${NC}"
        echo ""
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
    echo -e "${CYAN}[1]${NC} $(get_text "menu_1") ${RED}$(get_text "requires_admin")${NC}"
    echo -e "${CYAN}[2]${NC} $(get_text "menu_2")"
    echo -e "${CYAN}[3]${NC} $(get_text "menu_3")"
    echo -e "${CYAN}[4]${NC} $(get_text "menu_4")"
    echo -e "${CYAN}[5]${NC} $(get_text "menu_5")"
    echo -e "${CYAN}[6]${NC} $(get_text "menu_6") ${RED}$(get_text "requires_admin")${NC}"
    echo -e "${CYAN}[7]${NC} ${YELLOW}$(get_text "menu_7")${NC}"
    echo -e "${CYAN}[8]${NC} $(get_text "menu_8")"
    echo ""
    echo -e "${YELLOW}Tip: Enter numbers to select cleanup items, separate with spaces${NC}"
    echo ""
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
        read -p "$(echo -e ${WHITE}$(get_text "enter_choice")${NC})" choice
        echo ""
        
        # Handle language menu
        if [[ "$choice" == "8" ]]; then
            show_language_menu
            continue
        fi
        
        # Parse input - handle both single numbers and space-separated numbers
        if [[ "$choice" =~ ^[1-7]([[:space:]]+[1-7])*$ ]]; then
            # Convert choice to array
            read -ra selections <<< "$choice"
            
            # Handle "7" (select all)
            if [[ " ${selections[*]} " =~ " 7 " ]]; then
                selections=(1 2 3 4 5 6)
            fi
            
            # Remove duplicates and sort
            selections=($(printf '%s\n' "${selections[@]}" | grep -E '^[1-6]$' | sort -u))
            
            if [[ ${#selections[@]} -gt 0 ]]; then
                execute_selected_cleanups "${selections[*]}"
                show_summary
                echo ""
                read -p "$(echo -e ${WHITE}$(get_text "press_enter")${NC})"
                # Reset counters for next round
                total_cleaned=0
                total_items=0
                cleaned_paths=()
                skipped_paths=()
            fi
        else
            print_error "$(get_text "invalid_choice")"
            sleep 2
        fi
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