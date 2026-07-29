/// Finds the vehicle this mob is seated in, if any. Reports why to src on failure.
/mob/living/carbon/proc/get_seated_vehicle()
	if(!istype(buckled, /obj/structure/bed/chair/comfy/vehicle))
		to_chat(src, SPAN_WARNING("You're not seated in a vehicle."))
		return null

	var/obj/structure/bed/chair/comfy/vehicle/seat_chair = buckled
	var/obj/vehicle/multitile/seated_vehicle = seat_chair.vehicle
	if(!istype(seated_vehicle))
		to_chat(src, SPAN_WARNING("You're not seated in a vehicle."))
		return null

	return seated_vehicle

/// Finds the tank this mob is seated in, if any. Reports why to src on failure.
/mob/living/carbon/proc/get_seated_tank_vehicle()
	if(!istype(buckled, /obj/structure/bed/chair/comfy/vehicle))
		to_chat(src, SPAN_WARNING("You're not seated in a vehicle."))
		return null

	var/obj/structure/bed/chair/comfy/vehicle/seat_chair = buckled
	var/obj/vehicle/multitile/tank/tank_vehicle = seat_chair.vehicle
	if(!istype(tank_vehicle))
		to_chat(src, SPAN_WARNING("You're not seated in a tank."))
		return null

	return tank_vehicle

/// Finds the tank_turret this mob is seated behind, if any. Reports why to src on failure.
/mob/living/carbon/proc/get_seated_tank_turret()
	var/obj/vehicle/multitile/tank/tank_vehicle = get_seated_tank_vehicle()
	if(!tank_vehicle)
		return null

	var/obj/item/hardpoint/holder/tank_turret/turret
	for(var/obj/item/hardpoint/holder/tank_turret/TT in tank_vehicle.hardpoints)
		turret = TT
		break
	if(!turret)
		to_chat(src, SPAN_WARNING("This tank has no turret installed."))
		return null

	return turret

/// Debug tool for live-tuning weapon sprite alignment on the vehicle you're seated in.
/mob/living/carbon/verb/set_weapon_rotation_pivot()
	set name = "Set Weapon Rotation Pivot"
	set category = "Debug"
	set desc = "Live-tunes the rotation_pivot of a weapon mounted on the vehicle you're seated in."

	if(!check_rights(R_DEBUG))
		return

	var/obj/vehicle/multitile/seated_vehicle = get_seated_vehicle()
	if(!seated_vehicle)
		return

	var/datum/tank_pivot_tuner/tuner = new
	tuner.vehicle = seated_vehicle
	var/list/candidates = tuner.get_weapon_list()
	if(!length(candidates))
		to_chat(src, SPAN_WARNING("This vehicle has no rotating weapons mounted."))
		qdel(tuner)
		return

	tuner.weapon = candidates[1]
	tuner.tgui_interact(src)

/datum/tank_pivot_tuner
	var/obj/vehicle/multitile/vehicle
	var/obj/item/hardpoint/weapon

/datum/tank_pivot_tuner/ui_state(mob/user)
	return GLOB.always_state

/datum/tank_pivot_tuner/ui_close(mob/user)
	. = ..()
	qdel(src)

/datum/tank_pivot_tuner/tgui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "TankPivotTuner")
		ui.open()
		ui.set_autoupdate(TRUE)

/// The tank_turret holder mounted on this tuner's vehicle, if any.
/datum/tank_pivot_tuner/proc/get_turret()
	return locate(/obj/item/hardpoint/holder/tank_turret) in vehicle.hardpoints

/// Every weapon this tuner can select: a turret's own nested hardpoints, or the vehicle's own rotating top-level hardpoints if it has no turret.
/datum/tank_pivot_tuner/proc/get_weapon_list()
	var/obj/item/hardpoint/holder/tank_turret/turret = get_turret()
	if(turret)
		return turret.hardpoints.Copy()

	var/list/candidates = list()
	for(var/obj/item/hardpoint/H in vehicle.hardpoints)
		if(H.traverse_arc)
			candidates += H
	return candidates

