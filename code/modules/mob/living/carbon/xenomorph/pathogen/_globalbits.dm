/datum/admins/var/create_pathogen_creatures_html = null
/datum/admins/proc/create_pathogen_creatures(mob/user)
	if(!create_xenos_html)
		var/hive_types = XENO_HIVE_PATHOGEN
		var/xeno_types = jointext(ALL_PATHOGEN_CREATURES, ";")
		create_pathogen_creatures_html = file2text('html/create_xenos.html')
		create_pathogen_creatures_html = replacetext(create_pathogen_creatures_html, "null /* hive paths */", "\"[hive_types]\"")
		create_pathogen_creatures_html = replacetext(create_pathogen_creatures_html, "null /* xeno paths */", "\"[xeno_types]\"")
		create_pathogen_creatures_html = replacetext(create_pathogen_creatures_html, "/* href token */", RawHrefToken(forceGlobal = TRUE))

	show_browser(user, replacetext(create_pathogen_creatures_html, "/* ref src */", "\ref[src]"), "Create Pathogen Creatures", "create_pathogen_creatures", width = 450, height = 630)

/client/proc/create_pathogen_creatures()
	set name = "Create Pathogen Creatures"
	set category = "Admin.Events"
	if(admin_holder)
		admin_holder.create_pathogen_creatures(usr)

/mob/living/carbon/xenomorph/proc/is_hive_ruler()
	if(hive && (hive.living_xeno_queen == src))
		return TRUE
	return FALSE

/mob/living/carbon/xenomorph/proc/give_blight_core()
	if(hivenumber == XENO_HIVE_PATHOGEN)
		give_action(src, /datum/action/xeno_action/activable/create_core)
		return TRUE
	return FALSE

//####################################################################
//####################################################################
//####################################################################

// LANGUAGE SHIT
/mob/living/carbon/xenomorph/proc/make_pathogen_speaker()
	set_languages(list(LANGUAGE_PATHOGEN, LANGUAGE_PATHOGEN_MIND))
	langchat_color = "#c2c38d"
	speaking_key = "-"

/datum/language/pathogen
	name = LANGUAGE_PATHOGEN
	color = "pathogen"
	desc = "The common tongue of the Pathogen Confluence."
	speech_verb = "clicks"
	ask_verb = "clicks"
	exclaim_verb = "clicks"
	key = "-"
	flags = RESTRICTED
	syllables = list("sss", "sSs", "SSS")

/datum/language/pathogen_mind
	name = LANGUAGE_PATHOGEN_MIND
	desc = "Pathogen Creatures have the strange ability to commune over a mycelial hivemind."
	speech_verb = "hiveminds"
	ask_verb = "hiveminds"
	exclaim_verb = "hiveminds"
	color = "pathogen"
	key = "q"//Same key as xeno hivemind because it does the same backend, it only appears different for language menu.
	flags = RESTRICTED|HIVEMIND

//Make queens BOLD text
/datum/language/pathogen_mind/broadcast(mob/living/speaker, message, speaker_mask)
	if(iscarbon(speaker))
		var/mob/living/carbon/C = speaker

		if(!(C.hivenumber in GLOB.hive_datum))
			return

		C.hivemind_broadcast(message, GLOB.hive_datum[C.hivenumber])

//####################################################################
//####################################################################
//####################################################################

/// WEEDS
/obj/effect/alien/weeds/node/pathogen
	name = "mycelium blight node"
	desc = "A weird, pulsating node."
	icon = 'icons/mob/pathogen/pathogen_weeds.dmi'
	hivenumber = XENO_HIVE_PATHOGEN
	spread_on_semiweedable = TRUE

/obj/effect/alien/weeds/pathogen
	name = "mycelium blight"
	desc = "A mycelium growth of strange origins..."
	icon = 'icons/mob/pathogen/pathogen_weeds.dmi'
	hivenumber = XENO_HIVE_PATHOGEN
	spread_on_semiweedable = TRUE

