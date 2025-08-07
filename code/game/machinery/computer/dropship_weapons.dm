/obj/structure/machinery/computer/dropship_weapons
	name = "abstract dropship weapons controls"
	desc = "A computer to manage equipment, weapons and simulations installed on the dropship."
	density = TRUE
	icon = 'icons/obj/structures/machinery/shuttle-parts.dmi'
	icon_state = "consoleright"
	var/faction = FACTION_MARINE
	circuit = null
	unslashable = TRUE
	unacidable = TRUE
	explo_proof = TRUE
	var/shuttle_tag  // Used to know which shuttle we're linked to.
	var/obj/structure/dropship_equipment/selected_equipment //the currently selected equipment installed on the shuttle this console controls.
	var/cavebreaker = FALSE //ignore caves and other restrictions?
	var/datum/cas_fire_envelope/firemission_envelope
	var/datum/cas_fire_mission/selected_firemission
	var/datum/cas_fire_mission/editing_firemission
	var/firemission_signal //id of the signal
	var/in_firemission_mode = FALSE
	var/upgraded = MATRIX_DEFAULT // we transport upgrade var from matrixdm
	var/matrix_color = NV_COLOR_GREEN //color of matrix, only used when we upgrade to nv
	var/power //level of the property
	var/datum/cas_signal/selected_cas_signal
	var/datum/simulator/simulation
	var/datum/cas_fire_mission/configuration

	// groundside maps
	var/datum/tacmap/tacmap
	var/minimap_type = MINIMAP_FLAG_USCM

	// Cameras
	var/camera_target_id
	var/camera_width = 11
	var/camera_height = 11
	var/camera_map_name
	///Tracks equipment with a camera that is deployed and we are viewing
	var/obj/structure/dropship_equipment/camera_area_equipment = null

	var/registered = FALSE

/obj/structure/machinery/computer/dropship_weapons/New()
	..()
	if(firemission_envelope)
		firemission_envelope.linked_console = src

/obj/structure/machinery/computer/dropship_weapons/Initialize()
	. = ..()
	simulation = new()
	tacmap = new(src, minimap_type)

	RegisterSignal(src, COMSIG_CAMERA_MAPNAME_ASSIGNED, PROC_REF(camera_mapname_update))

	// camera setup
	AddComponent(/datum/component/camera_manager)
	SEND_SIGNAL(src, COMSIG_CAMERA_CLEAR)

/obj/structure/machinery/computer/dropship_weapons/Destroy()
	. = ..()
	QDEL_NULL(firemission_envelope)
	QDEL_NULL(tacmap)
	UnregisterSignal(src, COMSIG_CAMERA_MAPNAME_ASSIGNED)

/obj/structure/machinery/computer/dropship_weapons/proc/camera_mapname_update(source, value)
	camera_map_name = value

/obj/structure/machinery/computer/dropship_weapons/attack_hand(mob/user)
	if(..())
		return

	if(!allowed(user))
		// TODO: Restore cas simulator
		to_chat(user, SPAN_WARNING("Weapons modification access denied."))
		return TRUE
		// everyone can access the simulator, requested feature.
		/*to_chat(user, SPAN_WARNING("Weapons modification access denied, attempting to launch simulation."))

		if(!selected_firemission)
			to_chat(user, SPAN_WARNING("Firemission must be selected before attempting to run the simulation"))
			return TRUE

		tgui_interact(user)
		return FALSE*/

	user.set_interaction(src)
	ui_interact(user)

/obj/structure/machinery/computer/dropship_weapons/attackby(obj/item/W, mob/user as mob)
	if(istype(W, /obj/item/frame/matrix_frame))
		var/obj/item/frame/matrix_frame/matrix = W
		if(matrix.state == ASSEMBLY_LOCKED)
			user.drop_held_item(W, src)
			W.forceMove(src)
			to_chat(user, SPAN_NOTICE("You swap the matrix in the dropship guidance camera system, destroying the older part in the process"))
			upgraded = matrix.upgrade
			power = matrix.power

		else
			to_chat(user, SPAN_WARNING("Matrix is not complete!"))

/obj/structure/machinery/computer/dropship_weapons/proc/equipment_update(obj/docking_port/mobile/marine_dropship/dropship)
	SIGNAL_HANDLER
	var/list/obj/structure/dropship_equipment/weapons = list()
	for(var/obj/structure/dropship_equipment/weapon/weap as anything in dropship.equipments)
		weapons.Add(weap)
	firemission_envelope.update_weapons(weapons)

/obj/structure/machinery/computer/dropship_weapons/ui_interact(mob/user, ui_key = "main", datum/nanoui/ui = null, force_open = 0)
	var/obj/docking_port/mobile/marine_dropship/dropship = SSshuttle.getShuttle(shuttle_tag)
	if(!istype(dropship))
		return

	var/screen_mode = 0
	if(firemission_envelope)
		if(!istype(editing_firemission))
			editing_firemission = null

		if(editing_firemission)
			var/error_code = editing_firemission.check(src)
			var/can_edit = error_code != FIRE_MISSION_CODE_ERROR
			if(!can_edit)
				editing_firemission = null
				//abort

		if((screen_mode != 0 && in_firemission_mode) || !selected_firemission)
			in_firemission_mode = FALSE
		if(selected_firemission && in_firemission_mode)
			if(selected_firemission.check(src)!=FIRE_MISSION_ALL_GOOD)
				in_firemission_mode = FALSE
				selected_firemission = null
		if(selected_firemission && in_firemission_mode)
			screen_mode = 3
			if(firemission_envelope.recorded_loc && (!firemission_envelope.recorded_loc.signal_loc || !firemission_envelope.recorded_loc.signal_loc:loc))
				firemission_envelope.recorded_loc = null

		if(screen_mode != 3 || !selected_firemission || dropship.mode != SHUTTLE_CALL)
			update_location(user, null)

	tgui_interact(user)

