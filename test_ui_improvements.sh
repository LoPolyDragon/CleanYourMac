#!/bin/bash

# 测试界面优化效果

# Source only the needed parts
# Define color constants
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
WHITE='\033[1;37m'
BRIGHT_WHITE='\033[1;97m'
BRIGHT_CYAN='\033[1;96m'
BRIGHT_YELLOW='\033[1;93m'
BRIGHT_GREEN='\033[1;92m'
BOLD='\033[1m'
NC='\033[0m'

# Icons
CHECK_ICON="✅"
WARNING_ICON="⚠️"
INFO_ICON="ℹ️"

# Test functions
show_loading() {
    local message="$1"
    local duration="${2:-3}"
    local chars="⠋⠙⠹⠸⠼⠴⠦⠧⠇⠏"
    local i=0
    
    echo -n -e "${BOLD}${BRIGHT_CYAN}${message}${NC} "
    
    while [ $i -lt $((duration * 10)) ]; do
        printf "\r${BOLD}${BRIGHT_CYAN}${message}${NC} ${BRIGHT_YELLOW}${chars:$((i%10)):1}${NC}"
        sleep 0.1
        ((i++))
    done
    
    printf "\r${BOLD}${BRIGHT_CYAN}${message}${NC} ${GREEN}${CHECK_ICON}${NC}\n"
}

show_progress() {
    local current=$1
    local total=$2
    local message="$3"
    local width=30
    local percentage=$((current * 100 / total))
    local completed=$((current * width / total))
    
    local bar=""
    for ((i=0; i<completed; i++)); do bar+="█"; done
    for ((i=completed; i<width; i++)); do bar+="░"; done
    
    printf "\r${BOLD}${WHITE}${message}${NC} [${BRIGHT_CYAN}${bar}${NC}] ${BRIGHT_GREEN}${percentage}%%${NC} (${current}/${total})"
}

print_success() {
    echo -e "${BOLD}${GREEN}┌─────────────────────────────────────────────────────────────────────┐${NC}"
    printf "${BOLD}${GREEN}│${NC} ${GREEN}${CHECK_ICON} %-62s ${BOLD}${GREEN}│${NC}\n" "$1"
    echo -e "${BOLD}${GREEN}└─────────────────────────────────────────────────────────────────────┘${NC}"
}

print_info() {
    echo -e "${BOLD}${BLUE}┌─────────────────────────────────────────────────────────────────────┐${NC}"
    printf "${BOLD}${BLUE}│${NC} ${BLUE}${INFO_ICON} %-62s ${BOLD}${BLUE}│${NC}\n" "$1"
    echo -e "${BOLD}${BLUE}└─────────────────────────────────────────────────────────────────────┘${NC}"
}

print_warning() {
    echo -e "${BOLD}${YELLOW}┌─────────────────────────────────────────────────────────────────────┐${NC}"
    printf "${BOLD}${YELLOW}│${NC} ${YELLOW}${WARNING_ICON} %-62s ${BOLD}${YELLOW}│${NC}\n" "$1"
    echo -e "${BOLD}${YELLOW}└─────────────────────────────────────────────────────────────────────┘${NC}"
}

print_error() {
    echo -e "${BOLD}${RED}┌─────────────────────────────────────────────────────────────────────┐${NC}"
    printf "${BOLD}${RED}│${NC} ${RED}${WARNING_ICON} %-62s ${BOLD}${RED}│${NC}\n" "$1"
    echo -e "${BOLD}${RED}└─────────────────────────────────────────────────────────────────────┘${NC}"
}

# 运行测试
echo "🎨 界面优化效果演示"
echo "==================="

# 测试加载动画
echo -e "\n📡 测试加载动画："
show_loading "正在扫描系统" 2

# 测试进度条
echo -e "\n📊 测试进度条："
for i in {1..10}; do
    show_progress $i 10 "处理文件"
    sleep 0.2
done
echo ""

# 测试消息显示
echo -e "\n💬 测试消息显示："
print_success "操作完成！清理了 1.2GB 空间"
echo ""
print_info "发现 45 个可清理的文件"
echo ""
print_warning "建议重启系统以完成优化"
echo ""
print_error "无法访问某些系统目录"

echo -e "\n✨ 界面优化测试完成！"