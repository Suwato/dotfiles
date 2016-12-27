/System/Library/PrivateFrameworks/Apple80211.framework/Versions/Current/Resources/airport airport -I | /usr/bin/grep -ie '^\s*ssid'  | cut -d ":" -f 2
