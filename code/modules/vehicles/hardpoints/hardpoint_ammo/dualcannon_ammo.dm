/obj/item/ammo_magazine/hardpoint/boyars_dualcannon
	name = "Boyars Dualcannon Flak Magazine"
	desc = "A magazine filled with explosive flak, using a modular design to fit all makes of Boyars dualcannons."
	caliber = "20mm"
	icon_state = "ace_autocannon"
	w_class = SIZE_LARGE
	default_ammo = /datum/ammo/bullet/tank/flak/weak
	max_rounds = 40
	gun_type = /obj/item/hardpoint/primary/dualcannon

/obj/item/ammo_magazine/hardpoint/boyars_dualcannon/update_icon()
	if(current_rounds > 0)
		icon_state = "ace_autocannon"
	else
		icon_state = "ace_autocannon_empty"
