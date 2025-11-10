//Xenomorph Evolution Code - Colonial Marines - Apophis775 - Last Edit: 11JUN16

//Recoded and consolidated by Abby -- ALL evolutions come from here now. It should work with any caste, anywhere
//All castes need an evolves_to() list in their defines
//Such as evolves_to = list(XENO_CASTE_WARRIOR, XENO_CASTE_SENTINEL, XENO_CASTE_RUNNER, "Badass") etc

/// A list of ckeys that have been de-evolved willingly or forcefully
GLOBAL_LIST_EMPTY(deevolved_ckeys)

/mob/living/carbon/xenomorph/verb/Evolve()
	set name = "Evolve"
	set desc = "Evolve into a higher form."
	set category = "Alien"

	do_evolve()

/mob/living/carbon/xenomorph/proc/do_evolve()
	if(!evolve_checks())
		return
	var/mob/living/carbon/human/user = hauled_mob?.resolve()
	if(user)
		to_chat(src, "Release [user] before evolving!")
		return

	var/list/castes_available = caste.evolves_to.Copy()

	// Also offer queen to any tier 1 that can evolve at all if there isn't a queen
	if(tier == 1 && hive.allow_queen_evolve && !hive.living_xeno_queen)
		castes_available |= XENO_CASTE_QUEEN

	// Allow drones to evo into any T2 before first drop
	if(caste_type == XENO_CASTE_DRONE && !SSobjectives.first_drop_complete)
		castes_available = caste.early_evolves_to.Copy()

	for(var/caste in castes_available)
		if(GLOB.xeno_datum_list[caste].minimum_evolve_time > ROUND_TIME)
			castes_available -= caste

	if(!length(castes_available))
		to_chat(src, SPAN_WARNING("The Hive is not capable of supporting any castes we can evolve to yet."))
		return

	// BANDAMARINES EDIT START - Translation
	// Assoc list - [ru_caste_name = caste_name]
	var/list/castes_available_ru = list()
	for(var/caste_name in castes_available)
		castes_available_ru[declent_ru_initial(caste_name, NOMINATIVE, caste_name)] = caste_name
	// BANDAMARINES EDIT END - Translation

	var/castepick
	if((client.prefs && client.prefs.no_radials_preference) || !hive.evolution_menu_images)
		castepick = tgui_input_list(src, "You are growing into a beautiful alien! It is time to choose a caste.", "Evolve", castes_available_ru, theme="hive_status") // BANDAMARINES EDIT - Translation
	else
		var/list/fancy_caste_list = list()
		for(var/caste in castes_available_ru) // BANDAMARINES EDIT - Translation
			fancy_caste_list[caste] = hive.evolution_menu_images[castes_available_ru[caste]] // BANDAMARINES EDIT - Translation

		castepick = show_radial_menu(src, client?.eye, fancy_caste_list)
	castepick = castes_available_ru[castepick] || castepick // BANDAMARINES EDIT - Translation
	if(!castepick) //Changed my mind
		return

	if(SEND_SIGNAL(src, COMSIG_XENO_TRY_EVOLVE, castepick) & COMPONENT_OVERRIDE_EVOLVE)
		return // Message will be handled by component

	var/datum/caste_datum/caste_datum = GLOB.xeno_datum_list[castepick]
	if(caste_datum && caste_datum.minimum_evolve_time > ROUND_TIME)
		to_chat(src, SPAN_WARNING("The Hive cannot support this caste yet! ([floor((caste_datum.minimum_evolve_time - ROUND_TIME) / 10)] seconds remaining)"))
		return

	if(!evolve_checks())
		return

	if(!hive.living_xeno_queen && castepick != XENO_CASTE_QUEEN && !islarva(src) && !hive.allow_no_queen_evo)
		if(hive.xeno_queen_timer > world.time)
			to_chat(src, SPAN_WARNING("Улей потрясён смертью последней Королевы. Без Королевы у нас нет возможности эволюционировать."))
		else
			to_chat(src, SPAN_XENONOTICE("В улье сейчас нет Королевы! Без Королевы у нас нет возможности эволюционировать."))
		return

	if(castepick == XENO_CASTE_QUEEN) //Special case for dealing with queenae
		if(hardcore)
			to_chat(src, SPAN_WARNING("Nuh-uhh."))
			return

		if(SSticker.mode && hive.xeno_queen_timer > world.time)
			to_chat(src, SPAN_WARNING("We must wait about [DisplayTimeText(hive.xeno_queen_timer - world.time, 1)] for the hive to recover from the previous Queen's death."))
			return

		var/required_plasma = min(500, plasma_max)
		if(plasma_stored >= required_plasma)
			if(hive.living_xeno_queen)
				to_chat(src, SPAN_WARNING("There already is a living Queen."))
				return
		else
			to_chat(src, SPAN_WARNING("We require more plasma! Currently at: [plasma_stored] / [required_plasma]."))
			return

	if(evolution_threshold && castepick != XENO_CASTE_QUEEN) //Does the caste have an evolution timer? Then check it
		if(evolution_stored < evolution_threshold)
			to_chat(src, SPAN_WARNING("We must wait before evolving. Currently at: [evolution_stored] / [evolution_threshold]."))
			return

	var/mob/living/carbon/xenomorph/xeno_type = null
	xeno_type = GLOB.RoleAuthority.get_caste_by_text(castepick)

	if(isnull(xeno_type))
		to_chat(src, SPAN_WARNING("[castepick] is not a valid caste! If you're seeing this message, tell a coder!"))
		return

	// Used for restricting benos to evolve to drone/queen when they're the only potential queen
	var/potential_queens = hive.get_potential_queen_count()

	if(!can_evolve(castepick, potential_queens))
		return
	to_chat(src, SPAN_XENONOTICE("Похоже, что улей может поддержать нашу эволюцию в [SPAN_BOLD(castepick)]!")) // SS220 EDIT ADDICTION

	visible_message(SPAN_XENONOTICE("[capitalize(declent_ru(NOMINATIVE))] начинает извиваться и дрожать."), // SS220 EDIT ADDICTION
	SPAN_XENONOTICE("Мы начинаем извиваться и дрожать."))
	xeno_jitter(25)
	evolving = TRUE
	var/level_to_switch_to = get_vision_level()

	if(!do_after(src, 2.5 SECONDS, INTERRUPT_INCAPACITATED|INTERRUPT_CHANGED_LYING, BUSY_ICON_HOSTILE)) // Can evolve while moving, resist or rest to cancel it.
		to_chat(src, SPAN_WARNING("Мы дрожим, но ничего не происходит. Похоже, что наша эволюция была приостановлена..."))
		evolving = FALSE
		return

	evolving = FALSE

	if(!isturf(loc)) //qdel'd or moved into something
		return
	if(castepick == XENO_CASTE_QUEEN) //Do another check after the tick.
		if(jobban_isbanned(src, XENO_CASTE_QUEEN))
			to_chat(src, SPAN_WARNING("You are jobbanned from the Queen role."))
			return
		if(hive.living_xeno_queen)
			to_chat(src, SPAN_WARNING("There already is a Queen."))
			return
		if(!hive.allow_queen_evolve)
			to_chat(src, SPAN_WARNING("We can't find the strength to evolve into a Queen"))
			return
	else if(!can_evolve(castepick, potential_queens))
		return

	// subtract the threshold, keep the stored amount
	evolution_stored -= evolution_threshold

	// don't drop their organ
	var/obj/item/organ/xeno/organ = locate() in src
	if(!isnull(organ))
		qdel(organ)

	//From there, the new xeno exists, hopefully
	var/mob/living/carbon/xenomorph/new_xeno = new xeno_type(get_turf(src), src)
	new_xeno.creation_time = creation_time

	if(!istype(new_xeno))
		//Something went horribly wrong!
		to_chat(src, SPAN_WARNING("Something went terribly wrong here. Your new xeno is null! Tell a coder immediately!"))
		stack_trace("Xeno evolution failed: [src] attempted to evolve into \'[castepick]\'")
		if(new_xeno)
			qdel(new_xeno)
		return

	var/area/xeno_area = get_area(new_xeno)
	if(!should_block_game_interaction(new_xeno) || (xeno_area.flags_atom & AREA_ALLOW_XENO_JOIN))
		switch(new_xeno.tier) //They have evolved, add them to the slot count IF they are in regular game space
			if(2)
				hive.tier_2_xenos |= new_xeno
			if(3)
				hive.tier_3_xenos |= new_xeno

	log_game("EVOLVE: [key_name(src)] evolved into [new_xeno].")
	if(mind)
		mind.transfer_to(new_xeno)
	else
		new_xeno.key = key
		if(new_xeno.client)
			new_xeno.client.change_view(GLOB.world_view_size)

	//Regenerate the new mob's name now that our player is inside
	new_xeno.generate_name()
	if(new_xeno.client)
		new_xeno.set_lighting_alpha(level_to_switch_to)
	if(new_xeno.health - getBruteLoss(src) - getFireLoss(src) > 0) //Cmon, don't kill the new one! Shouldnt be possible though
		new_xeno.bruteloss = bruteloss //Transfers the damage over.
		new_xeno.fireloss = fireloss //Transfers the damage over.
		new_xeno.updatehealth()

	if(plasma_max == 0)
		new_xeno.plasma_stored = new_xeno.plasma_max
	else
		new_xeno.plasma_stored = new_xeno.plasma_max*(plasma_stored/plasma_max) //preserve the ratio of plasma

	new_xeno.built_structures = built_structures.Copy()

	built_structures = null

	new_xeno.visible_message(SPAN_XENODANGER("Из панциря [declent_ru(GENITIVE)] появляется [declent_ru_initial(new_xeno.caste.caste_type, NOMINATIVE, new_xeno.caste.caste_type)]."), // SS220 EDIT ADDICTION
	SPAN_XENODANGER("Мы эволюционируем в более совершенную форму из оболочки старого панциря. Во имя улья!"))

	if(hive.living_xeno_queen && hive.living_xeno_queen.observed_xeno == src)
		hive.living_xeno_queen.overwatch(new_xeno)

	transfer_observers_to(new_xeno)
	new_xeno._status_traits = _status_traits

	// Freshly evolved xenos emerge standing.
	// This resets density and resting status traits.
	set_body_position(STANDING_UP)

	qdel(src)
	new_xeno.xeno_jitter(25)

	if (new_xeno.client)
		new_xeno.client.mouse_pointer_icon = initial(new_xeno.client.mouse_pointer_icon)

	if(new_xeno.mind && GLOB.round_statistics)
		GLOB.round_statistics.track_new_participant(new_xeno.faction, 0) //so an evolved xeno doesn't count as two.
	SSround_recording.recorder.track_player(new_xeno)

	// We prevent de-evolved people from being tracked for the rest of the round relating to T1s in order to prevent people
	// Intentionally de/re-evolving to mess with the stats gathered. We don't track t2/3 because it's a legit strategy to open
	// With a t1 into drone before de-evoing later to go t1 into another caste once survs are dead/capped
	if(new_xeno.ckey && !((new_xeno.caste.caste_type in XENO_T1_CASTES) && (new_xeno.ckey in GLOB.deevolved_ckeys) && !(new_xeno.datum_flags & DF_VAR_EDITED)))
		var/caste_cleaned_key = lowertext(replacetext(castepick, " ", "_"))
		if(!SSticker.mode?.round_stats.castes_evolved[caste_cleaned_key])
			SSticker.mode?.round_stats.castes_evolved[caste_cleaned_key] = 1
		else
			SSticker.mode?.round_stats.castes_evolved[caste_cleaned_key] += 1

	SEND_SIGNAL(src, COMSIG_XENO_EVOLVE_TO_NEW_CASTE, new_xeno)

