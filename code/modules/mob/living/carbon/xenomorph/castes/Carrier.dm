/datum/caste_datum/carrier
	caste_type = XENO_CASTE_CARRIER
	caste_desc = "A carrier of huggies."
	tier = 2

	melee_damage_lower = XENO_DAMAGE_TIER_2
	melee_damage_upper = XENO_DAMAGE_TIER_4
	melee_vehicle_damage = XENO_DAMAGE_TIER_3
	max_health = XENO_HEALTH_TIER_9
	plasma_gain = XENO_PLASMA_GAIN_TIER_6
	plasma_max = XENO_PLASMA_TIER_5
	xeno_explosion_resistance = XENO_EXPLOSIVE_ARMOR_TIER_2
	armor_deflection = XENO_NO_ARMOR
	evasion = XENO_EVASION_NONE
	speed = XENO_SPEED_TIER_4

	available_strains = list(/datum/xeno_strain/eggsac)
	behavior_delegate_type = /datum/behavior_delegate/carrier_base

	evolution_allowed = FALSE
	deevolves_to = list(XENO_CASTE_DRONE)
	throwspeed = SPEED_AVERAGE
	can_hold_facehuggers = 1
	can_hold_eggs = CAN_HOLD_ONE_HAND
	weed_level = WEED_LEVEL_STANDARD

	hugger_nurturing = TRUE
	huggers_max = 16
	eggs_max = 8

	tackle_min = 2
	tackle_max = 4
	tackle_chance = 50
	tacklestrength_min = 4
	tacklestrength_max = 5

	aura_strength = 2
	hugger_delay = 20
	egg_cooldown = 250

	minimum_evolve_time = 5 MINUTES

	minimap_icon = "carrier"

/mob/living/carbon/xenomorph/carrier
	caste_type = XENO_CASTE_CARRIER
	name = XENO_CASTE_CARRIER
	desc = "A strange-looking alien creature. It carries a number of scuttling jointed crablike creatures."
	icon_size = 64
	icon_xeno = 'icons/mob/xenos/castes/tier_2/carrier.dmi'
	icon_state = "Carrier Walking"
	plasma_types = list(PLASMA_PURPLE)

	drag_delay = 6 //pulling a big dead xeno is hard
	var/huggers_reserved = 0

	mob_size = MOB_SIZE_BIG
	tier = 2
	pixel_x = -16 //Needed for 2x2
	old_x = -16
	organ_value = 1000

	base_actions = list(
		/datum/action/xeno_action/onclick/xeno_resting,
		/datum/action/xeno_action/onclick/release_haul,
		/datum/action/xeno_action/watch_xeno,
		/datum/action/xeno_action/activable/tail_stab,
		/datum/action/xeno_action/activable/place_construction,
		/datum/action/xeno_action/onclick/emit_pheromones,
		/datum/action/xeno_action/onclick/plant_weeds, //1st macro
		/datum/action/xeno_action/onclick/place_trap, //2nd macro
		/datum/action/xeno_action/activable/throw_hugger, //3rd macro
		/datum/action/xeno_action/activable/retrieve_egg, //4th macro
		/datum/action/xeno_action/onclick/set_hugger_reserve,
		/datum/action/xeno_action/onclick/tacmap,
		)

	inherent_verbs = list(
		/mob/living/carbon/xenomorph/proc/rename_tunnel,
		/mob/living/carbon/xenomorph/proc/set_hugger_reserve_for_morpher,
	)

	icon_xenonid = 'icons/mob/xenonids/castes/tier_2/carrier.dmi'

	weed_food_icon = 'icons/mob/xenos/weeds_64x64.dmi'
	weed_food_states = list("Carrier_1","Carrier_2","Carrier_3")
	weed_food_states_flipped = list("Carrier_1","Carrier_2","Carrier_3")

	skull = /obj/item/skull/carrier
	pelt = /obj/item/pelt/carrier

	var/list/hugger_image_index = list()
	var/mutable_appearance/hugger_overlays_icon
	var/mutable_appearance/eggsac_overlays_icon

	//Carrier specific vars
	var/threw_a_hugger = 0
	var/huggers_cur = 0
	var/eggs_cur = 0
	var/huggers_max = 0
	var/eggs_max = 0
	var/laid_egg = 0

