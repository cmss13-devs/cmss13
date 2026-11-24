// Actual caste datum basedef
/datum/caste_datum
	var/caste_type = ""
	/// Action typepaths granted to a newly spawned member of this caste.
	var/list/base_actions
	var/display_name = ""
	var/tier = 0
	var/dead_icon = "Drone Dead"
	var/language = LANGUAGE_XENOMORPH
	var/melee_damage_lower = 10
	var/melee_damage_upper = 20
	///allows fine tuning melee damage to vehicles per caste.
	var/melee_vehicle_damage = 10
	var/evasion = XENO_EVASION_NONE

	var/speed = XENO_SPEED_TIER_10

	var/plasma_max = 10
	var/plasma_gain = 5

	var/max_health = XENO_UNIVERSAL_HPMULT * 100
	///Are they allowed to evolve (and have their evolution progress group)
	var/evolution_allowed = 1
	///Threshold to next evolution
	var/evolution_threshold = 0
	/// whether they can get evo points without needing an ovi queen
	var/evolve_without_queen = FALSE
	///This is where you add castes to evolve into. "Separated", "by", "commas"
	var/list/evolves_to = list()
	/// what caste or castes to de-evolve to.
	var/list/deevolves_to = list()
	///This is where you add castes drones can evolve to before first drop.
	var/list/early_evolves_to
	///If they can use consoles, etc. Set on Queen
	var/is_intelligent = 0
	var/caste_desc = null
	/// Combat or support mechanics to explain before a player evolves.
	var/playstyle

	// Tackles
	/// Whether this caste has a tackle attack to describe in its preview.
	var/can_tackle = TRUE
	var/tackle_min = 2
	var/tackle_max = 6
	var/tackle_chance = 35
	var/tacklestrength_min = 2
	var/tacklestrength_max = 3

	///Chance of deflecting projectiles.
	var/armor_deflection = 0
	var/fire_intensity_resistance = 0

	/// Windup for spits
	var/spit_windup = FALSE

	///The strength of our aura. Zero means we can't emit one
	var/aura_strength = XENO_PHERO_STRENGTH_NONE

	///"Evolving" removed for the time being
	var/aura_allowed = list(XENO_PHERO_FRENZY, XENO_PHERO_WARDING, XENO_PHERO_RECOVERY)

	///Adjust pixel size. 0.x is smaller, 1.x is bigger, percentage based.
	var/adjust_size_x = 1
	var/adjust_size_y = 1

	///list of datum projectile types the xeno can use.
	var/list/spit_types

	var/attack_delay = 0 //Bonus or pen to time in between attacks. + makes slashes slower.

	var/agility_speed_increase = 0 // this opens up possibilities for balancing

	/// A list of strain typepaths that are able to be chosen by this caste.
	var/list/available_strains = list()

	// The type of mutator delegate to instantiate on the base caste. Will
	// be replaced when the Xeno chooses a strain.
	var/behavior_delegate_type = /datum/behavior_delegate

	// Resin building-related vars
	/// Default build time and build distance
	var/build_time_mult = BUILD_TIME_MULT_XENO
	var/max_build_dist = 0

	// Carrier vars //

	/// if a hugger is held in hand, won't attempt to leap and kill itself
	var/hugger_nurturing = FALSE
	var/huggers_max = 0
	var/throwspeed = 0
	/// delay time modifier it takes between hugger throws, only exclusively used by the carrier currently
	var/hugger_throw_delay = 0
	var/eggs_max = 0
	var/egg_cooldown = 3 SECONDS
	///Armor but for explosions
	var/xeno_explosion_resistance = 0

	//Queen vars
	var/can_hold_facehuggers = 0
	var/can_hold_eggs = CANNOT_HOLD_EGGS

	var/can_be_queen_healed = TRUE
	var/can_be_revived = TRUE

	var/can_vent_crawl = 1

	var/caste_luminosity = 0

	/// if fire_immunity is set to be vulnerable, how much will fire damage be multiplied. Defines in xeno.dm
	var/fire_vulnerability_mult = 0

	var/burrow_cooldown = 5 SECONDS
	var/burrow_duration = 9 SECONDS
	var/tunnel_cooldown = 10 SECONDS
	///whether the xeno heals even outside weeds.
	var/innate_healing = FALSE

	var/acid_level = 0
	var/weed_level = WEED_LEVEL_STANDARD
	///Time it takes between acid splash retaliate procs. Variable per caste, for if we want future castes that are acid bombs
	var/acid_splash_cooldown = 3 SECONDS

	// regen vars

	var/heal_delay_time = 0 SECONDS
	var/heal_resting = 1
	var/heal_standing = 0.4
	var/heal_knocked_out = 0.33

	var/list/resin_build_order
	var/minimum_xeno_playtime = 0

