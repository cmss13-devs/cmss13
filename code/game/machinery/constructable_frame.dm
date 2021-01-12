//This file was auto-corrected by findeclaration.exe on 25.5.2012 20:42:31

/obj/structure/machinery/constructable_frame //Made into a seperate type to make future revisions easier.
	name = "machine frame"
	icon = 'icons/obj/structures/machinery/stock_parts.dmi'
	icon_state = "box_0"
	var/base_state = "box"
	density = 0
	anchored = 1
	use_power = 0
	var/requirements_left
	var/obj/item/circuitboard/machine/circuit = null
	var/list/components = null
	var/list/req_components = null
	var/list/req_component_names = null
	var/state = CONSTRUCTION_STATE_BEGIN
	var/required_skill = SKILL_CONSTRUCTION_ENGI
	var/required_dismantle_skill = SKILL_ENGINEER_ENGI

/obj/structure/machinery/constructable_frame/Initialize(mapload, ...)
	. = ..()
	update_desc()

/obj/structure/machinery/constructable_frame/proc/update_desc()
	if(state == CONSTRUCTION_STATE_BEGIN)
		requirements_left = " Requires 5 lengths of cable."
	if(req_components)
		requirements_left = " Requires "
		var/first = 1
		for(var/I in req_components)
			if(req_components[I] > 0)
				requirements_left += "[first?"":", "][num2text(req_components[I])] [req_component_names[I]]"
				first = 0
		if(first) // nothing needs to be added, then
			requirements_left += "nothing. Use a screwdriver to complete"
		requirements_left += "."
	desc = initial(desc) + SPAN_WARNING(requirements_left)

/obj/structure/machinery/constructable_frame/update_icon()
    ..()
    icon_state = "[base_state]_[state]"