/mob/living/carbon/xenomorph/proc/evolve_checks()
	if(!check_state(TRUE))
		return FALSE

	if(is_ventcrawling)
		to_chat(src, SPAN_WARNING("Мы не можем эволюционировать в этом месте."))
		return FALSE

	if(!isturf(loc))
		to_chat(src, SPAN_WARNING("Мы не можем эволюционировать в этом месте."))
		return FALSE

	if(HAS_TRAIT(src, TRAIT_HIVEMIND_INTERFERENCE))
		to_chat(src, SPAN_WARNING("Наша связь с ульем подавляется... Мы должны немного подождать."))
		return FALSE

	if(hardcore)
		to_chat(src, SPAN_WARNING("Nuh-uh."))
		return FALSE

	if(lock_evolve)
		if(banished)
			to_chat(src, SPAN_WARNING("Мы изгнаны и не можем поддерживать связь с ульем."))
		else
			to_chat(src, SPAN_WARNING("Мы не можем эволюционировать."))
		return FALSE

	if(jobban_isbanned(src, JOB_XENOMORPH))//~who so genius to do this is?
		to_chat(src, SPAN_WARNING("You are jobbanned from aliens and cannot evolve. How did you even become an alien?"))
		return FALSE

	if(handcuffed || legcuffed)
		to_chat(src, SPAN_WARNING("The restraints are too restricting to allow us to evolve."))
		return FALSE

	if(isnull(caste.evolves_to) || !length(caste.evolves_to))
		to_chat(src, SPAN_WARNING("We are already the apex of form and function. Go forth and spread the hive!"))
		return FALSE

	if(health < maxHealth)
		to_chat(src, SPAN_WARNING("Мы слишком слабы, чтобы эволюционировать... Мы должны восстановить здоровье."))
		return FALSE

	if(agility || fortify || crest_defense || stealth)
		to_chat(src, SPAN_WARNING("Мы не можем эволюционировать."))
		return FALSE

	if(ROUND_TIME < XENO_ROUNDSTART_BOOSTED_EVO_TIME)
		if(caste_type == XENO_CASTE_LARVA || caste_type == XENO_CASTE_PREDALIEN_LARVA)
			var/turf/evoturf = get_turf(src)
			if(!locate(/obj/effect/alien/weeds) in evoturf)
				to_chat(src, SPAN_WARNING("The hive hasn't developed enough yet for you to evolve off weeds!"))
				return FALSE

	return TRUE

