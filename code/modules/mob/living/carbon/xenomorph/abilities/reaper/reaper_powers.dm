/datum/action/xeno_action/activable/flesh_harvest/use_ability(atom/target)
	var/mob/living/carbon/xenomorph/xeno = owner
	var/mob/living/carbon/carbon = target
	var/mob/living/carbon/human/victim = carbon
	var/datum/behavior_delegate/base_reaper/reaper = xeno.behavior_delegate

	if(!istype(xeno))
		return

	if(!iscarbon(carbon))
		return

	if(!action_cooldown_check())
		return

	if(!xeno.check_state())
		return

	if(!check_and_use_plasma_owner())
		return

	var/distance = get_dist(xeno, carbon)
	if(distance > 2)
		return

	if(!xeno.Adjacent(carbon))
		return

	if(issynth(carbon))
		to_chat(xeno, SPAN_XENOWARNING("This one is a damnable fake, we get nothing from it!"))

	if(!carbon.stat == DEAD)
		to_chat(xeno, SPAN_XENOWARNING("This one still lives, they squirm too much to be suitable."))
		return

	if(!victim.chestburst == 2 || victim.is_revivable())
		to_chat(xeno, SPAN_XENOWARNING("This one is too warm, not yet suitable."))
		return

	var/limb_remove_start = pick('sound/effects/bone_break2.ogg','sound/effects/bone_break3.ogg')
	var/limb_remove_end = pick('sound/scp/firstpersonsnap.ogg','sound/scp/firstpersonsnap2.ogg')
	var/obj/limb/limb = null
	var/cooldown_mult = 0
	var/fake_count = 0

	xeno.face_atom(carbon)
	xeno.visible_message(SPAN_XENOWARNING("[xeno] crouches over [carbon]'s corpse, saliva dripping from it's mouth!"), SPAN_XENOWARNING("This one is ripe for harvesting!"))

	if(victim.has_limb("r_leg"))
		do_after(xeno, 1 SECONDS, INTERRUPT_ALL|BEHAVIOR_IMMOBILE, BUSY_ICON_HOSTILE)
		limb = victim.get_limb("r_leg")
		if(limb.status & (LIMB_ROBOT|LIMB_SYNTHSKIN))
			to_chat(xeno, SPAN_XENOWARNING("This limb is fake!"))
			fake_count += 1
		else
			playsound(carbon, limb_remove_start, 50, TRUE)
			xeno.visible_message(SPAN_XENONOTICE("[xeno] grabs [carbon]'s [limb.display_name] and starts twisting and pulling!"))
			do_after(xeno, 3 SECONDS, INTERRUPT_ALL|BEHAVIOR_IMMOBILE, BUSY_ICON_HOSTILE)
			limb.droplimb(FALSE, TRUE, "flesh harvest")
			xeno.visible_message(SPAN_XENOWARNING("With a final violent motion, [xeno] wrenches off [carbon]'s [limb.display_name] and consumes it!"), \
			SPAN_XENOWARNING("We harvest the [limb.display_name]!"))
			reaper.flesh_resin += 35
			cooldown_mult += 1
			playsound(xeno, limb_remove_end, 25, TRUE)

	if(victim.has_limb("l_leg"))
		do_after(xeno, 1 SECONDS, INTERRUPT_ALL|BEHAVIOR_IMMOBILE, BUSY_ICON_HOSTILE)
		limb = victim.get_limb("l_leg")
		if(limb.status & (LIMB_ROBOT|LIMB_SYNTHSKIN))
			to_chat(xeno, SPAN_XENOWARNING("This limb is fake!"))
			fake_count += 1
		else
			playsound(carbon, limb_remove_start, 50, TRUE)
			xeno.visible_message(SPAN_XENONOTICE("[xeno] grabs [carbon]'s [limb.display_name] and starts twisting and pulling!"))
			do_after(xeno, 3 SECONDS, INTERRUPT_ALL|BEHAVIOR_IMMOBILE, BUSY_ICON_HOSTILE)
			limb.droplimb(FALSE, TRUE, "flesh harvest")
			xeno.visible_message(SPAN_XENOWARNING("With a final violent motion, [xeno] wrenches off [carbon]'s [limb.display_name] and consumes it!"), \
			SPAN_XENOWARNING("We harvest the [limb.display_name]!"))
			reaper.flesh_resin += 35
			cooldown_mult += 1
			playsound(xeno, limb_remove_end, 25, TRUE)

	if(victim.has_limb("r_arm"))
		do_after(xeno, 1 SECONDS, INTERRUPT_ALL|BEHAVIOR_IMMOBILE, BUSY_ICON_HOSTILE)
		limb = victim.get_limb("r_arm")
		if(limb.status & (LIMB_ROBOT|LIMB_SYNTHSKIN))
			to_chat(xeno, SPAN_XENOWARNING("This limb is fake!"))
			fake_count += 1
		else
			playsound(carbon, limb_remove_start, 50, TRUE)
			xeno.visible_message(SPAN_XENONOTICE("[xeno] grabs [carbon]'s [limb.display_name] and starts twisting and pulling!"))
			do_after(xeno, 3 SECONDS, INTERRUPT_ALL|BEHAVIOR_IMMOBILE, BUSY_ICON_HOSTILE)
			limb.droplimb(FALSE, TRUE, "flesh harvest")
			xeno.visible_message(SPAN_XENOWARNING("With a final violent motion, [xeno] wrenches off [carbon]'s [limb.display_name] and consumes it!"), \
			SPAN_XENOWARNING("We harvest the [limb.display_name]!"))
			reaper.flesh_resin += 35
			cooldown_mult += 1
			playsound(xeno, limb_remove_end, 25, TRUE)

	if(victim.has_limb("l_arm"))
		do_after(xeno, 1 SECONDS, INTERRUPT_ALL|BEHAVIOR_IMMOBILE, BUSY_ICON_HOSTILE)
		limb = victim.get_limb("l_arm")
		if(limb.status & (LIMB_ROBOT|LIMB_SYNTHSKIN))
			to_chat(xeno, SPAN_XENOWARNING("This limb is fake!"))
			fake_count += 1
		else
			playsound(carbon, limb_remove_start, 50, TRUE)
			xeno.visible_message(SPAN_XENONOTICE("[xeno] grabs [carbon]'s [limb.display_name] and starts twisting and pulling!"))
			do_after(xeno, 3 SECONDS, INTERRUPT_ALL|BEHAVIOR_IMMOBILE, BUSY_ICON_HOSTILE)
			limb.droplimb(FALSE, TRUE, "flesh harvest")
			xeno.visible_message(SPAN_XENOWARNING("With a final violent motion, [xeno] wrenches off [carbon]'s [limb.display_name] and consumes it!"), \
			SPAN_XENOWARNING("We harvest the [limb.display_name]!"))
			reaper.flesh_resin += 35
			cooldown_mult += 1
			playsound(xeno, limb_remove_end, 25, TRUE)

	if(fake_count == 4)
		xeno.emote("hiss")
		xeno.visible_message(SPAN_XENONOTICE("After inspecting [carbon]'s corpse, [xeno] rises angrily."), SPAN_XENOWARNING("It was all fake! Infuriating!"))
		return

	if(limb == null)
		do_after(xeno, 4 SECONDS, INTERRUPT_ALL|BEHAVIOR_IMMOBILE, BUSY_ICON_HOSTILE)
		xeno.emote("hiss")
		xeno.visible_message(SPAN_XENONOTICE("After inspecting [carbon]'s corpse, [xeno] rises angrily."), SPAN_XENOWARNING("...But they have nothing to harvest. Disappointing."))
		return

	xeno.visible_message(SPAN_XENONOTICE("[xeno] rises from [carbon]'s corpse."), SPAN_XENOWARNING("We finish our harvest, digesting the harvested limbs into flesh resin!"))
	reaper.flesh_resin += 35
	apply_cooldown(cooldown_mult)
	return ..()

