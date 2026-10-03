/// Human-readable "empty <this>" descriptor per hardpoint slot.
GLOBAL_LIST_INIT(hardpoint_slot_labels, list(
	HDPT_PRIMARY = "primary weapon mount",
	HDPT_SECONDARY = "secondary weapon mount",
	HDPT_SUPPORT = "support module slot",
	HDPT_ARMOR = "armor mount",
	HDPT_SNOWPLOW = "snowplow mount",
	HDPT_TREADS = "tread mount",
	HDPT_WHEELS = "wheel mount",
	HDPT_TURRET = "turret mount",
	HDPT_ENGINE = "engine compartment",
	HDPT_FUEL_TANK = "fuel tank slot",
	HDPT_RADIATOR = "radiator mount",
	HDPT_BATTERY = "battery compartment",
	HDPT_HATCH = "hatch mount",
	HDPT_IFF_MODULE = "IFF module slot",
	HDPT_VISUAL_SENSORS = "visual sensor mount",
	HDPT_TURRET_RING = "turret ring mount",
	HDPT_AIR_FILTER = "air filter slot",
))

/**
 * Builds one bolded "An EMPTY <slot>." examine line per distinct slot with nothing occupying it.
 * Shared between a vehicle's top-level slots and a holder's nested weapon slots.
 *
 * Arguments:
 * * allowed_types = List of hardpoint types that could go here.
 * * installed_hardpoints = List of hardpoints actually mounted here right now.
 *
 * Returns:
 * * List of ready-to-append examine line strings, already SPAN_BOLDWARNING-wrapped.
 */
/proc/get_missing_hardpoint_slot_lines(list/allowed_types, list/installed_hardpoints)
	. = list()
	if(!length(allowed_types))
		return

	var/list/occupied_slots = list()
	for(var/obj/item/hardpoint/H in installed_hardpoints)
		occupied_slots[H.slot] = TRUE

	var/list/seen_slots = list()
	for(var/type in allowed_types)
		var/slot = initial(type:slot)
		if(!slot || (slot in seen_slots))
			continue
		seen_slots[slot] = TRUE
		if(occupied_slots[slot])
			continue
		if(slot == HDPT_SNOWPLOW)
			continue // purely optional, never treated as missing gear
		var/label = GLOB.hardpoint_slot_labels[slot] || "[slot] slot"
		. += SPAN_BOLDWARNING("An EMPTY [label].")

// Returns all hardpoints that are attached to the vehicle, including ones held by holder hardpoints (e.g. turrets)
/obj/vehicle/multitile/proc/get_hardpoints_copy()
	var/list/all_hardpoints = hardpoints.Copy()
	for(var/obj/item/hardpoint/holder/H in all_hardpoints)
		if(!H.hardpoints)
			continue
		all_hardpoints += H.hardpoints.Copy()

	return all_hardpoints

/**
 * Every in-place-fixable wound across every hardpoint whose current repair step matches tool.
 *
 * Returns:
 * * An assoc list, "Fix <name> (<hardpoint>)" -> list(hardpoint, family_type). Empty if none match.
 */
/obj/vehicle/multitile/proc/get_wound_fix_candidates(obj/item/tool)
	. = list()
	for(var/obj/item/hardpoint/H in get_hardpoints_copy())
		for(var/family_type in H.wound_tiers)
			var/list/tier_data = H.get_wound_tier_data(family_type)
			if(!tier_data || tier_data["unmount_required"])
				continue
			var/list/steps = tier_data["repair_steps"]
			if(!length(steps))
				continue
			var/current_step = H.get_wound_repair_step(family_type)
			if(current_step >= length(steps))
				continue
			if(!wound_repair_step_matches_tool(steps[current_step + 1], tool))
				continue
			.["Fix [tier_data["wound_name"]] ([H.name])"] = list(H, family_type)

