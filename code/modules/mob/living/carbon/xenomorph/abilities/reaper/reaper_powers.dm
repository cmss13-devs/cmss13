/datum/action/xeno_action/activable/flesh_harvest/use_ability(atom/target)
	var/mob/living/carbon/xenomorph/xeno = owner
	var/mob/living/carbon/carbon = target
	var/mob/living/carbon/human/victim = carbon
	var/datum/behavior_delegate/base_reaper/reaper = xeno.behavior_delegate

	if(!iscarbon(carbon))
		return

	if(!xeno.check_state())
		return

	var/distance = get_dist(xeno, carbon)
	if(distance > 2)
		return

	if(!xeno.Adjacent(carbon))
		return

	if(reaper.harvesting == TRUE)
		to_chat(xeno, SPAN_XENOWARNING("We are already harvesting!"))
		return

	if(isxeno(carbon))
		return

	if(issynth(carbon))
		to_chat(xeno, SPAN_XENOWARNING("This one is a damnable fake, we get nothing from it!"))
		return

	if(carbon.stat != DEAD)
		to_chat(xeno, SPAN_XENOWARNING("This one still lives, they squirm too much to be suitable."))
		return

	if(!victim.chestburst == 2 || (victim.check_tod() || victim.is_revivable()))
		to_chat(xeno, SPAN_XENOWARNING("This one is too warm, not yet suitable."))
		return

	if(!check_and_use_plasma_owner())
		return

	var/limb_remove_start = pick('sound/effects/bone_break2.ogg','sound/effects/bone_break3.ogg')
	var/limb_remove_end = pick('sound/scp/firstpersonsnap.ogg','sound/scp/firstpersonsnap2.ogg')
	var/obj/limb/limb = null
	var/fake_count = 0

	xeno.face_atom(carbon)
	xeno.visible_message(SPAN_XENOWARNING("[xeno] crouches over [carbon]'s corpse, saliva dripping from it's mouth!"), SPAN_XENOWARNING("This one is ripe for harvesting!"))
	reaper.harvesting = TRUE

	if(victim.has_limb("r_leg"))
		if(!do_after(xeno, 1 SECONDS, INTERRUPT_ALL|BEHAVIOR_IMMOBILE, BUSY_ICON_HOSTILE))
			reaper.harvesting = FALSE
			return
		limb = victim.get_limb("r_leg")
		if(limb.status & (LIMB_ROBOT|LIMB_SYNTHSKIN))
			to_chat(xeno, SPAN_XENOWARNING("This limb is fake!"))
			fake_count += 1
		else
			playsound(carbon, limb_remove_start, 50, TRUE)
			xeno.visible_message(SPAN_XENONOTICE("[xeno] grabs [carbon]'s [limb.display_name] and starts twisting and pulling!"))
			if(!do_after(xeno, 3 SECONDS, INTERRUPT_ALL|BEHAVIOR_IMMOBILE, BUSY_ICON_HOSTILE))
				reaper.harvesting = FALSE
				return
			limb.droplimb(FALSE, TRUE, "flesh harvest")
			xeno.visible_message(SPAN_XENOWARNING("With a final violent motion, [xeno] wrenches off [carbon]'s [limb.display_name] and consumes it!"), \
			SPAN_XENOWARNING("We harvest the [limb.display_name]!"))
			reaper.flesh_plasma += 30
			playsound(xeno, limb_remove_end, 25, TRUE)

	if(victim.has_limb("l_leg"))
		if(!do_after(xeno, 1 SECONDS, INTERRUPT_ALL|BEHAVIOR_IMMOBILE, BUSY_ICON_HOSTILE))
			reaper.harvesting = FALSE
			return
		limb = victim.get_limb("l_leg")
		if(limb.status & (LIMB_ROBOT|LIMB_SYNTHSKIN))
			to_chat(xeno, SPAN_XENOWARNING("This limb is fake!"))
			fake_count += 1
		else
			playsound(carbon, limb_remove_start, 50, TRUE)
			xeno.visible_message(SPAN_XENONOTICE("[xeno] grabs [carbon]'s [limb.display_name] and starts twisting and pulling!"))
			if(!do_after(xeno, 3 SECONDS, INTERRUPT_ALL|BEHAVIOR_IMMOBILE, BUSY_ICON_HOSTILE))
				reaper.harvesting = FALSE
				return
			limb.droplimb(FALSE, TRUE, "flesh harvest")
			xeno.visible_message(SPAN_XENOWARNING("With a final violent motion, [xeno] wrenches off [carbon]'s [limb.display_name] and consumes it!"), \
			SPAN_XENOWARNING("We harvest the [limb.display_name]!"))
			reaper.flesh_plasma += 30
			playsound(xeno, limb_remove_end, 25, TRUE)

	if(victim.has_limb("r_arm"))
		if(!do_after(xeno, 1 SECONDS, INTERRUPT_ALL|BEHAVIOR_IMMOBILE, BUSY_ICON_HOSTILE))
			reaper.harvesting = FALSE
			return
		limb = victim.get_limb("r_arm")
		if(limb.status & (LIMB_ROBOT|LIMB_SYNTHSKIN))
			to_chat(xeno, SPAN_XENOWARNING("This limb is fake!"))
			fake_count += 1
		else
			playsound(carbon, limb_remove_start, 50, TRUE)
			xeno.visible_message(SPAN_XENONOTICE("[xeno] grabs [carbon]'s [limb.display_name] and starts twisting and pulling!"))
			if(!do_after(xeno, 3 SECONDS, INTERRUPT_ALL|BEHAVIOR_IMMOBILE, BUSY_ICON_HOSTILE))
				reaper.harvesting = FALSE
				return
			limb.droplimb(FALSE, TRUE, "flesh harvest")
			xeno.visible_message(SPAN_XENOWARNING("With a final violent motion, [xeno] wrenches off [carbon]'s [limb.display_name] and consumes it!"), \
			SPAN_XENOWARNING("We harvest the [limb.display_name]!"))
			reaper.flesh_plasma += 30
			playsound(xeno, limb_remove_end, 25, TRUE)

	if(victim.has_limb("l_arm"))
		if(!do_after(xeno, 1 SECONDS, INTERRUPT_ALL|BEHAVIOR_IMMOBILE, BUSY_ICON_HOSTILE))
			reaper.harvesting = FALSE
			return
		limb = victim.get_limb("l_arm")
		if(limb.status & (LIMB_ROBOT|LIMB_SYNTHSKIN))
			to_chat(xeno, SPAN_XENOWARNING("This limb is fake!"))
			fake_count += 1
		else
			playsound(carbon, limb_remove_start, 50, TRUE)
			xeno.visible_message(SPAN_XENONOTICE("[xeno] grabs [carbon]'s [limb.display_name] and starts twisting and pulling!"))
			if(!do_after(xeno, 3 SECONDS, INTERRUPT_ALL|BEHAVIOR_IMMOBILE, BUSY_ICON_HOSTILE))
				reaper.harvesting = FALSE
				return
			limb.droplimb(FALSE, TRUE, "flesh harvest")
			xeno.visible_message(SPAN_XENOWARNING("With a final violent motion, [xeno] wrenches off [carbon]'s [limb.display_name] and consumes it!"), \
			SPAN_XENOWARNING("We harvest the [limb.display_name]!"))
			reaper.flesh_plasma += 30
			playsound(xeno, limb_remove_end, 25, TRUE)

	if(fake_count == 4) // Let's be real, this isn't going to happen normally, but it would be fucking funny
		xeno.emote("hiss")
		reaper.harvesting = FALSE
		xeno.visible_message(SPAN_XENONOTICE("After inspecting [carbon]'s corpse, [xeno] rises angrily."), SPAN_XENOWARNING("It was all fake! Infuriating!"))
		return

	if(limb == null)
		if(!do_after(xeno, 4 SECONDS, INTERRUPT_ALL|BEHAVIOR_IMMOBILE, BUSY_ICON_HOSTILE))
			reaper.harvesting = FALSE
			return
		xeno.emote("hiss")
		reaper.harvesting = FALSE
		xeno.visible_message(SPAN_XENONOTICE("After inspecting [carbon]'s corpse, [xeno] rises, visibly frustrated."), SPAN_XENOWARNING("...But they have nothing to harvest. Frustrating."))
		return

	xeno.visible_message(SPAN_XENONOTICE("[xeno] rises from [carbon]'s corpse."), SPAN_XENOWARNING("We finish our harvest, digesting the harvested limbs into flesh resin!"))
	reaper.flesh_plasma += 30
	reaper.harvesting = FALSE
	return ..()

