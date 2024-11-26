/datum/xeno_strain/valkyrie
	name = PRAETORIAN_VALKYRIE
	description = "You trade your ranged abilities and acid to gain the ability to emit strong pheromones and buff other Xenomorphs, giving them extra armor, as well as a dash that lets you dash to enemies to slice and root them. Targeting an ally causes you to dash towards them and knockdown the enemies around them. Lastly you get an ability that rejuvenates everyone in a certain rage depending on your rage."
	flavor_description = "This one will deny her sisters' deaths until they earn it. Fight or be forgotten."
	icon_state_prefix = "Warden"

	actions_to_remove = list(
		/datum/action/xeno_action/activable/tail_stab,
		/datum/action/xeno_action/activable/xeno_spit,
		/datum/action/xeno_action/activable/pounce/base_prae_dash,
		/datum/action/xeno_action/activable/prae_acid_ball,
		/datum/action/xeno_action/activable/spray_acid/base_prae_spray_acid,
		/datum/action/xeno_action/onclick/tacmap,
	)
	actions_to_add = list(
		/datum/action/xeno_action/activable/tail_stab/tail_fountain,
		/datum/action/xeno_action/onclick/emit_pheromones,
		/datum/action/xeno_action/activable/valkyrie_rage,
		/datum/action/xeno_action/activable/high_gallop,
		/datum/action/xeno_action/onclick/fight_or_flight,
		/datum/action/xeno_action/onclick/tacmap,
	)

	behavior_delegate_type = /datum/behavior_delegate/praetorian_valkyrie

/datum/xeno_strain/valkyrie/apply_strain(mob/living/carbon/xenomorph/praetorian/prae)
	prae.speed_modifier += XENO_SPEED_SLOWMOD_TIER_5
	prae.armor_modifier += XENO_ARMOR_MOD_SMALL
	prae.recalculate_everything()

/datum/behavior_delegate/praetorian_valkyrie
	name = "Praetorian Valkyrie Behavior Delegate"

	// Config
	var/fury_max = 200
	var/fury_per_attack = 15
	var/fury_per_life = 5
	var/heal_range =  3
	var/raging = FALSE

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

	if(SEND_SIGNAL(bound_xeno, COMSIG_XENO_PRE_HEAL) & COMPONENT_CANCEL_XENO_HEAL)
		return

	for(var/mob/living/carbon/xenomorph/xeno_in_range in range(heal_range, bound_xeno))
		if(xeno_in_range.on_fire)
			continue
		xeno_in_range.flick_heal_overlay(2 SECONDS, "#00B800")
		if(raging == TRUE)
			xeno_in_range.gain_health(15)
			transferred_healing += 15
		else
			xeno_in_range.gain_health(8)
			transferred_healing += 8


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
