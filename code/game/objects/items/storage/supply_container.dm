/obj/structure/vehicle_locker/supply_container/ammo //proof of concept it needs common ancestor with vehicle locker but that one is just so cool
	icon = 'icons/obj/structures/M8_SUPPLY_CONTAINER.dmi'
	icon_state = "m8"
	name = "m8 supply container"
	anchored = FALSE
	density = TRUE
	can_hold = list(
		/obj/item/ammo_box,
	)
	storage_slots = null
	max_w_class = SIZE_MASSIVE
	w_class = SIZE_MASSIVE
	max_storage_space = 40
	bypass_w_limit = list(
		/obj/item/ammo_box,
	)
	role_restriction = null
