
/datum/action/xeno_action/activable/pounce/crusher_charge/additional_effects_always()
	var/mob/living/carbon/Xenomorph/X = owner
	if (!istype(X))
		return

	for (var/mob/living/carbon/human/H in orange(1, get_turf(X)))
		new /datum/effects/xeno_slow(H, X, null, null, 35)
		to_chat(H, SPAN_XENODANGER("You are slowed as the impact of [X] shakes the ground!"))

/datum/action/xeno_action/activable/pounce/crusher_charge/additional_effects(mob/living/L)

	if (!ishuman(L))
		return

	var/mob/living/carbon/human/H = L 
	if (H.stat == DEAD)
		return
	
	var/mob/living/carbon/Xenomorph/X = owner
	if (!istype(X))
		return

	X.emote("roar")
	L.KnockDown(2)
	X.visible_message(SPAN_XENODANGER("[X] overruns [H], brutally trampling them underfoot!"), SPAN_XENODANGER("You brutalize [H] as you crush them underfoot!"))

	var/affecting = H.get_limb("chest")
	var/armor_block = H.getarmor(affecting, ARMOR_MELEE)

	var/n_damage = armor_damage_reduction(config.marine_melee, direct_hit_damage, armor_block)
	if (n_damage <= 0.34*direct_hit_damage)
		H.show_message(SPAN_WARNING("Your armor absorbs the blow!"), null, null, null, CHAT_TYPE_ARMOR_DAMAGE)
	else if (n_damage <= 0.67*direct_hit_damage)
		H.show_message(SPAN_WARNING("Your armor softens the blow!"), null, null, null, CHAT_TYPE_ARMOR_DAMAGE)

	H.apply_damage(n_damage, BRUTE, affecting, 0, sharp = 0, edge = 0)
	xeno_throw_human(H, X, X.dir, 3)

	L.last_damage_mob = X
	L.last_damage_source = initial(X.caste_name)
	return

// This ties the pounce/throwing backend into the old collision backend
/mob/living/carbon/Xenomorph/Crusher/obj_launch_collision(var/obj/O)
	var/datum/action/xeno_action/activable/pounce/crusher_charge/CCA = get_xeno_action_by_type(src, /datum/action/xeno_action/activable/pounce/crusher_charge)
	if (istype(CCA) && !CCA.action_cooldown_check())
		CCA.reduce_cooldown(80)

	src.gain_plasma(10)

	if (!handle_collision(O)) // Check old backend
		..(O)
	else
		return TRUE

/mob/living/carbon/Xenomorph/Crusher/turf_launch_collision(var/turf/T)
	if (throwing)
		T.ex_act(EXPLOSION_THRESHOLD_MLOW)
	. = ..(T)

/datum/action/xeno_action/onclick/crusher_stomp/use_ability(atom/A)
	var/mob/living/carbon/Xenomorph/X = owner
	if (!istype(X))
		return

	if (!action_cooldown_check())
		return
	
	if (!X.check_state())
		return

	if (!check_and_use_plasma_owner())
		return
	
	playsound(get_turf(X), 'sound/effects/bang.ogg', 25, 0)
	X.visible_message(SPAN_XENODANGER("[X] smashes into the ground!"), SPAN_XENODANGER("You smash into the ground!"))
	X.create_stomp()

	for (var/mob/living/carbon/human/H in get_turf(X))
		if (H.stat == DEAD)
			continue
		new effect_type_base(H, X, , , effect_duration)
		to_chat(H, SPAN_XENOHIGHDANGER("You are slowed as [X] knocks you off balance!"))
		H.KnockDown(0.2)

		var/affecting = H.get_limb("chest")
		var/armor_block = H.getarmor(affecting, ARMOR_MELEE)

		var/n_damage = armor_damage_reduction(config.marine_melee, damage, armor_block)
		if (n_damage <= 0.34*damage)
			H.show_message(SPAN_WARNING("Your armor absorbs the blow!"), null, null, null, CHAT_TYPE_ARMOR_DAMAGE)
		else if (n_damage <= 0.67*damage)
			H.show_message(SPAN_WARNING("Your armor softens the blow!"), null, null, null, CHAT_TYPE_ARMOR_DAMAGE)

		H.apply_damage(n_damage, BRUTE, affecting, 0, sharp = 0, edge = 0)
		H.last_damage_mob = X
		H.last_damage_source = initial(X.caste_name)

	for (var/mob/living/carbon/human/H in orange(distance, get_turf(X)))
		new effect_type_base(H, X, , , effect_duration)
		H.KnockDown(0.2)
		to_chat(H, SPAN_XENOHIGHDANGER("You are slowed as [X] knocks you off balance!"))

	apply_cooldown()
	..()
	return

/datum/action/xeno_action/onclick/crusher_shield/use_ability(atom/A)
	var/mob/living/carbon/Xenomorph/X = owner

	if (!istype(X))
		return

	if (!action_cooldown_check())
		return

	if (!X.check_state())
		return

	if (!check_and_use_plasma_owner())
		return

	X.visible_message(SPAN_XENOWARNING("[X] hunkers down and bolsters its defenses!"), SPAN_XENOHIGHDANGER("You hunker down and bolster your defenses!"))

	X.create_crusher_shield()

	X.add_xeno_shield(shield_amount, XENO_SHIELD_SOURCE_CRUSHER, /datum/xeno_shield/crusher)
	X.overlay_shields()

	X.explosivearmor_modifier += 1000
	X.recalculate_armor()
	
	add_timer(CALLBACK(src, .proc/remove_explosion_immunity), 25, TIMER_UNIQUE)
	add_timer(CALLBACK(src, .proc/remove_shield), 100, TIMER_UNIQUE)

	apply_cooldown()
	..()
	return

/datum/action/xeno_action/onclick/crusher_shield/proc/remove_explosion_immunity()
	var/mob/living/carbon/Xenomorph/X = owner
	if (!istype(X))
		return

	X.explosivearmor_modifier -= 1000
	X.recalculate_armor()
	to_chat(X, SPAN_XENODANGER("Your immunity to explosion damage ends!"))

/datum/action/xeno_action/onclick/crusher_shield/proc/remove_shield()
	var/mob/living/carbon/Xenomorph/X = owner
	if (!istype(X))
		return

	var/datum/xeno_shield/found
	for (var/datum/xeno_shield/XS in X.xeno_shields)
		if (XS.shield_source == XENO_SHIELD_SOURCE_CRUSHER)
			found = XS
			break

	if (istype(found))
		qdel(found)
		to_chat(X, SPAN_XENOHIGHDANGER("You feel your enhanced shield end!"))