#!/bin/bash
# Visa antal körande Docker containers i waybar

count=$(docker ps -q 2>/dev/null | wc -l)
if [ "$count" -gt 0 ]; then
    echo "󰡨 $count"
else
    echo ""
fi
