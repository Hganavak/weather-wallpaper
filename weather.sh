#!/bin/bash

# Weather-Wallpaper V4: Sam Kavanagh, Tofu.dev.
# See the README for setup instructions.

#==========================================#
#               USER SETTINGS              #
#==========================================#

# Path to weather wallpapers directory
WEATHER_WALLPAPERS_DIRECTORY="/home/sam/Pictures/weather-wallpapers/"

# Wallpaper filenames and their corresponding weather conditions
HEAVY_RAIN_WALLPAPER="Rain.jpg" # Rain, Heavy Rain, Thunderstorm
LIGHT_RAIN_WALLPAPER="Light Rain.jpg" # Light Rain, Drizzle, Shower In Vicinity
CLOUDY_WALLPAPER="Cloudy.jpg" # Cloudy, Overcast, Mist, Fog
CLEAR_WALLPAPER="Clear.jpg" # Clear
SUNNY_WALLPAPER="Sunny.jpg" # Sunny
SNOW_WALLPAPER="Snow.jpg" # Snow
FALLBACK_WALLPAPER="Fallback.jpg" # Fallback: In case of no Internet access or other error

DOW_MODE_ENABLED=false # Selects the pictures from a different folder depending on the day of the week

#==========================================#
#             END USER SETTINGS            #
#==========================================#

# Get the DBUS_SESSION_BUS_ADDRESS environment variable: gsettings needs this but cron by default runs without it
PID=$(pgrep gnome-session | tail -n1)
export DBUS_SESSION_BUS_ADDRESS=$(grep -z DBUS_SESSION_BUS_ADDRESS /proc/$PID/environ|cut -d= -f2-)
export GIO_EXTRA_MODULES=/usr/lib/x86_64-linux-gnu/gio/modules/ # Allows you to run the script not as CRON

#==========================================#
#         DAY OF THE WEEK SETTINGS         #
#==========================================#

if [ "$DOW_MODE_ENABLED" = true ] ; then
	DOW=$(date +%u)
	case $DOW in
		1) WEATHER_WALLPAPERS_DIRECTORY="/home/sam/Pictures/weather-wallpapers/monet/" # Monday: Monet
			;;
		2) WEATHER_WALLPAPERS_DIRECTORY="/home/sam/Pictures/weather-wallpapers/matisse/" # Tuesday: Matisse
			;;
		3) WEATHER_WALLPAPERS_DIRECTORY="/home/sam/Pictures/weather-wallpapers/friedrich/" # Wednesday: Friedrich
			;;
		4) WEATHER_WALLPAPERS_DIRECTORY="/home/sam/Pictures/weather-wallpapers/chagall/" # Thursday: Chagall
			;;
		*) RPIC=$(find /home/sam/Pictures/weather-wallpapers/ -not -type d | shuf -n 1); # Fridays & Weekends: Randomized picture
			echo "Random picture: $RPIC"
			gsettings set org.gnome.desktop.background picture-uri "file://${RPIC}"
			gsettings set org.gnome.desktop.screensaver picture-uri "file://${RPIC}"
			exit;
			;;
	esac
fi

#==========================================#
#       END DAY OF THE WEEK SETTINGS       #
#==========================================#

# Welcome message 
echo -e ''$_{1..69}'\b='
echo -e "\tSam Kavanagh's Epic Weather Wallpaper Switcher\t"
echo -e "\t\t\ttofu.dev"
echo -e ''$_{1..69}'\b='

# Get current weather
CUR_WEATHER=$(curl --silent wttr.in?format="%C")

echo -e "Wallpaper directory:\t $WEATHER_WALLPAPERS_DIRECTORY"
echo -e "Current weather:\t $CUR_WEATHER"

# Decide on the appropriate wallpaper
shopt -s nocasematch; # Ignore case
if [[ $CUR_WEATHER =~ Thunderstorm|Heavy|^Rain$ ]]; then
	SELECTED_WALLPAPER=$HEAVY_RAIN_WALLPAPER
elif [[ $CUR_WEATHER =~ Shower|Drizzle|"Light Rain" ]]; then
	SELECTED_WALLPAPER=$LIGHT_RAIN_WALLPAPER
elif [[ $CUR_WEATHER =~ Cloudy|Overcast|Mist|Fog ]]; then
	SELECTED_WALLPAPER=$CLOUDY_WALLPAPER
elif [[ $CUR_WEATHER =~ Clear ]]; then
	SELECTED_WALLPAPER=$CLEAR_WALLPAPER
elif [[ $CUR_WEATHER =~ Sunny ]]; then
	SELECTED_WALLPAPER=$SUNNY_WALLPAPER;
elif [[ $CUR_WEATHER =~ Snow ]]; then
	SELECTED_WALLPAPER=$SNOW_WALLPAPER;
else
	SELECTED_WALLPAPER=$FALLBACK_WALLPAPER;
fi

echo -e "Setting wallpaper to:\t $SELECTED_WALLPAPER"


# Set the wallpaper
echo -e "file://${WEATHER_WALLPAPERS_DIRECTORY}/${SELECTED_WALLPAPER}"
gsettings set org.gnome.desktop.background picture-uri "file://${WEATHER_WALLPAPERS_DIRECTORY}/${SELECTED_WALLPAPER}"
gsettings set org.gnome.desktop.screensaver picture-uri "file://${WEATHER_WALLPAPERS_DIRECTORY}/${SELECTED_WALLPAPER}"
