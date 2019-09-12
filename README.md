# Weather Wallpaper Switcher (GNOME)
Set your desktop wallpaper/background based on the weather at your current location (GNOME).


##  Explanation & Setup
* The way the script works is quite simple: it `curl`s the [wttr.in](https://github.com/chubin/wttr.in/) free weather API using the command `curl --silent wttr.in?format="%C"`. The API responds with a single line of output describing the weather at your current location, for example:

```shell
[sam@samantha] λ curl --silent wttr.in?format="%C"
Light Rain
```

* Based on the weather condition, the script sets the wallpaper to any one of `6` images (it's up to you to download/save these).
  * The names of these files, as well as the directory they are located in **needs to be specified** in the `User Settings` section of `weather.sh`:

```
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
```

* This script simply has to be added as a `cron job` to execute every `5` minutes (or however often you want to query for weather updates).
  1) `crontab -e`
  2) Add the following line to the end of the the file (adjust according to the path to your `weather.sh`)
  ```
  */1 * * * * /home/sam/.rc/weather.sh
  ```

* You may need to `chmod +x weather.sh` as well as restart cron `sudo service cron restart`.

## Day of the Week Mode
* You can optionally enable the day of the week mode, this will look for your pictures in a different folder depending on the day of the week.
* Day of the week mode is enabled in the `USER SETTINGS` section by setting

```
DOW_MODE_ENABLED=true # Selects the pictures from a different folder depending on the day of the week
```

* The folders this script will look in for depending on the day of the week are configured in the  `DAY OF THE WEEK SETTINGS` section:

```
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
```
* **Note**: I've set up Fridays and Weekends to select a completely random picture from any of your 'days of the week folders' for a bit of fun, tweak to whatever suits your needs :neckbeard:
