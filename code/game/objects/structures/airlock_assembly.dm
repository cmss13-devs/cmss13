#define STATE_STANDARD 		0
#define STATE_CIRCUIT		1
#define STATE_WIRES			2
#define STATE_SCREWDRIVER	3

#define AIRLOCK_MATERIAL_COST	5

#define AIRLOCK_NOGLASS		0
#define AIRLOCK_GLASSIN		1
#define AIRLOCK_CANTGLASS	2

/obj/structure/airlock_assembly
	name = "airlock assembly"
	icon = 'icons/obj/structures/doors/airlock_assembly.dmi'
	icon_state = "door_as_0"
	anchored = FALSE
	density = TRUE
	var/state = STATE_STANDARD
	var/base_icon_state = ""
	var/base_name = "airlock"
	var/obj/item/circuitboard/airlock/electronics = null
	var/airlock_type = "generic" //the type path of the airlock once completed
	var/glass = AIRLOCK_NOGLASS // see defines
	var/created_name = null
/obj/structure/airlock_assembly/Initialize(mapload, ...)
	. = ..()

	update_icon()

/obj/structure/airlock_assembly/get_examine_text(mob/user)
	. = ..()

	var/helpmessage
	. += SPAN_NOTICE("A [SPAN_HELPFUL("crowbar")] will dismantle it.")
	switch(state)
		if(STATE_STANDARD)
			if(anchored)
				helpmessage += "It looks like a [SPAN_HELPFUL("wrench")] will unsecure it. Insert a [SPAN_HELPFUL("airlock circuit")]."
				if(!glass)
					helpmessage += "Insert some [SPAN_HELPFUL("glass sheets")] to add windows to it."
				else if(glass == AIRLOCK_GLASSIN)
					helpmessage += "You can take out the windows with a [SPAN_HELPFUL("screwdriver")]."
			else
				helpmessage += "It looks like a [SPAN_HELPFUL("wrench")] will secure it."
		if(STATE_CIRCUIT)
			helpmessage += "Add [SPAN_HELPFUL("cable coil")] to the circuit."
		if(STATE_WIRES)
			helpmessage += "Secure the circuit with a [SPAN_HELPFUL("screwdriver")]."
		if(STATE_SCREWDRIVER)
			helpmessage += "[SPAN_HELPFUL("Weld")] it all in place."
	helpmessage += "You can name it with a [SPAN_HELPFUL("pen")]."
	. += SPAN_NOTICE(helpmessage)

