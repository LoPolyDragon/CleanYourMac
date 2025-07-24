#!/bin/bash

# CleanMac - Advanced macOS System Cleanup Tool
# Version: 2.0
# Author: CleanYourMac Project
# Description: Interactive macOS cleanup utility with beautiful interface

set -euo pipefail

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

# Global variables
total_cleaned=0
total_items=0
cleaned_paths=()
skipped_paths=()

# Utility functions
print_header() {
    clear
    echo -e "${BOLD}${CYAN}"
    echo "╔══════════════════════════════════════════════════════════════════════════════╗"
    echo "║                    🧼 CleanMac - macOS System Cleanup Tool                   ║"
    echo "║                           Interactive Cleanup Utility                       ║"
    echo "╚══════════════════════════════════════════════════════════════════════════════╝"
    echo -e "${NC}"
    echo -e "${WHITE}This tool helps you safely clean cache and junk files from your macOS system.${NC}"
    echo -e "${WHITE}You will be asked before anything is deleted. Let's begin.${NC}"
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
        print_info "Path not found: $path"
        return 0
    fi
    
    size=$(get_size "$path")
    
    if [[ "$size" == "0B" ]]; then
        print_info "Already clean: $description"
        return 0
    fi
    
    echo -e "${BOLD}${YELLOW}$description${NC}"
    echo -e "  ${CYAN}→ Path: $path${NC}"
    echo -e "  ${CYAN}→ Size: $size${NC}"
    
    read -p "$(echo -e ${WHITE}Do you want to clean this? [y/N]: ${NC})" -n 1 -r
    echo
    
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        echo -e "${CLEAN_ICON} Cleaning..."
        if rm -rf "$path"/* "$path"/.[^.]* 2>/dev/null; then
            print_success "Cleaned: $description ($size freed)"
            cleaned_paths+=("$description: $size")
            ((total_cleaned++))
        else
            print_error "Failed to clean: $description"
        fi
    else
        print_skip "Skipped: $description"
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
        print_info "Path not found: $path"
        return 0
    fi
    
    size=$(get_size "$path")
    
    if [[ "$size" == "0B" ]]; then
        print_info "Already clean: $description"
        return 0
    fi
    
    echo -e "${BOLD}${YELLOW}$description${NC} ${RED}(requires admin password)${NC}"
    echo -e "  ${CYAN}→ Path: $path${NC}"
    echo -e "  ${CYAN}→ Size: $size${NC}"
    
    read -p "$(echo -e ${WHITE}Do you want to clean this? [y/N]: ${NC})" -n 1 -r
    echo
    
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        echo -e "${CLEAN_ICON} Cleaning (admin password required)..."
        if sudo rm -rf "$path"/* "$path"/.[^.]* 2>/dev/null; then
            print_success "Cleaned: $description ($size freed)"
            cleaned_paths+=("$description: $size")
            ((total_cleaned++))
        else
            print_error "Failed to clean: $description"
        fi
    else
        print_skip "Skipped: $description"
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
    
    read -p "$(echo -e ${WHITE}Do you want to run this cleanup? [y/N]: ${NC})" -n 1 -r
    echo
    
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        echo -e "${CLEAN_ICON} Running cleanup..."
        if eval "$command" >/dev/null 2>&1; then
            print_success "Completed: $description"
            cleaned_paths+=("$description")
            ((total_cleaned++))
        else
            print_error "Failed: $description"
        fi
    else
        print_skip "Skipped: $description"
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
    echo -e "${BOLD}${COMPUTER_ICON} User-Level Caches & Logs${NC}"
    print_separator
    
    safe_clean "$HOME/Library/Caches" "User application caches"
    safe_clean "$HOME/Library/Logs" "User application logs"
    safe_clean "$HOME/Library/Application Support/CrashReporter" "Crash reports"
    safe_clean "$HOME/Library/Saved Application State" "Saved application states"
    safe_clean "$HOME/Library/Application Support/com.apple.sharedfilelist" "Shared file lists"
}

clean_system_caches() {
    print_separator
    echo -e "${BOLD}${COMPUTER_ICON} System-Level Caches${NC}"
    print_separator
    
    sudo_clean "/Library/Caches" "System application caches"
    sudo_clean "/private/var/folders" "System temporary files"
    sudo_clean "/private/var/log" "System logs"
    sudo_clean "/Library/Logs/DiagnosticReports" "System diagnostic reports"
}

clean_browser_caches() {
    print_separator
    echo -e "${BOLD}${BROWSER_ICON} Browser Caches${NC}"
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
    echo -e "${BOLD}${DEV_ICON} Development Tools${NC}"
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
    echo -e "${BOLD}🧩 Application Caches${NC}"
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
    echo -e "${BOLD}${TRASH_ICON} Trash & Miscellaneous${NC}"
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

# Function to show final summary
show_summary() {
    print_separator
    echo -e "${BOLD}${SPARKLE_ICON} Cleanup Summary${NC}"
    print_separator
    
    echo -e "${BOLD}${GREEN}Cleaned items ($total_cleaned/$total_items):${NC}"
    if [[ ${#cleaned_paths[@]} -gt 0 ]]; then
        for item in "${cleaned_paths[@]}"; do
            echo -e "  ${CHECK_ICON} $item"
        done
    else
        echo -e "  ${INFO_ICON} No items were cleaned"
    fi
    
    echo ""
    echo -e "${BOLD}${YELLOW}Skipped items:${NC}"
    if [[ ${#skipped_paths[@]} -gt 0 ]]; then
        for item in "${skipped_paths[@]}"; do
            echo -e "  ${SKIP_ICON} $item"
        done
    else
        echo -e "  ${INFO_ICON} No items were skipped"
    fi
    
    echo ""
    echo -e "${BOLD}${SPARKLE_ICON} All selected items have been processed. Thank you for using CleanMac!${NC}"
    echo ""
}

# Main menu function
show_menu() {
    echo -e "${BOLD}${WHITE}Select cleanup categories:${NC}"
    echo ""
    echo -e "${CYAN}[1]${NC} User-level caches & logs"
    echo -e "${CYAN}[2]${NC} System-level caches ${RED}(requires admin)${NC}"
    echo -e "${CYAN}[3]${NC} Browser caches"
    echo -e "${CYAN}[4]${NC} Development tools"
    echo -e "${CYAN}[5]${NC} Application caches"
    echo -e "${CYAN}[6]${NC} Trash & miscellaneous"
    echo -e "${CYAN}[7]${NC} Clean everything ${RED}(interactive)${NC}"
    echo -e "${CYAN}[8]${NC} Exit"
    echo ""
}

# Main execution
main() {
    print_header
    
    while true; do
        show_menu
        read -p "$(echo -e ${WHITE}Enter your choice [1-8]: ${NC})" choice
        echo ""
        
        case $choice in
            1) clean_user_caches ;;
            2) clean_system_caches ;;
            3) clean_browser_caches ;;
            4) clean_dev_tools ;;
            5) clean_app_caches ;;
            6) clean_trash_and_misc ;;
            7) 
                clean_user_caches
                clean_system_caches
                clean_browser_caches
                clean_dev_tools
                clean_app_caches
                clean_trash_and_misc
                ;;
            8) 
                echo -e "${BOLD}${GREEN}Thank you for using CleanMac! Goodbye! ${SPARKLE_ICON}${NC}"
                exit 0
                ;;
            *) 
                print_error "Invalid choice. Please select 1-8."
                continue
                ;;
        esac
        
        show_summary
        echo ""
        read -p "$(echo -e ${WHITE}Press Enter to continue or Ctrl+C to exit...${NC})"
        print_header
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