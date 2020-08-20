#! /bin/bash

## This program  outputs power status of laptop. 


# Check bc command availability 
which bc > /dev/null
[[ $? -ne 0 ]] && echo "ERROR: bc command not found, exit.." && exit 1 

# Preparation 
path='/sys/class/power_supply/BAT0'

alarm=$(cat $path/alarm)
full_design=$(grep FULL_DESIGN= $path/uevent | cut -d "=" -f 2)
full=$(grep FULL= $path/uevent | cut -d "=" -f 2)
now_power=$(grep POWER_NOW= $path/uevent | cut -d "=" -f 2)
now_energy=$(grep ENERGY_NOW= $path/uevent | cut -d "=" -f 2)


# Batteries life remains 
life=$(echo "scale=2; $full/$full_design*100" | bc)%


# Current batteries time remains
time_left(){
	hours=$(echo "scale=2; $now_energy/$now_power" | bc)
	h1=$(echo $hours | cut -d "." -f 1)
	h2=$(echo $hours | cut -d "." -f 2)
	m=$(echo "$h2*60/100" | bc)
        if [[ -n  $h1 ]];then 
	  time="$h1 hour(s) $m minuts"
        else 
          time="$m minuts"
       fi
}


# Low power warning 
[[ $now_energy -le $alarm ]] && printf "\n%15s %s\n" Warning: 'Battery is Critically Low!'

# Charging status  
status=$(cat $path/status) # Charge/Discharge
charge_left=$(echo "scale=2; ($full-$now_energy)/$full*100" | bc)% # Percentage to Fully Charged 

# Output 
echo ""
printf "%25s %15s\n" 'Battery Life:' "$life"
case $status in 
     Discharging )   time_left 
                     printf "\n%25s %15s\n" 'Charging Status:' "$status" 
                     printf "\n%25s %15s\n\n"  'Time Left:' "$time" ;;
        Charging )   printf "\n%25s %15s %32s\n\n" 'Charging Status:' "$status"  "$charge_left Left to Fully Charged";;
         Unknown | Full)   printf "\n%25s %22s\n\n" 'Charging Status:' 'Fully Charged' ;; # "Status: Unknown" = Stop Charging
esac 



