/mob/living/carbon/xenomorph/proc/transmute_verb()
	set name = "Transmute"
	set desc = "Transmute into a different caste of the same tier"
	set category = "Alien"

	if(!check_state())
		return
	if(is_ventcrawling)
		to_chat(src, SPAN_XENOWARNING("Мы не можем изменить форму в этом месте."))
		return
	if(!isturf(loc))
		to_chat(src, SPAN_XENOWARNING("Мы не можем изменить форму в этом месте."))
		return
	if(HAS_TRAIT(src, TRAIT_HIVEMIND_INTERFERENCE))
		to_chat(src, SPAN_WARNING("Наша связь с ульем подавляется... Мы должны немного подождать."))
		return FALSE
	if(health < maxHealth)
		to_chat(src, SPAN_XENOWARNING("Мы слишком слабы, чтобы изменить форму... Мы должны восстановить здоровье."))
		return
	if(tier == 0 || tier == 4)
		to_chat(src, SPAN_XENOWARNING("Мы не можем изменить форму."))
		return
	if(agility || fortify || crest_defense || stealth)
		to_chat(src, SPAN_XENOWARNING("Мы не можем изменить форму."))
		return
	if(lock_evolve)
		if(banished)
			to_chat(src, SPAN_WARNING("Мы изгнаны и не можем поддерживать связь с ульем."))
		else
			to_chat(src, SPAN_WARNING("Мы не можем изменить форму."))
		return FALSE

	var/newcaste
	var/list/options = list()
	var/static/list/option_images = list()

	if(tier == 1)
		options = XENO_T1_CASTES
	else if (tier == 2)
		options = XENO_T2_CASTES
	else if (tier == 3)
		options = XENO_T3_CASTES

	if(!option_images["[tier]"])
		option_images["[tier]"] = collect_xeno_images(options)

	if(!client.prefs.no_radial_labels_preference)
		newcaste = show_radial_menu(src, src, option_images["[tier]"])
	else
		newcaste = tgui_input_list(src, "Выберите касту в которую хотите перейти.", "Изменение формы", options, theme="hive_status")

	if(!newcaste)
		return

	transmute(newcaste, "Мы изменяемся в новую форму.")