// cannot evolve to this caste until the round has been going on for this amount of time
	// IMPORTANT: this is ROUND_TIME, not world.time
	var/minimum_evolve_time = 1 MINUTES
	/// Iconstate for the xeno on the minimap
	var/minimap_icon = "xeno"
	var/minimap_background = "background_xeno"
	///The iconstate for leadered xenos on the minimap, added as overlay
	var/minimap_leadered_overlay = "xenoleader"

	var/royal_caste = FALSE

	var/organ_type = /obj/item/organ/xeno;
	/// Time taken to regenerate the organ
	var/organ_regen_time = 5 MINUTES


/datum/caste_datum/can_vv_modify()
	return FALSE

/datum/caste_datum/proc/base_plasma_capacity(datum/xeno_strain/strain)
	return max(plasma_max + (strain?.plasma_mod || 0), 0)

/// Abilities documented by this caste, including any later unlocks
/datum/caste_datum/proc/get_preview_actions()
	return base_actions.Copy()

/// Preview the destination's base form against the abilities and permanent stats of the current caste and strain.
/datum/caste_datum/proc/show_preview(mob/living/carbon/xenomorph/xeno, mob/living/carbon/xenomorph/destination_type, confirm_action, notice)
	if(!destination_type || !xeno.client)
		return FALSE
	var/list/buttons = confirm_action ? list(confirm_action, "Cancel") : list("Close")
	var/datum/tgui_modal/xeno_preview/preview = new(xeno, null, caste_type, buttons, 0, TRUE, GLOB.always_state)
	var/datum/xeno_strain/strain = xeno.strain
	var/list/current_actions = xeno.caste.get_preview_actions()
	if(strain)
		current_actions = (current_actions - strain.actions_to_remove) | strain.actions_to_add
	current_actions = preview.action_types(current_actions)
	var/list/destination_actions = preview.action_types(get_preview_actions())

	var/armor_change = armor_deflection - xeno.caste.armor_deflection - (strain?.armor_mod || 0)
	var/health_change = max_health - xeno.caste.max_health - (strain?.health_mod || 0)
	var/damage_change = (melee_damage_lower + melee_damage_upper - xeno.caste.melee_damage_lower - xeno.caste.melee_damage_upper) * 0.5 - (strain?.damage_mod || 0)
	var/portrait_state = "Normal [caste_type] Running"
	var/portrait_file = initial(destination_type.icon_xeno)
	if(HAS_TRAIT(xeno, TRAIT_XENONID) && initial(destination_type.icon_xenonid) && icon_exists(initial(destination_type.icon_xenonid), portrait_state))
		portrait_file = initial(destination_type.icon_xenonid)
	if(!icon_exists(portrait_file, portrait_state))
		portrait_state = initial(destination_type.icon_state)
	preview.details = list(
		"windowTitle" = confirm_action || "Strain Information",
		"currentCaste" = !confirm_action,
		"notice" = notice,
		"caste" = confirm_action ? "[strain?.name || xeno.caste_type] to [caste_type]" : "Base caste",
		"summary" = playstyle || caste_desc,
		"tackleMin" = tackle_min,
		"canTackle" = can_tackle,
		"tackleMax" = tackle_max,
		"flavor" = initial(destination_type.desc),
		"portrait" = icon2html(portrait_file, xeno, portrait_state, dir = SOUTH, sourceonly = TRUE, non_standard_size = TRUE),
		"resources" = preview.resource_changes(xeno, xeno.caste, strain, src, null),
		"stats" = preview.stat_changes(xeno, armor_change, damage_change, health_change, show_current = !confirm_action),
		"showCurrentStats" = !confirm_action,
		"gained" = preview.abilities(xeno, confirm_action ? destination_actions - current_actions : destination_actions),
		"lost" = preview.abilities(xeno, current_actions - destination_actions),
	)
	var/choice = preview.prompt(xeno)
	qdel(preview)
	return confirm_action && choice == confirm_action

/datum/caste_datum/New()
	. = ..()

	//Initialise evolution and upgrade thresholds in one place, once and for all
	evolution_threshold = 0
	if(evolution_allowed)
		switch(tier)
			if(0)
				evolution_threshold = 60
			if(1)
				evolution_threshold = 200
			if(2)
				evolution_threshold = 500
			//Other tiers (T3, Queen, etc.) can't evolve anyway

	resin_build_order = GLOB.resin_build_order_drone

/client/var/cached_xeno_playtime

/datum/caste_datum/proc/can_play_caste(client/client)
	if(!CONFIG_GET(flag/use_timelocks))
		return TRUE

	var/total_xeno_playtime = client.get_total_xeno_playtime()

	if(minimum_xeno_playtime && total_xeno_playtime < minimum_xeno_playtime)
		return FALSE

	return TRUE

/datum/caste_datum/proc/get_caste_requirement(client/client)
	return minimum_xeno_playtime - client.get_total_xeno_playtime()
