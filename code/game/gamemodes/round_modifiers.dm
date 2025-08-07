/// Sets and enables all applicable gamemode modifiers
/datum/game_mode/proc/initialize_gamemode_modifiers()
	var/list/default_modifiers = starting_round_modifiers

	for(var/datum/gamemode_modifier/current_modifier as anything in subtypesof(/datum/gamemode_modifier))
		if(current_modifier == current_modifier::abstract_type)
			continue

		var/starts_enabled = FALSE
		for(var/starting_modifier in default_modifiers)
			if(starting_modifier != current_modifier)
				continue
			starts_enabled = TRUE
			default_modifiers -= starting_modifier
			break

		var/datum/gamemode_modifier/modifier = new current_modifier
		if(starts_enabled)
			modifier.active = TRUE
		round_modifiers[current_modifier] += modifier

/// Returns the state of the modifier, using its typepath
/datum/game_mode/proc/get_gamemode_modifier(modifier_typepath)
	var/datum/gamemode_modifier/modifier = round_modifiers[modifier_typepath]
	if(!modifier)
		CRASH("Invalid gamemode modifier, [modifier_typepath], was attempted to be checked.")
	return modifier.active

/// Sets the state of the modifier, using its typepath and the state to set it to
/datum/game_mode/proc/set_gamemode_modifier(modifier_typepath, enabled = FALSE)
	var/datum/gamemode_modifier/modifier = round_modifiers[modifier_typepath]
	if(!modifier)
		CRASH("Invalid gamemode modifier, [modifier_typepath], was attempted to be set.")
	modifier.set_active(enabled)
	return TRUE

/datum/gamemode_modifier
	var/active = FALSE
	var/modifier_name
	var/modifier_desc
	var/datum/gamemode_modifier/abstract_type = /datum/gamemode_modifier

/datum/gamemode_modifier/proc/set_active(enabled = FALSE)
	SHOULD_CALL_PARENT(TRUE)
	active = enabled

/datum/gamemode_modifier/blood_optimization
	modifier_name = "Blood Optimizations"
	modifier_desc = "Blood dries instantly, footsteps cannot get bloodied."

/datum/gamemode_modifier/defib_past_armor
	modifier_name = "Strong Defibrillators"
	modifier_desc = "Allows defibrillators to ignore armor when reviving."

/datum/gamemode_modifier/disable_combat_cas
	modifier_name = "Disable Combat CAS"
	modifier_desc = "Prevents purchasing weapons or ammo in the dropship's part fabricators."

/datum/gamemode_modifier/disable_attacking_corpses
	modifier_name = "Disable Attacking Corpses"
	modifier_desc = "Prevents weapons from hitting dead mobs, and blocks executions."

/datum/gamemode_modifier/disable_ib
	modifier_name = "Disable Internal Bleeding"
	modifier_desc = "Prevents mobs from getting internal bleeding when injured."

/datum/gamemode_modifier/disable_long_range_sentry
	modifier_name = "Disable Long Range Sentry Upgrades"
	modifier_desc = "Prevents sentries from upgrading to long range variants. Applies to DMR and Long-Range Plasma upgrades."

/datum/gamemode_modifier/disable_ob
	modifier_name = "Disable Orbital Bombardment Cannon"
	modifier_desc = "Prevents the Orbital Bombardment system from firing OB warheads."

/datum/gamemode_modifier/disable_strip_essentials
	modifier_name = "Disable Stripping Hostiles Essentials"
	modifier_desc = "Requires Disable Stripping Hostiles enabled. Allows factions to strip non-essentials from other factions. Essentials are ID, helmet, armor, uniform, and boots."

/datum/gamemode_modifier/disable_stripdrag_enemy
	modifier_name = "Disable Stripping Hostiles"
	modifier_desc = "Prevents factions from stripping or dragging other factions. Applies to stripping, dragging, sensors, splints, and internals."

/datum/gamemode_modifier/disable_wj_respawns
	modifier_name = "Disable Working Joe Respawning"
	modifier_desc = "Prevents players from joining as Working Joe multiple times in a round."

/datum/gamemode_modifier/disposable_mobs
	modifier_name = "Allow Disposing Mobs"
	modifier_desc = "Allows non-crawler mobs to enter non-narrow disposals systems."

/datum/gamemode_modifier/ignore_wj_restrictions
	modifier_name = "Disable Working Joe Joining Restrictions"
	modifier_desc = "Removes all restrictions on Working Joe's joining. Applies to respawn cooldown, slot cap, and administrative locks."

/datum/gamemode_modifier/indestructible_splints
	modifier_name = "Indestructible Splints"
	modifier_desc = "Turns splints into nanosplints when the splint is created."

/datum/gamemode_modifier/lz_mortar_protection
	modifier_name = "Landing Zone Mortar Protection"
	modifier_desc = "Prevents mortars from targetting the primary landing zone."

/datum/gamemode_modifier/lz_roundstart_miasma
	modifier_name = "Roundstart Landing Zone Miasma"
	modifier_desc = "Miasma is applied to both landing zones roundstart. Does nothing if activated after miasma trigger 3 minutes into round."

/datum/gamemode_modifier/lz_roundstart_miasma/set_active(enabled)
	. = ..()
	if(ROUND_TIME > DISTRESS_LZ_HAZARD_START)
		to_chat(usr, SPAN_WARNING("Its too late to toggle this!"))

/datum/gamemode_modifier/lz_weeding
	modifier_name = "Landing Zone Weeding"
	modifier_desc = "Allows xenomorphs to weed all landing zones."

/datum/gamemode_modifier/lz_weeding/set_active(enabled)
	. = ..()
	for(var/area/cur_area as anything in GLOB.all_areas)
		if(cur_area.flags_area & AREA_UNWEEDABLE)
			continue
		cur_area.is_resin_allowed = enabled ? TRUE : initial(cur_area.is_resin_allowed)

/datum/gamemode_modifier/mortar_laser_warning
	modifier_name = "Mortar Telegraphing"
	modifier_desc = "Shows a visual warning of where a mortar will hit."

/datum/gamemode_modifier/permadeath
	modifier_name = "Human Permadeath"
	modifier_desc = "Humans will permanently die without possibility of revival."

/datum/gamemode_modifier/yautja_shipside_large_sd
	modifier_name = "Yautja Shipside Large SD"
	modifier_desc = "Allows Yautja to large self destruct on the mainship z-level."


/datum/gamemode_modifier/heavy_specialists
	modifier_name = "Heavy uscm specialists"
	modifier_desc = "Replaces all specialist kits with b18 armor kit."

/datum/gamemode_modifier/weaker_explosions_fire
	modifier_name = "Weaker explosions"
	modifier_desc = "Reduces damage from flames and explosion and stun from explosions to humans."


/datum/gamemode_modifier/no_body_c4
	modifier_name = "No body c4"
	modifier_desc = "Prevents c4 explosives from being planted on dead body."

/datum/gamemode_modifier/ceasefire
	modifier_name = "Ceasefire"
	modifier_desc = "Prevents firing guns and throwing granades."