/obj/structure/machinery/computer/dropship_weapons/tgui_interact(mob/user, datum/tgui/ui)
	if(!registered)
		var/obj/docking_port/mobile/marine_dropship/dropship = SSshuttle.getShuttle(shuttle_tag)
		RegisterSignal(dropship, COMSIG_DROPSHIP_ADD_EQUIPMENT, PROC_REF(equipment_update))
		RegisterSignal(dropship, COMSIG_DROPSHIP_REMOVE_EQUIPMENT, PROC_REF(equipment_update))
		registered = TRUE

	if(!tacmap.map_holder)
		var/level = SSmapping.levels_by_trait(tacmap.targeted_ztrait)
		tacmap.map_holder = SSminimaps.fetch_tacmap_datum(level[1], tacmap.allowed_flags)

	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		user.client.register_map_obj(tacmap.map_holder.map)
		SEND_SIGNAL(src, COMSIG_CAMERA_REGISTER_UI, user)
		ui = new(user, src, "DropshipWeaponsConsole", "Weapons Console")
		ui.open()

/obj/structure/machinery/computer/dropship_weapons/ui_close(mob/user)
	. = ..()
	SEND_SIGNAL(src, COMSIG_CAMERA_UNREGISTER_UI, user)
	simulation.stop_watching(user)

/obj/structure/machinery/computer/dropship_weapons/ui_status(mob/user, datum/ui_state/state)
	. = ..()
	if(inoperable())
		return UI_CLOSE
	if(!faction)
		return UI_CLOSE

	var/datum/cas_iff_group/cas_group = GLOB.cas_groups[faction]
	if(!cas_group)
		return UI_CLOSE

/obj/structure/machinery/computer/dropship_weapons/ui_state(mob/user)
	return GLOB.not_incapacitated_and_adjacent_strict_state

/obj/structure/machinery/computer/dropship_weapons/ui_static_data(mob/user)
	. = list()
	.["tactical_map_ref"] = tacmap.map_holder.map_ref
	.["camera_map_ref"] = camera_map_name

/obj/structure/machinery/computer/dropship_weapons/ui_data(mob/user)
	. = list()
	var/obj/docking_port/mobile/marine_dropship/dropship = SSshuttle.getShuttle(shuttle_tag)
	if (!istype(dropship))
		return

	var/datum/cas_signal/sig = get_cas_signal(camera_target_id)
	if(camera_target_id && !sig)
		set_camera_target(null)

	.["screen_mode"] = get_screen_mode()

	// dropship info
	.["shuttle_state"] = dropship.mode
	.["fire_mission_enabled"] = dropship.in_flyby

	// equipment info
	.["equipment_data"] = get_sanitised_equipment(user, dropship)

	// medevac targets
	.["medevac_targets"] = list()
	for(var/obj/structure/dropship_equipment/equipment as anything in dropship.equipments)
		if (istype(equipment, /obj/structure/dropship_equipment/medevac_system))
			var/obj/structure/dropship_equipment/medevac_system/medevac = equipment
			.["medevac_targets"] += medevac.ui_data(user)
	// fultons

	.["fulton_targets"] = list()
	for(var/obj/structure/dropship_equipment/equipment as anything in dropship.equipments)
		if (istype(equipment, /obj/structure/dropship_equipment/fulton_system))
			var/obj/structure/dropship_equipment/fulton_system/fult = equipment
			.["fulton_targets"] += fult.ui_data(user)

	.["targets_data"] = get_targets()
	.["camera_target"] = camera_target_id

	if(selected_equipment)
		.["selected_eqp"] = selected_equipment.ship_base.attach_id
		if(selected_equipment.ammo_equipped)
			var/obj/structure/ship_ammo/ammo_equipped = selected_equipment.ammo_equipped
			.["selected_eqp_ammo_name"] = sanitize(copytext(ammo_equipped.name, 1, MAX_MESSAGE_LEN))
			.["selected_eqp_ammo_amt"] = ammo_equipped.ammo_count
			.["selected_eqp_max_ammo_amt"] = ammo_equipped.max_ammo_count

	// firemission info
	.["has_firemission"] = !!firemission_envelope
	.["can_firemission"] = !!selected_firemission && dropship.mode == SHUTTLE_CALL
	if(editing_firemission)
		.["editing_firemission"] = editing_firemission
		.["editing_firemission_length"] = editing_firemission ? editing_firemission.mission_length : 0
		var/error_code = editing_firemission.check(src)
		.["current_mission_error"] = error_code != FIRE_MISSION_ALL_GOOD ? editing_firemission.error_message(error_code) : null
		.["firemission_edit_data"] = get_edit_firemission_data()

	if(firemission_envelope)
		.["can_launch_firemission"] = !!selected_firemission && dropship.mode == SHUTTLE_CALL && firemission_envelope.stat != FIRE_MISSION_STATE_IDLE
		.["firemission_data"] = get_firemission_data(user)
		.["firemission_state"] = firemission_envelope.stat
		.["firemission_offset"] = firemission_envelope.recorded_offset
		.["firemission_message"] = firemission_envelope.firemission_status_message()
		.["firemission_name"] = selected_firemission ? selected_firemission.name : ""
		.["firemission_step"] = firemission_envelope.stat
		.["firemission_selected_laser"] = firemission_envelope.recorded_loc ? firemission_envelope.recorded_loc.get_name() : "NOT SELECTED"

	.["configuration"] = configuration
	.["dummy_mode"] = simulation.dummy_mode
	.["worldtime"] = world.time
	.["nextdetonationtime"] = simulation.detonation_cooldown
	.["detonation_cooldown"] = simulation.detonation_cooldown_time

