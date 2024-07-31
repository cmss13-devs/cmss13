/datum/action/xeno_action/activable/secrete_resin/reaper/use_ability(atom/target)
	var/mob/living/carbon/xenomorph/xeno = owner
	var/datum/behavior_delegate/base_reaper/reaper = xeno.behavior_delegate
	if(!xeno.check_state())
		return

	if(!..())
		return

	if(!xeno.selected_resin)
		return

	var/turf/target_turf = get_turf(target)
	if(!target_turf)
		return

	// Opening doors from afar is cool
	var/obj/structure/mineral_door/resin/resin_door = target
	if(istype(target, /obj/structure/mineral_door/resin) && !xeno.Adjacent(resin_door))
		resin_door.TryToSwitchState(xeno)
		if(resin_door.state)
			to_chat(xeno, SPAN_XENONOTICE("We compel the resin door to close."))
		else
			to_chat(xeno, SPAN_XENONOTICE("We compel the resin door to open."))
		return

	if(reaper.flesh_resin < resin_cost)
		build_speed_mod = 1
	else
		build_speed_mod = initial(build_speed_mod)
		reaper.flesh_resin -= resin_cost
		to_chat(xeno, SPAN_XENONOTICE("We absorb some stored flesh resin to hasten our building."))

	return TRUE

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

	var/distance = get_dist(xeno, carbon)
	if(distance > 2)
		return

	if(!xeno.Adjacent(carbon))
		return

	if(reaper.making_servant == TRUE)
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

	if(!victim.chestburst == 2 || (victim.check_tod() && victim.is_revivable()))
		to_chat(xeno, SPAN_XENOWARNING("This one is too warm, not yet suitable."))
		return

	if(!check_and_use_plasma_owner())
		return

	var/limb_remove_start = pick('sound/effects/bone_break2.ogg','sound/effects/bone_break3.ogg')
	var/limb_remove_end = pick('sound/scp/firstpersonsnap.ogg','sound/scp/firstpersonsnap2.ogg')
	var/obj/limb/limb = null
	var/cooldown_mult = 0
	var/fake_count = 0

	xeno.face_atom(carbon)
	xeno.visible_message(SPAN_XENOWARNING("[xeno] crouches over [carbon]'s corpse, saliva dripping from it's mouth!"), SPAN_XENOWARNING("This one is ripe for harvesting!"))
	reaper.harvesting = TRUE
	reaper.pause_dur = 40 SECONDS
	reaper.pause_drain = TRUE

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
			reaper.flesh_resin += 30
			cooldown_mult += 1
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
			reaper.flesh_resin += 30
			cooldown_mult += 1
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
			reaper.flesh_resin += 30
			cooldown_mult += 1
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
			reaper.flesh_resin += 30
			cooldown_mult += 1
			playsound(xeno, limb_remove_end, 25, TRUE)

	if(fake_count == 4) // Let's be real, this isn't going to happen naturally, but it would be fucking funny.
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
	reaper.flesh_resin += 30
	reaper.harvesting = FALSE
	apply_cooldown(cooldown_mult)
	reaper.pause_drain = TRUE
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

	if(distance > strike_range)
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
	xeno.visible_message(SPAN_XENOWARNING("[xeno] swings it's wing-like claws at [carbon], piercing them in the [target_limb ? target_limb.display_name : "chest"]!"), \
	SPAN_XENOWARNING("We strike [carbon] in the [target_limb ? target_limb.display_name : "chest"]!"))
	if(iscarbon(carbon))
		var/mob/living/carbon/human/victim = carbon
		if(victim.getToxLoss() >= 25)
			victim.vomit()
		if(!issynth(victim))
			if(envenomed)
				to_chat(xeno, SPAN_XENOWARNING("We inject [victim] with venom!"))
				victim.reagents.add_reagent("fleshresintoxin", 6)
				victim.reagents.set_source_mob(xeno, /datum/reagent/toxin/flesh_resin_toxin)
				envenomed = FALSE
				addtimer(CALLBACK(src, PROC_REF(claw_venom)), 40 SECONDS)
	carbon.apply_armoured_damage(damage, ARMOR_MELEE, BRUTE, target_limb ? target_limb.name : "chest")
	reaper.flesh_resin += 30
	apply_cooldown()
	reaper.pause_drain = TRUE
	return ..()

/datum/action/xeno_action/activable/claw_strike/proc/claw_venom()
	var/mob/living/carbon/xenomorph/xeno = owner

	xeno.visible_message(SPAN_XENONOTICE("A vile-smelling ooze drips from [xeno]'s wing-like claws ..."), SPAN_XENONOTICE("Our claws drip with venom once more."))
	envenomed = TRUE