/datum/action/xeno_action/activable/rapture/use_ability(atom/target)
	var/mob/living/carbon/xenomorph/xeno = owner
	var/datum/behavior_delegate/base_reaper/reaper = xeno.behavior_delegate
	var/mob/living/carbon/carbon = target
	var/distance = get_dist(xeno, target)
	var/damage = xeno.melee_damage_upper + xeno.frenzy_aura * FRENZY_DAMAGE_MULTIPLIER

	if(!action_cooldown_check())
		return

	if(!isxeno_human(carbon) || xeno.can_not_harm(carbon))
		return

	if(!xeno.check_state())
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

	if(carbon.stat == DEAD)
		return

	if(HAS_TRAIT(carbon, TRAIT_NESTED))
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
		SPAN_XENOWARNING("We strike [carbon] in the [target_limb ? target_limb.display_name : "chest"]!"))
		if(iscarbon(carbon))
			var/mob/living/carbon/human/victim = carbon
			if(!issynth(victim))
				victim.reagents.add_reagent("fleshplasmatoxin", toxin_amount)
				victim.reagents.set_source_mob(xeno, /datum/reagent/toxin/flesh_plasma_toxin)
	else
		xeno.visible_message(SPAN_XENOWARNING("As [xeno] swings its wing-like claws infront of it, tendrils of resin rapidly shoot out and extends their reach, piercing [carbon] in the [target_limb ? target_limb.display_name : "chest"]!"), \
		SPAN_XENOWARNING("We strike [carbon] in the [target_limb ? target_limb.display_name : "chest"]!"))
	carbon.apply_armoured_damage(damage, ARMOR_MELEE, BRUTE, target_limb ? target_limb.name : "chest")
	reaper.flesh_plasma += 20
	apply_cooldown()
	return ..()

