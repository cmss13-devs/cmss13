/datum/xeno_strain/alchemist
	name = SPITTER_ALCHEMIST
	description = "In exchange for your acid, normal tail stab and base abilities, gain the ability to select, produce or remove three toxic chemicals into a stockpile and inject the entirety of it into opponents at once, with the effect depending on chemical pairing. Based on Tail Stab, Tail Injection takes all chemicals in your stockpile and injects them all into your opponent, with cooldown depending on how much you have injected at once. Select Chemical allows you to select a chemical to produce, Produce Chemical has a 1.5 second channel to add a little bit to your stockpile, and Remove Chemical allows you to remove the entirety of whatever chemical you have selected from your stockpile."
	flavor_description = "This one shall be the cauldron in which draughts of suffering shall be brewed and given to our enemies."
	icon_state_prefix = "Alchemist"

	actions_to_remove = list(
		/datum/action/xeno_action/activable/tail_stab/spitter,
		/datum/action/xeno_action/activable/corrosive_acid,
		/datum/action/xeno_action/activable/xeno_spit,
		/datum/action/xeno_action/onclick/charge_spit,
		/datum/action/xeno_action/activable/spray_acid/spitter,
	)
	actions_to_add = list(
		/datum/action/xeno_action/activable/tail_inject,
		/datum/action/xeno_action/onclick/select_alchem,
		/datum/action/xeno_action/onclick/produce_alchem,
		/datum/action/xeno_action/onclick/remove_alchem,
	)

	behavior_delegate_type = /datum/behavior_delegate/spitter_alchemist

/datum/xeno_strain/alchemist/apply_strain(mob/living/carbon/xenomorph/spitter/spitter)
	spitter.armor_modifier += XENO_ARMOR_MOD_VERY_SMALL
	spitter.speed_modifier += XENO_SPEED_SLOWMOD_TIER_4
	spitter.plasmapool_modifier = 0.5
	spitter.plasma_types -= PLASMA_NEUROTOXIN
	spitter.plasma_types += PLASMA_PHEROMONE // Alchemist Spitter got some funky shit in their alien bloodstream

	spitter.recalculate_everything()

/datum/behavior_delegate/spitter_alchemist
	name = "Alchemist Spitter Behavior Delegate"

	var/total_pool = 0
	var/total_pool_cap = 30
	var/sagunine_pool = 0
	var/cholinine_pool = 0
	var/noctine_pool = 0

	var/current_alchem = null
	var/producing_alchem = FALSE
	var/slash_generation = 1

	var/sagunine_present = 1
	var/cholinine_present = 2
	var/noctine_present = 3
	var/alchem_combination = 0

	var/final_alchem_name = null
	var/final_alchem_reagent = null
	var/final_alchem_source = null

	var/alchem_xeno_effect = null
	var/alchem_xeno_debuff = null

/datum/behavior_delegate/spitter_alchemist/append_to_stat()
	. = list()
	. += "Stockpiled chemicals: [total_pool] / [total_pool_cap]"
	if(sagunine_pool > 0)
		. += "Sagunine stockpiled: [sagunine_pool]"
	if(cholinine_pool > 0)
		. += "Cholinine stockpiled: [cholinine_pool]"
	if(noctine_pool > 0)
		. += "Noctine stockpiled: [noctine_pool]"

/datum/behavior_delegate/spitter_alchemist/melee_attack_additional_effects_self()
	if(current_alchem == null)
		return
	if(total_pool == total_pool_cap)
		return
	total_pool += slash_generation
	switch(current_alchem)
		if("sagunine")
			sagunine_pool += slash_generation
		if("cholinine")
			cholinine_pool += slash_generation
		if("noctine")
			noctine_pool += slash_generation

