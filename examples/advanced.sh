#!/usr/bin/env bash

# Advanced example - Manual mode, mixed mode, and practical features
source ./lib/mbar.sh

# Define keys
mbar_add_key "p" "pause"
mbar_add_key "s" "stop"
mbar_add_key "l" "list"
mbar_add_key "i" "info"
mbar_add_key "h" "help"

# State variables
declare -i processed=0
declare -i total=0

# Auto mode handlers (convention-based)
mbar_handler_p() {
  paused=$((paused ? 0 : 1))
  echo "Pause toggled: $paused"
}

mbar_handler_s() {
  echo "Stopping..."
  exit 0
}

# Manual mode handlers (explicit registration)
list_files() {
  echo "Files in current directory:"
  ls -1 | head -5
}

show_info() {
  echo "Processing stats:"
  echo "  Total items: $total"
  echo "  Processed: $processed"
  echo "  Remaining: $((total - processed))"
}

show_help() {
  echo "Available commands:"
  echo "  p - pause/resume (auto mode)"
  echo "  s - stop (auto mode)"
  echo "  l - list files (manual mode)"
  echo "  i - show info (manual mode)"
  echo "  h - help (manual mode)"
}

# Register manual handlers
mbar_register "l" list_files
mbar_register "i" show_info
mbar_register "h" show_help

# Main loop
echo "Advanced example - Demonstrates auto + manual modes"
echo "Auto: p,s | Manual: l,i,h"
echo

total=20
for i in {1..20}; do
  processed=$i
  mbar_loop "Processing item $i/$total" "cyan"
  sleep 0.3
done

echo "Done!" 