#!/bin/bash
# Visa svensk veckodag med stor första bokstav, datum, veckonummer och tid

weekday=$(LC_TIME=sv_SE.UTF-8 date +"%A")
day=$(date +"%-d")
month=$(LC_TIME=sv_SE.UTF-8 date +"%b" | tr '[:upper:]' '[:lower:]')
week=$(date +"%V")
time=$(date +"%H:%M")

# Kapitalisera första bokstaven
weekday_cap="${weekday^}"

# Svenskt ordinaltal (1:a, 2:a, 3:e, etc.)
if [[ "$day" == "1" || "$day" == "2" ]]; then
    ordinal=":a"
else
    ordinal=":e"
fi

echo "${weekday_cap} ${day}${ordinal} ${month} - Vecka ${week} - ${time}"