/datum/behavior_delegate/spitter_alchemist/proc/choose_alchem(alchem)
	if(bound_xeno.client.prefs && bound_xeno.client.prefs.no_radials_preference)
		alchem = tgui_input_list(bound_xeno, "Choose a pheromone", "Pheromone Menu", "sagunine" + "cholinine" + "noctine" + "nothing" + "help" + "cancel", theme="hive_status")
		if(alchem == "help")
			to_chat(bound_xeno, SPAN_NOTICE("<br>You can choose between three unique toxic chemicals to produce with Stockpile and inject into humanoid targets with Injection, with varying effects:<br><B>Sagunine</B> - Deals brute damage and purges Bicardine and Meralyne.<br><B>Cholinine</B> - Deals burn damage and purges Kelotane and Dermaline.<br><B>Noctine</B> - Induces a fair bit of pain and purges Paracetamol, Tramadol and Oxycodone.<br>Stockpiling different chemicals causes them blend together upon Injecting someone to produce a different effect. This happens automatically and regardless of amount stored.<br><B>Experiment!</B><br>"))
			return
		if(alchem == "nothing")
			if(current_alchem != null)
				current_alchem = null
				to_chat(bound_xeno, SPAN_XENOWARNING("We relax our body from producing chemicals!"))
			return
		if(!alchem || alchem == "cancel" || !bound_xeno.check_state(1)) //If they are stacking windows, disable all input
			return
	else
		var/static/list/alchem_selections = list("Help" = image(icon = 'icons/mob/radial.dmi', icon_state = "radial_help"), "Sagunine" = image(icon = 'icons/mob/radial.dmi', icon_state = "phero_frenzy"), "Cholinine" = image(icon = 'icons/mob/radial.dmi', icon_state = "phero_warding"), "Noctine" = image(icon = 'icons/mob/radial.dmi', icon_state = "phero_recov"), "Nothing" = image(icon = 'icons/mob/radial.dmi', icon_state = "radial_center_focus"))
		alchem = lowertext(show_radial_menu(bound_xeno, bound_xeno.client?.eye, alchem_selections))
		if(alchem == "help")
			to_chat(bound_xeno, SPAN_NOTICE("<br>You can choose between three unique toxic chemicals to produce with Stockpile and inject into humanoid targets with Injection, with varying effects:<br><B>Sagunine</B> - Deals brute damage and purges Bicardine and Meralyne.<br><B>Cholinine</B> - Deals burn damage and purges Kelotane and Dermaline.<br><B>Noctine</B> - Induces a fair bit of pain and purges Paracetamol, Tramadol and Oxycodone.<br>Stockpiling different chemicals causes them blend together upon Injecting someone to produce a different effect. This happens automatically and regardless of amount stored.<br><B>Experiment!</B><br>"))
			return
		if(alchem == "nothing")
			if(current_alchem != null)
				current_alchem = null
				to_chat(bound_xeno, SPAN_XENOWARNING("We relax our body from producing chemicals!"))
			return
		if(!alchem || !bound_xeno.check_state(1)) //If they are stacking windows, disable all input
			return
	if(alchem)
		if(alchem == current_alchem)
			to_chat(bound_xeno, SPAN_XENOWARNING("We're already producing [alchem]!"))
			return
		current_alchem = alchem
		to_chat(bound_xeno, SPAN_XENOWARNING("We shift our body to produce [alchem]!"))
		playsound(bound_xeno.loc, "alien_drool", 25)

/datum/behavior_delegate/spitter_alchemist/proc/stockpile_alchem(amount = 2, alchem = current_alchem)
	total_pool += amount
	var/overcap_reduction = 0
	if(total_pool > total_pool_cap)
		overcap_reduction = total_pool - total_pool_cap
		total_pool -= overcap_reduction
	switch(alchem)
		if("sagunine")
			sagunine_pool += (amount - overcap_reduction)
		if("cholinine")
			cholinine_pool += (amount - overcap_reduction)
		if("noctine")
			noctine_pool += (amount - overcap_reduction)

	to_chat(bound_xeno, SPAN_XENOWARNING("We produce [alchem] and add it to our chemical stockpile!"))
	playsound(bound_xeno.loc, "alien_drool", 25)
	overcap_reduction = 0

/datum/behavior_delegate/spitter_alchemist/proc/remove_alchem(alchem = current_alchem)
	var/no_chem_to_purge = FALSE
	switch(alchem)
		if("sagunine")
			if(sagunine_pool != 0)
				total_pool -= sagunine_pool
				sagunine_pool = 0
			else
				no_chem_to_purge = TRUE
		if("cholinine")
			if(cholinine_pool != 0)
				total_pool -= cholinine_pool
				cholinine_pool = 0
			else
				no_chem_to_purge = TRUE
		if("noctine")
			if(noctine_pool != 0)
				total_pool -= noctine_pool
				noctine_pool = 0
			else
				no_chem_to_purge = TRUE

	if(no_chem_to_purge)
		to_chat(bound_xeno, SPAN_XENOWARNING("We don't have any [alchem] to purge!"))
	else
		to_chat(bound_xeno, SPAN_XENOWARNING("We purge all [alchem] from our chemical stockpile!"))
		playsound(bound_xeno.loc, "alien_drool", 25)

