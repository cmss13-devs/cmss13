/datum/caste_datum/carrier
	caste_name = "Carrier"
	caste_desc = "A carrier of huggies."
	tier = 2

	melee_damage_lower = XENO_DAMAGE_TIER_2
	melee_damage_upper = XENO_DAMAGE_TIER_4
	max_health = XENO_HEALTH_TIER_8
	plasma_gain = XENO_PLASMA_GAIN_TIER_6
	plasma_max = XENO_PLASMA_TIER_4
	crystal_max = XENO_CRYSTAL_LOW
	xeno_explosion_resistance = XENO_EXPLOSIVE_ARMOR_TIER_1
	armor_deflection = XENO_ARMOR_TIER_1
	armor_hardiness_mult = XENO_ARMOR_FACTOR_MEDIUM
	evasion = XENO_EVASION_NONE
	speed = XENO_SPEED_TIER_4

	evolution_allowed = FALSE
	deevolves_to = "Drone"
	aura_strength = 1 //Carrier's pheromones are equivalent to Hivelord. Climbs 0.5 up to 2.5
	eggs_max = 5
	throwspeed = 1
	can_hold_facehuggers = 1
	can_hold_eggs = CAN_HOLD_ONE_HAND
	weed_level = WEED_LEVEL_STANDARD
	huggers_max = 16
	eggs_max = 7
	
	tackle_min = 2
	tackle_max = 4
	tackle_chance = 50
	tacklestrength_min = 4
	tacklestrength_max = 5

	aura_strength = 2
	hugger_delay = 20
	egg_cooldown = 250

/mob/living/carbon/Xenomorph/Carrier
	caste_name = "Carrier"
	name = "Carrier"
	desc = "A strange-looking alien creature. It carries a number of scuttling jointed crablike creatures."
	icon_source = "alien_carrier"
	icon_size = 64
	icon_state = "Carrier Walking"
	plasma_types = list(PLASMA_PURPLE)

	drag_delay = 6 //pulling a big dead xeno is hard

	mob_size = MOB_SIZE_BIG
	tier = 2
	pixel_x = -16 //Needed for 2x2
	old_x = -16

	actions = list(
		/datum/action/xeno_action/onclick/xeno_resting,
		/datum/action/xeno_action/onclick/regurgitate,
		/datum/action/xeno_action/watch_xeno,
		/datum/action/xeno_action/onclick/plant_weeds,
		/datum/action/xeno_action/activable/place_construction,
		/datum/action/xeno_action/onclick/emit_pheromones,
		/datum/action/xeno_action/activable/throw_hugger,
		/datum/action/xeno_action/activable/retrieve_egg,
		/datum/action/xeno_action/onclick/place_trap
		)
	mutation_type = CARRIER_NORMAL


/mob/living/carbon/Xenomorph/Carrier/death(var/cause, var/gibbed)
	. = ..(cause, gibbed)
	if(.)
		var/chance = 75

		while (eggs_cur > 0)
			if(prob(chance))
				new /obj/item/xeno_egg(loc, hivenumber)
				eggs_cur--
		if (huggers_cur)
			visible_message(SPAN_XENOWARNING("The chittering mass of tiny aliens is trying to escape [src]!"))
			for(var/i in 0 to huggers_cur)
				if(prob(chance))
					var/obj/item/clothing/mask/facehugger/F = new(loc, hivenumber)
					step_away(F,src,1)
					addtimer(CALLBACK(F, /obj/item/clothing/mask/facehugger/.proc/leap_at_nearest_target), SECONDS_3)


/mob/living/carbon/Xenomorph/Carrier/Stat()
	if (!..())
		return 0
	if(huggers_max > 0)
		stat("Stored Huggers:", "[huggers_cur] / [huggers_max]")
	stat("Stored Eggs:", "[eggs_cur] / [eggs_max]")
	return 1

/mob/living/carbon/Xenomorph/Carrier/proc/store_hugger(obj/item/clothing/mask/facehugger/F)
	if(F.hivenumber != hivenumber)
		to_chat(src, SPAN_WARNING("This hugger is tainted!"))
		return

	if(huggers_max > 0 && huggers_cur < huggers_max)
		if(F.stat != DEAD && !F.sterile)
			huggers_cur++
			to_chat(src, SPAN_NOTICE("You store the facehugger and carry it for safekeeping. Now sheltering: [huggers_cur] / [huggers_max]."))
			qdel(F)
		else
			to_chat(src, SPAN_WARNING("This [F.name] looks too unhealthy."))
	else
		to_chat(src, SPAN_WARNING("You can't carry more facehuggers on you."))


