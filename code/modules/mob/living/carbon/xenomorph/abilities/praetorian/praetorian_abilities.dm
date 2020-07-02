//// Abilities PRIMARILY used by Praetorian.


////////// VANGUARD ABILITIES

/datum/action/xeno_action/activable/pierce
	name = "Pierce"
	action_icon_state = "prae_pierce"
	ability_name = "pierce"
	macro_path = /datum/action/xeno_action/verb/verb_pierce
	action_type = XENO_ACTION_CLICK
	ability_primacy = XENO_PRIMARY_ACTION_1
	cooldowns = list(45, 35, 30, 25)
	plasma_cost = 20

	// Config
	var/damage = 50
	var/shield_regen_threshold = 2
	var/should_spin_instead = FALSE

/datum/action/xeno_action/activable/pounce/prae_dash
	name = "Dash"
	action_icon_state = "prae_dash"
	ability_name = "dash"
	macro_path = /datum/action/xeno_action/verb/verb_dash
	action_type = XENO_ACTION_CLICK
	ability_primacy = XENO_PRIMARY_ACTION_2
	cooldowns = list(130, 120, 110, 100)
	plasma_cost = 10

	// Config options
	distance = 5					
	knockdown = FALSE				
	slash = FALSE					
	freeze_self = FALSE				
	pounce_pass_flags = PASS_MOB|PASS_OVER_THROW_MOB

	var/buff_duration = 12
	var/damage = 45
	var/shield_regen_threshold = 2

	var/activated_once = FALSE
	var/time_until_timeout = 20

/datum/action/xeno_action/activable/cleave
	name = "Cleave"
	action_icon_state = "prae_cleave_action"
	ability_name = "cleave"
	macro_path = /datum/action/xeno_action/verb/verb_cleave
	ability_primacy = XENO_PRIMARY_ACTION_3
	action_type = XENO_ACTION_CLICK
	cooldowns = list(80, 75, 70, 70)

	// Root config
	var/root_duration_unbuffed = 5
	var/root_duration_buffed = 12.5

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

/datum/action/xeno_action/onclick/toggle_cleave/can_use_action()
	var/mob/living/carbon/Xenomorph/X = owner
	if(X && !X.buckled && !X.is_mob_incapacitated())
		return TRUE

/datum/action/xeno_action/onclick/toggle_cleave/use_ability(atom/A)
	var/mob/living/carbon/Xenomorph/X = owner

	if (!istype(X))
		return

	if(!X.check_state(1))
		return

	var/datum/action/xeno_action/activable/cleave/cAction = get_xeno_action_by_type(X, /datum/action/xeno_action/activable/cleave)

	if (!istype(cAction))
		return

	cAction.root_toggle = !cAction.root_toggle

	var/action_icon_result
	if (cAction.root_toggle)
		action_icon_result = "prae_cleave_root"
		to_chat(X, SPAN_WARNING("You will now root marines with your cleave."))
	else
		action_icon_result = "prae_cleave_fling" // TODO: update
		to_chat(X, SPAN_WARNING("You will now throw marines with your cleave."))

	button.overlays.Cut()
	button.overlays += image('icons/mob/hud/actions.dmi', button, action_icon_result)

////////// Oppressor powers
/datum/action/xeno_action/activable/prae_stomp
	name = "Stomp"
	action_icon_state = "stomp"
	ability_name = "stomp"
	macro_path = /datum/action/xeno_action/verb/verb_prae_stomp
	ability_primacy = XENO_PRIMARY_ACTION_1
	action_type = XENO_ACTION_CLICK
	cooldowns = list(150, 140, 130, 120)
	plasma_cost = 50

	// Config
	var/max_distance = 5
	var/windup = 3
	var/knockdown_power = 1


// This one is more tightly coupled than I'd like, but oh well
/datum/action/xeno_action/onclick/crush
	name = "Crush"
	action_icon_state = "prae_crush"
	ability_name = "crush"
	macro_path = /datum/action/xeno_action/verb/verb_crush
	ability_primacy = XENO_PRIMARY_ACTION_2
	action_type = XENO_ACTION_ACTIVATE
	cooldowns = list(120, 110, 100, 90)
	plasma_cost = 50

// Tail lash
/datum/action/xeno_action/activable/tail_lash
	name = "Tail Lash"
	action_icon_state = "prae_tail_lash"
	ability_name = "tail lash"
	macro_path = /datum/action/xeno_action/verb/verb_crush
	ability_primacy = XENO_PRIMARY_ACTION_3
	action_type = XENO_ACTION_CLICK
	cooldowns = list(150, 140, 130, 120)
	plasma_cost = 50

	// Config
	var/fling_dist = 5
	var/windup = 3

////////// Dancer Abilities

/datum/action/xeno_action/activable/prae_impale
	name = "Impale"
	action_icon_state = "prae_impale"
	ability_name = "impale"
	macro_path = /datum/action/xeno_action/verb/verb_prae_impale
	ability_primacy = XENO_PRIMARY_ACTION_1
	action_type = XENO_ACTION_CLICK
	cooldowns = list(150, 140, 130, 120)
	plasma_cost = 100

	var/click_miss_cooldown = 15

/datum/action/xeno_action/activable/prae_dodge
	name = "Dodge"
	action_icon_state = "prae_dodge"
	ability_name = "dodge"
	macro_path = /datum/action/xeno_action/verb/verb_prae_dodge
	ability_primacy = XENO_PRIMARY_ACTION_2
	action_type = XENO_ACTION_ACTIVATE
	plasma_cost = 100
	cooldowns = list(250, 230, 210, 190)

	// Config
	var/duration = 70
	var/speed_buff_amount = 0.5

