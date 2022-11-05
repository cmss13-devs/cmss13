/obj/item/frame/matrix
	name = "Matrix frame"
	desc = "Assembly for dropship camera matrix, installed into weapons console. Has complex series of lenses to pass light through fluid. \nBecause fluids of the vial is spread evenly inside, it cant be removed after its been inserted. "
	icon = 'icons/obj/items/devices.dmi'
	icon_state = "matrix"
	matter = list("metal" = 7500)
	var/state = ASSEMBLY_EMPTY
	var/upgrade = MATRIX_DEFAULT //upgrade type
	var/power //power of the property
	var/matrixcol // related to the upgrade color and zoom amount
	var/matrixsize
//Upgrades types
//Matrix default - nothing, basicly what you get roundstart in CAS
//Matrix NVG - guidance camera gets NVG filter depended on potency of the property
//Matrix wide - gives a wider view which depends on potency of the proeprty.
/obj/item/frame/matrix/attackby(var/obj/item/W, mob/user as mob)
	switch(state)
		if(ASSEMBLY_EMPTY)
			if(istype(W, /obj/item/reagent_container/glass/beaker/vial) && W.reagents.total_volume == 30 && W.reagents.reagent_list.len == 1)
				user.drop_held_item(W)
				W.forceMove(src)
				state = ASSEMBLY_UNLOCKED
				to_chat(user, SPAN_NOTICE("You add the vial to the matrix, and the testing indicator lights up with green"))
				desc = initial(desc) + "\nThe vial is installed but is not screwed."
				var/datum/reagent/S = W.reagents.reagent_list[1]
				if(S.get_property(PROPERTY_PHOTOSENSETIVE) && !S.get_property(PROPERTY_CRYSTALLIZATION))
					var/datum/chem_property/G = S.get_property(PROPERTY_PHOTOSENSETIVE)
					power = G.level
					if(power <= 3)
						matrixcol = "#19c519"
					else if (power >= 4)
						matrixcol= "#7aff7a"
					upgrade = MATRIX_NVG
					return
				else if (S.get_property(PROPERTY_CRYSTALLIZATION))
					var/datum/chem_property/G = S.get_property(PROPERTY_CRYSTALLIZATION)
					power = G.level
					upgrade = MATRIX_WIDE
					return
				else
					upgrade = MATRIX_DEFAULT
					return
			else if(W.reagents.total_volume < 30)
				to_chat(user, SPAN_WARNING("The testing indicator lights up with red! Use a full container for effectivness!"))
				return
			else if (W.reagents.reagent_list.len > 1)
				to_chat(user, SPAN_WARNING("The testing indicator lights up with red! Use pure sample."))

		if(ASSEMBLY_UNLOCKED)
			if(HAS_TRAIT(W, TRAIT_TOOL_SCREWDRIVER))
				playsound(src.loc, 'sound/items/Screwdriver.ogg', 25, 1)
				state = ASSEMBLY_LOCKED
				to_chat(user, SPAN_NOTICE("You lock the matrix assembly"))
				desc = initial(desc) + "\n The vial is installed and screwed in place."
		if(ASSEMBLY_LOCKED)
			if(HAS_TRAIT(W, TRAIT_TOOL_SCREWDRIVER))
				playsound(src.loc, 'sound/items/Screwdriver.ogg', 25, 1)
				state = ASSEMBLY_UNLOCKED
				to_chat(user, SPAN_NOTICE("You unlock the matrix assembly"))
