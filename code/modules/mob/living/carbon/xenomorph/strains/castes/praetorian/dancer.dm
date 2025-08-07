/datum/xeno_strain/dancer
	// My name is Cuban Pete, I'm the King of the Rumba Beat
	name = PRAETORIAN_DANCER
	description = "You lose all of your acid-based abilities and a small amount of your armor in exchange for increased movement speed, evasion, and unparalleled agility that gives you an ability to move even more quickly, dodge bullets, and phase through enemies and allies alike. By slashing enemies, you temporarily increase your movement speed and you also you apply a tag that changes how your two new tail abilities function. By tagging enemies, you will make Impale hit twice instead of once and make Tail Trip knock enemies down instead of stunning them."
	flavor_description = "A performance fit for a Queen, this one will become my instrument of death."
	icon_state_prefix = "Dancer"

	actions_to_remove = list(
		/datum/action/xeno_action/activable/xeno_spit,
		/datum/action/xeno_action/activable/pounce/base_prae_dash,
		/datum/action/xeno_action/activable/prae_acid_ball,
		/datum/action/xeno_action/activable/spray_acid/base_prae_spray_acid,
		/datum/action/xeno_action/activable/corrosive_acid,
	)
	actions_to_add = list(
		/datum/action/xeno_action/activable/prae_impale,
		/datum/action/xeno_action/onclick/prae_dodge,
		/datum/action/xeno_action/activable/prae_tail_trip,
	)

	behavior_delegate_type = /datum/behavior_delegate/praetorian_dancer

/datum/xeno_strain/dancer/apply_strain(mob/living/carbon/xenomorph/praetorian/prae)
	prae.armor_modifier -= XENO_ARMOR_MOD_VERY_SMALL
	prae.speed_modifier += XENO_SPEED_FASTMOD_TIER_5
	prae.plasma_types = list(PLASMA_CATECHOLAMINE)
	prae.claw_type = CLAW_TYPE_SHARP

	prae.recalculate_everything()

/datum/behavior_delegate/praetorian_dancer
	name = "Praetorian Dancer Behavior Delegate"

	// State
	var/dodge_activated = FALSE

/datum/behavior_delegate/praetorian_dancer/melee_attack_additional_effects_target(mob/living/carbon/target_carbon)
	if (!isxeno_human(target_carbon))
		return

	if (target_carbon.stat)
		return

	// Clean up all tags to 'refresh' our TTL
	for (var/datum/effects/dancer_tag/target_tag in target_carbon.effects_list)
		qdel(target_tag)

	new /datum/effects/dancer_tag(target_carbon, bound_xeno, , , 35)

	if(ishuman(target_carbon))
		var/mob/living/carbon/human/target_human = target_carbon
		target_human.update_xeno_hostile_hud()

