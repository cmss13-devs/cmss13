//Terribly sorry for the code doubling, but things go derpy otherwise.
/obj/structure/machinery/door/airlock/multi_tile
	width = 2
	damage_cap = 650 // Bigger = more endurable

/obj/structure/machinery/door/airlock/multi_tile/close() //Nasty as hell O(n^2) code but unfortunately necessary
	for(var/turf/T in locs)
		for(var/obj/vehicle/multitile/M in T)
			if(M) return 0

	return ..()

/obj/structure/machinery/door/airlock/multi_tile/glass
	name = "Glass Airlock"
	icon = 'icons/obj/structures/doors/Door2x1glass.dmi'
	opacity = FALSE
	glass = 1
	assembly_type = /obj/structure/airlock_assembly/multi_tile

/obj/structure/machinery/door/airlock/multi_tile/glass/colony
	req_access = null
	req_one_access = list(ACCESS_CIVILIAN_PUBLIC)

/obj/structure/machinery/door/airlock/multi_tile/security
	name = "Security Airlock"
	icon = 'icons/obj/structures/doors/Door2x1security.dmi'
	opacity = FALSE
	glass = 1

/obj/structure/machinery/door/airlock/multi_tile/security/colony
	req_access = null
	req_one_access = list(ACCESS_CIVILIAN_BRIG, ACCESS_CIVILIAN_COMMAND)

/obj/structure/machinery/door/airlock/multi_tile/command
	name = "Command Airlock"
	icon = 'icons/obj/structures/doors/Door2x1command.dmi'
	opacity = FALSE
	glass = 1

/obj/structure/machinery/door/airlock/multi_tile/command/colony
	req_access = null
	req_one_access = list(ACCESS_CIVILIAN_BRIG, ACCESS_CIVILIAN_COMMAND, ACCESS_WY_CORPORATE)

/obj/structure/machinery/door/airlock/multi_tile/medical
	name = "Medical Airlock"
	icon = 'icons/obj/structures/doors/Door2x1medbay.dmi'
	opacity = FALSE
	glass = 1

/obj/structure/machinery/door/airlock/multi_tile/medical/colony
	req_access = null
	req_one_access = list(ACCESS_CIVILIAN_MEDBAY, ACCESS_CIVILIAN_RESEARCH, ACCESS_CIVILIAN_COMMAND, ACCESS_CIVILIAN_PUBLIC)

/obj/structure/machinery/door/airlock/multi_tile/engineering
	name = "Engineering Airlock"
	icon = 'icons/obj/structures/doors/Door2x1engine.dmi'
	opacity = FALSE
	glass = 1

/obj/structure/machinery/door/airlock/multi_tile/engineering/colony
	req_access = null
	req_one_access = list(ACCESS_CIVILIAN_COMMAND, ACCESS_CIVILIAN_ENGINEERING, ACCESS_CIVILIAN_LOGISTICS)

/obj/structure/machinery/door/airlock/multi_tile/research
	name = "Research Airlock"
	icon = 'icons/obj/structures/doors/Door2x1research.dmi'
	opacity = FALSE
	glass = 1

/obj/structure/machinery/door/airlock/multi_tile/research/colony
	req_access = null
	req_one_access = list(ACCESS_CIVILIAN_RESEARCH, ACCESS_CIVILIAN_COMMAND, ACCESS_WY_CORPORATE)

/obj/structure/machinery/door/airlock/multi_tile/research/reinforced
	name = "Reinforced Research Airlock"
	masterkey_resist = TRUE

/obj/structure/machinery/door/airlock/multi_tile/research/reinforced/colony
	req_access = null
	req_one_access = list(ACCESS_CIVILIAN_RESEARCH, ACCESS_CIVILIAN_COMMAND, ACCESS_WY_CORPORATE)

/obj/structure/machinery/door/airlock/multi_tile/secure
	name = "Secure Airlock"
	icon = 'icons/obj/structures/doors/Door2x1_secure.dmi'
	openspeed = 34
/obj/structure/machinery/door/airlock/multi_tile/secure/colony
	req_access = null
	req_one_access = list(ACCESS_CIVILIAN_PUBLIC)

