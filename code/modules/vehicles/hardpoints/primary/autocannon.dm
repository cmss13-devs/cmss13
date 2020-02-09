/obj/item/hardpoint/gun/autocannon
	name = "AC3-E Autocannon"
	desc = "A primary autocannon for tanks that shoots explosive flak rounds"

	icon_state = "ace_autocannon"
	disp_icon = "tank"
	disp_icon_state = "ace_autocannon"
	firing_sounds = list('sound/weapons/tank_autocannon_fire.ogg')

	slot = HDPT_PRIMARY

	point_cost = 600
	health = 500
	damage_multiplier = 0.15
	cooldown = 10
	accuracy = 0.98
	firing_arc = 60

	origins = list(0, -3)

	ammo = new /obj/item/ammo_magazine/hardpoint/ace_autocannon
	max_clips = 2

	px_offsets = list(
		"1" = list(0, 22),
		"2" = list(0, -32),
		"4" = list(32, 0),
		"8" = list(-32, 0)
	)
