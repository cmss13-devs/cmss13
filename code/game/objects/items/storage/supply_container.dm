/obj/structure/general_container/supply_container
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

/obj/structure/general_container/supply_container/ammo //proof of concept it needs common ancestor with vehicle locker but that one is just so cool
	row_length = 5
	storage_slots = 10
	can_hold = list(
		/obj/item/ammo_box,
	)
	bypass_w_limit = list(
		/obj/item/ammo_box,
	)

/obj/structure/general_container/supply_container/intel
	icon_state = "deployed_intel_duffel"
	name = "deployed duffel bag"
	row_length = 10
	storage_slots = 30
	can_hold = list(
		/obj/item/paper,
		/obj/item/clipboard,
		/obj/item/document_objective/paper,
		/obj/item/document_objective,
		/obj/item/disk/objective,
	)

/obj/structure/general_container/supply_container/intel/MouseDrop(over_object, src_location, over_location)
	..()
	if(over_object == usr && Adjacent(usr))

		if(!ishuman(usr))
			return

		if(!container.empty(over_object, loc, require_in_hand = FALSE))
			return
		visible_message(SPAN_NOTICE("[usr] empty and picks up the [name]."))

		usr.put_in_hands(new /obj/item/duffel_bag)
		qdel(src)

/obj/item/duffel_bag
	icon = 'icons/obj/structures/M8_SUPPLY_CONTAINER.dmi'
	icon_state = "intel_duffel"
	w_class = SIZE_MEDIUM

/obj/item/duffel_bag/attack_self(mob/user)
	.=..()
	var/obj/structure/general_container/supply_container/intel/bag = new /obj/structure/general_container/supply_container/intel(user.loc)
	qdel(src)
