/datum/xeno_mutator/hedgehog
	name = "STRAIN: Ravager - Hedgehog"
	description = "You build up shards internally that increase your armor's resilience. You can use these to power several abilities, offensive and defensive in nature."
	flavor_description = "In the midst of the Chaos of the battlefield, there is also opportunity."
	cost = MUTATOR_COST_EXPENSIVE
	individual_only = TRUE
	caste_whitelist = list("Ravager")  	// Only Ravager.
	mutator_actions_to_remove = list("Empower", "Charge", "Scissor Cut")
	mutator_actions_to_add = list(/datum/action/xeno_action/activable/spike_shield, /datum/action/xeno_action/activable/rav_spikes, /datum/action/xeno_action/activable/spike_shed)
	behavior_delegate_type = /datum/behavior_delegate/ravager_hedgehog
	keystone = TRUE

/datum/xeno_mutator/hedgehog/apply_mutator(datum/mutator_set/individual_mutators/MS)
	. = ..()
	if (. == 0)
		return	

	var/mob/living/carbon/Xenomorph/Ravager/R = MS.xeno

	R.mutation_type = RAVAGER_HEDGEHOG
	
	R.speed_modifier += XENO_SPEED_MOD_LARGE
	R.armor_integrity_modifier += 20 // Take drastically reduced armor damage

	apply_behavior_holder(R)

	mutator_update_actions(R)
	MS.recalculate_actions(description, flavor_description)
	
	R.recalculate_everything()

/datum/behavior_delegate/ravager_hedgehog
	name = "Hedgehog Ravager Behavior Delegate"

	// Shard config
	var/max_shards = 300
	var/shard_gain_onlife = 10
	var/shards_per_projectile = 20
	var/armor_buff_per_fifty_shards = 2.25
	var/shard_lock_duration = 300
	var/shard_lock_armor_mod = 10
	var/shard_lock_speed_mod = 0.75

	// Shard state
	var/shards = 0
	var/shards_locked = FALSE //are we locked at 0 shards?

	// Armor buff state
	var/times_armor_buffed = 0

/datum/behavior_delegate/ravager_hedgehog/append_to_stat()
	stat("Bone Shards:", "[shards]/[max_shards]")
	stat("Shards Armor Bonus:", "[times_armor_buffed*armor_buff_per_fifty_shards]")

/datum/behavior_delegate/ravager_hedgehog/proc/lock_shards()

	if (!bound_xeno)
		return

	to_chat(bound_xeno, SPAN_XENODANGER("You have shed your spikes and cannot gain any more for [shard_lock_duration/10] seconds!"))

	bound_xeno.armor_modifier -= shard_lock_armor_mod
	bound_xeno.speed_modifier -= shard_lock_speed_mod
	bound_xeno.recalculate_armor()
	bound_xeno.recalculate_speed()

	shards = 0
	shards_locked = TRUE
	add_timer(CALLBACK(src, .proc/unlock_shards), shard_lock_duration)

/datum/behavior_delegate/ravager_hedgehog/proc/unlock_shards()

	if (!bound_xeno)
		return

	to_chat(bound_xeno, SPAN_XENODANGER("You feel your ability to gather shards return!"))

	bound_xeno.armor_modifier += shard_lock_armor_mod
	bound_xeno.speed_modifier += shard_lock_speed_mod
	bound_xeno.recalculate_armor()
	bound_xeno.recalculate_speed()

	shards_locked = FALSE
	
// Return true if we have enough shards, false otherwise
/datum/behavior_delegate/ravager_hedgehog/proc/check_shards(amount)
	if (!amount)
		return FALSE
	else
		return (shards >= amount)

/datum/behavior_delegate/ravager_hedgehog/proc/use_shards(amount)
	if (!amount)
		return 
	shards = max(0, shards - amount)

/datum/behavior_delegate/ravager_hedgehog/on_life()
	
	if (!shards_locked)
		shards = min(max_shards, shards + shard_gain_onlife)

	var/armor_buff_count = shards/50 //0-6
	bound_xeno.armor_modifier -= times_armor_buffed * armor_buff_per_fifty_shards
	bound_xeno.armor_modifier += armor_buff_count * armor_buff_per_fifty_shards
	bound_xeno.recalculate_armor()
	times_armor_buffed = armor_buff_count
	return

/datum/behavior_delegate/ravager_hedgehog/on_hitby_projectile()
	if (!shards_locked)
		shards = min(max_shards, shards + shards_per_projectile)
	return
