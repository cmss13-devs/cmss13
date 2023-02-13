/obj/item/weapon/gun/pistol/tranquilizer
	name = "Tranquilizer gun"
	desc = "Contains horse tranquilizer darts. Useful at knocking people out."
	icon = 'icons/obj/items/weapons/guns/guns_by_faction/upp.dmi'
	icon_state = "pk9r"
	item_state = "pk9r"
	current_mag = /obj/item/ammo_magazine/pistol/tranq

	burst_amount = 1

/obj/item/weapon/gun/pistol/tranquilizer/set_gun_config_values()
	..()
	fire_delay = FIRE_DELAY_TIER_6
	accuracy_mult = BASE_ACCURACY_MULT + HIT_ACCURACY_MULT_TIER_7
	accuracy_mult_unwielded = BASE_ACCURACY_MULT + HIT_ACCURACY_MULT_TIER_10
	scatter = SCATTER_AMOUNT_TIER_10
	scatter_unwielded = SCATTER_AMOUNT_TIER_10
	damage_mult = 0 // Miniscule amounts of damage

/obj/item/weapon/gun/pistol/tranquilizer/handle_starting_attachment()//Making the gun have an invisible silencer since it's supposed to have one.
	..()
	var/obj/item/attachable/suppressor/S = new(src)
	S.hidden = TRUE
	S.flags_attach_features &= ~ATTACH_REMOVABLE
	S.Attach(src)
	update_attachable(S.slot)

/obj/item/ammo_magazine/pistol/tranq
	name = "\improper Tranquilizer magazine (Horse Tranquilizer)"
	icon = 'icons/obj/items/weapons/guns/ammo_by_faction/upp.dmi'
	default_ammo = /datum/ammo/bullet/pistol/tranq
	caliber = ".22"
	icon_state = "pk-9_tranq"
	max_rounds = 5
	gun_type = /obj/item/weapon/gun/pistol/tranquilizer

/obj/effect/landmark/gun_spawner
	icon = 'icons/obj/items/weapons/guns/ammo_by_faction/upp.dmi'
	icon_state = "pk-9_tranq"

/obj/effect/landmark/gun_spawner/Initialize(mapload, ...)
	. = ..()
	var/debug_x = src.x
	var/debug_y = src.y
	debug_y++
	for(var/gun_typepath as anything in typesof(/obj/item/weapon/gun))
		var/obj/item/weapon/gun = new gun_typepath(locate(debug_x, debug_y, src.z))
		debug_x++
		if(!gun)
			debug_y++
			var/obj/item/weapon/g = new gun_typepath(locate(debug_x, debug_y, src.z))

/obj/effect/landmark/ammo_box_spawner
	icon = 'icons/obj/items/weapons/guns/ammo_by_faction/upp.dmi'
	icon_state = "pk-9"

	Initialize(mapload, ...)
		. = ..()
		var/debug_x = src.x
		var/debug_y = src.y
		debug_y++
		for(var/gun_typepath as anything in typesof(/obj/item/ammo_box))
			var/obj/structure/magazine_box/gun = new gun_typepath(locate(debug_x, debug_y, src.z))
			debug_x++
			if(!gun)
				debug_y++
				var/obj/structure/magazine_box/g = new gun_typepath(locate(debug_x, debug_y, src.z))

/obj/effect/landmark/ammo_spawner
	icon = 'icons/obj/items/weapons/guns/ammo_by_faction/upp.dmi'
	icon_state = "skorpion"

	Initialize(mapload, ...)
		. = ..()
		var/debug_x = src.x
		var/debug_y = src.y
		debug_y++
		for(var/gun_typepath as anything in typesof(/obj/item/ammo_magazine))
			var/obj/item/ammo_magazine/gun = new gun_typepath(locate(debug_x, debug_y, src.z))
			debug_x++
			if(!gun)
				debug_y++
				var/obj/item/ammo_magazine/g = new gun_typepath(locate(debug_x, debug_y, src.z))
