/datum/xeno_strain/berserker
	name = RAVAGER_BERSERKER
	description = "You lose your empower, charge, and scissor cut, decrease your health, and sacrifice a bit of your influence under frenzy pheromones to increase your movement speed, slightly increase your armor, and gain a new set of abilities that make you a terrifying melee monster. By slashing, you heal yourself and gain a stack of rage that increases your armor, movement speed, attack speed, and your heals per slash, to a maximum of six rage. Use your new Appehend ability to increase your movement speed and apply a slow on the next target you slash and use your Clothesline ability to fling your target to heal yourself, even more-so if you have a rage stack that will be used up. Finally, use your Eviscerate to unleash a devastating windmill attack that heals you for every enemy you hit after an immobilizing wind-up."
	flavor_description = "Unbridled fury fills this one. You will become an extension of my rage."
	icon_state_prefix = "Berserker"

	actions_to_remove = list(
		/datum/action/xeno_action/onclick/empower,
		/datum/action/xeno_action/activable/pounce/charge,
		/datum/action/xeno_action/activable/scissor_cut,
	)
	actions_to_add = list(
		/datum/action/xeno_action/onclick/apprehend,
		/datum/action/xeno_action/activable/clothesline,
		/datum/action/xeno_action/activable/eviscerate,
	)

	behavior_delegate_type = /datum/behavior_delegate/ravager_berserker

/datum/xeno_strain/berserker/apply_strain(mob/living/carbon/xenomorph/ravager/ravager)
	ravager.plasma_max = 0
	ravager.health_modifier -= XENO_HEALTH_MOD_MED
	ravager.armor_modifier += XENO_ARMOR_MOD_VERY_SMALL
	ravager.speed_modifier += XENO_SPEED_FASTMOD_TIER_3
	ravager.received_phero_caps["frenzy"] = 2.9 // Moderate

	ravager.recalculate_everything()

// Mutator delegate for Berserker ravager
/datum/behavior_delegate/ravager_berserker
	name = "Berserker Ravager Behavior Delegate"

	var/hp_vamp_ratio = 0.3

	// Rage config
	var/max_rage = 5
	var/rage_decay_time = 30 // How many deciseconds between slashes until we start to decay rage
	var/attack_delay_buff_per_rage = 0.6
	var/armor_buff_per_rage = 3
	var/movement_speed_buff_per_rage = 0.1

	// Eviscerate config
	var/rage_lock_duration = 10 SECONDS   // 10 seconds of max rage
	var/rage_cooldown_duration = 10 SECONDS  // 10 seconds of NO rage.

	// State for tracking rage
	var/rage = 0
	var/last_slash_time = 0

	// Eviscerate state
	var/rage_lock_start_time = 0
	var/rage_cooldown_start_time = 0

	// State
	var/next_slash_buffed = FALSE
	var/slash_slow_duration = 2	//measured in life ticks

/datum/behavior_delegate/ravager_berserker/melee_attack_additional_effects_self()
	..()

	if (rage != max_rage && !rage_cooldown_start_time)
		rage = rage + 1
		bound_xeno.armor_modifier += armor_buff_per_rage
		bound_xeno.attack_speed_modifier -= attack_delay_buff_per_rage
		bound_xeno.speed_modifier -= movement_speed_buff_per_rage
		bound_xeno.recalculate_armor()
		bound_xeno.recalculate_speed()
		last_slash_time = world.time

		if (rage == max_rage)
			bound_xeno.add_filter("berserker_rage", 1, list("type" = "outline", "color" = "#000000ff", "size" = 1))
			rage_lock()
			to_chat(bound_xeno, SPAN_XENOHIGHDANGER("We feel a euphoric rush as we reach max rage! We are LOCKED at max Rage!"))

	// HP vamp
	if(!bound_xeno.on_fire)
		bound_xeno.gain_health((0.05*rage + hp_vamp_ratio)*((bound_xeno.melee_damage_upper - bound_xeno.melee_damage_lower)/2 + bound_xeno.melee_damage_lower))

