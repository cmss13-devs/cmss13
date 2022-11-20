/datum/xeno_mutator/gardener
	name = "STRAIN: Drone - Gardener"
	description = "You trade most of your abilities aside from pheromones and planting weeds to gain the abilities to plant potent resin fruits for your sisters."
	cost = MUTATOR_COST_EXPENSIVE
	individual_only = TRUE
	caste_whitelist = list(XENO_CASTE_DRONE) //Only drone.
	mutator_actions_to_remove = list(
		/datum/action/xeno_action/activable/secrete_resin,
		/datum/action/xeno_action/onclick/choose_resin,
		/datum/action/xeno_action/activable/corrosive_acid/weak,
		/datum/action/xeno_action/activable/transfer_plasma
	)
	mutator_actions_to_add = list(
		/datum/action/xeno_action/onclick/plant_weeds/gardener, // second macro
		/datum/action/xeno_action/activable/resin_surge, // third macro
		/datum/action/xeno_action/onclick/plant_resin_fruit/greater, // fourth macro
		/datum/action/xeno_action/onclick/change_fruit
	)
	keystone = TRUE

/datum/xeno_mutator/gardener/apply_mutator(datum/mutator_set/individual_mutators/mutator)
	. = ..()
	if (. == 0)
		return

	var/mob/living/carbon/Xenomorph/Drone/drone = mutator.xeno
	drone.mutation_type = DRONE_GARDENER
	drone.available_fruits = list(/obj/effect/alien/resin/fruit/greater, /obj/effect/alien/resin/fruit/unstable, /obj/effect/alien/resin/fruit/spore, /obj/effect/alien/resin/fruit/speed, /obj/effect/alien/resin/fruit/plasma)
	drone.selected_fruit = /obj/effect/alien/resin/fruit/greater
	drone.max_placeable = 6
	mutator_update_actions(drone)
	// Also change the primacy value for our place construction ability (because we want it in the same place but have another primacy ability)
	for(var/datum/action/xeno_action/action in drone.actions)
		if(istype(action, /datum/action/xeno_action/activable/place_construction))
			action.ability_primacy = XENO_NOT_PRIMARY_ACTION
			break // Don't need to keep looking
	mutator.recalculate_actions(description, flavor_description)
	drone.regeneration_multiplier = XENO_REGEN_MULTIPLIER_TIER_1

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
	name = "Plant Resin Fruit (100)"
	plasma_cost = 100
	ability_primacy = XENO_PRIMARY_ACTION_4

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
		if(length(X.current_fruits) >= X.max_placeable)
			to_chat(X, SPAN_XENOWARNING("You cannot sustain another fruit, one will wither away to allow this one to live!"))
			var/obj/effect/alien/resin/fruit/old_fruit = X.current_fruits[1]
			X.current_fruits.Remove(old_fruit)
			qdel(old_fruit)

		X.visible_message(SPAN_XENONOTICE("\The [X] secretes fluids and shape it into a fruit!"), \
		SPAN_XENONOTICE("You secrete a portion of your vital fluids and shape it into a fruit!"), null, 5)

		var/obj/effect/alien/resin/fruit/fruit = new X.selected_fruit(W.loc, W, X)
		if(!fruit)
			to_chat(X, SPAN_XENOHIGHDANGER("Couldn't find the fruit to place! Contact a coder!"))
			return
		X.adjustBruteLoss(health_cost)
		X.updatehealth()
		playsound(X.loc, "alien_resin_build", 25)
		X.current_fruits.Add(fruit)

		var/number_of_fruit = length(X.current_fruits)
		button.set_maptext(SMALL_FONTS_COLOR(7, number_of_fruit, "#e69d00"), 19, 2)
		update_button_icon()

	apply_cooldown()
	..()
	return


/datum/action/xeno_action/onclick/change_fruit
	name = "Change Fruit"
	action_icon_state = "blank"
	ability_name = "change fruit"
	plasma_cost = 0
	xeno_cooldown = 0
	macro_path = /datum/action/xeno_action/verb/verb_resin_surge
	action_type = XENO_ACTION_CLICK
	ability_primacy = XENO_PRIMARY_ACTION_5

/datum/action/xeno_action/onclick/change_fruit/give_to(mob/living/carbon/Xenomorph/xeno)
	. = ..()

	button.overlays.Cut()
	button.overlays += image(icon_file, button, action_icon_state)
	button.overlays += image('icons/mob/hostiles/fruits.dmi', button, initial(xeno.selected_fruit.mature_icon_state))

