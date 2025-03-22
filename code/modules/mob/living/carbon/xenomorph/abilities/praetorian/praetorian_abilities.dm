//// Abilities PRIMARILY used by Praetorian.


////////// VANGUARD ABILITIES

/datum/action/xeno_action/activable/pierce
	name = "Pierce"
	action_icon_state = "prae_pierce"
	macro_path = /datum/action/xeno_action/verb/verb_pierce
	action_type = XENO_ACTION_CLICK
	ability_primacy = XENO_PRIMARY_ACTION_1
	xeno_cooldown = 3 SECONDS
	plasma_cost = 50

	// Config
	var/damage = 45
	var/shield_regen_threshold = 2
	var/should_spin_instead = FALSE

/datum/action/xeno_action/activable/pounce/prae_dash
	name = "Dash"
	action_icon_state = "prae_dash"
	action_text = "dash"
	macro_path = /datum/action/xeno_action/verb/verb_dash
	action_type = XENO_ACTION_CLICK
	ability_primacy = XENO_PRIMARY_ACTION_2
	xeno_cooldown = 11 SECONDS
	plasma_cost = 50

	// Config options
	distance = 5
	knockdown = FALSE
	slash = FALSE
	freeze_self = FALSE

	var/buff_duration = 12
	var/damage = 40
	var/shield_regen_threshold = 1

	var/activated_once = FALSE
	var/time_until_timeout = 20

/datum/action/xeno_action/activable/pounce/prae_dash/initialize_pounce_pass_flags()
	pounce_pass_flags = PASS_MOB_THRU|PASS_OVER_THROW_MOB

/datum/action/xeno_action/activable/cleave
	name = "Cleave"
	action_icon_state = "prae_cleave_action"
	macro_path = /datum/action/xeno_action/verb/verb_cleave
	ability_primacy = XENO_PRIMARY_ACTION_3
	action_type = XENO_ACTION_CLICK
	xeno_cooldown = 12 SECONDS

	// Root config
	var/root_duration_unbuffed = 1 SECONDS
	var/root_duration_buffed = 1.8 SECONDS

	// Fling config
	var/fling_dist_unbuffed = 3
	var/fling_dist_buffed = 6

	// Root or do a punch-like-effect.
	var/root_toggle = TRUE
	var/buffed = FALSE // Are we buffed

/datum/action/xeno_action/onclick/toggle_cleave
	name = "Toggle Cleave Type"
	action_icon_state = "prae_cleave_root"
	plasma_cost = 0
	macro_path = /datum/action/xeno_action/verb/verb_toggle_cleave
	action_type = XENO_ACTION_CLICK
	ability_primacy = XENO_PRIMARY_ACTION_4

/datum/action/xeno_action/onclick/toggle_cleave/can_use_action()
	var/mob/living/carbon/xenomorph/X = owner
	if(X && !X.buckled && !X.is_mob_incapacitated())
		return TRUE

/datum/action/xeno_action/onclick/toggle_cleave/use_ability(atom/A)
	var/mob/living/carbon/xenomorph/X = owner

	if (!istype(X))
		return

	if(!X.check_state(1))
		return

	var/datum/action/xeno_action/activable/cleave/cAction = get_action(X, /datum/action/xeno_action/activable/cleave)

	if (!istype(cAction))
		return

	cAction.root_toggle = !cAction.root_toggle

	var/action_icon_result
	if (cAction.root_toggle)
		action_icon_result = "prae_cleave_root"
		to_chat(X, SPAN_WARNING("We will now root marines with our cleave."))
	else
		action_icon_result = "prae_cleave_fling" // TODO: update
		to_chat(X, SPAN_WARNING("We will now throw marines with our cleave."))

	button.overlays.Cut()
	button.overlays += image('icons/mob/hud/actions_xeno.dmi', button, action_icon_result)
	return ..()

////////// Oppressor powers

/datum/action/xeno_action/activable/tail_stab/tail_seize //no verbmacrohotkey, its just tail stab.
	name = "Tail Seize"
	action_icon_state = "tail_seize"
	action_type = XENO_ACTION_CLICK
	charge_time = 0.5 SECONDS
	xeno_cooldown = 15 SECONDS
	ability_primacy = XENO_TAIL_STAB