/obj/structure/machinery/door/airlock/multi_tile/secure2
	name = "Secure Airlock"
	icon = 'icons/obj/structures/doors/Door2x1_secure2.dmi'
	openspeed = 31
	req_access = null

/obj/structure/machinery/door/airlock/multi_tile/secure2/colony
	req_access = null
	req_one_access = list(ACCESS_CIVILIAN_PUBLIC)


/obj/structure/machinery/door/airlock/multi_tile/secure2_glass
	name = "Secure Airlock"
	icon = 'icons/obj/structures/doors/Door2x1_secure2_glass.dmi'
	opacity = FALSE
	glass = 1
	openspeed = 31
	req_access = null

/obj/structure/machinery/door/airlock/multi_tile/secure2_glass/colony
	req_access = null
	req_one_access = list(ACCESS_CIVILIAN_PUBLIC)

/obj/structure/machinery/door/airlock/multi_tile/shuttle
	name = "Shuttle Podlock"
	icon = 'icons/obj/structures/doors/1x2blast_vert.dmi'
	icon_state = "pdoor1"
	opacity = TRUE
	openspeed = 12
	req_access = null
	not_weldable = 1


// ALMAYER

/obj/structure/machinery/door/airlock/multi_tile/almayer
	name = "\improper Airlock"
	icon = 'icons/obj/structures/doors/comdoor.dmi' //Tiles with is here FOR SAFETY PURPOSES
	openspeed = 4 //shorter open animation.
	tiles_with = list(
		/obj/structure/window/framed/almayer,
		/obj/structure/machinery/door/airlock,
	)
	var/multi_filler = list()

/obj/structure/machinery/door/airlock/multi_tile/almayer/Initialize()
	. = ..()
	return INITIALIZE_HINT_LATELOAD

/obj/structure/machinery/door/airlock/multi_tile/almayer/LateInitialize()
	. = ..()
	relativewall_neighbours()

/obj/structure/machinery/door/airlock/multi_tile/almayer/take_damage(dam, mob/M)
	var/damage_check = max(0, damage + dam)
	if(damage_check >= damage_cap && M && is_mainship_level(z))
		SSclues.create_print(get_turf(M), M, "The fingerprint contains bits of wire and metal specks.")
	..()

/obj/structure/machinery/door/airlock/multi_tile/almayer/generic
	name = "\improper Airlock"
	icon = 'icons/obj/structures/doors/2x1generic.dmi'
	opacity = FALSE
	glass = TRUE

/obj/structure/machinery/door/airlock/multi_tile/almayer/generic/autoname
	autoname = TRUE

/obj/structure/machinery/door/airlock/multi_tile/almayer/medidoor
	name = "\improper Medical Airlock"
	icon = 'icons/obj/structures/doors/2x1medidoor.dmi'
	opacity = FALSE
	glass = TRUE
	req_access = list()
	req_one_access = list(ACCESS_MARINE_MEDBAY, ACCESS_MARINE_COMMAND)

/obj/structure/machinery/door/airlock/multi_tile/almayer/medidoor/colony
	req_access = null
	req_one_access = list(ACCESS_CIVILIAN_MEDBAY, ACCESS_CIVILIAN_RESEARCH, ACCESS_CIVILIAN_COMMAND, ACCESS_CIVILIAN_PUBLIC)

/obj/structure/machinery/door/airlock/multi_tile/almayer/medidoor/solid
	icon = 'icons/obj/structures/doors/2x1medidoor_solid.dmi'
	opacity = TRUE
	glass = FALSE

/obj/structure/machinery/door/airlock/multi_tile/almayer/medidoor/solid/colony
	req_access = null
	req_one_access = list(ACCESS_CIVILIAN_MEDBAY, ACCESS_CIVILIAN_RESEARCH, ACCESS_CIVILIAN_COMMAND, ACCESS_CIVILIAN_PUBLIC)

/obj/structure/machinery/door/airlock/multi_tile/almayer/medidoor/research
	name = "\improper Research Airlock"
	req_one_access = list(ACCESS_MARINE_RESEARCH)
	masterkey_resist = TRUE

