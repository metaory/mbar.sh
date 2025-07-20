#!/usr/bin/env bash

# Basic example - Simple status bar with minimal configuration
source ./lib/mbar.sh

# Define keys
mbar_add_key "p" "pause"
mbar_add_key "q" "quit"

# Auto mode handlers (convention-based)
mbar_handler_p() {
  paused=$((paused ? 0 : 1))
}

mbar_handler_q() {
  echo "Exiting..."
  exit 0
}

# Simple loop
echo "Basic example - Press 'p' to pause, 'q' to quit"
echo

for i in {1..20}; do
  mbar_loop "Processing item $i" "green"
  sleep 0.5
done

echo "Done!" 