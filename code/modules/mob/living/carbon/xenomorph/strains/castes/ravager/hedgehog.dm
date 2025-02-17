/datum/xeno_strain/hedgehog
	name = RAVAGER_HEDGEHOG
	description = "You lose your empower, charge, scissor cut, and some slash damage in exchange for more explosive resistance. Your resistance scales with your shard count and at 50% grants you immunity to some explosive stuns. You accumulate shards over time and when taking damage. You can use these shards to power three new abilities: Spike Shield which gives you a temporary shield that spits bone shards around you when damaged; Fire Spikes which launches spikes at your target to slow them and deal damage when they move; and Spike Shed which launches all your spikes, grants a temporary speed boost, and disables shard generation for thirty seconds."
	flavor_description = "You will pierce them a million times, show them what it feels like. This one will become my shield."
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
	ravager.small_explosives_stun = TRUE
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

	if(percentage_shards >= 50)
		bound_xeno.small_explosives_stun = FALSE
		bound_xeno.add_filter("hedge_unstunnable", 1, list("type" = "outline", "color" = "#421313", "size" = 1))
	else
		bound_xeno.small_explosives_stun = TRUE
		bound_xeno.remove_filter("hedge_unstunnable", 1, list("type" = "outline", "color" = "#421313", "size" = 1))


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


/datum/action/xeno_action/onclick/spike_shield/use_ability(atom/target)
	var/mob/living/carbon/xenomorph/xeno = owner

	if (!action_cooldown_check())
		return

	if (!xeno.check_state())
		return

	var/datum/behavior_delegate/ravager_hedgehog/behavior = xeno.behavior_delegate
	if (!behavior.check_shards(shard_cost))
		to_chat(xeno, SPAN_DANGER("Not enough shards! We need [shard_cost - behavior.shards] more!"))
		return
	behavior.use_shards(shard_cost)

	xeno.visible_message(SPAN_XENODANGER("[xeno] ruffles its bone-shard quills, forming a defensive shell!"), SPAN_XENODANGER("We ruffle our bone-shard quills, forming a defensive shell!"))

	// Add our shield
	var/datum/xeno_shield/hedgehog_shield/shield = xeno.add_xeno_shield(shield_amount, XENO_SHIELD_SOURCE_HEDGE_RAV, /datum/xeno_shield/hedgehog_shield)
	if (shield)
		shield.owner = xeno
		shield.shrapnel_amount = shield_shrapnel_amount
		xeno.overlay_shields()

	xeno.create_shield(shield_duration, "shield2")
	shield_active = TRUE
	button.icon_state = "template_active"
	addtimer(CALLBACK(src, PROC_REF(remove_shield)), shield_duration)

	apply_cooldown()
	return ..()

/datum/action/xeno_action/onclick/spike_shield/action_cooldown_check()
	if (shield_active) // If active shield, return FALSE so that this action does not get carried out
		return FALSE
	else if (cooldown_timer_id == TIMER_ID_NULL)
		var/mob/living/carbon/xenomorph/xeno = owner
		var/datum/behavior_delegate/ravager_hedgehog/behavior = xeno.behavior_delegate
		return behavior.check_shards(shard_cost)
	return FALSE

/datum/action/xeno_action/onclick/spike_shield/proc/remove_shield()
	var/mob/living/carbon/xenomorph/xeno = owner

	if (!shield_active)
		return

	shield_active = FALSE
	button.icon_state = "template"

	for (var/datum/xeno_shield/shield in xeno.xeno_shields)
		if (shield.shield_source == XENO_SHIELD_SOURCE_HEDGE_RAV)
			shield.on_removal()
			qdel(shield)
			break

	to_chat(xeno, SPAN_XENODANGER("We feel our shard shield dissipate!"))
	xeno.overlay_shields()
	return

/datum/action/xeno_action/activable/rav_spikes/use_ability(atom/affected_atom)
	var/mob/living/carbon/xenomorph/xeno = owner

	if (!action_cooldown_check())
		return

	if(!affected_atom || affected_atom.layer >= FLY_LAYER || !isturf(xeno.loc) || !xeno.check_state())
		return

	var/datum/behavior_delegate/ravager_hedgehog/behavior = xeno.behavior_delegate
	if (!behavior.check_shards(shard_cost))
		to_chat(xeno, SPAN_DANGER("Not enough shards! We need [shard_cost - behavior.shards] more!"))
		return
	behavior.use_shards(shard_cost)

	xeno.visible_message(SPAN_XENOWARNING("[xeno] fires their spikes at [affected_atom]!"), SPAN_XENOWARNING("We fire our spikes at [affected_atom]!"))

	var/turf/target = locate(affected_atom.x, affected_atom.y, affected_atom.z)
	var/obj/projectile/projectile = new /obj/projectile(xeno.loc, create_cause_data(initial(xeno.caste_type), xeno))

	var/datum/ammo/ammo_datum = GLOB.ammo_list[ammo_type]

	projectile.generate_bullet(ammo_datum)

	projectile.fire_at(target, xeno, xeno, ammo_datum.max_range, ammo_datum.shell_speed)
	playsound(xeno, 'sound/effects/spike_spray.ogg', 25, 1)

	apply_cooldown()
	return ..()

/datum/action/xeno_action/activable/rav_spikes/action_cooldown_check()
	if(!owner)
		return FALSE
	if (cooldown_timer_id == TIMER_ID_NULL)
		var/mob/living/carbon/xenomorph/xeno = owner
		if(!istype(xeno))
			return FALSE
		var/datum/behavior_delegate/ravager_hedgehog/behavior = xeno.behavior_delegate
		return behavior.check_shards(shard_cost)
	else
		return FALSE

/datum/action/xeno_action/onclick/spike_shed/use_ability(atom/affected_atom)
	var/mob/living/carbon/xenomorph/xeno = owner

	if (!action_cooldown_check())
		return

	if (!xeno.check_state())
		return

	var/datum/behavior_delegate/ravager_hedgehog/behavior = xeno.behavior_delegate
	if (!behavior.check_shards(shard_cost))
		to_chat(xeno, SPAN_DANGER("Not enough shards! We need [shard_cost - behavior.shards] more!"))
		return
	behavior.use_shards(shard_cost)
	behavior.lock_shards()

	xeno.visible_message(SPAN_XENOWARNING("[xeno] sheds their spikes, firing them in all directions!"), SPAN_XENOWARNING("We shed our spikes, firing them in all directions!!"))
	xeno.spin_circle()
	create_shrapnel(get_turf(xeno), shrapnel_amount, null, null, ammo_type, create_cause_data(initial(xeno.caste_type), owner), TRUE)
	playsound(xeno, 'sound/effects/spike_spray.ogg', 25, 1)

	apply_cooldown()
	return ..()

/datum/action/xeno_action/onclick/spike_shed/action_cooldown_check()
	if (cooldown_timer_id == TIMER_ID_NULL)
		var/mob/living/carbon/xenomorph/xeno = owner
		var/datum/behavior_delegate/ravager_hedgehog/behavior = xeno.behavior_delegate
		return behavior.check_shards(shard_cost)
	else
		return FALSE