/datum/action/xeno_action/activable/prae_impale/use_ability(atom/target_atom)
	var/mob/living/carbon/xenomorph/dancer_user = owner

	if (!action_cooldown_check())
		return

	if (!dancer_user.check_state())
		return

	if (!ismob(target_atom))
		apply_cooldown_override(impale_click_miss_cooldown)
		update_button_icon()
		return

	if (!isxeno_human(target_atom) || dancer_user.can_not_harm(target_atom))
		to_chat(dancer_user, SPAN_XENODANGER("We must target a hostile!"))
		return

	if (!dancer_user.Adjacent(target_atom))
		to_chat(dancer_user, SPAN_XENODANGER("We must be adjacent to [target_atom]!"))
		return

	var/mob/living/carbon/target_carbon = target_atom

	if (target_carbon.stat == DEAD)
		to_chat(dancer_user, SPAN_XENOWARNING("[target_atom] is dead, why would we want to attack it?"))
		return

	if (!check_and_use_plasma_owner())
		return

	apply_cooldown()
	var/buffed = FALSE
	for (var/datum/effects/dancer_tag/dancer_tag_effect in target_carbon.effects_list)
		buffed = TRUE
		qdel(dancer_tag_effect)
		break

	if(ishuman(target_carbon))
		var/mob/living/carbon/human/Hu = target_carbon
		Hu.update_xeno_hostile_hud()

	// Hmm todayvisible_message(SPAN_DANGER("\The [dancer_user] violently slices [target_atom] with its tail[buffed?" twice":""]!"),
	dancer_user.face_atom(target_atom)

	var/damage = get_xeno_damage_slash(target_carbon, rand(dancer_user.melee_damage_lower, dancer_user.melee_damage_upper))

	dancer_user.visible_message(SPAN_DANGER("\The [dancer_user] violently slices [target_atom] with its tail[buffed?" twice":""]!"),
					SPAN_DANGER("We slice [target_atom] with our tail[buffed?" twice":""]!"))

	if(buffed)
		// Do two attacks instead of one
		dancer_user.animation_attack_on(target_atom)
		dancer_user.flick_attack_overlay(target_atom, "tail")
		dancer_user.emote("roar") // Feedback for the player that we got the magic double impale

		target_carbon.apply_armoured_damage(damage, ARMOR_MELEE, BRUTE, "chest", 10)
		playsound(target_carbon, 'sound/weapons/alien_tail_attack.ogg', 30, TRUE)

		// Reroll damage
		damage = get_xeno_damage_slash(target_carbon, rand(dancer_user.melee_damage_lower, dancer_user.melee_damage_upper))
		sleep(4) // Short sleep so the animation and sounds will be distinct, but this creates some strange effects if the prae runs away. not entirely happy with this, but I think its benefits outweigh its drawbacks

	dancer_user.animation_attack_on(target_atom)
	dancer_user.flick_attack_overlay(target_atom, "tail")

	target_carbon.last_damage_data = create_cause_data(initial(dancer_user.caste_type), dancer_user)
	target_carbon.apply_armoured_damage(damage, ARMOR_MELEE, BRUTE, "chest", 10)
	playsound(target_carbon, 'sound/weapons/alien_tail_attack.ogg', 30, TRUE)
	return ..()

/datum/action/xeno_action/onclick/prae_dodge/use_ability(atom/target)
	var/mob/living/carbon/xenomorph/dodge_user = owner

	if (!action_cooldown_check())
		return

	if (!istype(dodge_user) || !dodge_user.check_state())
		return

	if (!check_and_use_plasma_owner())
		return

	var/datum/behavior_delegate/praetorian_dancer/behavior = dodge_user.behavior_delegate
	if (!istype(behavior))
		return

	behavior.dodge_activated = TRUE
	button.icon_state = "template_active"
	to_chat(dodge_user, SPAN_XENOHIGHDANGER("We can now dodge through mobs!"))
	dodge_user.speed_modifier -= speed_buff_amount
	dodge_user.add_temp_pass_flags(PASS_MOB_THRU)
	dodge_user.recalculate_speed()

	addtimer(CALLBACK(src, PROC_REF(remove_effects)), duration)

	apply_cooldown()
	return ..()

/datum/action/xeno_action/onclick/prae_dodge/proc/remove_effects()
	var/mob/living/carbon/xenomorph/dodge_remove = owner

	if (!istype(dodge_remove))
		return

	var/datum/behavior_delegate/praetorian_dancer/behavior = dodge_remove.behavior_delegate
	if (!istype(behavior))
		return

	if (behavior.dodge_activated)
		behavior.dodge_activated = FALSE
		button.icon_state = "template"
		dodge_remove.speed_modifier += speed_buff_amount
		dodge_remove.remove_temp_pass_flags(PASS_MOB_THRU)
		dodge_remove.recalculate_speed()
		to_chat(dodge_remove, SPAN_XENOHIGHDANGER("We can no longer dodge through mobs!"))

