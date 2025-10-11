/datum/caste_datum/pathogen/popper
	caste_type = PATHOGEN_CREATURE_POPPER
	tier = 0

	melee_damage_lower = 10
	melee_damage_upper = 10
	melee_vehicle_damage = 0
	max_health = XENO_HEALTH_LESSER_DRONE
	plasma_gain = XENO_PLASMA_GAIN_TIER_2
	plasma_max = XENO_PLASMA_TIER_10
	xeno_explosion_resistance = XENO_EXPLOSIVE_ARMOR_TIER_2
	armor_deflection = XENO_NO_ARMOR
	evasion = XENO_EVASION_LOW
	speed = XENO_SPEED_TIER_8

	attack_delay = 2

	available_strains = list()
	behavior_delegate_type = /datum/behavior_delegate/pathogen_base

	caste_desc = "A fast, powerful combatant."
	evolves_to = list()
	evolution_allowed = FALSE

	heal_resting = 1

	minimap_icon = "popper"

/mob/living/carbon/xenomorph/popper
	caste_type = PATHOGEN_CREATURE_POPPER
	name = PATHOGEN_CREATURE_POPPER
	desc = "A crawling bag of spores. What nightmare are you living in?"
	icon_size = 32
	icon_state = "Popper Walking"
	plasma_types = list()
	tier = 0
	base_pixel_x = 0
	base_pixel_y = -20
	organ_value = 0
	base_actions = list(
		/datum/action/xeno_action/onclick/xeno_resting,
		/datum/action/xeno_action/watch_xeno,
		/datum/action/xeno_action/onclick/emit_pheromones,
		/datum/action/xeno_action/onclick/plant_weeds/pathogen/popper,
//		/datum/action/xeno_action/onclick/place_spore_sac, // Macro 2 // Needs rethinking on ease of access
//		/datum/action/xeno_action/onclick/release_spores,
		/datum/action/xeno_action/onclick/tacmap,
	)
	inherent_verbs = list(
		/mob/living/carbon/xenomorph/proc/vent_crawl,
	)
	claw_type = CLAW_TYPE_NORMAL

	tackle_min = 6
	tackle_max = 6
	tackle_chance = 10

	icon_xeno = 'icons/mob/pathogen/popper.dmi'
	icon_xenonid = 'icons/mob/pathogen/popper.dmi'
	need_weeds = FALSE

	weed_food_icon = 'icons/mob/xenos/weeds_48x48.dmi'
	mycelium_food_icon = 'icons/mob/pathogen/pathogen_weeds_48x48.dmi'
	weed_food_states = list("Drone_1","Drone_2","Drone_3")
	weed_food_states_flipped = list("Drone_1","Drone_2","Drone_3")
	gib_chance = 100

	AUTOWIKI_SKIP(TRUE)
	hivenumber = XENO_HIVE_PATHOGEN
	speaking_noise = "pathogen_talk"

	mob_size = MOB_SIZE_XENO_SMALL
	acid_blood_damage = 0
	bubble_icon = "pathogen"
	aura_strength = 2
	counts_for_slots = FALSE

	counts_for_roundend = FALSE

/mob/living/carbon/xenomorph/popper/initialize_pass_flags(datum/pass_flags_container/pass_flags)
	..()
	if(pass_flags)
		pass_flags.flags_pass = PASS_MOB_THRU|PASS_FLAGS_CRAWLER
		pass_flags.flags_can_pass_all = PASS_ALL^PASS_OVER_THROW_ITEM

/mob/living/carbon/xenomorph/popper/death(cause, gibbed)
	. = ..()
	new /obj/effect/pathogen/spore_cloud(loc)

/mob/living/carbon/xenomorph/popper/start_pulling(atom/movable/AM)
	return

/datum/action/xeno_action/onclick/place_spore_sac
	name = "Place spore sac (700)"
	action_icon_state = "place_trap"
	plasma_cost = 700
	action_type = XENO_ACTION_CLICK
	ability_primacy = XENO_PRIMARY_ACTION_2