/obj/structure/machinery/computer/dropship_weapons/ui_act(action, list/params, datum/tgui/ui, datum/ui_state/state)
	. = ..()
	if(.)
		return
	var/obj/docking_port/mobile/marine_dropship/shuttle = SSshuttle.getShuttle(shuttle_tag)
	if(shuttle.is_hijacked)
		return

	var/mob/user = ui.user
	switch(action)
		if("button_push")
			playsound(src, get_sfx("terminal_button"), 25, FALSE)
			return FALSE

		if("select_equipment")
			var/base_tag = params["equipment_id"]
			ui_equip_interact(user, base_tag)
			return TRUE

		if("start_watching")
			simulation.start_watching(user)
			. = TRUE

		if("stop_watching")
			simulation.stop_watching(user)
			. = TRUE

		if("execute_simulated_firemission")
			if(!configuration)
				to_chat(user, SPAN_WARNING("No configured firemission"))
				return
			simulate_firemission(user)
			. = TRUE

		if("switch_firemission")
			configuration = tgui_input_list(user, "Select firemission to simulate", "Select firemission", firemission_envelope.missions, 30 SECONDS)
			if(!selected_firemission)
				to_chat(user, SPAN_WARNING("No configured firemission"))
				return
			if(!configuration)
				configuration = selected_firemission
			. = TRUE

		if("switchmode")
			simulation.dummy_mode = tgui_input_list(user, "Select target type to simulate", "Target type", simulation.target_types, 30 SECONDS)
			if(!simulation.dummy_mode)
				simulation.dummy_mode = CLF_MODE
			. = TRUE

		if("set-camera")
			var/target_camera = params["equipment_id"]
			set_camera_target(target_camera)
			return TRUE

		if("set-camera-sentry")
			var/equipment_tag = params["equipment_id"]
			for(var/obj/structure/dropship_equipment/equipment as anything in shuttle.equipments)
				var/mount_point = equipment.ship_base.attach_id
				if(mount_point != equipment_tag)
					continue
				if(istype(equipment, /obj/structure/dropship_equipment/sentry_holder))
					var/obj/structure/dropship_equipment/sentry_holder/sentry = equipment
					var/obj/structure/machinery/defenses/sentry/defense = sentry.deployed_turret
					if(defense.has_camera)
						defense.set_range()
						camera_area_equipment = sentry
						SEND_SIGNAL(src, COMSIG_CAMERA_SET_AREA, defense.range_bounds, defense.loc.z)
				return TRUE

		if("auto-deploy")
			var/equipment_tag = params["equipment_id"]
			for(var/obj/structure/dropship_equipment/equipment as anything in shuttle.equipments)
				var/mount_point = equipment.ship_base.attach_id
				if(mount_point != equipment_tag)
					continue

				if(istype(equipment, /obj/structure/dropship_equipment/sentry_holder))
					var/obj/structure/dropship_equipment/sentry_holder/sentry = equipment
					sentry.auto_deploy = !sentry.auto_deploy
					return TRUE

				if(istype(equipment, /obj/structure/dropship_equipment/mg_holder))
					var/obj/structure/dropship_equipment/mg_holder/mg = equipment
					mg.auto_deploy = !mg.auto_deploy
				return TRUE

		if("clear-camera")
			set_camera_target(null)
			return TRUE

		if("medevac-target")
			var/equipment_tag = params["equipment_id"]
			for(var/obj/structure/dropship_equipment/equipment as anything in shuttle.equipments)
				var/mount_point = equipment.ship_base.attach_id
				if(mount_point != equipment_tag)
					continue
				if (istype(equipment, /obj/structure/dropship_equipment/medevac_system))
					var/obj/structure/dropship_equipment/medevac_system/medevac = equipment
					var/target_ref = params["ref"]
					medevac.automate_interact(user, target_ref)
					if(medevac.linked_stretcher)
						SEND_SIGNAL(src, COMSIG_CAMERA_SET_TARGET, medevac.linked_stretcher, 5, 5)
				return TRUE

		if("fulton-target")
			var/equipment_tag = params["equipment_id"]
			for(var/obj/structure/dropship_equipment/equipment as anything in shuttle.equipments)
				var/mount_point = equipment.ship_base.attach_id
				if(mount_point != equipment_tag)
					continue
				if (istype(equipment, /obj/structure/dropship_equipment/fulton_system))
					var/obj/structure/dropship_equipment/fulton_system/fulton = equipment
					var/target_ref = params["ref"]
					fulton.automate_interact(user, target_ref)
				return TRUE

		if("fire-weapon")
			var/weapon_tag = params["eqp_tag"]
			var/obj/structure/dropship_equipment/weapon/DEW = get_weapon(weapon_tag)
			if(!DEW)
				return FALSE

			var/datum/cas_signal/sig = get_cas_signal(camera_target_id)
			if(!sig)
				return FALSE

			selected_equipment = DEW
			if(ui_open_fire(user, shuttle, camera_target_id))
				if(firemission_envelope)
					firemission_envelope.untrack_object()
			return TRUE

		if("deploy-equipment")
			var/equipment_tag = params["equipment_id"]
			for(var/obj/structure/dropship_equipment/equipment as anything in shuttle.equipments)
				var/mount_point = equipment.ship_base.attach_id
				if(mount_point != equipment_tag)
					continue
				if(camera_area_equipment == equipment)
					set_camera_target(null)
				equipment.equipment_interact(user)
				return TRUE

		if("firemission-create")
			var/name = params["firemission_name"]
			var/length = params["firemission_length"]
			var/length_n = text2num(length)
			if(!length_n)
				to_chat(user, SPAN_WARNING("Incorrect input format."))
				return FALSE
			ui_create_firemission(user, name, length_n)
			return TRUE

		if("firemission-delete")
			var/name = params["firemission_name"]
			ui_delete_firemission(user, name)
			return TRUE

		if("firemission-dual-offset-camera")
			var/target_id = params["target_id"]

			var/x_offset_value = params["x_offset_value"]
			var/y_offset_value = params["y_offset_value"]

			camera_target_id = target_id
			var/datum/cas_signal/cas_sig = get_cas_signal(camera_target_id, valid_only = TRUE)
			// we don't want rapid offset changes to trigger admin warnings
			// and block the user from accessing TGUI
			// we change the minute_count
			user.client.reduce_minute_count()
			if(!cas_sig)
				return TRUE

			// find position of cas_sig with offset dir and value applied
			var/dx = text2num(x_offset_value)
			var/dy = text2num(y_offset_value)

			var/obj/current = cas_sig.signal_loc
			var/obj/new_target = locate(
				current.x + dx,
				current.y + dy,
				current.z)

			camera_area_equipment = null
			firemission_envelope.change_current_loc(new_target, cas_sig)
			return TRUE

		if("nvg-enable")
			if(upgraded != MATRIX_NVG)
				to_chat(user, SPAN_WARNING("The matrix is not upgraded with night vision."))
				return FALSE
			if(user.client?.prefs?.night_vision_preference)
				matrix_color = user.client.prefs.nv_color_list[user.client.prefs.night_vision_preference]
			SEND_SIGNAL(src, COMSIG_CAMERA_SET_NVG, 5, matrix_color)
			return TRUE

		if("nvg-disable")
			SEND_SIGNAL(src, COMSIG_CAMERA_CLEAR_NVG)
			return TRUE

		if("firemission-edit")
			var/fm_tag = text2num(params["tag"])
			var/weapon_id = text2num(params["weapon_id"])
			var/offset_id = text2num(params["offset_id"])
			var/offset_value = text2num(params["offset_value"])
			return ui_firemission_change_offset(user, fm_tag, weapon_id, offset_id + 1, offset_value)

		if("firemission-execute")
			var/fm_tag = text2num(params["tag"])
			var/direction = params["direction"]
			var/target_id = params["target_id"]
			var/offset_x_value = params["offset_x_value"]
			var/offset_y_value = params["offset_y_value"]

			if(!ui_select_firemission(user, fm_tag))
				playsound(src, 'sound/machines/terminal_error.ogg', 5, 1)
				return FALSE
			if(!update_direction(user, text2num(direction)))
				playsound(src, 'sound/machines/terminal_error.ogg', 5, 1)
				return FALSE
			if(!ui_select_laser_firemission(user, shuttle, target_id))
				playsound(src, 'sound/machines/terminal_error.ogg', 5, 1)
				return FALSE

			initiate_firemission(user, fm_tag, direction, text2num(offset_x_value), text2num(offset_y_value))
			return TRUE
		if("paradrop-lock")
			var/obj/docking_port/mobile/marine_dropship/linked_shuttle = SSshuttle.getShuttle(shuttle_tag)
			if(!linked_shuttle)
				return FALSE
			if(linked_shuttle.mode != SHUTTLE_CALL)
				return FALSE
			if(linked_shuttle.paradrop_signal)
				clear_locked_turf_and_lock_aft()
				return TRUE
			var/datum/cas_signal/sig = get_cas_signal(camera_target_id)
			if(!sig)
				to_chat(user, SPAN_WARNING("No signal chosen."))
				return FALSE
			var/turf/location = get_turf(sig.signal_loc)
			var/area/location_area = get_area(location)
			if(CEILING_IS_PROTECTED(location_area.ceiling, CEILING_PROTECTION_TIER_1))
				to_chat(user, SPAN_WARNING("Target is obscured."))
				return FALSE
			var/equipment_tag = params["equipment_id"]
			for(var/obj/structure/dropship_equipment/equipment as anything in shuttle.equipments)
				var/mount_point = equipment.ship_base.attach_id
				if(mount_point != equipment_tag)
					continue
				if(istype(equipment, /obj/structure/dropship_equipment/paradrop_system))
					var/obj/structure/dropship_equipment/paradrop_system/paradrop_system = equipment
					if(paradrop_system.system_cooldown > world.time)
						to_chat(user, SPAN_WARNING("You toggled the system too recently."))
						return
					paradrop_system.system_cooldown = world.time + 5 SECONDS
					paradrop_system.visible_message(SPAN_NOTICE("[equipment] hums as it locks to a signal."))
					break
			linked_shuttle.paradrop_signal = sig
			addtimer(CALLBACK(src, PROC_REF(open_aft_for_paradrop)), 2 SECONDS)
			RegisterSignal(linked_shuttle.paradrop_signal, COMSIG_PARENT_QDELETING, PROC_REF(clear_locked_turf_and_lock_aft))
			RegisterSignal(linked_shuttle, COMSIG_SHUTTLE_SETMODE, PROC_REF(clear_locked_turf_and_lock_aft))
			return TRUE

