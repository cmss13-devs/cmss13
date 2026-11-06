/datum/weather_event/light_rain
	name = "Light Rain"
	display_name = "Light Rain"
	length = 8 MINUTES
	fullscreen_type = /atom/movable/screen/fullscreen/weather/low

	turf_overlay_icon_state = "strata_storm"
	turf_overlay_alpha = 50

	effect_message = null
	damage_per_tick = 0

	ambience = 'sound/ambience/rainforest.ogg'

	fire_smothering_strength = 1

/datum/weather_event/heavy_rain
	name = "Heavy Rain"
	display_name = "Heavy Rain"
	length = 12 MINUTES
	fullscreen_type = /atom/movable/screen/fullscreen/weather/medium

	turf_overlay_icon_state = "strata_storm"
	turf_overlay_alpha = 125

	effect_message = null
	damage_per_tick = 0

	ambience = 'sound/ambience/rainforest.ogg'

	has_process = TRUE
	lightning_chance = 2

	fire_smothering_strength = 4

GLOBAL_LIST_INIT(big_fog_tiles, list())

/obj/effect/landmark/big_fog_marker
	name = "Big fog spawner"
	var/obj/effect/big_fog/linked_fog

/obj/effect/landmark/big_fog_marker/Initialize(mapload, ...)
	. = ..()
	GLOB.big_fog_tiles += src

/obj/effect/landmark/big_fog_marker/proc/activate()
	addtimer(CALLBACK(src, PROC_REF(spawn_fog)),x * 4)

/obj/effect/landmark/big_fog_marker/proc/deactivate()
	addtimer(CALLBACK(src, PROC_REF(despawn_fog)),x * 4)

/obj/effect/landmark/big_fog_marker/proc/spawn_fog()
	linked_fog = new/obj/effect/big_fog(loc)
	linked_fog.linked_marker = src

/obj/effect/landmark/big_fog_marker/proc/despawn_fog()
	if(linked_fog)
		QDEL_NULL(linked_fog)


/obj/effect/landmark/big_fog_marker/Destroy()
	. = ..()
	GLOB.big_fog_tiles -= src
	if(linked_fog)
		QDEL_NULL(linked_fog)

/datum/weather_event/heavy_rain/fog
	name = "Heavy Rain with fog"
	display_name = "Heavy Rain with fog"

/datum/weather_event/heavy_rain/fog/handle_weather_process()
	. = ..()
	//for(var/i = 1 to 60)
	//	var/obj/effect/landmark/fog_marker/marker = pick(GLOB.fog_tiles)



/datum/weather_event/heavy_rain/fog/start_weather_event()
	for(var/obj/effect/landmark/big_fog_marker/marker as anything in GLOB.big_fog_tiles)
		marker.activate()

/datum/weather_event/heavy_rain/fog/end_weather_event()
	for(var/obj/effect/landmark/big_fog_marker/marker as anything in GLOB.big_fog_tiles)
		marker.deactivate()

/obj/effect/big_fog
	icon = 'icons/effects/192x192.dmi'
	icon_state = "massive_fog"
	alpha = 0
	var/obj/effect/landmark/big_fog_marker/linked_marker

/obj/effect/big_fog/New(loc, ...)
	. = ..()
	animate(src, time = 2 SECONDS ,loop = 0, alpha = 256)

/obj/effect/big_fog/Destroy(force)
	. = ..()
	if(linked_marker)
		QDEL_NULL(linked_marker)

