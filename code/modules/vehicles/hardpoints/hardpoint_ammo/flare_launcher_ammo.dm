/obj/item/ammo_magazine/hardpoint/flare_launcher
	name = "Flare Launcher Magazine"
	desc = "A support armament grenade magazine. This one is loaded with flares packaged in expendable shells."
	caliber = "grenade"
	icon_state = "slauncher_1"
	w_class = SIZE_LARGE
	default_ammo = /datum/ammo/flare
	max_rounds = 6
	gun_type = /obj/item/hardpoint/gun/flare_launcher
	point_cost = 50

/obj/item/ammo_magazine/hardpoint/flare_launcher/update_icon()
	icon_state = "slauncher_[current_rounds <= 0 ? "0" : "1"]"