/obj/structure/machinery/computer/dropship_weapons/proc/open_aft_for_paradrop()
	var/obj/docking_port/mobile/marine_dropship/shuttle = SSshuttle.getShuttle(shuttle_tag)
	if(!shuttle || !shuttle.paradrop_signal || shuttle.mode != SHUTTLE_CALL)
		return
	shuttle.door_control.control_doors("force-unlock", "aft", TRUE)

/obj/structure/machinery/computer/dropship_weapons/proc/clear_locked_turf_and_lock_aft()
	SIGNAL_HANDLER
	var/obj/docking_port/mobile/marine_dropship/shuttle = SSshuttle.getShuttle(shuttle_tag)
	if(!shuttle)
		return
	shuttle.door_control.control_doors("force-lock", "aft", TRUE)
	visible_message(SPAN_WARNING("[src] displays an alert as it loses the paradrop target."))
	for(var/obj/structure/dropship_equipment/paradrop_system/parad in shuttle.equipments)
		parad.visible_message(SPAN_WARNING("[parad] displays an alert as it loses the paradrop target."))
	UnregisterSignal(shuttle.paradrop_signal, COMSIG_PARENT_QDELETING)
	UnregisterSignal(shuttle, COMSIG_SHUTTLE_SETMODE)
	shuttle.paradrop_signal = null

