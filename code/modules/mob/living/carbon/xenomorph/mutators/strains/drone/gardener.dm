/datum/xeno_mutator/gardener
	name = "STRAIN: Drone - Gardener"
	description = "You trade most of your abilities aside from pheromones and planting weeds to gain the abilities to plant potent resin fruits for your sisters."
	cost = MUTATOR_COST_EXPENSIVE
	individual_only = TRUE
	caste_whitelist = list("Drone") //Only drone.
	mutator_actions_to_remove = list(
		/datum/action/xeno_action/activable/secrete_resin,
		/datum/action/xeno_action/onclick/choose_resin,
		/datum/action/xeno_action/activable/corrosive_acid/weak,
		/datum/action/xeno_action/activable/transfer_plasma,
		/datum/action/xeno_action/activable/place_construction,
	)
	mutator_actions_to_add = list(
		/datum/action/xeno_action/activable/resin_surge, //second macro
		/datum/action/xeno_action/onclick/plant_resin_fruit/greater, //third macro
		/datum/action/xeno_action/onclick/change_fruit //fourth macro
		)
	keystone = TRUE

/datum/xeno_mutator/gardener/apply_mutator(datum/mutator_set/individual_mutators/MS)
	. = ..()
	if (. == 0)
		return

	var/mob/living/carbon/Xenomorph/Drone/D = MS.xeno
	D.mutation_type = DRONE_GARDENER
	D.max_placeable = 3
	mutator_update_actions(D)
	MS.recalculate_actions(description, flavor_description)
	D.regeneration_multiplier = XENO_REGEN_MULTIPLIER_TIER_1
	D.available_placeable = list("Greater Resin Fruit", "Unstable Resin Fruit", "Spore Resin Fruit")

/datum/action/xeno_action/onclick/plant_resin_fruit
	name = "Plant Resin Fruit (50)"
	action_icon_state = "gardener_plant"
	ability_name = "plant resin fruit"
	plasma_cost = 50
	macro_path = /datum/action/xeno_action/verb/plant_resin_fruit
	action_type = XENO_ACTION_CLICK
	ability_primacy = XENO_PRIMARY_ACTION_2
	xeno_cooldown = 10
	var/health_cost = 50

/datum/action/xeno_action/onclick/plant_resin_fruit/greater
	name = "Plant Greater Resin Fruit (100)"
	plasma_cost = 100
	ability_primacy = XENO_PRIMARY_ACTION_3

/datum/action/xeno_action/verb/plant_resin_fruit()
	set category = "Alien"
	set name = "Plant Resin Fruit"
	set hidden = 1
	var/action_name = "Plant Resin Fruit"
	handle_xeno_macro(src, action_name)