/obj/effect/alien/weeds/weedwall/pathogen
	name = "mycelium blight"
	desc = "A mycelium growth of strange origins..."
	icon = 'icons/mob/pathogen/pathogen_weeds.dmi'
	hivenumber = XENO_HIVE_PATHOGEN
	spread_on_semiweedable = TRUE

/obj/effect/alien/weeds/weedwall/window/pathogen
	name = "mycelium blight"
	desc = "A mycelium growth of strange origins..."
	icon = 'icons/mob/pathogen/pathogen_weeds.dmi'
	hivenumber = XENO_HIVE_PATHOGEN
	spread_on_semiweedable = TRUE

/obj/effect/alien/weeds/weedwall/frame/pathogen
	name = "mycelium blight"
	desc = "A mycelium growth of strange origins..."
	icon = 'icons/mob/pathogen/pathogen_weeds.dmi'
	hivenumber = XENO_HIVE_PATHOGEN
	spread_on_semiweedable = TRUE

// Ability

/datum/action/xeno_action/onclick/plant_weeds/pathogen
	name = "Spread Blight (200)"
	action_icon_state = "plant_weeds"
	plasma_cost = 200
	macro_path = /datum/action/xeno_action/verb/verb_plant_weeds
	action_type = XENO_ACTION_CLICK
	xeno_cooldown = 1 SECONDS
	ability_primacy = XENO_NOT_PRIMARY_ACTION

	plant_on_semiweedable = TRUE
	node_type = /obj/effect/alien/weeds/node/pathogen

/datum/action/xeno_action/onclick/plant_weeds/pathogen/popper
	name = "Spread Blight (100)"
	plasma_cost = 100
	ability_primacy = XENO_PRIMARY_ACTION_1

//####################################################################
//####################################################################
//####################################################################

/datum/caste_datum/var/pathogen_creature = FALSE
/datum/caste_datum/pathogen
	minimum_evolve_time = 0
	pathogen_creature = TRUE
	language = LANGUAGE_PATHOGEN
	fire_immunity = FIRE_VULNERABILITY
	fire_vulnerability_mult = FIRE_MULTIPLIER_MEDIUM

/*
/datum/caste_datum/pathogen/get_minimap_icon()
	var/image/background = mutable_appearance('icons/mob/pathogen/neo_blips.dmi', minimap_background)

	var/iconstate = minimap_icon ? minimap_icon : "unknown"
	var/mutable_appearance/icon = image('icons/mob/pathogen/neo_blips.dmi', icon_state = iconstate)
	icon.appearance_flags = RESET_COLOR
	background.overlays += icon

	return background
*/

//####################################################################
//####################################################################
//####################################################################

/datum/behavior_delegate/pathogen_base
	name = "Base Pathogen Behavior Delegate"

	// State
	var/next_slash_buffed = FALSE

#define BLIGHT_TOUCH_DELAY 6 SECONDS

/datum/behavior_delegate/pathogen_base/melee_attack_modify_damage(original_damage, mob/living/carbon/carbon_target)
	if (!next_slash_buffed)
		return original_damage

	if (!isxeno_human(carbon_target))
		return original_damage

	if(skillcheck(carbon_target, SKILL_ENDURANCE, SKILL_ENDURANCE_MAX ))
		carbon_target.visible_message(SPAN_DANGER("[carbon_target] withstands the blight!"))
		next_slash_buffed = FALSE
		return original_damage //endurance 5 makes you immune to weak blight
	if(ishuman(carbon_target))
		var/mob/living/carbon/human/human = carbon_target
		if(human.chem_effect_flags & CHEM_EFFECT_RESIST_NEURO || human.species.flags & NO_NEURO)
			human.visible_message(SPAN_DANGER("[human] shrugs off the blight!"))
			next_slash_buffed = FALSE
			return //species like zombies or synths are immune to blight
	if (next_slash_buffed)
		to_chat(bound_xeno, SPAN_XENOHIGHDANGER("We add blight into our attack, [carbon_target] is about to fall over paralyzed!"))
		to_chat(carbon_target, SPAN_XENOHIGHDANGER("You feel like you're about to fall over, as [bound_xeno] slashes you with its blight coated claws!"))
		carbon_target.sway_jitter(times = 3, steps = floor(BLIGHT_TOUCH_DELAY/3))
		carbon_target.Daze(8)
		addtimer(CALLBACK(src, PROC_REF(blight_slash), carbon_target), BLIGHT_TOUCH_DELAY)
		next_slash_buffed = FALSE
	if(!next_slash_buffed)
		var/datum/action/xeno_action/onclick/blight_slash/ability = get_action(bound_xeno, /datum/action/xeno_action/onclick/blight_slash)
		if (ability && istype(ability))
			ability.button.icon_state = "template"
	return original_damage

