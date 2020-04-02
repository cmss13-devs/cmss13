//Hive Pylon - Remote building location for other structures, generates strong weeds

/obj/effect/alien/resin/special/pylon
	name = XENO_STRUCTURE_PYLON
	desc = "A towering spike of resin. Its base pulsates with large tendrils."
	icon_state = "pylon"
	health = 1200
	luminosity = 2
	var/cover_range = WEED_RANGE_PYLON
	var/ceiling_buff_amount = CEILING_RESIN
	var/node_type = /obj/effect/alien/weeds/node/pylon

/obj/effect/alien/resin/special/pylon/New(loc, var/hive_ref)
	replace_node()
	var/area/A = get_area(loc)
	A.ceiling = CEILING_RESIN
	..(loc, hive_ref)

/obj/effect/alien/resin/special/pylon/Dispose()
	var/area/A = get_area(loc)
	var/obj/effect/alien/resin/special/pylon/P = locate() in A
	if(!P)
		A.ceiling = initial(A.ceiling)
	var/obj/effect/alien/weeds/node/pylon/W = locate() in loc
	if(W)
		qdel(W)
	. = ..()

/obj/effect/alien/resin/special/pylon/examine(mob/user)
	..()
	if((isXeno(user) || isobserver(user)) && linked_hive)
		var/message = "There is [linked_hive.crystal_stored] plasma in the stockpile."
		to_chat(user, message)

/obj/effect/alien/resin/special/pylon/proc/replace_node()
	var/obj/effect/alien/weeds/node/pylon/W = locate() in loc
	if(W)
		return
	new node_type(loc)

/obj/effect/alien/resin/special/pylon/attack_alien(mob/living/carbon/Xenomorph/M)
	if(!linked_hive || !M.crystal_max || M.a_intent == HARM_INTENT)
		return ..()

	//deposit resources
	if(M.a_intent == HELP_INTENT && M.crystal_stored)
		var/amount = input("How much [MATERIAL_CRYSTAL] do you wish to deposit? ([M.crystal_stored] stored)") as null|num
		if(!amount || amount <= 0)
			return
		amount = Clamp(amount, 1, M.crystal_stored)
		linked_hive.crystal_stored += amount
		M.crystal_stored -= amount
		playsound(src, 'sound/effects/alien_resin_build2.ogg', 25, 1)
		visible_message(SPAN_XENOWARNING("\The [M] deposits a stack of [MATERIAL_CRYSTAL] into \the [src]."), \
			SPAN_XENONOTICE("You collect a deposits of [amount] [MATERIAL_CRYSTAL] into \the [src]."))
		return

	//collect resources
	if(!linked_hive.crystal_stored)
		to_chat(M, SPAN_XENOWARNING("There is no stored plasma!"))
		return
	var/amount = input("How much [MATERIAL_CRYSTAL] do you wish to collect? ([linked_hive.crystal_stored] stored)") as null|num
	if(!amount || amount <= 0)
		return
	amount = Clamp(amount, 1, min((M.crystal_max - M.crystal_stored), linked_hive.crystal_stored))
	linked_hive.crystal_stored -= amount
	M.crystal_stored += amount
	playsound(src, 'sound/effects/alien_resin_build1.ogg', 25, 1)
	visible_message(SPAN_XENOWARNING("\The [M] collects a stack of [MATERIAL_CRYSTAL] from \the [src]."), \
		SPAN_XENONOTICE("You collect a stack of [amount] [MATERIAL_CRYSTAL] from \the [src]."))

//Hive Core - Stockpiles materials, generates strong weeds, supports other buildings
/obj/effect/alien/resin/special/pylon/core
	name = XENO_STRUCTURE_CORE
	desc = "A giant pulsating mound of mass. It looks very much alive."
	icon_state = "core"
	health = 1500
	luminosity = 4
	cover_range = WEED_RANGE_CORE
	node_type = /obj/effect/alien/weeds/node/pylon/core

/obj/effect/alien/resin/special/pylon/core/New(loc, var/datum/hive_status/hive_ref)
	..(loc, hive_ref)

	// Pick the closest xeno resource activator
	var/obj/effect/landmark/resource_node_activator/hive/start_activator
	for(var/obj/effect/landmark/resource_node_activator/hive/node_activator in world)
		if(!start_activator || get_dist(src, node_activator) < get_dist(src, start_activator))
			start_activator = node_activator

	// And grow the crystals tied to it
	if(start_activator)
		start_activator.trigger()

	if(hive_ref)
		hive_ref.set_hive_location(src, linked_hive.hivenumber)

/obj/effect/alien/resin/special/pylon/core/Dispose()
	if(linked_hive)
		linked_hive.hive_location = null

	. = ..()