/datum/action/xeno_action/activable/flesh_bolster/use_ability(atom/target)
	var/mob/living/carbon/xenomorph/xeno = owner
	var/mob/living/carbon/xenomorph/fren = target
	var/datum/behavior_delegate/base_reaper/reaper = xeno.behavior_delegate

	if(!istype(xeno))
		return

	if(!isxeno(fren))
		return

	if(!xeno.check_state())
		return

	if(!xeno.can_not_harm(fren))
		to_chat(xeno, SPAN_XENOWARNING("[fren] is hostile to our hive!"))
		return

	if(fren.stat == DEAD)
		to_chat(xeno, SPAN_XENOWARNING("[fren] is dead!"))
		return

	if(reaper.flesh_resin < resin_cost)
		to_chat(xeno, SPAN_XENOWARNING("We don't have enough flesh resin!"))
		return

	if(!can_see(xeno, fren, max_range))
		return

	var/distance = get_dist(xeno, fren)
	if(distance > max_range)
		to_chat(xeno, SPAN_XENOWARNING("They are too far away to bolster!"))
		return

	if(fren == xeno)
		if(istype(reaper))
			if(!check_and_use_plasma_owner())
				return
			if(reaper.flesh_bolstered == TRUE)
				to_chat(xeno, SPAN_XENOWARNING("We are already empowered!"))
				return
			reaper.flesh_bolstered = TRUE
			xeno.visible_message(SPAN_WARNING("A rancid-smelling sludge oozes out of the wing-like claws on [xeno]'s back!"), \
			SPAN_WARNING("We absorb some of our stored flesh resin and channel it to our claws, bolstering their next strike and hardening our exoskeleton!"))
			playsound(xeno, "alien_egg_move.ogg", 25, TRUE)
			reaper.flesh_resin -= resin_cost
			reaper.armor_modifier += XENO_ARMOR_MOD_MED
			addtimer(CALLBACK(src, PROC_REF(unbolster_self)), self_duration)
			apply_cooldown()
			return ..()

	if(fren.health >= fren.maxHealth)
		to_chat(xeno, SPAN_XENOWARNING("[fren] is too healthy to bolster!"))
		return

	if(!check_and_use_plasma_owner())
		return

	xeno.face_atom(fren)
	xeno.bolster_with_flesh(target, fren_heal)
	reaper.flesh_resin -= resin_cost
	apply_cooldown(2)
	return ..()

