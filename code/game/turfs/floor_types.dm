



//Floors

/turf/open/floor/plating
	name = "plating"
	icon_state = "plating"
	intact_tile = FALSE
	tool_flags = NO_FLAGS

/turf/open/floor/plating/is_plating()
	return TRUE

/turf/open/floor/plating/is_plasteel_floor()
	return FALSE

/turf/open/floor/plating/is_light_floor()
	return FALSE

/turf/open/floor/plating/is_grass_floor()
	return FALSE

/turf/open/floor/plating/is_wood_floor()
	return FALSE

/turf/open/floor/plating/is_carpet_floor()
	return FALSE


/turf/open/floor/plating/attackby(obj/item/C, mob/user)
	if(istypestrict(C, /obj/item/stack/rods))
		var/obj/item/stack/rods/R = C
		if(R.get_amount() < 2)
			to_chat(user, SPAN_WARNING("You need more rods."))
			return
		to_chat(user, SPAN_NOTICE("You start reinforcing the floor."))
		var/current_type = type
		if(do_after(user, 30 * user.get_skill_duration_multiplier(SKILL_CONSTRUCTION), INTERRUPT_ALL|BEHAVIOR_IMMOBILE, BUSY_ICON_BUILD) && current_type == type)
			if(!R)
				return
			if(R.use(2))
				ChangeTurf(/turf/open/floor/engine)
				playsound(src, 'sound/items/Deconstruct.ogg', 25, 1)
		return
	if(istype(C, /obj/item/stack/cable_coil))
		var/obj/item/stack/cable_coil/coil = C
		coil.turf_place(src, user)
		return
	if(iswelder(C))
		if(!HAS_TRAIT(C, TRAIT_TOOL_BLOWTORCH))
			to_chat(user, SPAN_WARNING("You need a stronger blowtorch!"))
			return
		var/obj/item/tool/weldingtool/welder = C
		if(welder.isOn() && (broken || burnt))
			if(welder.remove_fuel(0, user))
				to_chat(user, SPAN_WARNING("You fix some dents on the broken plating."))
				playsound(src, 'sound/items/Welder.ogg', 25, 1)
				icon_state = "plating"
				burnt = FALSE
				broken = FALSE
			else
				to_chat(user, SPAN_WARNING("You need more welding fuel to complete this task."))
		return
	if(istype(C, /obj/item/stack/tile))
		if(broken || burnt)
			to_chat(user, SPAN_NOTICE("This section is too damaged to support a tile. Use a welder to fix the damage."))
			return
		var/obj/item/stack/tile/T = C
		if(T.get_amount() < 1)
			return
		playsound(src, 'sound/weapons/Genhit.ogg', 25, 1)
		T.use(1)
		T.build(src)
		return
	if(istype(C, /obj/item/stack/catwalk))
		if(broken || burnt)
			to_chat(user, SPAN_NOTICE("This section is too damaged to support a catwalk. Use a welder to fix the damage."))
			return
		var/obj/item/stack/catwalk/T = C
		if(T.get_amount() < 1)
			return
		playsound(src, 'sound/weapons/Genhit.ogg', 25, 1)
		T.use(1)
		T.build(src)
		return
	return ..()

/turf/open/floor/plating/make_plating()
	return

/turf/open/floor/plating/prison
	icon = 'icons/turf/floors/prison.dmi'

/turf/open/floor/plating/almayer
	icon = 'icons/turf/almayer.dmi'

/turf/open/floor/plating/airless
	icon_state = "plating"
	name = "airless plating"

/turf/open/floor/plating/airless/Initialize(mapload, ...)
	. = ..()
	name = "plating"

/turf/open/floor/plating/icefloor
	icon_state = "plating"
	name = "ice colony plating"

/turf/open/floor/plating/icefloor/Initialize(mapload, ...)
	. = ..()
	name = "plating"

