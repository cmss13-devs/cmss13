/obj/docking_port/stationary/supply
	id = "supply_home"
	width = 5
	dwidth = 2
	dheight = 2
	height = 5
/obj/docking_port/mobile/supply
	name = "supply shuttle"
	id = SHUTTLE_SUPPLY
	callTime = 15 SECONDS

	dir = WEST
	port_direction = EAST
	width = 5
	dwidth = 2
	dheight = 2
	height = 5
	movement_force = list("KNOCKDOWN" = 0, "THROW" = 0)
	use_ripples = FALSE
	var/list/gears = list()
	var/list/obj/structure/machinery/door/poddoor/railing/railings = list()
/obj/docking_port/stationary/supply/alamyer
	name ="ASRS platform"
	id = "supply platform"
	roundstart_template = /datum/map_template/shuttle/supply

/obj/docking_port/mobile/supply/lift
	name ="ASRS lift"
	id = "supply lift"
	var/faction = FACTION_MARINE ///The faction of this docking port (aka, on which ship it is located)
	var/home_id = "supply_home" /// Id of the home docking port

/obj/docking_port/mobile/supply/Destroy(force)
	for(var/i in railings)
		var/obj/structure/machinery/door/poddoor/railing/railing = i
		railing.linked_pad = null
	railings.Cut()
	return ..()

/obj/docking_port/mobile/supply/afterShuttleMove()
	. = ..()
	if(getDockedId() == home_id)
		for(var/j in railings)
			var/obj/structure/machinery/door/poddoor/railing/R = j
			R.open()

/obj/docking_port/mobile/supply/on_ignition()
	if(getDockedId() == home_id)
		for(var/j in railings)
			var/obj/structure/machinery/door/poddoor/railing/R = j
			R.close()
		for(var/i in gears)
			var/obj/structure/machinery/gear/G = i
			G.start_moving(NORTH)
	else
		for(var/i in gears)
			var/obj/structure/machinery/gear/G = i
			G.start_moving(SOUTH)

/obj/docking_port/mobile/supply/register()
	. = ..()
	for(var/obj/structure/machinery/gear/G in GLOB.machines)
		if(G.id == "supply_elevator_gear")
			gears += G
			RegisterSignal(G, COMSIG_PARENT_QDELETING, .proc/clean_gear)
	for(var/obj/structure/machinery/door/poddoor/railing/R in GLOB.machines)
		if(R.id == "supply_elevator_railing")
			railings += R
			RegisterSignal(R, COMSIG_PARENT_QDELETING, .proc/clean_railing)
			R.linked_pad = src
			R.open()

///Signal handler when a gear is destroyed
/obj/docking_port/mobile/supply/proc/clean_gear(datum/source)
	SIGNAL_HANDLER
	gears -= source

///Signal handler when a railing is destroyed
/obj/docking_port/mobile/supply/proc/clean_railing(datum/source)
	SIGNAL_HANDLER
	railings -= source

/obj/docking_port/mobile/supply/canMove()
	if(is_station_level(z))
		return check_blacklist(shuttle_areas)
	return ..()

/obj/docking_port/mobile/supply/proc/check_blacklist(areaInstances)
	if(!areaInstances)
		areaInstances = shuttle_areas
	for(var/place in areaInstances)
		var/area/shuttle/shuttle_area = place
		for(var/trf in shuttle_area)
			var/turf/T = trf
			for(var/a in T.GetAllContents())
				if(isxeno(a))
					var/mob/living/L = a
					if(L.stat == DEAD)
						continue
				if(ishuman(a))
					var/mob/living/carbon/human/human_to_sell = a
					if(human_to_sell.stat == DEAD && can_sell_human_body(human_to_sell, faction))
						continue
				if(is_type_in_typecache(a, GLOB.blacklisted_cargo_types))
					return FALSE
	return TRUE

/obj/docking_port/mobile/supply/request(obj/docking_port/stationary/S)
	if(mode != SHUTTLE_IDLE)
		return 2
	return ..()

/obj/docking_port/mobile/supply/proc/buy(mob/user)
	if(!length(SSpoints.shoppinglist[faction]))
		return
	log_game("Supply pack orders have been purchased by [key_name(user)]")

	var/list/empty_turfs = list()
	for(var/place in shuttle_areas)
		var/area/shuttle/shuttle_area = place
		for(var/turf/open/floor/T in shuttle_area)
			if(is_blocked_turf(T))
				continue
			empty_turfs += T

	for(var/i in SSpoints.shoppinglist[faction])
		if(!empty_turfs.len)
			break
		var/datum/supply_order/SO = LAZYACCESSASSOC(SSpoints.shoppinglist, faction, i)

		var/datum/supply_packs/firstpack = SO.pack[1]

		var/obj/structure/crate_type = firstpack.containertype || firstpack.contains[1]

		var/obj/structure/A = new crate_type(pick_n_take(empty_turfs))
		if(firstpack.containertype)
			A.name = "Order #[SO.id] for [SO.orderer]"


		var/list/contains = list()
		//spawn the stuff, finish generating the manifest while you're at it
		for(var/P in SO.pack)
			var/datum/supply_packs/SP = P
			// yes i know
			if(SP.access)
				A.req_access = list()
				A.req_access += text2num(SP.access)

			if(SP.randomised_num_contained)
				if(length(SP.contains))
					for(var/j in 1 to SP.randomised_num_contained)
						contains += pick(SP.contains)
			else
				contains += SP.contains

		for(var/typepath in contains)
			if(!typepath)
				continue
			if(!firstpack.containertype)
				break
			new typepath(A)

		SSpoints.shoppinglist[faction] -= "[SO.id]"
		SSpoints.shopping_history += SO

/obj/docking_port/mobile/supply/proc/sell()
	for(var/place in shuttle_areas)
	if(!shuttle_areas)
		return

	// Sell crates.
	for(var/obj/structure/closet/crate/C in shuttle_areas)
		points += points_per_crate
		qdel(C)

	// Sell manifests.
	for(var/atom/movable/movable_atom in shuttle_areas)
		if(istype(movable_atom, /obj/item/paper/manifest))
			var/obj/item/paper/manifest/M = movable_atom
			if(M.stamped && M.stamped.len)
				points += points_per_slip

		//black market points
		if(black_market_enabled)
			var/points_to_add = get_black_market_value(movable_atom)
			if(points_to_add == KILL_MENDOZA)
				kill_mendoza()
			black_market_sold_items[movable_atom.type] += 1
			black_market_points += points_to_add

		// Don't disintegrate humans! Maul their corpse instead. >:)
		if(ishuman(movable_atom))
			var/timer = 0.5 SECONDS
			for(var/index in 1 to 10)
				timer += 0.5 SECONDS
				addtimer(CALLBACK(GLOBAL_PROC, GLOBAL_PROC_REF(maul_human), movable_atom), timer)

		// Delete everything else.
		else qdel(movable_atom)

/datum/supply_ui/ui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)

	if(!ui)
		if(shuttle_id)
			supply = SSshuttle.getShuttle(shuttle_id)
			supply.home_id = home_id
			supply.faction = faction
		ui = new(user, src, tgui_name, source_object.name)
		ui.open()
