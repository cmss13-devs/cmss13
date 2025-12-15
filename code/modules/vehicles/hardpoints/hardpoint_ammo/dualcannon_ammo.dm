/obj/item/ammo_magazine/hardpoint/boyars_dualcannon
	name = "PARS-159 Dualcannon IFF Magazine"
	desc = "A magazine for PARS-159 Boyars Dualcannon filled with 20mm rounds. Slightly contuses targets upon hit. Supports IFF."
	caliber = "20mm"
	icon_state = "ace_autocannon"
	icon = 'icons/obj/items/weapons/guns/ammo_by_faction/USCM/vehicles.dmi'
	w_class = SIZE_LARGE
	default_ammo = /datum/ammo/bullet/tank/dualcannon
	max_rounds = 60
	gun_type = /obj/item/hardpoint/primary/dualcannon

/obj/item/ammo_magazine/hardpoint/boyars_dualcannon/update_icon()
	if(current_rounds > 0)
		icon_state = "ace_autocannon"
	else
		icon_state = "ace_autocannon_empty"