// The queen de-evo, but on yourself.
/mob/living/carbon/xenomorph/verb/Deevolve()
	set name = "De-Evolve"
	set desc = "De-evolve into a lesser form."
	set category = "Alien"

	if(!check_state())
		return
	if(is_ventcrawling)
		to_chat(src, SPAN_XENOWARNING("Мы не можем регрессировать в этом месте."))
		return
	if(!isturf(loc))
		to_chat(src, SPAN_XENOWARNING("Мы не можем регрессировать в этом месте."))
		return
	if(health < maxHealth)
		to_chat(src, SPAN_XENOWARNING("Мы слишком слабы, чтобы регрессировать... Мы должны восстановить здоровье."))
		return
	if(HAS_TRAIT(src, TRAIT_HIVEMIND_INTERFERENCE))
		to_chat(src, SPAN_WARNING("Наша связь с ульем подавляется... Мы должны немного подождать."))
		return FALSE
	if(length(caste.deevolves_to) < 1)
		to_chat(src, SPAN_XENOWARNING("Мы не можем регрессировать дальше."))
		return
	if(lock_evolve)
		if(banished)
			to_chat(src, SPAN_WARNING("Мы изгнаны и не можем поддерживать связь с ульем."))
		else
			to_chat(src, SPAN_WARNING("Мы не можем регрессировать."))
		return FALSE

	var/alleged_queens = hive.get_potential_queen_count()
	if(hive.allow_queen_evolve && !hive.living_xeno_queen && alleged_queens < 2 && isdrone(src))
		to_chat(src, SPAN_XENONOTICE("В улье сейчас нет сестры, которая могла бы стать Королевой! Вы должны стать дроном, чтобы улей выжил!"))
		return FALSE

	var/newcaste
	if(length(caste.deevolves_to) == 1)
		newcaste = caste.deevolves_to[1]
	else if(length(caste.deevolves_to) > 1)
		newcaste = tgui_input_list(src, "Choose a caste you want to de-evolve to.", "De-evolve", caste.deevolves_to, theme="hive_status")

	if(!newcaste)
		return

	var/confirm = tgui_alert(src, "Are you sure you want to de-evolve from [caste.caste_type] to [newcaste]? You won't be able to return to it for a time.", "Deevolution", list("Yes", "No"))
	if(confirm != "Yes")
		return

	if(!check_state())
		return
	if(is_ventcrawling)
		return
	if(!isturf(loc))
		return
	if(health <= 0)
		return
	if(lock_evolve)
		to_chat(src, SPAN_WARNING("Мы изгнаны и не можем поддерживать связь с ульем."))
		return


	SEND_SIGNAL(src, COMSIG_XENO_DEEVOLVE)

	var/mob/living/carbon/xenomorph/new_xeno = transmute(newcaste)
	if(new_xeno)
		log_game("EVOLVE: [key_name(src)] de-evolved into [new_xeno].")

	if(new_xeno.ckey)
		GLOB.deevolved_ckeys += new_xeno.ckey

