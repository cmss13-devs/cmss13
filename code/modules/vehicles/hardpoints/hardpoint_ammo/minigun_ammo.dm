/obj/item/ammo_magazine/hardpoint/ltaaap_minigun
	name = "LTAA-AP Minigun Magazine"
	icon = 'icons/obj/items/weapons/guns/ammo_by_faction/event.dmi'
	desc = "A primary armament minigun magazine."
	caliber = "7.62x51mm" //Correlates to miniguns
	icon_state = "painless"
	w_class = SIZE_LARGE //Primary weapon ammo should probably all be the same w_class
	default_ammo = /datum/ammo/bullet/tank/minigun
	max_rounds = 500
	gun_type = /obj/item/hardpoint/primary/minigun