/datum/action/xeno_action/onclick/place_spore_sac/use_ability(atom/A)
	var/mob/living/carbon/xenomorph/popper = owner
	if(!popper.check_state())
		return

	var/turf/target_turf = get_turf(popper)
	if(!istype(target_turf))
		to_chat(popper, SPAN_XENOWARNING("We can't do that here."))
		return
	var/area/turf_area = get_area(target_turf)
	if(istype(turf_area,/area/shuttle/drop1/lz1) || istype(turf_area,/area/shuttle/drop2/lz2) || SSinterior.in_interior(owner))
		to_chat(popper, SPAN_WARNING("We sense this is not a suitable area for creating a spore sac."))
		return
	if(isnull(turf_area) || !(turf_area.is_resin_allowed))
		if(!turf_area || turf_area.flags_area & AREA_UNWEEDABLE)
			to_chat(popper, SPAN_XENOWARNING("This area is unsuited to host the hive!"))
			return
		to_chat(popper, SPAN_XENOWARNING("It's too early to spread the hive this far."))
		return
	if(!target_turf.check_spore_sac_placement(popper))
		return
	if(!popper.check_plasma(plasma_cost))
		return
	popper.use_plasma(plasma_cost)
	playsound(popper.loc, "alien_resin_build", 25)
	new /obj/effect/pathogen/spore_sac(target_turf)
	to_chat(popper, SPAN_XENONOTICE("We place a spore sac on the ground."))
	return ..()

/turf/proc/check_spore_sac_placement(mob/living/carbon/xenomorph/xeno)
	if(is_weedable < FULLY_WEEDABLE)
		to_chat(xeno, SPAN_XENOWARNING("This place cannot support a spore sac."))
		return FALSE

	var/obj/effect/alien/weeds/alien_weeds = locate() in src
	if(alien_weeds && (alien_weeds.linked_hive.hivenumber != xeno.hivenumber))
		to_chat(xeno, SPAN_XENOWARNING("We cannot grow spores on this contaminant!"))
		return FALSE

	// This snowflake check exists because stairs specifically are indestructable, tile-covering, and cannot be moved, which allows resin holes to be
	// planted under them without any possible counterplay. In the future if resin holes stop being able to be hidden under objects, remove this check.
	if(locate(/obj/structure) in src)
		if(locate(/obj/structure/stairs) in src)
			to_chat(xeno, SPAN_XENOWARNING("We cannot grow spores on a staircase!"))
			return FALSE

		if(locate(/obj/structure/monorail) in src)
			to_chat(xeno, SPAN_XENOWARNING("We cannot grow spores on a track!"))
			return FALSE

		if(locate(/obj/structure/machinery/conveyor) in src)
			to_chat(xeno, SPAN_XENOWARNING("We cannot grow spores on a conveyor!"))
			return FALSE

		if(locate(/obj/structure/machinery/colony_floodlight) in src)
			to_chat(xeno, SPAN_XENOWARNING("We cannot grow spores on a light!"))
			return FALSE

	if(!xeno.check_alien_construction(src, check_doors = TRUE))
		return FALSE

	if(locate(/obj/effect/alien/resin/trap) in orange(1, src)) // obj/effect/alien/resin presence is checked on turf by check_alien_construction, so we just check orange.
		to_chat(xeno, SPAN_XENOWARNING("This is too close to a contaminant!"))
		return FALSE

	if(locate(/obj/effect/pathogen/spore_sac) in range(2, src))
		to_chat(xeno, SPAN_XENOWARNING("This is too close to an existing spore sac!"))
		return FALSE

	for(var/mob/living/body in src)
		if(body.stat == DEAD)
			to_chat(xeno, SPAN_XENOWARNING("The body is in the way!"))
			return FALSE

	return TRUE