/// Visually like plating+catwalks but without overlaying or interactions - mainly for Reqs Elevator
/turf/open/floor/plating/bare_catwalk
	name = "catwalk"
	desc = "Cats really don't like these things."
	icon = 'icons/turf/almayer.dmi'
	icon_state = "plating_catwalk"

/turf/open/floor/plating/plating_catwalk
	name = "catwalk"
	desc = "Cats really don't like these things."
	icon = 'icons/turf/almayer.dmi'
	icon_state = "plating_catwalk"
	var/base_state = "plating" //Post mapping
	var/covered = TRUE

/turf/open/floor/plating/plating_catwalk/Initialize(mapload, ...)
	. = ..()

	icon_state = base_state
	update_icon()

/turf/open/floor/plating/plating_catwalk/update_icon()
	. = ..()
	if(covered)
		overlays += image(icon, src, "catwalk", CATWALK_LAYER)

/turf/open/floor/plating/plating_catwalk/attackby(obj/item/W as obj, mob/user as mob)
	if (HAS_TRAIT(W, TRAIT_TOOL_CROWBAR))
		if(covered)
			var/obj/item/stack/catwalk/R = new(src, 1, type)
			R.add_to_stacks(usr)
			covered = FALSE
			to_chat(user, SPAN_WARNING("You remove the top of the catwalk."))
			playsound(src, 'sound/items/Crowbar.ogg', 25, 1)
			update_icon()
			return
	if(istype(W, /obj/item/stack/catwalk))
		if(!covered)
			var/obj/item/stack/catwalk/E = W
			E.use(1)
			covered = TRUE
			to_chat(user, SPAN_WARNING("You replace the top of the catwalk."))
			playsound(src, 'sound/items/Crowbar.ogg', 25, 1)
			update_icon()
			return
	return ..()

/turf/open/floor/plating/plating_catwalk/break_tile()
	if(covered)
		covered = 0
		update_icon()
	..()

/turf/open/floor/plating/plating_catwalk/break_tile_to_plating()
	if(covered)
		covered = 0
		update_icon()
	..()

/turf/open/floor/plating/plating_catwalk/prison
	icon = 'icons/turf/floors/prison.dmi'

/turf/open/floor/plating/plating_catwalk/strata
	icon = 'icons/turf/floors/strata_floor.dmi'

/turf/open/floor/plating/plating_catwalk/shiva
	icon = 'icons/turf/floors/ice_colony/shiva_floor.dmi'



/turf/open/floor/plating/ironsand
	name = "Iron Sand"

/turf/open/floor/plating/ironsand/Initialize(mapload, ...)
	. = ..()
	icon_state = "ironsand[rand(1,15)]"



/turf/open/floor/plating/catwalk
	icon = 'icons/turf/floors/catwalks.dmi'
	icon_state = "catwalk0"
	name = "catwalk"
	desc = "Cats really don't like these things."


/turf/open/floor/almayer
	icon = 'icons/turf/almayer.dmi'
	icon_state = "default"
	plating_type = /turf/open/floor/plating/almayer

//Cargo elevator
/turf/open/floor/almayer/empty
	name = "empty space"
	desc = "There seems to be an awful lot of machinery down below"
	icon = 'icons/turf/floors/floors.dmi'
	icon_state = "black"

/turf/open/floor/almayer/empty/Initialize(mapload, ...)
	. = ..()
	GLOB.asrs_empty_space_tiles_list += src

/turf/open/floor/almayer/empty/Destroy(force) // may as well
	. = ..()
	GLOB.asrs_empty_space_tiles_list -= src

/turf/open/floor/almayer/empty/is_weedable()
	return NOT_WEEDABLE

/turf/open/floor/almayer/empty/ex_act(severity) //Should make it indestructible
	return

/turf/open/floor/almayer/empty/fire_act(exposed_temperature, exposed_volume)
	return

/turf/open/floor/almayer/empty/attackby() //This should fix everything else. No cables, etc
	return

/turf/open/floor/almayer/empty/Entered(atom/movable/AM)
	..()
	if(!isobserver(AM))
		addtimer(CALLBACK(src, PROC_REF(enter_depths), AM), 0.2 SECONDS)