/obj/structure/machinery/computer/dropship_weapons/proc/get_weapon(eqp_tag)
	var/obj/docking_port/mobile/marine_dropship/dropship = SSshuttle.getShuttle(shuttle_tag)
	var/obj/structure/dropship_equipment/equipment = dropship.equipments[eqp_tag]
	if(istype(equipment, /obj/structure/dropship_equipment/weapon))
		//is weapon
		return equipment
	return

/obj/structure/machinery/computer/dropship_weapons/proc/get_cas_signal(target_ref, valid_only = FALSE)
	if(!target_ref)
		return

	var/datum/cas_iff_group/cas_group = GLOB.cas_groups[faction]
	for(var/datum/cas_signal/sig in cas_group.cas_signals)
		if(sig.target_id == target_ref)
			if(valid_only && !sig.valid_signal())
				continue
			return sig

/obj/structure/machinery/computer/dropship_weapons/proc/set_camera_target(target_ref)
	camera_area_equipment = null
	if(firemission_envelope)
		firemission_envelope.untrack_object()

	var/datum/cas_signal/target = get_cas_signal(target_ref)
	camera_target_id = target_ref
	if(!target)
		SEND_SIGNAL(src, COMSIG_CAMERA_CLEAR)
		return

	var/cam_width = camera_width
	var/cam_height = camera_height
	if(upgraded == MATRIX_WIDE)
		cam_width = cam_width * 1.5
		cam_height = cam_height * 1.5

	SEND_SIGNAL(src, COMSIG_CAMERA_SET_TARGET, target.linked_cam, cam_width, cam_height)

/obj/structure/machinery/computer/dropship_weapons/proc/get_screen_mode()
	. = 0
	if(selected_equipment)
		. = selected_equipment.screen_mode
	if(editing_firemission && editing_firemission.check(src) != FIRE_MISSION_CODE_ERROR)
		. = 2
	if(selected_firemission && in_firemission_mode)
		. = 3
/obj/structure/machinery/computer/dropship_weapons/proc/get_firemission_data(mob/user)
	. = list()
	var/firemission_id = 1
	for(var/datum/cas_fire_mission/firemission in firemission_envelope.missions)
		var/error_code = firemission.check(src)

		var/selected = firemission == selected_firemission
		var/can_edit = error_code != FIRE_MISSION_CODE_ERROR && !selected

		var/can_interact = firemission_envelope.stat == FIRE_MISSION_STATE_IDLE && error_code == FIRE_MISSION_ALL_GOOD
		var/list/fm_data = firemission.ui_data(user)
		fm_data["mission_tag"] = firemission_id
		fm_data["can_edit"] = can_edit
		fm_data["can_interact"] = can_interact
		fm_data["selected"] = selected
		. += list(fm_data)

		firemission_id++

/obj/structure/machinery/computer/dropship_weapons/proc/get_edit_firemission_data()
	. = list()
	if(!editing_firemission)
		return
	for(var/datum/cas_fire_mission_record/firerec as anything in editing_firemission.records)
		var/gimbal = firerec.get_offsets()
		var/ammo = firerec.get_ammo()
		var/offsets = new /list(length(firerec.offsets))
		for(var/idx = 1; idx < length(firerec.offsets); idx++)
			offsets[idx] = firerec.offsets[idx] == null ? "-" : firerec.offsets[idx]
			. += list(
				"name" = sanitize(copytext(firerec.weapon.name, 1, 50)),
				"ammo" = ammo,
				"gimbal" = gimbal,
				"offsets" = firerec.offsets
			)