/datum/action/xeno_action/onclick/release_spores
	name = "Release Spore Cloud (200)"
	action_icon_state = "gas mine"
	plasma_cost = 200
	action_type = XENO_ACTION_CLICK
	ability_primacy = XENO_PRIMARY_ACTION_3
	var/windup_duration = 1 SECONDS

/datum/action/xeno_action/onclick/release_spores/use_ability(atom/A)
	var/mob/living/carbon/xenomorph/popper = owner
	if(!popper.check_state())
		return

	var/turf/target_turf = get_turf(popper)
	if(!istype(target_turf))
		to_chat(popper, SPAN_XENOWARNING("We can't do that here."))
		return
	if(!popper.check_plasma(plasma_cost))
		return
	if(!do_after(popper, windup_duration, INTERRUPT_NO_NEEDHAND, BUSY_ICON_HOSTILE))
		return
	popper.use_plasma(plasma_cost)
	playsound(popper.loc, "alien_resin_build", 25)
	new /obj/effect/pathogen/spore_cloud(target_turf)
	popper.visible_message(SPAN_DANGER("[src] releases a cloud of spores!"), SPAN_XENONOTICE("We release a spore cloud."))
	return ..()



/datum/resin_construction/resin_obj/popper_cocoon
	name = PATHOGEN_STRUCTURE_COCOON
	desc = "A cocoon to grow a Pathogen Popper."
	construction_name = "mycelial cocoon"
	cost = 800
	max_per_xeno = 3

	build_path = /obj/effect/alien/resin/special/popper_cocoon

/obj/effect/alien/resin/special/popper_cocoon
	name = PATHOGEN_STRUCTURE_COCOON
	desc = "Something strange must be growing in this cocoon..."
	icon = 'icons/mob/pathogen/pathogen_weeds.dmi'
	icon_state = "cocoon_half"
	health = 300
	maxhealth = 300

	pixel_x = 0
	pixel_y = 0
	forced_hive = TRUE
	hivenumber = XENO_HIVE_PATHOGEN

	broadcast_destroy = FALSE

	var/growth_state = POPPER_COCOON_GROWING
	var/mature_time

/obj/effect/alien/resin/special/popper_cocoon/Initialize(mapload, hive_ref)
	mature_time = addtimer(CALLBACK(src, PROC_REF(mature)), 60 SECONDS, TIMER_UNIQUE | TIMER_STOPPABLE)
	. = ..()

/obj/effect/alien/resin/special/popper_cocoon/proc/mature()
	if((health <= 0) || !(growth_state == POPPER_COCOON_GROWING))
		return FALSE

	icon_state = "cocoon_full"
	desc = "There is definitely something odd in here..."
	health = 500
	maxhealth = 500
	growth_state = POPPER_COCOON_GROWN

	xeno_message("Confluence: \A [name] has finished growing at [sanitize_area(get_area_name(src))]!", 3, XENO_HIVE_PATHOGEN)

	var/area/growth_area = get_area(src)
	notify_ghosts(header = "Popper Cocoon", message = "A <b>Popper Cocoon</b> has fully grown at <b>[growth_area]</b>!", source = src)
	return TRUE

/obj/effect/alien/resin/special/popper_cocoon/update_icon()
	. = ..()

	if(health > 0)
		switch(growth_state)
			if(POPPER_COCOON_GROWING)
				icon_state = "cocoon_half"
			if(POPPER_COCOON_GROWN)
				icon_state = "cocoon_full"
			if(POPPER_COCOON_HATCHED)
				icon_state = "cocoon_empty"
	else
		icon_state = "cocoon_dead"

/obj/effect/alien/resin/special/popper_cocoon/process()
	if(growth_state == POPPER_COCOON_HATCHED)
		STOP_PROCESSING(SSobj, src)
		return
	if(health <= 0)
		STOP_PROCESSING(SSobj, src)
		return

	if((health < maxhealth))
		health = max(health + 5, maxhealth)

