#!/usr/bin/env bash

INSTALL_DIR="/usr/local/bin"
SCRIPT_NAME="doze-simulator"
SOURCE_FILE="$(dirname "$0")/../bin/doze-simulator"

# Colors
GREEN='\033[0;32m'
RED='\033[0;31m'
RESET='\033[0m'

if [ "$EUID" -ne 0 ]; then
  printf "${RED}Error: Please run as root (sudo).${RESET}\n"
  exit 1
fi

if [ ! -f "$SOURCE_FILE" ]; then
  printf "${RED}Error: $SOURCE_FILE not found in current directory.${RESET}\n"
  exit 1
fi

printf "Installing $SCRIPT_NAME to $INSTALL_DIR...\n"
cp "$SOURCE_FILE" "$INSTALL_DIR/$SCRIPT_NAME"
chmod +x "$INSTALL_DIR/$SCRIPT_NAME"

if [ -f "$INSTALL_DIR/$SCRIPT_NAME" ]; then
  printf "${GREEN}Success! $SCRIPT_NAME installed.${RESET}\n"
  printf "You can now run it from anywhere: ${GREEN}$SCRIPT_NAME --help${RESET}\n"
else
  printf "${RED}Installation failed.${RESET}\n"
  exit 1
fi