/obj/structure/machinery/door/airlock/multi_tile/almayer/medidoor/research/colony
	req_access = null
	req_one_access = list(ACCESS_CIVILIAN_RESEARCH, ACCESS_CIVILIAN_COMMAND, ACCESS_WY_CORPORATE)

/obj/structure/machinery/door/airlock/multi_tile/almayer/comdoor
	name = "\improper Command Airlock"
	icon = 'icons/obj/structures/doors/2x1comdoor.dmi'
	opacity = FALSE
	glass = TRUE
	req_access = list(ACCESS_MARINE_COMMAND)

/obj/structure/machinery/door/airlock/multi_tile/almayer/comdoor/colony
	req_access = null
	req_one_access = list(ACCESS_CIVILIAN_BRIG, ACCESS_CIVILIAN_COMMAND, ACCESS_WY_CORPORATE)

/obj/structure/machinery/door/airlock/multi_tile/almayer/comdoor/reinforced
	name = "\improper Reinforced Command Airlock"
	masterkey_resist = TRUE

/obj/structure/machinery/door/airlock/multi_tile/almayer/comdoor/reinforced/colony
	req_access = null
	req_one_access = list(ACCESS_CIVILIAN_BRIG, ACCESS_CIVILIAN_COMMAND, ACCESS_WY_CORPORATE)

/obj/structure/machinery/door/airlock/multi_tile/almayer/comdoor/solid
	icon = 'icons/obj/structures/doors/2x1comdoor_solid.dmi'
	opacity = TRUE
	glass = FALSE

/obj/structure/machinery/door/airlock/multi_tile/almayer/comdoor/solid/colony
	req_access = null
	req_one_access = list(ACCESS_CIVILIAN_BRIG, ACCESS_CIVILIAN_COMMAND, ACCESS_WY_CORPORATE)

/obj/structure/machinery/door/airlock/multi_tile/almayer/comdoor/solid/reinforced
	name = "\improper Reinforced Command Airlock"
	masterkey_resist = TRUE

/obj/structure/machinery/door/airlock/multi_tile/almayer/comdoor/solid/reinforced/colony
	req_access = null
	req_one_access = list(ACCESS_CIVILIAN_BRIG, ACCESS_CIVILIAN_COMMAND, ACCESS_WY_CORPORATE)

/obj/structure/machinery/door/airlock/multi_tile/almayer/handle_multidoor()
	if(!(width > 1)) return //Bubblewrap

	update_filler_turfs()
	if(dir in list(NORTH, SOUTH))
		bound_height = world.icon_size * width
		bound_width = world.icon_size
	else if(dir in list(EAST, WEST))
		bound_width = world.icon_size * width
		bound_height = world.icon_size

//We have to find these again since these doors are used on shuttles a lot so the turfs changes
/obj/structure/machinery/door/airlock/multi_tile/almayer/proc/update_filler_turfs()
	for(var/turf/T in multi_filler)
		T.SetOpacity(null)

	multi_filler = list()
	for(var/turf/T in get_filler_turfs())
		T.SetOpacity(opacity)
		multi_filler += list(T)

/obj/structure/machinery/door/airlock/multi_tile/proc/get_filler_turfs()
	. = list()
	for(var/i = 1, i < width, i++)
		if(dir in list(NORTH, SOUTH))
			var/turf/T = locate(x, y + i, z)
			if(T)
				. += list(T)
		else if(dir in list(EAST, WEST))
			var/turf/T = locate(x + i, y, z)
			if(T)
				. += list(T)

/obj/structure/machinery/door/airlock/multi_tile/almayer/open()
	. = ..()
	update_filler_turfs()

/obj/structure/machinery/door/airlock/multi_tile/almayer/close()
	. = ..()
	update_filler_turfs()

//------Dropship Cargo Doors -----//

/obj/structure/machinery/door/airlock/multi_tile/almayer/dropshiprear
	opacity = TRUE
	width = 3
	unslashable = TRUE
	unacidable = TRUE
	no_panel = 1
	not_weldable = 1