/datum/action/xeno_action/activable/prae_abduct
	name = "Abduct"
	action_icon_state = "abduct"
	macro_path = /datum/action/xeno_action/verb/verb_prae_abduct
	ability_primacy = XENO_PRIMARY_ACTION_1
	action_type = XENO_ACTION_CLICK
	xeno_cooldown = 15 SECONDS
	plasma_cost = 180

	// Config
	var/max_distance = 7
	var/windup = 8 DECISECONDS

/datum/action/xeno_action/activable/oppressor_punch
	name = "Dislocate"
	action_icon_state = "punch"
	macro_path = /datum/action/xeno_action/verb/verb_oppressor_punch
	action_type = XENO_ACTION_CLICK
	ability_primacy = XENO_PRIMARY_ACTION_2
	xeno_cooldown = 10 SECONDS
	plasma_cost = 55

	// Configurables
	var/damage = 20


// This one is more tightly coupled than I'd like, but oh well
// unused
/*datum/action/xeno_action/onclick/crush
	name = "Crush"
	action_icon_state = "prae_crush"
	action_text = "crush"
	macro_path = /datum/action/xeno_action/verb/verb_crush
	action_type = XENO_ACTION_ACTIVATE
	xeno_cooldown = 10 SECONDS
	plasma_cost = 80*/

// Tail lash
/datum/action/xeno_action/activable/tail_lash
	name = "Tail Lash"
	action_icon_state = "prae_tail_lash"
	macro_path = /datum/action/xeno_action/verb/verb_crush
	ability_primacy = XENO_PRIMARY_ACTION_3
	action_type = XENO_ACTION_CLICK
	xeno_cooldown = 13 SECONDS
	plasma_cost = 80

	// Config
	var/fling_dist = 3
	var/windup = 2 DECISECONDS

////////// Dancer Abilities

/datum/action/xeno_action/activable/prae_impale
	name = "Impale"
	action_icon_state = "prae_impale"
	macro_path = /datum/action/xeno_action/verb/verb_prae_impale
	ability_primacy = XENO_PRIMARY_ACTION_1
	action_type = XENO_ACTION_CLICK
	xeno_cooldown = 13 SECONDS
	plasma_cost = 80

	var/impale_click_miss_cooldown = 1.5 SECONDS

/datum/action/xeno_action/onclick/prae_dodge
	name = "Dodge"
	action_icon_state = "prae_dodge"
	macro_path = /datum/action/xeno_action/verb/verb_prae_dodge
	ability_primacy = XENO_PRIMARY_ACTION_2
	action_type = XENO_ACTION_CLICK
	plasma_cost = 200
	xeno_cooldown = 19 SECONDS

	// Config
	var/duration = 70
	var/speed_buff_amount = 0.5

/datum/action/xeno_action/activable/prae_tail_trip
	name = "Tail Trip"
	action_icon_state = "prae_tail_trip"
	macro_path = /datum/action/xeno_action/verb/verb_prae_tail_trip
	ability_primacy = XENO_PRIMARY_ACTION_3
	action_type = XENO_ACTION_CLICK
	xeno_cooldown = 13 SECONDS
	plasma_cost = 30

	var/tail_click_miss_cooldown = 1.5 SECONDS

	// Config
	var/range = 2
	var/slow_duration = 3
	var/stun_duration_default = 0.1
	var/daze_duration_default = 1
	var/stun_duration_buffed = 1
	var/daze_duration_buffed = 2

////////// BASE PRAE

/datum/action/xeno_action/activable/pounce/base_prae_dash
	name = "Dash"
	action_icon_state = "prae_dash"
	action_text = "dash"
	macro_path = /datum/action/xeno_action/verb/verb_dash
	action_type = XENO_ACTION_CLICK
	ability_primacy = XENO_PRIMARY_ACTION_2
	xeno_cooldown = 10 SECONDS
	plasma_cost = 40

	// Config options
	distance = 6
	knockdown = FALSE
	slash = FALSE
	freeze_self = FALSE