/obj/structure/machinery/computer/dropship_weapons/proc/get_sanitised_equipment(mob/user, obj/docking_port/mobile/marine_dropship/dropship)
	. = list()
	var/element_nbr = 1
	for(var/obj/structure/dropship_equipment/equipment in dropship.equipments)
		var/list/data = list(
			"name"= equipment.name,
			"shorthand" = equipment.shorthand,
			"eqp_tag" = element_nbr,
			"is_weapon" = equipment.is_weapon,
			"is_interactable" = equipment.is_interactable,
			"mount_point" = equipment.ship_base.attach_id,
			"is_missile" = istype(equipment,  /obj/structure/dropship_equipment/weapon/rocket_pod),
			"ammo_name" = equipment.ammo_equipped?.name,
			"ammo" = equipment.ammo_equipped?.ammo_count,
			"max_ammo" = equipment.ammo_equipped?.max_ammo_count,
			"firemission_delay" = equipment.ammo_equipped?.fire_mission_delay,
			"burst" = equipment.ammo_equipped?.ammo_used_per_firing,
			"data" = equipment.ui_data(user)
		)

		. += list(data)

		element_nbr++
		equipment.linked_console = src


/obj/structure/machinery/computer/dropship_weapons/proc/get_targets()
	. = list()
	var/datum/cas_iff_group/cas_group = GLOB.cas_groups[faction]
	for(var/datum/cas_signal/LT as anything in cas_group.cas_signals)
		var/obj/object = LT.signal_loc
		if(!istype(LT) || !LT.valid_signal() || !is_ground_level(object.z))
			continue
		var/area/laser_area = get_area(LT.signal_loc)
		. += list(
			list(
				"target_name" = "[LT.name] ([laser_area.name])",
				"target_tag" = LT.target_id
			)
		)

/obj/structure/machinery/computer/dropship_weapons/proc/ui_equip_interact(mob/user, base_tag)
	var/obj/docking_port/mobile/marine_dropship/shuttle = SSshuttle.getShuttle(shuttle_tag)
	var/obj/structure/dropship_equipment/E = shuttle.equipments[base_tag]
	E.linked_console = src
	E.equipment_interact(user)

/obj/structure/machinery/computer/dropship_weapons/proc/ui_open_fire(mob/weapon_operator, obj/docking_port/mobile/marine_dropship/dropship, targ_id)
	if(ishuman(weapon_operator))
		var/mob/living/carbon/human/human_operator = weapon_operator
		if(!human_operator.allow_gun_usage)
			to_chat(human_operator, SPAN_WARNING("Your programming prevents you from operating dropship weaponry!"))
			return FALSE
	var/obj/structure/dropship_equipment/weapon/DEW = selected_equipment
	if(!selected_equipment || !selected_equipment.is_weapon)
		to_chat(weapon_operator, SPAN_WARNING("No weapon selected."))
		return FALSE
	if(!skillcheck(weapon_operator, SKILL_PILOT, DEW.skill_required)) //only pilots can fire dropship weapons.
		to_chat(weapon_operator, SPAN_WARNING("You don't have the training to fire this weapon!"))
		return FALSE
	if(dropship.mode != SHUTTLE_CALL)
		to_chat(weapon_operator, SPAN_WARNING("Dropship can only fire while in flight."))
		return FALSE
	if(!faction)
		return FALSE//no faction, no weapons
	if(!selected_equipment || !selected_equipment.is_weapon)
		to_chat(weapon_operator, SPAN_WARNING("No weapon selected."))
		return FALSE
	if(dropship.door_override)
		return FALSE
	if(!skillcheck(weapon_operator, SKILL_PILOT, DEW.skill_required)) //only pilots can fire dropship weapons.
		to_chat(weapon_operator, SPAN_WARNING("You don't have the training to fire this weapon!"))
		return FALSE
	if(!dropship.in_flyby && DEW.fire_mission_only)
		to_chat(weapon_operator, SPAN_WARNING("[DEW] requires a fire mission flight type to be fired."))
		return FALSE

	if(!DEW.ammo_equipped || DEW.ammo_equipped.ammo_count <= 0)
		to_chat(weapon_operator, SPAN_WARNING("[DEW] has no ammo."))
		return FALSE
	if(DEW.last_fired > world.time - DEW.firing_delay)
		to_chat(weapon_operator, SPAN_WARNING("[DEW] just fired, wait for it to cool down."))
		return FALSE

	var/datum/cas_iff_group/cas_group = GLOB.cas_groups[faction]

	if(!cas_group)
		return FALSE//broken group. No fighting

	for(var/datum/cas_signal/LT in cas_group.cas_signals)
		if(LT.target_id != targ_id || !LT.valid_signal())
			continue
		if(!LT.signal_loc)
			return FALSE
		var/turf/TU = get_turf(LT.signal_loc)
		var/area/targ_area = get_area(LT.signal_loc)
		var/is_outside = FALSE
		if(is_ground_level(TU.z))
			switch(targ_area.ceiling)
				if(CEILING_NONE)
					is_outside = TRUE
				if(CEILING_GLASS)
					is_outside = TRUE
		if(!is_outside && !cavebreaker) //cavebreaker doesn't care
			to_chat(weapon_operator, SPAN_WARNING("INVALID TARGET: target must be visible from high altitude."))
			return FALSE
		if (protected_by_pylon(TURF_PROTECTION_CAS, TU))
			to_chat(weapon_operator, SPAN_WARNING("INVALID TARGET: biological-pattern interference with signal."))
			return FALSE
		if(!DEW.ammo_equipped.can_fire_at(TU, weapon_operator))
			return FALSE

		DEW.open_fire(LT.signal_loc)
		return TRUE
	return FALSE

