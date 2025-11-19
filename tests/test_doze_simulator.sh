#!/usr/bin/env bash

# ==========================================
# Test Suite for doze-simulator.sh
# ==========================================

# Ensure we are in the project root
cd "$(dirname "$0")/.." || exit 1

SCRIPT="./bin/doze-simulator"
MOCK_LOG="$(pwd)/mock_adb.log"
TMP_BIN="$(pwd)/tmp_bin"

# Colors
GREEN='\033[0;32m'
RED='\033[0;31m'
RESET='\033[0m'

pass_count=0
fail_count=0

log_pass() {
  printf "${GREEN}[PASS]${RESET} $1\n"
  pass_count=$((pass_count + 1))
}

log_fail() {
  printf "${RED}[FAIL]${RESET} $1\n"
  fail_count=$((fail_count + 1))
}

setup_mock() {
  mkdir -p "$TMP_BIN"
  cat <<EOF > "$TMP_BIN/adb"
#!/bin/bash
echo "adb \$*" >> "$MOCK_LOG"
if [[ "\$*" == *"devices"* ]]; then
  echo "List of devices attached"
  echo "emulator-5554 device"
elif [[ "\$*" == *"pidof"* ]]; then
  # Default to returning a PID unless overridden
  if [ -f "$TMP_BIN/no_pid" ]; then
    echo ""
  else
    echo "12345"
  fi
fi
EOF
  chmod +x "$TMP_BIN/adb"
  export PATH="$TMP_BIN:$PATH"
}

cleanup() {
  rm -rf "$TMP_BIN" "$MOCK_LOG"
}

echo "Running tests..."
cleanup
setup_mock

# ------------------------------------------
# Test 1: Missing Arguments
# ------------------------------------------
output=$($SCRIPT 2>&1)
if [[ "$output" == *"Package and wait time are required"* ]]; then
  log_pass "Missing arguments check"
else
  log_fail "Missing arguments check failed"
  echo "Output: $output"
fi

# ------------------------------------------
# Test 2: Standard Flow (Mocked)
# ------------------------------------------
rm -f "$MOCK_LOG"
$SCRIPT --package com.test --wait 1 > /dev/null 2>&1

if [ -f "$MOCK_LOG" ] && grep -q "adb shell dumpsys battery unplug" "$MOCK_LOG" && \
   grep -q "adb shell dumpsys deviceidle force-idle" "$MOCK_LOG"; then
  log_pass "Standard flow execution (Mocked)"
else
  log_fail "Standard flow execution failed."
  if [ -f "$MOCK_LOG" ]; then
    echo "Log content:"
    cat "$MOCK_LOG"
  else
    echo "Log file not found."
  fi
fi

# ------------------------------------------
# Test 3: Kill Flag
# ------------------------------------------
rm -f "$MOCK_LOG"
$SCRIPT --package com.test --wait 1 --kill > /dev/null 2>&1

if [ -f "$MOCK_LOG" ] && grep -q "adb shell am force-stop com.test" "$MOCK_LOG"; then
  log_pass "Kill flag triggers force-stop"
else
  log_fail "Kill flag failed to trigger force-stop"
  if [ -f "$MOCK_LOG" ]; then
    echo "Log content:"
    cat "$MOCK_LOG"
  fi
fi

# ------------------------------------------
# Test 4: Pre-flight Check (App not running)
# ------------------------------------------
rm -f "$MOCK_LOG"
touch "$TMP_BIN/no_pid" # Signal mock to return empty PID

output=$($SCRIPT --package com.test --wait 1 2>&1)
if [[ "$output" == *"WARNING: App 'com.test' is not running"* ]]; then
  log_pass "Pre-flight check warns when app is missing"
else
  log_fail "Pre-flight check failed"
  echo "Output: $output"
fi

rm -f "$TMP_BIN/no_pid"

# Cleanup
cleanup

echo "--------------------------------"
echo "Tests Completed: $pass_count Passed, $fail_count Failed"
if [ "$fail_count" -eq 0 ]; then
  exit 0
else
  exit 1
fi