/datum/action/xeno_action/activable/flesh_bolster/proc/unbolster_self()
	var/mob/living/carbon/xenomorph/xeno = owner
	if (!istype(xeno))
		return
	var/datum/behavior_delegate/base_reaper/reaper = xeno.behavior_delegate
	if (istype(reaper))
		if (!reaper.flesh_bolstered)
			return
		reaper.flesh_bolstered = FALSE

	reaper.armor_modifier -= XENO_ARMOR_MOD_MED
	to_chat(xeno, SPAN_XENOWARNING("We feel the power bestowed to our claws fade as resin sloughs off them!"))

/mob/living/carbon/xenomorph/proc/bolster_with_flesh(mob/living/carbon/xenomorph/fren, fren_heal = 150)
	var/mob/living/carbon/xenomorph/xeno = src

	if(!can_not_harm(fren))
		to_chat(xeno, SPAN_XENOWARNING("[fren] is hostile to our hive!"))
		return

	// The following is shamelessly nabbed and modified where appropriate from Healer's Apply Salve
	if(fren.mob_size == MOB_SIZE_SMALL)
		fren_heal = fren_heal * 0.15

	new /datum/effects/heal_over_time(fren, fren_heal, 10, 1)
	fren.xeno_jitter(1 SECONDS)
	fren.flick_heal_overlay(10 SECONDS, "#00be6f")
	to_chat(fren, SPAN_XENOWARNING("We feel our wounds start to close at an unnatural rate and a burst of energy bolstering us!"))
	xeno.visible_message(SPAN_WARNING("[xeno] points a razor-sharp finger at [fren], causing it to emanate a foul smell as it's wounds to close!"), \
	SPAN_XENOWARNING("We absorb some of our stored flesh resin and channel energy to force [fren]'s wounds to shut themselves!"))
	playsound(fren, "alien_drool", 25, TRUE)

