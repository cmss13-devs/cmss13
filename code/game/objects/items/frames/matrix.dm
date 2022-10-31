/obj/item/frame/matrix
	name = "Matrix frame"
	desc = "Assembly for dropship guidance camera matrix."
	icon = 'icons/obj/items/devices.dmi'
	icon_state = "matrix"
	matter = list("metal" = 7500)
	var/obj/item/reagent_container/glass/beaker/vial/construction
	var/state = ASSEMBLY_EMPTY

/obj/item/frame/matrix/attackby(var/obj/item/W, mob/user as mob)
	switch(state)
		if(ASSEMBLY_EMPTY)
			if(istype(W, /obj/item/reagent_container/glass/beaker/vial) && W.reagents.total_volume == 30)
				user.drop_held_item(W)
				W.forceMove(src)
				var/datum/reagent/matrixchem = W.reagents.reagent_list[1]
				state = ASSEMBLY_UNLOCKED
				to_chat(user, SPAN_NOTICE("You add the vial to the matrix"))
				desc = initial(desc) + "\nThe vial is installed but is not screwed."
				to_chat(user, SPAN_WARNING("TEST: PROPERTIES OF THE CHEM" + (matrixchem.properties)))
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