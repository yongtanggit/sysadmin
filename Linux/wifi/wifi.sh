
#! /bin/bash

# This code scans and show available SSID 

dev_name=$(iw dev | grep Interface | cut -d ' ' -f 2)
echo "Scanning available network..."
echo +++++++++++++++++++++++++++++++++++++++++++

iw dev $dev_name scan  | grep SSID:

echo +++++++++++++++++++++++++++++++++++++++++++

#wpa_supplicant -B -i wls3 -c /etc/wpa_supplicant/wpa_supplicant.conf