/**
 * Wrench/welder half of the wound-fix dispatch. Fixes the wound if there's one match, asks via
 * tgui_input_list() if there's more than one. Falls through to handle_repairs() if there are none.
 *
 * Returns:
 * * TRUE if a wound-fix was offered or attempted. FALSE if there was nothing to offer.
 */
/obj/vehicle/multitile/proc/try_fix_wound_with_tool(obj/item/tool, mob/living/user)
	var/list/candidates = get_wound_fix_candidates(tool)
	if(!length(candidates))
		return FALSE

	var/list/labels = list()
	for(var/label in candidates)
		labels += label

	var/chosen_label = length(labels) == 1 ? labels[1] : tgui_input_list(user, "What would you like to fix?", "Tank Repair", labels + list("Cancel"))
	if(!chosen_label || chosen_label == "Cancel")
		return TRUE

	// Re-validate since tgui_input_list() can suspend for a while awaiting input.
	if(QDELETED(user) || user.is_mob_incapacitated() || get_dist(src, user) > 2 || tool != user.get_active_hand())
		return TRUE
	var/list/fix_data = candidates[chosen_label]
	if(!fix_data)
		return TRUE
	var/obj/item/hardpoint/target_hardpoint = fix_data[1]
	target_hardpoint.fix_wound(user, tool, fix_data[2])
	return TRUE

/**
 * Every in-place-fixable Hull wound whose current repair step matches tool. Mirrors
 * get_wound_fix_candidates() but reads hull_wound_tiers instead of hardpoints.
 *
 * Returns:
 * * An assoc list, "Fix <wound name> (Hull)" -> a family_type path. Empty if none match.
 */
/obj/vehicle/multitile/proc/get_hull_wound_fix_candidates(obj/item/tool)
	. = list()
	for(var/family_type in hull_wound_tiers)
		var/tier = hull_wound_tiers[family_type]
		var/datum/hardpoint_wound_family/family = GLOB.hardpoint_wound_families_by_type[family_type]
		if(!family || tier > length(family.tiers))
			continue
		var/list/tier_data = family.tiers[tier]
		var/list/steps = tier_data["repair_steps"]
		if(!length(steps))
			continue
		var/current_step = get_hull_wound_repair_step(family_type)
		if(current_step >= length(steps))
			continue
		if(!wound_repair_step_matches_tool(steps[current_step + 1], tool))
			continue
		.["Fix [tier_data["wound_name"]] (Hull)"] = family_type

/**
 * Wrench/welder half of the Hull wound-fix dispatch. Fixes the Hull wound if tool matches, or asks
 * via tgui_input_list() if more than one applies. Falls through to handle_repairs() otherwise.
 *
 * Returns:
 * * TRUE if a wound-fix was offered or attempted. FALSE if there was nothing to offer.
 */
/obj/vehicle/multitile/proc/try_fix_hull_wound_with_tool(obj/item/tool, mob/living/user)
	var/list/candidates = get_hull_wound_fix_candidates(tool)
	if(!length(candidates))
		return FALSE

	var/list/labels = list()
	for(var/label in candidates)
		labels += label

	var/chosen_label = length(labels) == 1 ? labels[1] : tgui_input_list(user, "What would you like to fix?", "Tank Repair", labels + list("Cancel"))
	if(!chosen_label || chosen_label == "Cancel")
		return TRUE

	if(QDELETED(user) || user.is_mob_incapacitated() || get_dist(src, user) > 2 || tool != user.get_active_hand())
		return TRUE
	var/family_type = candidates[chosen_label]
	if(!family_type)
		return TRUE
	fix_hull_wound(user, tool, family_type)
	return TRUE

/**
 * Crowbar half of the wound-fix dispatch. Merges any crowbar-fixable wound options into the same
 * picker as uninstall_hardpoint(), instead of guessing which one the player wants.
 *
 * Returns:
 * * TRUE if this handled the interaction. FALSE if there was no wound-fix option to merge in.
 */