/obj/effect/alien/resin/special/popper_cocoon/healthcheck()
	if(health > 0)
		return
	if(growth_state == POPPER_COCOON_DEAD)
		return // Already dead.

	flick("cocoon_pop", src)
	STOP_PROCESSING(SSobj, src)
	update_icon()
	growth_state = POPPER_COCOON_DEAD

	xeno_message("Confluence: \A [name] has been destroyed at [sanitize_area(get_area_name(src))]!", 3, XENO_HIVE_PATHOGEN)
	addtimer(CALLBACK(src, PROC_REF(decay)), 30 SECONDS)

/obj/effect/alien/resin/special/popper_cocoon/proc/hatch(mob/dead/observer/user)
	if(growth_state != POPPER_COCOON_GROWN) // No dooubling up
		to_chat(user, SPAN_WARNING("There is no Popper left in this cocoon!"))
		return FALSE

	var/datum/hive_status/pathogen/hive = GLOB.hive_datum[XENO_HIVE_PATHOGEN]
	if(!hive.has_popper_slot())
		to_chat(user, SPAN_WARNING("The Mycelial Confluence cannot support another Popper at this time!"))
		return FALSE

	growth_state = POPPER_COCOON_HATCHED
	update_icon()
	linked_hive.spawn_as_popper(user, src)
	addtimer(CALLBACK(src, PROC_REF(decay)), 30 SECONDS)
	return TRUE

/obj/effect/alien/resin/special/popper_cocoon/attack_ghost(mob/dead/observer/user)
	. = ..()
	if(growth_state != POPPER_COCOON_GROWN)
		return FALSE

	if(!linked_hive.can_spawn_as_popper(user))
		return FALSE

	if(!(tgui_alert(user, "Do you wish to spawn as a Pathogen Popper?", "Confirm Spawn", list("Yes", "No"), 5 SECONDS) == "Yes"))
		return FALSE

	hatch(user)
	return TRUE

/obj/effect/alien/resin/special/popper_cocoon/proc/death()
	if(health <= 0)
		return FALSE

	health = 0
	healthcheck()
	addtimer(CALLBACK(src, PROC_REF(decay)), 30 SECONDS)
	return TRUE

/obj/effect/alien/resin/special/popper_cocoon/proc/decay()
	if(growth_state == POPPER_COCOON_HATCHED)
		xeno_message("Confluence: \A [name] has decayed after hatching!", 2, XENO_HIVE_PATHOGEN)
	if(mature_time)
		deltimer(mature_time)
	mature_time = null
	qdel(src)

/datum/hive_status/proc/spawn_as_popper(mob/dead/observer/user, atom/source)
	var/mob/living/carbon/xenomorph/popper/popper = new /mob/living/carbon/xenomorph/popper(source.loc, null, XENO_HIVE_PATHOGEN)
	user.mind.transfer_to(popper, TRUE)
	popper.visible_message(SPAN_XENODANGER("A Popper suddenly emerges out of \the [source]!"), SPAN_XENODANGER("You emerge out of \the [source] and awaken from your slumber."))
	playsound(popper, 'sound/effects/xeno_newlarva.ogg', 25, TRUE)
	popper.generate_name()
	popper.timeofdeath = user.timeofdeath
	msg_admin_niche("[key_name(popper)] has joined as a Pathogen Popper at ([source.x],[source.y],[source.z]).")

