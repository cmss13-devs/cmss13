/obj/item/hardpoint/gun/towlauncher
	name = "TOW Launcher"
	desc = "A secondary weapon for tanks that shoots rockets"

	icon_state = "tow_launcher"
	disp_icon = "tank"
	disp_icon_state = "towlauncher"

	slot = HDPT_SECONDARY

	point_cost = 500
	health = 500
	damage_multiplier = 0.125
	cooldown = 150
	accuracy = 0.8
	firing_arc = 60

	origins = list(0, -2)

	ammo = new /obj/item/ammo_magazine/hardpoint/towlauncher

	px_offsets = list(
		"1" = list(1, 10),
		"2" = list(-1, 5),
		"4" = list(0, 0),
		"8" = list(0, 18)
	)

	muzzle_flash_pos = list(
		"1" = list(8, -1),
		"2" = list(-8, -16),
		"4" = list(5, -8),
		"8" = list(-5, 10)
	)