/datum/behavior_delegate/spitter_alchemist/proc/empty_entire_stockpile()
	sagunine_pool = 0
	cholinine_pool = 0
	noctine_pool = 0
	total_pool = 0
	alchem_combination = 0
	final_alchem_name = null
	final_alchem_reagent = null
	final_alchem_source = null

/datum/behavior_delegate/spitter_alchemist/proc/parse_final_alchem()
	if(sagunine_pool > 0)
		alchem_combination += 1

	if(cholinine_pool > 0)
		alchem_combination += 2

	if(noctine_pool > 0)
		alchem_combination += 4

	switch(alchem_combination)
		if(1) // Sagunine
			final_alchem_name = "Saguinine"
			final_alchem_reagent = "xenoalch_brute"
			final_alchem_source = /datum/reagent/toxin/alchemic/sagunine
		if(2) // Cholinine
			final_alchem_name = "Cholinine"
			final_alchem_reagent = "xenoalch_burn"
			final_alchem_source = /datum/reagent/toxin/alchemic/cholinine
		if(3) // Sagunine + Cholinine = Pyrinine
			final_alchem_name = "Pyrinine"
			final_alchem_reagent = "xenoalch_fire"
			final_alchem_source = /datum/reagent/toxin/alchemic/pyrinine
		if(4) // Noctine
			final_alchem_name = "Noctine"
			final_alchem_reagent = "xenoalch_pain"
			final_alchem_source = /datum/reagent/toxin/alchemic/noctine
		if(5) // Noctine + Sagunine = Vapinine
			final_alchem_name = "Vapinine"
			final_alchem_reagent = "xenoalch_bloodloss"
			final_alchem_source = /datum/reagent/toxin/alchemic/vapinine
		if(6) // Noctine + Cholinine = Crynine
			final_alchem_name = "Crynine"
			final_alchem_reagent = "xenoalch_freeze"
			final_alchem_source = /datum/reagent/toxin/alchemic/crynine
		if(7) // Noctine + Sagunine + Cholinine = Xenosterine
			final_alchem_name = "Xenosterine"
			final_alchem_reagent = "xenoalch_purge"
			final_alchem_source = /datum/reagent/toxin/alchemic/xenosterine

/datum/behavior_delegate/spitter_alchemist/proc/final_alchem_info(mob/living/carbon/target)
	if(isxeno(target))
		if(bound_xeno.can_not_harm(target))
			switch(final_alchem_name)
				if("Saguinine")
					to_chat(bound_xeno, SPAN_XENOWARNING("We catalyzed Saguinine! It restore some of our target's health!"))
				if("Cholinine")
					to_chat(bound_xeno, SPAN_XENOWARNING("We catalyzed Cholinine! It restore some of our target's health!"))
				if("Noctine")
					to_chat(bound_xeno, SPAN_XENOWARNING("We catalyzed Noctine! It will temporarily harden our target's' carapace!"))
				if("Pyrinine")
					to_chat(bound_xeno, SPAN_XENOWARNING("We catalyzed Pyrinine! It will temporarily strengthen our target's' claws!"))
				if("Vapinine")
					to_chat(bound_xeno, SPAN_XENOWARNING("We catalyzed Vapinine! It will restore some of our target's blood!"))
				if("Crynine")
					to_chat(bound_xeno, SPAN_XENOWARNING("We catalyzed Crynine! It will temporarily increase our target's speed!"))
				if("Xenosterine")
					to_chat(bound_xeno, SPAN_XENOWARNING("We catalyzed Xenosterine! It will render our target fireproof!"))
		else
			switch(final_alchem_name)
				if("Saguinine")
					to_chat(bound_xeno, SPAN_XENOWARNING("We catalyzed Saguinine! It harm our target slightly!"))
				if("Cholinine")
					to_chat(bound_xeno, SPAN_XENOWARNING("We catalyzed Cholinine! It harm our target slightly!"))
				if("Noctine")
					to_chat(bound_xeno, SPAN_XENOWARNING("We catalyzed Noctine! It will temporarily weaken our target's' carapace!"))
				if("Pyrinine")
					to_chat(bound_xeno, SPAN_XENOWARNING("We catalyzed Pyrinine! It will temporarily weaken our target's' claws!"))
				if("Vapinine")
					to_chat(bound_xeno, SPAN_XENOWARNING("We catalyzed Vapinine! It will drain some of our target's blood!"))
				if("Crynine")
					to_chat(bound_xeno, SPAN_XENOWARNING("We catalyzed Crynine! It will temporarily decrease our target's speed!"))
				if("Xenosterine")
					to_chat(bound_xeno, SPAN_XENOWARNING("We catalyzed Xenosterine! It will temporarily block our target from their hivemind!"))
	else
		switch(final_alchem_name)
			if("Saguinine")
				to_chat(bound_xeno, SPAN_XENOWARNING("We catalyzed Saguinine! It will deal brute damage and purge most chemicals that recover it!"))
			if("Cholinine")
				to_chat(bound_xeno, SPAN_XENOWARNING("We catalyzed Cholinine! It will deal burn damage and purge most chemicals that recover it!"))
			if("Noctine")
				to_chat(bound_xeno, SPAN_XENOWARNING("We catalyzed Noctine! It will induce large amounts of pain and purge most chemicals that alleviate it!"))
			if("Pyrinine")
				to_chat(bound_xeno, SPAN_XENOWARNING("We catalyzed Pyrinine! It will increase body temperature to almost burning!"))
			if("Vapinine")
				to_chat(bound_xeno, SPAN_XENOWARNING("We catalyzed Vapinine! It will drain blood!"))
			if("Crynine")
				to_chat(bound_xeno, SPAN_XENOWARNING("We catalyzed Crynine! It will decrease body temperature to almost freezing!"))
			if("Xenosterine")
				to_chat(bound_xeno, SPAN_XENOWARNING("We catalyzed Xenosterine! It will rapidly purge any chemical that isn't a toxin!"))