/obj/structure/machinery/computer/dropship_weapons/proc/ui_create_firemission(mob/weapon_operator, firemission_name, firemission_length)
	if(!skillcheck(weapon_operator, SKILL_PILOT, SKILL_PILOT_TRAINED)) //only pilots can fire dropship weapons.
		to_chat(weapon_operator, SPAN_WARNING("A screen with graphics and walls of physics and engineering values open, you immediately force it closed."))
		return FALSE
	// Check name
	if(!firemission_name || length(firemission_name) < 1)
		to_chat(weapon_operator, SPAN_WARNING("Name too short (at least 1 symbols)."))
		return FALSE
	// Check length
	if(!firemission_length)
		to_chat(weapon_operator, SPAN_WARNING("Incorrect input format."))
		return FALSE
	if(firemission_length > firemission_envelope.fire_length)
		to_chat(weapon_operator, SPAN_WARNING("Fire Mission is longer than allowed by this vehicle."))
		return FALSE
	if(firemission_envelope.stat != FIRE_MISSION_STATE_IDLE)
		to_chat(weapon_operator, SPAN_WARNING("Vehicle has to be idle to allow Fire Mission editing and creation."))
		return FALSE

	for(var/datum/cas_fire_mission/mission in firemission_envelope.missions)
		if(firemission_name == mission.name)
			to_chat(weapon_operator, SPAN_WARNING("Fire Mission name must be unique."))
			return FALSE
	//everything seems to be fine now
	firemission_envelope.generate_mission(firemission_name, firemission_length)
	return TRUE

/obj/structure/machinery/computer/dropship_weapons/proc/ui_delete_firemission(mob/weapon_operator, firemission_tag)
	if(!skillcheck(weapon_operator, SKILL_PILOT, SKILL_PILOT_TRAINED)) //only pilots can fire dropship weapons.
		to_chat(weapon_operator, SPAN_WARNING("A screen with graphics and walls of physics and engineering values open, you immediately force it closed."))
		return FALSE
	if(firemission_tag > length(firemission_envelope.missions))
		to_chat(weapon_operator, SPAN_WARNING("Fire Mission ID corrupted or already deleted."))
		return FALSE
	if(selected_firemission == firemission_envelope.missions[firemission_tag])
		to_chat(weapon_operator, SPAN_WARNING("Can't delete selected Fire Mission."))
		return FALSE
	var/result = firemission_envelope.delete_firemission(firemission_tag)
	if(result != 1)
		to_chat(weapon_operator, SPAN_WARNING("Unable to delete Fire Mission while in combat."))
		return FALSE
	return TRUE

/obj/structure/machinery/computer/dropship_weapons/proc/ui_select_firemission(mob/weapon_operator, firemission_tag)
	if(!skillcheck(weapon_operator, SKILL_PILOT, SKILL_PILOT_TRAINED)) //only pilots can fire dropship weapons.
		to_chat(weapon_operator, SPAN_WARNING("A screen with graphics and walls of physics and engineering values open, you immediately force it closed."))
		return FALSE
	if(firemission_envelope.stat > FIRE_MISSION_STATE_IN_TRANSIT && firemission_envelope.stat < FIRE_MISSION_STATE_COOLDOWN)
		to_chat(weapon_operator, SPAN_WARNING("Fire Mission already underway."))
		return FALSE
	if(firemission_tag > length(firemission_envelope.missions))
		to_chat(weapon_operator, SPAN_WARNING("Fire Mission ID corrupted or deleted."))
		return FALSE
	if(selected_firemission == firemission_envelope.missions[firemission_tag])
		selected_firemission = null
	else
		selected_firemission = firemission_envelope.missions[firemission_tag]
	return TRUE

/obj/structure/machinery/computer/dropship_weapons/proc/ui_firemission_change_offset(mob/weapons_operator, fm_tag, weapon_id, offset_id, offset_value)
	if(!skillcheck(weapons_operator, SKILL_PILOT, SKILL_PILOT_TRAINED)) //only pilots can fire dropship weapons.
		to_chat(weapons_operator, SPAN_WARNING("A screen with graphics and walls of physics and engineering values open, you immediately force it closed."))
		return FALSE

	var/result = firemission_envelope.update_mission(fm_tag, weapon_id, offset_id, offset_value)
	if(result != FIRE_MISSION_ALL_GOOD)
		playsound(src, 'sound/machines/terminal_error.ogg', 5, 1)
	return TRUE

/obj/structure/machinery/computer/dropship_weapons/proc/ui_select_laser_firemission(mob/weapons_operator, obj/docking_port/mobile/marine_dropship/dropship, laser)
	if(!laser)
		to_chat(weapons_operator, SPAN_WARNING("Bad Target."))
		return FALSE
	if(!skillcheck(weapons_operator, SKILL_PILOT, SKILL_PILOT_TRAINED)) //only pilots can fire dropship weapons.
		to_chat(weapons_operator, SPAN_WARNING("A screen with graphics and walls of physics and engineering values open, you immediately force it closed."))
		return FALSE
	if(firemission_envelope.stat > FIRE_MISSION_STATE_IN_TRANSIT && firemission_envelope.stat < FIRE_MISSION_STATE_COOLDOWN)
		to_chat(weapons_operator, SPAN_WARNING("Fire Mission already underway."))
		return FALSE
	if(dropship.mode != SHUTTLE_CALL)
		to_chat(weapons_operator, SPAN_WARNING("Shuttle has to be in orbit."))
		return FALSE
	var/datum/cas_iff_group/cas_group = GLOB.cas_groups[faction]
	var/datum/cas_signal/cas_sig
	for(var/X in cas_group.cas_signals)
		var/datum/cas_signal/LT = X
		if(LT.target_id == laser  && LT.valid_signal())
			cas_sig = LT
	if(!cas_sig)
		to_chat(weapons_operator, SPAN_WARNING("Target lost or obstructed."))
		return FALSE

	update_location(weapons_operator, cas_sig)
	return TRUE