/datum/action/xeno_action/activable/prae_tail_trip/use_ability(atom/target_atom)
	var/mob/living/carbon/xenomorph/dancer_user = owner

	if (!action_cooldown_check())
		return

	if (!istype(dancer_user) || !dancer_user.check_state())
		return

	if (!ismob(target_atom))
		apply_cooldown_override(tail_click_miss_cooldown)
		update_button_icon()
		return

	if (!isxeno_human(target_atom) || dancer_user.can_not_harm(target_atom))
		to_chat(dancer_user, SPAN_XENODANGER("We must target a hostile!"))
		return

	var/mob/living/carbon/target_carbon = target_atom

	if (target_carbon.stat == DEAD)
		to_chat(dancer_user, SPAN_XENOWARNING("[target_atom] is dead, why would we want to attack it?"))
		return

	if (!check_and_use_plasma_owner())
		return


	if(ishuman(target_carbon))
		var/mob/living/carbon/human/target_human = target_carbon
		target_human.update_xeno_hostile_hud()

	var/dist = get_dist(dancer_user, target_carbon)

	if (dist > range)
		to_chat(dancer_user, SPAN_WARNING("[target_carbon] is too far away!"))
		return

	if (dist > 1)
		var/turf/targetTurf = get_step(dancer_user, get_dir(dancer_user, target_carbon))
		if (targetTurf.density)
			to_chat(dancer_user, SPAN_WARNING("We can't attack through [targetTurf]!"))
			return
		else
			for (var/atom/atom_in_turf in targetTurf)
				if (atom_in_turf.density && !atom_in_turf.throwpass && !istype(atom_in_turf, /obj/structure/barricade) && !istype(atom_in_turf, /mob/living))
					to_chat(dancer_user, SPAN_WARNING("We can't attack through [atom_in_turf]!"))
					return



	// Hmm today I will kill a marine while looking away from them
	dancer_user.face_atom(target_carbon)
	dancer_user.flick_attack_overlay(target_carbon, "disarm")

	var/buffed = FALSE

	var/datum/effects/dancer_tag/dancer_tag_effect = locate() in target_carbon.effects_list

	if (dancer_tag_effect)
		buffed = TRUE
		qdel(dancer_tag_effect)

	if (!buffed)
		new /datum/effects/xeno_slow(target_carbon, dancer_user, null, null, get_xeno_stun_duration(target_carbon, slow_duration))

	var/stun_duration = stun_duration_default
	var/daze_duration = 0

	if (buffed)
		stun_duration = stun_duration_buffed
		daze_duration = daze_duration_buffed

	var/xeno_smashed = FALSE

	if(isxeno(target_carbon))
		var/mob/living/carbon/xenomorph/Xeno = target_carbon
		if(Xeno.mob_size >= MOB_SIZE_BIG)
			xeno_smashed = TRUE
			shake_camera(Xeno, 10, 1)
			dancer_user.visible_message(SPAN_XENODANGER("[dancer_user] smashes [Xeno] with it's tail!"), SPAN_XENODANGER("We smash [Xeno] with your tail!"))
			to_chat(Xeno, SPAN_XENOHIGHDANGER("You feel dizzy as [dancer_user] smashes you with their tail!"))
			dancer_user.animation_attack_on(Xeno)

	if(!xeno_smashed)
		if (stun_duration > 0)
			target_carbon.apply_effect(stun_duration, WEAKEN)
		dancer_user.visible_message(SPAN_XENODANGER("[dancer_user] trips [target_atom] with it's tail!"), SPAN_XENODANGER("We trip [target_atom] with our tail!"))
		dancer_user.spin_circle()
		dancer_user.emote("tail")
		to_chat(target_carbon, SPAN_XENOHIGHDANGER("You are swept off your feet by [dancer_user]!"))
	if (daze_duration > 0)
		target_carbon.apply_effect(daze_duration, DAZE)

	apply_cooldown()
	return ..()

/datum/action/xeno_action/activable/prae_acid_ball/use_ability(atom/A)
	if (!A)
		return

	var/mob/living/carbon/xenomorph/acidball_user = owner
	if (!acidball_user.check_state() || acidball_user.action_busy)
		return

	if (!action_cooldown_check())
		return
	var/turf/current_turf = get_turf(acidball_user)

	if (!current_turf)
		return

	if (!do_after(acidball_user, activation_delay, INTERRUPT_ALL | BEHAVIOR_IMMOBILE, BUSY_ICON_HOSTILE))
		to_chat(acidball_user, SPAN_XENODANGER("We cancel our acid ball."))
		return

	if (!check_and_use_plasma_owner())
		return

	apply_cooldown()

	to_chat(acidball_user, SPAN_XENOWARNING("We lob a compressed ball of acid into the air!"))

	var/obj/item/explosive/grenade/xeno_acid_grenade/grenade = new /obj/item/explosive/grenade/xeno_acid_grenade
	grenade.cause_data = create_cause_data(initial(acidball_user.caste_type), acidball_user)
	grenade.forceMove(get_turf(acidball_user))
	grenade.throw_atom(A, 5, SPEED_SLOW, acidball_user, TRUE)
	addtimer(CALLBACK(grenade, TYPE_PROC_REF(/obj/item/explosive, prime)), prime_delay)

	return ..()
