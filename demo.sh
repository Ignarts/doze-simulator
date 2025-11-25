#!/usr/bin/env bash

# Demo script for doze-simulator
# This script demonstrates the key features of the tool
# Record with: asciinema rec demo.cast -c "./demo.sh"

set -e

# Colors for demo
CYAN='\033[0;36m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RESET='\033[0m'

demo_sleep() {
  sleep "${1:-2}"
}

clear

echo -e "${CYAN}╔═══════════════════════════════════════════════════════╗${RESET}"
echo -e "${CYAN}║                                                       ║${RESET}"
echo -e "${CYAN}║                DOZE-SIMULATOR - DEMO                  ║${RESET}"
echo -e "${CYAN}║                                                       ║${RESET}"
echo -e "${CYAN}╚═══════════════════════════════════════════════════════╝${RESET}"
echo ""
demo_sleep 2

echo -e "${GREEN}▶ 1. Show help${RESET}"
echo -e "${YELLOW}\$ doze-simulator --help${RESET}"
demo_sleep 1
./bin/doze-simulator --help
echo ""
demo_sleep 2

echo -e "${GREEN}▶ 2. Dry run - Preview commands without execution${RESET}"
echo -e "${YELLOW}\$ doze-simulator -p com.example.app -w 5 --dry-run${RESET}"
demo_sleep 1
./bin/doze-simulator -p com.example.app -w 5 --dry-run
echo ""
demo_sleep 2

echo -e "${GREEN}▶ 3. Simulate with Force Stop (Cold Start)${RESET}"
echo -e "${YELLOW}\$ doze-simulator -p com.example.app -w 5 --kill --dry-run${RESET}"
demo_sleep 1
./bin/doze-simulator -p com.example.app -w 5 --kill --dry-run
echo ""
demo_sleep 2

echo -e "${GREEN}▶ 4. Verbose mode for debugging${RESET}"
echo -e "${YELLOW}\$ doze-simulator -p com.example.app -w 3 --verbose --dry-run${RESET}"
demo_sleep 1
./bin/doze-simulator -p com.example.app -w 3 --verbose --dry-run
echo ""
demo_sleep 2

echo -e "${GREEN}▶ 5. Reactivate app after simulation${RESET}"
echo -e "${YELLOW}\$ doze-simulator -p com.example.app -w 3 --activate --dry-run${RESET}"
demo_sleep 1
./bin/doze-simulator -p com.example.app -w 3 --activate --dry-run
echo ""
demo_sleep 2

echo -e "${GREEN}▶ 6. Full simulation with all flags${RESET}"
echo -e "${YELLOW}\$ doze-simulator -p com.example.app -w 5 --kill --activate --verbose --dry-run${RESET}"
demo_sleep 1
./bin/doze-simulator -p com.example.app -w 5 --kill --activate --verbose --dry-run
echo ""
demo_sleep 2

echo -e "${GREEN}▶ 7. Test error handling (missing arguments)${RESET}"
echo -e "${YELLOW}\$ doze-simulator${RESET}"
demo_sleep 1
./bin/doze-simulator 2>&1 || true
echo ""
demo_sleep 2

echo -e "${CYAN}╔═══════════════════════════════════════════════════════╗${RESET}"
echo -e "${CYAN}║                                                       ║${RESET}"
echo -e "${CYAN}║                   DEMO COMPLETE                       ║${RESET}"
echo -e "${CYAN}║                                                       ║${RESET}"
echo -e "${CYAN}║  For real device testing, remove --dry-run flag       ║${RESET}"
echo -e "${CYAN}║  and connect an Android device via ADB                ║${RESET}"
echo -e "${CYAN}║                                                       ║${RESET}"
echo -e "${CYAN}╚═══════════════════════════════════════════════════════╝${RESET}"
echo ""