/obj/structure/airlock_assembly/attackby(obj/item/W as obj, mob/user as mob)
	if(user.action_busy)
		return TRUE //no afterattack

	if(!skillcheck(user, SKILL_CONSTRUCTION, SKILL_CONSTRUCTION_TRAINED))
		to_chat(user, SPAN_WARNING("You are not trained to configure \the [src]..."))
		return

	if(istype(W, /obj/item/tool/pen))
		var/t = copytext(stripped_input(user, "Enter the name for the airlock.", name, created_name), 1, MAX_NAME_LEN)
		if(!t || !in_range(src, usr) && loc != usr)
			return
		created_name = t
		return

	if(istype(W, /obj/item/stack/sheet/glass))
		var/obj/item/stack/sheet/glass/G = W
		if(!anchored)
			to_chat(user, SPAN_NOTICE("The airlock is not secured!"))
			return
		if(state != STATE_STANDARD)
			to_chat(user, SPAN_NOTICE("You can't add in the glass with the circuit already in!"))
			return
		if(glass == AIRLOCK_GLASSIN)
			to_chat(user, SPAN_NOTICE("You can't add more glass to \the [src]!"))
			return
		if(glass == AIRLOCK_CANTGLASS)
			to_chat(user, SPAN_NOTICE("\The [src] has no slots to install glass!"))
			return
		if(!do_after(user, 20 * user.get_skill_duration_multiplier(SKILL_CONSTRUCTION), INTERRUPT_ALL|BEHAVIOR_IMMOBILE, BUSY_ICON_BUILD))
			return
		if(G.use(5))
			playsound(loc, 'sound/items/Deconstruct.ogg', 25, 1)
			glass = AIRLOCK_GLASSIN
			to_chat(user, SPAN_NOTICE("You insert some glass into \the [src], adding windows to it."))
			update_icon()
			return
		else
			to_chat(user, SPAN_WARNING("You need five sheets of glass to add windows to \the [src]!"))
			return

	if(HAS_TRAIT(W, TRAIT_TOOL_CROWBAR))
		to_chat(user, SPAN_NOTICE("You start pulling \the [src] apart."))
		playsound(loc, 'sound/items/Crowbar.ogg', 25, 1)
		if(!do_after(user, 20 * user.get_skill_duration_multiplier(SKILL_CONSTRUCTION), INTERRUPT_ALL|BEHAVIOR_IMMOBILE, BUSY_ICON_BUILD))
			return
		to_chat(user, SPAN_NOTICE("You pulled \the [src] apart."))
		playsound(loc, 'sound/items/Deconstruct.ogg', 25, 1)
		new /obj/item/stack/sheet/metal(loc, 5)
		if(glass == AIRLOCK_GLASSIN)
			new /obj/item/stack/sheet/glass(loc, 5)
		qdel(src)
		return

	switch(state)
		if(STATE_STANDARD)
			if(HAS_TRAIT(W, TRAIT_TOOL_WRENCH))
				if(!anchored)
					var/turf/open/T = loc
					if(!(istype(T) && T.allow_construction))
						to_chat(user, SPAN_WARNING("\The [src] cannot be secured here!"))
						return
				playsound(loc, 'sound/items/Ratchet.ogg', 25, 1)
				to_chat(user, SPAN_NOTICE(" You start [anchored? "un" : ""]securing the airlock assembly!"))
				if(!do_after(user, 40 * user.get_skill_duration_multiplier(SKILL_CONSTRUCTION), INTERRUPT_ALL|BEHAVIOR_IMMOBILE, BUSY_ICON_BUILD))
					return
				playsound(loc, 'sound/items/Ratchet.ogg', 25, 1)
				to_chat(user, SPAN_NOTICE(" You [anchored? "un" : ""]secured the airlock assembly!"))
				anchored = !anchored
				return

			if(!anchored)
				to_chat(user, SPAN_NOTICE("The airlock is not secured!"))
				return ..()

			if(istype(W, /obj/item/circuitboard/airlock))
				var/obj/item/circuitboard/airlock/C = W
				if(C.fried) // guess what this used to check? ICON STATE!!
					to_chat(user, SPAN_WARNING("\The [C] are totally broken!"))
					return
				playsound(loc, 'sound/items/Screwdriver.ogg', 25, 1)
				to_chat(user, SPAN_NOTICE("You start installing the airlock electronics."))
				if(!do_after(user, 40 * user.get_skill_duration_multiplier(SKILL_CONSTRUCTION), INTERRUPT_ALL|BEHAVIOR_IMMOBILE, BUSY_ICON_BUILD))
					return
				playsound(loc, 'sound/items/Screwdriver.ogg', 25, 1)
				user.drop_held_item()
				W.forceMove(src)
				to_chat(user, SPAN_NOTICE("You installed the airlock electronics!"))
				state = STATE_CIRCUIT
				electronics = W
				update_icon()
				return

			if(HAS_TRAIT(W, TRAIT_TOOL_SCREWDRIVER))
				if(!anchored)
					to_chat(user, SPAN_NOTICE("The airlock is not secured!"))
					return
				if(glass != AIRLOCK_GLASSIN)
					to_chat(user, SPAN_NOTICE("\The [src] has no glass to take out!"))
					return
				if(!do_after(user, 20 * user.get_skill_duration_multiplier(SKILL_CONSTRUCTION), INTERRUPT_ALL|BEHAVIOR_IMMOBILE, BUSY_ICON_BUILD))
					return
				playsound(loc, 'sound/items/Deconstruct.ogg', 25, 1)
				glass = AIRLOCK_NOGLASS
				new /obj/item/stack/sheet/glass(loc, 5)
				to_chat(user, SPAN_NOTICE("You pry the glass panes out of \the [src]."))
				update_icon()
				return


		if(STATE_CIRCUIT)
			if(istype(W, /obj/item/stack/cable_coil))
				var/obj/item/stack/cable_coil/C = W
				if (C.get_amount() < 1)
					to_chat(user, SPAN_WARNING("You need one length of coil to wire the airlock assembly."))
					return
				to_chat(user, SPAN_NOTICE("You start to wire the circuit."))
				if(!do_after(user, 40 * user.get_skill_duration_multiplier(SKILL_CONSTRUCTION), INTERRUPT_ALL|BEHAVIOR_IMMOBILE, BUSY_ICON_BUILD))
					return
				if(C.use(1))
					state = STATE_WIRES
					to_chat(user, SPAN_NOTICE("You wire the circuit."))
					update_icon()
				return

		if(STATE_WIRES)
			if(HAS_TRAIT(W, TRAIT_TOOL_SCREWDRIVER))
				playsound(loc, 'sound/items/Screwdriver.ogg', 25, 1)
				to_chat(user, SPAN_NOTICE("You start securing the circuit"))
				if(!do_after(user, 40 * user.get_skill_duration_multiplier(SKILL_CONSTRUCTION), INTERRUPT_ALL|BEHAVIOR_IMMOBILE, BUSY_ICON_BUILD))
					return
				playsound(loc, 'sound/items/Screwdriver.ogg', 25, 1)
				to_chat(user, SPAN_NOTICE("You secured the circuit!"))
				state = STATE_SCREWDRIVER
				update_icon()
				return

		if(STATE_SCREWDRIVER)
			if(iswelder(W))
				if(!HAS_TRAIT(W, TRAIT_TOOL_BLOWTORCH))
					to_chat(user, SPAN_WARNING("You need a stronger blowtorch!"))
					return
				var/obj/item/tool/weldingtool/WT = W
				if(!WT.remove_fuel(5, user))
					return
				playsound(loc, 'sound/items/Welder2.ogg', 25, 1)
				to_chat(user, SPAN_NOTICE("Now finishing the airlock."))

				if(!do_after(user, 40 * user.get_skill_duration_multiplier(SKILL_CONSTRUCTION), INTERRUPT_ALL|BEHAVIOR_IMMOBILE, BUSY_ICON_BUILD))
					WT.remove_fuel(-5)
					return

				playsound(loc, 'sound/items/Welder2.ogg', 25, 1)
				to_chat(user, SPAN_NOTICE("You finish the airlock!"))
				var/path
				if (glass == AIRLOCK_GLASSIN)
					path = text2path("/obj/structure/machinery/door/airlock/almayer/[airlock_type]/glass")
				else
					path = text2path("/obj/structure/machinery/door/airlock/almayer/[airlock_type]")
				var/obj/structure/machinery/door/airlock/door = new path(loc)
				door.assembly_type = type
				door.electronics = electronics
				door.dir = dir
				if(electronics.one_access)
					door.req_access = null
					door.req_one_access = electronics.conf_access
				else
					door.req_access = electronics.conf_access

				if(created_name)
					door.name = created_name
				else
					door.name = base_name

				electronics.forceMove(door)
				qdel(src)
				return
	..()

