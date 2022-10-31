/obj/item/frame/matrix
	name = "Matrix frame"
	desc = "Assembly for dropship guidance camera matrix."
	icon = 'icons/obj/items/devices.dmi'
	icon_state = "matrix"
	matter = list("metal" = 7500)
	var/obj/item/reagent_container/glass/beaker/vial/B
	var/state = ASSEMBLY_EMPTY

/obj/item/frame/matrix/attackby(var/obj/item/W, mob/user as mob)
	switch(state)
		if(ASSEMBLY_EMPTY)
			if(istype(W, /obj/item/reagent_container/glass/beaker/vial) && W.reagents.total_volume == 30)
				user.drop_held_item(W)
				W.forceMove(src)
				state = ASSEMBLY_UNLOCKED
				to_chat(user, SPAN_NOTICE("You add the vial to the matrix"))
				desc = initial(desc) + "\nThe vial is installed but is not screwed."
				var/datum/reagent/S = W.reagents.reagent_list[1]
				var/datum/chem_property/P = S.get_property(PROPERTY_PHOTOSENSETIVE)
				if(P)
					to_chat(user, SPAN_NOTICE("it works!"))
				return
			else if(W.reagents.total_volume < 30)
				to_chat(user, SPAN_WARNING("You need a full container for effectivness!"))
				return

		if(ASSEMBLY_UNLOCKED)
			if(HAS_TRAIT(W, TRAIT_TOOL_SCREWDRIVER))
				playsound(src.loc, 'sound/items/Screwdriver.ogg', 25, 1)
				state = ASSEMBLY_LOCKED
				to_chat(user, SPAN_NOTICE("You lock the matrix assembly"))
				desc = initial(desc) + "\n The vial is installed and screwed in place."