#undef BLIGHT_TOUCH_DELAY

/datum/behavior_delegate/pathogen_base/override_intent(mob/living/carbon/target_carbon)
	. = ..()

	if(!isxeno_human(target_carbon))
		return

	if(next_slash_buffed)
		return INTENT_HARM

/datum/behavior_delegate/pathogen_base/proc/blight_slash(mob/living/carbon/human/human_target)
	human_target.KnockDown(2)
	human_target.Stun(2)
	to_chat(human_target, SPAN_XENOHIGHDANGER("You fall over, paralyzed by the blight!"))

/datum/behavior_delegate/pathogen_base/append_to_stat()
	. = list()

	var/datum/hive_status/pathogen/hive = GLOB.hive_datum[XENO_HIVE_PATHOGEN]
	if(hive)
		. += "Pathogen Poppers: [hive.get_popper_num()]/[hive.max_poppers]"

// ################## Blight slash ##################
/datum/action/xeno_action/verb/verb_blight_slash()
	set category = "Alien"
	set name = "Blight Slash"
	set hidden = TRUE
	var/action_name = "Blight Slash"
	handle_xeno_macro(src,action_name)

/datum/action/xeno_action/onclick/blight_slash
	name = "Blight Slash"
	action_icon_state = "lurker_inject_neuro"
	macro_path = /datum/action/xeno_action/verb/verb_blight_slash
	action_type = XENO_ACTION_CLICK
	ability_primacy = XENO_NOT_PRIMARY_ACTION
	xeno_cooldown = 12 SECONDS
	plasma_cost = 50

	var/buff_duration = 50

/datum/action/xeno_action/onclick/blight_slash/use_ability(atom/target)
	var/mob/living/carbon/xenomorph/paraslash_user = owner

	if (!istype(paraslash_user))
		return

	if (!action_cooldown_check())
		return

	if (!check_and_use_plasma_owner())
		return

	var/datum/behavior_delegate/pathogen_base/behavior = paraslash_user.behavior_delegate
	if (istype(behavior))
		behavior.next_slash_buffed = TRUE

	to_chat(paraslash_user, SPAN_XENOHIGHDANGER("Our next slash will apply blight!"))
	button.icon_state = "template_active"

	addtimer(CALLBACK(src, PROC_REF(unbuff_slash)), buff_duration)

	apply_cooldown()
	return ..()

/datum/action/xeno_action/onclick/blight_slash/proc/unbuff_slash()
	var/mob/living/carbon/xenomorph/unbuffslash_user = owner
	if (!istype(unbuffslash_user))
		return
	var/datum/behavior_delegate/pathogen_base/behavior = unbuffslash_user.behavior_delegate
	if (istype(behavior))
		// In case slash has already landed
		if (!behavior.next_slash_buffed)
			return
		behavior.next_slash_buffed = FALSE

	to_chat(unbuffslash_user, SPAN_XENODANGER("We have waited too long, our slash will no longer apply blight!"))
	button.icon_state = "template"