/obj/structure/airlock_assembly/update_icon()
	icon_state = "door_as_[state]"
	if(glass == AIRLOCK_GLASSIN)
		icon_state = "door_as_g[state]"
	else
		icon_state = "door_as_[base_icon_state][state]"

/obj/structure/airlock_assembly/airlock_assembly_com
	base_icon_state = "com"
	base_name = "Command Airlock"
	airlock_type = "/command"

/obj/structure/airlock_assembly/airlock_assembly_sec
	base_icon_state = "sec"
	base_name = "Security Airlock"
	airlock_type = "/security"

/obj/structure/airlock_assembly/airlock_assembly_eng
	base_icon_state = "eng"
	base_name = "Engineering Airlock"
	airlock_type = "/engineering"

/obj/structure/airlock_assembly/airlock_assembly_min
	base_icon_state = "min"
	base_name = "Mining Airlock"
	airlock_type = "/mining"

/obj/structure/airlock_assembly/airlock_assembly_atmo
	base_icon_state = "atmo"
	base_name = "Atmospherics Airlock"
	airlock_type = "/atmos"

/obj/structure/airlock_assembly/airlock_assembly_research
	base_icon_state = "res"
	base_name = "Research Airlock"
	airlock_type = "/research"

/obj/structure/airlock_assembly/airlock_assembly_science
	base_icon_state = "sci"
	base_name = "Science Airlock"
	airlock_type = "/science"

