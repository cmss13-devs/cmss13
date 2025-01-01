/datum/action/xeno_action/activable/retrieve_hugger_egg/use_ability(atom/thing)
	var/mob/living/carbon/xenomorph/reaper/xeno = owner

	if(thing == xeno)
		var/action_icon_result
		if(getting_egg == TRUE)
			action_icon_result = "throw_hugger"
			to_chat(xeno, SPAN_XENONOTICE("We will now retrieve facehuggers from our storage."))
			getting_egg = FALSE
		else
			action_icon_result = "retrieve_egg"
			to_chat(xeno, SPAN_XENONOTICE("We will now retrieve eggs from our storage."))
			getting_egg = TRUE
		button.overlays.Cut()
		button.overlays += image('icons/mob/hud/actions_xeno.dmi', button, action_icon_result)
		return ..()

	if(getting_egg)
		xeno.retrieve_egg(thing)
	else
		xeno.retrieve_hugger(thing)
	return ..()

/datum/action/xeno_action/onclick/set_hugger_reserve_reaper/use_ability(atom/target)
	var/mob/living/carbon/xenomorph/reaper/xeno = owner
	xeno.huggers_reserved = tgui_input_number(usr,
		"How many facehuggers would you like to keep safe from Observers wanting to join as facehuggers?",
		"How many to reserve?",
		xeno.huggers_reserved, xeno.huggers_max, 0
	)
	to_chat(xeno, SPAN_XENONOTICE("We reserve [xeno.huggers_reserved] facehuggers for ourself."))
	return ..()

/datum/action/xeno_action/activable/haul_corpse/use_ability(atom/target)
	var/mob/living/carbon/xenomorph/reaper/xeno = owner
	var/mob/living/carbon/carbon = target

	if(!action_cooldown_check())
		return

	if(!xeno.check_state())
		return

	if(target == xeno)
		if(xeno.corpse_no > 0)
			corpse_retrieve(carbon)
			return
		else
			to_chat(xeno, SPAN_XENONOTICE("We aren't hauling any corpses."))
			return

	var/distance = get_dist(xeno, target)
	if((distance > 2) && !xeno.Adjacent(target))
		return

	if(!iscarbon(carbon))
		return

	if(xeno.harvesting == TRUE)
		to_chat(xeno, SPAN_XENOWARNING("We are busy harvesting!"))
		return

	if(xeno.corpse_no == xeno.corpse_max)
		to_chat(xeno, SPAN_XENOWARNING("We cannot haul more!"))
		return

	if(issynth(carbon))
		to_chat(xeno, SPAN_XENOWARNING("This one is a fake, why would we try hauling it?"))
		return

	if(!carbon.chestburst)
		to_chat(xeno, SPAN_XENOWARNING("We can only haul those that have burst."))
		return

	if(ishuman(carbon))
		corpse_add(carbon)

	return ..()

/datum/action/xeno_action/activable/haul_corpse/proc/corpse_add(mob/living/corpse)
	var/mob/living/carbon/xenomorph/reaper/xeno = owner

	xeno.visible_message(SPAN_XENONOTICE("[xeno] stabs a wing-like back limb through the gaping hole on [corpse]'s chest, lifting them into the air."), \
	SPAN_XENONOTICE("We hoist the corpse onto one of our back limbs for hauling."))
	xeno.corpses_hauled.Add(corpse)
	xeno.corpse_no += 1
	corpse.forceMove(xeno)

/datum/action/xeno_action/activable/haul_corpse/proc/corpse_retrieve(mob/living/corpse)
	var/mob/living/carbon/xenomorph/reaper/xeno = owner

	xeno.visible_message(SPAN_XENONOTICE("[xeno] deftly uses its tail to slide a corpse off one of its wing-like back limbs."), \
	SPAN_XENONOTICE("We remove a corpse from one of our back limbs."))
	for(var/atom/movable/corpse_mob in xeno.corpses_hauled)
		xeno.corpses_hauled.Remove(corpse_mob)
		xeno.corpse_no -= 1
		corpse_mob.forceMove(get_true_turf(xeno.loc))
		break