/datum/action/xeno_action/activable/prae_tail_trip
	name = "Tail Trip"
	action_icon_state = "prae_tail_trip"
	ability_name = "tail trip"
	macro_path = /datum/action/xeno_action/verb/verb_prae_tail_trip
	ability_primacy = XENO_PRIMARY_ACTION_3
	action_type = XENO_ACTION_CLICK
	cooldowns = list(150, 140, 130, 120)
	plasma_cost = 50

	// Config
	var/range = 2
	var/slow_duration = 3
	var/stun_duration_default = 0.1
	var/daze_duration_default = 1
	var/stun_duration_buffed = 1
	var/daze_duration_buffed = 2

	var/click_miss_cooldown = 15

////////// BASE PRAE

/datum/action/xeno_action/activable/pounce/base_prae_dash
	name = "Dash"
	action_icon_state = "prae_dash"
	ability_name = "dash"
	macro_path = /datum/action/xeno_action/verb/verb_dash
	action_type = XENO_ACTION_CLICK
	ability_primacy = XENO_PRIMARY_ACTION_2
	cooldowns = list(50, 50, 50, 50)
	plasma_cost = 10

	// Config options
	distance = 4			
	knockdown = FALSE				
	slash = FALSE					
	freeze_self = FALSE		

/datum/action/xeno_action/activable/prae_acid_ball
	name = "Acid Ball"
	action_icon_state = "prae_acid_ball"
	ability_name = "acid ball"
	macro_path = /datum/action/xeno_action/verb/verb_acid_ball
	action_type = XENO_ACTION_CLICK
	ability_primacy = XENO_PRIMARY_ACTION_3
	cooldowns = list(200, 190, 180, 170)
	plasma_cost = 75

	var/activation_delay = 10
	var/prime_delay = 10

/datum/action/xeno_action/activable/spray_acid/base_prae_spray_acid
	name = "Spray Acid"
	action_icon_state = "spray_acid"
	ability_name = "spray acid"
	macro_path = /datum/action/xeno_action/verb/verb_spray_acid
	action_type = XENO_ACTION_CLICK
	ability_primacy = XENO_PRIMARY_ACTION_4
	
	plasma_cost = 40
	cooldowns = list(120, 110, 100, 90)

	// Configurable options
	spray_type = ACID_SPRAY_LINE	
	spray_distance = 7				
	spray_effect_type = /obj/effect/xenomorph/spray/praetorian
	activation_delay = TRUE		
	activation_delay_length = 5


///////////////////////// WARDEN PRAE

/datum/action/xeno_action/activable/spray_acid/prae_warden
	ability_primacy = XENO_PRIMARY_ACTION_2	
	plasma_cost = 60
	cooldowns = list(150, 140, 130, 120)


	// Configurable options

	spray_type = ACID_SPRAY_LINE	// Enum for the shape of spray to do
	spray_distance = 7 				// Distance to spray

	activation_delay = TRUE		 
	activation_delay_length = 5

/datum/action/xeno_action/activable/warden_heal
	name = "Protect"
	action_icon_state = "transfer_health"
	ability_name = "protect"
	// todo: macro
	action_type = XENO_ACTION_CLICK
	ability_primacy = XENO_PRIMARY_ACTION_3
	cooldowns = list(100, 100, 100, 100)
	plasma_cost = 75

	// Config

	// These values are used to determine the
	// "HP costs" and effects of the three different, toggle-able, heal types.
	var/heal_cost = 100
	var/heal_amount = 175

	var/shield_cost = 100
	var/shield_amount = 125

	var/debuff_cost = 100

	var/curr_effect_type = WARDEN_HEAL_SHIELD


/datum/action/xeno_action/onclick/prae_switch_heal_type
	name = "Toggle Heal Type"
	action_icon_state = "warden_shield" // default = shield
	macro_path = /datum/action/xeno_action/verb/verb_prae_switch_heal_types
	action_type = XENO_ACTION_ACTIVATE

/datum/action/xeno_action/onclick/prae_switch_heal_type/can_use_action()
	var/mob/living/carbon/Xenomorph/X = owner
	if(X && !X.buckled && !X.is_mob_incapacitated())
		return TRUE

/datum/action/xeno_action/onclick/prae_switch_heal_type/use_ability(atom/A)

	var/mob/living/carbon/Xenomorph/X = owner
	var/action_icon_result

	if(!X.check_state(1))
		return

	var/datum/action/xeno_action/activable/warden_heal/WH = get_xeno_action_by_type(X, /datum/action/xeno_action/activable/warden_heal)
	if (!istype(WH))
		return

	if (WH.curr_effect_type == WARDEN_HEAL_SHIELD)
		action_icon_result = "warden_heal"
		WH.curr_effect_type = WARDEN_HEAL_HP
		to_chat(X, SPAN_XENOWARNING("You will now protect your allies with a heal!"))
	
	else if (WH.curr_effect_type == WARDEN_HEAL_HP)
		action_icon_result = "warden_rejuvenate"
		WH.curr_effect_type = WARDEN_HEAL_DEBUFFS
		to_chat(X, SPAN_XENOWARNING("You will now protect your allies by rejuvenating them!"))
		
	else
		action_icon_result = "warden_shield"
		WH.curr_effect_type = WARDEN_HEAL_SHIELD
		to_chat(X, SPAN_XENOWARNING("You will now protect your allies by increasing their resilience from afar!"))
		
	button.overlays.Cut()
	button.overlays += image('icons/mob/hud/actions.dmi', button, action_icon_result)