/obj/structure/airlock_assembly/airlock_assembly_med
	base_icon_state = "med"
	base_name = "Medical Airlock"
	airlock_type = "/medical"

/obj/structure/airlock_assembly/airlock_assembly_mai
	base_icon_state = "mai"
	base_name = "Maintenance Airlock"
	airlock_type = "/maintenance"
	glass = AIRLOCK_CANTGLASS

/obj/structure/airlock_assembly/airlock_assembly_ext
	base_icon_state = "ext"
	base_name = "External Airlock"
	airlock_type = "/external"
	glass = AIRLOCK_CANTGLASS

/obj/structure/airlock_assembly/airlock_assembly_fre
	base_icon_state = "fre"
	base_name = "Freezer Airlock"
	airlock_type = "/freezer"
	glass = AIRLOCK_CANTGLASS

/obj/structure/airlock_assembly/airlock_assembly_hatch
	base_icon_state = "hatch"
	base_name = "Airtight Hatch"
	airlock_type = "/hatch"
	glass = AIRLOCK_CANTGLASS

/obj/structure/airlock_assembly/airlock_assembly_mhatch
	base_icon_state = "mhatch"
	base_name = "Maintenance Hatch"
	airlock_type = "/maintenance_hatch"
	glass = AIRLOCK_CANTGLASS

/obj/structure/airlock_assembly/airlock_assembly_highsecurity // Borrowing this until WJohnston makes sprites for the assembly
	base_icon_state = "highsec"
	base_name = "High Security Airlock"
	airlock_type = "/highsecurity"
	glass = AIRLOCK_CANTGLASS

/obj/structure/airlock_assembly/multi_tile
	icon = 'icons/obj/structures/doors/airlock_assembly2x1.dmi'
	dir = EAST
	var/width = 1

/*Temporary until we get sprites.
	airlock_type = "/multi_tile/maint"
	glass = 1*/
	base_icon_state = "g" //Remember to delete this line when reverting "glass" var to 1.
	airlock_type = "/multi_tile/glass"
	glass = AIRLOCK_CANTGLASS //To prevent bugs in deconstruction process.

/obj/structure/airlock_assembly/multi_tile/Initialize(mapload, ...)
	. = ..()
	if(dir in list(EAST, WEST))
		bound_width = width * world.icon_size
		bound_height = world.icon_size
	else
		bound_width = world.icon_size
		bound_height = width * world.icon_size
	update_icon()

/obj/structure/airlock_assembly/multi_tile/Move()
	. = ..()
	if(dir in list(EAST, WEST))
		bound_width = width * world.icon_size
		bound_height = world.icon_size
	else
		bound_width = world.icon_size
		bound_height = width * world.icon_size


#undef STATE_STANDARD
#undef STATE_CIRCUIT
#undef STATE_WIRES
#undef STATE_SCREWDRIVER

#undef AIRLOCK_MATERIAL_COST