/// The nearest of the 8 cardinal/diagonal dir constants to whatever drives the selected weapon's rotation_pivot/gimbal_pivot.
/datum/tank_pivot_tuner/proc/get_rotation_octant()
	var/obj/item/hardpoint/holder/tank_turret/turret = get_turret()
	if(turret)
		return angle_to_dir(turret.current_angle)
	if(QDELETED(weapon))
		return SOUTH
	return angle_to_dir(weapon.get_rotation_owner().current_angle)

/// The dir key px_offsets is looked up under for the selected weapon: its own loc's dir.
/datum/tank_pivot_tuner/proc/get_offset_dir()
	if(QDELETED(weapon) || !weapon.loc)
		return SOUTH
	var/atom/container = weapon.loc
	return container.dir

/datum/tank_pivot_tuner/ui_data(mob/user)
	. = list()
	if(QDELETED(vehicle))
		return

	var/rotation_octant = get_rotation_octant()
	.["dir_name"] = dir2text(rotation_octant)

	var/rotation_dir_key = "[rotation_octant]"
	var/list/weapon_list = list()
	for(var/obj/item/hardpoint/H in get_weapon_list())
		var/list/pivot = LAZYACCESS(H.rotation_pivot, rotation_dir_key) || list(0, 0)
		weapon_list += list(list(
			"ref" = "\ref[H]",
			"name" = H.name,
			"pivot_x" = pivot[1],
			"pivot_y" = pivot[2],
			"selected" = (H == weapon),
		))
	.["weapons"] = weapon_list

	if(QDELETED(weapon))
		return
	var/list/selected_pivot = LAZYACCESS(weapon.rotation_pivot, rotation_dir_key) || list(0, 0)
	.["tuning_label"] = "facing: [dir2text(rotation_octant)]"
	.["selected_name"] = weapon.name
	.["pivot_x"] = selected_pivot[1]
	.["pivot_y"] = selected_pivot[2]

	var/offset_dir_key = "[get_offset_dir()]"
	var/list/selected_offset = LAZYACCESS(weapon.px_offsets, offset_dir_key) || list(0, 0)
	.["offset_x"] = selected_offset[1]
	.["offset_y"] = selected_offset[2]

	.["is_gimballed"] = weapon.self_gimballed
	if(weapon.self_gimballed)
		var/list/selected_gimbal_pivot = LAZYACCESS(weapon.gimbal_pivot, rotation_dir_key) || list(0, 0)
		.["gimbal_pivot_x"] = selected_gimbal_pivot[1]
		.["gimbal_pivot_y"] = selected_gimbal_pivot[2]

/datum/tank_pivot_tuner/ui_act(action, list/params, datum/tgui/ui)
	. = ..()
	if(.)
		return
	if(QDELETED(vehicle))
		return

	switch(action)
		if("select_weapon")
			var/obj/item/hardpoint/H = locate(params["ref"]) in get_weapon_list()
			if(!H)
				return
			weapon = H
			. = TRUE
		if("adjust")
			if(QDELETED(weapon))
				return
			var/axis = params["axis"]
			var/delta = params["delta"]
			var/target = params["target"]
			if(!delta || !(axis == "x" || axis == "y") || !(target == "rotation" || target == "gimbal" || target == "offset"))
				return
			if(target == "gimbal" && !weapon.self_gimballed)
				return

			var/list/pivot_list
			var/dir_key
			switch(target)
				if("gimbal")
					pivot_list = weapon.gimbal_pivot
					dir_key = "[get_rotation_octant()]"
				if("offset")
					pivot_list = weapon.px_offsets
					dir_key = "[get_offset_dir()]"
				else
					pivot_list = weapon.rotation_pivot
					dir_key = "[get_rotation_octant()]"
			var/list/pivot = LAZYACCESS(pivot_list, dir_key) || list(0, 0)
			var/list/new_pivot = list(pivot[1], pivot[2])
			if(axis == "x")
				new_pivot[1] = clamp(pivot[1] + delta, -200, 200)
			else
				new_pivot[2] = clamp(pivot[2] + delta, -200, 200)
			LAZYSET(pivot_list, dir_key, new_pivot)
			switch(target)
				if("gimbal")
					weapon.gimbal_pivot = pivot_list
				if("offset")
					weapon.px_offsets = pivot_list
				else
					weapon.rotation_pivot = pivot_list

			vehicle.update_icon()
			. = TRUE

