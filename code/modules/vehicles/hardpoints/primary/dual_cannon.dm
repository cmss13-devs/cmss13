// APC cannons
/obj/item/hardpoint/gun/dualcannon
	name = "PARS-159 Boyars Dualcannon"
	desc = "A primary two-barrel cannon for the APC that shoots explosive flak rounds"
	icon = 'icons/obj/vehicles/hardpoints/apc.dmi'

	icon_state = "dual_cannon"
	disp_icon = "apc"
	disp_icon_state = "dualcannon"
	firing_sounds = list('sound/weapons/tank_autocannon_fire.ogg')

	slot = HDPT_PRIMARY

	point_cost = 600
	health = 500
	damage_multiplier = 0.15
	cooldown = 10
	accuracy = 0.98
	firing_arc = 60

	origins = list(0, -2)

	ammo = new /obj/item/ammo_magazine/hardpoint/boyars_dualcannon
	max_clips = 2

	muzzle_flash_pos = list(
		"1" = list(10, -29),
		"2" = list(-10, 10),
		"4" = list(-14, 9),
		"8" = list(14, 9)
	)

// Dual cannon, appropriately enough, fires twice
/obj/item/hardpoint/gun/dualcannon/activate(var/mob/user, var/atom/A)
	..()
	add_timer(CALLBACK(src, .proc/fire, user, A), 2)
