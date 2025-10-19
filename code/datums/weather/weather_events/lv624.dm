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

GLOBAL_LIST_INIT(fog_tiles, list())

GLOBAL_LIST_INIT(big_fog_tiles, list())

/obj/effect/landmark/fog_marker
	name = "Fog marker"
	var/active = FALSE
	var/datum/effect_system/smoke_spread/fog/smoke
	icon_state = "fog"

/obj/effect/landmark/fog_marker/Initialize(mapload, ...)
	. = ..()
	GLOB.fog_tiles += src

/obj/effect/landmark/fog_marker/proc/activate()
	if(active)
		return
	active = TRUE
	addtimer(CALLBACK(src, PROC_REF(set_off)), rand(0,59))

/obj/effect/landmark/fog_marker/proc/set_off()
	var/duration = rand(5,10)
	smoke = new()
	smoke.set_up(radius = 0, loca = loc,smoke_time = duration)
	smoke.start()
	addtimer(CALLBACK(src, PROC_REF(deactivate)), duration)

/obj/effect/landmark/fog_marker/proc/deactivate()
	active = FALSE

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

/obj/effect/landmark/big_fog_marker/proc/despawn_fog()
	QDEL_NULL(linked_fog)


/obj/effect/landmark/fog_marker/Destroy()
	. = ..()
	GLOB.fog_tiles -= src

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

/obj/effect/big_fog/New(loc, ...)
	. = ..()
	animate(src, time = 2 SECONDS ,loop = 0, alpha = 256)

