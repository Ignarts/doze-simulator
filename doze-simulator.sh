#!/usr/bin/env bash

# ===========================
# Default values
# ===========================
USE_COLORS=true
VERBOSE=false
ACTIVATE_APP=false
PACKAGE=""
WAIT_TIME=""

# ===========================
# Colors (only used if enabled)
# ===========================
green='\033[0;32m'
yellow='\033[1;33m'
cyan='\033[0;36m'
red='\033[0;31m'
reset='\033[0m'

disable_colors() {
  green=""
  yellow=""
  cyan=""
  red=""
  reset=""
}

log() {
  if [ "$VERBOSE" = true ]; then
    printf "%s\n" "$1"
  fi
}

usage() {
  echo "Usage:"
  echo "  $0 -p <PACKAGE> -w <SECONDS> [options]"
  echo ""
  echo "Options:"
  echo "  -a, --activate         Reactivate the app at the end"
  echo "  -n, --no-colors        Disable color output"
  echo "  -v, --verbose          Enable verbose output"
  echo "  -p, --package <name>   Package name of the app"
  echo "  -w, --wait <seconds>   Waiting time to simulate idle"
  echo "  -h, --help             Show this help message"
  exit 1
}

# ===========================
# Parse FLAGS (short & long)
# ===========================
while [[ "$#" -gt 0 ]]; do
  case "$1" in
    -a|--activate)
      ACTIVATE_APP=true
      ;;
    -n|--no-colors)
      USE_COLORS=false
      ;;
    -v|--verbose)
      VERBOSE=true
      ;;
    -p|--package)
      PACKAGE="$2"
      shift
      ;;
    --package=*)
      PACKAGE="${1#*=}"
      ;;
    -w|--wait)
      WAIT_TIME="$2"
      shift
      ;;
    --wait=*)
      WAIT_TIME="${1#*=}"
      ;;
    -h|--help)
      usage
      ;;
    *)
      echo "Unknown option: $1"
      usage
      ;;
  esac
  shift
done

# Disable colors if requested
if [ "$USE_COLORS" = false ]; then
  disable_colors
fi

# ===========================
# Validate Environment
# ===========================

# 1. Check if ADB is installed
if ! command -v adb &> /dev/null; then
    printf "${red}Error: ADB is not installed or not in your PATH.${reset}\n"
    printf "Please install Android Platform Tools.\n"
    exit 1
fi

# 2. Check if a device is connected
device_count=$(adb devices | grep -w "device" | grep -v "List of devices attached" | wc -l)

if [ "$device_count" -eq 0 ]; then
    printf "${red}Error: No Android device found.${reset}\n"
    printf "Please connect a device and enable USB Debugging.\n"
    exit 1
elif [ "$device_count" -gt 1 ]; then
    printf "${yellow}Warning: Multiple devices connected. Using the first one found.${reset}\n"
fi

# ===========================
# Validate required arguments
# ===========================
if [ -z "$PACKAGE" ] || [ -z "$WAIT_TIME" ]; then
  printf "${red}Error:${reset} Package and wait time are required.\n"
  usage
fi

total_steps=5
if [ "$ACTIVATE_APP" = true ]; then
total_steps=6
fi

# ===========================
# START SIMULATION
# ===========================
printf "${cyan}--- DOZE SIMULATION ---${reset}\n"
printf "Package: %s\n" "$PACKAGE"
printf "Simulated wait: %s seconds\n" "$WAIT_TIME"
printf "------------------------------------\n"

printf "${yellow}[1/$total_steps] Unplugging battery...${reset}\n"
adb shell dumpsys battery unplug
log "Battery unplug forced"
sleep 1

printf "${yellow}[2/$total_steps] Forcing Doze idle mode...${reset}\n"
adb shell dumpsys deviceidle force-idle
log "Doze deep idle forced"
sleep 1

printf "${yellow}[3/$total_steps] Forcing app into App Standby...${reset}\n"
adb shell am set-inactive "$PACKAGE" true
log "App set to inactive"
sleep 1

printf "${yellow}[4/$total_steps] Waiting to simulate idle...${reset}\n"
for ((i=1; i<=WAIT_TIME; i++)); do
  printf "\r\033[K${cyan}Waiting: %d / %d seconds${reset}" "$i" "$WAIT_TIME"
  sleep 1
done
printf "\nDone waiting.\n"
sleep 1

printf "${yellow}[5/$total_steps] Releasing Doze...${reset}\n"
adb shell dumpsys deviceidle unforce
log "Doze unforced"
sleep 1

if [ "$ACTIVATE_APP" = true ]; then
  printf "${yellow}[6/$total_steps] Optional app reactivation...${reset}\n"
  printf "${cyan}→ Marking app as active (set-inactive false)${reset}\n"
  adb shell am set-inactive "$PACKAGE" false
  fi

sleep 1

printf "${green}--- SIMULATION COMPLETE ---${reset}\n"
