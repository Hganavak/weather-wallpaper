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
WEATHER_WALLPAPERS_DIRECTORY="/home/sam/Pictures/weather-wallpapers"

# Wallpaper filenames and their corresponding weather conditions
HEAVY_RAIN_WALLPAPER="Rain.jpg" # Rain, Heavy Rain, Thunderstorm
LIGHT_RAIN_WALLPAPER="Light Rain.jpg" # Light Rain, Drizzle, Shower In Vicinity
CLOUDY_WALLPAPER="Cloudy.jpg" # Cloudy, Overcast, 
CLEAR_WALLPAPER="Clear.jpg" # Clear
SUNNY_WALLPAPER="Sunny.jpg" # Sunny
SNOW_WALLPAPER="Snow.jpg" # Snow

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
