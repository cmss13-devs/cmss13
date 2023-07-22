/datum/xeno_mutator/praetorian_warden
	// i mean so basically im braum
	name = "STRAIN: Praetorian - Warden"
	description = "You trade your acid ball, acid spray, dash, and a small bit of your slash damage and speed to become an effective medic. You gain the ability to emit strong pheromones, an ability that retrieves endangered, knocked-down or sitting allies and pulls them to your location, and you gain an internal hitpoint pool that fills with every slash against your enemies, which can be spent to aid your allies and yourself by healing them or curing their ailments."
	flavor_description = "Only in death does your sisters' service to the Queen end. They will be untouched by plague or disease; no sickness will blight them."
	cost = MUTATOR_COST_EXPENSIVE
	individual_only = TRUE
	caste_whitelist = list(XENO_CASTE_PRAETORIAN) // Only bae
	mutator_actions_to_remove = list(
		/datum/action/xeno_action/activable/pounce/base_prae_dash,
		/datum/action/xeno_action/activable/prae_acid_ball,
		/datum/action/xeno_action/activable/spray_acid/base_prae_spray_acid,
	)
	mutator_actions_to_add = list(
		/datum/action/xeno_action/activable/spray_acid/prae_warden,
		/datum/action/xeno_action/activable/warden_heal,
		/datum/action/xeno_action/activable/prae_retrieve,
		/datum/action/xeno_action/onclick/prae_switch_heal_type,
		/datum/action/xeno_action/onclick/emit_pheromones,
	)
	behavior_delegate_type = /datum/behavior_delegate/praetorian_warden
	keystone = TRUE

/datum/xeno_mutator/praetorian_warden/apply_mutator(datum/mutator_set/individual_mutators/mutator_set)
	. = ..()
	if (. == 0)
		return

	var/mob/living/carbon/xenomorph/praetorian/praetorian = mutator_set.xeno

	// Make a 'halftank'
	praetorian.speed_modifier += XENO_SPEED_SLOWMOD_TIER_5
	praetorian.damage_modifier -= XENO_DAMAGE_MOD_SMALL

	mutator_update_actions(praetorian)
	mutator_set.recalculate_actions(description, flavor_description)

	praetorian.recalculate_everything()

	apply_behavior_holder(praetorian)
	praetorian.mutation_icon_state = PRAETORIAN_WARDEN
	praetorian.mutation_type = PRAETORIAN_WARDEN

/datum/behavior_delegate/praetorian_warden
	name = "Praetorian Warden Behavior Delegate"

	// Config
	var/internal_hitpoints_max = 350
	var/internal_hitpoints_per_attack = 50
	var/internal_hp_per_life = 5

	// State
	var/internal_hitpoints = 0

/datum/behavior_delegate/praetorian_warden/append_to_stat()
	. = list()
	. += "Energy Reserves: [internal_hitpoints]/[internal_hitpoints_max]"

/datum/behavior_delegate/praetorian_warden/on_life()
	internal_hitpoints = min(internal_hitpoints_max, internal_hitpoints + internal_hp_per_life)

	var/mob/living/carbon/xenomorph/praetorian/praetorian = bound_xeno
	var/image/holder = praetorian.hud_list[PLASMA_HUD]
	holder.overlays.Cut()

	if(praetorian.stat == DEAD)
		return

	var/percentage_energy = round((internal_hitpoints / internal_hitpoints_max) * 100, 10)
	if(percentage_energy)
		holder.overlays += image('icons/mob/hud/hud.dmi', "xenoenergy[percentage_energy]")

/datum/behavior_delegate/praetorian_warden/handle_death(mob/M)
	var/image/holder = bound_xeno.hud_list[PLASMA_HUD]
	holder.overlays.Cut()

/datum/behavior_delegate/praetorian_warden/melee_attack_additional_effects_self()
	..()

	add_internal_hitpoints(internal_hitpoints_per_attack)

/datum/behavior_delegate/praetorian_warden/ranged_attack_additional_effects_target(atom/target_atom)
	if(ismob(target_atom))
		add_internal_hitpoints(internal_hitpoints_per_attack)

/datum/behavior_delegate/praetorian_warden/proc/add_internal_hitpoints(amount)
	if (amount > 0)
		if (internal_hitpoints >= internal_hitpoints_max)
			return
		to_chat(bound_xeno, SPAN_XENODANGER("You feel your internal health reserves increase!"))
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
