/datum/xeno_strain/hedgehog
	name = RAVAGER_HEDGEHOG
	description = "You lose your empower, charge, scissor cut and some slash damage, for a bit more explosive resistance, immunity to small explosions, and you gain several new abilities that allow you to become a spiky tank. You build up shards internally over time and also when taking damage that increase your armor's resilience. You can use these shards to power three new abilities: Spike Shield, which gives you a temporary shield that spits bone shards around you when damaged, Fire Spikes, which launches spikes at your target that slows them and does extra damage if they move, and finally, Spike Shed, which launches spikes all around yourself and gives you a temporary speed boost as an escape plan at the cost of all your stored shards and being unable to gain shards for thirty seconds."
	flavor_description = "They will be of iron will and steely muscle. In great armor shall they be clad, and with the mightiest spikes will they be armed."
	icon_state_prefix = "Hedgehog"

	actions_to_remove = list(
		/datum/action/xeno_action/onclick/empower,
		/datum/action/xeno_action/activable/pounce/charge,
		/datum/action/xeno_action/activable/scissor_cut,
	)
	actions_to_add = list(
		/datum/action/xeno_action/onclick/spike_shield,
		/datum/action/xeno_action/activable/rav_spikes,
		/datum/action/xeno_action/onclick/spike_shed,
	)

	behavior_delegate_type = /datum/behavior_delegate/ravager_hedgehog

/datum/xeno_strain/hedgehog/apply_strain(mob/living/carbon/xenomorph/ravager/ravager)
	ravager.plasma_max = 0
	ravager.small_explosives_stun = FALSE
	ravager.explosivearmor_modifier += XENO_EXPOSIVEARMOR_MOD_SMALL
	ravager.damage_modifier -= XENO_DAMAGE_MOD_SMALL

	ravager.recalculate_everything()

/datum/behavior_delegate/ravager_hedgehog
	name = "Hedgehog Ravager Behavior Delegate"

	// Shard config
	var/max_shards = 300
	var/shard_gain_onlife = 5
	var/shards_per_projectile = 10
	var/shards_per_slash = 15
	var/armor_buff_per_fifty_shards = 2.50
	var/shard_lock_duration = 150
	var/shard_lock_speed_mod = 0.45

	// Shard state
	var/shards = 0
	var/shards_locked = FALSE //are we locked at 0 shards?

	// Armor buff state
	var/times_armor_buffed = 0

/datum/behavior_delegate/ravager_hedgehog/append_to_stat()
	. = list()
	. += "Bone Shards: [shards]/[max_shards]"
	. += "Shards Armor Bonus: [times_armor_buffed*armor_buff_per_fifty_shards]"

/datum/behavior_delegate/ravager_hedgehog/proc/lock_shards()

	if (!bound_xeno)
		return

	to_chat(bound_xeno, SPAN_XENODANGER("You have shed your spikes and cannot gain any more for [shard_lock_duration/10] seconds!"))

	bound_xeno.speed_modifier -= shard_lock_speed_mod
	bound_xeno.recalculate_speed()

	shards = 0
	shards_locked = TRUE
	addtimer(CALLBACK(src, PROC_REF(unlock_shards)), shard_lock_duration)

/datum/behavior_delegate/ravager_hedgehog/proc/unlock_shards()

	if (!bound_xeno)
		return

	to_chat(bound_xeno, SPAN_XENODANGER("You feel your ability to gather shards return!"))

	bound_xeno.speed_modifier += shard_lock_speed_mod
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

	var/image/holder = bound_xeno.hud_list[PLASMA_HUD]
	holder.overlays.Cut()
	var/percentage_shards = round((shards / max_shards) * 100, 10)
	if(percentage_shards)
		holder.overlays += image('icons/mob/hud/hud.dmi', "xenoenergy[percentage_shards]")
	return


/datum/behavior_delegate/ravager_hedgehog/handle_death(mob/M)
	var/image/holder = bound_xeno.hud_list[PLASMA_HUD]
	holder.overlays.Cut()

/datum/behavior_delegate/ravager_hedgehog/on_hitby_projectile()
	if (!shards_locked)
		shards = min(max_shards, shards + shards_per_projectile)
	return

/datum/behavior_delegate/ravager_hedgehog/melee_attack_additional_effects_self()
	if (!shards_locked)
		shards = min(max_shards, shards + shards_per_slash)
	return
