GLOBAL_DATUM(almayer_aa_cannon, /obj/structure/anti_air_cannon)

/obj/structure/anti_air_cannon
	name = "\improper IX-50 MGAD Cannon"
	desc = "The IX-50 is a state-of-the-art Micro-Gravity and Air Defense system capable of independently tracking and neutralizing threats with rockets strapped onto them."
	icon = 'icons/effects/128x128.dmi'
	icon_state = "anti_air_cannon"
	density = TRUE
	anchored = TRUE
	layer = LADDER_LAYER
	bound_width = 128
	bound_height = 64
	bound_y = 64
	unslashable = TRUE
	unacidable = TRUE

	// Which ship section is being protected by the AA gun
	var/protecting_section = ""
	var/is_disabled = FALSE

/obj/structure/anti_air_cannon/New()
	. = ..()
	if(!GLOB.almayer_aa_cannon)
		GLOB.almayer_aa_cannon = src

/obj/structure/anti_air_cannon/Destroy()
	. = ..()
	if(GLOB.almayer_aa_cannon == src)
		GLOB.almayer_aa_cannon = null
		message_admins("Reference to GLOB.almayer_aa_cannon is lost!")

/obj/structure/anti_air_cannon/ex_act()
	return

/obj/structure/anti_air_cannon/bullet_act()
	return

/obj/structure/machinery/computer/aa_console
	name = "\improper MGAD System Console"
	desc = "The console controlling anti air tracking systems."
	icon_state = "ob_console"
	dir = WEST
	flags_atom = ON_BORDER|CONDUCT|FPRINT

	req_one_access = list(ACCESS_MARINE_ENGINEERING, ACCESS_MARINE_COMMAND)
	unacidable = TRUE
	unslashable = TRUE

/obj/structure/machinery/computer/aa_console/initialize_pass_flags(datum/pass_flags_container/PF)
	..()
	if (PF)
		PF.flags_can_pass_all = PASS_ALL

/obj/structure/machinery/computer/aa_console/ex_act()
	return

/obj/structure/machinery/computer/aa_console/bullet_act()
	return

/obj/structure/machinery/computer/aa_console/tgui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "AntiAirConsole", "[src.name]")
		ui.open()


/obj/structure/machinery/computer/aa_console/ui_state(mob/user)
	return GLOB.not_incapacitated_and_adjacent_state

/obj/structure/machinery/computer/aa_console/ui_status(mob/user, datum/ui_state/state)
	. = ..()
	if(inoperable())
		return UI_CLOSE
	if(!allowed(user))
		return UI_CLOSE

/obj/structure/machinery/computer/aa_console/ui_static_data(mob/user)
	var/list/data = list()

	data["sections"] = list()

	for(var/section in GLOB.almayer_ship_sections)
		data["sections"] += list(list(
			"section_id" = section,
		))

	return data

/obj/structure/machinery/computer/aa_console/ui_data(mob/user)
	var/list/data = list()

	data["disabled"] = GLOB.almayer_aa_cannon.is_disabled
	data["protecting_section"] = GLOB.almayer_aa_cannon.protecting_section

	return data

/obj/structure/machinery/computer/aa_console/ui_act(action, list/params, datum/tgui/ui, datum/ui_state/state)
	. = ..()
	if(.)
		return

	if(!GLOB.almayer_aa_cannon)
		return

	switch(action)
		if("protect")
			GLOB.almayer_aa_cannon.protecting_section = params["section_id"]
			if(!(GLOB.almayer_aa_cannon.protecting_section in GLOB.almayer_ship_sections))
				GLOB.almayer_aa_cannon.protecting_section = ""
				return
			message_admins("[key_name(usr)] has set the AA to [html_encode(GLOB.almayer_aa_cannon.protecting_section)].")
			log_ares_antiair("[usr] Set AA to cover [html_encode(GLOB.almayer_aa_cannon.protecting_section)].")
			. = TRUE
		if("deactivate")
			GLOB.almayer_aa_cannon.protecting_section = ""
			message_admins("[key_name(usr)] has deactivated the AA cannon.")
			log_ares_antiair("[usr] Deactivated Anti Air systems.")
			. = TRUE

	add_fingerprint(usr)

// based on big copypasta from the orbital console
// the obvious improvement here is to port to nanoui but i'm too lazy to do that from the get go
/obj/structure/machinery/computer/aa_console/attack_hand(mob/user)
	if(..())
		return TRUE

	if(!skillcheck(user, SKILL_ENGINEER, SKILL_ENGINEER_TRAINED))
		to_chat(user, SPAN_WARNING("You have no idea how to use that console."))
		return TRUE

	if(!allowed(user))
		to_chat(user, SPAN_WARNING("You do not have access to this."))
		return TRUE

	tgui_interact(user)
	return TRUE

