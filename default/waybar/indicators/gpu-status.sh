#!/bin/bash

if command -v nvidia-smi &>/dev/null; then
  output=$(nvidia-smi --query-gpu=utilization.gpu,temperature.gpu --format=csv,noheader,nounits 2>/dev/null)
  if [[ -n "$output" ]]; then
    usage=$(echo "$output" | cut -d',' -f1 | tr -d ' ')
    temp=$(echo "$output" | cut -d',' -f2 | tr -d ' ')
    echo "󰢮 ${usage}% ${temp}°C"
  fi
fi