/datum/action/xeno_action/activable/meat_shield/use_ability(atom/target)
	var/mob/living/carbon/xenomorph/xeno = owner
	var/mob/living/carbon/xenomorph/fren = target
	var/datum/behavior_delegate/base_reaper/reaper = xeno.behavior_delegate

	if(!istype(xeno))
		return

	if(!isxeno(fren))
		return

	if(!xeno.check_state())
		return

	if(!xeno.can_not_harm(fren))
		to_chat(xeno, SPAN_XENOWARNING("[fren] is hostile to our hive!"))
		return

	if(fren.stat == DEAD)
		to_chat(xeno, SPAN_XENOWARNING("[fren] is dead!"))
		return

	if(reaper.flesh_resin < resin_cost)
		to_chat(xeno, SPAN_XENOWARNING("We don't have enough flesh resin!"))
		return

	if(!can_see(xeno, fren, max_range))
		return

	var/distance = get_dist(xeno, fren)
	if(distance > max_range)
		to_chat(xeno, SPAN_XENOWARNING("They are too far away to bolster!"))
		return

	if(!check_and_use_plasma_owner())
		return

	reaper.flesh_resin -= resin_cost
	fren.emote("roar")
	fren.create_shield()
	fren.add_xeno_shield(150, XENO_SHIELD_SOURCE_REAPER, /datum/xeno_shield/reaper, 1, 2, FALSE, 150)
	fren.overlay_shields()
	if(fren == xeno)
		xeno.visible_message(SPAN_WARNING("[xeno] starts to ooze a foul-smelling resin from it's carapace! It seems to drip off as it ages!"), \
		SPAN_XENOWARNING("We absorb some of our stored flesh resin and excrete a defensive resin, granting us a protective barrier!"))
		apply_cooldown()
		return ..()
	else
		to_chat(fren, SPAN_XENOWARNING("We feel our exoskeleton start to ooze a resin, forming a protective barrier!"))
		xeno.visible_message(SPAN_WARNING("[xeno] points a razor-sharp finger at [fren], causing it to ooze a foul-smelling resin from it's carapace! It seems to drip off as it ages!"), \
		SPAN_XENOWARNING("We absorb some of our stored flesh resin and channel energy to force [fren] to excrete defensive resin!"))
		apply_cooldown(2)
		return ..()

/datum/action/xeno_action/activable/claw_strike/use_ability(atom/target)
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

	if(reaper.flesh_bolstered == TRUE)
		strike_range += 2
	if(distance > strike_range)
		to_chat(xeno; SPAN_WARNING("They are too far!"))
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
	if(reaper.flesh_bolstered)
		xeno.visible_message(SPAN_XENOWARNING("The foul ooze on [xeno]'s wing-like claws twists and extends as it swings at [carbon], striking them in the [target_limb ? target_limb.display_name : "chest"]!"), \
		SPAN_XENOWARNING("We strike [carbon] in the [target_limb ? target_limb.display_name : "chest"], bending the resin on our claws to strike even further!"))
		carbon.apply_armoured_damage(damage + 15, ARMOR_MELEE, BRUTE, target_limb ? target_limb.name : "chest", 15)
		reaper.flesh_bolstered = FALSE
		strike_range -= 2
		apply_cooldown()
		return ..()

	else
		xeno.visible_message(SPAN_XENOWARNING("[xeno] swings their wing-like claws at [carbon], striking them in the [target_limb ? target_limb.display_name : "chest"]!"), \
		SPAN_XENOWARNING("We strike [carbon] in the [target_limb ? target_limb.display_name : "chest"] with our claws!"))
		carbon.apply_armoured_damage(damage, ARMOR_MELEE, BRUTE, target_limb ? target_limb.name : "chest")
		apply_cooldown()
		return ..()
