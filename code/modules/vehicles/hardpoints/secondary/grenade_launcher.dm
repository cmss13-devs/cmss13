/obj/item/hardpoint/gun/grenade_launcher
	name = "Grenade Launcher"
	desc = "A secondary weapon for tanks that shoots grenades"

	icon_state = "glauncher"
	disp_icon = "tank"
	disp_icon_state = "glauncher"
	firing_sounds = list('sound/weapons/gun_m92_attachable.ogg')

	slot = HDPT_SECONDARY

	point_cost = 300
	health = 500
	damage_multiplier = 0.125
	cooldown = 30
	accuracy = 0.4
	firing_arc = 90

	origins = list(0, -2)

	ammo = new /obj/item/ammo_magazine/hardpoint/tank_glauncher
	max_clips = 3

	use_muzzle_flash = FALSE

	px_offsets = list(
		"1" = list(0, 17),
		"2" = list(0, 0),
		"4" = list(6, 0),
		"8" = list(-6, 17)
	)
