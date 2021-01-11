//These machines are mostly just here for debugging/spawning. Skeletons of the feature to come.

/obj/structure/machinery/bioprinter
	name = "bio/synthetic printer"
	desc = "It's a machine that can either grow replacement or manufacture synthetic organs."
	icon = 'icons/obj/structures/machinery/surgery.dmi'

	anchored = 1
	density = 1

	icon_state = "bioprinter"

	var/working = 0
	var/stored_matter = 0
	var/stored_metal = 0

	//"Name" = list(location, matter, metal, time, isorganic)
	var/list/products = list(
		"synthetic left arm (125 - Metal)" =  list(/obj/item/robot_parts/l_arm,  0, LIMB_METAL_AMOUNT, LIMB_PRINTING_TIME),
		"synthetic right arm (125 - Metal)" = list(/obj/item/robot_parts/r_arm,  0, LIMB_METAL_AMOUNT, LIMB_PRINTING_TIME),
		"synthetic left leg (125 - Metal)" =  list(/obj/item/robot_parts/l_leg,  0, LIMB_METAL_AMOUNT, LIMB_PRINTING_TIME),
		"synthetic right leg (125 - Metal)" = list(/obj/item/robot_parts/r_leg,  0, LIMB_METAL_AMOUNT, LIMB_PRINTING_TIME)
		)

/obj/structure/machinery/bioprinter/attack_hand(mob/user)
	if(inoperable())
		return

	if(working)
		to_chat(user, "Something is already being printed...")
		return
	var/choice = tgui_input_list(usr, "What would you like to print?", "Bioprinter", products)
	if(!choice)
		return
	if(stored_matter >= products[choice][2] && stored_metal >= products[choice][3]) //Matter and metal
		if(working)
			to_chat(user, "Something is already being printed...")
			return
		stored_matter -= products[choice][2] //Matter
		stored_metal -= products[choice][3] //Metal
		to_chat(user, SPAN_NOTICE(" \The [src] is now printing the selected organ. Please hold."))
		working = 1
		spawn(products[choice][4]) //Time
			var/new_organ = products[choice][1]
			new new_organ(get_turf(src))
			working = 0
			visible_message("The bio/synthetic printer spits out a new organ.")

	else
		to_chat(user, "There is not enough materials in the printer.")

/obj/structure/machinery/bioprinter/attackby(obj/item/W, mob/user)
//Matter
	if(istype(W, /obj/item/reagent_container/food/snacks/meat))
		to_chat(user, SPAN_NOTICE(" \The [src] processes \the [W]."))
		stored_matter += 50
		user.drop_held_item()
		qdel(W)
		return
//Metal
	else if(istype(W, /obj/item/stack/sheet/metal))
		var/obj/item/stack/sheet/metal/M = W
		to_chat(user, SPAN_NOTICE(" \The [src] processes \the [W]."))
		stored_metal += M.amount * 100
		user.drop_held_item()
		qdel(W)
		return
	else
		return..()

/obj/structure/machinery/bioprinter/examine(mob/user)
	..()
	to_chat(user, "It has [stored_matter] matter and [stored_metal] metal left.")