/datum/behavior_delegate/ravager_berserker/append_to_stat()
	. = list()
	. += "Rage: [rage]/[max_rage]"

/datum/behavior_delegate/ravager_berserker/on_life()
	// Compute our current rage (demerit if necessary)
	if (((last_slash_time + rage_decay_time) < world.time) && !(rage <= 0))
		decrement_rage()

// Handles internal state from decrementing rage
/datum/behavior_delegate/ravager_berserker/proc/decrement_rage(amount = 1)
	if (rage_lock_start_time)
		return
	var/real_amount = amount
	if (amount > rage)
		real_amount = rage

	rage -= real_amount
	bound_xeno.armor_modifier -= armor_buff_per_rage*real_amount
	bound_xeno.attack_speed_modifier += attack_delay_buff_per_rage*real_amount
	bound_xeno.speed_modifier += movement_speed_buff_per_rage*real_amount
	bound_xeno.recalculate_armor()
	bound_xeno.recalculate_speed()
	return

/datum/behavior_delegate/ravager_berserker/proc/rage_lock()
	rage = max_rage
	rage_lock_start_time = world.time
	var/color = "#00000035"
	bound_xeno.add_filter("empower_rage", 1, list("type" = "outline", "color" = color, "size" = 3))
	addtimer(CALLBACK(src, PROC_REF(rage_lock_weaken)), rage_lock_duration/2)

/datum/behavior_delegate/ravager_berserker/proc/rage_lock_weaken()
	bound_xeno.remove_filter("empower_rage")
	var/color = "#00000027"
	bound_xeno.add_filter("empower_rage", 1, list("type" = "outline", "color" = color, "size" = 3))
	addtimer(CALLBACK(src, PROC_REF(rage_lock_callback)), rage_cooldown_duration/2)


/datum/behavior_delegate/ravager_berserker/proc/rage_lock_callback()
	bound_xeno.remove_filter("empower_rage")
	rage_lock_start_time = 0
	rage_cooldown_start_time = world.time
	decrement_rage(rage)
	bound_xeno.remove_filter("berserker_rage")
	to_chat(bound_xeno, SPAN_XENOWARNING("Our adrenal glands spasm. We cannot gain any rage for [rage_cooldown_duration/10] seconds."))
	addtimer(CALLBACK(src, PROC_REF(rage_cooldown_callback)), rage_cooldown_duration)
	bound_xeno.add_filter("berserker_lockdown", 1, list("type" = "outline", "color" = "#fcfcfcff", "size" = 1))

/datum/behavior_delegate/ravager_berserker/proc/rage_cooldown_callback()
	bound_xeno.remove_filter("berserker_lockdown")
	rage_cooldown_start_time = 0
	return

/datum/behavior_delegate/ravager_berserker/melee_attack_modify_damage(original_damage, mob/living/carbon/A)
	if (!isxeno_human(A))
		return original_damage

	if (next_slash_buffed)
		to_chat(bound_xeno, SPAN_XENOHIGHDANGER("We significantly strengthen our attack, slowing [A]!"))
		to_chat(A, SPAN_XENOHIGHDANGER("You feel a sharp pain as [bound_xeno] slashes you, slowing you down!"))
		A.apply_effect(get_xeno_stun_duration(A, slash_slow_duration), SLOW)
		next_slash_buffed = FALSE

	return original_damage




