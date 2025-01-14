/obj/structure/vehicle_locker/supply_container
	icon = 'icons/obj/structures/M8_SUPPLY_CONTAINER.dmi'
	icon_state = "m8"
	name = "m8 supply container"
	anchored = FALSE
	density = TRUE
	can_hold = list()
	storage_slots = 30
	max_w_class = SIZE_MASSIVE
	w_class = SIZE_MASSIVE
	max_storage_space = 40
	bypass_w_limit = list()
	role_restriction = null

/obj/structure/vehicle_locker/supply_container/ammo //proof of concept it needs common ancestor with vehicle locker but that one is just so cool
	row_length = 5
	storage_slots = 10
	can_hold = list(
		/obj/item/ammo_box,
	)
	bypass_w_limit = list(
		/obj/item/ammo_box,
	)
