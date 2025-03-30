
/obj/item/xeno_egg
	name = "egg"
	desc = "Some sort of egg."
	icon = 'icons/mob/xenos/effects.dmi'
	item_icons = list(
		WEAR_L_HAND = 'icons/mob/humans/onmob/inhands/items/xeno_items_lefthand.dmi',
		WEAR_R_HAND = 'icons/mob/humans/onmob/inhands/items/xeno_items_righthand.dmi',
	)
	icon_state = "egg_item"
	item_state = "xeno_egg"
	w_class = SIZE_MASSIVE
	flags_atom = FPRINT|OPENCONTAINER
	flags_item = NOBLUDGEON
	throw_range = 1
	layer = MOB_LAYER
	black_market_value = 35
	var/hivenumber = XENO_HIVE_NORMAL
	var/flags_embryo = NO_FLAGS
	///The objects in this list will be skipped when checking for obstrucing objects.
	var/static/list/object_whitelist = list(/obj/structure/machinery/light, /obj/structure/machinery/light_construct)

/obj/item/xeno_egg/Initialize(mapload, hive)
	pixel_x = rand(-3,3)
	pixel_y = rand(-3,3)
	create_reagents(60)
	reagents.add_reagent(PLASMA_EGG, 60, list("hive_number" = hivenumber))

	if (hive)
		hivenumber = hive

	set_hive_data(src, hivenumber)
	. = ..()

	if(hivenumber == XENO_HIVE_NORMAL)
		RegisterSignal(SSdcs, COMSIG_GLOB_GROUNDSIDE_FORSAKEN_HANDLING, PROC_REF(forsaken_handling))

/obj/item/xeno_egg/proc/forsaken_handling()
	SIGNAL_HANDLER
	if(is_ground_level(z))
		hivenumber = XENO_HIVE_FORSAKEN
		set_hive_data(src, XENO_HIVE_FORSAKEN)

	UnregisterSignal(SSdcs, COMSIG_GLOB_GROUNDSIDE_FORSAKEN_HANDLING)

/obj/item/xeno_egg/get_examine_text(mob/user)
	. = ..()
	if(isxeno(user))
		. += "A queen egg, it needs to be planted on weeds to start growing."
		if(hivenumber != XENO_HIVE_NORMAL)
			var/datum/hive_status/hive = GLOB.hive_datum[hivenumber]
			. += "This one appears to belong to the [hive.name]"

/obj/item/xeno_egg/afterattack(atom/target, mob/user, proximity)
	if(istype(target, /obj/effect/alien/resin/special/eggmorph))
		return //We tried storing the hugger from the egg, no need to try to plant it (we know the turf is occupied!)
	if(isxeno(user))
		var/mob/living/carbon/xenomorph/xeno = user
		var/turf/T = get_turf(target)
		if(get_dist(xeno, T) <= xeno.egg_planting_range)
			proximity = TRUE
		plant_egg(xeno, T, proximity)
	if(proximity && ishuman(user))
		var/turf/T = get_turf(target)
		plant_egg_human(user, T)

/obj/item/xeno_egg/proc/plant_egg_human(mob/living/carbon/human/user, turf/T)
	if(user.hivenumber != hivenumber)
		if(!istype(T, /turf/open/floor/almayer/research/containment))
			to_chat(user, SPAN_WARNING("Best not to plant this thing outside of a containment cell."))
			return
		for (var/obj/O in T)
			if (!istype(O, /obj/structure/machinery/light))
				to_chat(user, SPAN_WARNING("The floor needs to be clear to plant this!"))
				return

	user.visible_message(SPAN_NOTICE("[user] starts planting [src]."),
					SPAN_NOTICE("You start planting [src]."), null, 5)
	if(!do_after(user, 50, INTERRUPT_ALL|BEHAVIOR_IMMOBILE, BUSY_ICON_BUILD))
		return

	if(user.hivenumber != hivenumber)
		for (var/obj/O in T)
			if (!istype(O, /obj/structure/machinery/light))
				return

	var/obj/effect/alien/egg/newegg = new /obj/effect/alien/egg(T, hivenumber)
	newegg.flags_embryo = flags_embryo

	newegg.add_hiddenprint(user)
	playsound(T, 'sound/effects/splat.ogg', 15, 1)
	qdel(src)