/datum/action/xeno_action/onclick/plant_resin_fruit/use_ability(atom/A)
	var/mob/living/carbon/Xenomorph/X = owner
	if(!istype(X))
		return

	if(!action_cooldown_check())
		return

	if(!X.check_state())
		return
	var/turf/T = X.loc

	if(!istype(T))
		to_chat(X, SPAN_WARNING("You can't do that here."))
		return

	var/obj/effect/alien/weeds/W = locate(/obj/effect/alien/weeds) in T
	if(!W)
		to_chat(X, SPAN_WARNING("There's no weed to place it on!"))
		return

	if(W.hivenumber != X.hivenumber)
		to_chat(X, SPAN_WARNING("This weed is toxic to the fruit. Can't plant it here!"))
		return

	if(locate(/obj/effect/alien/resin/trap) in range(1, T))
		to_chat(X, SPAN_XENOWARNING("This is too close to a resin hole!"))
		return

	if(locate(/obj/effect/alien/resin/fruit) in range(1, T))
		to_chat(X, SPAN_XENOWARNING("This is too close to another fruit!"))
		return

	if (check_and_use_plasma_owner())
		if(length(X.current_placeable) >= X.max_placeable)
			to_chat(X, SPAN_XENOWARNING("You cannot sustain another fruit, one will wither away to allow this one to live!"))
			var/obj/effect/alien/resin/fruit/old_fruit = X.current_placeable[1]
			X.current_placeable.Remove(old_fruit)
			qdel(old_fruit)

		X.visible_message(SPAN_XENONOTICE("\The [X] secretes fluids and shape it into a fruit!"), \
		SPAN_XENONOTICE("You secrete a portion of your vital fluids and shape it into a fruit!"), null, 5)

		var/to_place_text = X.available_placeable[X.selected_placeable_index]
		var/placed = null
		switch(to_place_text)
			if("Lesser Resin Fruit")
				placed = new /obj/effect/alien/resin/fruit(W.loc, W, X)
			if("Greater Resin Fruit")
				placed = new /obj/effect/alien/resin/fruit/greater(W.loc,W, X)
			if("Unstable Resin Fruit")
				placed = new /obj/effect/alien/resin/fruit/unstable(W.loc, W, X)
			if("Spore Resin Fruit")
				placed = new /obj/effect/alien/resin/fruit/spore(W.loc, W, X)
		if(!placed)
			to_chat(X, SPAN_XENOHIGHDANGER("Couldn't find the fruit to place! Contact a coder!"))
			return
		X.bruteloss += health_cost
		X.updatehealth()
		playsound(X.loc, "alien_resin_build", 25)
		X.current_placeable.Add(placed)

		var/number_of_fruit = length(X.current_placeable)
		update_button_icon()
		if(number_of_fruit > 1)
			button.overlays -= "+stack_[number_of_fruit-1]"

		button.overlays += "+stack_[number_of_fruit]"

	apply_cooldown()
	..()
	return


/datum/action/xeno_action/onclick/change_fruit
	name = "Change Fruit"
	action_icon_state = "fruit_greater"
	ability_name = "change fruit"
	plasma_cost = 0
	xeno_cooldown = 0
	macro_path = /datum/action/xeno_action/verb/verb_resin_surge
	action_type = XENO_ACTION_CLICK
	ability_primacy = XENO_PRIMARY_ACTION_4

/datum/action/xeno_action/onclick/change_fruit/New()
	..()
	button.overlays.Cut()
	button.overlays += image('icons/mob/hostiles/fruits.dmi', action_icon_state)

/datum/action/xeno_action/onclick/change_fruit/use_ability(atom/A)
	var/mob/living/carbon/Xenomorph/X = owner
	X.selected_placeable_index++
	if(X.selected_placeable_index > length(X.available_placeable))
		X.selected_placeable_index = 1
	to_chat(X, SPAN_XENO("You will plant [X.available_placeable[X.selected_placeable_index]]"))
	button.overlays.Cut()
	var/fruit_icon = "fruit_lesser"
	switch(X.available_placeable[X.selected_placeable_index])
		if("Lesser Resin Fruit")
			fruit_icon = "fruit_lesser"
		if("Greater Resin Fruit")
			fruit_icon = "fruit_greater"
		if("Unstable Resin Fruit")
			fruit_icon = "fruit_unstable"
		if("Spore Resin Fruit")
			fruit_icon = "fruit_spore"
	button.overlays += image('icons/mob/hostiles/fruits.dmi', fruit_icon)

/*
	Resin Surge
*/

/datum/action/xeno_action/activable/resin_surge
	name = "Resin Surge (75)"
	action_icon_state = "gardener_resin_surge"
	ability_name = "resin surge"
	plasma_cost = 75
	xeno_cooldown = 10 SECONDS
	macro_path = /datum/action/xeno_action/verb/verb_resin_surge
	action_type = XENO_ACTION_CLICK
	ability_primacy = XENO_PRIMARY_ACTION_2
	var/channel_in_progress = FALSE
	var/max_range = 7

