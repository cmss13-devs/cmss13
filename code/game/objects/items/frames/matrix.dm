/obj/item/frame/matrix
	name = "Matrix frame"
	desc = "Assembly for dropship guidance camera matrix, its missing a vial."
	icon = 'icons/obj/items/devices.dmi'
	item_state = "matrix"
	matter = list("metal" = 7500)
	var/obj/item/reagent_container/glass/beaker/vial/construction
	var/state = ASSEMBLY_EMPTY

/obj/item/frame/matrix/afterattack(atom/target, mob/user, proximity_flag, click_parameters)
	if(proximity_flag && (istype(target, /obj/item/reagent_container/glass/beaker/vial)

/obj/item/frame/matrix/attackby(var/obj/item/W, mob/user as mob)
    ..()
	switch(state)
		if(ASSEMBLY_EMPTY)
			if(istype(W, /obj/item/reagent_container/glass/beaker/vial)
				user.drop_inv_item(vial)
				vial.forceMove(src)
				construction = vial
				state = ASSEMBLY_UNLOCKED
				to_chat(user, SPAN_NOTICE("You add the vial to the matrix"))
				desc = initial(desc) = "Assembly for dropship guidance camera matrix, due to installing methods, the vial cant be removed after its in place., The vial is in place, but is unscrewed."
				return
		if(ASSEMBLY_UNLOCKED)
			if(HAS_TRAIT(W, TRAIT_TOOL_SCREWDRIVER))
				playsound(src.loc, 'sound/items/Screwdriver.ogg', 25, 1)
				state = ASSEMBLY_LOCKED
				to_chat(user, SPAN_NOTICE("You lock the matrix assembly"))
				desc = initial(desc) = "Assembly for dropship guidance camera matrix, due to installing methods, the vial cant be removed after its in place. The vial is in place, and is screwed in place."