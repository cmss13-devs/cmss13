// attach a wire to a power machine - leads from the turf you are standing on

/obj/structure/machinery/power/attackby(obj/item/W, mob/user)

	if(istype(W, /obj/item/stack/cable_coil))

		var/obj/item/stack/cable_coil/coil = W

		var/turf/T = user.loc

		if(T.intact_tile || !istype(T, /turf/open/floor))
			return

		if(get_dist(src, user) > 1)
			return

		if(!directwired) // only for attaching to directwired machines
			return

		coil.turf_place(T, user)
		return
	else
		. = ..()
	return

// the power cable object
/obj/structure/cable
	level = 1
	anchored =1
	var/datum/powernet/powernet
	name = "power cable"
	desc = "A flexible superconducting cable for heavy-duty power transfer"
	icon = 'icons/obj/pipes/power_cond_white.dmi'
	icon_state = "0-1"
	var/d1 = 0
	var/d2 = 1
	layer = WIRE_LAYER
	plane = FLOOR_PLANE
	color = COLOR_RED
	var/obj/structure/machinery/power/breakerbox/breaker_box
	unslashable = TRUE
	unacidable = TRUE
	var/id

/obj/structure/cable/yellow
	color = "#ffe28a"

/obj/structure/cable/green
	color = "#589471"

/obj/structure/cable/blue
	color = "#a8c1dd"

/obj/structure/cable/pink
	color = "#6fcb9f"

/obj/structure/cable/orange
	color = "#ff9845"

/obj/structure/cable/cyan
	color = "#a8c1dd"

/obj/structure/cable/white
	color = "#666547"

/obj/structure/cable/Initialize()
	. = ..()
	// ensure d1 & d2 reflect the icon_state for entering and exiting cable
	var/dash = findtext(icon_state, "-")
	d1 = text2num( copytext( icon_state, 1, dash ) )
	d2 = text2num( copytext( icon_state, dash+1 ) )
	var/turf/T = src.loc // hide if turf is not intact
	if(level==1)
		hide(T.intact_tile)
	update_icon()
	GLOB.cable_list += src

/obj/structure/cable/Destroy()
	breaker_box = null
	GLOB.cable_list -= src
	return ..()

/obj/structure/cable/hide(i)

	if(level == 1 && istype(loc, /turf))
		invisibility = i ? 101 : 0
	updateicon()

/obj/structure/cable/proc/updateicon()
	icon_state = "[d1]-[d2]"
	alpha = invisibility ? 127 : 255


/obj/structure/cable/attackby(obj/item/W, mob/user)

	var/turf/T = src.loc
	if(T.intact_tile)
		return

	if(HAS_TRAIT(W, TRAIT_TOOL_WIRECUTTERS))

///// Z-Level Stuff
		if(src.d1 == 12 || src.d2 == 12)
			to_chat(user, SPAN_WARNING("You must cut this cable from above."))
			return

		if(src.d1 == 11 || src.d2 == 11)
			return

		if(src.d1 == 12 || src.d2 == 12)
			return

///// Z-Level Stuff

		if(breaker_box)
			to_chat(user, SPAN_DANGER("This cable is connected to nearby breaker box. Use breaker box to interact with it."))
			return

		if (shock(user, 50))
			return

		deconstruct()
		for(var/mob/O in viewers(src, null))
			O.show_message(SPAN_WARNING("[user] cuts the cable."), SHOW_MESSAGE_VISIBLE)
		// wires are irrelevant so I have disabled this message for now
		//message_admins("[key_name(user)] cut a wire at ([x],[y],[z]) [ADMIN_JMP(src)]")

		return // not needed, but for clarity


	else if(istype(W, /obj/item/stack/cable_coil))
		var/obj/item/stack/cable_coil/coil = W
		coil.cable_join(src, user)

	else
		if (W.flags_atom & CONDUCT)
			shock(user, 50, 0.7)

	src.add_fingerprint(user)

// shock the user with probability prb

/obj/structure/cable/proc/shock(mob/user, prb, siemens_coeff = 1.0)
	if(!prob(prb))
		return 0
	if (electrocute_mob(user, powernet, src, siemens_coeff))
		var/datum/effect_system/spark_spread/s = new /datum/effect_system/spark_spread
		s.set_up(5, 1, src)
		s.start()
		return 1
	else
		return 0

/obj/structure/cable/ex_act(severity)
	if(SSmapping.configs[GROUND_MAP].map_name == MAP_WHISKEY_OUTPOST)
		return
	if(is_ground_level(z) && layer < 2) //ground map - no blowie. They are buried underground.
		return

	if(src.d1 == 11 || src.d2 == 11)
		return

	if(src.d1 == 12 || src.d2 == 12)
		return

	switch(severity)
		if(0 to EXPLOSION_THRESHOLD_LOW)
			if (prob(25))
				deconstruct(TRUE)
		if(EXPLOSION_THRESHOLD_LOW to EXPLOSION_THRESHOLD_MEDIUM)
			if (prob(50))
				deconstruct(TRUE)
		if(EXPLOSION_THRESHOLD_MEDIUM to INFINITY)
			deconstruct(FALSE)
	return

/obj/structure/cable/deconstruct(disassembled = TRUE)
	if(disassembled)
		new/obj/item/stack/cable_coil(src.loc, src.d1 ? 2 : 1, color)
	return ..()

/obj/structure/cable/proc/cableColor(colorC)
	if(colorC)
		color = colorC
	else
		color = "#DD0000"
