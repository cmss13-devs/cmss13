/datum/action/xeno_action/onclick/toggle_crest/use_ability(atom/target)
	var/mob/living/carbon/xenomorph/xeno = owner
	if (!istype(xeno))
		return

	if(xeno.fortify)
		to_chat(xeno, SPAN_XENOWARNING("We cannot use abilities while fortified."))
		return

	if(!xeno.check_state())
		return

	if(!action_cooldown_check())
		return

	xeno.crest_defense = !xeno.crest_defense

	if(xeno.crest_defense)
		to_chat(xeno, SPAN_XENOWARNING("We lower our crest."))

		xeno.ability_speed_modifier += speed_debuff
		xeno.armor_deflection_buff += armor_buff
		xeno.mob_size = MOB_SIZE_BIG //knockback immune
		button.icon_state = "template_active"
		xeno.update_icons()
	else
		to_chat(xeno, SPAN_XENOWARNING("We raise our crest."))

		xeno.ability_speed_modifier -= speed_debuff
		xeno.armor_deflection_buff -= armor_buff
		xeno.mob_size = MOB_SIZE_XENO //no longer knockback immune
		button.icon_state = "template"
		xeno.update_icons()

	apply_cooldown()
	return ..()

// Defender Headbutt
/datum/action/xeno_action/activable/headbutt/use_ability(atom/target_atom)
	var/mob/living/carbon/xenomorph/fendy = owner
	if(!istype(fendy))
		return

	if(!isxeno_human(target_atom) || fendy.can_not_harm(target_atom))
		return

	if(!fendy.check_state())
		return

	if(!action_cooldown_check())
		return

	if(!check_and_use_plasma_owner())
		return

	if(fendy.fortify && !usable_while_fortified)
		to_chat(fendy, SPAN_XENOWARNING("We cannot use headbutt while fortified."))
		return

	var/mob/living/carbon/carbone = target_atom
	if(carbone.stat == DEAD)
		return

	var/distance = get_dist(fendy, carbone)

	var/max_distance = 3 - (fendy.crest_defense * 2)

	if(distance > max_distance)
		return

	if(!fendy.crest_defense)
		apply_cooldown()
		fendy.throw_atom(get_step_towards(carbone, fendy), 3, SPEED_SLOW, fendy)
	if(!fendy.Adjacent(carbone))
		on_cooldown_end()
		return

	carbone.last_damage_data = create_cause_data(fendy.caste_type, fendy)
	fendy.visible_message(SPAN_XENOWARNING("[fendy] rams [carbone] with its armored crest!"), \
	SPAN_XENOWARNING("We ram [carbone] with our armored crest!"))

	if(carbone.stat != DEAD && (!(carbone.status_flags & XENO_HOST) || !HAS_TRAIT(carbone, TRAIT_NESTED)))
		// -10 damage if their crest is down.
		var/damage = base_damage - (fendy.crest_defense * 10)
		carbone.apply_armoured_damage(get_xeno_damage_slash(carbone, damage), ARMOR_MELEE, BRUTE, "chest", 5)

	var/facing = get_dir(fendy, carbone)
	var/headbutt_distance = 1 + (fendy.crest_defense * 2) + (fendy.fortify * 2)

	// Hmm today I will kill a marine while looking away from them
	fendy.face_atom(carbone)
	fendy.animation_attack_on(carbone)
	fendy.flick_attack_overlay(carbone, "punch")
	fendy.throw_carbon(carbone, facing, headbutt_distance, SPEED_SLOW, shake_camera = FALSE, immobilize = FALSE)
	playsound(carbone,'sound/weapons/alien_claw_block.ogg', 50, 1)
	apply_cooldown()
	return ..()