/obj/vehicle/multitile/proc/try_fix_or_remove_with_crowbar(obj/item/tool, mob/living/user)
	var/list/candidates = get_wound_fix_candidates(tool)
	if(!length(candidates))
		return FALSE

	var/list/options = candidates.Copy()
	for(var/obj/item/hardpoint/H in get_hardpoints_copy())
		if(H.w_class == SIZE_MASSIVE || istype(H, /obj/item/hardpoint/special))
			continue
		options["Remove [H.name]"] = H

	var/list/labels = list()
	for(var/label in options)
		labels += label
	var/chosen_label = tgui_input_list(user, "What would you like to do with \the [tool]?", "Tank Repair", labels + list("Cancel"))
	if(!chosen_label || chosen_label == "Cancel")
		return TRUE

	if(QDELETED(user) || user.is_mob_incapacitated() || get_dist(src, user) > 2 || tool != user.get_active_hand())
		return TRUE
	var/chosen_value = options[chosen_label]
	if(istype(chosen_value, /obj/item/hardpoint))
		uninstall_hardpoint(tool, user, chosen_value)
	else if(islist(chosen_value))
		var/list/fix_data = chosen_value
		var/obj/item/hardpoint/target_hardpoint = fix_data[1]
		target_hardpoint.fix_wound(user, tool, fix_data[2])
	return TRUE

//Returns all activatable hardpoints
/obj/vehicle/multitile/proc/get_activatable_hardpoints(seat)
	var/list/hps = list()
	for(var/obj/item/hardpoint/H in hardpoints)
		if(istype(H, /obj/item/hardpoint/holder))
			var/obj/item/hardpoint/holder/HP = H
			if(HP.hardpoints)
				hps += HP.get_activatable_hardpoints(seat)
		if(!H.is_activatable() || seat && seat != H.allowed_seat)
			continue
		hps += H
	return hps

/// The first activatable secondary mounted on this vehicle (or its turret holder), eligible to be slaved to the driver.
/obj/vehicle/multitile/proc/get_slavable_secondary()
	var/obj/item/hardpoint/holder/tank_turret/turret = locate() in hardpoints
	var/list/search_list = turret ? turret.hardpoints : hardpoints
	for(var/obj/item/hardpoint/secondary/candidate in search_list)
		if(!candidate.is_activatable())
			continue
		return candidate
	return null

/// The first hardpoint on this vehicle (or its turret holder) that loads star shells/star shell packets directly.
/obj/vehicle/multitile/proc/get_starshell_hardpoint()
	var/obj/item/hardpoint/holder/tank_turret/turret = locate() in hardpoints
	var/list/search_list = turret ? turret.hardpoints : hardpoints
	for(var/obj/item/hardpoint/candidate in search_list)
		if(candidate.uses_starshell_ammo)
			return candidate
	return null

//Returns hardpoints that use ammunition
/obj/vehicle/multitile/proc/get_hardpoints_with_ammo(seat)
	var/list/hps = list()
	for(var/obj/item/hardpoint/H in hardpoints)
		if(istype(H, /obj/item/hardpoint/holder))
			var/obj/item/hardpoint/holder/HP = H
			if(HP.hardpoints)
				hps += HP.get_hardpoints_with_ammo(seat)
		if(!H.ammo_type || seat && seat != H.allowed_seat)
			continue
		hps += H
	return hps

/**
 * Whether this vehicle has a Visual Sensors slot at all. FALSE by default, TRUE on the tank.
 */
/obj/vehicle/multitile/proc/supports_visual_sensors()
	return FALSE

/**
 * Whether this vehicle's gunner gets the Ctrl+Click rangefinder feature. FALSE by default, TRUE
 * on the tank only.
 */
/obj/vehicle/multitile/proc/has_gunner_rangefinder()
	return FALSE

