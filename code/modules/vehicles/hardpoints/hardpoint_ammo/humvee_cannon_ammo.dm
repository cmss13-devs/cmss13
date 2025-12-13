/obj/item/ammo_magazine/hardpoint/humvee_cannon
	name = "M24-RC1 Remote Cannon Magazine (10x28mm tungsten rounds)"
	desc = "A magazine for the M24-RC1 Remote Cannon filled with 10x28mm tungsten rounds."
	caliber = "10x28mm"
	icon_state = "ace_autocannon"
	icon = 'icons/obj/items/weapons/guns/ammo_by_faction/USCM/vehicles.dmi'
	w_class = SIZE_LARGE
	default_ammo = /datum/ammo/bullet/humvee_cannon
	max_rounds = 225
	gun_type = /obj/item/hardpoint/primary/humvee_cannon

/obj/item/ammo_magazine/hardpoint/humvee_cannon/update_icon()
	if(current_rounds > 0)
		icon_state = "ace_autocannon"
	else
		icon_state = "ace_autocannon_empty"
