/datum/action/xeno_action/activable/haul_corpse/use_ability(atom/target)
	var/mob/living/carbon/xenomorph/reaper/xeno = owner
	var/mob/living/carbon/carbon = target
	var/datum/behavior_delegate/base_reaper/reaper = xeno.behavior_delegate

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

	if(reaper.harvesting == TRUE)
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

	xeno.visible_message(SPAN_XENONOTICE("[xeno] stabs a wing-like back limb through the gaping hole on [corpse]'s chest."), \
	SPAN_XENONOTICE("We hoist the corpse onto one of our back limbs for hauling."))
	xeno.corpses_hauled.Add(corpse)
	xeno.corpse_no += 1
	corpse.forceMove(xeno)

/datum/action/xeno_action/activable/haul_corpse/proc/corpse_retrieve(mob/living/corpse)
	var/mob/living/carbon/xenomorph/reaper/xeno = owner

	xeno.visible_message(SPAN_XENONOTICE("[xeno] deftly uses its tail to slide a corpse off one of its wing-like back limbs."), \
	SPAN_XENONOTICE("We retrieve a corpse from one of our back limbs."))
	for(var/atom/movable/corpse_mob in xeno.corpses_hauled)
		xeno.corpses_hauled.Remove(corpse_mob)
		xeno.corpse_no -= 1
		corpse_mob.forceMove(get_true_turf(xeno.loc))
		break

/datum/action/xeno_action/activable/flesh_harvest/use_ability(atom/target)
	var/mob/living/carbon/xenomorph/xeno = owner
	var/mob/living/carbon/carbon = target
	var/mob/living/carbon/human/victim = carbon
	var/datum/behavior_delegate/base_reaper/reaper = xeno.behavior_delegate

	if(!action_cooldown_check())
		return

	if(!iscarbon(carbon))
		return

	if(!xeno.check_state())
		return

	var/distance = get_dist(xeno, target)
	if((distance > 2) && !xeno.Adjacent(target))
		return

	if(reaper.harvesting == TRUE)
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
				to_chat(xeno, SPAN_WARNING("A sister is still growing inside this one, we should refrain from harvesting them yet."))
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
	var/mob/living/carbon/xenomorph/xeno = owner
	var/mob/living/carbon/human/victim = carbon
	var/datum/behavior_delegate/base_reaper/reaper = xeno.behavior_delegate

	var/limb_remove_end = pick('sound/scp/firstpersonsnap.ogg','sound/scp/firstpersonsnap2.ogg')
	var/limb_remove_start = pick('sound/effects/bone_break2.ogg','sound/effects/bone_break3.ogg')

	reaper.harvesting = TRUE
	xeno.visible_message(SPAN_XENONOTICE("[xeno] reaches down and grabs [victim]'s [limb.display_name], twisting and pulling at it!"), \
	SPAN_XENONOTICE("We begin to harvest the [limb.display_name]!"))

	playsound(victim, limb_remove_start, 50, TRUE)
	if(do_after(xeno, 3 SECONDS, INTERRUPT_ALL|BEHAVIOR_IMMOBILE, BUSY_ICON_HOSTILE))
		if(!xeno.Adjacent(victim))
			to_chat(xeno, SPAN_XENOWARNING("Our harvest was interrupted!"))
			reaper.harvesting = FALSE
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
		reaper.modify_flesh_plasma(harvest_gain)
	reaper.pause_decay = TRUE
	reaper.harvesting = FALSE

/datum/action/xeno_action/activable/flesh_harvest/proc/burst_chest(mob/living/carbon/carbon, burst_living = FALSE)
	var/mob/living/carbon/xenomorph/xeno = owner
	var/mob/living/carbon/human/victim = carbon
	var/datum/behavior_delegate/base_reaper/reaper = xeno.behavior_delegate

	if(victim.chestburst)
		to_chat(xeno, SPAN_XENOWARNING("A sister has already burst from them, there is nothing to harvest!"))
		return

	reaper.harvesting = TRUE
	xeno.visible_message(SPAN_XENONOTICE("[xeno] bends over and reaches [victim]!"), \
	SPAN_XENONOTICE("We prepare our inner jaw to harvest [victim]'s chest organs!"))

	if(do_after(xeno, 3 SECONDS, INTERRUPT_ALL|BEHAVIOR_IMMOBILE, BUSY_ICON_HOSTILE))
		if(!xeno.Adjacent(victim))
			to_chat(xeno, SPAN_XENOWARNING("Oopsies Our harvest was interrupted!"))
			reaper.harvesting = FALSE
			return

	if(ishuman(victim))
		var/mob/living/carbon/human/victim_human = victim
		var/datum/internal_organ/organ
		var/internal
		for(internal in list("heart","lungs")) // Ripped from Embryo code for vibes, with single letter vars murdered (I wish I found this sooner)
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
	reaper.modify_flesh_plasma(harvest_gain * 2)
	reaper.pause_decay = TRUE
	reaper.harvesting = FALSE

/datum/action/xeno_action/activable/flesh_harvest/proc/cannot_harvest()
//	var/mob/living/carbon/xenomorph/xeno = owner
	to_chat(owner, SPAN_XENOWARNING("This part is not worth harvesting!"))

/datum/action/xeno_action/activable/reap/use_ability(atom/target)
	var/mob/living/carbon/xenomorph/xeno = owner
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

	var/distance = get_dist(xeno, target)
	if(distance > range)
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

/datum/action/xeno_action/onclick/emit_mist/use_ability(atom/target)
	var/mob/living/carbon/xenomorph/xeno = owner
	var/datum/behavior_delegate/base_reaper/reaper = xeno.behavior_delegate
	var/datum/effect_system/smoke_spread/reaper_mist/cloud = new /datum/effect_system/smoke_spread/reaper_mist

	if(!isxeno(owner))
		return

	if(!action_cooldown_check())
		return

	if(!xeno.check_state())
		return

	if(reaper.flesh_plasma < flesh_plasma_cost)
		to_chat(xeno, SPAN_XENOWARNING("We don't have enough flesh plasma!"))
		return

	if(!check_and_use_plasma_owner())
		return

	var/datum/cause_data/cause_data = create_cause_data("reaper mist", owner)
	cloud.set_up(3, 0, get_turf(xeno), null, 10, new_cause_data = cause_data)
	cloud.start()
	xeno.visible_message(SPAN_XENOWARNING("[xeno] belches a sickly green mist!"), \
		SPAN_XENOWARNING("We consume flesh plasma and breath a cloud of mist!"))

	reaper.modify_flesh_plasma(-flesh_plasma_cost)
	apply_cooldown()
	return ..()