/datum/action/xeno_action/activable/flesh_harvest/use_ability(atom/target)
	var/mob/living/carbon/xenomorph/reaper/xeno = owner
	var/mob/living/carbon/carbon = target
	var/mob/living/carbon/human/victim = carbon

	if(!action_cooldown_check())
		return

	if(!iscarbon(carbon))
		return

	if(!xeno.check_state())
		return

	var/distance = get_dist(xeno, target)
	if((distance > 2) && !xeno.Adjacent(target))
		return

	if(xeno.harvesting == TRUE)
		to_chat(xeno, SPAN_XENOWARNING("We are already harvesting!"))
		return

	if(isxeno(carbon))
		return

	if(issynth(carbon))
		to_chat(xeno, SPAN_XENOWARNING("This one is a fake, we get nothing from it!"))
		return

	if(affect_living != TRUE)
		if(carbon.stat != DEAD)
			to_chat(xeno, SPAN_XENOWARNING("This one still lives, they are not suitable."))
			return

		if(victim.is_revivable(TRUE) && victim.check_tod())
			to_chat(xeno, SPAN_XENOWARNING("This one still pulses with life, they are not suitable."))
			return

	if(victim.status_flags & XENO_HOST)
		for(var/obj/item/alien_embryo/embryo in victim)
			if(HIVE_ALLIED_TO_HIVE(xeno.hivenumber, embryo.hivenumber))
				to_chat(xeno, SPAN_XENOWARNING("A sister is still growing inside this one, we should refrain from harvesting them yet."))
				return

	var/obj/limb/target_limb = victim.get_limb(check_zone(xeno.zone_selected))
	if(ishuman(carbon) && !target_limb || (target_limb.status & LIMB_DESTROYED))
		to_chat(xeno, SPAN_XENOWARNING("There is nothing to harvest!"))
		return

	xeno.face_atom(carbon)
	var/obj/limb/limb = target_limb
	switch(limb.name)
		if("head")
			cannot_harvest()
			return
		if("chest", "groin")
			burst_chest(victim, affect_living)
		if("l_arm")
			do_harvest(victim, limb)
		if("l_hand")
			limb = carbon.get_limb("l_arm")
			do_harvest(victim, limb)
		if("r_arm")
			do_harvest(victim, limb)
		if("r_hand")
			limb = carbon.get_limb("r_arm")
			do_harvest(victim, limb)
		if("l_leg")
			do_harvest(victim, limb)
		if("l_foot")
			limb = carbon.get_limb("l_leg")
			do_harvest(victim, limb)
		if("r_leg")
			do_harvest(victim, limb)
		if("r_foot")
			limb = carbon.get_limb("r_leg")
			do_harvest(victim, limb)

	apply_cooldown()
	return ..()

/datum/action/xeno_action/activable/flesh_harvest/proc/do_harvest(mob/living/carbon/carbon, obj/limb/limb)
	var/mob/living/carbon/xenomorph/reaper/xeno = owner
	var/mob/living/carbon/human/victim = carbon
	var/datum/behavior_delegate/base_reaper/reaper = xeno.behavior_delegate

	var/limb_remove_end = pick('sound/scp/firstpersonsnap.ogg','sound/scp/firstpersonsnap2.ogg')
	var/limb_remove_start = pick('sound/effects/bone_break2.ogg','sound/effects/bone_break3.ogg')

	xeno.harvesting = TRUE
	xeno.visible_message(SPAN_XENONOTICE("[xeno] reaches down and grabs [victim]'s [limb.display_name], twisting and pulling at it!"), \
	SPAN_XENONOTICE("We begin to harvest the [limb.display_name]!"))

	playsound(victim, limb_remove_start, 50, TRUE)
	if(do_after(xeno, 3 SECONDS, INTERRUPT_ALL|BEHAVIOR_IMMOBILE, BUSY_ICON_HOSTILE))
		if(!xeno.Adjacent(victim))
			to_chat(xeno, SPAN_XENOWARNING("Our harvest was interrupted!"))
			xeno.harvesting = FALSE
			return

	playsound(xeno, limb_remove_end, 25, TRUE)
	if(limb.status & (LIMB_ROBOT|LIMB_SYNTHSKIN))
		xeno.visible_message(SPAN_XENOWARNING("[xeno] wrenches off [victim]'s [limb.display_name] with a final violent motion and drops it!"), \
		SPAN_XENOWARNING("We harvest the [limb.display_name], but it's a fake! Useless!"))
		limb.droplimb(FALSE, FALSE, "flesh harvest")
	else
		xeno.visible_message(SPAN_XENOWARNING("[xeno] wrenches off [victim]'s [limb.display_name] with a final violent motion and swallows it whole!"), \
		SPAN_XENOWARNING("We harvest the [limb.display_name]!"))
		limb.droplimb(FALSE, TRUE, "flesh harvest")
		xeno.modify_flesh_plasma(harvest_gain)
	reaper.pause_decay = TRUE
	xeno.harvesting = FALSE

