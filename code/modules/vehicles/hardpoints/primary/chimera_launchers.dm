/obj/item/hardpoint/primary/chimera_launchers
	name = "\improper Chimera Launchers"
	desc = ""

	icon_state = "ace_autocannon"
	activation_sounds = list('sound/vehicles/vtol/launcher.ogg')

	health = 500
	firing_arc = 180

	ammo = new /obj/item/ammo_magazine/hardpoint/chimera_launchers_ammo
	max_clips = 2

	gun_firemode = GUN_FIREMODE_SEMIAUTO
	gun_firemode_list = list(
		GUN_FIREMODE_SEMIAUTO,
	)
	fire_delay = 10 SECONDS