// Generic anti-air effect datum for dropship equipment
/datum/dropship_antiair
	var/name = "antiair effect"
	var/description = "This equipment has been affected by anti-air defenses."
	var/examine_text = "The skies are protected by an antiair defense system." // This is the examine text for the tile, think metal roofs etc
	var/duration = null // default: infinite duration unless set by effect type
	var/list/repair_steps = list()
	var/antiair_fire = FALSE // blocks weapon from firing
	var/antiair_reload = FALSE // blocks weapon from being reloaded
	var/antiair_destroy = FALSE // destroys the weapon after the duration
	var/list/tools = list("WELDER", "SCREWDRIVER", "WRENCH", "WIRECUTTERS", "CROWBAR", "MULTITOOL", "CABLE COIL")
	var/repairing = FALSE
	var/repair_step_index = 1
	var/effect_id = null // Unique identifier for this effect instance
	var/creation_time = null // So we know when it was applied
	var/repair_steps_count = 3 // Number of repair steps for this effect
	var/antiair_message = null // Custom message for when this antiair effect triggers during CAS, use PLANE as the placeholder for the DS name, it'll be converted into dropship/bird for marine/xeno

/datum/dropship_antiair/New()
	..()
	// Assign a unique effect_id on creation
	creation_time = world.time
	effect_id = "[src.type]-[creation_time]-[rand(1000,9999)]"
	// Generate a random repair_steps list of length repair_steps_count
	var/list/shuffled = shuffle(tools.Copy())
	repair_steps = list()
	for(var/step_index = 1, step_index <= repair_steps_count, step_index++)
		if(step_index > shuffled.len)
			shuffled = shuffle(tools.Copy())
		repair_steps += shuffled[step_index]

/datum/dropship_antiair/proc/get_antiair_message(ds_identifier)
	return antiair_message ? replacetext(antiair_message, "PLANE", ds_identifier) : null

/datum/dropship_antiair/proc/apply(obj/structure/dropship_equipment/target)
	target.damaged = TRUE

	// Automatically apply all antiair flags
	for(var/varname in vars)
		if(findtext(varname, "antiair_") && vars[varname] && (varname in target.vars))
			target.vars[varname] = TRUE

	if(duration > 0)
		spawn(duration)
			src.on_timeout(target)

/datum/dropship_antiair/proc/remove(obj/structure/dropship_equipment/target)
	// Reset antiair flags only if no remaining effects need them
	for(var/varname in target.vars)
		if(findtext(varname, "antiair_"))
			var/effect_stacked = FALSE
			// Check if any remaining effects still need this flag
			for(var/datum/dropship_antiair/remaining_effect in target.active_effects)
				if(remaining_effect.effect_id == src.effect_id)
					continue // Skip this effect since it's being removed
				if(findtext(varname, "antiair_") && (varname in remaining_effect.vars) && remaining_effect.vars[varname])
					effect_stacked = TRUE
					break
			// Only set to FALSE if no remaining effects need it
			if(!effect_stacked)
				target.vars[varname] = FALSE

	// Only set damaged to FALSE if no antiair effects remain
	if(!target.active_effects || target.active_effects.len == 0)
		target.damaged = FALSE

	// Clean up the effect if it was set to delete on timeout
	if(antiair_destroy)
		qdel(src)

/datum/dropship_antiair/proc/on_timeout(obj/structure/dropship_equipment/target)
	// Check if this effect is still active on the target (not removed by repairs)
	if(!(src in target.active_effects))
		return

	// Only destroy if the effect wasn't repaired (still has repair steps)
	if(antiair_destroy && length(src.repair_steps) > 0)
		// Effect timed out without being repaired - destroy the equipment
		target.visible_message(SPAN_WARNING("[target] crumbles into itself and falls apart. It's been destroyed!"))
		qdel(target)
	else
		// Effect was repaired or doesn't destroy on timeout, remove it properly
		target.remove_antiair_effect(src)

/datum/dropship_antiair/boiler_corrosion
	name = "Corrosive Acid Damage"
	description = "Corrosive acid is eating through the equipment!"
	examine_text = "A thick smog of acidic gas lingers above."
	duration = 1800
	antiair_reload = TRUE
	antiair_destroy = TRUE
	tools = list("WELDER", "SCREWDRIVER", "WRENCH", "WIRECUTTERS", "CROWBAR")
	antiair_message = "YOU HEAR THE PLANE VEER OFF COURSE AS IT FLIES THROUGH A CLOUD OF ACIDIC GAS!"