/datum/behavior_delegate/spitter_alchemist/proc/alchem_xeno_reaction(mob/living/carbon/xenomorph/target)
	target.xeno_jitter(1 SECONDS)
	if(!bound_xeno.can_not_harm(target))
		switch(final_alchem_name)
			if("Saguinine") // Just does bonus damage
				to_chat(target, SPAN_XENOWARNING("You feel like something has just ruptured!"))
				target.apply_damage(total_pool * XVX_UNIVERSAL_DAMAGEMULT)
			if("Cholinine") // Also just does bonus damage
				to_chat(target, SPAN_XENOWARNING("You feel like you're burning!"))
				target.apply_damage(total_pool * XVX_UNIVERSAL_DAMAGEMULT)
			if("Noctine") // Weakens armor
				target.AddComponent(/datum/component/status_effect/xeno_stat_debuff/armor_debuff, total_pool)
			if("Pyrinine") // Weakens slash damage
				target.AddComponent(/datum/component/status_effect/xeno_stat_debuff/slash_debuff, total_pool)
			if("Vapinine") // Drains plasma
				if(target.plasma_max > 0)
					target.plasma_stored = max(target.plasma_stored - (target.plasma_max * (total_pool / 150)), 0)
					to_chat(target, SPAN_WARNING("You feel your plasma reserves being drained!"))
			if("Crynine") // Slows down
				target.AddComponent(/datum/component/status_effect/xeno_stat_debuff/speed_debuff, total_pool)
			if("Xenosterine") // Blocks hivemind
				target.AddComponent(/datum/component/status_effect/interference, total_pool)
	else
		switch(final_alchem_name)
			if("Saguinine") // Heals a small bit
				new /datum/effects/heal_over_time(target, heal_amount = 5 * total_pool)
			if("Cholinine") // Also heals a small bit
				new /datum/effects/heal_over_time(target, heal_amount = 5 * total_pool)
			if("Noctine") // Temporarily buffs armor
				target.AddComponent(/datum/component/status_effect/xeno_stat_buff/armor_buff, total_pool)
			if("Pyrinine") // Temporarily buffs slash
				target.AddComponent(/datum/component/status_effect/xeno_stat_buff/slash_buff, total_pool)
			if("Vapinine") // Recovers some plasma
				target.plasma_stored = max(target.plasma_stored + (target.plasma_max * (total_pool / 150)), 0)
				to_chat(target, SPAN_WARNING("You feel a surge of plasma!"))
			if("Crynine") // Temporarily boosts speed
				target.AddComponent(/datum/component/status_effect/xeno_stat_buff/speed_buff, total_pool)
			if("Xenosterine") // Makes fireproof
				target.AddComponent(/datum/component/status_effect/xeno_stat_buff/fireproof_buff, total_pool)

