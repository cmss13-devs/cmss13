/obj/item/ammo_magazine/needler_crystal
	name = "\improper blamite needler charge"
	desc = "A glowing pink crystal charge for a needler."
	caliber = "needle"
	icon = 'icons/halo/obj/items/weapons/guns_by_faction/covenant/covenant_magazines.dmi'
	icon_state = "blamite"
	item_state = "blamite"
	w_class = SIZE_MEDIUM
	default_ammo = /datum/ammo/needler
	current_rounds = 60
	max_rounds = 60
	gun_type = /obj/item/weapon/gun/smg/covenant_needler
	flags_magazine = NO_FLAGS

/obj/item/ammo_magazine/carbine
	name = "\improper carbine magazine"
	desc = "Holds 18 rounds of radioactive mayhem."
	caliber = "8x60mm"
	icon = 'icons/halo/obj/items/weapons/guns_by_faction/covenant/covenant_magazines.dmi'
	icon_state = "carbine_mag"
	item_state = "carbine_mag"
	w_class = SIZE_MEDIUM
	default_ammo = /datum/ammo/bullet/rifle/carbine
	current_rounds = 18
	max_rounds = 18
	gun_type = /obj/item/weapon/gun/rifle/covenant_carbine
	flags_magazine = NO_FLAGS
