#!/usr/bin/env bash

# mbar.sh - Minimal bash status bar library
# Zero-dependency status bar with keyboard handlers

# shellcheck disable=SC2034

if [[ ${BASH_VERSINFO[0]} -lt 4 ]]; then
  echo "Error: mbar requires bash 4.0 or later (current: $BASH_VERSION)" >&2
  exit 1
fi

green=$'\033[1;32m'
yellow=$'\033[1;33m'
cyan=$'\033[1;36m'
red=$'\033[1;31m'
magenta=$'\033[1;35m'
reset=$'\033[0m'

# Global state
declare -i paused=0
declare -A keys
declare -A handlers

# Core functions
function mbar_show {
  local msg=$1 color=${2:-"green"}
  local keys_display=""

  for key in "${!keys[@]}"; do
    keys_display+="($key)${keys[$key]} "
  done

  printf "\r${!color}[STATUS] %s | %s${reset}" "$msg" "$keys_display"
}

function mbar_add_key {
  local key=$1 desc=$2
  keys[$key]=$desc
}

function mbar_register {
  local key=$1 handler=$2

  if ! declare -f "$handler" >/dev/null 2>&1; then
    echo "Error: Handler '$handler' not found" >&2
    return 1
  fi

  handlers[$key]=$handler
}

function mbar_handle {
  local key=$1

  # Manual mode: explicit handler
  if [[ -n "${handlers[$key]}" ]]; then
    "${handlers[$key]}"
    return
  fi

  # Auto mode: convention-based handler
  local auto_handler="mbar_handler_${key}"
  if declare -f "$auto_handler" >/dev/null 2>&1; then
    "$auto_handler"
    return
  fi
}

function mbar_pause {
  while ((paused)); do
    mbar_show "Paused" "yellow"
    read -rst 0.5 -n 1 key && mbar_handle "$key"
  done
}

function mbar_loop {
  local msg=$1 color=${2:-"green"}

  mbar_show "$msg" "$color"
  read -rst 0.1 -n 1 key && mbar_handle "$key"
  mbar_pause
}
