/datum/moba_caste/defender
	equivalent_caste_path = /datum/caste_datum/defender
	equivalent_xeno_path = /mob/living/carbon/xenomorph/defender
	name = XENO_CASTE_DEFENDER
	desc = {"
		Slow-moving frontliner that tanks through brute force and shields.<br>
		<b>P:</b> Stunning an already-stunned target grants a temporary shield.<br>
		<b>1:</b> Headbutt a nearby target, knocking them back and stunning them.<br>
		<b>2:</b> Knock back any nearby enemies, slowing and potentially stunning them.<br>
		<b>3:</b> Fortify yourself, converting damage taken into temporary shields.<br>
		<b>U:</b> After a short wind-up, smash your tail down, converting your shields into a stun on all nearby enemies.
	"}
	category = MOBA_ARCHETYPE_TANK
	icon_state = "defender"
	ideal_roles = list(MOBA_LANE_TOP)
	starting_health = 540
	ending_health = 1800
	starting_health_regen = 2
	ending_health_regen = 8
	starting_plasma = 250
	ending_plasma = 625
	starting_plasma_regen = 1.8
	ending_plasma_regen = 4.8
	starting_armor = 0
	ending_armor = 35
	starting_acid_armor = 0
	ending_acid_armor = 25
	speed = 0.7
	attack_delay_modifier = 0
	starting_attack_damage = 40
	ending_attack_damage = 55
	abilities_to_add = list(
		/datum/action/xeno_action/activable/moba_headbutt,
		/datum/action/xeno_action/onclick/moba_tail_sweep,
		/datum/action/xeno_action/onclick/moba_soak,
		/datum/action/xeno_action/onclick/moba_tremor,
	)

/datum/moba_caste/defender/apply_caste(mob/living/carbon/xenomorph/xeno, datum/component/moba_player/player_component, datum/moba_player/player_datum)
	. = ..()
	RegisterSignal(xeno, COMSIG_MOBA_STUN_GIVEN, PROC_REF(on_stunning_enemy))

/datum/moba_caste/defender/proc/on_stunning_enemy(mob/living/carbon/xenomorph/source, mob/living/target)
	SIGNAL_HANDLER

	if(HAS_TRAIT(target, TRAIT_IMMOBILIZED))
		source.apply_status_effect(/datum/status_effect/fortification)

// so called metalheads when they meet magnetheads:
/datum/action/xeno_action/activable/moba_headbutt
	name = "Headbutt"
	desc = "Knock back a targeted enemy by 1 tile, stunning them for 1.5/2/2.5 seconds. Additionally deals 30/45/60 (+35% AD) physical damage. Cooldown 8/7.5/7 seconds. Plasma cost 60."
	action_icon_state = "headbutt"
	macro_path = /datum/action/xeno_action/verb/verb_headbutt
	action_type = XENO_ACTION_CLICK
	ability_primacy = XENO_PRIMARY_ACTION_1
	xeno_cooldown = 8 SECONDS
	plasma_cost = 60

	var/damage = 30
	var/stun = 1.5 SECONDS

/datum/action/xeno_action/activable/moba_headbutt/use_ability(atom/target_atom)
	var/mob/living/carbon/xenomorph/fendy = owner
	if(!istype(fendy))
		return

	if(!isliving(target_atom) || fendy.can_not_harm(target_atom))
		return

	if(!fendy.check_state())
		return

	if(!action_cooldown_check())
		return

	if(!check_and_use_plasma_owner())
		return

	var/mob/living/living_target = target_atom
	if(living_target.stat == DEAD)
		return

	var/distance = get_dist(fendy, living_target)
	if(distance > 1)
		return

	living_target.last_damage_data = create_cause_data(fendy.caste_type, fendy)
	fendy.visible_message(SPAN_XENOWARNING("[fendy] rams [living_target] with its armored crest!"),
	SPAN_XENOWARNING("We ram [living_target] with our armored crest!"))

	SEND_SIGNAL(fendy, COMSIG_MOBA_STUN_GIVEN, living_target)
	living_target.KnockDown(stun * 0.1)

	var/facing = get_dir(fendy, living_target)

	// Hmm today I will kill a marine while looking away from them
	fendy.face_atom(living_target)
	fendy.animation_attack_on(living_target)
	fendy.flick_attack_overlay(living_target, "punch")
	fendy.throw_carbon(living_target, facing, 1, SPEED_SLOW, shake_camera = FALSE, immobilize = FALSE) //surely we can throw a living through throw carbon
	playsound(living_target,'sound/weapons/alien_claw_block.ogg', 50, 1)

	var/list/armorpen_list = list()
	SEND_SIGNAL(fendy, COMSIG_MOBA_GET_PHYS_PENETRATION, armorpen_list)
	living_target.apply_armoured_damage(damage + (fendy.melee_damage_upper * 0.35), ARMOR_MELEE, BRUTE, penetration = armorpen_list[1])

	apply_cooldown()
	return ..()

/datum/action/xeno_action/activable/moba_headbutt/level_up_ability(new_level)
	xeno_cooldown = src::xeno_cooldown - ((0.5 SECONDS) * (new_level - 1))
	damage = src::damage + (15 * (new_level - 1))
	stun = src::stun + ((0.5 SECONDS) * (new_level - 1))

	desc = "Knock back a targeted enemy by 1 tile, stunning them for [MOBA_LEVEL_ABILITY_DESC_HELPER(new_level, "1.5", "2", "2.5")] seconds. Additionally deals [MOBA_LEVEL_ABILITY_DESC_HELPER(new_level, "30", "45", "60")] (+35% AD) physical damage. Cooldown [MOBA_LEVEL_ABILITY_DESC_HELPER(new_level, "8", "7.5", "7")] seconds. Plasma cost 60."

// SpiiiiIIiiIeEEeEeEeen
/datum/action/xeno_action/onclick/moba_tail_sweep
	name = "Tail Sweep"
	desc = "Knock back all enemies around you by 1 tile, slowing them by 20/25/30% for 1.5 seconds. Additionally, if an enemy would collide with a solid object (wall, minion, tower, etc.), they are stunned for the same duration. Cooldown of 10/9/8 seconds. Plasma cost 50/45/40."
	action_icon_state = "tail_sweep"
	macro_path = /datum/action/xeno_action/verb/verb_tail_sweep
	action_type = XENO_ACTION_ACTIVATE
	ability_primacy = XENO_PRIMARY_ACTION_2
	plasma_cost = 50
	xeno_cooldown = 10 SECONDS

	var/slow = 0.2

/datum/action/xeno_action/onclick/moba_tail_sweep/use_ability(atom/A)
	var/mob/living/carbon/xenomorph/xeno = owner
	if(!istype(xeno))
		return

	if(!xeno.check_state())
		return

	if(!action_cooldown_check())
		return

	if(!check_and_use_plasma_owner())
		return

	xeno.visible_message(SPAN_XENOWARNING("[xeno] sweeps its tail in a wide circle!"),
	SPAN_XENOWARNING("We sweep our tail in a wide circle!"))

	xeno.spin_circle()
	xeno.emote("tail")

	var/sweep_range = 1
	var/debuff_duration = 1.5 SECONDS
	for(var/mob/living/target in orange(sweep_range, get_turf(xeno)))
		if(xeno.can_not_harm(target))
			continue
		if(target.stat == DEAD)
			continue
		target.apply_status_effect(/datum/status_effect/slow, slow, debuff_duration)
		var/turf/destination = get_step(target, get_dir(xeno, target))
		if(LinkBlocked(target, target.loc, destination))
			SEND_SIGNAL(xeno, COMSIG_MOBA_STUN_GIVEN, target)
			target.KnockDown(debuff_duration * 0.1)
			playsound(destination, "slam", 50)
			target.animation_spin(5, 1)
		step_away(target, xeno, sweep_range, 2)
		xeno.flick_attack_overlay(target, "punch")
		to_chat(target, SPAN_XENOWARNING("You are struck by [xeno]'s tail sweep!"))
		playsound(target, 'sound/weapons/alien_claw_block.ogg', 50, 1)

	apply_cooldown()
	return ..()

/datum/action/xeno_action/onclick/moba_tail_sweep/level_up_ability(new_level)
	xeno_cooldown = src::xeno_cooldown - ((1 SECONDS) * (new_level - 1))
	slow = src::slow + (0.1 * (new_level - 1))

	desc = "Knock back all enemies around you by 1 tile, slowing them by [MOBA_LEVEL_ABILITY_DESC_HELPER(new_level, "0.2", "0.3", "0.4")] for 1.5 seconds. Additionally, if an enemy would collide with a solid object (wall, minion, tower, etc.), they are stunned for the same duration. Cooldown of [MOBA_LEVEL_ABILITY_DESC_HELPER(new_level, "10", "9", "8")] seconds. Plasma cost [MOBA_LEVEL_ABILITY_DESC_HELPER(new_level, "50", "45", "40")]."

// "I am fucking invincible" - some bald guy
/datum/action/xeno_action/onclick/moba_soak
	name = "Soak"
	desc = "Take 50% reduced damage from all sources for 3 seconds. During this time, you are unable to attack and have your speed reduced by 0.5. Once the time ends, you gain 175%/200%/225% (+1% bonus HP) of the pre-mitigation damage taken as shields. These shields decay after 4/5/6 seconds. Cooldown of 16/15/14 seconds. Plasma cost 100."
	action_icon_state = "soak"
	macro_path = /datum/action/xeno_action/verb/verb_soak
	action_type = XENO_ACTION_ACTIVATE
	ability_primacy = XENO_PRIMARY_ACTION_3
	plasma_cost = 100
	xeno_cooldown = 16 SECONDS

	var/slow = 0.5
	var/shield_mod = 1.75
	var/shield_duration = 4 SECONDS
	var/incoming_damage_mod = 0.5
	var/damage_accumulated = 0

/datum/action/xeno_action/onclick/moba_soak/use_ability(atom/A)
	var/mob/living/carbon/xenomorph/xeno = owner

	if (!action_cooldown_check())
		return

	if (!xeno.check_state())
		return

	if(!check_and_use_plasma_owner())
		return

	xeno.balloon_alert(xeno, "begins to soak incoming damage!")
	to_chat(xeno, SPAN_XENONOTICE("We begin to tank incoming damage!"))

	xeno.add_filter("steelcrest_enraging", 1, list("type" = "outline", "color" = "#421313", "size" = 1))
	playsound(get_turf(xeno), 'sound/effects/stonedoor_openclose.ogg', 30, 1)

	RegisterSignal(xeno, COMSIG_XENO_TAKE_DAMAGE, PROC_REF(damage_accumulate))
	addtimer(CALLBACK(src, PROC_REF(stop_accumulating)), 3 SECONDS)

	xeno.fortify = TRUE
	xeno.update_icons()

	xeno.ability_speed_modifier += slow

	apply_cooldown()
	return ..()

/datum/action/xeno_action/onclick/moba_soak/proc/damage_accumulate(owner, damage_data, damage_type)
	SIGNAL_HANDLER

	damage_accumulated += damage_data["damage"] // before, so the shield amount isnt reduced by 50%
	damage_data["damage"] *= incoming_damage_mod

/datum/action/xeno_action/onclick/moba_soak/proc/stop_accumulating()
	var/mob/living/carbon/xenomorph/xeno = owner
	UnregisterSignal(xeno, COMSIG_XENO_TAKE_DAMAGE)

	var/list/bonus_hp_list = list()
	SEND_SIGNAL(xeno, COMSIG_MOBA_GET_BONUS_HP, bonus_hp_list)

	var/shield_amount = (damage_accumulated * (shield_mod + (bonus_hp_list[1] * 0.01 * 0.01)))
	xeno.add_xeno_shield(shield_amount, XENO_SHIELD_SOURCE_CUMULATIVE_GENERIC, duration = shield_duration, decay_amount_per_second = shield_amount * 0.25, add_shield_on = TRUE, max_shield = INFINITY) // >:3

	xeno.fortify = FALSE
	xeno.update_icons()

	xeno.ability_speed_modifier -= slow
	damage_accumulated = 0

	to_chat(xeno, SPAN_XENONOTICE("We stop tanking incoming damage."))
	xeno.balloon_alert(xeno, "ceases soaking incoming damage!")
	xeno.remove_filter("steelcrest_enraging")

/datum/action/xeno_action/onclick/moba_soak/level_up_ability(new_level)
	xeno_cooldown = src::xeno_cooldown - ((1 SECONDS) * (new_level - 1))
	shield_mod = src::shield_mod + (0.25 * (new_level - 1))
	shield_duration = src::shield_duration + ((1 SECONDS) * (new_level - 1))

	desc = "Take 50% reduced damage from all sources for 3 seconds. During this time, you are unable to attack and have your speed reduced by 0.5. Once the time ends, you gain [MOBA_LEVEL_ABILITY_DESC_HELPER(new_level, "175", "200", "225")]% (+1% bonus HP) of the pre-mitigation damage taken as shields. These shields decay after [MOBA_LEVEL_ABILITY_DESC_HELPER(new_level, "4", "5", "6")] seconds. Cooldown of [MOBA_LEVEL_ABILITY_DESC_HELPER(new_level, "16", "15", "14")] seconds. Plasma cost 100."

// DO THE HARLEM SHAKE
/datum/action/xeno_action/onclick/moba_tremor
	name = "Tremor"
	action_icon_state = "fortify"
	macro_path = /datum/action/xeno_action/verb/verb_tremor
	action_type = XENO_ACTION_ACTIVATE
	ability_primacy = XENO_PRIMARY_ACTION_4
	plasma_cost = 225
	xeno_cooldown = 180 SECONDS

	var/windup = 3 SECONDS
	var/duration = 2 SECONDS
	var/range = 7
	var/duration_shield_div = 100

/datum/action/xeno_action/onclick/moba_tremor/use_ability(atom/A)
	var/mob/living/carbon/xenomorph/xeno = owner
	if(!istype(xeno))
		return

	if(!xeno.check_state())
		return

	if(!action_cooldown_check())
		return

	if(!check_and_use_plasma_owner())
		return

	xeno.visible_message(SPAN_XENOWARNING("[xeno] starts raising its bulky tail into the air!"),
	SPAN_XENOWARNING("We start raising our bulky tail into the air!"))

	apply_cooldown()
	for(var/datum/xeno_shield/shield_effect as anything in xeno.xeno_shields)
		shield_effect.decay_amount_per_second = 0

	xeno.create_shield(windup-1, "empower") // -1 or stomp overlay will also be removed bc timings
	playsound(xeno, 'sound/voice/xeno_praetorian_screech.ogg', 50, FALSE)

	if(!do_after(xeno, windup, INTERRUPT_ALL|BEHAVIOR_IMMOBILE, BUSY_ICON_HOSTILE))
		xeno.remove_xeno_shield()
		return

	xeno.visible_message(SPAN_XENOWARNING("[xeno] slams the ground with it's tail!"),
	SPAN_XENOWARNING("We slam the ground with our tail!"))

	playsound(xeno, 'sound/effects/alien_footstep_charge3.ogg', 75, FALSE)
	xeno.create_stomp()
	xeno.emote("tail")

	var/total_shields = 0
	for(var/datum/xeno_shield/shield_effect as anything in xeno.xeno_shields)
		total_shields += shield_effect.amount

	xeno.remove_xeno_shield()

	var/true_duration = duration + ((0.5 SECONDS) * (total_shields / duration_shield_div))
	var/true_range = floor(range + (total_shields / duration_shield_div))

	for(var/mob/living/target in orange(true_range, get_turf(xeno)))
		if(xeno.can_not_harm(target))
			continue

		if(target.stat == DEAD)
			continue

		SEND_SIGNAL(xeno, COMSIG_MOBA_STUN_GIVEN, target)
		target.KnockDown(true_duration/10)

		shake_camera(target, true_duration/2, 3)
		to_chat(target, SPAN_XENOWARNING("You fall, as [xeno]'s tail slams the ground!"))

	shake_camera(xeno, true_duration/5, 3)

	return ..()

/datum/action/xeno_action/onclick/moba_tremor/level_up_ability(new_level)
	xeno_cooldown = src::xeno_cooldown - ((15 SECONDS) * (new_level - 1))
	duration_shield_div = src::duration_shield_div - (25 * (new_level - 1))

	desc = "Root yourself in place and begin channeling for 3 seconds, pausing any shield decay and raising your tail in the air. At the end of the channel, slam your tail down. All enemies within 7 tiles of you are stunned for 2 seconds. For every [MOBA_LEVEL_ABILITY_DESC_HELPER(new_level, "100", "75", "50")] shield you have, increase the range of the stun by 1 tile and increase the stun's duration by 0.5 seconds. Once the channel finishes, lose all shields you currently have. Cooldown [MOBA_LEVEL_ABILITY_DESC_HELPER(new_level, "180", "165", "150")] seconds. Plasma cost 225."
