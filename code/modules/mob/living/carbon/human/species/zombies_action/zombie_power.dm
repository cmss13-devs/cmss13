/datum/action/zombie_action/toggable/bite/use_ability(atom/target)
	var/mob/living/carbon/human/zombie = owner
	if (!iszombie(zombie))
		return
	if (!ishuman_strict(target))
		return
	if(!action_cooldown_check())
		return
	var/mob/living/carbon/human/victim = target
	var/datum/disease/black_goo/D = locate() in victim.viruses
	if(D)
		to_chat(zombie, SPAN_XENOWARNING("the target is already infected, you cannot bite him again."))
	else
		to_chat(zombie, SPAN_XENOWARNING("You reach down to [target.name] neck, preparing to bite him"))
		to_chat(target, SPAN_DANGER("[zombie.name] reaches to your neck and starts to open his jaw, agh!"))
		if(do_after(zombie, 5 SECONDS, INTERRUPT_ALL, BUSY_ICON_HOSTILE, target, INTERRUPT_ALL))
			to_chat(zombie, SPAN_XENOWARNING("You bite [target.name] neck, leaving a bloody mark!"))
			to_chat(target, SPAN_DANGER("[zombie.name] Bites you right in the neck!"))
			victim.AddDisease(new /datum/disease/black_goo)
			victim.apply_damage(30, BRUTE, "head")
			apply_cooldown()
		else
			to_chat(zombie, SPAN_XENOWARNING("You were interupted!"))

/datum/action/zombie_action/toggable/leap/use_ability(atom/target)
	var/mob/living/carbon/human/zomb = owner

	if(!action_cooldown_check())
		return

	if(!iszombie(zomb)) //how did we ended up here?
		return

	if(!target)
		return

	if(target.layer >= FLY_LAYER)
		return

	if(!isturf(zomb.loc))
		to_chat(zomb, SPAN_XENOWARNING("You can't [action_name] from here!"))
		return

	apply_cooldown()

	if (windup)
		zomb.set_face_dir(get_cardinal_dir(zomb, target))
		if (!windup_interruptable)
			zomb.frozen = TRUE
			zomb.anchored = TRUE
			zomb.update_canmove()

		if (!do_after(zomb, windup_duration, INTERRUPT_NO_NEEDHAND, BUSY_ICON_HOSTILE))
			to_chat(zomb, SPAN_XENODANGER("You cancel your [action_name]!"))
			return

		if (!windup_interruptable)
			zomb.frozen = FALSE
			zomb.anchored = FALSE
			zomb.update_canmove()

	zomb.visible_message(SPAN_XENOWARNING("\The [zomb.name] [action_name][findtext(action_name, "e", -1) || findtext(action_name, "p", -1) ? "s" : "es"] at [target]!"), SPAN_XENOWARNING("You [action_name] at [target]!"))


	leap_distance = get_dist(zomb, target)

	var/datum/launch_metadata/LM = new()
	LM.target = target
	LM.range = maxdistance
	LM.speed = throw_speed
	LM.thrower = zomb
	LM.spin = FALSE

	zomb.launch_towards(LM)
	return TRUE