/datum/action/xeno_action/activable/flesh_harvest/proc/burst_chest(mob/living/carbon/carbon, burst_living = FALSE)
	var/mob/living/carbon/xenomorph/reaper/xeno = owner
	var/mob/living/carbon/human/victim = carbon
	var/datum/behavior_delegate/base_reaper/reaper = xeno.behavior_delegate

	if(victim.chestburst)
		to_chat(xeno, SPAN_XENOWARNING("A sister has already burst from them, there is nothing to harvest!"))
		return

	xeno.harvesting = TRUE
	xeno.visible_message(SPAN_XENONOTICE("[xeno] bends over and reaches [victim]!"), \
	SPAN_XENONOTICE("We prepare our inner jaw to harvest [victim]'s chest organs!"))

	if(do_after(xeno, 3 SECONDS, INTERRUPT_ALL|BEHAVIOR_IMMOBILE, BUSY_ICON_HOSTILE))
		if(!xeno.Adjacent(victim))
			to_chat(xeno, SPAN_XENOWARNING("Our harvest was interrupted!"))
			xeno.harvesting = FALSE
			return

	if(ishuman(victim))
		var/mob/living/carbon/human/victim_human = victim
		var/datum/internal_organ/organ
		var/internal
		for(internal in list("heart","lungs")) // Ripped from Embryo code for vibes, with single letter vars murdered (I wish I found this months sooner)
			organ = victim_human.internal_organs_by_name[internal]
			victim_human.internal_organs_by_name -= internal
			victim_human.internal_organs -= organ
	if(burst_living == TRUE && victim.stat != DEAD)
		var/datum/cause_data/cause = create_cause_data("reaper living burst chest", src)
		victim.last_damage_data = cause
		victim.death(cause)
	playsound(victim, 'sound/weapons/alien_bite2.ogg', 50, TRUE)
	xeno.visible_message(SPAN_XENOWARNING("[xeno]'s inner jaw shoots out of it's mouth, gouging a large hole in [victim]'s chest!"), \
	SPAN_XENOWARNING("We plunge our inner jaw into [victim]'s chest and consume their organs!"))
	victim.chestburst = 2
	victim.update_burst()
	xeno.modify_flesh_plasma(harvest_gain * 2)
	reaper.pause_decay = TRUE
	xeno.harvesting = FALSE

/datum/action/xeno_action/activable/flesh_harvest/proc/cannot_harvest()
	to_chat(owner, SPAN_XENOWARNING("This part is not worth harvesting!"))