/mob/living/carbon/xenomorph/carrier/proc/update_hugger_overlays()
	if(!hugger_overlays_icon)
		return

	overlays -= hugger_overlays_icon
	hugger_overlays_icon.overlays.Cut()

	if(!huggers_cur)
		hugger_image_index.Cut()
		return

	update_clinger_maths(floor(( huggers_cur / huggers_max ) * 3.999) + 1)

	for(var/i in hugger_image_index)
		if(stat == DEAD)
			hugger_overlays_icon.overlays += icon(icon, "clinger_[i] Knocked Down")
		else if(body_position == LYING_DOWN)
			if(!HAS_TRAIT(src, TRAIT_INCAPACITATED) && !HAS_TRAIT(src, TRAIT_FLOORED))
				hugger_overlays_icon.overlays += icon(icon, "clinger_[i] Sleeping")
			else
				hugger_overlays_icon.overlays +=icon(icon, "clinger_[i] Knocked Down")
		else
			hugger_overlays_icon.overlays +=icon(icon, "clinger_[i]")

	overlays += hugger_overlays_icon

/mob/living/carbon/xenomorph/carrier/proc/update_clinger_maths(number)
	var/clinger_list = list(1,2,3,4)
	if(length(hugger_image_index) != number)
		if(length(hugger_image_index) > number)
			while(length(hugger_image_index) != number)
				hugger_image_index -= hugger_image_index[length(hugger_image_index)]
		else
			while(length(hugger_image_index) != number)
				for(var/i in hugger_image_index)
					if(locate(i) in clinger_list)
						clinger_list -= i
				hugger_image_index += clinger_list[rand(1,length(clinger_list))]

/mob/living/carbon/xenomorph/carrier/proc/update_eggsac_overlays()
	if(!eggsac_overlays_icon)
		return

	overlays -= eggsac_overlays_icon
	eggsac_overlays_icon.overlays.Cut()

	if(!eggs_cur)
		return

	///Simplified image index change.
	var/i = 0
	if(eggs_cur > 8)
		i = 3
	else if (eggs_cur > 4)
		i = 2
	else if (eggs_cur > 0)
		i = 1

	if(stat != DEAD)
		if(body_position == LYING_DOWN)
			if(!HAS_TRAIT(src, TRAIT_INCAPACITATED) && !HAS_TRAIT(src, TRAIT_FLOORED))
				eggsac_overlays_icon.overlays += icon(icon, "eggsac_[i] Sleeping")
			else
				eggsac_overlays_icon.overlays +=icon(icon, "eggsac_[i] Knocked Down")
		else
			eggsac_overlays_icon.overlays +=icon(icon, "eggsac_[i]")

	overlays += eggsac_overlays_icon

/mob/living/carbon/xenomorph/carrier/Initialize(mapload, mob/living/carbon/xenomorph/oldxeno, h_number)
	. = ..()
	hugger_overlays_icon = mutable_appearance('icons/mob/xenos/overlay_effects64x64.dmi',"empty")
	eggsac_overlays_icon = mutable_appearance('icons/mob/xenos/overlay_effects64x64.dmi',"empty")

/mob/living/carbon/xenomorph/carrier/death(cause, gibbed)
	. = ..(cause, gibbed)
	if(.)
		var/chance = 75 //75% to drop an egg or hugger.

		if(huggers_cur)
			//Hugger explosion, like an egg morpher
			var/obj/item/clothing/mask/facehugger/hugger
			visible_message(SPAN_XENOWARNING("The chittering mass of tiny aliens is trying to escape [src]!"))
			for(var/i in 1 to huggers_cur)
				if(prob(chance))
					hugger = new(loc, hivenumber)
					step_away(hugger, src, 1)

		var/eggs_dropped = FALSE
		for(var/i in 1 to eggs_cur)
			if(prob(chance))
				new /obj/item/xeno_egg(loc, hivenumber)
				eggs_dropped = TRUE
		eggs_cur = 0

		if(eggs_dropped) //Checks whether or not to announce egg drop.
			xeno_message(SPAN_XENOANNOUNCE("[src] has dropped some precious eggs!"), 2, hive.hivenumber)