/mob/living/carbon/Xenomorph/Carrier/proc/throw_hugger(atom/T)
	if(!T) return

	if(!check_state())
		return

	//target a hugger on the ground to store it directly
	if(istype(T, /obj/item/clothing/mask/facehugger))
		var/obj/item/clothing/mask/facehugger/F = T
		if(isturf(F.loc) && Adjacent(F))
			if(F.hivenumber != hivenumber)
				to_chat(src, SPAN_WARNING("That facehugger is tainted!"))
				drop_inv_item_on_ground(F)
				return
			if(on_fire)
				to_chat(src, SPAN_WARNING("Touching \the [F] while you're on fire would burn it!"))
				return
			store_hugger(F)
			return

	var/obj/item/clothing/mask/facehugger/F = get_active_hand()
	if(!F) //empty active hand
		//if no hugger in active hand, we take one from our storage
		if(huggers_cur <= 0)
			to_chat(src, SPAN_WARNING("You don't have any facehuggers to use!"))
			return

		if(on_fire)
			to_chat(src, SPAN_WARNING("Retrieving a stored facehugger while you're on fire would burn it!"))
			return

		F = new(src, hivenumber)
		huggers_cur--
		put_in_active_hand(F)
		to_chat(src, SPAN_XENONOTICE("You grab one of the facehugger in your storage. Now sheltering: [huggers_cur] / [huggers_max]."))
		return

	if(!istype(F)) //something else in our hand
		to_chat(src, SPAN_WARNING("You need a facehugger in your hand to throw one!"))
		return

	if(!threw_a_hugger)
		threw_a_hugger = TRUE
		for(var/X in actions)
			var/datum/action/A = X
			A.update_button_icon()
		drop_inv_item_on_ground(F)
		F.throw_atom(T, 4, caste.throwspeed)
		visible_message(SPAN_XENOWARNING("\The [src] throws something towards \the [T]!"), \
			SPAN_XENOWARNING("You throw a facehugger towards \the [T]!"))
		spawn(caste.hugger_delay)
			threw_a_hugger = 0
			for(var/X in actions)
				var/datum/action/A = X
				A.update_button_icon()



/mob/living/carbon/Xenomorph/Carrier/proc/store_egg(obj/item/xeno_egg/E)
	if(E.hivenumber != hivenumber)
		to_chat(src, SPAN_WARNING("That egg is tainted!"))
		return
	if(eggs_cur < eggs_max)
		if(stat == CONSCIOUS)
			eggs_cur++
			to_chat(src, SPAN_NOTICE("You store the egg and carry it for safekeeping. Now sheltering: [eggs_cur] / [eggs_max]."))
			qdel(E)
		else
			to_chat(src, SPAN_WARNING("This [E.name] looks too unhealthy."))
	else
		to_chat(src, SPAN_WARNING("You can't carry more eggs on you."))


/mob/living/carbon/Xenomorph/Carrier/proc/retrieve_egg(atom/T)
	if(!T) return

	if(!check_state())
		return

	//target a hugger on the ground to store it directly
	if(istype(T, /obj/item/xeno_egg))
		var/obj/item/xeno_egg/E = T
		if(isturf(E.loc) && Adjacent(E))
			store_egg(E)
			return

	var/obj/item/xeno_egg/E = get_active_hand()
	if(!E) //empty active hand
		//if no hugger in active hand, we take one from our storage
		if(eggs_cur <= 0)
			to_chat(src, SPAN_WARNING("You don't have any egg to use!"))
			return
		E = new(src, hivenumber)
		eggs_cur--
		put_in_active_hand(E)
		to_chat(src, SPAN_XENONOTICE("You grab one of the eggs in your storage. Now sheltering: [eggs_cur] / [eggs_max]."))
		return

	if(!istype(E)) //something else in our hand
		to_chat(src, SPAN_WARNING("You need an empty hand to grab one of your stored eggs!"))
		return
