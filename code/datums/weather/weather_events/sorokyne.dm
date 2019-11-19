// Weather events for Sorokyne
/datum/weather_event/snow
    name = "Snow"
    display_name = "Snow"
    length = MINUTES_10
    fullscreen_type = /obj/screen/fullscreen/weather/snow
    effect_type = /datum/effects/weather/snow
    turf_overlay_icon_state = "strata_snowing"

/datum/weather_event/snowstorm
    name = "Snowstorm"
    display_name = "Snowstorm"
    length = MINUTES_6
    fullscreen_type = /obj/screen/fullscreen/weather/snowstorm
    effect_type = /datum/effects/weather/snowstorm
    turf_overlay_icon_state = "strata_storm"

/datum/weather_event/blizzard
    name = "Blizzard"
    display_name = "Blizzard"
    length = MINUTES_4
    fullscreen_type = /obj/screen/fullscreen/weather/blizzard
    turf_overlay_icon_state = "strata_blizzard"
    effect_type = /datum/effects/weather/snow
