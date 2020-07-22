#define STATE_STANDARD 		0
#define STATE_CIRCUIT		1
#define STATE_WIRES			2
#define STATE_SCREWDRIVER	3

#define AIRLOCK_MATERIAL_COST	5

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
	var/airlock_type = "" //the type path of the airlock once completed
	var/glass_type = "/glass"
	var/glass = 0 // 0 = glass can be installed. -1 = glass can't be installed. 1 = glass is already installed. Text = mineral plating is installed instead.
	var/created_name = null

/obj/structure/airlock_assembly/Initialize(mapload, ...)
	. = ..()

	update_icon()

/obj/structure/airlock_assembly/examine(mob/user)
	. = ..()
	
	to_chat(user, SPAN_NOTICE("A [SPAN_HELPFUL("crowbar")] will dismantle it."))
	switch(state)
		if(STATE_STANDARD)
			if(anchored)
				to_chat(user, SPAN_NOTICE("It looks like a [SPAN_HELPFUL("wrench")] will unsecure it. Insert a [SPAN_HELPFUL("airlock circuit")]."))
			else
				to_chat(user, SPAN_NOTICE("It looks like a [SPAN_HELPFUL("wrench")] will secure it."))
		if(STATE_CIRCUIT)
			to_chat(user, SPAN_NOTICE("Add [SPAN_HELPFUL("cable coil")] to the circuit."))
		if(STATE_WIRES)
			to_chat(user, SPAN_NOTICE("Secure the circuit with a [SPAN_HELPFUL("screwdriver")]."))
		if(STATE_SCREWDRIVER)
			to_chat(user, SPAN_NOTICE("[SPAN_HELPFUL("Weld")] it all in place."))

/obj/structure/airlock_assembly/attackby(obj/item/W as obj, mob/user as mob)
	if(user.action_busy)
		return TRUE //no afterattack

	if(!skillcheck(user, SKILL_CONSTRUCTION, SKILL_CONSTRUCTION_TRAINED))
		to_chat(user, SPAN_WARNING("You are not trained to configure [src]..."))
		return 

	if(istype(W, /obj/item/tool/pen))
		var/t = copytext(stripped_input(user, "Enter the name for the door.", name, created_name), 1, MAX_NAME_LEN)
		if(!t || !in_range(src, usr) && loc != usr)	
			return
		created_name = t
		return

	if(iscrowbar(W))
		to_chat(user, SPAN_NOTICE("You start pulling [src] apart."))
		playsound(loc, 'sound/items/Crowbar.ogg', 25, 1)
		if(!do_after(user, 20 * user.get_skill_duration_multiplier(SKILL_CONSTRUCTION), INTERRUPT_ALL|BEHAVIOR_IMMOBILE, BUSY_ICON_BUILD))
			return
		to_chat(user, SPAN_NOTICE("You pulled [src] apart."))
		playsound(loc, 'sound/items/Deconstruct.ogg', 25, 1)
		new /obj/item/stack/sheet/metal(loc, 5)
		qdel(src)
		return

	switch(state)
		if(STATE_STANDARD)
			if(iswrench(W))
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
				if(C.icon_state == "door_electronics_smoked")
					return
				playsound(loc, 'sound/items/Screwdriver.ogg', 25, 1)
				to_chat(user, SPAN_NOTICE("You start installing the airlock electronics."))
				if(!do_after(user, 40 * user.get_skill_duration_multiplier(SKILL_CONSTRUCTION), INTERRUPT_ALL|BEHAVIOR_IMMOBILE, BUSY_ICON_BUILD))
					return
				playsound(loc, 'sound/items/Screwdriver.ogg', 25, 1)
				user.drop_held_item()
				W.loc = src
				to_chat(user, SPAN_NOTICE("You installed the airlock electronics!"))
				state = STATE_CIRCUIT
				electronics = W
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
			if(isscrewdriver(W))
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
				if(istext(glass))
					path = text2path("/obj/structure/machinery/door/airlock/[glass]")
				else if (glass == 1)
					path = text2path("/obj/structure/machinery/door/airlock[glass_type]")
				else
					path = text2path("/obj/structure/machinery/door/airlock[airlock_type]")
				var/obj/structure/machinery/door/airlock/door = new path(loc)
				door.assembly_type = type
				door.electronics = electronics
				if(electronics.one_access)
					door.req_access = null
					door.req_one_access = electronics.conf_access
				else
					door.req_access = electronics.conf_access

				if(created_name)
					door.name = created_name
				else
					door.name = "[istext(glass) ? "[glass] airlock" : base_name]"

				electronics.loc = door
				qdel(src)
				return
	..()