/datum/action/xeno_action/activable/resin_surge/use_ability(atom/A)
	var/mob/living/carbon/Xenomorph/X = owner
	if (!istype(X))
		return

	if (!action_cooldown_check())
		return

	if (!X.check_state())
		return

	if (!can_see(X, A, max_range))
		to_chat(X, SPAN_XENODANGER("You cannot see that location!"))
		return

	if (!check_and_use_plasma_owner())
		return

	var/turf/T = get_turf(A)

	var/obj/effect/alien/weeds/W = locate(/obj/effect/alien/weeds) in T
	var/obj/effect/alien/resin/fruit/F = locate(/obj/effect/alien/resin/fruit) in T
	var/obj/structure/mineral_door/resin/door = A
	var/turf/closed/wall/resin/wall = T

	var/wall_present = istype(wall) && wall.hivenumber == X.hivenumber
	var/door_present = istype(door) && door.hivenumber == X.hivenumber
	// Is my tile either a wall or a door
	if(door_present || wall_present)
		var/structure_to_buff = door || wall
		var/buff_already_present = FALSE
		if(door_present )
			for(var/datum/effects/xeno_structure_reinforcement/sf in door.effects_list)
				buff_already_present = TRUE
				break
		else if(wall_present)
			for(var/datum/effects/xeno_structure_reinforcement/sf in wall.effects_list)
				buff_already_present = TRUE
				break

		if(!buff_already_present)
			new /datum/effects/xeno_structure_reinforcement(structure_to_buff, X, ttl = 3 SECONDS)
			X.visible_message(SPAN_XENODANGER("\The [X] surges the resin around [structure_to_buff], making it temporarily nigh unbreakable!"), \
			SPAN_XENONOTICE("You surge the resin around [structure_to_buff], making it temporarily nigh unbreakable!"), null, 5)
		else
			to_chat(X, SPAN_XENONOTICE("You haplessly try to surge resin around [structure_to_buff], but it's already reinforced. It'll take a moment for you to recover."))
			xeno_cooldown = xeno_cooldown * 0.5

	else if(F && F.hivenumber == X.hivenumber)
		if(F.mature)
			to_chat(X, SPAN_XENONOTICE("The [F] is already mature. The [src.name] does nothing."))
			xeno_cooldown = xeno_cooldown * 0.5
		else
			to_chat(X, SPAN_XENONOTICE("You surge the resin around the [F], speeding its growth somewhat!"))
			F.reduce_timer(5 SECONDS)

	else if(W && istype(T, /turf/open) && W.hivenumber == X.hivenumber)
		X.visible_message(SPAN_XENODANGER("\The [X] surges the resin, creating an unstable wall!"), \
		SPAN_XENONOTICE("You surge the resin, creating an unstable wall!"), null, 5)
		T.PlaceOnTop(/turf/closed/wall/resin/weak)
		var/turf/closed/wall/resin/weak_wall = T
		weak_wall.hivenumber = X.hivenumber
		set_hive_data(weak_wall, X.hivenumber)

	else if(T)
		if(channel_in_progress)
			return
		channel_in_progress = TRUE
		if(!do_after(X, 1 SECONDS, INTERRUPT_ALL, BUSY_ICON_HOSTILE))
			channel_in_progress = FALSE
			return
		channel_in_progress = FALSE
		X.visible_message(SPAN_XENODANGER("\The [X] surges deep resin, creating an unstable sticky resin patch!"), \
		SPAN_XENONOTICE("You surge the deep resin, creating an unstable sticky resin patch!"), null, 5)
		for (var/turf/targetTurf in orange(1, T))
			if(!locate(/obj/effect/alien/resin/sticky) in targetTurf)
				new /obj/effect/alien/resin/sticky/thin/weak(targetTurf, X.hivenumber)
		if(!locate(/obj/effect/alien/resin/sticky) in T)
			new /obj/effect/alien/resin/sticky/thin/weak(T, X.hivenumber)

	else
		xeno_cooldown = xeno_cooldown * 0.5

	apply_cooldown()

	xeno_cooldown = initial(xeno_cooldown)
	..()

/datum/action/xeno_action/verb/verb_resin_surge()
	set category = "Alien"
	set name = "Resin Surge"
	set hidden = 1
	var/action_name = "Resin Surge"
	handle_xeno_macro(src, action_name)