/mob/living/carbon/xenomorph/proc/do_pathogen_evolve()
	if(!evolve_checks())
		return
	var/mob/living/carbon/human/user = hauled_mob?.resolve()
	if(user)
		to_chat(src, "Release [user] before evolving!")
		return

	var/list/castes_available = caste.evolves_to.Copy()

	// Also offer queen to any tier 1 that can evolve at all if there isn't a queen
	if(tier <= 2 && !hive.living_xeno_queen)
		castes_available |= PATHOGEN_CREATURE_OVERMIND

	for(var/caste in castes_available)
		if(GLOB.xeno_datum_list[caste].minimum_evolve_time > ROUND_TIME)
			castes_available -= caste

	if(!length(castes_available))
		to_chat(src, SPAN_WARNING("The Hive is not capable of supporting any castes we can evolve to yet."))
		return

	var/castepick
	if((client.prefs && client.prefs.no_radials_preference) || !hive.evolution_menu_images)
		castepick = tgui_input_list(src, "You are growing into a beautiful alien! It is time to choose a caste.", "Evolve", castes_available, theme="hive_status")
	else
		var/list/fancy_caste_list = list()
		for(var/caste in castes_available)
			fancy_caste_list[caste] = hive.evolution_menu_images[caste]

		castepick = show_radial_menu(src, client?.eye, fancy_caste_list)
	if(!castepick) //Changed my mind
		return

	if(castepick == PATHOGEN_CREATURE_OVERMIND && tgui_alert(src, "You are about to evolve into the overmind, which places its core on the tile you're on when evolving. This core cannot be moved and you cannot regress. Are you sure you would like to place your core here?", "Evolving to Overmind", list("Yes", "No"), FALSE) != "Yes")
		return

	if(SEND_SIGNAL(src, COMSIG_XENO_TRY_EVOLVE, castepick) & COMPONENT_OVERRIDE_EVOLVE)
		return // Message will be handled by component

	var/datum/caste_datum/caste_datum = GLOB.xeno_datum_list[castepick]
	if(caste_datum && caste_datum.minimum_evolve_time > ROUND_TIME)
		to_chat(src, SPAN_WARNING("The Hive cannot support this caste yet! ([floor((caste_datum.minimum_evolve_time - ROUND_TIME) / 10)] seconds remaining)"))
		return

	if(!evolve_checks())
		return

	if(evolution_threshold && castepick != PATHOGEN_CREATURE_OVERMIND) //Does the caste have an evolution timer? Then check it
		if(evolution_stored < evolution_threshold)
			to_chat(src, SPAN_WARNING("We must wait before evolving. Currently at: [evolution_stored] / [evolution_threshold]."))
			return

	var/mob/living/carbon/xenomorph/xeno_type = null
	xeno_type = GLOB.RoleAuthority.get_caste_by_text(castepick)

	if(isnull(xeno_type))
		to_chat(src, SPAN_WARNING("[castepick] is not a valid caste! If you're seeing this message, tell a coder!"))
		return

	to_chat(src, SPAN_XENONOTICE("It looks like the hive can support our evolution to [SPAN_BOLD(castepick)]!"))

	visible_message(SPAN_XENONOTICE("[src] begins to twist and contort."),
	SPAN_XENONOTICE("We begin to twist and contort."))
	xeno_jitter(25)
	evolving = TRUE
	var/level_to_switch_to = get_vision_level()

	if(!do_after(src, 2.5 SECONDS, INTERRUPT_INCAPACITATED|INTERRUPT_CHANGED_LYING, BUSY_ICON_HOSTILE)) // Can evolve while moving, resist or rest to cancel it.
		to_chat(src, SPAN_WARNING("We quiver, but nothing happens. Our evolution has ceased for now..."))
		evolving = FALSE
		return

	if(castepick == PATHOGEN_CREATURE_OVERMIND && hive.living_xeno_queen)
		to_chat(src, SPAN_WARNING("Another creature has become the Overmind. We remain as we are, for now."))
		return

	evolving = FALSE

	if(!isturf(loc)) //qdel'd or moved into something
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

	new_xeno.visible_message(SPAN_XENODANGER("A [new_xeno.caste.caste_type] emerges from the husk of [src]."),
	SPAN_XENODANGER("We emerge in a greater form from the husk of our old body. For the hive!"))

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