/turf/open/floor/almayer/empty/proc/enter_depths(atom/movable/AM)
	if(AM.throwing == 0 && istype(get_turf(AM), /turf/open/floor/almayer/empty))
		AM.visible_message(SPAN_WARNING("[AM] falls into the depths!"), SPAN_WARNING("You fall into the depths!"))
		if(!ishuman(AM))
			qdel(AM)
			return
		var/mob/living/carbon/human/thrown_human = AM
		for(var/atom/computer as anything in supply_controller.bound_supply_computer_list)
			computer.balloon_alert_to_viewers("you hear horrifying noises coming from the elevator!")

		var/area/area_shuttle = supply_controller.shuttle?.get_location_area()
		if(!area_shuttle)
			return
		var/list/turflist = list()
		for(var/turf/turf in area_shuttle)
			turflist |= turf

		thrown_human.forceMove(pick(turflist))

		var/timer = 0.5 SECONDS
		for(var/index in 1 to 10)
			timer += 0.5 SECONDS
			addtimer(CALLBACK(GLOBAL_PROC, GLOBAL_PROC_REF(maul_human), thrown_human), timer)
		return

	else
		for(var/obj/effect/decal/cleanable/C in contents) //for the off chance of someone bleeding mid=flight
			qdel(C)

//Others
/turf/open/floor/almayer/uscm
	icon_state = "logo_c"
	name = "\improper USCM Logo"

/turf/open/floor/almayer/uscm/directional
	icon_state = "logo_directional"



// RESEARCH STUFF
/turf/open/floor/almayer/research/containment/entrance
	icon_state = "containment_entrance"

/turf/open/floor/almayer/research/containment/floor1
	icon_state = "containment_floor_1"

/turf/open/floor/almayer/research/containment/floor2
	icon_state = "containment_floor_2"

/turf/open/floor/almayer/research/containment/corner
	icon_state = "containment_corner"

/turf/open/floor/almayer/research/containment/corner1
	icon_state = "containment_corner_1"

/turf/open/floor/almayer/research/containment/corner2
	icon_state = "containment_corner_2"

/turf/open/floor/almayer/research/containment/corner3
	icon_state = "containment_corner_3"

/turf/open/floor/almayer/research/containment/corner4
	icon_state = "containment_corner_4"

/turf/open/floor/almayer/research/containment/corner_var1
	icon_state = "containment_corner_variant_1"

/turf/open/floor/almayer/research/containment/corner_var2
	icon_state = "containment_corner_variant_2"






//Outerhull

/turf/open/floor/almayer_hull
	icon = 'icons/turf/almayer.dmi'
	icon_state = "outerhull"
	name = "hull"
	hull_floor = TRUE








//////////////////////////////////////////////////////////////////////





/turf/open/floor/airless
	icon_state = "floor"
	name = "airless floor"

/turf/open/floor/airless/Initialize(mapload, ...)
	. = ..()
	name = "floor"

/turf/open/floor/icefloor
	icon_state = "floor"
	name = "ice colony floor"
	plating_type = /turf/open/floor/plating/icefloor

/turf/open/floor/icefloor/Initialize(mapload, ...)
	. = ..()
	name = "floor"

/turf/open/floor/wood
	name = "wooden floor"
	icon_state = "wood"
	tile_type = /obj/item/stack/tile/wood
	tool_flags = BREAK_CROWBAR|REMOVE_SCREWDRIVER

/turf/open/floor/wood/is_wood_floor()
	return TRUE

/turf/open/floor/wood/ship
	name = "fake wooden floor"
	desc = "This metal floor has been painted to look like one made of wood. Unfortunately, wood and high-pressure internal atmosphere don't mix well. Wood is a major fire hazard don't'cha know."
	tile_type = /obj/item/stack/tile/wood/fake

/turf/open/floor/vault
	icon_state = "rockvault"

/turf/open/floor/vault/Initialize(mapload, type)
	. = ..()
	icon_state = "[type]vault"



