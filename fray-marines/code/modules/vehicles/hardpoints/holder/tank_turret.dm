/obj/item/hardpoint/holder/tank_turret/flares
	name = "M34A2-B Multipurpose Turret"
	desc = "The centerpiece of the tank. Designed to support quick installation and deinstallation of various tank weapon modules. Has inbuilt flare launcher system."

	activation_sounds = list('sound/weapons/gun_m92_attachable.ogg')

	ammo = new /obj/item/ammo_magazine/hardpoint/flare_launcher
	max_clips = 3

	gun_firemode = GUN_FIREMODE_AUTOMATIC
	gun_firemode_list = list(
		GUN_FIREMODE_AUTOMATIC,
	)

/obj/item/ammo_magazine/hardpoint/flare_launcher/tank
	name = "M34A2-B Flare Launcher Magazine"
	gun_type = /obj/item/hardpoint/holder/tank_turret/flares
