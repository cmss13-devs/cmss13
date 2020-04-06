/obj/item/explosive/warhead
	icon = 'icons/obj/items/weapons/grenade.dmi'
	customizable = TRUE
	allowed_sensors = list() //We only need a detonator

/obj/item/explosive/warhead/rocket
	name = "84mm rocket warhead"
	desc = "A custom warhead meant for 84mm rocket shells."
	icon_state = "warhead_rocket"
	max_container_size = 120
	matter = list("metal" = 11250) //3 sheets
	reaction_limits = list(	"max_ex_power" = 300,	"max_ex_falloff" = 50,	"max_ex_shards" = 64,
							"max_fire_rad" = 7,		"max_fire_int" = 30,	"max_fire_dur" = 36,
							"min_fire_rad" = 2,		"min_fire_int" = 4,		"min_fire_dur" = 5
	)

/obj/item/explosive/warhead/mortar
	name = "80mm mortar warhead"
	desc = "A custom warhead meant for 80mm mortar shells."
	icon_state = "warhead_mortar"
	max_container_size = 300
	matter = list("metal" = 11250) //3 sheets
	reaction_limits = list(	"max_ex_power" = 360,	"max_ex_falloff" = 30,	"max_ex_shards" = 128,
							"max_fire_rad" = 8,		"max_fire_int" = 40,	"max_fire_dur" = 48,
							"min_fire_rad" = 3,		"min_fire_int" = 5,		"min_fire_dur" = 5
	)