// Defender Tail Sweep
/datum/action/xeno_action/onclick/tail_sweep/use_ability(atom/A)
	var/mob/living/carbon/xenomorph/xeno = owner
	if (!istype(xeno))
		return

	if(!xeno.check_state())
		return

	if (!action_cooldown_check())
		return

	if(xeno.fortify)
		to_chat(src, SPAN_XENOWARNING("We cannot use tail swipe while fortified."))
		return

	if(xeno.crest_defense)
		to_chat(src, SPAN_XENOWARNING("We cannot use tail swipe with our crest lowered."))
		return

	xeno.visible_message(SPAN_XENOWARNING("[xeno] sweeps its tail in a wide circle!"), \
	SPAN_XENOWARNING("We sweep our tail in a wide circle!"))

	if(!check_and_use_plasma_owner())
		return

	xeno.spin_circle()
	xeno.emote("tail")

	var/sweep_range = 1
	for(var/mob/living/carbon/human in orange(sweep_range, get_turf(xeno)))
		if (!isxeno_human(human) || xeno.can_not_harm(human))
			continue
		if(human.stat == DEAD)
			continue
		if(HAS_TRAIT(human, TRAIT_NESTED))
			continue
		step_away(human, xeno, sweep_range, 2)
		xeno.flick_attack_overlay(human, "punch")
		human.last_damage_data = create_cause_data(xeno.caste_type, xeno)
		human.apply_armoured_damage(get_xeno_damage_slash(xeno, 15), ARMOR_MELEE, BRUTE)
		shake_camera(human, 2, 1)

		if(human.mob_size < MOB_SIZE_BIG)
			human.apply_effect(get_xeno_stun_duration(human, 1), WEAKEN)

		to_chat(human, SPAN_XENOWARNING("You are struck by [xeno]'s tail sweep!"))
		playsound(human,'sound/weapons/alien_claw_block.ogg', 50, 1)

	apply_cooldown()
	return ..()

// Defender Fortify
/datum/action/xeno_action/activable/fortify/use_ability(atom/target)
	var/mob/living/carbon/xenomorph/xeno = owner
	if (!istype(xeno))
		return

	if(xeno.crest_defense)
		to_chat(src, SPAN_XENOWARNING("We cannot use fortify with our crest lowered."))
		return

	if(!xeno.check_state())
		return

	if (!action_cooldown_check())
		return

	playsound(get_turf(xeno), 'sound/effects/stonedoor_openclose.ogg', 30, 1)

	if(!xeno.fortify)
		RegisterSignal(owner, COMSIG_XENO_ENTER_CRIT, PROC_REF(unconscious_check))
		RegisterSignal(owner, COMSIG_MOB_DEATH, PROC_REF(unconscious_check))
		fortify_switch(xeno, TRUE)
		if(xeno.selected_ability != src)
			button.icon_state = "template_active"
	else
		UnregisterSignal(owner, COMSIG_XENO_ENTER_CRIT)
		UnregisterSignal(owner, COMSIG_MOB_DEATH)
		fortify_switch(xeno, FALSE)
		if(xeno.selected_ability != src)
			button.icon_state = "template"

	apply_cooldown()
	return ..()

/datum/action/xeno_action/activable/fortify/action_activate()
	..()
	var/mob/living/carbon/xenomorph/xeno = owner
	if(xeno.fortify && xeno.selected_ability != src)
		button.icon_state = "template_active"

/datum/action/xeno_action/activable/fortify/action_deselect()
	..()
	var/mob/living/carbon/xenomorph/xeno = owner
	if(xeno.fortify)
		button.icon_state = "template_active"

/datum/action/xeno_action/activable/fortify/proc/fortify_switch(mob/living/carbon/xenomorph/xeno, fortify_state)
	if(xeno.fortify == fortify_state)
		return

	if(fortify_state)
		to_chat(xeno, SPAN_XENOWARNING("We tuck ourself into a defensive stance."))
		RegisterSignal(owner, COMSIG_XENO_PRE_CALCULATE_ARMOURED_DAMAGE_PROJECTILE, PROC_REF(check_directional_armor))
		xeno.mob_size = MOB_SIZE_IMMOBILE //knockback immune
		xeno.mob_flags &= ~SQUEEZE_UNDER_VEHICLES
		xeno.fortify = TRUE
	else
		to_chat(xeno, SPAN_XENOWARNING("We resume our normal stance."))
		REMOVE_TRAIT(xeno, TRAIT_IMMOBILIZED, TRAIT_SOURCE_ABILITY("Fortify"))
		xeno.anchored = FALSE
		UnregisterSignal(owner, COMSIG_XENO_PRE_CALCULATE_ARMOURED_DAMAGE_PROJECTILE)
		xeno.mob_size = MOB_SIZE_XENO //no longer knockback immune
		xeno.mob_flags |= SQUEEZE_UNDER_VEHICLES
		xeno.fortify = FALSE

	apply_modifiers(xeno, fortify_state)
	xeno.update_icons()

/datum/action/xeno_action/activable/fortify/proc/apply_modifiers(mob/living/carbon/xenomorph/xeno, fortify_state)
	if(fortify_state)
		xeno.armor_deflection_buff += 30
		xeno.armor_explosive_buff += 60
		ADD_TRAIT(xeno, TRAIT_IMMOBILIZED, TRAIT_SOURCE_ABILITY("Fortify"))
		xeno.anchored = TRUE
		xeno.small_explosives_stun = FALSE
	else
		xeno.armor_deflection_buff -= 30
		xeno.armor_explosive_buff -= 60
		xeno.small_explosives_stun = TRUE

