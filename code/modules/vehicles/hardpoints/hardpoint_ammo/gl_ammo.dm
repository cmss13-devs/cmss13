/obj/item/ammo_magazine/hardpoint/tank_glauncher
	name = "M92T Grenade Launcher Magazine"
	desc = "A magazine loaded with M40 grenades. Used to reload the magazine fed M92T Grenade launcher."
	caliber = "grenade"
	icon_state = "glauncher_2"
	icon = 'icons/obj/items/weapons/guns/ammo_by_faction/USCM/vehicles.dmi'
	w_class = SIZE_LARGE
	default_ammo = /datum/ammo/grenade_container/tank_glauncher
	max_rounds = 10
	gun_type = /obj/item/hardpoint/secondary/grenade_launcher

/obj/item/ammo_magazine/hardpoint/tank_glauncher/update_icon()
	if(current_rounds >= max_rounds)
		icon_state = "glauncher_2"
	else if(current_rounds <= 0)
		icon_state = "glauncher_0"
	else
		icon_state = "glauncher_1"