/obj/item/xeno_egg/proc/plant_egg(mob/living/carbon/xenomorph/user, turf/T, proximity = TRUE)
	if(!proximity)
		return // no message because usual behavior is not to show any
	if(!user.hive)
		to_chat(user, SPAN_XENOWARNING("Your hive cannot procreate."))
		return
	if(!user.check_alien_construction(T, ignore_nest = TRUE))
		return
	if(!user.check_plasma(30))
		return

	var/obj/effect/alien/weeds/hive_weeds
	var/obj/effect/alien/weeds/any_weeds
	for(var/obj/effect/alien/weeds/weed in T)
		if(weed.weed_strength >= WEED_LEVEL_HIVE && weed.linked_hive.hivenumber == hivenumber)
			hive_weeds = weed
			break
		if(weed.weed_strength >= WEED_LEVEL_WEAK && weed.linked_hive.hivenumber == hivenumber) //check for ANY weeds
			any_weeds = weed

	// If the user isn't an eggsac carrier, then they can only  plant eggs on hive weeds.
	var/needs_hive_weeds = !istype(user.strain, /datum/xeno_strain/eggsac)

	var/datum/hive_status/hive = GLOB.hive_datum[hivenumber]
	if(!any_weeds && !hive_weeds) //you need at least some weeds to plant on.
		to_chat(user, SPAN_XENOWARNING("[src] must be planted on [lowertext(hive.prefix)]weeds."))
		return

	if(!hive_weeds && needs_hive_weeds)
		to_chat(user, SPAN_XENOWARNING("[src] can only be planted on [lowertext(hive.prefix)]hive weeds."))
		return

	if(istype(get_area(T), /area/interior))
		to_chat(user, SPAN_XENOWARNING("[src] cannot be planted inside a vehicle."))
		return

	for(var/obj/object in T.contents)
		if(is_type_in_list(object, object_whitelist))
			continue
		var/obj/effect/alien/egg/xeno_egg = /obj/effect/alien/egg
		if(object.layer > initial(xeno_egg.layer))
			to_chat(user, SPAN_XENOWARNING("[src] cannot be planted below objects that would obscure it."))
			return

	user.visible_message(SPAN_XENONOTICE("[user] starts planting [src]."), SPAN_XENONOTICE("You start planting [src]."), null, 5)

	var/plant_time = 35
	if(isdrone(user))
		plant_time = 25
	else if(iscarrier(user))
		plant_time = 10

	if(!do_after(user, plant_time, INTERRUPT_ALL|BEHAVIOR_IMMOBILE, BUSY_ICON_BUILD))
		return
	if(!user.check_alien_construction(T, ignore_nest = TRUE))
		return
	if(!user.check_plasma(30))
		return

	for(var/obj/effect/alien/weeds/weed in T)
		if(weed.weed_strength >= WEED_LEVEL_HIVE || !needs_hive_weeds)
			user.use_plasma(30)
			var/obj/effect/alien/egg/newegg
			if(weed.weed_strength >= WEED_LEVEL_HIVE)
				newegg = new /obj/effect/alien/egg(T, hivenumber)
			else if(weed.weed_strength >= WEED_LEVEL_STANDARD)
				newegg = new /obj/effect/alien/egg/carrier_egg(T,hivenumber, user)
			else
				to_chat(user, SPAN_XENOWARNING("[src] can't be planted on these weeds."))
				return

			newegg.flags_embryo = flags_embryo

			newegg.add_hiddenprint(user)
			playsound(T, 'sound/effects/splat.ogg', 15, 1)
			qdel(src)
			break

/obj/item/xeno_egg/attack_self(mob/user)
	..()

	if(!isxeno(user))
		return

	var/mob/living/carbon/xenomorph/X = user
	if(iscarrier(X))
		var/mob/living/carbon/xenomorph/carrier/C = X
		C.store_egg(src)
	else
		var/turf/T = get_turf(user)
		plant_egg(user, T)



//Deal with picking up facehuggers. "attack_alien" is the universal 'xenos click something while unarmed' proc.
/obj/item/xeno_egg/attack_alien(mob/living/carbon/xenomorph/user)
	if(user.caste.can_hold_eggs == CAN_HOLD_ONE_HAND)
		attack_hand(user)
		return XENO_NO_DELAY_ACTION
	if(user.caste.can_hold_eggs == CAN_HOLD_TWO_HANDS)
		if(user.r_hand || user.l_hand)
			to_chat(user, SPAN_XENOWARNING("You need two hands to hold [src]."))
		else
			attack_hand(user)
		return XENO_NO_DELAY_ACTION

/obj/item/xeno_egg/fire_act(exposed_temperature, exposed_volume)
	if(exposed_temperature > 300)
		qdel(src)

/obj/item/xeno_egg/flamer_fire_act()
	qdel(src)

/obj/item/xeno_egg/alpha
	color = "#ff4040"
	hivenumber = XENO_HIVE_ALPHA

/obj/item/xeno_egg/forsaken
	color = "#cc8ec4"
	hivenumber = XENO_HIVE_FORSAKEN