/datum/action/xeno_action/activable/replenish/use_ability(atom/target)
	var/mob/living/carbon/xenomorph/reaper/xeno = owner
	var/mob/living/carbon/xenomorph/xeno_carbon = target

	if(!action_cooldown_check())
		return

	if(!xeno.check_state())
		return

	if(!check_plasma_owner())
		return

	if(!istype(xeno_carbon))
		return

	if(xeno.flesh_plasma < flesh_plasma_cost)
		to_chat(xeno, SPAN_XENOWARNING("We don't have enough flesh plasma, we need [flesh_plasma_cost - xeno.flesh_plasma] more!"))
		return

	if(!xeno.can_not_harm(xeno_carbon))
		to_chat(xeno, SPAN_XENODANGER("We must target an ally!"))
		return

	if(get_dist(xeno, xeno_carbon) > range)
		to_chat(xeno, SPAN_WARNING("They are too far away!"))
		return

	if(xeno_carbon.stat == DEAD)
		to_chat(xeno, SPAN_XENODANGER("We cannot heal the dead!"))
		return

	if(SEND_SIGNAL(xeno_carbon, COMSIG_XENO_PRE_HEAL) & COMPONENT_CANCEL_XENO_HEAL)
		to_chat(xeno, SPAN_XENOWARNING("We cannot help [xeno_carbon] when they're on fire!"))
		return

	if(xeno_carbon.health >= xeno_carbon.maxHealth)
		to_chat(xeno, SPAN_XENOWARNING("[xeno_carbon] is already at max health!"))
		return

	if(xeno_carbon != xeno && !xeno.Adjacent(xeno_carbon))
		plas_mod = 1
		var/obj/effect/alien/weeds/user_weeds = locate() in xeno.loc
		var/obj/effect/alien/weeds/target_weeds = locate() in xeno_carbon.loc
		if((!user_weeds && !target_weeds))
			to_chat(xeno, SPAN_XENOWARNING("We must either be adjacent to our target or both of us must be on weeds!"))
			return
		if(user_weeds.linked_hive.hivenumber != xeno.hivenumber && target_weeds.linked_hive.hivenumber != xeno.hivenumber)
			to_chat(xeno, SPAN_XENOWARNING("Both us and our target must be on allied weeds!"))
			return
	else
		plas_mod = 0.5

	xeno.face_atom(xeno_carbon)

	var/recovery_amount = xeno_carbon.maxHealth * 0.15 // 15% of the Xeno's max health feels like a good value for semi-ranged healing

	if(islarva(xeno_carbon) && islesserdrone(xeno_carbon))
		recovery_amount = xeno_carbon.maxHealth * 0.3 // 15% on these ones ain't much, so let them get 30% instead

	else if(isfacehugger(xeno_carbon))
		recovery_amount = xeno_carbon.maxHealth // Can as well just fully heal them if you choose to waste the flesh plasma on them

	if(xeno_carbon.health < 0)
		recovery_amount = (xeno_carbon.maxHealth * 0.05) + abs(xeno_carbon.health) // If they're in crit, get them out of it but heal less

	xeno_carbon.gain_health(recovery_amount)
	xeno_carbon.updatehealth()
	xeno_carbon.xeno_jitter(1 SECONDS)
	xeno_carbon.flick_heal_overlay(3 SECONDS, "#c5bc81")

	if(xeno_carbon == xeno)
		xeno.visible_message(SPAN_XENOWARNING("[xeno]'s wounds emit a foul scent and close up faster!"), \
		SPAN_XENOWARNING("We absorb flesh plasma, healing some of our injuries!"))
	else if(xeno.Adjacent(xeno_carbon))
		xeno.visible_message(SPAN_XENOWARNING("[xeno] smears a foul-smelling ooze onto [xeno_carbon]'s wounds, causing them to close up faster!"), \
		SPAN_XENOWARNING("We use flesh plasma to heal [xeno_carbon]'s wounds!"))
		to_chat(xeno_carbon, SPAN_XENOWARNING("[xeno] smears a pale ooze onto our wounds, causing them to close up faster!"))
	else if(!xeno.Adjacent(xeno_carbon))
		xeno.visible_message(SPAN_XENOWARNING("The weeds between [xeno] and [xeno_carbon] ripple and emit a foul scent as [xeno_carbon]'s wounds close up faster!"), \
		SPAN_XENOWARNING("We channel flesh plasma to heal [xeno_carbon]'s wounds from afar!"))
		to_chat(xeno_carbon, SPAN_XENOWARNING("The weeds beneath us shudder as a pale ooze forms on our wounds, causing them to close up faster!"))

	use_plasma_owner(plasma_cost * plas_mod)
	apply_cooldown()
	return ..()

