/obj/item/hardpoint/gun/flamer
	name = "DRG-N Offensive Flamer Unit"
	desc = "A primary weapon for the tank that spews fire everywhere."

	icon_state = "drgn_flamer"
	disp_icon = "tank"
	disp_icon_state = "drgn_flamer"
	firing_sounds = list('sound/weapons/tank_flamethrower.ogg')

	slot = HDPT_PRIMARY

	point_cost = 400
	health = 400
	damage_multiplier = 0.15
	cooldown = 20
	accuracy = 0.75
	firing_arc = 90

	origins = list(0, -3)

	ammo = new /obj/item/ammo_magazine/hardpoint/primary_flamer

	px_offsets = list(
		"1" = list(0, 21),
		"2" = list(0, -32),
		"4" = list(32, 1),
		"8" = list(-32, 1)
	)

	use_muzzle_flash = FALSE
