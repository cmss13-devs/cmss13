/datum/action/xeno_action/onclick/toggle_long_range/boiler
	should_delay = TRUE
	delay = 0.5 SECONDS
	ability_primacy = XENO_PRIMARY_ACTION_4
	handles_movement = FALSE
	movement_slowdown = XENO_SPEED_SLOWMOD_ZOOM

/datum/action/xeno_action/onclick/shift_spits/boiler
	ability_description = "Switch between acid or neuorotoxic gas carried by your bombardment glob."
	name = "Toggle Gas Type"
	action_icon_state = "shift_spit_acid_glob"
	macro_path = /datum/action/xeno_action/verb/verb_toggle_spit_type
	action_type = XENO_ACTION_CLICK
	ability_primacy = XENO_PRIMARY_ACTION_2
	xeno_cooldown = 1 SECONDS // Spam preventionv

/datum/action/xeno_action/activable/spray_acid/boiler
	plasma_cost = 40
	xeno_cooldown = 10 SECONDS
	ability_primacy = XENO_PRIMARY_ACTION_3
	// Configurable options
	spray_type = ACID_SPRAY_LINE	// Enum for the shape of spray to do
	spray_distance = 6 				// Distance to spray


/datum/action/xeno_action/activable/xeno_spit/bombard
	ability_stats_type = /datum/xeno_ability_stats/bombard
	ability_description = "Lob a gas glob at distant terrain to cover the impact area in your selected gas."
	name = "Bombard"
	action_icon_state = "bombard"
	cooldown_message = "Our stomach fills with another gas glob. We are ready to bombard again."
	sound_to_play = 'sound/effects/blobattack.ogg'
	aim_turf = TRUE
	xeno_cooldown = 30 SECONDS
	no_cooldown_msg = FALSE // Boiler spits slow enough that having a cooldown message is justifiable
	/// These are actions that will be placed on cooldown for the cooldown_duration when activates. Added acid shroud for now because it can be abused
	var/action_types_to_cd = list(
		/datum/action/xeno_action/onclick/acid_shroud,
	)

	/// Duration for the cooldown of abilities affected by bombard
	var/cooldown_duration = 20 SECONDS

XENO_ABILITY_STATS(bombard, datum/action/xeno_action/activable/xeno_spit/bombard)
	var/windup = /datum/ammo/xeno/boiler_gas::spit_windup
	var/radius = /datum/ammo/xeno/boiler_gas::smokerange
	var/cost = /datum/ammo/xeno/boiler_gas::spit_cost
	return list(
		XENO_STAT_VALUE("Windup", windup * 0.1, null, "s."),
		XENO_STAT_VALUE("Cloud radius", radius, null, " tiles."),
		XENO_STAT_VALUE("Plasma per glob", cost, "plasma", "."),
	)

/datum/action/xeno_action/onclick/acid_shroud  // acid dump alternative
	ability_description = "Release a cloud of your selected gas around yourself."
	name = "Acid Shroud"
	action_icon_state = "acid_shroud"
	action_type = XENO_ACTION_ACTIVATE
	ability_primacy = XENO_PRIMARY_ACTION_5
	plasma_cost = 10
	macro_path = /datum/action/xeno_action/verb/verb_acid_shroud
	/// Allows the sound to play. Flipped to false when sound is triggered and true after a timer. This prevents soundspam
	var/sound_play = TRUE
	cooldown_message = "Our stomach has sufficiently filled with gas and our pores are opened again. We can now shroud ourselves with acid."

	/// These are actions that will be placed on cooldown for the cooldown_duration when activates
	var/action_types_to_cd = list(
		/datum/action/xeno_action/activable/xeno_spit/bombard,
		/datum/action/xeno_action/onclick/acid_shroud,
		/datum/action/xeno_action/onclick/toggle_long_range/boiler,
		/datum/action/xeno_action/activable/spray_acid/boiler,
	)
	xeno_cooldown = 34 SECONDS

	/// Duration for the cooldown of abilities affected by acid shroud
	var/cooldown_duration = 30 SECONDS

/datum/action/xeno_action/activable/tail_stab/boiler
	ability_description = "Stab a target to inject acid or neurotoxin, depending on your selected gas."
	name = "Toxic Tail Stab"
	cooldown_message = "Our tail's acid stores have filled up enough to stab with it."