/mob/living/carbon/xenomorph/bloodburster/Initialize(mapload, mob/living/carbon/xenomorph/old_xeno, hivenumber)
	. = ..()
	make_pathogen_speaker()
/mob/living/carbon/xenomorph/bloodburster/do_evolve()
	do_pathogen_evolve()
	return

/mob/living/carbon/xenomorph/popper/Initialize(mapload, mob/living/carbon/xenomorph/old_xeno, hivenumber)
	. = ..()
	make_pathogen_speaker()
/mob/living/carbon/xenomorph/popper/do_evolve()
	do_pathogen_evolve()
	return

/mob/living/carbon/xenomorph/sprinter/Initialize(mapload, mob/living/carbon/xenomorph/old_xeno, hivenumber)
	. = ..()
	make_pathogen_speaker()
/mob/living/carbon/xenomorph/sprinter/do_evolve()
	do_pathogen_evolve()
	return

/mob/living/carbon/xenomorph/neomorph/Initialize(mapload, mob/living/carbon/xenomorph/old_xeno, hivenumber)
	. = ..()
	make_pathogen_speaker()
/mob/living/carbon/xenomorph/neomorph/do_evolve()
	do_pathogen_evolve()
	return

/mob/living/carbon/xenomorph/blight/Initialize(mapload, mob/living/carbon/xenomorph/old_xeno, hivenumber)
	. = ..()
	make_pathogen_speaker()
/mob/living/carbon/xenomorph/blight/do_evolve()
	do_pathogen_evolve()
	return

/mob/living/carbon/xenomorph/venator/Initialize(mapload, mob/living/carbon/xenomorph/old_xeno, hivenumber)
	. = ..()
	make_pathogen_speaker()
/mob/living/carbon/xenomorph/venator/do_evolve()
	do_pathogen_evolve()
	return

// Brute & Matriarch Init handled in their own files.

/mob/living/carbon/xenomorph/brute/do_evolve()
	do_pathogen_evolve()
	return
/mob/living/carbon/xenomorph/matriarch/do_evolve()
	do_pathogen_evolve()
	return

/datum/action/xeno_action/activable/mycotoxin
	name = "Mycotoxin Injection (100)"
	action_icon_state = "mycotoxin_injection"
	action_type = XENO_ACTION_CLICK
	charge_time = 2 SECONDS
	xeno_cooldown = 60 SECONDS
	ability_primacy = XENO_NOT_PRIMARY_ACTION
	var/stab_range = 2
	plasma_cost = 100
	var/matriarch_stab = FALSE

/datum/action/xeno_action/activable/mycotoxin/matriarch
	name = "Mycotoxin Injection (150)"
	plasma_cost = 150
	matriarch_stab = TRUE
	xeno_cooldown = 120 SECONDS
	stab_range = 3

