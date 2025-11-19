#!/usr/bin/env bash

INSTALL_DIR="/usr/local/bin"
SCRIPT_NAME="doze-simulator"

# Colors
GREEN='\033[0;32m'
RED='\033[0;31m'
RESET='\033[0m'

if [ "$EUID" -ne 0 ]; then
  printf "${RED}Error: Please run as root (sudo).${RESET}\n"
  exit 1
fi

if [ -f "$INSTALL_DIR/$SCRIPT_NAME" ]; then
  printf "Removing $SCRIPT_NAME from $INSTALL_DIR...\n"
  rm "$INSTALL_DIR/$SCRIPT_NAME"
  printf "${GREEN}Success! $SCRIPT_NAME uninstalled.${RESET}\n"
else
  printf "${RED}Error: $SCRIPT_NAME not found in $INSTALL_DIR.${RESET}\n"
  exit 1
fi
