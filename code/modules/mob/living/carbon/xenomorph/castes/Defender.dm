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
		/datum/action/xeno_action/onclick/toggle_seethrough,
		/datum/action/xeno_action/onclick/xeno_resting,
		/datum/action/xeno_action/onclick/release_haul,
		/datum/action/xeno_action/watch_xeno,
		/datum/action/xeno_action/activable/tail_stab/slam,
		/datum/action/xeno_action/onclick/toggle_crest,
		/datum/action/xeno_action/activable/headbutt,
		/datum/action/xeno_action/onclick/tail_sweep,
		/datum/action/xeno_action/activable/fortify,
	)

	icon_xeno = 'icons/mob/xenos/castes/tier_1/defender.dmi'
	icon_xenonid = 'icons/mob/xenonids/castes/tier_1/defender.dmi'

	weed_food_icon = 'icons/mob/xenos/weeds_64x64.dmi'
	weed_food_states = list("Defender_1","Defender_2","Defender_3")
	weed_food_states_flipped = list("Defender_1","Defender_2","Defender_3")

	skull = /obj/item/skull/defender
	pelt = /obj/item/pelt/defender

/mob/living/carbon/xenomorph/defender/handle_special_state()
	if(HAS_TRAIT(src, TRAIT_ABILITY_FORTIFY))
		return TRUE
	if(HAS_TRAIT(src, TRAIT_ABILITY_CREST))
		return TRUE
	return FALSE

/mob/living/carbon/xenomorph/defender/handle_special_wound_states(severity)
	. = ..()
	if(HAS_TRAIT(src, TRAIT_ABILITY_FORTIFY))
		return "Defender_fortify_[severity]"
	if(HAS_TRAIT(src, TRAIT_ABILITY_CREST))
		return "Defender_crest_[severity]"

/mob/living/carbon/xenomorph/defender/handle_special_backpack_states()
	. = ..()
	if(HAS_TRAIT(src, TRAIT_ABILITY_FORTIFY))
		return " Fortify"
	if(HAS_TRAIT(src, TRAIT_ABILITY_CREST))
		return " Crest"

/mob/living/carbon/xenomorph/defender/ex_act()
	. = ..()
	if(HAS_TRAIT(src, TRAIT_INCAPACITATED) && HAS_TRAIT(src, TRAIT_FLOORED))
		if(HAS_TRAIT(src, TRAIT_ABILITY_FORTIFY))
			var/datum/action/xeno_action/activable/fortify/fortify_used = get_action(src, /datum/action/xeno_action/activable/fortify)
			fortify_used.stop_fortify()

/mob/living/carbon/xenomorph/defender/death()
	var/datum/action/xeno_action/activable/fortify/fortify_used = get_action(src, /datum/action/xeno_action/activable/fortify)
	if(HAS_TRAIT(src, TRAIT_ABILITY_FORTIFY))
		fortify_used.stop_fortify()

	var/datum/action/xeno_action/onclick/toggle_crest/crest_used = get_action(src, /datum/action/xeno_action/onclick/toggle_crest)
	if(HAS_TRAIT(src, TRAIT_ABILITY_CREST))
		crest_used.stop_crest()

	return ..()


/datum/behavior_delegate/defender_base
	name = "Base Defender Behavior Delegate"

/datum/behavior_delegate/defender_base/on_update_icons()
	if(bound_xeno.stat == DEAD)
		return

	if(!HAS_TRAIT(bound_xeno, TRAIT_INCAPACITATED) && !HAS_TRAIT(bound_xeno, TRAIT_FLOORED))
		if(HAS_TRAIT(bound_xeno, TRAIT_ABILITY_FORTIFY) && bound_xeno.health > 0)
			bound_xeno.icon_state = "[bound_xeno.get_strain_icon()] Defender Fortify"
			return TRUE

		if(HAS_TRAIT(bound_xeno, TRAIT_ABILITY_CREST) && bound_xeno.health > 0)
			bound_xeno.icon_state = "[bound_xeno.get_strain_icon()] Defender Crest"
			return TRUE

	else
		bound_xeno.icon_state = "[bound_xeno.get_strain_icon()] Defender Knocked Down"


/datum/action/xeno_action/onclick/toggle_crest/use_ability(atom/target_atom)
	var/mob/living/carbon/xenomorph/xeno = owner
	if(!istype(xeno))
		return

	if(HAS_TRAIT(xeno, TRAIT_ABILITY_FORTIFY))
		to_chat(xeno, SPAN_XENOWARNING("We cannot use crest while fortified."))
		return

	XENO_ACTION_CHECK(xeno)

	if(HAS_TRAIT(xeno, TRAIT_ABILITY_CREST))
		stop_crest()
	else
		start_crest()

	return ..()