/**
 * Applies or clears the Visual Sensors vision-impair overlay on a seated crew member, mirroring
 * welding goggles. A damaged sensor also layers in a red vignette and a gaussian blur filter.
 *
 * Arguments:
 * * seated_mob = The buckled driver/gunner/passenger to update.
 */
/obj/vehicle/multitile/proc/update_visual_sensor_overlay(mob/seated_mob)
	if(!seated_mob?.client)
		return

	var/obj/item/hardpoint/visual_sensors/sensors = locate() in get_hardpoints_copy()
	var/severity
	if(sensors)
		severity = sensors.get_overlay_severity()
	else if(supports_visual_sensors())
		// No sensor installed despite having the slot for one, worst-case impair.
		severity = VISION_IMPAIR_ULTRA
	else
		// This vehicle type has no Visual Sensors slot at all, nothing to be missing.
		severity = VISION_IMPAIR_NONE

	if(severity <= VISION_IMPAIR_NONE)
		clear_visual_sensor_overlay(seated_mob)
	else
		var/atom/movable/plane_master_controller/game_plane_master_controller = seated_mob.hud_used?.plane_master_controllers[PLANE_MASTERS_GAME]
		seated_mob.overlay_fullscreen("visual_sensors", /atom/movable/screen/fullscreen/impaired, severity)
		seated_mob.overlay_fullscreen("visual_sensors_oxy", /atom/movable/screen/fullscreen/oxy, severity)
		game_plane_master_controller?.add_filter("visual_sensors_blur", 1, gauss_blur_filter(clamp(severity * 0.5, 0.6, 3)))

/**
 * Strips all Visual Sensors vision effects off M, so unbuckle handlers don't leave them stuck on
 * a mob who already left the seat.
 */
/obj/vehicle/multitile/proc/clear_visual_sensor_overlay(mob/M)
	M.clear_fullscreen("visual_sensors")
	M.clear_fullscreen("visual_sensors_oxy")
	var/atom/movable/plane_master_controller/game_plane_master_controller = M.hud_used?.plane_master_controllers[PLANE_MASTERS_GAME]
	game_plane_master_controller?.remove_filter("visual_sensors_blur")

// Returns a hardpoint by its name
/obj/vehicle/multitile/proc/find_hardpoint(name)
	for(var/obj/item/hardpoint/H in hardpoints)
		if(istype(H, /obj/item/hardpoint/holder))
			var/obj/item/hardpoint/holder/HP = H

			var/obj/item/hardpoint/nested_hp = HP.find_hardpoint(name)
			if(nested_hp)
				return nested_hp

		if(H.name == name)
			return H
	return null

//What to do if all ofthe installed modules have been broken
/obj/vehicle/multitile/proc/handle_all_modules_broken()
	update_minimap_icon(TRUE)
	return

/obj/vehicle/multitile/proc/deactivate_all_hardpoints()
	var/list/hps = get_activatable_hardpoints()
	for(var/obj/item/hardpoint/H in hps)
		H.deactivate()

/obj/vehicle/multitile/proc/remove_all_players()
	return