/obj/structure/machinery/computer/dropship_weapons/proc/initiate_firemission(mob/user, fmId, dir, offset_x, offset_y)
	set waitfor = 0
	var/obj/docking_port/mobile/marine_dropship/dropship = SSshuttle.getShuttle(shuttle_tag)
	if (!istype(dropship))
		return FALSE
	if (!dropship.in_flyby || dropship.mode != SHUTTLE_CALL)
		to_chat(user, SPAN_WARNING("Has to be in Fly By mode"))
		return FALSE
	if (dropship.timer && dropship.timeLeft(1) < firemission_envelope.flyoff_period)
		to_chat(user, SPAN_WARNING("Not enough time to complete the Fire Mission"))
		return FALSE
	var/datum/cas_signal/recorded_loc = firemission_envelope.recorded_loc
	var/obj/source = recorded_loc.signal_loc
	var/turf/target = locate(
		source.x + offset_x,
		source.y + offset_y,
		source.z
	)
	var/result = firemission_envelope.execute_firemission(recorded_loc, target, dir, fmId)
	if(result != FIRE_MISSION_ALL_GOOD)
		to_chat(user, SPAN_WARNING("Screen beeps with an error: [firemission_envelope.mission_error]"))
	return TRUE

/obj/structure/machinery/computer/dropship_weapons/proc/update_location(mob/user, new_location)
	var/result = firemission_envelope.change_target_loc(new_location)
	if(result<1)
		to_chat(user, SPAN_WARNING("Screen beeps with an error: [firemission_envelope.mission_error]"))
		return FALSE
	return TRUE


/obj/structure/machinery/computer/dropship_weapons/proc/update_direction(mob/user, new_direction)
	var/result = firemission_envelope.change_direction(new_direction)
	if(result<1)
		to_chat(user, SPAN_WARNING("Screen beeps with an error: [firemission_envelope.mission_error]"))
		return FALSE
	return TRUE

/obj/structure/machinery/computer/dropship_weapons/proc/update_trace_loc(mob/user)
	if(!firemission_envelope)
		return
	if(firemission_envelope.recorded_loc == null || firemission_envelope.recorded_dir == null || firemission_envelope.recorded_offset == null)
		return
	if(firemission_envelope.recorded_loc.obstructed_signal())
		if(firemission_envelope.user_is_guided(user))
			to_chat(user, SPAN_WARNING("Signal Obstructed. You have to go in blind."))
		return
	var/sx = 0
	var/sy = 0
	switch(firemission_envelope.recorded_dir)
		if(NORTH) //default direction
			sx = 0
			sy = 1
		if(SOUTH)
			sx = 0
			sy = -1
		if(EAST)
			sx = 1
			sy = 0
		if(WEST)
			sx = -1
			sy = 0
	var/turf/tt_turf = get_turf(firemission_envelope.recorded_loc.signal_loc)
	if(!tt_turf)
		return
	var/turf/shootloc = locate(tt_turf.x + sx*firemission_envelope.recorded_offset, tt_turf.y + sy*firemission_envelope.recorded_offset,tt_turf.z)
	if(!shootloc)
		return
	var/area/laser_area = get_area(shootloc)
	if(!istype(laser_area) || CEILING_IS_PROTECTED(laser_area.ceiling, CEILING_PROTECTION_TIER_1))
		if(firemission_envelope.user_is_guided(user))
			to_chat(user, SPAN_WARNING("Vision Obstructed. You have to go in blind."))
		firemission_envelope.change_current_loc()
	else
		firemission_envelope.change_current_loc(shootloc)
	return TRUE

/obj/structure/machinery/computer/dropship_weapons/dropship1
	name = "\improper 'Alamo' weapons controls"
	req_one_access = list(ACCESS_MARINE_LEADER, ACCESS_MARINE_DROPSHIP, ACCESS_WY_FLIGHT)
	firemission_envelope = new /datum/cas_fire_envelope/uscm_dropship()
	shuttle_tag = DROPSHIP_ALAMO

/obj/structure/machinery/computer/dropship_weapons/dropship2
	name = "\improper 'Normandy' weapons controls"
	req_one_access = list(ACCESS_MARINE_LEADER, ACCESS_MARINE_DROPSHIP, ACCESS_WY_FLIGHT)
	firemission_envelope = new /datum/cas_fire_envelope/uscm_dropship()
	shuttle_tag = DROPSHIP_NORMANDY

/obj/structure/machinery/computer/dropship_weapons/dropship3
	name = "\improper 'Saipan' weapons controls"
	req_one_access = list(ACCESS_MARINE_LEADER, ACCESS_MARINE_DROPSHIP, ACCESS_WY_FLIGHT)
	firemission_envelope = new /datum/cas_fire_envelope/uscm_dropship()
	shuttle_tag = DROPSHIP_SAIPAN

/obj/structure/machinery/computer/dropship_weapons/proc/simulate_firemission(mob/living/user)
	if(!configuration)
		to_chat(user, SPAN_WARNING("Configure a firemission before attempting to run the simulation"))
		return
	if(configuration.check(src) != FIRE_MISSION_ALL_GOOD)
		to_chat(user, SPAN_WARNING("Configured firemission has errors, fix the errors before attempting to run the simulation"))
		return

	simulation.spawn_mobs(user)

	if(!simulation.sim_camera)
		to_chat(user, SPAN_WARNING("The simulator has malfunctioned!"))

	//acutal firemission
	configuration.simulate_execute_firemission(src, get_turf(simulation.sim_camera), user)