// instantly swaps whichever primary/secondary weapon is mounted on the tank turret

/mob/living/carbon/verb/cycle_tank_weapon_hardpoint()
	set name = "Cycle Tank Weapon Hardpoint"
	set category = "Debug"
	set desc = "Swaps the turret's primary/secondary weapon (whichever slot the next type in the cycle belongs to) to the next available type."

	if(!check_rights(R_DEBUG))
		return

	var/obj/item/hardpoint/holder/tank_turret/turret = get_seated_tank_turret()
	if(!turret)
		return

	if(!LAZYLEN(turret.accepted_hardpoints))
		to_chat(src, SPAN_WARNING("This turret doesn't accept any hardpoints."))
		return

	turret.debug_cycle_index = (turret.debug_cycle_index % length(turret.accepted_hardpoints)) + 1
	var/next_type = turret.accepted_hardpoints[turret.debug_cycle_index]

	var/obj/item/hardpoint/next_hardpoint = new next_type()

	var/obj/item/hardpoint/existing
	for(var/obj/item/hardpoint/H in turret.hardpoints)
		if(H.slot == next_hardpoint.slot)
			existing = H
			break
	if(existing)
		turret.remove_hardpoint(existing, get_turf(turret))
		qdel(existing)

	turret.add_hardpoint(next_hardpoint)
	turret.owner.update_icon()

	to_chat(src, SPAN_NOTICE("Installed [next_hardpoint.name] on the turret ([turret.debug_cycle_index]/[length(turret.accepted_hardpoints)])."))

// Full visual hardpoint editor. Swap/remove hardpoints and set health/wound tiers directly.
/mob/living/carbon/verb/debug_edit_tank_hardpoints()
	set name = "Edit Tank Hardpoints"
	set category = "Debug"
	set desc = "Opens a visual editor for every hardpoint slot on the tank you're seated in - install/remove any hardpoint, and set the selected one's health and wounds directly."

	if(!check_rights(R_DEBUG))
		return

	var/obj/vehicle/multitile/tank/tank_vehicle = get_seated_tank_vehicle()
	if(!tank_vehicle)
		return

	var/datum/tank_hardpoint_debugger/debugger = new
	debugger.vehicle = tank_vehicle
	debugger.tgui_interact(src)

/datum/tank_hardpoint_debugger
	var/obj/vehicle/multitile/tank/vehicle
	var/obj/item/hardpoint/selected

/datum/tank_hardpoint_debugger/ui_state(mob/user)
	return GLOB.always_state

/datum/tank_hardpoint_debugger/ui_close(mob/user)
	. = ..()
	qdel(src)

/datum/tank_hardpoint_debugger/tgui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "TankHardpointDebugger")
		ui.open()
		ui.set_autoupdate(TRUE)

/// The turret holder currently installed on this vehicle, if any.
/datum/tank_hardpoint_debugger/proc/get_turret()
	RETURN_TYPE(/obj/item/hardpoint/holder/tank_turret)
	for(var/obj/item/hardpoint/holder/tank_turret/turret in vehicle.hardpoints)
		return turret
	return null

/**
 * Builds one row per possible hardpoint slot, filled or not. Each row carries a "location" so
 * ui_act() knows which object to call.
 */