//Putting on hardpoints
//Similar to repairing stuff, down to the time delay
/obj/vehicle/multitile/proc/install_hardpoint(obj/item/O, mob/user)
	if(!skillcheck(user, SKILL_ENGINEER, SKILL_ENGINEER_TRAINED))
		to_chat(user, SPAN_WARNING("You don't know what to do with [O] on \the [src]."))
		return

	var/obj/item/hardpoint/HP = O
	if(ispowerclamp(O))
		var/obj/item/powerloader_clamp/PC = O
		HP = PC.loaded

	for(var/obj/item/hardpoint/holder/H in hardpoints)
		// Attempt to install on holder hardpoints first
		if(H.can_install(HP))
			H.install(HP, user)
			update_icon()
			return

	if(health < initial(health) * 0.75)
		to_chat(user, SPAN_WARNING("All the mounting points on \the [src] are broken!"))
		return

	if(LAZYLEN(hardpoints))
		for(var/obj/item/hardpoint/H in hardpoints)
			if(HP.slot == H.slot)
				to_chat(user, SPAN_WARNING("There is already something installed there!"))
				return

	if(!(HP.type in hardpoints_allowed))
		to_chat(user, SPAN_WARNING("You don't know what to do with [HP] on \the [src]."))
		return

	user.visible_message(SPAN_NOTICE("[user] begins installing \the [HP] on the [HP.slot] hardpoint slot of \the [src]."),
		SPAN_NOTICE("You begin installing \the [HP] on the [HP.slot] hardpoint slot of \the [src]."))

	var/num_delays = 1

	switch(HP.slot)
		if(HDPT_PRIMARY)
			num_delays = 5
		if(HDPT_SECONDARY)
			num_delays = 3
		if(HDPT_SUPPORT)
			num_delays = 2
		if(HDPT_ARMOR, HDPT_SNOWPLOW)
			num_delays = 10
		if(HDPT_TREADS, HDPT_WHEELS)
			num_delays = 7

	if(!do_after(user, 30*num_delays * user.get_skill_duration_multiplier(SKILL_ENGINEER), INTERRUPT_ALL, BUSY_ICON_FRIENDLY, numticks = num_delays))
		user.visible_message(SPAN_WARNING("[user] stops installing \the [HP] on \the [src]."), SPAN_WARNING("You stop installing \the [HP] on \the [src]."))
		return

	//check to prevent putting two modules on same slot
	for(var/obj/item/hardpoint/H in hardpoints)
		if(HP.slot == H.slot)
			to_chat(user, SPAN_WARNING("There is already something installed there!"))
			return

	user.visible_message(SPAN_NOTICE("[user] installs \the [HP] on \the [src]."), SPAN_NOTICE("You install \the [HP] on \the [src]."))

	if(ispowerclamp(O))
		var/obj/item/powerloader_clamp/PC = O
		PC.loaded.forceMove(src)
		to_chat(user, SPAN_NOTICE("You install \the [PC.loaded] on \the [src] with \the [PC]."))
		PC.loaded = null
		playsound(loc, 'sound/machines/hydraulics_2.ogg', 40, 1)
		PC.update_icon()
	else
		user.temp_drop_inv_item(HP, 0)

	add_hardpoint(HP, user)

/**
 * User-orientated proc for taking off hardpoints. Similar to install_hardpoint().
 *
 * Arguments:
 * * O = The tool used (crowbar, or a powerloader clamp).
 * * user = Whoever's removing it.
 * * preselected = Optional, skips the "Select a hardpoint to remove" picker and acts on this one.
 */