/datum/hive_status/proc/can_spawn_as_popper(mob/dead/observer/user)
	if(!GLOB.hive_datum || ! GLOB.hive_datum[XENO_HIVE_PATHOGEN])
		return FALSE

	if(jobban_isbanned(user, JOB_XENOMORPH)) // User is jobbanned
		to_chat(user, SPAN_WARNING("You are banned from playing aliens and cannot spawn as a Pathogen Popper."))
		return FALSE

	for(var/mob_name in banished_ckeys)
		if(banished_ckeys[mob_name] == user.ckey)
			to_chat(user, SPAN_WARNING("You are banished from the [src], you may not rejoin unless the Overmind re-admits you."))
			return FALSE

	var/mob/living/carbon/human/original_human = user.mind?.original
	if(istype(original_human) && !original_human.undefibbable && !original_human.chestburst && HAS_TRAIT_FROM(original_human, TRAIT_NESTED, TRAIT_SOURCE_BUCKLE))
		to_chat(user, SPAN_WARNING("You cannot become a Popper until you are no longer alive in a nest."))
		return FALSE

	if(world.time - user.client?.player_details.larva_pool_time < XENO_JOIN_DEAD_TIME)
		var/time_left = floor((user.client.player_details.larva_pool_time + XENO_JOIN_DEAD_TIME - world.time) / 10)
		to_chat(user, SPAN_WARNING("You ghosted too recently. You cannot become a Popper until [XENO_JOIN_DEAD_TIME / 600] minutes have passed ([time_left] seconds remaining)."))
		return FALSE

	if(world.time - user.timeofdeath < JOIN_AS_LESSER_DRONE_DELAY)
		var/time_left = floor((user.timeofdeath + JOIN_AS_LESSER_DRONE_DELAY - world.time) / 10)
		to_chat(user, SPAN_WARNING("You ghosted too recently. You cannot become a Popper until [JOIN_AS_LESSER_DRONE_DELAY / 10] seconds have passed ([time_left] seconds remaining)."))
		return FALSE

	if(!has_popper_slot())
		to_chat(user, SPAN_WARNING("The Mycelial Confluence cannot support another Popper at this time!"))
		return FALSE

	if(!user.client)
		return FALSE

	return TRUE

/datum/game_mode/proc/attempt_to_join_as_pathogen_popper(mob/xeno_candidate)
	var/datum/hive_status/pathogen/hive

	hive = GLOB.hive_datum[XENO_HIVE_PATHOGEN]

	if(length(hive.totalXenos) <= 0)
		to_chat(xeno_candidate, SPAN_WARNING("The confluence isn't active at this point for you to join."))
		return FALSE

	if(!hive.has_popper_slot())
		to_chat(xeno_candidate, SPAN_WARNING("The Mycelial Confluence cannot support another Popper at this time!"))
		return FALSE


	var/list/selection_list = list()
	var/list/selection_list_structure = list()

	for(var/obj/effect/alien/resin/special/popper_cocoon/cocoon as anything in hive.hive_structures[PATHOGEN_STRUCTURE_COCOON])
		if(cocoon.growth_state == POPPER_COCOON_GROWN)
			var/cocoon_number = 1
			var/cocoon_name = "[cocoon.name] at [get_area(cocoon)]"
			//For renaming the cocoons if we have duplicates
			var/cocoon_selection_name = cocoon_name
			while(cocoon_selection_name in selection_list)
				cocoon_selection_name = "[cocoon_name] ([cocoon_number])"
				cocoon_number++
			selection_list += cocoon_selection_name
			selection_list_structure += cocoon

	if(!length(selection_list))
		to_chat(xeno_candidate, SPAN_WARNING("The confluence does not have enough cocoons to hatch another Popper!"))
		return FALSE

	var/prompt = tgui_input_list(xeno_candidate, "Select spawn?", "Spawnpoint Selection", selection_list)
	if(!prompt)
		return FALSE

	var/obj/effect/alien/resin/special/popper_cocoon/selected_structure = selection_list_structure[selection_list.Find(prompt)]

	if(!hive.can_spawn_as_popper(xeno_candidate))
		return FALSE

	selected_structure.hatch(xeno_candidate)
	return TRUE

/datum/hive_status/proc/has_popper_slot()
	return FALSE

/datum/hive_status/proc/get_popper_num()
	var/popper_num = 0
	for(var/mob/living/carbon/xenomorph/xeno as anything in totalXenos)
		if(ispopper(xeno))
			popper_num++
	return popper_num

/datum/hive_status/pathogen/has_popper_slot()
	if(get_popper_num() >= max_poppers)
		return FALSE
	return TRUE
