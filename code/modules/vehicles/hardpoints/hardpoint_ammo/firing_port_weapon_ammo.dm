/obj/item/ammo_magazine/hardpoint/firing_port_weapon
	name = "M56 FPW Magazine"
	desc = "A magazine for an M56 Firing Port Weapon. Supports IFF."
	caliber = "10x28mm" //Correlates to smartguns
	icon = 'icons/obj/items/weapons/guns/ammo_by_faction/USCM/vehicles.dmi'
	icon_state = "cupola_1"
	w_class = SIZE_LARGE
	default_ammo = /datum/ammo/bullet/smartgun/m56_fpw
	max_rounds = 75
	gun_type = /obj/item/hardpoint/special/firing_port_weapon

/obj/item/ammo_magazine/hardpoint/firing_port_weapon/update_icon()
	icon_state = "cupola_[current_rounds <= 0 ? "0" : "1"]"
