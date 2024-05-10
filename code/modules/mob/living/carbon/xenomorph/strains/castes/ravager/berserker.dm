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
