/obj/item/ammo_magazine/hardpoint/tank_glauncher
	name = "Grenade Launcher Magazine"
	desc = "A secondary armament grenade magazine"
	caliber = "grenade"
	icon_state = "glauncher_2"
	w_class = SIZE_LARGE
	default_ammo = /datum/ammo/grenade_container
	max_rounds = 10
	gun_type = /obj/item/hardpoint/secondary/grenade_launcher
	point_cost = 100

/obj/item/ammo_magazine/hardpoint/tank_glauncher/update_icon()
	if(current_rounds >= max_rounds)
		icon_state = "glauncher_2"
	else if(current_rounds <= 0)
		icon_state = "glauncher_0"
	else
		icon_state = "glauncher_1"
