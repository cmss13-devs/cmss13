/obj/item/hardpoint/secondary/m56cupola
	name = "M56 Cupola"
	desc = "A secondary weapon for tanks that shoots bullets"

	icon_state = "m56_cupola"
	disp_icon = "tank"
	disp_icon_state = "m56cupola"
	activation_sounds = list('sound/weapons/gun_smartgun1.ogg', 'sound/weapons/gun_smartgun2.ogg', 'sound/weapons/gun_smartgun3.ogg', 'sound/weapons/gun_smartgun4.ogg')

	health = 350
	firing_arc = 120

	ammo = new /obj/item/ammo_magazine/hardpoint/m56_cupola
	max_clips = 1

	muzzle_flash_pos = list(
		"1" = list(8, -1),
		"2" = list(-7, -15),
		"4" = list(6, -10),
		"8" = list(-5, 7)
	)

	scatter = 3
	gun_firemode = GUN_FIREMODE_BURSTFIRE
	gun_firemode_list = list(
		GUN_FIREMODE_BURSTFIRE,
	)
	burst_amount = 3
	burst_delay = 0.3 SECONDS
	extra_delay = 0.6 SECONDS

/obj/item/hardpoint/secondary/m56cupola/set_bullet_traits()
	..()
	LAZYADD(traits_to_give, list(
		BULLET_TRAIT_ENTRY(/datum/element/bullet_trait_iff)
	))