/obj/structure/machinery/door/airlock/multi_tile/almayer/dropshiprear/ex_act(severity)
	return


/obj/structure/machinery/door/airlock/multi_tile/almayer/dropshiprear/unlock()
	if(is_reserved_level(z))
		return // in orbit
	..()

/obj/structure/machinery/door/airlock/multi_tile/almayer/dropshiprear/attack_alien(mob/living/carbon/xenomorph/xeno)
	if(xeno.hive_pos != XENO_QUEEN)
		return ..()

	if(!locked)
		return ..()

	to_chat(xeno, SPAN_NOTICE("You try and force the doors open"))
	if(do_after(xeno, 3 SECONDS, INTERRUPT_ALL, BUSY_ICON_HOSTILE))
		unlock(TRUE)
		open(1)
		lock(TRUE)

/obj/structure/machinery/door/airlock/multi_tile/almayer/dropshiprear/ds1
	name = "\improper Alamo cargo door"
	icon = 'icons/obj/structures/doors/dropship1_cargo.dmi'

/obj/structure/machinery/door/airlock/multi_tile/almayer/dropshiprear/ds2
	name = "\improper Normandy cargo door"
	icon = 'icons/obj/structures/doors/dropship2_cargo.dmi'

/obj/structure/machinery/door/airlock/multi_tile/almayer/dropshiprear/blastdoor
	name = "bulkhead blast door"
	icon = 'icons/obj/structures/doors/almayerblastdoor.dmi'
	desc = "A heavyset bulkhead door. Built to withstand explosions, gunshots, and extreme pressure. Chances are you're not getting through this."

/obj/structure/machinery/door/airlock/multi_tile/almayer/dropshiprear/lifeboat
	name = "lifeboat docking hatch"
	icon = 'icons/obj/structures/doors/lifeboatdoors.dmi'
	desc = "A heavyset bulkhead for a lifeboat."
	safe = FALSE
	autoclose = FALSE
	locked = TRUE
	opacity = FALSE
	glass = TRUE
	var/throw_dir = EAST

/obj/structure/machinery/door/airlock/multi_tile/almayer/dropshiprear/lifeboat/try_to_activate_door(mob/user)
	return

/obj/structure/machinery/door/airlock/multi_tile/almayer/dropshiprear/lifeboat/bumpopen(mob/user as mob)
	return

/obj/structure/machinery/door/airlock/multi_tile/almayer/dropshiprear/lifeboat/proc/close_and_lock()
	unlock(TRUE)
	close(TRUE)
	lock(TRUE)

/obj/structure/machinery/door/airlock/multi_tile/almayer/dropshiprear/lifeboat/proc/unlock_and_open()
	unlock(TRUE)
	open(TRUE)
	lock(TRUE)

/obj/structure/machinery/door/airlock/multi_tile/almayer/dropshiprear/lifeboat/close()
	. = ..()
	for(var/turf/self_turf as anything in locs)
		var/turf/projected = get_ranged_target_turf(self_turf, throw_dir, 1)
		for(var/atom/movable/atom_movable in self_turf)
			if(ismob(atom_movable) && !isobserver(atom_movable))
				var/mob/mob = atom_movable
				mob.apply_effect(5, WEAKEN)
				to_chat(mob, SPAN_HIGHDANGER("\The [src] shoves you out!"))
			else if(isobj(atom_movable))
				var/obj/object = atom_movable
				if(object.anchored)
					continue
			else
				continue
			INVOKE_ASYNC(atom_movable, TYPE_PROC_REF(/atom/movable, throw_atom), projected, 1, SPEED_FAST, null, FALSE)

/obj/structure/machinery/door/airlock/multi_tile/almayer/dropshiprear/lifeboat/connect_to_shuttle(obj/docking_port/mobile/port, obj/docking_port/stationary/dock, idnum, override)
	. = ..()
	if(istype(port, /obj/docking_port/mobile/lifeboat))
		var/obj/docking_port/mobile/lifeboat/lifeboat = port
		lifeboat.doors += src