/datum/action/xeno_action/onclick/apprehend/use_ability(atom/affected_atom)
	var/mob/living/carbon/xenomorph/xeno = owner

	if (!istype(xeno))
		return

	if (!action_cooldown_check())
		return

	if (!xeno.check_state())
		return

	if (!check_and_use_plasma_owner())
		return

	var/datum/behavior_delegate/ravager_berserker/behavior = xeno.behavior_delegate
	if (istype(behavior))
		behavior.next_slash_buffed = TRUE

	to_chat(xeno, SPAN_XENODANGER("Our next slash will slow!"))

	addtimer(CALLBACK(src, PROC_REF(unbuff_slash)), buff_duration)

	xeno.speed_modifier -= speed_buff
	xeno.recalculate_speed()

	addtimer(CALLBACK(src, PROC_REF(apprehend_off)), buff_duration, TIMER_UNIQUE)
	xeno.add_filter("apprehend_on", 1, list("type" = "outline", "color" = "#522020ff", "size" = 1)) // Dark red because the berserker is scary in this state

	apply_cooldown()
	return ..()

/datum/action/xeno_action/onclick/apprehend/proc/apprehend_off()
	var/mob/living/carbon/xenomorph/xeno = owner
	xeno.remove_filter("apprehend_on")
	if (istype(xeno))
		xeno.speed_modifier += speed_buff
		xeno.recalculate_speed()
		to_chat(xeno, SPAN_XENOHIGHDANGER("We feel our speed wane!"))

/datum/action/xeno_action/onclick/apprehend/proc/unbuff_slash()
	var/mob/living/carbon/xenomorph/xeno = owner
	if (!istype(xeno))
		return
	var/datum/behavior_delegate/ravager_berserker/behavior = xeno.behavior_delegate
	if (istype(behavior))
		// In case slash has already landed
		if (!behavior.next_slash_buffed)
			return
		behavior.next_slash_buffed = FALSE

	to_chat(xeno, SPAN_XENODANGER("We have waited too long, our slash will no longer slow enemies!"))


/datum/action/xeno_action/activable/clothesline/use_ability(atom/affected_atom)
	var/mob/living/carbon/xenomorph/xeno = owner

	if (!action_cooldown_check())
		return

	if (!xeno.check_state())
		return

	if (!isxeno_human(affected_atom) || xeno.can_not_harm(affected_atom))
		to_chat(xeno, SPAN_XENOWARNING("We must target a hostile!"))
		return

	if (!xeno.Adjacent(affected_atom))
		to_chat(xeno, SPAN_XENOWARNING("We must be adjacent to our target!"))
		return

	var/mob/living/carbon/carbon = affected_atom
	var/heal_amount = base_heal
	var/fling_distance = fling_dist_base
	var/debilitate = TRUE // Do we apply neg. status effects to the target?

	if (carbon.mob_size >= MOB_SIZE_BIG)
		to_chat(xeno, SPAN_XENOWARNING("We creature is too massive to target"))
		return

	if (carbon.stat == DEAD)
		return

	var/datum/behavior_delegate/ravager_berserker/behavior = xeno.behavior_delegate
	if (behavior.rage >= 2)
		behavior.decrement_rage()
		heal_amount += additional_healing_enraged
	else
		to_chat(xeno, SPAN_XENOWARNING("Our rejuvenation was weaker without rage!"))
		debilitate = FALSE
		fling_distance--

	// Damage
	var/obj/limb/head/head = carbon.get_limb("head")
	if(ishuman(carbon) && head)
		carbon.apply_armoured_damage(damage, ARMOR_MELEE, BRUTE, "head")
	else
		carbon.apply_armoured_damage(get_xeno_damage_slash(carbon, damage), ARMOR_MELEE, BRUTE) // just for consistency

	// Heal
	if(!xeno.on_fire)
		xeno.gain_health(heal_amount)

	// Fling
	var/facing = get_dir(xeno, carbon)
	var/turf/turf = get_turf(xeno)
	var/turf/temp = turf

	for (var/step in 0 to fling_distance-1)
		temp = get_step(turf, facing)
		if (!temp)
			break
		turf = temp

	carbon.throw_atom(turf, fling_distance, SPEED_VERY_FAST, xeno, TRUE)

	// Negative stat effects
	if (debilitate)
		carbon.AdjustDaze(daze_amount)

	apply_cooldown()
	return ..()