/datum/action/xeno_action/onclick/emit_mist/use_ability(atom/target)
	var/mob/living/carbon/xenomorph/reaper/xeno = owner
	var/datum/effect_system/smoke_spread/reaper_mist/cloud = new /datum/effect_system/smoke_spread/reaper_mist

	if(!isxeno(owner))
		return

	if(!action_cooldown_check())
		return

	if(!xeno.check_state())
		return

	if(!check_and_use_plasma_owner())
		return

	if(xeno.flesh_plasma < flesh_plasma_cost)
		to_chat(xeno, SPAN_XENOWARNING("We don't have enough flesh plasma, we need [flesh_plasma_cost - xeno.flesh_plasma] more!"))
		return

	var/datum/cause_data/cause_data = create_cause_data("reaper mist", owner)
	cloud.set_up(3, 0, get_turf(xeno), null, 10, new_cause_data = cause_data)
	cloud.start()
	xeno.emote("roar")
	xeno.visible_message(SPAN_XENOWARNING("[xeno] belches a sickly green mist!"), \
		SPAN_XENOWARNING("We breath a cloud of mist of evaporated flesh plasma!"))

	xeno.modify_flesh_plasma(-flesh_plasma_cost)
	apply_cooldown()
	return ..()


// Strain Powers

/datum/action/xeno_action/activable/reap/use_ability(atom/target)
	var/mob/living/carbon/xenomorph/reaper/xeno = owner
	var/mob/living/carbon/carbon = target
	var/datum/behavior_delegate/base_reaper/reaper = xeno.behavior_delegate

	var/damage = xeno.melee_damage_upper + xeno.frenzy_aura * FRENZY_DAMAGE_MULTIPLIER

	if(!action_cooldown_check())
		return

	if(!isxeno_human(carbon) || xeno.can_not_harm(carbon))
		return

	if(!xeno.check_state())
		return

	if(carbon.stat == DEAD)
		return

	if(HAS_TRAIT(carbon, TRAIT_NESTED))
		return

	if(get_dist(xeno, target) > range)
		to_chat(xeno, SPAN_WARNING("They are too far away!"))
		return

	if(!check_and_use_plasma_owner())
		return

	var/list/turf/path = get_line(xeno, carbon, include_start_atom = FALSE)
	for(var/turf/path_turf as anything in path)
		if(path_turf.density)
			to_chat(xeno, SPAN_WARNING("There's something blocking our strike!"))
			return
		for(var/obj/path_contents in path_turf.contents)
			if(path_contents != carbon && path_contents.density && !path_contents.throwpass)
				to_chat(xeno, SPAN_WARNING("There's something blocking our strike!"))
				return

		var/atom/barrier = path_turf.handle_barriers(xeno, null, (PASS_MOB_THRU_XENO|PASS_OVER_THROW_MOB|PASS_TYPE_CRAWLER))
		if(barrier != path_turf)
			to_chat(xeno, SPAN_WARNING("There's something blocking our strike!"))
			return
		for(var/obj/structure/current_structure in path_turf)
			if(current_structure.density && !current_structure.throwpass)
				to_chat(xeno, SPAN_WARNING("There's something blocking us from striking!"))
				return

	var/obj/limb/target_limb = carbon.get_limb(check_zone(xeno.zone_selected))
	if(ishuman(carbon) && (!target_limb || (target_limb.status & LIMB_DESTROYED)))
		target_limb = carbon.get_limb("chest")

	xeno.face_atom(carbon)
	xeno.animation_attack_on(carbon)
	xeno.flick_attack_overlay(carbon, "slash")
	playsound(carbon, 'sound/weapons/alien_tail_attack.ogg', 50, TRUE)
	xeno.visible_message(SPAN_XENOWARNING("[xeno] swings its large claws at [carbon], slicing them in the [target_limb ? target_limb.display_name : "chest"]!"), \
	SPAN_XENOWARNING("We slice [carbon] in the [target_limb ? target_limb.display_name : "chest"]!"))
	if(iscarbon(carbon))
		var/mob/living/carbon/human/victim = carbon
		if(!issynth(victim))
			victim.reagents.add_reagent("sepsicine", toxin_amount)
			victim.reagents.set_source_mob(xeno, /datum/reagent/toxin/sepsicine)
	carbon.apply_armoured_damage(damage, ARMOR_MELEE, BRUTE, target_limb ? target_limb.name : "chest")
	carbon.apply_effect(2, DAZE)
	reaper.pause_decay = TRUE
	reaper.modify_passive_mult(1)
	shake_camera(target, 2, 1)
	apply_cooldown()
	return ..()