/obj/vehicle/multitile/proc/uninstall_hardpoint(obj/item/O, mob/user, obj/item/hardpoint/preselected)
	if(!skillcheck(user, SKILL_ENGINEER, SKILL_ENGINEER_TRAINED))
		to_chat(user, SPAN_WARNING("You don't know what to do with \the [O] on \the [src]."))
		return

	if(ispowerclamp(O))
		var/obj/item/powerloader_clamp/PC = O
		if(!PC.linked_powerloader || PC.loaded)
			return

	var/obj/item/hardpoint/old = preselected
	if(!old)
		var/list/hps = list()
		for(var/obj/item/hardpoint/H in get_hardpoints_copy())
			// Only allow uninstalls of massive hardpoints when using powerloaders
			if(H.w_class == SIZE_MASSIVE && !ispowerclamp(O) || H.w_class <= SIZE_HUGE && ispowerclamp(O) || istype(H, /obj/item/hardpoint/special))
				continue
			hps += H

		var/chosen_hp = tgui_input_list(usr, "Select a hardpoint to remove", "Hardpoint Removal", (hps + "Cancel"))
		if(chosen_hp == "Cancel" || !chosen_hp || (get_dist(src, user) > 2)) //get_dist uses 2 because the vehicle is 3x3
			return
		old = chosen_hp

	if(!old)
		to_chat(user, SPAN_WARNING("There is nothing installed there."))
		return

	if(!old.can_be_removed(user))
		return
	// It's in a holder
	if(!(old in hardpoints))
		for(var/obj/item/hardpoint/holder/H in hardpoints)
			if(old in H.hardpoints)
				H.uninstall(old, user)
				update_icon()
				return

	user.visible_message(SPAN_NOTICE("[user] begins removing [old] on the [old.slot] hardpoint slot on \the [src]."),
		SPAN_NOTICE("You begin removing [old] on the [old.slot] hardpoint slot on \the [src]."))

	var/num_delays = 1

	switch(old.slot)
		if(HDPT_PRIMARY)
			num_delays = 5
		if(HDPT_SECONDARY)
			num_delays = 3
		if(HDPT_SUPPORT)
			num_delays = 2
		if(HDPT_ARMOR, HDPT_SNOWPLOW)
			num_delays = 10
		if(HDPT_TREADS)
			num_delays = 7

	if(!do_after(user, 30*num_delays * user.get_skill_duration_multiplier(SKILL_ENGINEER), INTERRUPT_ALL, BUSY_ICON_FRIENDLY, numticks = num_delays, target_flags = INTERRUPT_DIFF_LOC, target = old))
		user.visible_message(SPAN_WARNING("[user] stops removing \the [old] on \the [src]."), SPAN_WARNING("You stop removing \the [old] on \the [src]."))
		return

	user.visible_message(SPAN_NOTICE("[user] removes \the [old] on \the [src]."), SPAN_NOTICE("You remove \the [old] on \the [src]."))

	remove_hardpoint(old, user)

	if(QDELETED(old))
		return

	if(ispowerclamp(O))
		var/obj/item/powerloader_clamp/PC = O
		PC.grab_object(user, old, "vehicle_module")
		PC.loaded.update_icon()

	if(old.slot == HDPT_TREADS && clamped)
		detach_clamp(user)

//General proc for putting on hardpoints
//ALWAYS CALL THIS WHEN ATTACHING HARDPOINTS
/obj/vehicle/multitile/proc/add_hardpoint(obj/item/hardpoint/HP, mob/user)
	HP.owner = src
	HP.forceMove(src)
	hardpoints += HP

	HP.on_install(src)
	HP.rotate(turning_angle(HP.dir, dir))

	update_minimap_icon()
	update_icon()
	ensure_active_hardpoint(VEHICLE_DRIVER)
	ensure_active_hardpoint(VEHICLE_GUNNER)

//General proc for taking off hardpoints
//ALWAYS CALL THIS WHEN REMOVING HARDPOINTS
/obj/vehicle/multitile/proc/remove_hardpoint(obj/item/hardpoint/old, mob/user)
	if(!(old in hardpoints))
		return

	if(user)
		old.forceMove(get_turf(user))
	else
		old.forceMove(get_turf(src))

	old.on_uninstall(src)
	old.reset_rotation()
	hardpoints -= old
	old.owner = null
	refresh_hardpoint_actions()
	ensure_active_hardpoint(VEHICLE_DRIVER)
	ensure_active_hardpoint(VEHICLE_GUNNER)

	if(old.health <= 0 && !old.gc_destroyed) // Make sure it's not already being deleted.
		visible_message(SPAN_WARNING("\The [src] disintegrates into useless pile of scrap under the damage it suffered."))
		qdel(old)

	// Register the dropped hardpoint as an on-top object too, so it doesn't get left behind and
	// rendered under the hull's sprite next time the tank moves.
	if(!QDELETED(old))
		var/obj/vehicle/multitile/tank/tank_self = istype(src, /obj/vehicle/multitile/tank) ? src : null
		tank_self?.obj_mark_on_top(old)

	update_icon()
