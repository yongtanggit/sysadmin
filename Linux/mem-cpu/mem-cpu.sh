#! /bin/bash

# This Program monitors CPU/Memory utilization and send warning when they reach the thresholds.

which sar > /dev/null

[[ $? -ne 0 ]] && echo "ERROR: sar command not found, exit.." && exit 1

# Grep CPU and Memory Status
idle_cpu=$(sar -u 1 1 | grep ^Average: | awk '{print $8}')
used_mem=$(sar -r 1 1 | grep ^Average: | awk '{print $4}')

# Set CPU and Memory Threshold
alert_cpu=10 # idle CPU
alert_mem=80  # used memory

# Get Results
result_cpu=$(echo  "$idle_cpu < $alert_cpu" | bc -l)
result_mem=$(echo  "$used_mem > $alert_mem" | bc -l)

# Output
echo -------------------------

[[ "$result_cpu" -eq 1 ]] && echo "WARNING! CPU Reached Threshold!"

[[ "$result_mem" -eq 1 ]] && echo "WARNING! Memory Reached Threshold!"

echo "CPU_Idle: $idle_cpu%"

echo "MEM_Used: $used_mem%"

echo ------------------------