/datum/tank_hardpoint_debugger/proc/build_slot_data()
	var/list/slots_by_id = list() // slot string -> row list, dedups multiple candidate types sharing a slot
	var/obj/item/hardpoint/holder/tank_turret/turret = get_turret()

	add_slot_candidates(slots_by_id, vehicle.hardpoints_allowed, vehicle.hardpoints, "vehicle")
	if(turret)
		add_slot_candidates(slots_by_id, turret.accepted_hardpoints, turret.hardpoints, "turret")

	// Peel off just the row values, in insertion order, for the frontend's .map() to consume.
	var/list/rows = list()
	for(var/slot_key in slots_by_id)
		rows += list(slots_by_id[slot_key])
	return rows

/// Populates slots_by_id in place from one candidate_types list and its installed hardpoints.
/datum/tank_hardpoint_debugger/proc/add_slot_candidates(list/slots_by_id, list/candidate_types, list/installed_hardpoints, location)
	for(var/candidate_type in candidate_types)
		var/candidate_slot = initial(candidate_type:slot)
		var/list/row = slots_by_id[candidate_slot]
		if(!row)
			row = list("slot" = candidate_slot, "location" = location, "installed" = null, "candidates" = list())
			slots_by_id[candidate_slot] = row
		row["candidates"] += list(list("type" = "[candidate_type]", "name" = initial(candidate_type:name)))

	for(var/obj/item/hardpoint/H in installed_hardpoints)
		var/list/row = slots_by_id[H.slot]
		if(!row)
			continue
		row["installed"] = list(
			"ref" = "\ref[H]",
			"name" = H.name,
			"health_pct" = H.health <= 0 ? 0 : round(H.get_integrity_percent()),
			"selected" = (H == selected),
		)

/datum/tank_hardpoint_debugger/ui_data(mob/user)
	. = list()
	if(QDELETED(vehicle))
		return

	.["slots"] = build_slot_data()

	.["hull"] = list(
		"health" = vehicle.health,
		"max_health" = initial(vehicle.health),
		"wounds" = build_wound_rows(GLOB.hardpoint_wound_families_by_slot[WOUND_SLOT_HULL], vehicle.hull_wound_tiers),
	)

	if(QDELETED(selected))
		return

	.["selected"] = list(
		"ref" = "\ref[selected]",
		"name" = selected.name,
		"slot" = selected.slot,
		"health" = selected.health,
		"max_health" = initial(selected.health),
		"wounds" = build_wound_rows(GLOB.hardpoint_wound_families_by_slot[selected.get_wound_family_slot()], selected.wound_tiers),
	)

/// Builds the wound family rows ui_data() sends for one slot's tiers.
/datum/tank_hardpoint_debugger/proc/build_wound_rows(list/candidate_families, list/current_tiers)
	var/list/wound_list = list()
	for(var/datum/hardpoint_wound_family/family in candidate_families)
		var/list/tier_names = list()
		for(var/list/tier_data in family.tiers)
			tier_names += tier_data["wound_name"]
		wound_list += list(list(
			"family_type" = "[family.type]",
			"family_label" = family.get_display_label(),
			"current_tier" = LAZYACCESS(current_tiers, family.type) || 0,
			"max_tier" = length(family.tiers),
			"tier_names" = tier_names,
		))
	return wound_list

