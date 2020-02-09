/obj/item/ammo_magazine/hardpoint/primary_flamer
	name = "Tank Flamer Magazine"
	desc = "A primary armament flamethrower magazine"
	caliber = "Napalm B" //correlates to flamer mags
	icon_state = "drgn_flametank"
	w_class = SIZE_LARGE
	max_rounds = 120
	gun_type = /obj/item/hardpoint/gun/flamer
	default_ammo = /datum/ammo/flamethrower/tank_flamer
	point_cost = 200

/obj/item/ammo_magazine/hardpoint/primary_flamer/update_icon()
	if(current_rounds > 0)
		icon_state = "drgn_flametank"
	else
		icon_state = "drgn_flametank_empty"