/// External airlock that is part of the lifeboat dock
/obj/structure/machinery/door/airlock/multi_tile/almayer/dropshiprear/lifeboat/blastdoor
	name = "bulkhead blast door"
	desc = "A heavyset bulkhead door. Built to withstand explosions, gunshots, and extreme pressure. Chances are you're not getting through this."
	icon = 'icons/obj/structures/doors/almayerblastdoor.dmi'
	safe = FALSE
	/// ID of the related stationary docking port operating this
	var/linked_dock

/obj/structure/machinery/door/airlock/multi_tile/almayer/dropshiprear/lifeboat/blastdoor/Initialize(mapload, ...)
	GLOB.lifeboat_doors += src
	return ..()

/obj/structure/machinery/door/airlock/multi_tile/almayer/dropshiprear/lifeboat/blastdoor/Destroy()
	GLOB.lifeboat_doors -= src
	return ..()

/obj/structure/machinery/door/airlock/multi_tile/almayer/dropshiprear/lifeboat/blastdoor/proc/vacate_premises()
	for(var/turf/self_turf as anything in locs)
		var/turf/near_turf = get_step(self_turf, throw_dir)
		var/turf/projected = get_ranged_target_turf(near_turf, throw_dir, 50)
		for(var/atom/movable/atom_movable in near_turf)
			if(ismob(atom_movable) && !isobserver(atom_movable))
				var/mob/mob = atom_movable
				mob.apply_effect(10, STUN)
				to_chat(mob, SPAN_HIGHDANGER("You get sucked into space!"))
			else if(isobj(atom_movable))
				var/obj/object = atom_movable
				if(object.anchored)
					continue
			else
				continue
			INVOKE_ASYNC(atom_movable, TYPE_PROC_REF(/atom/movable, throw_atom), projected, 50, SPEED_FAST, null, TRUE)

/obj/structure/machinery/door/airlock/multi_tile/almayer/dropshiprear/lifeboat/blastdoor/proc/bolt_explosion()
	var/turf/turf = get_step(src, throw_dir|dir)
	cell_explosion(turf, 150, 50, EXPLOSION_FALLOFF_SHAPE_LINEAR, null, create_cause_data("lifeboat explosive bolt"))

// Elevator door
/obj/structure/machinery/door/airlock/multi_tile/elevator
	icon = 'icons/obj/structures/doors/4x1_elevator.dmi'
	icon_state = "door_closed"
	width = 4
	openspeed = 22

/obj/structure/machinery/door/airlock/multi_tile/elevator/research
	name = "\improper Research Elevator Hatch"

/obj/structure/machinery/door/airlock/multi_tile/elevator/arrivals
	name = "\improper Arrivals Elevator Hatch"

/obj/structure/machinery/door/airlock/multi_tile/elevator/dormatory
	name = "\improper Dormitory Elevator Hatch"

/obj/structure/machinery/door/airlock/multi_tile/elevator/freight
	name = "\improper Freight Elevator Hatch"


/obj/structure/machinery/door/airlock/multi_tile/elevator/access
	icon = 'icons/obj/structures/doors/4x1_elevator_access.dmi'
	opacity = FALSE
	glass = 1

/obj/structure/machinery/door/airlock/multi_tile/elevator/access/research
	name = "\improper Research Elevator Hatch"

/obj/structure/machinery/door/airlock/multi_tile/elevator/access/arrivals
	name = "\improper Arrivals Elevator Hatch"

/obj/structure/machinery/door/airlock/multi_tile/elevator/access/dormatory
	name = "\improper Dormitory Elevator Hatch"

/obj/structure/machinery/door/airlock/multi_tile/elevator/access/freight
	name = "\improper Freight Elevator Hatch"

/obj/structure/machinery/door/airlock/multi_tile/almayer/secdoor
	name = "\improper Security Airlock"
	icon = 'icons/obj/structures/doors/2x1secdoor.dmi'
	req_access = list(ACCESS_MARINE_BRIG)

/obj/structure/machinery/door/airlock/multi_tile/almayer/secdoor/colony
	req_access = null
	req_one_access = list(ACCESS_CIVILIAN_BRIG, ACCESS_CIVILIAN_COMMAND)