/datum/action/xeno_action/onclick/change_fruit/use_ability(atom/A)
	var/mob/living/carbon/Xenomorph/X = owner
	if(!X.check_state())
		return

	tgui_interact(X)
	return ..()

/datum/action/xeno_action/onclick/change_fruit/ui_assets(mob/user)
	return list(get_asset_datum(/datum/asset/spritesheet/choose_fruit))

/datum/action/xeno_action/onclick/change_fruit/ui_static_data(mob/user)
	var/mob/living/carbon/Xenomorph/X = user
	if(!istype(X))
		return

	. = list()

	var/list/fruits = list()
	for(var/obj/effect/alien/resin/fruit/fruit as anything in X.available_fruits)
		var/list/entry = list()

		entry["name"] = initial(fruit.name)
		entry["desc"] = initial(fruit.desc)
		entry["image"] = replacetext(initial(fruit.mature_icon_state), " ", "-")
		entry["id"] = "[fruit]"
		fruits += list(entry)

	.["fruits"] = fruits

/datum/action/xeno_action/onclick/change_fruit/ui_data(mob/user)
	var/mob/living/carbon/Xenomorph/X = user
	if(!istype(X))
		return

	. = list()
	.["selected_fruit"] = X.selected_fruit


/datum/action/xeno_action/onclick/change_fruit/tgui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "ChooseFruit", "Choose Fruit")
		ui.set_autoupdate(FALSE)
		ui.open()

/datum/action/xeno_action/onclick/change_fruit/Destroy()
	SStgui.close_uis(src)
	return ..()

/datum/action/xeno_action/onclick/change_fruit/ui_state(mob/user)
	return GLOB.always_state

/datum/action/xeno_action/onclick/change_fruit/ui_act(action, list/params, datum/tgui/ui, datum/ui_state/state)
	. = ..()
	if(.)
		return

	var/mob/living/carbon/Xenomorph/X = usr
	if(!istype(X))
		return

	switch(action)
		if("choose_fruit")
			var/selected_type = text2path(params["type"])
			if(!(selected_type in X.available_fruits))
				return

			var/obj/effect/alien/resin/fruit/fruit = selected_type
			to_chat(X, SPAN_NOTICE("You will now build <b>[initial(fruit.name)]\s</b> when secreting resin."))
			//update the button's overlay with new choice
			button.overlays.Cut()
			button.overlays += image(icon_file, button, action_icon_state)
			button.overlays += image('icons/mob/hostiles/fruits.dmi', button, initial(fruit.mature_icon_state))
			X.selected_fruit = selected_type
			. = TRUE
		if("refresh_ui")
			. = TRUE

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
	ability_primacy = XENO_PRIMARY_ACTION_3
	var/channel_in_progress = FALSE
	var/max_range = 7

/datum/action/xeno_action/activable/resin_surge/use_ability(atom/A, mods)
	var/mob/living/carbon/Xenomorph/X = owner
	if (!istype(X))
		return

	if (!action_cooldown_check())
		return

	if (!X.check_state(TRUE))
		return

	if(mods["click_catcher"])
		return

	if(ismob(A)) // to prevent using thermal vision to bypass clickcatcher
		if(!can_see(X, A, max_range))
			to_chat(X, SPAN_XENODANGER("You cannot see that location!"))
			return
	else
		if(get_dist(X, A) > max_range)
			to_chat(X, SPAN_WARNING("That's too far away!"))
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
			new /datum/effects/xeno_structure_reinforcement(structure_to_buff, X, ttl = 15 SECONDS)
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

/datum/action/xeno_action/onclick/plant_weeds/gardener
	name = "Plant Hardy Weeds (125)"
	ability_name = "Plant Hardy Weeds"
	action_icon_state = "plant_gardener_weeds"
	plasma_cost = 125
	macro_path = /datum/action/xeno_action/verb/verb_plant_gardening_weeds
	xeno_cooldown = 2 MINUTES
	action_type = XENO_ACTION_CLICK
	ability_primacy = XENO_PRIMARY_ACTION_2
	node_type = /obj/effect/alien/weeds/node/gardener

/obj/effect/alien/weeds/node/gardener
	spread_on_semiweedable = TRUE
	block_structures = BLOCK_SPECIAL_STRUCTURES
	fruit_growth_multiplier = 0.8

/datum/action/xeno_action/verb/verb_plant_gardening_weeds()
	set category = "Alien"
	set name = "Plant Hardy Weeds"
	set hidden = 1
	var/action_name = "Plant Hardy Weeds (125)"
	handle_xeno_macro(src, action_name)
