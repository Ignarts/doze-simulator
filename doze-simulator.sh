#!/usr/bin/env bash

# ===========================
# Default values
# ===========================
USE_COLORS=true
VERBOSE=false
ACTIVATE_APP=false
DRY_RUN=false
KILL_APP=false
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

run_cmd() {
  if [ "$DRY_RUN" = true ]; then
    printf "${cyan}[DRY-RUN] %s${reset}\n" "$*"
  else
    "$@"
  fi
}

usage() {
  echo "Usage:"
  echo "  $0 -p <PACKAGE> -w <SECONDS> [options]"
  echo ""
  echo "Options:"
  echo "  -a, --activate         Reactivate the app at the end"
  echo "  -d, --dry-run          Print commands without executing"
  echo "  -k, --kill             Force stop the app (simulate system kill)"
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
    -d|--dry-run)
      DRY_RUN=true
      ;;
    -k|--kill)
      KILL_APP=true
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

# 2. Check if a device is connected (Skip in Dry Run)
if [ "$DRY_RUN" = false ]; then
  device_count=$(adb devices | grep -w "device" | grep -v "List of devices attached" | wc -l)

  if [ "$device_count" -eq 0 ]; then
      printf "${red}Error: No Android device found.${reset}\n"
      printf "Please connect a device and enable USB Debugging.\n"
      exit 1
  elif [ "$device_count" -gt 1 ]; then
      printf "${yellow}Warning: Multiple devices connected. Using the first one found.${reset}\n"
  fi
fi

# ===========================
# Validate required arguments
# ===========================
if [ -z "$PACKAGE" ] || [ -z "$WAIT_TIME" ]; then
  printf "${red}Error:${reset} Package and wait time are required.\n"
  usage
fi

# ===========================
# Pre-flight Check
# ===========================
if [ "$DRY_RUN" = false ]; then
  initial_pid=$(adb shell pidof "$PACKAGE")
  if [ -z "$initial_pid" ]; then
    printf "${yellow}WARNING: App '$PACKAGE' is not running!${reset}\n"
    printf "The simulation might not work as expected if the app is not started.\n"
    printf "Please open the app before running this script.\n"
    sleep 2
  else
    log "App is running (PID: $initial_pid)"
  fi
fi

total_steps=5
if [ "$ACTIVATE_APP" = true ]; then
total_steps=$((total_steps + 1))
fi
if [ "$KILL_APP" = true ]; then
total_steps=$((total_steps + 1))
fi

step_counter=1

# ===========================
# START SIMULATION
# ===========================
printf "${cyan}--- DOZE SIMULATION ---${reset}\n"
if [ "$DRY_RUN" = true ]; then
  printf "${yellow}[DRY-RUN ENABLED] No commands will be executed${reset}\n"
fi
printf "Package: %s\n" "$PACKAGE"
printf "Simulated wait: %s seconds\n" "$WAIT_TIME"
printf -- "------------------------------------\n"

printf "${yellow}[$step_counter/$total_steps] Unplugging battery...${reset}\n"
run_cmd adb shell dumpsys battery unplug
log "Battery unplug forced"
step_counter=$((step_counter + 1))
sleep 1

printf "${yellow}[$step_counter/$total_steps] Forcing Doze idle mode...${reset}\n"
run_cmd adb shell dumpsys deviceidle force-idle
log "Doze deep idle forced"
step_counter=$((step_counter + 1))
sleep 1

printf "${yellow}[$step_counter/$total_steps] Forcing app into App Standby...${reset}\n"
run_cmd adb shell am set-inactive "$PACKAGE" true
log "App set to inactive"
step_counter=$((step_counter + 1))
sleep 1

if [ "$KILL_APP" = true ]; then
  printf "${yellow}[$step_counter/$total_steps] Killing app process (Simulating OS kill)...${reset}\n"
  
  if [ "$DRY_RUN" = false ]; then
    pid_before=$(adb shell pidof "$PACKAGE")
    if [ -n "$pid_before" ]; then
       log "PID before kill: $pid_before"
    else
       log "App was not running before kill."
    fi
  fi

  run_cmd adb shell am force-stop "$PACKAGE"
  
  if [ "$DRY_RUN" = false ]; then
    sleep 1
    pid_after=$(adb shell pidof "$PACKAGE")
    if [ -n "$pid_after" ]; then
       printf "${red}WARNING: App process still exists (PID: $pid_after). Force-stop might have failed or app auto-restarted.${reset}\n"
    else
       log "App killed successfully (No PID found)."
    fi
  else
    log "App force-stopped"
  fi
  
  step_counter=$((step_counter + 1))
  sleep 1
fi

printf "${yellow}[$step_counter/$total_steps] Waiting to simulate idle...${reset}\n"
for ((i=1; i<=WAIT_TIME; i++)); do
  if [ "$DRY_RUN" = false ]; then
    printf "\r\033[K${cyan}Waiting: %d / %d seconds${reset}" "$i" "$WAIT_TIME"
    sleep 1
  else
     # In dry run, just show one line to avoid spamming
     if [ "$i" -eq 1 ]; then
        printf "${cyan}Waiting %d seconds (simulated)...${reset}\n" "$WAIT_TIME"
     fi
  fi
done
if [ "$DRY_RUN" = false ]; then
  printf "\nDone waiting.\n"
fi
step_counter=$((step_counter + 1))
sleep 1

printf "${yellow}[$step_counter/$total_steps] Releasing Doze...${reset}\n"
run_cmd adb shell dumpsys deviceidle unforce
log "Doze unforced"
step_counter=$((step_counter + 1))
sleep 1

if [ "$ACTIVATE_APP" = true ]; then
  printf "${yellow}[$step_counter/$total_steps] Optional app reactivation...${reset}\n"
  printf "${cyan}→ Marking app as active (set-inactive false)${reset}\n"
  run_cmd adb shell am set-inactive "$PACKAGE" false
  
  # If we killed it, we might want to launch it? 
  # For now, just keeping the original behavior of 'set-inactive false' 
  # The user will likely launch it manually or we could add a 'monkey' command to launch it.
  fi

sleep 1

printf "${green}--- SIMULATION COMPLETE ---${reset}\n"
