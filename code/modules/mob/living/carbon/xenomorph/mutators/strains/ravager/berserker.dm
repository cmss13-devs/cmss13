/datum/xeno_mutator/berserker
	name = "STRAIN: Ravager - Berserker"
	description = "You decrease your health and increase your speed to become a close range melee monster. Build up rage by slashing to increase your attack speed, movement speed, and armor; once you reach max rage you can go nuclear with eviscerate."
	flavor_description = "Crush and butcher, maim and rage, until the tallhosts are finished."
	cost = MUTATOR_COST_EXPENSIVE
	individual_only = TRUE
	caste_whitelist = list(XENO_CASTE_RAVAGER)
	mutator_actions_to_remove = list(
		/datum/action/xeno_action/onclick/empower,
		/datum/action/xeno_action/activable/pounce/charge,
		/datum/action/xeno_action/activable/scissor_cut,
	)
	mutator_actions_to_add = list(
		/datum/action/xeno_action/onclick/apprehend,
		/datum/action/xeno_action/activable/clothesline,
		/datum/action/xeno_action/activable/eviscerate
	)
	keystone = TRUE
	behavior_delegate_type = /datum/behavior_delegate/ravager_berserker

/datum/xeno_mutator/berserker/apply_mutator(datum/mutator_set/individual_mutators/MS)
	. = ..()
	if (. == 0)
		return

	var/mob/living/carbon/Xenomorph/Ravager/R = MS.xeno
	R.mutation_type = RAVAGER_BERSERKER
	R.plasma_max = 0
	R.health_modifier -= XENO_HEALTH_MOD_MED
	R.armor_modifier += XENO_ARMOR_MOD_VERYSMALL
	R.speed_modifier += XENO_SPEED_FASTMOD_TIER_3

	mutator_update_actions(R)
	MS.recalculate_actions(description, flavor_description)

	apply_behavior_holder(R)

	R.recalculate_everything()

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
	var/rage_lock_duration = 10 SECONDS      // 10 seconds of max rage
	var/rage_cooldown_duration = 6 SECONDS  // 6 seconds of NO rage.

	// State for tracking rage
	var/rage = 0
	var/last_slash_time = 0

	// Eviscerate state
	var/rage_lock_start_time = 0
	var/rage_cooldown_start_time = 0

	// State
	var/next_slash_buffed = FALSE
	var/slash_slow_duration = 3.5 SECONDS

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
			to_chat(bound_xeno, SPAN_XENOHIGHDANGER("You feel a euphoric rush as you reach max rage! You are LOCKED at max Rage!"))

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
	addtimer(CALLBACK(src, .proc/rage_lock_weaken), rage_lock_duration/2)

/datum/behavior_delegate/ravager_berserker/proc/rage_lock_weaken()
	bound_xeno.remove_filter("empower_rage")
	var/color = "#00000027"
	bound_xeno.add_filter("empower_rage", 1, list("type" = "outline", "color" = color, "size" = 3))
	addtimer(CALLBACK(src, .proc/rage_lock_callback), rage_cooldown_duration/2)


/datum/behavior_delegate/ravager_berserker/proc/rage_lock_callback()
	bound_xeno.remove_filter("empower_rage")
	rage_lock_start_time = 0
	rage_cooldown_start_time = world.time
	decrement_rage(rage)
	bound_xeno.remove_filter("berserker_rage")
	to_chat(bound_xeno, SPAN_XENOWARNING("Your adrenal glands spasm. You cannot gain any rage for [rage_cooldown_duration/10] seconds."))
	addtimer(CALLBACK(src, .proc/rage_cooldown_callback), rage_cooldown_duration)
	bound_xeno.add_filter("berserker_lockdown", 1, list("type" = "outline", "color" = "#fcfcfcff", "size" = 1))

/datum/behavior_delegate/ravager_berserker/proc/rage_cooldown_callback()
	bound_xeno.remove_filter("berserker_lockdown")
	rage_cooldown_start_time = 0
	return

/datum/behavior_delegate/ravager_berserker/melee_attack_modify_damage(original_damage, mob/living/carbon/A)
	if (!isXenoOrHuman(A))
		return original_damage

	if (next_slash_buffed)
		to_chat(bound_xeno, SPAN_XENOHIGHDANGER("You significantly strengthen your attack, slowing [A]!"))
		to_chat(A, SPAN_XENOHIGHDANGER("You feel a sharp pain as [bound_xeno] slashes you, slowing you down!"))
		A.SetSuperslowed(get_xeno_stun_duration(A, 6))
		next_slash_buffed = FALSE

	return original_damage
