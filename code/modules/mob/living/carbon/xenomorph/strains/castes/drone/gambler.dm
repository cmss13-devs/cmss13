var/list/jackpot = list(
	/datum/action/xeno_action/activable/gut,
	/datum/action/xeno_action/onclick/screech,
)



var/list/high_end_abilities = list(
	/datum/action/xeno_action/onclick/crusher_shield,
	/datum/action/xeno_action/activable/prae_abduct,
	/datum/action/xeno_action/onclick/empower,
	/datum/action/xeno_action/onclick/apprehend,
	/datum/action/xeno_action/onclick/feralrush,
	/datum/action/xeno_action/activable/feralfrenzy,
	/datum/action/xeno_action/onclick/predalien_roar,
	/datum/action/xeno_action/activable/xeno_spit/bombard,
	)


var/list/medium_end_abilities = list(
	/datum/action/xeno_action/activable/warrior_punch,
	/datum/action/xeno_action/activable/lunge,
	/datum/action/xeno_action/activable/fling,
	/datum/action/xeno_action/activable/pounce/base_prae_dash,
	/datum/action/xeno_action/activable/prae_acid_ball,
	/datum/action/xeno_action/activable/spray_acid/base_prae_spray_acid,
	/datum/action/xeno_action/activable/pierce,
	/datum/action/xeno_action/onclick/crusher_stomp,
	/datum/action/xeno_action/activable/cleave,
	/datum/action/xeno_action/activable/oppressor_punch,
	/datum/action/xeno_action/activable/tail_lash,
	/datum/action/xeno_action/activable/pounce/crusher_charge,
	/datum/action/xeno_action/activable/scissor_cut,
	/datum/action/xeno_action/activable/prae_retrieve,
	/datum/action/xeno_action/activable/high_gallop,
	/datum/action/xeno_action/onclick/tremor,
	/datum/action/xeno_action/onclick/acid_shroud,
	/datum/action/xeno_action/activable/pounce/runner,
	/datum/action/xeno_action/onclick/lurker_invisibility,
	/datum/action/xeno_action/onclick/lurker_assassinate,
)

/datum/xeno_strain/gambler

	name = DRONE_GAMBLER
	description = "I CANT STOP WINNING"
	flavor_description = "I cant stop winning."

	actions_to_remove = list(
		/datum/action/xeno_action/activable/secrete_resin,
		/datum/action/xeno_action/onclick/choose_resin,
		/datum/action/xeno_action/activable/corrosive_acid/weak,
		/datum/action/xeno_action/activable/transfer_plasma,
	)


	actions_to_add = list(
		/datum/action/xeno_action/activable/lets_go_gambling,
	)

	behavior_delegate_type = /datum/behavior_delegate/drone_gambler

/datum/xeno_strain/gambler/apply_strain(mob/living/carbon/xenomorph/drone/gamba)
	gamba.plasma_max = XENO_PLASMA_TIER_GAMBLER
	gamba.recalculate_everything()


/datum/behavior_delegate/drone_gambler // copy paste spam so the caste can handle abilities.

	name = "Gambler Drone Behavior Delegate"

	var/shield_decay_time = 15 SECONDS // Time in deciseconds before our shield decays
	var/slash_charge_cdr = 3 SECONDS // Amount to reduce charge cooldown by per slash
	var/knockdown_amount = 1.6
	var/fling_distance = 3
	var/empower_targets = 0
	var/super_empower_threshold = 3
	var/dmg_buff_per_target = 2
	var/kills = 2
	var/invis_recharge_time = 20 SECONDS
	var/invis_start_time = -1 // Special value for when we're not invisible
	var/invis_duration = 30 SECONDS // so we can display how long the lurker is invisible to it
	var/base_fury = 999999


/datum/behavior_delegate/drone_gambler/proc/decloak_handler(mob/source)
	SIGNAL_HANDLER
	var/datum/action/xeno_action/onclick/lurker_invisibility/lurker_invis_action = get_action(bound_xeno, /datum/action/xeno_action/onclick/lurker_invisibility)
	if(istype(lurker_invis_action))
		lurker_invis_action.invisibility_off(0.5) // Partial refund of remaining time

/// Implementation for enabling invisibility.
/datum/behavior_delegate/drone_gambler/proc/on_invisibility()

	ADD_TRAIT(bound_xeno, TRAIT_CLOAKED, TRAIT_SOURCE_ABILITY("cloak"))
	RegisterSignal(bound_xeno, COMSIG_MOB_EFFECT_CLOAK_CANCEL, PROC_REF(decloak_handler))
	bound_xeno.stealth = TRUE
	invis_start_time = world.time

/// Implementation for disabling invisibility.
/datum/behavior_delegate/drone_gambler/proc/on_invisibility_off()
	bound_xeno.stealth = FALSE
	REMOVE_TRAIT(bound_xeno, TRAIT_CLOAKED, TRAIT_SOURCE_ABILITY("cloak"))
	UnregisterSignal(bound_xeno, COMSIG_MOB_EFFECT_CLOAK_CANCEL)
	invis_start_time = -1

/datum/action/xeno_action/activable/lets_go_gambling

	name = "I can't stop winning"
	action_icon_state = "gardener_plant"
	plasma_cost = 0 // it costs NOTHING to gamble
	macro_path = ""
	action_type = XENO_ACTION_CLICK
	ability_primacy = XENO_PRIMARY_ACTION_2
	xeno_cooldown = 2 SECONDS


/datum/action/xeno_action/activable/lets_go_gambling/use_ability()
	var/mob/living/carbon/xenomorph/enterpanuer_drone = owner //buy my books

	if (!enterpanuer_drone.check_state() || enterpanuer_drone.action_busy)
		return

	if (!action_cooldown_check())
		return


	var/list_result = pick(35;high_end_abilities, 60;medium_end_abilities, 5;jackpot)

	var/datum/action/action_result = pick(list_result)
	var/datum/action/action_given = give_action(enterpanuer_drone, action_result)


	RegisterSignal(action_given, COMSIG_XENO_ACTION_USED, PROC_REF(delete_ability))
	addtimer(CALLBACK(src, PROC_REF(delete_ability), action_given, enterpanuer_drone), 10 SECONDS)

	apply_cooldown()
	..()

/datum/action/xeno_action/activable/lets_go_gambling/proc/delete_ability(datum/action/source, mob/owner)
	SIGNAL_HANDLER
	source.hide_from(owner)
	UnregisterSignal(source, COMSIG_XENO_ACTION_USED)
