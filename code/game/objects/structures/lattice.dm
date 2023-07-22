/obj/structure/lattice
	desc = "A lightweight support lattice."
	name = "lattice"
	icon = 'icons/obj/structures/structures.dmi'
	icon_state = "latticefull"
	density = FALSE
	anchored = TRUE
	layer = LATTICE_LAYER
	plane = FLOOR_PLANE
	// flags = CONDUCT

/obj/structure/lattice/Initialize()
	. = ..()
	if(!istype(src.loc, /turf/open/space))
		return INITIALIZE_HINT_QDEL
	for(var/obj/structure/lattice/LAT in src.loc)
		if(LAT != src)
			qdel(LAT)
	icon = 'icons/obj/structures/props/smoothlattice.dmi'
	icon_state = "latticeblank"
	updateOverlays()
	for (var/dir in cardinal)
		var/obj/structure/lattice/L
		if(locate(/obj/structure/lattice, get_step(src, dir)))
			L = locate(/obj/structure/lattice, get_step(src, dir))
			L.updateOverlays()

/obj/structure/lattice/Destroy()
	for (var/dir in cardinal)
		var/obj/structure/lattice/L
		if(locate(/obj/structure/lattice, get_step(src, dir)))
			L = locate(/obj/structure/lattice, get_step(src, dir))
			L.updateOverlays(src.loc)
	. = ..()

/obj/structure/lattice/ex_act(severity)
	switch(severity)
		if(0 to EXPLOSION_THRESHOLD_LOW)
			return
		if(EXPLOSION_THRESHOLD_LOW to EXPLOSION_THRESHOLD_MEDIUM)
			deconstruct(FALSE)
			return
		if(EXPLOSION_THRESHOLD_MEDIUM to INFINITY)
			deconstruct(FALSE)
			return
		else
	return

/obj/structure/lattice/attackby(obj/item/C as obj, mob/user as mob)

	if (istype(C, /obj/item/stack/tile/plasteel))
		var/turf/T = get_turf(src)
		T.attackby(C, user) //BubbleWrap - hand this off to the underlying turf instead
		return
	if (iswelder(C))
		if(!HAS_TRAIT(C, TRAIT_TOOL_BLOWTORCH))
			to_chat(user, SPAN_WARNING("You need a stronger blowtorch!"))
			return
		var/obj/item/tool/weldingtool/WT = C
		if(WT.remove_fuel(0, user))
			to_chat(user, SPAN_NOTICE("Slicing lattice joints..."))
		deconstruct()
	return

/obj/structure/lattice/deconstruct(disassembled = TRUE)
	if(disassembled)
		new /obj/item/stack/rods(src.loc)
	return ..()

/obj/structure/lattice/proc/updateOverlays()
	//if(!(istype(src.loc, /turf/open/space)))
	// qdel(src)
	spawn(1)
		overlays = list()

		var/dir_sum = 0

		for (var/direction in cardinal)
			if(locate(/obj/structure/lattice, get_step(src, direction)))
				dir_sum += direction
			else
				if(!(istype(get_step(src, direction), /turf/open/space)))
					dir_sum += direction

		icon_state = "lattice[dir_sum]"
		return