/turf/open/floor/engine
	name = "reinforced floor"
	icon_state = "engine"
	intact_tile = 0
	breakable_tile = FALSE
	burnable_tile = FALSE
	baseturfs = /turf/open/floor

/turf/open/floor/engine/make_plating()
	return

/turf/open/floor/engine/attackby(obj/item/C as obj, mob/user as mob)
	if(!C)
		return
	if(!user)
		return
	if(HAS_TRAIT(C, TRAIT_TOOL_WRENCH))
		user.visible_message(SPAN_NOTICE("[user] starts removing [src]'s protective cover."),
		SPAN_NOTICE("You start removing [src]'s protective cover."))
		playsound(src, 'sound/items/Ratchet.ogg', 25, 1)
		if(do_after(user, 30 * user.get_skill_duration_multiplier(SKILL_CONSTRUCTION), INTERRUPT_ALL|BEHAVIOR_IMMOBILE, BUSY_ICON_BUILD))
			new /obj/item/stack/rods(src, 2)
			var/turf/open/floor/F = ScrapeAway()
			if(istype(/turf/open/floor, F))
				F.make_plating()


/turf/open/floor/engine/ex_act(severity)
	switch(severity)
		if(EXPLOSION_THRESHOLD_LOW to EXPLOSION_THRESHOLD_MEDIUM)
			if(prob(25))
				break_tile_to_plating()
		if(EXPLOSION_THRESHOLD_MEDIUM to INFINITY)
			break_tile_to_plating()


/turf/open/floor/engine/nitrogen

/turf/open/floor/engine/cult
	name = "engraved floor"
	icon_state = "cult"


/turf/open/floor/engine/vacuum
	name = "vacuum floor"
	icon_state = "engine"


/turf/open/floor/engine/mars/exterior
	name = "floor"
	icon_state = "ironsand1"





/turf/open/floor/bluegrid
	icon = 'icons/turf/floors/floors.dmi'
	icon_state = "bcircuit"

/turf/open/floor/greengrid
	icon = 'icons/turf/floors/floors.dmi'
	icon_state = "gcircuit"


/turf/open/floor/grass
	name = "grass patch"
	icon_state = "grass1"
	tile_type = /obj/item/stack/tile/grass
	tool_flags = null

/turf/open/floor/grass/Initialize(mapload, ...)
	. = ..()
	icon_state = "grass[pick("1","2","3","4")]"
	update_icon()
	return INITIALIZE_HINT_LATELOAD

/turf/open/floor/grass/LateInitialize()
	. = ..()
	for(var/direction in cardinal)
		if(istype(get_step(src,direction),/turf/open/floor))
			var/turf/open/floor/FF = get_step(src,direction)
			FF.update_icon() //so siding get updated properly

/turf/open/floor/grass/is_grass_floor()
	return TRUE

/turf/open/floor/grass/update_icon()
	. = ..()
	if(!broken && !burnt)
		if(!(icon_state in list("grass1", "grass2", "grass3", "grass4")))
			icon_state = "grass[pick("1", "2", "3", "4")]"

/turf/open/floor/grass/make_plating()
	return

/turf/open/floor/carpet
	name = "carpet"
	icon_state = "carpet"
	tile_type = /obj/item/stack/tile/carpet
	tool_flags = REMOVE_SCREWDRIVER

/turf/open/floor/carpet/Initialize(mapload, ...)
	. = ..()
	if(!icon_state)
		icon_state = "carpet"
	return INITIALIZE_HINT_LATELOAD

/turf/open/floor/carpet/LateInitialize()
	. = ..()
	update_icon()
	for(var/direction in list(1,2,4,8,5,6,9,10))
		if(istype(get_step(src,direction),/turf/open/floor))
			var/turf/open/floor/FF = get_step(src,direction)
			FF.update_icon() //so siding get updated properly

/turf/open/floor/carpet/is_carpet_floor()
	return TRUE