/datum/action/xeno_action/onclick/toggle_crest/proc/start_crest()
	var/mob/living/carbon/xenomorph/xeno = owner

	ADD_TRAIT(xeno, TRAIT_ABILITY_CREST, TRAIT_SOURCE_ABILITY("crest"))
	to_chat(xeno, SPAN_XENOWARNING("We lower our crest."))
	xeno.ability_speed_modifier += speed_debuff
	xeno.armor_deflection_buff += armor_buff
	xeno.mob_size = MOB_SIZE_BIG //knockback immune
	button.icon_state = "template_active"
	xeno.update_icons()
	apply_cooldown()

/datum/action/xeno_action/onclick/toggle_crest/proc/stop_crest()
	var/mob/living/carbon/xenomorph/xeno = owner

	REMOVE_TRAIT(xeno, TRAIT_ABILITY_CREST, TRAIT_SOURCE_ABILITY("crest"))
	to_chat(xeno, SPAN_XENOWARNING("We raise our crest."))
	xeno.ability_speed_modifier -= speed_debuff
	xeno.armor_deflection_buff -= armor_buff
	xeno.mob_size = MOB_SIZE_XENO //no longer knockback immune
	button.icon_state = "template_xeno"
	xeno.update_icons()
	apply_cooldown()



// Defender Headbutt
/datum/action/xeno_action/activable/headbutt/use_ability(atom/target_atom)
	var/mob/living/carbon/xenomorph/xeno = owner
	if(!istype(xeno))
		return

	if(!isxeno_human(target_atom) || xeno.can_not_harm(target_atom))
		return

	XENO_ACTION_CHECK_USE_PLASMA(xeno)

	if(HAS_TRAIT(xeno, TRAIT_ABILITY_FORTIFY) && !usable_while_fortified)
		to_chat(xeno, SPAN_XENOWARNING("We cannot use headbutt while fortified."))
		return

	var/mob/living/carbon/target_carbon = target_atom
	if(target_carbon.stat == DEAD)
		return

	var/fortify = HAS_TRAIT(xeno, TRAIT_ABILITY_FORTIFY)
	var/crest_defense = HAS_TRAIT(xeno, TRAIT_ABILITY_CREST)

	var/distance = get_dist(xeno, target_carbon)

	var/max_distance = 3 - (crest_defense ? 2 : 0)

	if(distance > max_distance)
		return

	if(!crest_defense)
		apply_cooldown()
		xeno.throw_atom(get_step_towards(target_carbon, xeno), 3, SPEED_SLOW, xeno, tracking=TRUE)
	if(!xeno.Adjacent(target_carbon))
		on_cooldown_end()
		return

	target_carbon.last_damage_data = create_cause_data(xeno.caste_type, xeno)
	xeno.visible_message(SPAN_XENOWARNING("[xeno] rams [target_carbon] with its armored crest!"),
	SPAN_XENOWARNING("We ram [target_carbon] with our armored crest!"))

	if(target_carbon.stat != DEAD && (!(target_carbon.status_flags & XENO_HOST) || !HAS_TRAIT(target_carbon, TRAIT_NESTED)))
		// -10 damage if their crest is down.
		var/damage = base_damage - (crest_defense ? 10 : 0)
		target_carbon.apply_armoured_damage(get_xeno_damage_slash(target_carbon, damage), ARMOR_MELEE, BRUTE, "chest", 5)

	var/facing = get_dir(xeno, target_carbon)
	var/headbutt_distance = 1 + (crest_defense ? 2 : 0) + (fortify ? 2 : 0)

	// Hmm today I will kill a marine while looking away from them
	xeno.face_atom(target_carbon)
	xeno.animation_attack_on(target_carbon)
	xeno.flick_attack_overlay(target_carbon, "punch")
	xeno.throw_carbon(target_carbon, facing, headbutt_distance, SPEED_SLOW, shake_camera = FALSE, immobilize = FALSE)
	playsound(target_carbon,'sound/weapons/alien_claw_block.ogg', 50, 1)
	apply_cooldown()
	return ..()