/mob/living/carbon/xenomorph/carrier/recalculate_actions()
	. = ..()
	huggers_max = caste.huggers_max
	eggs_max = caste.eggs_max

/mob/living/carbon/xenomorph/carrier/get_status_tab_items()
	. = ..()
	if(huggers_max > 0)
		. += "Stored Huggers: [huggers_cur] / [huggers_max]"
	. += "Stored Eggs: [eggs_cur] / [eggs_max]"

/mob/living/carbon/xenomorph/carrier/proc/store_hugger(obj/item/clothing/mask/facehugger/F)
	if(F.hivenumber != hivenumber)
		to_chat(src, SPAN_WARNING("This hugger is tainted!"))
		return

	if(huggers_max > 0 && huggers_cur < huggers_max)
		if(F.stat != DEAD && !F.sterile)
			huggers_cur++
			to_chat(src, SPAN_NOTICE("We take a facehugger and carry it for safekeeping. Now sheltering: [huggers_cur] / [huggers_max]."))
			update_icons()
			qdel(F)
		else
			to_chat(src, SPAN_WARNING("This [F.name] looks too unhealthy."))
	else
		to_chat(src, SPAN_WARNING("We can't carry more facehuggers on us."))

/mob/living/carbon/xenomorph/carrier/proc/store_huggers_from_egg_morpher(obj/effect/alien/resin/special/eggmorph/morpher)
	if(morpher.linked_hive && (morpher.linked_hive.hivenumber != hivenumber))
		to_chat(src, SPAN_WARNING("That egg morpher is tainted!"))
		return

	if(morpher.stored_huggers == 0)
		to_chat(src, SPAN_WARNING("The egg morpher is empty!"))
		return

	if(huggers_max > 0 && huggers_cur < huggers_max)
		var/huggers_to_transfer = min(morpher.stored_huggers, huggers_max-huggers_cur)
		huggers_cur += huggers_to_transfer
		morpher.stored_huggers -= huggers_to_transfer
		if(huggers_to_transfer == 1)
			to_chat(src, SPAN_NOTICE("We take one facehugger and carry it for safekeeping. Now sheltering: [huggers_cur] / [huggers_max]."))
		else
			to_chat(src, SPAN_NOTICE("We take [huggers_to_transfer] facehuggers and carry them for safekeeping. Now sheltering: [huggers_cur] / [huggers_max]."))
		update_icons()
	else
		to_chat(src, SPAN_WARNING("We can't carry more facehuggers on you."))


