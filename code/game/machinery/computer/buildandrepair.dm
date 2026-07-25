//This file was auto-corrected by findeclaration.exe on 25.5.2012 20:42:31

/obj/structure/computerframe
	density = FALSE
	anchored = FALSE
	name = "Computer-frame"
	icon = 'icons/obj/structures/machinery/stock_parts.dmi'
	icon_state = "0"
	var/build_state = COMPUTERFRAME_STATE_FRAME_UNSECURE
	var/obj/item/circuitboard/computer/circuit = null
	///Whether this is currently being manipulated to prevent doubling up
	var/busy = FALSE
	// weight = 1.0E8

/obj/structure/computerframe/attackby(obj/item/attacking_item, mob/living/user, list/mods)
	if(busy)
		to_chat(user, SPAN_WARNING("Someone else is already working on [src]."))
		return

	switch(build_state)
		if(COMPUTERFRAME_STATE_FRAME_UNSECURE)
			if(HAS_TRAIT(attacking_item, TRAIT_TOOL_WRENCH))
				playsound(loc, 'sound/items/Ratchet.ogg', 25, 1)
				busy = TRUE
				if(do_after(user, 20, INTERRUPT_ALL|BEHAVIOR_IMMOBILE, BUSY_ICON_BUILD))
					to_chat(user, SPAN_NOTICE("You wrench the frame into place."))
					anchored = TRUE
					build_state = COMPUTERFRAME_STATE_NO_BOARD
				busy = FALSE
				return
			if(iswelder(attacking_item))
				if(!HAS_TRAIT(attacking_item, TRAIT_TOOL_BLOWTORCH))
					to_chat(user, SPAN_WARNING("You need a stronger blowtorch!"))
					return
				var/obj/item/tool/weldingtool/torch = attacking_item
				if(!torch.isOn())
					to_chat(user, SPAN_WARNING("[torch] needs to be on!"))
					return
				playsound(loc, 'sound/items/Welder.ogg', 25, 1)
				busy = TRUE
				if(do_after(user, 20, INTERRUPT_ALL|BEHAVIOR_IMMOBILE, BUSY_ICON_BUILD, src))
					busy = FALSE
					if(QDELETED(src) || !torch.isOn())
						return
					to_chat(user, SPAN_NOTICE("You deconstruct the frame."))
					deconstruct()
				busy = FALSE
				return
		if(COMPUTERFRAME_STATE_NO_BOARD)
			if(HAS_TRAIT(attacking_item, TRAIT_TOOL_WRENCH))
				playsound(loc, 'sound/items/Ratchet.ogg', 25, 1)
				busy = TRUE
				if(do_after(user, 20, INTERRUPT_ALL|BEHAVIOR_IMMOBILE, BUSY_ICON_BUILD))
					to_chat(user, SPAN_NOTICE("You unfasten the frame."))
					anchored = FALSE
					build_state = COMPUTERFRAME_STATE_FRAME_UNSECURE
				busy = FALSE
				return
			if(istype(attacking_item, /obj/item/circuitboard/computer) && !circuit)
				if(user.drop_held_item())
					playsound(loc, 'sound/items/Deconstruct.ogg', 25, 1)
					to_chat(user, SPAN_NOTICE("You place the circuit board inside the frame."))
					icon_state = "1"
					circuit = attacking_item
					attacking_item.forceMove(src)
				return
			if(HAS_TRAIT(attacking_item, TRAIT_TOOL_SCREWDRIVER) && circuit)
				playsound(loc, 'sound/items/Screwdriver.ogg', 25, 1)
				to_chat(user, SPAN_NOTICE("You screw the circuit board into place."))
				build_state = COMPUTERFRAME_STATE_NO_CABLES
				icon_state = "2"
				return
			if(HAS_TRAIT(attacking_item, TRAIT_TOOL_CROWBAR) && circuit)
				playsound(loc, 'sound/items/Crowbar.ogg', 25, 1)
				to_chat(user, SPAN_NOTICE("You remove the circuit board."))
				build_state = COMPUTERFRAME_STATE_NO_BOARD
				icon_state = "0"
				circuit.forceMove(loc)
				circuit = null
				return
		if(COMPUTERFRAME_STATE_NO_CABLES)
			if(HAS_TRAIT(attacking_item, TRAIT_TOOL_SCREWDRIVER) && circuit)
				playsound(loc, 'sound/items/Screwdriver.ogg', 25, 1)
				to_chat(user, SPAN_NOTICE("You unfasten the circuit board."))
				build_state = COMPUTERFRAME_STATE_NO_BOARD
				icon_state = "1"
				return
			if(istype(attacking_item, /obj/item/stack/cable_coil))
				var/obj/item/stack/cable_coil/coil = attacking_item
				if(coil.get_amount() < 5)
					to_chat(user, SPAN_WARNING("You need five coils of wire to add them to the frame."))
					return
				to_chat(user, SPAN_NOTICE("You start to add cables to the frame."))
				playsound(loc, 'sound/items/Deconstruct.ogg', 25, 1)
				busy = TRUE
				if(do_after(user, 20, INTERRUPT_ALL|BEHAVIOR_IMMOBILE, BUSY_ICON_BUILD) && build_state == COMPUTERFRAME_STATE_NO_CABLES)
					if(coil.use(5))
						to_chat(user, SPAN_NOTICE("You add cables to the frame."))
						build_state = COMPUTERFRAME_STATE_NO_GLASS
						icon_state = "3"
				busy = FALSE
				return
		if(COMPUTERFRAME_STATE_NO_GLASS)
			if(HAS_TRAIT(attacking_item, TRAIT_TOOL_WIRECUTTERS))
				playsound(loc, 'sound/items/Wirecutter.ogg', 25, 1)
				to_chat(user, SPAN_NOTICE("You remove the cables."))
				build_state = COMPUTERFRAME_STATE_NO_CABLES
				icon_state = "2"
				var/obj/item/stack/cable_coil/coil = new /obj/item/stack/cable_coil(loc)
				coil.amount = 5
				return
			if(istype(attacking_item, /obj/item/stack/sheet/glass))
				var/obj/item/stack/sheet/glass/glass_sheet = attacking_item
				if(glass_sheet.get_amount() < 2)
					to_chat(user, SPAN_WARNING("You need two sheets of glass to put in the glass panel."))
					return
				playsound(loc, 'sound/items/Deconstruct.ogg', 25, 1)
				to_chat(user, SPAN_NOTICE("You start to put in the glass panel."))
				busy = TRUE
				if(do_after(user, 20, INTERRUPT_ALL|BEHAVIOR_IMMOBILE, BUSY_ICON_BUILD) && build_state == COMPUTERFRAME_STATE_NO_GLASS)
					if(glass_sheet.use(2))
						to_chat(user, SPAN_NOTICE("You put in the glass panel."))
						build_state = COMPUTERFRAME_STATE_COMPLETE
						icon_state = "4"
				busy = FALSE
				return
		if(COMPUTERFRAME_STATE_COMPLETE)
			if(HAS_TRAIT(attacking_item, TRAIT_TOOL_CROWBAR))
				playsound(loc, 'sound/items/Crowbar.ogg', 25, 1)
				to_chat(user, SPAN_NOTICE("You remove the glass panel."))
				build_state = COMPUTERFRAME_STATE_NO_GLASS
				icon_state = "3"
				new /obj/item/stack/sheet/glass(loc, 2)
				return
			if(HAS_TRAIT(attacking_item, TRAIT_TOOL_SCREWDRIVER))
				playsound(loc, 'sound/items/Screwdriver.ogg', 25, 1)
				to_chat(user, SPAN_NOTICE("You connect the monitor."))
				var/board = new circuit.build_path(loc)
				circuit.construct(board)
				qdel(src)
				return

/obj/structure/computerframe/deconstruct(disassembled = TRUE)
	if(disassembled)
		new /obj/item/stack/sheet/metal(loc, 5)
	return ..()
