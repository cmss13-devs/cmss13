/datum/action/xeno_action/activable/flesh_harvest/use_ability(atom/target)
	var/mob/living/carbon/xenomorph/xeno = owner
	var/mob/living/carbon/carbon = target
	var/mob/living/carbon/human/victim = carbon
	var/datum/behavior_delegate/base_reaper/reaper = xeno.behavior_delegate

	var/limb_remove_start = pick('sound/effects/bone_break2.ogg','sound/effects/bone_break3.ogg')

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
		to_chat(xeno, SPAN_XENOWARNING("We are busy!"))
		return

	if(isxeno(carbon))
		return

	if(issynth(carbon))
		to_chat(xeno, SPAN_XENOWARNING("This one is a fake, we get nothing from it!"))
		return

	if(carbon.stat != DEAD)
		to_chat(xeno, SPAN_XENOWARNING("This one still lives, they are not suitable."))
		return

	if(victim.is_revivable(TRUE) && victim.check_tod())
		to_chat(xeno, SPAN_XENOWARNING("This one still pulses with life, they are not suitable."))
		return

	var/obj/limb/target_limb = victim.get_limb(check_zone(xeno.zone_selected))
	if(ishuman(carbon) && !target_limb || (target_limb.status & LIMB_DESTROYED))
		to_chat(xeno, SPAN_XENOWARNING("There is nothing to harvest!"))
		return

	switch(target_limb.name)
		if("head")
			cannot_harvest()
			return ..()
		if("chest")
			cannot_harvest()
			return ..()
		if("groin")
			cannot_harvest()
			return ..()
		else
			xeno.face_atom(carbon)
			var/obj/limb/limb = target_limb
			switch(limb.name)
				if("l_hand")
					limb = carbon.get_limb("l_arm")
				if("r_hand")
					limb = carbon.get_limb("r_arm")
				if("l_foot")
					limb = carbon.get_limb("l_leg")
				if("r_foot")
					limb = carbon.get_limb("r_leg")
			reaper.harvesting = TRUE
			xeno.visible_message(SPAN_XENONOTICE("[xeno] reaches down and grabs [victim]'s [limb.display_name], twisting and pulling at it!"), \
			SPAN_XENONOTICE("We begin to harvest the [limb.display_name]!"))
			playsound(victim, limb_remove_start, 50, TRUE)
			if(!do_after(xeno, 3 SECONDS, INTERRUPT_ALL|BEHAVIOR_IMMOBILE, BUSY_ICON_HOSTILE))
				reaper.harvesting = FALSE
				return
			do_harvest(carbon, target_limb)
			return ..()

/datum/action/xeno_action/activable/flesh_harvest/proc/do_harvest(mob/living/carbon/carbon, obj/limb/limb)
	var/mob/living/carbon/xenomorph/xeno = owner
	var/mob/living/carbon/human/victim = carbon
	var/datum/behavior_delegate/base_reaper/reaper = xeno.behavior_delegate

	var/limb_remove_end = pick('sound/scp/firstpersonsnap.ogg','sound/scp/firstpersonsnap2.ogg')

	playsound(xeno, limb_remove_end, 25, TRUE)
	if(limb.status & (LIMB_ROBOT|LIMB_SYNTHSKIN))
		xeno.visible_message(SPAN_XENOWARNING("[xeno] wrenches off [victim]'s [limb.display_name] with a final violent motion!"), \
		SPAN_XENOWARNING("We harvest the [limb.display_name], but it's a fake! Useless!"))
		limb.droplimb(FALSE, FALSE, "flesh harvest")
	else
		xeno.visible_message(SPAN_XENOWARNING("[xeno] wrenches off [victim]'s [limb.display_name] with a final violent motion and swallows it whole!"), \
		SPAN_XENOWARNING("We harvest the [limb.display_name]!"))
		limb.droplimb(FALSE, TRUE, "flesh harvest")
		reaper.flesh_plasma += harvest_gain
	reaper.harvesting = FALSE
	reaper.pause_decay = TRUE
	apply_cooldown()

/datum/action/xeno_action/activable/flesh_harvest/proc/cannot_harvest()
	var/mob/living/carbon/xenomorph/xeno = owner
	to_chat(xeno, SPAN_XENOWARNING("This part is not worth harvesting!"))

/datum/action/xeno_action/activable/rapture/use_ability(atom/target)
	var/mob/living/carbon/xenomorph/xeno = owner
	var/mob/living/carbon/carbon = target
	var/datum/behavior_delegate/base_reaper/reaper = xeno.behavior_delegate
	var/distance = get_dist(xeno, target)
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

	if(distance > max_range)
		to_chat(xeno, SPAN_WARNING("They are too far away!"))
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
	if(distance <= normal_range)
		xeno.visible_message(SPAN_XENOWARNING("[xeno] swings its wing-like claws at [carbon], piercing them in the [target_limb ? target_limb.display_name : "chest"]!"), \
		SPAN_XENOWARNING("We pierce [carbon] in the [target_limb ? target_limb.display_name : "chest"]!"))
		if(iscarbon(carbon))
			carbon.apply_effect(2, DAZE)
			var/mob/living/carbon/human/victim = carbon
			if(!issynth(victim))
				victim.reagents.add_reagent("sepsicine", toxin_amount)
				victim.reagents.set_source_mob(xeno, /datum/reagent/toxin/sepsicine)
	else
		xeno.visible_message(SPAN_XENOWARNING("[xeno] swings its wing-like claws infront of it as tendrils of resin whip outwards, striking [carbon] in the [target_limb ? target_limb.display_name : "chest"]!"), \
		SPAN_XENOWARNING("We strike [carbon] in the [target_limb ? target_limb.display_name : "chest"]!"))
	carbon.apply_armoured_damage(damage, ARMOR_MELEE, BRUTE, target_limb ? target_limb.name : "chest")
	reaper.pause_decay = TRUE
	reaper.passive_flesh_multi += 1
	shake_camera(target, 2, 1)
	apply_cooldown()
	return ..()

/datum/action/xeno_action/onclick/emit_mist/use_ability(atom/target)
	var/mob/living/carbon/xenomorph/xeno = owner
	var/datum/behavior_delegate/base_reaper/reaper = xeno.behavior_delegate
	var/datum/effect_system/smoke_spread/reaper_mist/cloud

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
	cloud = new /datum/effect_system/smoke_spread/reaper_mist
	cloud.set_up(3, 0, get_turf(xeno), null, 10, new_cause_data = cause_data)
	cloud.start()
	xeno.visible_message(SPAN_XENOWARNING("[xeno] belches a sickly green mist!"), \
		SPAN_XENOWARNING("We consume flesh plasma and breath a cloud of mist!"))

	reaper.flesh_plasma -= flesh_plasma_cost
	apply_cooldown()
	return ..()
