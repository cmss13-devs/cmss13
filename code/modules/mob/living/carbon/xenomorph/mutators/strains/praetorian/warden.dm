/datum/xeno_mutator/praetorian_warden
	// i mean so basically im braum
	name = "STRAIN: Praetorian - Warden"
	description = "You trade your corrosive acid and your dash for an internal hitpoint pool. The pool is filled by your spits and slashes, and can be spent to protect your allies and yourself."
	flavor_description = "Only in Death does your sisters' service to the Queen end. Keep them fighting using your own blood and claws."
	cost = MUTATOR_COST_EXPENSIVE
	individual_only = TRUE
	caste_whitelist = list("Praetorian")  	// Only bae
	mutator_actions_to_remove = list("Acid Ball", "Dash", "Spray Acid")
	mutator_actions_to_add = list(/datum/action/xeno_action/activable/spray_acid/prae_warden, /datum/action/xeno_action/activable/warden_heal, /datum/action/xeno_action/onclick/prae_switch_heal_type, /datum/action/xeno_action/onclick/emit_pheromones)
	behavior_delegate_type = /datum/behavior_delegate/praetorian_warden
	keystone = TRUE

/datum/xeno_mutator/praetorian_warden/apply_mutator(datum/mutator_set/individual_mutators/MS)
	. = ..()
	if (. == 0)
		return
	
	var/mob/living/carbon/Xenomorph/Praetorian/P = MS.xeno
	
	// Make a 'halftank'
	P.speed_modifier += XENO_SPEED_MODIFIER_SLOWER
	P.damage_modifier -= XENO_DAMAGE_MOD_SMALL

	mutator_update_actions(P)
	MS.recalculate_actions(description, flavor_description)

	P.recalculate_everything()
	
	apply_behavior_holder(P)
	P.mutation_type = PRAETORIAN_WARDEN

/datum/behavior_delegate/praetorian_warden
	name = "Praetorian Warden Behavior Delegate"

	// Config
	var/internal_hitpoints_max = 325
	var/internal_hitpoints_per_attack = 75
	var/percent_hp_to_self_heal = 0.2
	var/internal_hp_selfheal_size = 50
	var/internal_hp_per_life = 5 

	// State
	var/internal_hitpoints = 0

/datum/behavior_delegate/praetorian_warden/append_to_stat()
	stat("Health Reserves:", "[internal_hitpoints]/[internal_hitpoints_max]")

/datum/behavior_delegate/praetorian_warden/on_life()
	if ((internal_hitpoints != 0) && bound_xeno.health <= percent_hp_to_self_heal*bound_xeno.maxHealth && !bound_xeno.on_fire)
		if (internal_hitpoints >= internal_hp_selfheal_size)
			remove_internal_hitpoints(internal_hp_selfheal_size)
			bound_xeno.gain_health(internal_hp_selfheal_size)
		else
			bound_xeno.gain_health(internal_hitpoints)
			remove_internal_hitpoints(internal_hitpoints)

		to_chat(bound_xeno, SPAN_XENOHIGHDANGER("You feel your resources of health pour through your blood!"))
	else 
		internal_hitpoints = min(internal_hitpoints_max, internal_hitpoints + internal_hp_per_life)

/datum/behavior_delegate/praetorian_warden/on_hitby_projectile(ammo)
	if ((internal_hitpoints != 0) && bound_xeno.health <= percent_hp_to_self_heal*bound_xeno.maxHealth && !bound_xeno.on_fire)
		if (internal_hitpoints >= internal_hp_selfheal_size)
			remove_internal_hitpoints(internal_hp_selfheal_size)
			bound_xeno.gain_health(internal_hp_selfheal_size)
		else
			bound_xeno.gain_health(internal_hitpoints)
			remove_internal_hitpoints(internal_hitpoints)

/datum/behavior_delegate/praetorian_warden/melee_attack_additional_effects_self()
	add_internal_hitpoints(internal_hitpoints_per_attack)

/datum/behavior_delegate/praetorian_warden/ranged_attack_additional_effects_target(var/atom/A)
	if(ismob(A))
		add_internal_hitpoints(internal_hitpoints_per_attack)

/datum/behavior_delegate/praetorian_warden/proc/add_internal_hitpoints(amount)
	internal_hitpoints = Clamp(internal_hitpoints + amount, 0, internal_hitpoints_max)

/datum/behavior_delegate/praetorian_warden/proc/remove_internal_hitpoints(amount)
	add_internal_hitpoints(-1*amount)

/datum/behavior_delegate/praetorian_warden/proc/use_internal_hp_ability(cost)
	if (cost > internal_hitpoints)
		to_chat(bound_xeno, SPAN_XENODANGER("Your health reserves are insufficient! You need at least [cost] to do that!"))
		return FALSE
	else
		remove_internal_hitpoints(cost)
		return TRUE