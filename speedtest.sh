while true
do
  #!/bin/bash
  #foo=$(date)
  # speedtest=$(cat speedtest.txt)
  speedtest=$(speedtest-cli --simple)
  ssid=$(/System/Library/PrivateFrameworks/Apple80211.framework/Versions/Current/Resources/airport -I | awk '/ SSID/ {print substr($0, index($0, $2))}')
  printf '%s\t%s\n' "$(date '+%Y-%m-%d %H:%M')" "$ssid" "$speedtest" | tr '\n' '\t' >> speedtest_log.txt
  printf "\n" >> speedtest_log.txt
  sleep 300
done
