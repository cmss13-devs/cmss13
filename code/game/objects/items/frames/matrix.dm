/obj/item/frame/matrix_frame
	name = "matrix frame"
	desc = "An assembly for the dropship camera matrix, installed into the weapons console. Has a complex series of lenses which allow light to pass through the fluid. \nBecause the fluids of the vial are spread evenly inside, it cannot be removed after it has been inserted. "
	icon = 'icons/obj/items/devices.dmi'
	icon_state = "matrix"
	matter = list("metal" = 7500)
	var/state = ASSEMBLY_EMPTY
	var/upgrade = MATRIX_DEFAULT //upgrade type
	var/power //power of the property
	var/matrixcol // related to the upgrade color and zoom amount
	var/matrixsize

//Upgrade types
//Matrix default -the default dropship camera system you start with // upgrades binoculars to laser designators
//Matrix NVG - NVG filter depending on the level of the property, works in binoculars and DS cameras
//Matrix wide - wider view which depends on the level of the property, works in binoculars and  DS cameras

/obj/item/frame/matrix_frame/attackby(obj/item/attack_item, mob/user as mob)
	switch(state)
		if(ASSEMBLY_EMPTY)
			if(istype(attack_item, /obj/item/reagent_container/glass/beaker/vial) && attack_item.reagents.total_volume == 30 && length(attack_item.reagents.reagent_list) == 1)
				user.drop_held_item(attack_item)
				attack_item.forceMove(src)
				state = ASSEMBLY_UNLOCKED
				to_chat(user, SPAN_NOTICE("You add the vial to the matrix, and the testing indicator lights up with green"))
				desc = initial(desc) + "\nThe vial is installed but is not screwed."
				var/datum/reagent/upgrade_reagent = attack_item.reagents.reagent_list[1]
				if(upgrade_reagent.get_property(PROPERTY_PHOTOSENSITIVE) && !upgrade_reagent.get_property(PROPERTY_CRYSTALLIZATION))
					var/datum/chem_property/upgrade_property = upgrade_reagent.get_property(PROPERTY_PHOTOSENSITIVE)
					power = upgrade_property.level
					if(power <= 3)
						matrixcol = "#19c519"
					else if (power >= 4)
						matrixcol= "#7aff7a"
					upgrade = MATRIX_NVG
					return
				else if (upgrade_reagent.get_property(PROPERTY_CRYSTALLIZATION))
					var/datum/chem_property/upgrade_property = upgrade_reagent.get_property(PROPERTY_CRYSTALLIZATION)
					power = upgrade_property.level
					upgrade = MATRIX_WIDE
					return
				else
					upgrade = MATRIX_DEFAULT
					return
			else if(attack_item.reagents.total_volume < 30)
				to_chat(user, SPAN_WARNING("The testing indicator lights up with red! The container requires to be fully filled!"))
				return
			else if (length(attack_item.reagents.reagent_list) > 1)
				to_chat(user, SPAN_WARNING("The testing indicator lights up with red! The container requires a pure sample!"))

		if(ASSEMBLY_UNLOCKED)
			if(HAS_TRAIT(attack_item, TRAIT_TOOL_SCREWDRIVER))
				playsound(src.loc, 'sound/items/Screwdriver.ogg', 25, 1)
				state = ASSEMBLY_LOCKED
				to_chat(user, SPAN_NOTICE("You lock the matrix assembly"))
				desc = initial(desc) + "\n The vial is installed and screwed in place."
		if(ASSEMBLY_LOCKED)
			if(HAS_TRAIT(attack_item, TRAIT_TOOL_SCREWDRIVER))
				playsound(src.loc, 'sound/items/Screwdriver.ogg', 25, 1)
				state = ASSEMBLY_UNLOCKED
				to_chat(user, SPAN_NOTICE("You unlock the matrix assembly"))