// Defender Tail Sweep
/datum/action/xeno_action/onclick/tail_sweep/use_ability(atom/target_atom)
	var/mob/living/carbon/xenomorph/xeno = owner
	if(!istype(xeno))
		return

	XENO_ACTION_CHECK(xeno)

	if(HAS_TRAIT(xeno, TRAIT_ABILITY_FORTIFY))
		to_chat(xeno, SPAN_XENOWARNING("We cannot use tail swipe while fortified."))
		return

	if(HAS_TRAIT(xeno, TRAIT_ABILITY_CREST))
		xeno.balloon_alert(xeno, "our crest is lowered!", text_color = "#7d32bb", delay = 1 SECONDS)
		return

	xeno.visible_message(SPAN_XENOWARNING("[xeno] sweeps its tail in a wide circle!"),
	SPAN_XENOWARNING("We sweep our tail in a wide circle!"))

	XENO_ACTION_CHECK_USE_PLASMA(xeno)

	xeno.spin_circle()
	xeno.emote("tail")

	var/sweep_range = 1
	for(var/mob/living/carbon/human in orange(sweep_range, get_turf(xeno)))
		if(!isxeno_human(human) || xeno.can_not_harm(human))
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
/datum/action/xeno_action/activable/fortify/use_ability(atom/target_atom)
	var/mob/living/carbon/xenomorph/xeno = owner
	if(!istype(xeno))
		return

	if(HAS_TRAIT(xeno, TRAIT_ABILITY_CREST))
		xeno.balloon_alert(xeno, "our crest is lowered!", text_color = "#7d32bb", delay = 1 SECONDS)
		return

	XENO_ACTION_CHECK(xeno)

	playsound(get_turf(xeno), 'sound/effects/stonedoor_openclose.ogg', 30, 1)

	if(HAS_TRAIT(xeno, TRAIT_ABILITY_FORTIFY))
		stop_fortify()
		if(xeno.selected_ability != src)
			button.icon_state = "template_xeno"
	else
		start_fortify()
		if(xeno.selected_ability != src)
			button.icon_state = "template_active"

	xeno.update_icons()
	apply_cooldown()
	return ..()

/datum/action/xeno_action/activable/fortify/action_activate()
	. = ..()
	..()
	var/mob/living/carbon/xenomorph/xeno = owner
	if(HAS_TRAIT(xeno, TRAIT_ABILITY_FORTIFY) && xeno.selected_ability != src)
		button.icon_state = "template_active"

/datum/action/xeno_action/activable/fortify/action_deselect()
	..()
	var/mob/living/carbon/xenomorph/xeno = owner
	if(HAS_TRAIT(xeno, TRAIT_ABILITY_FORTIFY))
		button.icon_state = "template_active"

/datum/action/xeno_action/activable/fortify/proc/start_fortify()
	var/mob/living/carbon/xenomorph/xeno = owner

	RegisterSignal(xeno, COMSIG_XENO_ENTER_CRIT, PROC_REF(unconscious_check))
	RegisterSignal(xeno, COMSIG_MOB_DEATH, PROC_REF(unconscious_check))
	RegisterSignal(xeno, COMSIG_XENO_PRE_CALCULATE_ARMOURED_DAMAGE_PROJECTILE, PROC_REF(check_directional_projectile_armor))

	ADD_TRAIT(xeno, TRAIT_ABILITY_FORTIFY, TRAIT_SOURCE_ABILITY("fortify"))
	to_chat(xeno, SPAN_XENOWARNING("We tuck ourself into a defensive stance."))

	apply_modifiers(xeno, TRUE)
	xeno.mob_size = MOB_SIZE_IMMOBILE //knockback immune
	xeno.mob_flags &= ~SQUEEZE_UNDER_VEHICLES

/datum/action/xeno_action/activable/fortify/proc/stop_fortify()
	var/mob/living/carbon/xenomorph/xeno = owner

	UnregisterSignal(xeno, COMSIG_XENO_ENTER_CRIT)
	UnregisterSignal(xeno, COMSIG_MOB_DEATH)
	UnregisterSignal(xeno, COMSIG_XENO_PRE_CALCULATE_ARMOURED_DAMAGE_PROJECTILE)

	REMOVE_TRAIT(xeno, TRAIT_IMMOBILIZED, TRAIT_SOURCE_ABILITY("Fortify"))
	REMOVE_TRAIT(xeno, TRAIT_ABILITY_FORTIFY, TRAIT_SOURCE_ABILITY("fortify"))
	to_chat(xeno, SPAN_XENOWARNING("We resume our normal stance."))

	apply_modifiers(xeno, FALSE)
	xeno.anchored = FALSE
	xeno.mob_size = MOB_SIZE_XENO //no longer knockback immune
	xeno.mob_flags |= SQUEEZE_UNDER_VEHICLES

/datum/action/xeno_action/activable/fortify/proc/apply_modifiers(mob/living/carbon/xenomorph/xeno, fortify_state = FALSE)
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

/datum/action/xeno_action/activable/fortify/proc/check_directional_projectile_armor(mob/living/carbon/xenomorph/defendy, list/damagedata)
	SIGNAL_HANDLER
	var/projectile_direction = damagedata["direction"]
	// If the defender is facing the projectile.
	if(defendy.dir & REVERSE_DIR(projectile_direction))
		damagedata["armor"] += frontal_armor