/obj/structure/machinery/constructable_frame/attackby(obj/item/P as obj, mob/user as mob)
	if(P.crit_fail)
		to_chat(user, SPAN_DANGER("This part is faulty, you cannot add this to the machine!"))
		return
	switch(state)
		if(CONSTRUCTION_STATE_BEGIN)
			if(iscoil(P))
				if(!skillcheck(user, SKILL_CONSTRUCTION, required_skill))
					to_chat(user, SPAN_WARNING("You are not trained to build machines..."))
					return
				var/obj/item/stack/cable_coil/C = P
				if(C.get_amount() < 5)
					to_chat(user, SPAN_WARNING("You need five lengths of cable to add them to the frame."))
					return
				playsound(loc, 'sound/items/Deconstruct.ogg', 25, 1)
				user.visible_message(SPAN_NOTICE("[user] starts adding cables to [src]."),
				SPAN_NOTICE("You start adding cables to [src]."))
				if(do_after(user, 20 * user.get_skill_duration_multiplier(SKILL_CONSTRUCTION), INTERRUPT_ALL|BEHAVIOR_IMMOBILE, BUSY_ICON_BUILD) && state == 0)
					if(C && istype(C) && C.use(5))
						user.visible_message(SPAN_NOTICE("[user] adds cables to [src]."),
						SPAN_NOTICE("You add cables to [src]."))
						state = CONSTRUCTION_STATE_PROGRESS
						anchored = 1
			else if(iswrench(P))
				if(!skillcheck(user, SKILL_ENGINEER, required_dismantle_skill))
					to_chat(user, SPAN_WARNING("You are not trained to dismantle machines..."))
					return
				playsound(src.loc, 'sound/items/Ratchet.ogg', 25, 1)
				to_chat(user, SPAN_NOTICE(" You dismantle the frame..."))
				new /obj/item/stack/sheet/metal(src.loc, 5)
				qdel(src)
		if(CONSTRUCTION_STATE_PROGRESS)
			if(istype(P, /obj/item/circuitboard/machine))
				if(!skillcheck(user, SKILL_CONSTRUCTION, required_skill))
					to_chat(user, SPAN_WARNING("You are not trained to build machines..."))
					return
				if(!do_after(user, 20 * user.get_skill_duration_multiplier(SKILL_CONSTRUCTION), INTERRUPT_ALL|BEHAVIOR_IMMOBILE, BUSY_ICON_BUILD))
					return
				playsound(src.loc, 'sound/items/Deconstruct.ogg', 25, 1)
				to_chat(user, SPAN_NOTICE(" You add the circuit board to the frame."))
				circuit = P
				if(user.drop_inv_item_to_loc(P, src))
					state = CONSTRUCTION_STATE_FINISHED
					components = list()
					req_components = circuit.req_components.Copy()
					for(var/A in circuit.req_components)
						req_components[A] = circuit.req_components[A]
					req_component_names = circuit.req_components.Copy()
					for(var/A in req_components)
						var/obj/ct = A
						req_component_names[A] = initial(ct.name)
					if(circuit.frame_desc)
						requirements_left = circuit.frame_desc
					else
						update_desc()
					to_chat(user, requirements_left)

			else if(istype(P, /obj/item/tool/wirecutters))
				if(!skillcheck(user, SKILL_ENGINEER, required_dismantle_skill))
					to_chat(user, SPAN_WARNING("You are not trained to dismantle machines..."))
					return
				playsound(src.loc, 'sound/items/Wirecutter.ogg', 25, 1)
				to_chat(user, SPAN_NOTICE(" You remove the cables."))
				state = CONSTRUCTION_STATE_BEGIN
				var/obj/item/stack/cable_coil/A = new /obj/item/stack/cable_coil( src.loc )
				A.amount = 5

		if(CONSTRUCTION_STATE_FINISHED)
			if(istype(P, /obj/item/tool/crowbar))
				if(!skillcheck(user, SKILL_ENGINEER, required_dismantle_skill))
					to_chat(user, SPAN_WARNING("You are not trained to dismantle machines..."))
					return
				if(!do_after(user, 20 * user.get_skill_duration_multiplier(SKILL_CONSTRUCTION), INTERRUPT_ALL|BEHAVIOR_IMMOBILE, BUSY_ICON_BUILD))
					return
				playsound(src.loc, 'sound/items/Crowbar.ogg', 25, 1)
				state = CONSTRUCTION_STATE_BEGIN
				circuit.forceMove(loc)
				circuit = null
				if(components.len == 0)
					to_chat(user, SPAN_NOTICE("You remove the circuit board."))
				else
					to_chat(user, SPAN_NOTICE("You remove the circuit board and other components."))
					for(var/obj/item/W in components)
						W.forceMove(loc)
				update_desc()
				req_components = null
				components = null
			else if(istype(P, /obj/item/tool/screwdriver))
				if(!skillcheck(user, SKILL_CONSTRUCTION, required_skill))
					to_chat(user, SPAN_WARNING("You are not trained to build machines..."))
					return
				var/component_check = 1
				for(var/R in req_components)
					if(req_components[R] > 0)
						component_check = 0
						break
				if(component_check)
					playsound(src.loc, 'sound/items/Screwdriver.ogg', 25, 1)
					var/obj/structure/machinery/new_machine = new src.circuit.build_path(src.loc)
					QDEL_NULL_LIST(new_machine.component_parts)
					src.circuit.construct(new_machine)
					for(var/obj/O in src)
						O.forceMove(new_machine)
						LAZYADD(new_machine.component_parts, O)
					circuit.forceMove(new_machine)
					new_machine.RefreshParts()
					qdel(src)
			else if(istype(P, /obj/item))
				if(!skillcheck(user, SKILL_CONSTRUCTION, required_skill))
					to_chat(user, SPAN_WARNING("You are not trained to build machines..."))
					return
				for(var/I in req_components)
					if(istype(P, I) && (req_components[I] > 0))
						if(!do_after(user, 20 * user.get_skill_duration_multiplier(SKILL_CONSTRUCTION), INTERRUPT_ALL|BEHAVIOR_IMMOBILE, BUSY_ICON_BUILD))
							return
						playsound(src.loc, 'sound/items/Deconstruct.ogg', 25, 1)
						if(istype(P, /obj/item/stack/cable_coil))
							var/obj/item/stack/cable_coil/CP = P
							if(CP.get_amount() > 1)
								var/camt = min(CP.amount, req_components[I]) // amount of cable to take, idealy amount required, but limited by amount provided
								var/obj/item/stack/cable_coil/CC = new /obj/item/stack/cable_coil(src)
								CC.amount = camt
								CC.update_icon()
								CP.use(camt)
								components += CC
								req_components[I] -= camt
								update_desc()
								break
						if(user.drop_inv_item_to_loc(P, src))
							components += P
							req_components[I]--
							update_desc()
						break
				to_chat(user, requirements_left)
				if(P && P.loc != src && !istype(P, /obj/item/stack/cable_coil))
					to_chat(user, SPAN_DANGER("You cannot add that component to the machine!"))
	update_icon()