// Powers

/datum/action/xeno_action/activable/tail_inject/use_ability(atom/target)
	var/mob/living/carbon/xenomorph/xeno = owner
	var/datum/behavior_delegate/spitter_alchemist/alchemist = xeno.behavior_delegate
	var/mob/living/carbon/carbon = target

	if(!isxeno(xeno))
		return

	if(!istype(xeno.behavior_delegate, alchemist))
		return

	if(!action_cooldown_check())
		return

	if(!xeno.check_state())
		return

	if(get_dist(xeno, target) > 2)
		return

	if(alchemist.producing_alchem)
		to_chat(xeno, SPAN_XENOWARNING("We should wait until we've finished making chemicals!"))
		return

	var/list/turf/path = get_line(xeno, target, include_start_atom = FALSE)
	for(var/turf/path_turf as anything in path)
		if(path_turf.density)
			to_chat(xeno, SPAN_WARNING("There's something blocking us from striking!"))
			return
		var/atom/barrier = path_turf.handle_barriers(A = xeno , pass_flags = (PASS_MOB_THRU_XENO|PASS_OVER_THROW_MOB|PASS_TYPE_CRAWLER))
		if(barrier != path_turf)
			to_chat(xeno, SPAN_WARNING("There's something blocking us from striking!"))
			return
		for(var/obj/structure/current_structure in path_turf)
			if(current_structure.density && !current_structure.throwpass)
				to_chat(xeno, SPAN_WARNING("There's something blocking us from striking!"))
				return

	if(!iscarbon(target) && carbon.stat == DEAD)
		xeno.visible_message(SPAN_XENOWARNING("\The [xeno] swipes their tail through the air!"), SPAN_XENOWARNING("We swipe our tail through the air!"))
		apply_cooldown(0.2)
		playsound(xeno, 'sound/effects/alien_tail_swipe1.ogg', 50, TRUE)
		return

	if(xeno.can_not_harm(carbon) && ishuman(carbon)|| islarva(carbon)) // Don't want to try using on friendly humans or larva
		return

	var/obj/limb/target_limb = carbon.get_limb(check_zone(xeno.zone_selected))
	if(ishuman(target) && (!target_limb || (target_limb.status & LIMB_DESTROYED)))
		target_limb = carbon.get_limb("chest")

	alchemist.parse_final_alchem()
	if(alchemist.final_alchem_reagent != null && alchemist.final_alchem_source != null)
		if(isxeno(target))
			var/mob/living/carbon/xenomorph/xenoid = target
			alchemist.alchem_xeno_reaction(xenoid)

		if(!xeno.can_not_harm(carbon) && ishuman(target) && !issynth(target) && !HAS_TRAIT(target, TRAIT_NESTED) && carbon.status_flags & XENO_HOST)
			var/mob/living/carbon/human/humanoid = target
			if(isyautja(humanoid))
				humanoid.reagents.add_reagent(alchemist.final_alchem_reagent, alchemist.total_pool / 2)
				humanoid.reagents.set_source_mob(xeno, alchemist.final_alchem_source)
			else
				humanoid.reagents.add_reagent(alchemist.final_alchem_reagent, alchemist.total_pool)
				humanoid.reagents.set_source_mob(xeno, alchemist.final_alchem_source)
		alchemist.final_alchem_info(carbon)
		if(alchemist.total_pool > 14)
			alchem_cooldown_modifier = alchemist.total_pool * 0.07
		else
			alchem_cooldown_modifier = 1
		alchemist.empty_entire_stockpile()
		check_and_use_plasma_owner()

	if(!xeno.can_not_harm(carbon))
		xeno.visible_message(SPAN_XENOWARNING("[xeno] stabs [carbon] in the [target_limb ? target_limb.display_name : "chest"] with their tail!"), \
		SPAN_XENOWARNING("We stab [carbon] in the [target_limb ? target_limb.display_name : "chest"] with our tail!"))
		playsound(carbon,'sound/weapons/alien_tail_attack.ogg', 50, TRUE)

		carbon.apply_armoured_damage(get_xeno_damage_slash(target, xeno.caste.melee_damage_lower), ARMOR_MELEE, BRUTE, target_limb ? target_limb.name : "chest")
		carbon.last_damage_data = create_cause_data(xeno.caste_type, xeno)
		log_attack("[key_name(xeno)] attacked [key_name(carbon)] with Tail Injection")
	else
		xeno.visible_message(SPAN_XENOWARNING("[xeno] gently jabs [carbon] with their tail!"), \
		SPAN_XENOWARNING("We gently jab our tail into [carbon], making sure not to harm them!"))
		playsound(xeno, 'sound/effects/alien_tail_swipe1.ogg', 50, TRUE)
		if(alchemist.final_alchem_name == null)
			alchem_cooldown_modifier = 0.2
	var/stab_direction
	stab_direction = turn(get_dir(xeno, target), 180)

	/// To reset the direction if they haven't moved since then in below callback.
	var/last_dir = xeno.dir

	xeno.setDir(stab_direction)
	xeno.flick_attack_overlay(target, "tail")
	xeno.animation_attack_on(target)

	var/new_dir = xeno.dir
	addtimer(CALLBACK(src, PROC_REF(reset_direction), xeno, last_dir, new_dir), 0.5 SECONDS)

	apply_cooldown(alchem_cooldown_modifier)
	return ..()