/datum/action/xeno_action/onclick/extra_pheros/use_ability(atom/target)
	var/mob/living/carbon/xenomorph/xeno = owner
	var/datum/behavior_delegate/base_reaper/reaper = xeno.behavior_delegate
	var/datum/effect_system/smoke_spread/reaper_mist/cloud
	var/flesh_cost_modifier = 1
	var/list/datum/behavior_delegate/frenzy_reduced_delegates = list(
		/datum/behavior_delegate/runner_base,
		/datum/behavior_delegate/runner_acider,
		/datum/behavior_delegate/lurker_base,
		/datum/behavior_delegate/crusher_charger,
		/datum/behavior_delegate/praetorian_dancer,
		/datum/behavior_delegate/queen,
		//datum/behavior_delegate/king_base,	// This is a surprise that'll help us later
	)
	var/list/datum/behavior_delegate/warding_reduced_delegates = list(
		/datum/behavior_delegate/defender_base,
		/datum/behavior_delegate/warrior_base,
		/datum/behavior_delegate/lurker_base,
		/datum/behavior_delegate/burrower_base,
		/datum/behavior_delegate/praetorian_base,
		/datum/behavior_delegate/praetorian_dancer,
		/datum/behavior_delegate/praetorian_vanguard,
		/datum/behavior_delegate/oppressor_praetorian,
		/datum/behavior_delegate/predalien_base,
		/datum/behavior_delegate/ravager_base,
		/datum/behavior_delegate/ravager_berserker,
		/datum/behavior_delegate/ravager_hedgehog,
		/datum/behavior_delegate/crusher_base,
		/datum/behavior_delegate/crusher_charger,
		/datum/behavior_delegate/queen,
		//datum/behavior_delegate/king_base		// Ditto
	)
	var/list/datum/behavior_delegate/recovery_reduced_delegates = list(
		/datum/behavior_delegate/drone_healer,
		/datum/behavior_delegate/drone_gardener,
		/datum/behavior_delegate/lurker_base,
		/datum/behavior_delegate/ravager_berserker,
		/datum/behavior_delegate/praetorian_warden,
		/datum/behavior_delegate/queen,
		//datum/behavior_delegate/king_base		// Ditto 2; Electric Boogaloo
	)

	if(!isxeno(owner))
		return

	if(!action_cooldown_check())
		return

	if(!xeno.check_state())
		return

	if(!check_and_use_plasma_owner())
		return

	if(reaper.flesh_plasma < flesh_plasma_cost)
		to_chat(xeno, SPAN_XENOWARNING("We don't have enough flesh plasma!"))
		return

	for(var/mob/living/carbon/carbon in view(4, xeno))
		if(isxeno(carbon))
			var/mob/living/carbon/xenomorph/freno = carbon
			if(!freno)
				return
			if(!freno.behavior_delegate)
				return

			switch(xeno.current_aura)
				if("frenzy")
					xeno.visible_message(SPAN_WARNING("A pulse of stingingly sharp-smelling pheremones wafts from [xeno]!"), \
					SPAN_XENOWARNING("We mix some of our stored flesh plasma with our current pheremones and release a pulse of adrenal pheremones!"))
					if(freno.behavior_delegate == frenzy_reduced_delegates)
						new /datum/effects/xeno_speed(freno, xeno, ttl = 10 SECONDS, set_speed_modifier = 0.2, set_modifier_source = XENO_CASTE_REAPER, set_end_message = SPAN_XENOWARNING("We feel the effects of the pulse wane..."))
					else
						new /datum/effects/xeno_speed(freno, xeno, ttl = 10 SECONDS, set_speed_modifier = 0.4, set_modifier_source = XENO_CASTE_REAPER, set_end_message = SPAN_XENOWARNING("We feel the effects of the pulse wane..."))
					to_chat(freno, SPAN_XENOWARNING("We feel a pulse of adrenaline course through our body!"))
					freno.flick_heal_overlay(10 SECONDS, "#C53A27")
					freno.xeno_jitter(1 SECONDS)
					flesh_cost_modifier = 1
				if("warding")
					xeno.visible_message(SPAN_WARNING("A pulse of slightly acidic-smelling pheremones wafts from [xeno]!"), \
					SPAN_XENOWARNING("We mix some of our stored flesh plasma with our current pheremones and release a pulse of reinforcing pheremones!"))
					if(freno.behavior_delegate == warding_reduced_delegates)
						freno.armor_modifier += XENO_ARMOR_MOD_VERY_SMALL
						freno.recalculate_armor()
						addtimer(CALLBACK(src, PROC_REF(remove_limited_effects)), 10 SECONDS)
					else
						freno.armor_modifier += XENO_ARMOR_MOD_SMALL
						freno.recalculate_armor()
						addtimer(CALLBACK(src, PROC_REF(remove_full_effects)), 10 SECONDS)
					to_chat(freno, SPAN_XENOWARNING("We feel a strange pulse as our carapace hardens!"))
					freno.flick_heal_overlay(10 SECONDS, "#67AD33")
					freno.xeno_jitter(1 SECONDS)
					flesh_cost_modifier = 1
				if("recovery")
					xeno.visible_message(SPAN_WARNING("A pulse of strangely sweet-smelling pheremones wafts from [xeno]!"), \
					SPAN_XENOWARNING("We mix some of our stored flesh plasma with our current pheremones and release a pulse of soothing pheremones!"))
					if(freno.behavior_delegate == recovery_reduced_delegates)
						new /datum/effects/heal_over_time(freno, 60, 10 SECONDS, 1)
					else
						new /datum/effects/heal_over_time(freno, 30, 10 SECONDS, 1)
					to_chat(freno, SPAN_XENOWARNING("We feel a soothing pulse course across our body!"))
					freno.flick_heal_overlay(10 SECONDS, "#5DE9C4")
					freno.xeno_jitter(1 SECONDS)
					flesh_cost_modifier = 1
				if(null)
					var/datum/cause_data/cause_data = create_cause_data("reaper extra pheros smoke", owner)
					cloud = new /datum/effect_system/smoke_spread/reaper_mist
					cloud.set_up(4, 0, get_turf(xeno), null, 10, new_cause_data = cause_data)
					cloud.start()
					to_chat(xeno, SPAN_XENODANGER("Without any pheremones, we aerosolize some of our stored flesh plasma to create a toxic miasma!"))
					flesh_cost_modifier = 0.5

	reaper.flesh_plasma -= flesh_plasma_cost * flesh_cost_modifier
	apply_cooldown()
	return ..()

/datum/action/xeno_action/onclick/extra_pheros/proc/remove_limited_effects()
	var/mob/living/carbon/xenomorph/freno = owner

	if(!istype(freno))
		return

	freno.armor_modifier -= XENO_ARMOR_MOD_VERY_SMALL
	freno.recalculate_armor()
	to_chat(freno, SPAN_XENOWARNING("We feel our carapace soften and return to normal..."))

/datum/action/xeno_action/onclick/extra_pheros/proc/remove_full_effects()
	var/mob/living/carbon/xenomorph/freno = owner

	if(!istype(freno))
		return

	freno.armor_modifier -= XENO_ARMOR_MOD_SMALL
	freno.recalculate_armor()
	to_chat(freno, SPAN_XENOWARNING("We feel our carapace soften and return to normal..."))
