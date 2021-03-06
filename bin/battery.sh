#!/bin/bash

function get_percentage() {
  echo "$(pmset -g ps | egrep -o '[0-9]+%' | tr -d %)"
}

function is_charging() {
  pmset -g ps | grep -E "Battery Power|charged" >/dev/null 2>&1
  if [ $? -eq 0 ]; then
    return 1
  else
    return 0
  fi
}

function get_meter() {
  local percentage=$1
  if is_charging; then
    echo '|⚡︎⚡︎⚡︎⚡︎⚡︎|'
  else
    if [ $percentage -le 20 ]; then
      echo '|█    |'
    elif [ $percentage -gt 20 ] && [ $percentage -le 40 ]; then
      echo '|██   |'
    elif [ $percentage -gt 40 ] && [ $percentage -le 60 ]; then
      echo '|███  |'
    elif [ $percentage -gt 60 ] && [ $percentage -le 80 ]; then
      echo '|████ |'
    elif [ $percentage -gt 80 ] && [ $percentage -le 100 ]; then
      echo '|█████|'
    fi
  fi
}

function get_remain() {
  local time_remain
  time_remain="$(pmset -g ps | grep -o '[0-9]\+:[0-9]\+')"
  if [ -z "$time_remain" ]; then
    time_remain="no estimate"
  fi
  echo "$time_remain"
}

function display() {
  mode=$1
  percentage=$2
  display=$3
  if [ $mode == "shell" ]; then
    if is_charging; then
      echo -e "\033[32m${display}\033[m"
    else
      if [ $percentage -lt 20 ]; then
        echo -e "\033[31m${display}\033[m"
      else
        echo -e "\033[34m${display}\033[m"
      fi
    fi
  elif [ $mode == "tmux" ]; then
    if is_charging; then
      echo -e "#[fg=colour2]${display}#[default]"
    else
      if [ $percentage -lt 20 ]; then
        echo -e "#[fg=red]${display}#[default]"
      else
        echo -e "#[fg=blue]${display}#[default]"
      fi
    fi
  fi
}


MODE="shell"
PERCENTAGE="$(pmset -g ps | egrep -o '[0-9]+%' | tr -d %)"
DISPLAY="${PERCENTAGE}%"

for i in "$@"
do
  case "$i" in
    "-h")
      echo "usage: battery [-t tmux][-m meter][-r remain]" 1>&2
      exit
      ;;
    "-t")
      MODE="tmux"
      ;;
    "-m")
      DISPLAY="${DISPLAY} $(get_meter $PERCENTAGE)"
      ;;
    "-r")
      DISPLAY="${DISPLAY} ($(get_remain))"
      ;;
    -*)
      echo "$i: unknown option" 1>&2
      exit 1
      ;;
  esac
done
display $MODE $PERCENTAGE "$DISPLAY"