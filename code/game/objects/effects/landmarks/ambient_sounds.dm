/obj/effect/landmark/ambient_sound
	name = "ambient sound"
	icon = 'icons/landmarks.dmi'
	icon_state = "sound"

	var/list/sound_list = list()
	var/min_delay = 30 SECONDS
	var/max_delay = 90 SECONDS
	var/volume = 35
	var/min_volume = 35
	var/vary = TRUE
	var/play_chance = 100
	var/sound_radius = 7
	var/play_once = FALSE

/obj/effect/landmark/ambient_sound/Initialize(mapload)
	. = ..()

	addtimer(CALLBACK(src, PROC_REF(play_random_sound)), rand(min_delay, max_delay))

/obj/effect/landmark/ambient_sound/proc/play_random_sound()
	if(QDELETED(src))
		return

	if(prob(play_chance) && length(sound_list))
		playsound(loc, pick(sound_list), rand(min_volume, volume), vary, sound_radius)
	if(play_once)
		return

	addtimer(CALLBACK(src, PROC_REF(play_random_sound)), rand(min_delay, max_delay))

// The sounds - static playing sound landmarks, can be configured easily. A variety of uses.

// Sounds will overlap, unlike the area ambience.

// Use short sounds, shorter the better. I'd say around 20 seconds max.

// Fire_Colony Sounds

/obj/effect/landmark/ambient_sound/lava
	name = "lava ambience" // For the lava rivers and pools

	sound_list = list(
		'sound/ambience/lava/lava_river/lava_1.ogg',
		'sound/ambience/lava/lava_river/lava_2.ogg',
		'sound/ambience/lava/lava_river/lava_3.ogg',
		'sound/ambience/lava/lava_river/lava_4.ogg',
		'sound/ambience/lava/lava_river/lava_5.ogg',
		'sound/ambience/lava/lava_river/lava_6.ogg',
		'sound/ambience/lava/lava_river/lava_7.ogg',
		'sound/ambience/lava/lava_river/lava_8.ogg',
		'sound/ambience/lava/lava_river/lava_9.ogg',
		'sound/ambience/lava/lava_river/lava_10.ogg',
		'sound/ambience/lava/lava_river/lava_11.ogg',
		'sound/ambience/lava/lava_river/lava_12.ogg',
		'sound/ambience/lava/lava_river/lava_13.ogg',
		'sound/ambience/lava/lava_river/lava_14.ogg',
		'sound/ambience/lava/lava_river/lava_15.ogg',
		'sound/ambience/lava/lava_river/lava_16.ogg',
		'sound/ambience/lava/lava_river/lava_17.ogg',
		'sound/ambience/lava/lava_river/lava_18.ogg',
		'sound/ambience/lava/lava_river/lava_19.ogg',
		'sound/ambience/lava/lava_river/lava_20.ogg',
		'sound/ambience/lava/lava_river/lava_21.ogg',
		'sound/ambience/lava/lava_river/lava_22.ogg',
		'sound/ambience/lava/lava_river/lava_23.ogg',
		'sound/ambience/lava/lava_river/lava_24.ogg',
		'sound/ambience/lava/lava_river/lava_25.ogg',
	)

	min_delay = 6 SECONDS
	max_delay = 18 SECONDS
	min_volume = 15
	volume = 55
	sound_radius = 5
	play_chance = 80