/obj/structure/machinery/door/airlock/multi_tile/almayer/secdoor/reinforced
	masterkey_resist = TRUE

/obj/structure/machinery/door/airlock/multi_tile/almayer/secdoor/reinforced/colony
	req_access = null
	req_one_access = list(ACCESS_CIVILIAN_BRIG, ACCESS_CIVILIAN_COMMAND)

/obj/structure/machinery/door/airlock/multi_tile/almayer/secdoor/reinforced/autoname
	autoname = TRUE

/obj/structure/machinery/door/airlock/multi_tile/almayer/secdoor/autoname
	autoname = TRUE

/obj/structure/machinery/door/airlock/multi_tile/almayer/secdoor/glass
	icon = 'icons/obj/structures/doors/2x1secdoor_glass.dmi'
	opacity = FALSE
	glass = TRUE
/obj/structure/machinery/door/airlock/multi_tile/almayer/secdoor/glass/colony
	req_access = null
	req_one_access = list(ACCESS_CIVILIAN_BRIG, ACCESS_CIVILIAN_COMMAND)

/obj/structure/machinery/door/airlock/multi_tile/almayer/secdoor/glass/autoname
	autoname = TRUE

/obj/structure/machinery/door/airlock/multi_tile/almayer/secdoor/glass/reinforced
	masterkey_resist = TRUE

/obj/structure/machinery/door/airlock/multi_tile/almayer/secdoor/glass/reinforced/colony
	req_access = null
	req_one_access = list(ACCESS_CIVILIAN_BRIG, ACCESS_CIVILIAN_COMMAND)

/obj/structure/machinery/door/airlock/multi_tile/almayer/secdoor/glass/reinforced/autoname
	autoname = TRUE

/obj/structure/machinery/door/airlock/multi_tile/almayer/engidoor
	name = "\improper Engineering Airlock"
	icon = 'icons/obj/structures/doors/2x1engidoor.dmi'
	req_access = list()
	req_one_access = list(ACCESS_MARINE_COMMAND, ACCESS_MARINE_ENGINEERING)

/obj/structure/machinery/door/airlock/multi_tile/almayer/engidoor/colony
	req_access = null
	req_one_access = list(ACCESS_CIVILIAN_COMMAND, ACCESS_CIVILIAN_ENGINEERING, ACCESS_CIVILIAN_LOGISTICS)

/obj/structure/machinery/door/airlock/multi_tile/almayer/engidoor/autoname
	autoname = TRUE

/obj/structure/machinery/door/airlock/multi_tile/almayer/engidoor/glass
	icon = 'icons/obj/structures/doors/2x1engidoor_glass.dmi'
	opacity = FALSE
	glass = TRUE

/obj/structure/machinery/door/airlock/multi_tile/almayer/engidoor/glass/colony
	req_access = null
	req_one_access = list(ACCESS_CIVILIAN_COMMAND, ACCESS_CIVILIAN_ENGINEERING, ACCESS_CIVILIAN_LOGISTICS)

/obj/structure/machinery/door/airlock/multi_tile/almayer/engidoor/glass/autoname
	autoname = TRUE

/obj/structure/machinery/door/airlock/multi_tile/almayer/marine
	icon = 'icons/obj/structures/doors/2x1prepdoor.dmi'
	opacity = FALSE
	glass = TRUE

/obj/structure/machinery/door/airlock/multi_tile/almayer/marine/colony
	req_access = null
	req_one_access = list(ACCESS_CIVILIAN_PUBLIC)

/obj/structure/machinery/door/airlock/multi_tile/almayer/marine/alpha
	name = "\improper Alpha Squad Preparations"
	icon = 'icons/obj/structures/doors/2x1prepdoor_alpha.dmi'
	req_access = list(ACCESS_MARINE_PREP)
	req_one_access = list(ACCESS_MARINE_DATABASE, ACCESS_MARINE_CARGO, ACCESS_MARINE_ALPHA)

/obj/structure/machinery/door/airlock/multi_tile/almayer/marine/bravo
	name = "\improper Bravo Squad Preparations"
	icon = 'icons/obj/structures/doors/2x1prepdoor_bravo.dmi'
	req_access = list(ACCESS_MARINE_PREP)
	req_one_access = list(ACCESS_MARINE_DATABASE, ACCESS_MARINE_CARGO, ACCESS_MARINE_BRAVO)

