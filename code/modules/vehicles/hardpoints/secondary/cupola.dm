/obj/item/hardpoint/gun/m56cupola
	name = "M56 Cupola"
	desc = "A secondary weapon for tanks that shoots bullets"

	icon_state = "m56_cupola"
	disp_icon = "tank"
	disp_icon_state = "m56cupola"
	firing_sounds = list('sound/weapons/gun_smartgun1.ogg', 'sound/weapons/gun_smartgun2.ogg', 'sound/weapons/gun_smartgun3.ogg')

	slot = HDPT_SECONDARY

	point_cost = 400
	health = 350
	damage_multiplier = 0.125
	cooldown = 5
	accuracy = 0.7
	firing_arc = 90
	range_multiplier = 3

	origins = list(0, -2)

	ammo = new /obj/item/ammo_magazine/hardpoint/m56_cupola

	muzzle_flash_pos = list(
		"1" = list(8, -1),
		"2" = list(-7, -15),
		"4" = list(6, -10),
		"8" = list(-5, 7)
	)