/datum/action/xeno_action/activable/eviscerate/use_ability(atom/affected_atom)
	var/mob/living/carbon/xenomorph/xeno = owner

	if(!action_cooldown_check() || xeno.action_busy)
		return

	if(!xeno.check_state())
		return

	var/damage = base_damage
	var/range = 1
	var/windup_reduction = 0
	var/lifesteal_per_marine = 50
	var/max_lifesteal = 250
	var/lifesteal_range =  1

	var/datum/behavior_delegate/ravager_berserker/behavior = xeno.behavior_delegate
	if (behavior.rage == 0)
		to_chat(xeno, SPAN_XENODANGER("We cannot eviscerate when we have 0 rage!"))
		return
	damage = damage_at_rage_levels[clamp(behavior.rage, 1, behavior.max_rage)]
	range = range_at_rage_levels[clamp(behavior.rage, 1, behavior.max_rage)]
	windup_reduction = windup_reduction_at_rage_levels[clamp(behavior.rage, 1, behavior.max_rage)]
	behavior.decrement_rage(behavior.rage)

	apply_cooldown()

	if (range > 1)
		xeno.visible_message(SPAN_XENOHIGHDANGER("[xeno] begins digging in for a massive strike!"), SPAN_XENOHIGHDANGER("We begin digging in for a massive strike!"))
	else
		xeno.visible_message(SPAN_XENODANGER("[xeno] begins digging in for a strike!"), SPAN_XENOHIGHDANGER("We begin digging in for a strike!"))

	ADD_TRAIT(xeno, TRAIT_IMMOBILIZED, TRAIT_SOURCE_ABILITY("Eviscerate"))
	xeno.anchored = TRUE

	if (do_after(xeno, (activation_delay - windup_reduction), INTERRUPT_ALL | BEHAVIOR_IMMOBILE, BUSY_ICON_HOSTILE))
		xeno.emote("roar")
		xeno.spin_circle()

		for (var/mob/living/carbon/targets_to_hit in orange(xeno, range))
			if(!isxeno_human(targets_to_hit) || xeno.can_not_harm(targets_to_hit))
				continue

			if (targets_to_hit.stat == DEAD)
				continue

			if (HAS_TRAIT(targets_to_hit, TRAIT_NESTED))
				continue

			if(!check_clear_path_to_target(xeno, targets_to_hit))
				continue

			if (range > 1)
				xeno.visible_message(SPAN_XENOHIGHDANGER("[xeno] rips open the guts of [targets_to_hit]!"), SPAN_XENOHIGHDANGER("We rip open the guts of [targets_to_hit]!"))
				targets_to_hit.spawn_gibs()
				playsound(get_turf(targets_to_hit), 'sound/effects/gibbed.ogg', 30, 1)
				targets_to_hit.apply_effect(get_xeno_stun_duration(targets_to_hit, 1), WEAKEN)
			else
				xeno.visible_message(SPAN_XENODANGER("[xeno] claws [targets_to_hit]!"), SPAN_XENODANGER("We claw [targets_to_hit]!"))
				playsound(get_turf(targets_to_hit), "alien_claw_flesh", 30, 1)

			targets_to_hit.apply_armoured_damage(get_xeno_damage_slash(targets_to_hit, damage), ARMOR_MELEE, BRUTE, "chest", 20)

	var/valid_count = 0
	var/list/mobs_in_range = oviewers(lifesteal_range, xeno)

	for(var/mob/mob as anything in mobs_in_range)
		if(mob.stat == DEAD || HAS_TRAIT(mob, TRAIT_NESTED))
			continue

		if(xeno.can_not_harm(mob))
			continue

		valid_count++

	// This is the heal
	if(!xeno.on_fire)
		xeno.gain_health(clamp(valid_count * lifesteal_per_marine, 0, max_lifesteal))

	REMOVE_TRAIT(xeno, TRAIT_IMMOBILIZED, TRAIT_SOURCE_ABILITY("Eviscerate"))
	xeno.anchored = FALSE

	return ..()