/mob/living/carbon/xenomorph/carrier/proc/throw_hugger(atom/T)
	if(!T)
		return

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

	//target an egg morpher to top up on huggers
	if(istype(T, /obj/effect/alien/resin/special/eggmorph))
		var/obj/effect/alien/resin/special/eggmorph/morpher = T
		if(Adjacent(morpher))
			if(morpher.linked_hive && (morpher.linked_hive.hivenumber != hivenumber))
				to_chat(src, SPAN_WARNING("That egg morpher is tainted!"))
				return
			if(on_fire)
				to_chat(src, SPAN_WARNING("Touching \the [morpher] while you're on fire would burn the facehuggers in it!"))
				return
			store_huggers_from_egg_morpher(morpher)
			return

	var/obj/item/clothing/mask/facehugger/F = get_active_hand()
	if(!F) //empty active hand
		//if no hugger in active hand, we take one from our storage
		if(huggers_cur <= 0)
			to_chat(src, SPAN_WARNING("We don't have any facehuggers to use!"))
			return

		if(on_fire)
			to_chat(src, SPAN_WARNING("Retrieving a stored facehugger while we're on fire would burn it!"))
			return

		F = new(src, hivenumber)
		huggers_cur--
		put_in_active_hand(F)
		to_chat(src, SPAN_XENONOTICE("We grab one of the facehugger in our storage. Now sheltering: [huggers_cur] / [huggers_max]."))
		update_icons()
		return

	if(!istype(F)) //something else in our hand
		to_chat(src, SPAN_WARNING("We need a facehugger in our hand to throw one!"))
		return

	if(!threw_a_hugger)
		threw_a_hugger = TRUE
		for(var/X in actions)
			var/datum/action/A = X
			A.update_button_icon()
		drop_inv_item_on_ground(F)
		F.throw_atom(T, 4, caste.throwspeed)
		visible_message(SPAN_XENOWARNING("\The [src] throws something towards \the [T]!"),
			SPAN_XENOWARNING("We throw a facehugger towards \the [T]!"))
		spawn(caste.hugger_delay)
			threw_a_hugger = 0
			for(var/X in actions)
				var/datum/action/A = X
				A.update_button_icon()

/mob/living/carbon/xenomorph/carrier/proc/store_egg(obj/item/xeno_egg/E)
	if(E.hivenumber != hivenumber)
		to_chat(src, SPAN_WARNING("That egg is tainted!"))
		return
	if(eggs_cur < eggs_max)
		if(stat == CONSCIOUS)
			eggs_cur++
			update_icons()
			to_chat(src, SPAN_NOTICE("We store the egg and carry it for safekeeping. Now sheltering: [eggs_cur] / [eggs_max]."))
			qdel(E)
		else
			to_chat(src, SPAN_WARNING("This [E.name] looks too unhealthy."))
	else
		to_chat(src, SPAN_WARNING("We can't carry more eggs on ourselves."))

/mob/living/carbon/xenomorph/carrier/proc/retrieve_egg(atom/T)
	if(!T)
		return

	if(!check_state())
		return

	//target a hugger on the ground to store it directly
	if(istype(T, /obj/item/xeno_egg))
		var/obj/item/xeno_egg/E = T
		if(isturf(E.loc) && Adjacent(E))
			var/turf/egg_turf = E.loc
			store_egg(E)
			//Grab all the eggs from the turf
			if(eggs_cur < eggs_max)
				for(E in egg_turf)
					if(eggs_cur < eggs_max)
						store_egg(E)
			return

	if(istype(T, /obj/effect/alien/resin/special/eggmorph))
		store_eggs_into_egg_morpher(T)
		return

	var/obj/item/xeno_egg/E = get_active_hand()
	if(!E) //empty active hand
		//if no hugger in active hand, we take one from our storage
		if(eggs_cur <= 0)
			to_chat(src, SPAN_WARNING("We don't have any eggs to use!"))
			return
		E = new(src, hivenumber)
		eggs_cur--
		update_icons()
		put_in_active_hand(E)
		to_chat(src, SPAN_XENONOTICE("We grab one of the eggs in our storage. Now sheltering: [eggs_cur] / [eggs_max]."))
		return

	if(!istype(E)) //something else in our hand
		to_chat(src, SPAN_WARNING("We need an empty hand to grab one of our stored eggs!"))
		return

