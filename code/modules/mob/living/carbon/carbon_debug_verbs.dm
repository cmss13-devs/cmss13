/// Shared lookup for the debug verbs below: finds the tank_turret on the tank this mob is currently seated in, if any. Reports why to src and returns null on failure.
/mob/living/carbon/proc/get_seated_tank_turret()
	if(!istype(buckled, /obj/structure/bed/chair/comfy/vehicle))
		to_chat(src, SPAN_WARNING("You're not seated in a vehicle."))
		return null

	var/obj/structure/bed/chair/comfy/vehicle/seat_chair = buckled
	var/obj/vehicle/multitile/tank/tank_vehicle = seat_chair.vehicle
	if(!istype(tank_vehicle))
		to_chat(src, SPAN_WARNING("You're not seated in a tank."))
		return null

	var/obj/item/hardpoint/holder/tank_turret/turret
	for(var/obj/item/hardpoint/holder/tank_turret/TT in tank_vehicle.hardpoints)
		turret = TT
		break
	if(!turret)
		to_chat(src, SPAN_WARNING("This tank has no turret installed."))
		return null

	return turret

// Debug tool for live-tuning tank turret weapon sprite alignment
/mob/living/carbon/verb/set_tank_weapon_rotation_pivot()
	set name = "Set Tank Weapon Rotation Pivot"
	set category = "Debug"
	set desc = "Live-tunes the rotation_pivot of a weapon mounted on the turret of the tank you're seated in."

	if(!check_rights(R_DEBUG))
		return

	var/obj/item/hardpoint/holder/tank_turret/turret = get_seated_tank_turret()
	if(!turret)
		return

	if(!LAZYLEN(turret.hardpoints))
		to_chat(src, SPAN_WARNING("This turret has no weapons mounted."))
		return

	var/datum/tank_pivot_tuner/tuner = new
	tuner.turret = turret
	for(var/obj/item/hardpoint/H in turret.hardpoints)
		tuner.weapon = H
		break
	tuner.tgui_interact(src)

/datum/tank_pivot_tuner
	var/obj/item/hardpoint/holder/tank_turret/turret
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

/// The nearest of the 8 cardinal/diagonal dir constants to the turret's current continuous facing
/datum/tank_pivot_tuner/proc/get_turret_octant()
	return angle_to_dir(turret.current_angle)

/datum/tank_pivot_tuner/ui_data(mob/user)
	. = list()
	if(QDELETED(turret))
		return

	var/turret_octant = get_turret_octant()
	.["dir_name"] = dir2text(turret_octant)

	var/dir_key = "[turret_octant]"
	var/list/weapon_list = list()
	for(var/obj/item/hardpoint/H in turret.hardpoints)
		var/list/pivot = LAZYACCESS(H.rotation_pivot, dir_key) || list(0, 0)
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
	var/list/selected_pivot = LAZYACCESS(weapon.rotation_pivot, dir_key) || list(0, 0)
	.["tuning_label"] = "turret facing: [dir2text(turret_octant)]"
	.["selected_name"] = weapon.name
	.["pivot_x"] = selected_pivot[1]
	.["pivot_y"] = selected_pivot[2]

	var/list/selected_offset = LAZYACCESS(weapon.px_offsets, dir_key) || list(0, 0)
	.["offset_x"] = selected_offset[1]
	.["offset_y"] = selected_offset[2]

	.["is_gimballed"] = weapon.self_gimballed
	if(weapon.self_gimballed)
		var/list/selected_gimbal_pivot = LAZYACCESS(weapon.gimbal_pivot, dir_key) || list(0, 0)
		.["gimbal_pivot_x"] = selected_gimbal_pivot[1]
		.["gimbal_pivot_y"] = selected_gimbal_pivot[2]

/datum/tank_pivot_tuner/ui_act(action, list/params, datum/tgui/ui)
	. = ..()
	if(.)
		return
	if(QDELETED(turret))
		return

	switch(action)
		if("select_weapon")
			var/obj/item/hardpoint/H = locate(params["ref"]) in turret.hardpoints
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
			switch(target)
				if("gimbal")
					pivot_list = weapon.gimbal_pivot
				if("offset")
					pivot_list = weapon.px_offsets
				else
					pivot_list = weapon.rotation_pivot
			var/dir_key = "[get_turret_octant()]"
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

			turret.owner.update_icon()
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