/datum/action/xeno_action/activable/prae_acid_ball
	name = "Acid Ball"
	action_icon_state = "prae_acid_ball"
	macro_path = /datum/action/xeno_action/verb/verb_acid_ball
	action_type = XENO_ACTION_CLICK
	ability_primacy = XENO_PRIMARY_ACTION_3
	xeno_cooldown = 18 SECONDS
	plasma_cost = 80

	var/activation_delay = 1 SECONDS
	var/prime_delay = 1 SECONDS

/datum/action/xeno_action/activable/spray_acid/base_prae_spray_acid
	name = "Spray Acid"
	action_icon_state = "spray_acid"
	macro_path = /datum/action/xeno_action/verb/verb_spray_acid
	action_type = XENO_ACTION_CLICK
	ability_primacy = XENO_PRIMARY_ACTION_4

	plasma_cost = 80
	xeno_cooldown = 10 SECONDS

	// Configurable options
	spray_type = ACID_SPRAY_LINE
	spray_distance = 7
	spray_effect_type = /obj/effect/xenomorph/spray/praetorian
	activation_delay = TRUE
	activation_delay_length = 5

///////////////////////// VALKYRIE PRAE

/datum/action/xeno_action/activable/tail_stab/tail_fountain //no verbmacrohotkey, its just tail stab.
	name = "Tail Fountain"
	action_icon_state = "tail_seize"
	action_type = XENO_ACTION_CLICK
	charge_time = 0.5 SECONDS
	xeno_cooldown = 10 SECONDS
	ability_primacy = XENO_TAIL_STAB

/datum/action/xeno_action/activable/valkyrie_rage
	name = "Tantrum"
	action_icon_state = "warden_heal"
	action_type = XENO_ACTION_CLICK
	ability_primacy = XENO_PRIMARY_ACTION_1
	macro_path = /datum/action/xeno_action/verb/verb_prae_rage
	plasma_cost = 100
	xeno_cooldown = 7 SECONDS
	var/datum/weakref/focus_rage = null

	//rage configs
	var/armor_buff = 10 // the idea behind this is you can buff somebody to go in, or get them out which is why the armor is so high while the duration is so low, will need tweaks according to how well it does
	var/armor_buffs_duration = 5 SECONDS // your buff lasts longer because its less and ideally you should be in there slashing people already
	var/armor_buffs_active = FALSE
	var/max_range = 8

	var/target_armor_buff = 15
	var/armor_buffs_targer_dur = 3 SECONDS
	var/armor_buffs_active_target = FALSE

	var/speed_buff_dur = 2 SECONDS // tier 3's get speed boost instead of armor because they become a little broken.
	var/speed_buff_amount = 0.7
	var/armor_buffs_speed_target = FALSE
	var/rage_cost = 75


/datum/action/xeno_action/activable/high_gallop
	name = "High Gallop"
	action_icon_state = "prae_tail_trip"
	action_type = XENO_ACTION_CLICK
	ability_primacy = XENO_PRIMARY_ACTION_2
	macro_path = /datum/action/xeno_action/verb/verb_prae_high_gallop
	xeno_cooldown = 12 SECONDS

	//knockdown range
	var/gallop_range = 3


/datum/action/xeno_action/onclick/fight_or_flight
	name = "Fight or Flight"
	action_icon_state = "screech"
	action_type = XENO_ACTION_ACTIVATE
	ability_primacy = XENO_PRIMARY_ACTION_3
	macro_path = /datum/action/xeno_action/verb/verb_prae_fight_or_flight
	xeno_cooldown = 45 SECONDS
	plasma_cost = 300

	// ranges and windup duration, this part of the ability is heavily experimental and will be touched after if it makes to testing
	var/low_rage_range = 4
	var/high_rage_range = 6
	var/rejuvenate_cost = 75

/datum/action/xeno_action/activable/prae_retrieve

	name = "Retrieve"
	action_icon_state = "retrieve"
	macro_path = /datum/action/xeno_action/verb/verb_prae_retrieve
	ability_primacy = XENO_PRIMARY_ACTION_4
	action_type = XENO_ACTION_CLICK
	xeno_cooldown = 10 SECONDS
	plasma_cost = 180

	confing
	var/max_distance = 7
	var/windup = 6
	var/retrieve_cost = 100
