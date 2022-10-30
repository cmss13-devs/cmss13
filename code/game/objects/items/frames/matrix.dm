/obj/item/frame/matrix
	name = "Matrix frame"
	desc = "Assembly for dropship guidance camera matrix."
	icon = 'icons/obj/items/devices.dmi'
	item_state = "matrix"
	matter = list("metal" = 7500)
	var/obj/item/reagent_container/glass/beaker/vial/construction
	var/state = ASSEMBLY_EMPTY

/obj/item/frame/matrix/attackby(var/obj/item/W, mob/user as mob)
	switch(state)
		if(ASSEMBLY_EMPTY)
			if(istype(W, /obj/item/reagent_container/glass/beaker/vial))
				user.drop_held_item(W)
				W.forceMove(src)
				construction = W
				state = ASSEMBLY_UNLOCKED
				to_chat(user, SPAN_NOTICE("You add the vial to the matrix"))
				desc = initial(desc) + "\n The vial is installed but is not screwed."
				return
		if(ASSEMBLY_UNLOCKED)
			if(HAS_TRAIT(W, TRAIT_TOOL_SCREWDRIVER))
				playsound(src.loc, 'sound/items/Screwdriver.ogg', 25, 1)
				state = ASSEMBLY_LOCKED
				to_chat(user, SPAN_NOTICE("You lock the matrix assembly"))
				desc = initial(desc) + "\n The vial is installed and screwed in place."