/datum/action/xeno_action/activable/tail_inject/proc/reset_direction(mob/living/carbon/xenomorph/xeno, last_dir, new_dir)
	// If the xenomorph is still holding the same direction as the tail stab animation's changed it to, reset it back to the old direction so the xenomorph isn't stuck facing backwards.
	if(new_dir == xeno.dir)
		xeno.setDir(last_dir)

/datum/action/xeno_action/onclick/select_alchem/use_ability(atom/target)
	var/mob/living/carbon/xenomorph/xeno = owner
	var/datum/behavior_delegate/spitter_alchemist/alchemist = xeno.behavior_delegate

	if(!isxeno(xeno))
		return

	if(!istype(xeno.behavior_delegate, alchemist))
		return

	if(!xeno.check_state())
		return

	if(alchemist.producing_alchem)
		to_chat(xeno, SPAN_XENOWARNING("We cannot change what chemicals to produce while producing chemicals!"))
		return

	alchemist.choose_alchem()
	return ..()

/datum/action/xeno_action/onclick/produce_alchem/use_ability(atom/target)
	var/mob/living/carbon/xenomorph/xeno = owner
	var/datum/behavior_delegate/spitter_alchemist/alchemist = xeno.behavior_delegate

	if(!isxeno(xeno))
		return

	if(!istype(xeno.behavior_delegate, alchemist))
		return

	if(!action_cooldown_check())
		return

	if(!xeno.check_state())
		return

	if(alchemist.total_pool == alchemist.total_pool_cap)
		to_chat(xeno, SPAN_XENOWARNING("We cannot stockpile any more chemicals!"))
		return

	if(alchemist.current_alchem == null)
		to_chat(xeno, SPAN_XENOWARNING("We haven't chosen any chemical to produce!"))
		return

	if(alchemist.producing_alchem)
		to_chat(xeno, SPAN_XENOWARNING("We're already making chemicals!"))
		return

	if(!check_plasma_owner())
		return

	alchemist.producing_alchem = TRUE
	if(!do_after(xeno, 2 SECONDS, INTERRUPT_ALL, BUSY_ICON_HOSTILE))
		alchemist.producing_alchem = FALSE
		return
	alchemist.producing_alchem = FALSE
	alchemist.stockpile_alchem(amount)
	use_plasma_owner()
	apply_cooldown()
	return ..()

/datum/action/xeno_action/onclick/remove_alchem/use_ability(atom/target)
	var/mob/living/carbon/xenomorph/xeno = owner
	var/datum/behavior_delegate/spitter_alchemist/alchemist = xeno.behavior_delegate

	if(!isxeno(xeno))
		return

	if(!istype(xeno.behavior_delegate, alchemist))
		return

	if(!action_cooldown_check())
		return

	if(!xeno.check_state())
		return

	if(alchemist.total_pool == 0)
		to_chat(xeno, SPAN_XENOWARNING("We have no chemicals to remove!"))
		return

	if(alchemist.current_alchem == null)
		to_chat(xeno, SPAN_XENOWARNING("We haven't chosen any chemical for our body to remove!"))
		return

	if(alchemist.producing_alchem)
		to_chat(xeno, SPAN_XENOWARNING("We cannot remove chemicals while making chemicals!"))
		return

	if(!check_plasma_owner())
		return

	alchemist.remove_alchem()
	use_plasma_owner()
	return ..()
