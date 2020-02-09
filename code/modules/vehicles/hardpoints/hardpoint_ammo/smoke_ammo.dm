/obj/item/ammo_magazine/hardpoint/tank_slauncher
	name = "Smoke Launcher Magazine"
	desc = "A support armament grenade magazine"
	caliber = "grenade"
	icon_state = "slauncher_1"
	w_class = SIZE_LARGE
	default_ammo = /datum/ammo/grenade_container/smoke
	max_rounds = 6
	gun_type = /obj/item/hardpoint/gun/smoke_launcher
	point_cost = 50

/obj/item/ammo_magazine/hardpoint/tank_slauncher/update_icon()
	icon_state = "slauncher_[current_rounds <= 0 ? "0" : "1"]"