/datum/action/xeno_action/activable/mycotoxin/use_ability(atom/targetted_atom)
	var/mob/living/carbon/xenomorph/stabbing_xeno = owner
	if(HAS_TRAIT(targetted_atom, TRAIT_HAULED))
		return

	if(HAS_TRAIT(stabbing_xeno, TRAIT_ABILITY_BURROWED) || stabbing_xeno.is_ventcrawling)
		to_chat(stabbing_xeno, SPAN_XENOWARNING("We must be above ground to do this."))
		return

	if(!stabbing_xeno.check_state() || stabbing_xeno.cannot_slash)
		return FALSE

	if(!action_cooldown_check())
		return FALSE

	if (world.time <= stabbing_xeno.next_move)
		return FALSE

	if(stabbing_xeno.z != targetted_atom.z)
		return

	var/distance = get_dist(stabbing_xeno, targetted_atom)
	if(distance > stab_range)
		return FALSE

	var/list/turf/path = get_line(stabbing_xeno, targetted_atom, include_start_atom = FALSE)
	for(var/turf/path_turf as anything in path)
		if(path_turf.density)
			to_chat(stabbing_xeno, SPAN_WARNING("There's something blocking our strike!"))
			return FALSE
		for(var/obj/path_contents in path_turf.contents)
			if(path_contents != targetted_atom && path_contents.density && !path_contents.throwpass)
				to_chat(stabbing_xeno, SPAN_WARNING("There's something blocking our strike!"))
				return FALSE

		var/atom/barrier = path_turf.handle_barriers(stabbing_xeno, null, (PASS_MOB_THRU_XENO|PASS_OVER_THROW_MOB|PASS_TYPE_CRAWLER))
		if(barrier != path_turf)
			var/tail_stab_cooldown_multiplier = barrier.handle_tail_stab(stabbing_xeno)
			if(!tail_stab_cooldown_multiplier)
				to_chat(stabbing_xeno, SPAN_WARNING("There's something blocking our strike!"))
			else
				apply_cooldown(cooldown_modifier = tail_stab_cooldown_multiplier)
				xeno_attack_delay(stabbing_xeno)
			return FALSE

	var/tail_stab_cooldown_multiplier = targetted_atom.handle_tail_stab(stabbing_xeno)
	if(tail_stab_cooldown_multiplier)
		stabbing_xeno.animation_attack_on(targetted_atom)
		apply_cooldown(cooldown_modifier = tail_stab_cooldown_multiplier)
		xeno_attack_delay(stabbing_xeno)
		return ..()

	if(!ishuman(targetted_atom))
		stabbing_xeno.visible_message(SPAN_XENOWARNING("\The [stabbing_xeno] swipes their tail through the air!"), SPAN_XENOWARNING("We swipe our tail through the air!"))
		apply_cooldown(cooldown_modifier = 0.1)
		xeno_attack_delay(stabbing_xeno)
		playsound(stabbing_xeno, "alien_tail_swipe", 50, TRUE)
		return FALSE

	if(stabbing_xeno.can_not_harm(targetted_atom))
		return FALSE

	var/mob/living/carbon/human/target = targetted_atom
	var/mostly_dead = FALSE
	if(target.stat & DEAD)
		if(world.time > target.timeofdeath + target.revive_grace_period - 1 MINUTES)
			mostly_dead = TRUE

	if(!matriarch_stab && !mostly_dead)
		to_chat(stabbing_xeno, SPAN_PATHOGEN_LEADER("You cannot inject this target with mycotoxin, their body still functions!"))
		return FALSE

	if(HAS_TRAIT(target, TRAIT_NESTED))
		return FALSE

	var/obj/limb/limb = target.get_limb(check_zone(stabbing_xeno.zone_selected))
	if (ishuman(target) && (!limb || (limb.status & LIMB_DESTROYED)))
		to_chat(stabbing_xeno, (SPAN_WARNING("What [limb.display_name]?")))
		return FALSE

	if(!check_and_use_plasma_owner())
		return FALSE

	var/result = ability_act(stabbing_xeno, target, limb)

	apply_cooldown()
	xeno_attack_delay(stabbing_xeno)
	..()
	return result

