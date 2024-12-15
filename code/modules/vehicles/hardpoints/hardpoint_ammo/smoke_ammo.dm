/obj/item/ammo_magazine/hardpoint/turret_smoke
	name = "Turret Smoke Screen Magazine"
	desc = "A smoke grenades magazine used by tank turret."
	caliber = "grenade"
	icon = 'icons/obj/items/weapons/guns/ammo_by_faction/USCM/vehicles.dmi'
	icon_state = "slauncher_1"
	w_class = SIZE_LARGE
	default_ammo = /datum/ammo/grenade_container/smoke
	max_rounds = 10
	gun_type = /obj/item/hardpoint/holder/tank_turret

/obj/item/ammo_magazine/hardpoint/turret_smoke/update_icon()
	icon_state = "slauncher_[current_rounds <= 0 ? "0" : "1"]"
