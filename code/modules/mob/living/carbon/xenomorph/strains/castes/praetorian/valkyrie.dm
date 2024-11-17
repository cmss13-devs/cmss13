/datum/xeno_strain/valkyrie
	// i mean so basically im braum
	name = PRAETORIAN_VALKYRIE
	description = "You trade your acid ball, acid spray, dash, and a small bit of your slash damage and speed to become an effective medic. You gain the ability to emit strong pheromones, an ability that retrieves endangered, knocked-down or resting allies and pulls them to your location, and you gain an internal hitpoint pool that fills with every slash against your enemies, which can be spent to aid your allies and yourself by healing them or curing their ailments."
	flavor_description = "This one will deny her sisters' deaths until they earn it. Fight or be forgotten."
	icon_state_prefix = "Warden"

	actions_to_remove = list(
		/datum/action/xeno_action/activable/xeno_spit,
		/datum/action/xeno_action/activable/pounce/base_prae_dash,
		/datum/action/xeno_action/activable/prae_acid_ball,
		/datum/action/xeno_action/activable/spray_acid/base_prae_spray_acid,
		/datum/action/xeno_action/onclick/tacmap,
	)
	actions_to_add = list(
		/datum/action/xeno_action/onclick/emit_pheromones,
		/datum/action/xeno_action/activable/valkyrie_rage,
		/datum/action/xeno_action/activable/high_gallop,
		/datum/action/xeno_action/onclick/fight_or_flight,
		/datum/action/xeno_action/onclick/tacmap,
	)

	behavior_delegate_type = /datum/behavior_delegate/praetorian_valkyrie

/datum/xeno_strain/valkyrie/apply_strain(mob/living/carbon/xenomorph/praetorian/prae)
	prae.speed_modifier += XENO_SPEED_SLOWMOD_TIER_5
	prae.damage_modifier += XENO_DAMAGE_MOD_SMALL
	prae.armor_modifier += XENO_ARMOR_MOD_SMALL

	prae.recalculate_everything()
	to_chat(world, "test [prae.armor_modifier]")

/datum/behavior_delegate/praetorian_valkyrie
	name = "Praetorian Valkyrie Behavior Delegate"

	// Config
	var/fury_max = 200  // 20 seconds to recharge 1-hit shield
	var/fury_per_attack = 25   // 1 second to use pierce
	var/fury_per_life = 15   // How long you have to buffed cleave after the shield fully decays

	// State
	var/base_fury = 0
	var/transferred_healing = 0

/datum/behavior_delegate/praetorian_valkyrie/append_to_stat()
	. = list()
	. += "Fury: [base_fury]/[fury_max]"
	. += "Healing Done: [transferred_healing]"

/datum/behavior_delegate/praetorian_valkyrie/on_life()
	base_fury = min(fury_max, base_fury + fury_per_life)

	var/mob/living/carbon/xenomorph/praetorian/praetorian = bound_xeno
	var/image/holder = praetorian.hud_list[PLASMA_HUD]
	holder.overlays.Cut()

	if(praetorian.stat == DEAD)
		return

	var/percentage_energy = round((base_fury / fury_max) * 100, 10)
	if(percentage_energy)
		holder.overlays += image('icons/mob/hud/hud.dmi', "xenoenergy[percentage_energy]")

/datum/behavior_delegate/praetorian_valkyrie/handle_death(mob/M)
	var/image/holder = bound_xeno.hud_list[PLASMA_HUD]
	holder.overlays.Cut()

/datum/behavior_delegate/praetorian_valkyrie/melee_attack_additional_effects_self()
	..()

	add_base_fury(fury_per_attack)

/datum/behavior_delegate/praetorian_valkyrie/proc/add_base_fury(amount)
	if (amount > 0)
		if (base_fury >= fury_max)
			return
		to_chat(bound_xeno, SPAN_XENODANGER("We feel ourselves get angrier."))
	base_fury = clamp(base_fury + amount, 0, fury_max)

/datum/behavior_delegate/praetorian_valkyrie/proc/use_internal_fury_ability(cost)
	if (cost > base_fury)
		to_chat(bound_xeno, SPAN_XENODANGER("We dont have enough rage! We need to be angrier."))
		return FALSE

	add_base_fury(-cost)
	return TRUE