/datum/action/xeno_action/activable/mycotoxin/proc/ability_act(mob/living/carbon/xenomorph/stabbing_xeno, mob/living/carbon/human/target, obj/limb/limb)

	target.last_damage_data = create_cause_data(initial(stabbing_xeno.caste_type), stabbing_xeno)

	/// To reset the direction if they haven't moved since then in below callback.
	var/last_dir = stabbing_xeno.dir
	/// Direction var to make the tail stab look cool and immersive.
	var/stab_direction = turn(get_dir(stabbing_xeno, target), 180)

	stabbing_xeno.visible_message(SPAN_XENOWARNING("\The [stabbing_xeno] skewers [target] through the [limb ? limb.display_name : "chest"] with its razor sharp tail!"), SPAN_XENOWARNING("We skewer [target] through the [limb? limb.display_name : "chest"] with our razor sharp tail!"))
	playsound(target, "alien_bite", 50, TRUE)
	// The xeno flips around for a second to impale the target with their tail. These look awsome.
	stab_direction = turn(get_dir(stabbing_xeno, target), 180)
	log_attack("[key_name(stabbing_xeno)] injected [key_name(target)] with mycotoxin at [get_area_name(stabbing_xeno)]")
	target.attack_log += text("\[[time_stamp()]\] <font color='orange'>was injected with mycotoxin by [key_name(stabbing_xeno)]</font>")
	stabbing_xeno.attack_log += text("\[[time_stamp()]\] <font color='red'>injected [key_name(target)] with mycotoxin</font>")

	if(last_dir != stab_direction)
		stabbing_xeno.setDir(stab_direction)
		stabbing_xeno.emote("tail")
		/// Ditto.
		var/new_dir = stabbing_xeno.dir
		addtimer(CALLBACK(src, PROC_REF(reset_direction), stabbing_xeno, last_dir, new_dir), 0.5 SECONDS)

	stabbing_xeno.animation_attack_on(target)
	stabbing_xeno.flick_attack_overlay(target, "tail")
	var/message = "You have injected [target] with mycotoxin! If they perish with this toxin in their body they will rise again at your service!"
	if(matriarch_stab) // Only the Matriarch can inject into a living target.
		var/damage = (stabbing_xeno.melee_damage_upper + stabbing_xeno.frenzy_aura * FRENZY_DAMAGE_MULTIPLIER) * TAILSTAB_MOB_DAMAGE_MULTIPLIER

		if(stabbing_xeno.behavior_delegate)
			stabbing_xeno.behavior_delegate.melee_attack_additional_effects_target(target)
			stabbing_xeno.behavior_delegate.melee_attack_additional_effects_self()
			damage = stabbing_xeno.behavior_delegate.melee_attack_modify_damage(damage, target)

		target.apply_armoured_damage(get_xeno_damage_slash(target, damage), ARMOR_MELEE, BRUTE, limb ? limb.name : "chest")
		if(stabbing_xeno.mob_size >= MOB_SIZE_BIG)
			target.apply_effect(3, DAZE)
		else if(stabbing_xeno.mob_size == MOB_SIZE_XENO)
			target.apply_effect(1, DAZE)
		shake_camera(target, 2, 1)

		target.reagents.add_reagent("mycotoxin_e", 4)
		target.reagents.set_source_mob(owner, /datum/reagent/toxin/mycotoxin/enhanced)
	else
		target.reagents.add_reagent("mycotoxin", 6)
		target.reagents.set_source_mob(owner, /datum/reagent/toxin/mycotoxin)
		message = "You have injected [target] with mycotoxin! They will rise again in service to the Overmind!"

	to_chat(target, SPAN_HIGHDANGER("You are injected with a powerful mycotoxin by [stabbing_xeno]!"))
	to_chat(stabbing_xeno, SPAN_PATHOGEN_QUEEN(message))

	target.handle_blood_splatter(get_dir(owner.loc, target.loc))
	return target

/datum/action/xeno_action/activable/mycotoxin/proc/reset_direction(mob/living/carbon/xenomorph/stabbing_xeno, last_dir, new_dir)
	// If the xenomorph is still holding the same direction as the tail stab animation's changed it to, reset it back to the old direction so the xenomorph isn't stuck facing backwards.
	if(new_dir == stabbing_xeno.dir)
		stabbing_xeno.setDir(last_dir)
