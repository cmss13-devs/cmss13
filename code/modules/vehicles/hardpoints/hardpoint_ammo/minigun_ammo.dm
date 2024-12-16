/obj/item/ammo_magazine/hardpoint/ltaaap_minigun
	name = "LTAA-AP Minigun Magazine"
	icon = 'icons/obj/items/weapons/guns/ammo_by_faction/USCM/vehicles.dmi'
	desc = "A magazine of 7.62x51mm AP ammo for a heavy minigun. Filled to the brim with highly precise armor-penetrating rounds."
	caliber = "7.62x51mm" //Correlates to miniguns
	icon_state = "ltaa"
	w_class = SIZE_LARGE //Primary weapon ammo should probably all be the same w_class
	default_ammo = /datum/ammo/bullet/tank/minigun
	max_rounds = 500
	gun_type = /obj/item/hardpoint/primary/minigun