/obj/structure/airlock_assembly/update_icon()
	icon_state = "door_as_[state]"
	if(glass == 1)
		icon_state = "door_as_g[state]"
	else if (istext(glass))
		icon_state = "door_as_[glass][state]"
	else
		icon_state = "door_as_[base_icon_state][state]"

/obj/structure/airlock_assembly/airlock_assembly_com
	base_icon_state = "com"
	base_name = "Command Airlock"
	glass_type = "/glass_command"
	airlock_type = "/command"

/obj/structure/airlock_assembly/airlock_assembly_sec
	base_icon_state = "sec"
	base_name = "Security Airlock"
	glass_type = "/glass_security"
	airlock_type = "/security"

/obj/structure/airlock_assembly/airlock_assembly_eng
	base_icon_state = "eng"
	base_name = "Engineering Airlock"
	glass_type = "/glass_engineering"
	airlock_type = "/engineering"

/obj/structure/airlock_assembly/airlock_assembly_min
	base_icon_state = "min"
	base_name = "Mining Airlock"
	glass_type = "/glass_mining"
	airlock_type = "/mining"

/obj/structure/airlock_assembly/airlock_assembly_atmo
	base_icon_state = "atmo"
	base_name = "Atmospherics Airlock"
	glass_type = "/glass_atmos"
	airlock_type = "/atmos"

/obj/structure/airlock_assembly/airlock_assembly_research
	base_icon_state = "res"
	base_name = "Research Airlock"
	glass_type = "/glass_research"
	airlock_type = "/research"

/obj/structure/airlock_assembly/airlock_assembly_science
	base_icon_state = "sci"
	base_name = "Science Airlock"
	glass_type = "/glass_science"
	airlock_type = "/science"

/obj/structure/airlock_assembly/airlock_assembly_med
	base_icon_state = "med"
	base_name = "Medical Airlock"
	glass_type = "/glass_medical"
	airlock_type = "/medical"

/obj/structure/airlock_assembly/airlock_assembly_mai
	base_icon_state = "mai"
	base_name = "Maintenance Airlock"
	airlock_type = "/maintenance"
	glass = -1

/obj/structure/airlock_assembly/airlock_assembly_ext
	base_icon_state = "ext"
	base_name = "External Airlock"
	airlock_type = "/external"
	glass = -1

/obj/structure/airlock_assembly/airlock_assembly_fre
	base_icon_state = "fre"
	base_name = "Freezer Airlock"
	airlock_type = "/freezer"
	glass = -1

/obj/structure/airlock_assembly/airlock_assembly_hatch
	base_icon_state = "hatch"
	base_name = "Airtight Hatch"
	airlock_type = "/hatch"
	glass = -1

/obj/structure/airlock_assembly/airlock_assembly_mhatch
	base_icon_state = "mhatch"
	base_name = "Maintenance Hatch"
	airlock_type = "/maintenance_hatch"
	glass = -1

/obj/structure/airlock_assembly/airlock_assembly_highsecurity // Borrowing this until WJohnston makes sprites for the assembly
	base_icon_state = "highsec"
	base_name = "High Security Airlock"
	airlock_type = "/highsecurity"
	glass = -1

/obj/structure/airlock_assembly/multi_tile
	icon = 'icons/obj/structures/doors/airlock_assembly2x1.dmi'
	dir = EAST
	var/width = 1

/*Temporary until we get sprites.
	glass_type = "/multi_tile/glass"
	airlock_type = "/multi_tile/maint"
	glass = 1*/
	base_icon_state = "g" //Remember to delete this line when reverting "glass" var to 1.
	airlock_type = "/multi_tile/glass"
	glass = -1 //To prevent bugs in deconstruction process.

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