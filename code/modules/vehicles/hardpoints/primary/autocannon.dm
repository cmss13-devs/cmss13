/obj/item/hardpoint/primary/autocannon
	name = "AC3-E Autocannon"
	desc = "A primary autocannon for tanks that shoots explosive flak rounds"

	icon_state = "ace_autocannon"
	disp_icon = "tank"
	disp_icon_state = "ace_autocannon"
	activation_sounds = list('sound/weapons/vehicles/autocannon_fire.ogg')

	health = 500
	cooldown = 7
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