/datum/action/xeno_action/activable/raise_servant/use_ability(atom/target)
	var/mob/living/carbon/xenomorph/xeno = owner
	var/datum/behavior_delegate/base_reaper/reaper = xeno.behavior_delegate

	var/turf/target_turf = get_turf(target)
	var/obj/effect/alien/weeds/target_weeds = locate(/obj/effect/alien/weeds) in target_turf

	if(length(reaper.servants) >= reaper.servant_max)
		for(var/mob/living/simple_animal/hostile/alien/rotdrone/rotxeno in reaper.servants)
			if(!can_see(xeno, target, 10))
				return
			if(target == xeno)
				servant_recall(rotxeno, xeno)
				to_chat(xeno, SPAN_XENONOTICE("We recall our servant."))
				return
			else if(iscarbon(target))
				var/mob/living/carbon/cartar = target
				if(cartar.stat == DEAD)
					to_chat(xeno, SPAN_XENONOTICE("They are dead, why do we want send our servant to them?"))
					return
				if(!xeno.can_not_harm(cartar))
					to_chat(xeno, SPAN_XENOWARNING("We order our servant to attack [cartar]!"))
					servant_attack(rotxeno, cartar)
					return
				else
					to_chat(xeno, SPAN_XENONOTICE("We order our servant to escort [cartar]."))
					servant_escort(rotxeno, cartar)
					return
			else if(isStructure(target))
				servant_moveto_structure(rotxeno, target)
				to_chat(xeno, SPAN_XENONOTICE("We order our servant to go to [target]."))
				return
			else if(isturf(target) || (target_weeds && istype(target_turf, /turf/open)))
				servant_moveto_turf(rotxeno, target)
				to_chat(xeno, SPAN_XENONOTICE("We order our servant to go to [target]."))
				return
			else
				to_chat(xeno, SPAN_XENOWARNING("We fail to give orders."))
				return

	if(!xeno.check_state())
		return

	if(!action_cooldown_check())
		return

	if(reaper.harvesting == TRUE)
		return

	if(reaper.making_servant == TRUE)
		to_chat(xeno, SPAN_XENOWARNING("We are already making a servant!"))
		return

	if(reaper.flesh_resin < resin_cost)
		to_chat(xeno, SPAN_XENOWARNING("We don't have enough flesh resin!"))
		return

	if(!check_and_use_plasma_owner())
		return

	create_servant()
	reaper.flesh_resin -= resin_cost
	apply_cooldown()
	return ..()

/datum/action/xeno_action/activable/raise_servant/proc/create_servant(datum/action/xeno_action/activable/raise_servant/action_def, atom/target)
	var/mob/living/carbon/xenomorph/xeno = owner
	var/datum/behavior_delegate/base_reaper/reaper = xeno.behavior_delegate
	if(!xeno.check_state())
		return

	if(!istype(xeno))
		return

	xeno.visible_message(SPAN_XENOWARNING("[xeno] bends over and starts spewing large amounts of rancid, black ooze at it's feet, grasping at it as it cascades down!"), \
	SPAN_XENOWARNING("We regurgitate a mix of plasma and flesh resin, moulding it into a loyal servant!"))
	reaper.making_servant = TRUE
	reaper.pause_drain = TRUE

	if(!do_after(xeno, creattime, INTERRUPT_ALL|BEHAVIOR_IMMOBILE, ACTION_PURPLE_POWER_UP))
		reaper.making_servant = FALSE
		return

	xeno.visible_message(SPAN_XENOWARNING("As [xeno] rises, the lump of decomposing sludge shudders and grows, animating into a melting, odd-looking Drone!"), \
	SPAN_XENOWARNING("With much effort, we compel the mound of flesh resin to take shape and rise!"))
	var/mob/living/simple_animal/hostile/alien/rotdrone/rotxeno = new(xeno.loc, xeno)
	new_servant(rotxeno)
	reaper.making_servant = FALSE

/datum/action/xeno_action/activable/raise_servant/proc/new_servant(mob/living/simple_animal/hostile/alien/rotdrone/new_servant)
	var/mob/living/carbon/xenomorph/xeno = owner
	var/datum/behavior_delegate/base_reaper/reaper = xeno.behavior_delegate
	if(!istype(new_servant))
		return
	new_servant.alpha = 0
	animate(new_servant, alpha = 255, time = 2 SECONDS, easing = QUAD_EASING)
	playsound(new_servant, 'sound/voice/alien_roar_unused.ogg', 50, TRUE)

	RegisterSignal(new_servant, list(COMSIG_MOB_DEATH, COMSIG_PARENT_QDELETING), PROC_REF(remove_servant))
	reaper.servants += new_servant

/datum/action/xeno_action/activable/raise_servant/proc/remove_servant(datum/source)
	var/mob/living/carbon/xenomorph/xeno = owner
	var/datum/behavior_delegate/base_reaper/reaper = xeno.behavior_delegate
	SIGNAL_HANDLER
	to_chat(xeno, SPAN_XENOWARNING("We feel our servant has perished!"))
	reaper.servants -= source
	UnregisterSignal(source, list(COMSIG_MOB_DEATH, COMSIG_PARENT_QDELETING))

/datum/action/xeno_action/activable/raise_servant/proc/servant_recall(mob/living/simple_animal/hostile/alien/rotdrone/servant, mob/living/carbon/xenomorph/master)
	if(!istype(servant))
		return
	servant.got_orders = FALSE
	servant.is_fighting = FALSE
	walk_to(servant, master, rand(1, 2), 4)

/datum/action/xeno_action/activable/raise_servant/proc/servant_attack(mob/living/simple_animal/hostile/alien/rotdrone/servant, mob/living/carbon/target)
	if(!istype(servant))
		return
	servant.got_orders = TRUE
	servant.is_fighting = TRUE
	servant.mastertarget = target
	walk_to(servant, servant.mastertarget, 1, 4)

/datum/action/xeno_action/activable/raise_servant/proc/servant_escort(mob/living/simple_animal/hostile/alien/rotdrone/servant, mob/living/carbon/target)
	if(!istype(servant))
		return
	servant.got_orders = TRUE
	servant.escorting = TRUE
	servant.escort = target
	walk_to(servant, servant.escort, rand(1, 2), 4)

/datum/action/xeno_action/activable/raise_servant/proc/servant_moveto_turf(mob/living/simple_animal/hostile/alien/rotdrone/servant, turf/target)
	if(!istype(servant))
		return
	servant.got_orders = TRUE
	walk_to(servant, target, 0, 4)

/datum/action/xeno_action/activable/raise_servant/proc/servant_moveto_structure(mob/living/simple_animal/hostile/alien/rotdrone/servant, turf/target)
	if(!istype(servant))
		return
	servant.got_orders = TRUE
	walk_to(servant, target, 1, 4)