/turf/open/floor/carpet/update_icon()
	. = ..()
	if(!broken && !burnt)
		if(icon_state != "carpetsymbol")
			var/connectdir = 0
			for(var/direction in cardinal)
				if(istype(get_step(src, direction), /turf/open/floor))
					var/turf/open/floor/FF = get_step(src, direction)
					if(FF.is_carpet_floor())
						connectdir |= direction

			//Check the diagonal connections for corners, where you have, for example, connections both north and east
			//In this case it checks for a north-east connection to determine whether to add a corner marker or not.
			var/diagonalconnect = 0 //1 = NE; 2 = SE; 4 = NW; 8 = SW

			//Northeast
			if(connectdir & NORTH && connectdir & EAST)
				if(istype(get_step(src,NORTHEAST),/turf/open/floor))
					var/turf/open/floor/FF = get_step(src,NORTHEAST)
					if(FF.is_carpet_floor())
						diagonalconnect |= 1

			//Southeast
			if(connectdir & SOUTH && connectdir & EAST)
				if(istype(get_step(src,SOUTHEAST),/turf/open/floor))
					var/turf/open/floor/FF = get_step(src,SOUTHEAST)
					if(FF.is_carpet_floor())
						diagonalconnect |= 2

			//Northwest
			if(connectdir & NORTH && connectdir & WEST)
				if(istype(get_step(src,NORTHWEST),/turf/open/floor))
					var/turf/open/floor/FF = get_step(src,NORTHWEST)
					if(FF.is_carpet_floor())
						diagonalconnect |= 4

			//Southwest
			if(connectdir & SOUTH && connectdir & WEST)
				if(istype(get_step(src,SOUTHWEST),/turf/open/floor))
					var/turf/open/floor/FF = get_step(src,SOUTHWEST)
					if(FF.is_carpet_floor())
						diagonalconnect |= 8

			icon_state = "carpet[connectdir]-[diagonalconnect]"

/turf/open/floor/carpet/make_plating()
	for(var/direction in alldirs)
		if(istype(get_step(src, direction), /turf/open/floor))
			var/turf/open/floor/FF = get_step(src,direction)
			FF.update_icon() // So siding get updated properly
	return ..()

// Start Prison tiles

/turf/open/floor/prison
	icon = 'icons/turf/floors/prison.dmi'
	icon_state = "floor"
	plating_type = /turf/open/floor/plating/prison

/turf/open/floor/prison/trim/red
	icon_state = "darkred2"

/turf/open/floor/prison/chapel_carpet
	icon = 'icons/turf/floors/carpet_manual.dmi'//I dunno man, CM-ified carpet sprites are placed manually and I can't be bothered to write a new system for 'em.
	icon_state = "single"

// Mechbay
/turf/open/floor/mech_bay_recharge_floor
	name = "Mech Bay Recharge Station"
	icon = 'icons/obj/structures/props/mech.dmi'
	icon_state = "recharge_floor"

/turf/open/floor/mech_bay_recharge_floor/break_tile()
	if(broken)
		return
	ChangeTurf(/turf/open/floor/plating)
	broken = TRUE


/turf/open/floor/interior
	icon = 'icons/turf/floors/interior.dmi'

/turf/open/floor/interior/wood
	name = "wooden floor"
	icon_state = "oldwood1"
	tile_type = /obj/item/stack/tile/wood

/turf/open/floor/interior/wood/is_wood_floor()
	return TRUE

/turf/open/floor/interior/wood/alt
	icon_state = "oldwood2"

/turf/open/floor/interior/tatami
	name = "tatami flooring"
	desc = "A type of flooring often used in traditional Japanese-style housing."
	icon_state = "tatami"

/turf/open/floor/interior/plastic
	name = "plastic floor"
	icon_state = "plasticfloor1"

/turf/open/floor/interior/plastic/alt
	icon_state = "plasticfloor2"

// Biodome tiles

/turf/open/floor/corsat
	icon = 'icons/turf/floors/corsat.dmi'
	icon_state = "plating"