/datum/tank_hardpoint_debugger/ui_act(action, list/params, datum/tgui/ui)
	. = ..()
	if(.)
		return
	if(QDELETED(vehicle))
		return

	switch(action)
		if("select_hardpoint")
			var/obj/item/hardpoint/H = locate(params["ref"]) in vehicle.get_hardpoints_copy()
			selected = H
			. = TRUE

		if("install")
			var/hardpoint_type = text2path(params["type"])
			if(!ispath(hardpoint_type, /obj/item/hardpoint))
				return
			var/target_slot = params["slot"]
			var/new_hardpoint = new hardpoint_type()
			if(params["location"] == "turret")
				var/obj/item/hardpoint/holder/tank_turret/turret = get_turret()
				if(!turret)
					qdel(new_hardpoint)
					return
				remove_existing_in_slot(turret.hardpoints, target_slot, turret)
				turret.add_hardpoint(new_hardpoint)
			else
				remove_existing_in_slot(vehicle.hardpoints, target_slot, vehicle)
				vehicle.add_hardpoint(new_hardpoint)
			selected = new_hardpoint
			. = TRUE

		if("remove")
			var/obj/item/hardpoint/H = locate(params["ref"]) in vehicle.get_hardpoints_copy()
			if(!H)
				return
			if(H == selected)
				selected = null
			if(H in vehicle.hardpoints)
				vehicle.remove_hardpoint(H)
			else
				var/obj/item/hardpoint/holder/tank_turret/turret = get_turret()
				turret?.remove_hardpoint(H)
			qdel(H)
			. = TRUE

		if("set_health")
			if(QDELETED(selected) || !isnum(params["value"]))
				return
			var/new_health = clamp(round(params["value"]), 0, initial(selected.health))
			var/was_destroyed = selected.health <= 0
			selected.health = new_health
			if(new_health <= 0 && !was_destroyed)
				selected.on_destroy()
			. = TRUE

		if("set_wound_tier")
			if(QDELETED(selected) || !isnum(params["tier"]))
				return
			var/family_type = text2path(params["family_type"])
			var/datum/hardpoint_wound_family/family = GLOB.hardpoint_wound_families_by_type[family_type]
			// Validate against get_wound_family_slot(), not the raw install slot, since some hardpoints
			// override it to roll their own dedicated wound families.
			if(!family || family.part_slot != selected.get_wound_family_slot())
				return
			var/current_tier = LAZYACCESS(selected.wound_tiers, family_type) || 0
			var/new_tier = clamp(round(params["tier"]), 0, length(family.tiers))
			if(new_tier <= 0)
				LAZYREMOVE(selected.wound_tiers, family_type)
			else
				LAZYSET(selected.wound_tiers, family_type, new_tier)
			// Bypasses try_advance_wound_family(), so play the wound-gain cue manually on an increase.
			// No attacker to aim shrapnel toward, so it just bursts in every direction.
			if(new_tier > current_tier)
				play_wound_gain_effects(selected, family.damage_type, null)
			selected.recalculate_wound_effects()
			. = TRUE

		if("set_hull_health")
			if(!isnum(params["value"]))
				return
			vehicle.health = clamp(round(params["value"]), 0, initial(vehicle.health))
			. = TRUE

		if("set_hull_wound_tier")
			if(!isnum(params["tier"]))
				return
			var/family_type = text2path(params["family_type"])
			var/datum/hardpoint_wound_family/family = GLOB.hardpoint_wound_families_by_type[family_type]
			if(!family || family.part_slot != WOUND_SLOT_HULL)
				return
			var/current_tier = LAZYACCESS(vehicle.hull_wound_tiers, family_type) || 0
			var/new_tier = clamp(round(params["tier"]), 0, length(family.tiers))
			if(new_tier <= 0)
				LAZYREMOVE(vehicle.hull_wound_tiers, family_type)
			else
				LAZYSET(vehicle.hull_wound_tiers, family_type, new_tier)
			// Same reasoning as set_wound_tier above.
			if(new_tier > current_tier)
				play_wound_gain_effects(vehicle, family.damage_type, null)
			. = TRUE

/**
 * Removes and qdels whatever hardpoint currently occupies target_slot, if any.
 *
 * Arguments:
 * * holder = Either the vehicle or turret holder. Untyped so DM resolves remove_hardpoint() at runtime.
 */
/datum/tank_hardpoint_debugger/proc/remove_existing_in_slot(list/hardpoint_list, target_slot, holder)
	for(var/obj/item/hardpoint/H in hardpoint_list)
		if(H.slot != target_slot)
			continue
		if(H == selected)
			selected = null
		holder:remove_hardpoint(H)
		qdel(H)
		return
