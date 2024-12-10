/obj/item/ammo_magazine/hardpoint/arc_sentry
	name = "\improper RE700 Rotary Cannon Magazine"
	desc = "A magazine for RE700 Rotary Cannon filled with 20mm rounds. Supports IFF."
	caliber = "20mm"
	icon = 'icons/obj/items/weapons/guns/ammo_by_faction/USCM/vehicles.dmi'
	icon_state = "ace_autocannon"
	w_class = SIZE_LARGE
	default_ammo = /datum/ammo/bullet/re700
	max_rounds = 500
	gun_type = /obj/item/hardpoint/primary/arc_sentry

/obj/item/ammo_magazine/hardpoint/arc_sentry/update_icon()
	if(current_rounds > 0)
		icon_state = "ace_autocannon"
	else
		icon_state = "ace_autocannon_empty"

