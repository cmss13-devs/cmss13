
/obj/item/xeno_egg
	name = "egg"
	desc = "Some sort of egg."
	icon = 'icons/mob/xenos/Effects.dmi'
	icon_state = "egg_item"
	w_class = SIZE_MASSIVE
	flags_atom = OPENCONTAINER
	flags_item = NOBLUDGEON
	throw_range = 1
	layer = MOB_LAYER
	var/hivenumber = XENO_HIVE_NORMAL

/obj/item/xeno_egg/New()
	pixel_x = rand(-3,3)
	pixel_y = rand(-3,3)
	create_reagents(60)
	reagents.add_reagent("eggplasma",60)
	..()


/obj/item/xeno_egg/examine(mob/user)
	..()
	if(isXeno(user))
		to_chat(user, "A queen egg, it needs to be planted on weeds to start growing.")
		if(hivenumber == XENO_HIVE_CORRUPTED)
			to_chat(user, "This one appears to have been laid by a corrupted Queen.")

/obj/item/xeno_egg/afterattack(atom/target, mob/user, proximity)
	if(isXeno(user))
		var/turf/T = get_turf(target)
		plant_egg(user, T, proximity)
	if(proximity && ishuman(user))
		var/turf/T = get_turf(target)
		plant_egg_in_containment(user, T)

/obj/item/xeno_egg/proc/plant_egg_in_containment(mob/living/carbon/human/user, turf/T)
	if(!istype(T, /turf/open/floor/almayer/research/containment))
		to_chat(user, SPAN_WARNING("Best not to plant this thing outside of a containment cell."))
		return
	for (var/obj/O in T)
		if (!istype(O,/obj/structure/machinery/light/small))
			to_chat(user, SPAN_WARNING("The floor needs to be clear to plant this!"))
			return
	user.visible_message(SPAN_NOTICE("[user] starts planting [src]."), \
					SPAN_NOTICE("You start planting [src]."), null, 5)
	if(!do_after(user, 50, INTERRUPT_ALL|BEHAVIOR_IMMOBILE, BUSY_ICON_BUILD))
		return
	for (var/obj/O in T)
		if (!istype(O,/obj/structure/machinery/light/small))
			return
	var/obj/effect/alien/egg/newegg = new /obj/effect/alien/egg(T)
	newegg.add_hiddenprint(user)
	newegg.hivenumber = hivenumber
	playsound(T, 'sound/effects/splat.ogg', 15, 1)
	qdel(src)

/obj/item/xeno_egg/proc/plant_egg(mob/living/carbon/Xenomorph/user, turf/T, proximity = TRUE)
	if(!proximity)
		return // no message because usual behavior is not to show any
	if(!user.hive)
		to_chat(user, SPAN_XENOWARNING("Your hive cannot procreate."))
		return
	if(!user.check_alien_construction(T))
		return
	if(!user.check_plasma(30))
		return

	var/found_hive_weeds = FALSE
	for(var/obj/effect/alien/weeds/W in T)
		if(W.weed_strength >= WEED_LEVEL_HIVE)
			found_hive_weeds = TRUE
			break

	if(!found_hive_weeds)
		to_chat(user, SPAN_XENOWARNING("[src] can only be planted on hive weeds."))
		return

	user.visible_message(SPAN_XENONOTICE("[user] starts planting [src]."), SPAN_XENONOTICE("You start planting [src]."), null, 5)

	var/plant_time = 35
	if(isXenoDrone(user))
		plant_time = 25
	if(isXenoCarrier(user))
		plant_time = 10
	if(!do_after(user, plant_time, INTERRUPT_ALL|BEHAVIOR_IMMOBILE, BUSY_ICON_BUILD))
		return
	if(!user.check_alien_construction(T))
		return
	if(!user.check_plasma(30))
		return

	for(var/obj/effect/alien/weeds/W in T)
		if(W.weed_strength >= WEED_LEVEL_HIVE)
			user.use_plasma(30)
			var/obj/effect/alien/egg/newegg = new /obj/effect/alien/egg(T)
			newegg.add_hiddenprint(user)
			newegg.hivenumber = hivenumber
			playsound(T, 'sound/effects/splat.ogg', 15, 1)
			qdel(src)
			break

/obj/item/xeno_egg/attack_self(mob/user)
	if(isXeno(user))
		var/mob/living/carbon/Xenomorph/X = user
		if(isXenoCarrier(X))
			var/mob/living/carbon/Xenomorph/Carrier/C = X
			C.store_egg(src)
		else
			var/turf/T = get_turf(user)
			plant_egg(user, T)



//Deal with picking up facehuggers. "attack_alien" is the universal 'xenos click something while unarmed' proc.
/obj/item/xeno_egg/attack_alien(mob/living/carbon/Xenomorph/user)
	if(user.caste.can_hold_eggs == CAN_HOLD_ONE_HAND)
		attack_hand(user)
	if(user.caste.can_hold_eggs == CAN_HOLD_TWO_HANDS)
		if(user.r_hand || user.l_hand)
			to_chat(user, SPAN_XENOWARNING("You need two hands to hold [src]."))
		else
			attack_hand(user)

/obj/item/xeno_egg/fire_act(exposed_temperature, exposed_volume)
	if(exposed_temperature > 300)
		qdel(src)

/obj/item/xeno_egg/flamer_fire_act()
	qdel(src)