/mob/living/carbon/xenomorph/carrier/proc/store_eggs_into_egg_morpher(obj/effect/alien/resin/special/eggmorph/morpher)

	var/dist = get_dist(src, morpher)

	if(dist > 1)
		to_chat(src, SPAN_XENOWARNING("We need to be closer to do that."))
		return

	if(action_busy)
		return FALSE

	if(!morpher_safety_checks(morpher))
		return

	visible_message(SPAN_XENOWARNING("[src] starts placing facehuggers into [morpher] from their eggs..."), SPAN_XENONOTICE("We start placing children into [morpher] from our eggs..."))
	while(eggs_cur > 0)
		if(!morpher_safety_checks(morpher))
			return

		if(!do_after(src, 0.75 SECONDS, INTERRUPT_ALL, BUSY_ICON_GENERIC))
			to_chat(src, SPAN_WARNING("We stop filling [morpher] with our children."))
			return

		playsound(src.loc, "sound/effects/alien_egg_move.ogg", 20, TRUE)
		morpher.stored_huggers = min(morpher.huggers_max_amount, morpher.stored_huggers + 1)
		eggs_cur--
		to_chat(src, SPAN_XENONOTICE("We slide one of the children out of an egg and place them into [morpher]. Now sheltering: [eggs_cur] / [eggs_max]."))

/mob/living/carbon/xenomorph/carrier/proc/morpher_safety_checks(obj/effect/alien/resin/special/eggmorph/morpher)
	if(morpher.linked_hive && (morpher.linked_hive.hivenumber != hivenumber))
		to_chat(src, SPAN_WARNING("That egg morpher is tainted!"))
		return FALSE

	if(morpher.stored_huggers == morpher.huggers_max_amount)
		to_chat(src, SPAN_WARNING("[morpher] is full of children!"))
		return FALSE

	if(eggs_cur < 1)
		to_chat(src, SPAN_WARNING("We don't have any eggs left!"))
		return FALSE

	return TRUE

/mob/living/carbon/xenomorph/carrier/attack_ghost(mob/dead/observer/user)
	. = ..() //Do a view printout as needed just in case the observer doesn't want to join as a Hugger but wants info
	join_as_facehugger_from_this(user)

/mob/living/carbon/xenomorph/carrier/proc/join_as_facehugger_from_this(mob/dead/observer/user)
	if(!huggers_max) //Eggsac doesn't have huggers, do nothing!
		return
	if(stat == DEAD)
		to_chat(user, SPAN_WARNING("\The [src] is dead and all their huggers died with it."))
		return
	if(!huggers_cur)
		to_chat(user, SPAN_WARNING("\The [src] doesn't have any facehuggers to inhabit."))
		return
	if(huggers_cur <= huggers_reserved)
		to_chat(user, SPAN_WARNING("\The [src] has reserved the remaining facehuggers for themselves."))
		return
	if(!GLOB.hive_datum[hivenumber].can_spawn_as_hugger(user))
		return
	//Need to check again because time passed due to the confirmation window
	if(!huggers_cur)
		to_chat(user, SPAN_WARNING("\The [src] doesn't have any facehuggers to inhabit."))
		return
	GLOB.hive_datum[hivenumber].spawn_as_hugger(user, src)
	huggers_cur--

/datum/behavior_delegate/carrier_base
	name = "Base Carrier Behavior Delegate"

/datum/behavior_delegate/carrier_base/on_update_icons()
	var/mob/living/carbon/xenomorph/carrier/bound_carrier = bound_xeno
	bound_carrier.update_hugger_overlays()

/datum/action/xeno_action/activable/throw_hugger/use_ability(atom/target)
	var/mob/living/carbon/xenomorph/carrier/carrier_owner = owner
	carrier_owner.throw_hugger(target)
	return ..()

/datum/action/xeno_action/activable/retrieve_egg/use_ability(atom/target)
	var/mob/living/carbon/xenomorph/carrier/carrier_owner = owner
	carrier_owner.retrieve_egg(target)
	return ..()

/datum/action/xeno_action/onclick/set_hugger_reserve/use_ability(atom/Atom)
	var/mob/living/carbon/xenomorph/carrier/carrier = owner
	carrier.huggers_reserved = tgui_input_number(usr,
		"How many facehuggers would you like to keep safe from Observers wanting to join as facehuggers?",
		"How many to reserve?",
		carrier.huggers_reserved, carrier.huggers_max, 0
	)
	to_chat(carrier, SPAN_XENONOTICE("We reserve [carrier.huggers_reserved] facehuggers for ourself."))
	return ..()