/mob/living/carbon/xenomorph/proc/transmute(newcaste, message="Мы регрессируем в нашу предыдущую форму.")
	// We have to delete the organ before creating the new xeno because all old_xeno contents are dropped to the ground on Initalize()
	var/obj/item/organ/xeno/organ = locate() in src
	if(!isnull(organ))
		qdel(organ)

	var/level_to_switch_to = get_vision_level()
	var/xeno_type = GLOB.RoleAuthority.get_caste_by_text(newcaste)
	var/mob/living/carbon/xenomorph/new_xeno = new xeno_type(get_turf(src), src)
	new_xeno.creation_time = creation_time

	if(!istype(new_xeno))
		//Something went horribly wrong
		to_chat(src, SPAN_WARNING("Something went terribly wrong here. Your new xeno is null! Tell a coder immediately!"))
		if(new_xeno)
			qdel(new_xeno)

		if(organ_value != 0)
			organ = new()
			organ.forceMove(src)
			organ.research_value = organ_value
			organ.caste_origin = caste_type
			organ.icon_state = get_organ_icon()
		return FALSE

	new_xeno.built_structures = built_structures.Copy()
	built_structures = null

	if(mind)
		mind.transfer_to(new_xeno)
	else
		new_xeno.key = key
		if(new_xeno.client)
			new_xeno.client.change_view(GLOB.world_view_size)
			new_xeno.client.pixel_x = 0
			new_xeno.client.pixel_y = 0

	//Regenerate the new mob's name now that our player is inside
	if(newcaste == XENO_CASTE_LARVA)
		var/mob/living/carbon/xenomorph/larva/new_larva = new_xeno
		new_larva.larva_state = LARVA_STATE_NORMAL
		new_larva.update_icons()
	new_xeno.generate_name()
	if(new_xeno.client)
		new_xeno.set_lighting_alpha(level_to_switch_to)

	// If the player has lost the Deevolve verb before, don't allow them to do it again
	if(!(/mob/living/carbon/xenomorph/verb/Deevolve in verbs))
		remove_verb(new_xeno, /mob/living/carbon/xenomorph/verb/Deevolve)

	new_xeno.visible_message(SPAN_XENODANGER("Из панциря [declent_ru(GENITIVE)] появляется [declent_ru_initial(new_xeno.caste.caste_type, NOMINATIVE, new_xeno.caste.caste_type)]."), // SS220 EDIT ADDICTION
	SPAN_XENODANGER(message))

	transfer_observers_to(new_xeno)
	new_xeno._status_traits = src._status_traits

	if(GLOB.round_statistics && !new_xeno.statistic_exempt)
		GLOB.round_statistics.track_new_participant(faction, 0) //so an evolved xeno doesn't count as two.
	SSround_recording.recorder.stop_tracking(src)
	SSround_recording.recorder.track_player(new_xeno)

	qdel(src)

	return new_xeno

