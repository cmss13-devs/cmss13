/obj/item/explosive/warhead
	icon = 'icons/obj/items/weapons/grenade.dmi'
	customizable = TRUE
	allowed_sensors = list() //We only need a detonator
	ground_offset_x = 7
	ground_offset_y = 6

/obj/item/explosive/warhead/rocket
	name = "84mm rocket warhead"
	desc = "A custom warhead meant for 84mm rocket shells."
	icon_state = "warhead_rocket"
	max_container_volume = 210
	allow_star_shape = FALSE
	shrapnel_spread = 90
	matter = list("metal" = 11250) //3 sheets
	reaction_limits = list( "max_ex_power" = 220, "base_ex_falloff" = 160,"max_ex_shards" = 80,
							"max_fire_rad" = 4, "max_fire_int" = 45, "max_fire_dur" = 48,
							"min_fire_rad" = 2, "min_fire_int" = 4, "min_fire_dur" = 5
	)
	has_blast_wave_dampener = TRUE

/obj/item/explosive/warhead/mortar
	name = "80mm mortar warhead"
	desc = "A custom warhead meant for 80mm mortar shells."
	icon_state = "warhead_mortar"
	max_container_volume = 240
	matter = list("metal" = 11250) //3 sheets
	reaction_limits = list( "max_ex_power" = 360, "base_ex_falloff" = 130, "max_ex_shards" = 200,
							"max_fire_rad" = 8, "max_fire_int" = 45, "max_fire_dur" = 48,
							"min_fire_rad" = 3, "min_fire_int" = 5, "min_fire_dur" = 5
	)
	has_blast_wave_dampener = TRUE
	var/has_camera = FALSE

/obj/item/explosive/warhead/mortar/camera
	name = "80mm mortar camera warhead"
	desc = "A custom warhead meant for 80mm mortar shells. Camera drone included."
	max_container_volume = 180
	matter = list("metal" = 15000) //4 sheets
	has_camera = TRUE
