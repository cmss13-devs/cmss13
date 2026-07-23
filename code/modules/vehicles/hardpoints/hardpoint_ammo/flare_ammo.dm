/obj/item/ammo_magazine/hardpoint/turret_flare
	name = "Turret Flare Screen Magazine"
	desc = "The turret's internal star shell holders. Loaded directly with individual M74 AGM-S star shells or star shell packets, not swapped as a whole magazine."
	caliber = "flare"
	icon = 'icons/obj/items/weapons/guns/ammo_by_faction/USCM/vehicles.dmi'
	icon_state = "slauncher_1"
	w_class = SIZE_LARGE
	default_ammo = /datum/ammo/flare/starshell/burst
	max_rounds = 6
	gun_type = /obj/item/hardpoint/holder/tank_turret

/obj/item/ammo_magazine/hardpoint/turret_flare/update_icon()
	icon_state = "slauncher_[current_rounds <= 0 ? "0" : "1"]"
