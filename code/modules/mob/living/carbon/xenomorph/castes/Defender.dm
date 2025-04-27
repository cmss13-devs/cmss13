/datum/caste_datum/defender
	caste_type = XENO_CASTE_DEFENDER
	caste_desc = "A sturdy front line combatant."
	tier = 1

	melee_damage_lower = XENO_DAMAGE_TIER_2
	melee_damage_upper = XENO_DAMAGE_TIER_3
	melee_vehicle_damage = XENO_DAMAGE_TIER_3
	max_health = XENO_HEALTH_TIER_6
	plasma_gain = XENO_PLASMA_GAIN_TIER_9
	plasma_max = XENO_PLASMA_TIER_1
	xeno_explosion_resistance = XENO_EXPLOSIVE_ARMOR_TIER_7
	armor_deflection = XENO_ARMOR_TIER_4
	evasion = XENO_EVASION_NONE
	speed = XENO_SPEED_TIER_6

	evolves_to = list(XENO_CASTE_WARRIOR)
	deevolves_to = list(XENO_CASTE_LARVA)
	can_vent_crawl = 0

	available_strains = list(/datum/xeno_strain/steel_crest)
	behavior_delegate_type = /datum/behavior_delegate/defender_base

	tackle_min = 2
	tackle_max = 4

	minimum_evolve_time = 4 MINUTES

	minimap_icon = "defender"

/mob/living/carbon/xenomorph/defender
	caste_type = XENO_CASTE_DEFENDER
	name = XENO_CASTE_DEFENDER
	desc = "A alien with an armored crest."
	icon = 'icons/mob/xenos/castes/tier_1/defender.dmi'
	icon_size = 64
	icon_state = "Defender Walking"
	plasma_types = list(PLASMA_CHITIN)
	pixel_x = -16
	old_x = -16
	tier = 1
	organ_value = 1000

	base_actions = list(
		/datum/action/xeno_action/onclick/xeno_resting,
		/datum/action/xeno_action/onclick/release_haul,
		/datum/action/xeno_action/watch_xeno,
		/datum/action/xeno_action/activable/tail_stab/slam,
		/datum/action/xeno_action/onclick/toggle_crest,
		/datum/action/xeno_action/activable/headbutt,
		/datum/action/xeno_action/onclick/tail_sweep,
		/datum/action/xeno_action/activable/fortify,
		/datum/action/xeno_action/onclick/tacmap,
	)

	icon_xeno = 'icons/mob/xenos/castes/tier_1/defender.dmi'
	icon_xenonid = 'icons/mob/xenonids/castes/tier_1/defender.dmi'

	weed_food_icon = 'icons/mob/xenos/weeds_64x64.dmi'
	weed_food_states = list("Defender_1","Defender_2","Defender_3")
	weed_food_states_flipped = list("Defender_1","Defender_2","Defender_3")

	skull = /obj/item/skull/defender
	pelt = /obj/item/pelt/defender

/mob/living/carbon/xenomorph/defender/handle_special_state()
	if(fortify)
		return TRUE
	if(crest_defense)
		return TRUE
	return FALSE

/mob/living/carbon/xenomorph/defender/handle_special_wound_states(severity)
	. = ..()
	if(fortify)
		return "Defender_fortify_[severity]"
	if(crest_defense)
		return "Defender_crest_[severity]"

/mob/living/carbon/xenomorph/defender/handle_special_backpack_states()
	. = ..()
	if(fortify)
		return " Fortify"
	if(crest_defense)
		return " Crest"

/datum/behavior_delegate/defender_base
	name = "Base Defender Behavior Delegate"

/datum/behavior_delegate/defender_base/on_update_icons()
	if(bound_xeno.stat == DEAD)
		return

	if(bound_xeno.fortify && bound_xeno.health > 0)
		bound_xeno.icon_state = "[bound_xeno.get_strain_icon()] Defender Fortify"
		return TRUE
	if(bound_xeno.crest_defense && bound_xeno.health > 0)
		bound_xeno.icon_state = "[bound_xeno.get_strain_icon()] Defender Crest"
		return TRUE


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
		fendy.throw_atom(get_step_towards(carbone, fendy), 3, SPEED_SLOW, fendy, tracking=TRUE)
	if(!fendy.Adjacent(carbone))
		on_cooldown_end()
		return

	carbone.last_damage_data = create_cause_data(fendy.caste_type, fendy)
	fendy.visible_message(SPAN_XENOWARNING("[fendy] rams [carbone] with its armored crest!"),
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
		xeno.balloon_alert(xeno, "our crest is lowered!", text_color = "#7d32bb", delay = 1 SECONDS)
		return

	xeno.visible_message(SPAN_XENOWARNING("[xeno] sweeps its tail in a wide circle!"),
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
		xeno.balloon_alert(xeno, "our crest is lowered!", text_color = "#7d32bb", delay = 1 SECONDS)
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
	. = ..()
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