/obj/structure/machinery/door/airlock/multi_tile/almayer/marine/charlie
	name = "\improper Charlie Squad Preparations"
	icon = 'icons/obj/structures/doors/2x1prepdoor_charlie.dmi'
	req_access = list(ACCESS_MARINE_PREP)
	req_one_access = list(ACCESS_MARINE_DATABASE, ACCESS_MARINE_CARGO, ACCESS_MARINE_CHARLIE)

/obj/structure/machinery/door/airlock/multi_tile/almayer/marine/delta
	name = "\improper Delta Squad Preparations"
	icon = 'icons/obj/structures/doors/2x1prepdoor_delta.dmi'
	req_access = list(ACCESS_MARINE_PREP)
	req_one_access = list(ACCESS_MARINE_DATABASE, ACCESS_MARINE_CARGO, ACCESS_MARINE_DELTA)

/obj/structure/machinery/door/airlock/multi_tile/almayer/marine/shared
	name = "\improper Squads Preparations"
	icon = 'icons/obj/structures/doors/prepdoor.dmi'
	req_one_access = list(ACCESS_MARINE_PREP, ACCESS_MARINE_DATABASE, ACCESS_MARINE_CARGO, ACCESS_MARINE_ALPHA, ACCESS_MARINE_BRAVO, ACCESS_MARINE_CHARLIE, ACCESS_MARINE_DELTA)
	opacity = FALSE
	glass = 1

/obj/structure/machinery/door/airlock/multi_tile/almayer/marine/shared/alpha_bravo
	name = "\improper Alpha-Bravo Squads Preparations"
	icon = 'icons/obj/structures/doors/2x1prepdoor_alpha.dmi'
	req_one_access = list(ACCESS_MARINE_PREP, ACCESS_MARINE_DATABASE, ACCESS_MARINE_CARGO, ACCESS_MARINE_ALPHA, ACCESS_MARINE_BRAVO)

/obj/structure/machinery/door/airlock/multi_tile/almayer/marine/shared/alpha_bravo/yellow
	icon = 'icons/obj/structures/doors/2x1prepdoor_bravo.dmi'

/obj/structure/machinery/door/airlock/multi_tile/almayer/marine/shared/charlie_delta
	name = "\improper Charlie-Delta Squads Preparations"
	icon = 'icons/obj/structures/doors/2x1prepdoor_charlie.dmi'
	req_one_access = list(ACCESS_MARINE_PREP, ACCESS_MARINE_DATABASE, ACCESS_MARINE_CARGO, ACCESS_MARINE_CHARLIE, ACCESS_MARINE_DELTA)

/obj/structure/machinery/door/airlock/multi_tile/almayer/marine/shared/charlie_delta/blue
	icon = 'icons/obj/structures/doors/2x1prepdoor_delta.dmi'


/obj/structure/machinery/door/airlock/multi_tile/almayer/generic2
	name = "\improper Airlock"
	icon = 'icons/obj/structures/doors/2x1personaldoor.dmi'

/obj/structure/machinery/door/airlock/multi_tile/almayer/generic2/autoname
	autoname = TRUE

/obj/structure/machinery/door/airlock/multi_tile/almayer/generic2/glass
	name = "\improper Airlock"
	icon = 'icons/obj/structures/doors/2x1personaldoor_glass.dmi'
	opacity = FALSE
	glass = TRUE

/obj/structure/machinery/door/airlock/multi_tile/almayer/generic2/glass/autoname
	autoname = TRUE

/obj/structure/machinery/door/airlock/multi_tile/almayer/almayer
	name = "\improper Airlock"
	icon = 'icons/obj/structures/doors/2x1almayerdoor.dmi'

/obj/structure/machinery/door/airlock/multi_tile/almayer/almayer/glass
	icon = 'icons/obj/structures/doors/2x1almayerdoor_glass.dmi'
	opacity = FALSE
	glass = TRUE