/mob/living/carbon/xenomorph/proc/can_evolve(castepick, potential_queens)
	var/selected_caste = GLOB.xeno_datum_list[castepick]?.type
	var/free_slot = LAZYACCESS(hive.free_slots, selected_caste)
	var/used_slot = LAZYACCESS(hive.used_slots, selected_caste)
	if(free_slot > used_slot)
		return TRUE

	var/used_tier_2_slots = length(hive.tier_2_xenos)
	var/used_tier_3_slots = length(hive.tier_3_xenos)
	for(var/caste_path in hive.free_slots)
		var/slots_free = hive.free_slots[caste_path]
		var/slots_used = hive.used_slots[caste_path]
		if(!slots_used)
			continue
		var/datum/caste_datum/current_caste = caste_path
		switch(initial(current_caste.tier))
			if(2)
				used_tier_2_slots -= min(slots_used, slots_free)
			if(3)
				used_tier_3_slots -= min(slots_used, slots_free)

	var/burrowed_factor = min(hive.stored_larva, sqrt(4*hive.stored_larva))
	var/totalXenos = floor(burrowed_factor)
	for(var/mob/living/carbon/xenomorph/xeno as anything in hive.totalXenos)
		if(xeno.counts_for_slots)
			totalXenos++

	if(tier == 1 && (((used_tier_2_slots + used_tier_3_slots) / totalXenos) * hive.tier_slot_multiplier) >= 0.5 && castepick != XENO_CASTE_QUEEN)
		to_chat(src, SPAN_WARNING("The hive cannot support another Tier 2, wait for either more aliens to be born or someone to die."))
		return FALSE
	else if(tier == 2 && ((used_tier_3_slots / totalXenos) * hive.tier_slot_multiplier) >= 0.20 && castepick != XENO_CASTE_QUEEN)
		to_chat(src, SPAN_WARNING("The hive cannot support another Tier 3, wait for either more aliens to be born or someone to die."))
		return FALSE
	else if(hive.allow_queen_evolve && !hive.living_xeno_queen && potential_queens == 1 && islarva(src) && castepick != XENO_CASTE_DRONE)
		to_chat(src, SPAN_XENONOTICE("В улье сейчас нет сестры, которая могла бы стать Королевой! Вы должны стать дроном, чтобы улей выжил!"))
		return FALSE

	return TRUE