// Steel crest override
/datum/action/xeno_action/activable/fortify/steel_crest/apply_modifiers(mob/living/carbon/xenomorph/xeno, fortify_state)
	if(fortify_state)
		xeno.armor_deflection_buff += 10
		xeno.armor_explosive_buff += 60
		xeno.ability_speed_modifier += 3
		xeno.damage_modifier -= XENO_DAMAGE_MOD_SMALL
	else
		xeno.armor_deflection_buff -= 10
		xeno.armor_explosive_buff -= 60
		xeno.ability_speed_modifier -= 3
		xeno.damage_modifier += XENO_DAMAGE_MOD_SMALL

/datum/action/xeno_action/activable/fortify/proc/check_directional_armor(mob/living/carbon/xenomorph/defendy, list/damagedata)
	SIGNAL_HANDLER
	var/projectile_direction = damagedata["direction"]
	// If the defender is facing the projectile.
	if(defendy.dir & REVERSE_DIR(projectile_direction))
		damagedata["armor"] += frontal_armor

/datum/action/xeno_action/activable/fortify/proc/unconscious_check()
	SIGNAL_HANDLER

	if(QDELETED(owner))
		return

	UnregisterSignal(owner, COMSIG_XENO_ENTER_CRIT)
	UnregisterSignal(owner, COMSIG_MOB_DEATH)
	fortify_switch(owner, FALSE)

/datum/action/xeno_action/onclick/soak/use_ability(atom/A)
	var/mob/living/carbon/xenomorph/steelcrest = owner

	if (!action_cooldown_check())
		return

	if (!steelcrest.check_state())
		return

	if(!check_and_use_plasma_owner())
		return

	RegisterSignal(steelcrest, COMSIG_XENO_TAKE_DAMAGE, PROC_REF(damage_accumulate))
	addtimer(CALLBACK(src, PROC_REF(stop_accumulating)), 6 SECONDS)

	steelcrest.balloon_alert(steelcrest, "begins to tank incoming damage!")

	to_chat(steelcrest, SPAN_XENONOTICE("We begin to tank incoming damage!"))

	steelcrest.add_filter("steelcrest_enraging", 1, list("type" = "outline", "color" = "#421313", "size" = 1))

	apply_cooldown()
	return ..()


/datum/action/xeno_action/onclick/soak/proc/damage_accumulate(owner, damage_data, damage_type)
	SIGNAL_HANDLER

	damage_accumulated += damage_data["damage"]

	if(damage_accumulated >= damage_threshold)
		addtimer(CALLBACK(src, PROC_REF(enraged), owner))
		UnregisterSignal(owner, COMSIG_XENO_TAKE_DAMAGE) // Two Unregistersignal because if the enrage proc doesnt happen, then it needs to stop counting

/datum/action/xeno_action/onclick/soak/proc/stop_accumulating()
	UnregisterSignal(owner, COMSIG_XENO_TAKE_DAMAGE)

	damage_accumulated = 0
	to_chat(owner, SPAN_XENONOTICE("We stop taking incoming damage."))
	owner.remove_filter("steelcrest_enraging")

/datum/action/xeno_action/onclick/soak/proc/enraged()

	owner.remove_filter("steelcrest_enraging")
	owner.add_filter("steelcrest_enraged", 1, list("type" = "outline", "color" = "#ad1313", "size" = 1))
	owner.visible_message(SPAN_XENOWARNING("[owner] gets enraged after being damaged enough!"), SPAN_XENOWARNING("We feel enraged after taking in oncoming damage! Our tail slam's cooldown is reset and we heal!"))

	var/mob/living/carbon/xenomorph/enraged_mob = owner
	enraged_mob.gain_health(75) // pretty reasonable amount of health recovered

	// Check actions list for tail slam and reset it's cooldown if it's there
	var/datum/action/xeno_action/activable/tail_stab/slam/slam_action = locate() in owner.actions

	if (slam_action && !slam_action.action_cooldown_check())
		slam_action.end_cooldown()


	addtimer(CALLBACK(src, PROC_REF(remove_enrage), owner), 3 SECONDS)


/datum/action/xeno_action/onclick/soak/proc/remove_enrage()
	owner.remove_filter("steelcrest_enraged")
