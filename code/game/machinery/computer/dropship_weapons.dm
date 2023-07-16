
/datum/camera_manager
	var/map_name
	var/datum/shape/rectangle/current_area
	var/atom/movable/screen/map_view/cam_screen
	var/atom/movable/screen/background/cam_background
	var/list/range_turfs = list()
	/// The turf where the camera was last updated.
	var/turf/last_camera_turf
	var/target_x
	var/target_y
	var/target_z

/datum/camera_manager/New(map_ref)
	map_name = map_ref
	cam_screen = new
	cam_screen.name = "screen"
	cam_screen.assigned_map = map_name
	cam_screen.del_on_map_removal = FALSE
	cam_screen.screen_loc = "[map_name]:1,1"
	cam_background = new
	cam_background.assigned_map = map_name
	cam_background.del_on_map_removal = FALSE

/datum/camera_manager/Destroy(force, ...)
	. = ..()
	range_turfs = null
	QDEL_NULL(cam_background)
	QDEL_NULL(cam_screen)

/datum/camera_manager/proc/register(mob/user)
	user.client.register_map_obj(cam_background)
	user.client.register_map_obj(cam_screen)

/datum/camera_manager/proc/clear_camera()
	current_area = null
	target_x = null
	target_y = null
	target_z = null
	update_active_camera()

/datum/camera_manager/proc/set_camera_obj(obj/target, w, h)
	set_camera_rect(target.x, target.y, target.z, w, h)

/datum/camera_manager/proc/set_camera_turf(turf/target, w, h)
	set_camera_rect(target.x, target.y, target.z, w, h)

/datum/camera_manager/proc/set_camera_rect(x, y, z, w, h)
	current_area = new(x, y, w, h)
	target_x = x
	target_y = y
	target_z = z
	update_active_camera()

/**
 * Set the displayed camera to the static not-connected.
 */
/datum/camera_manager/proc/show_camera_static()
	cam_screen.vis_contents.Cut()
	last_camera_turf = null
	cam_background.icon_state = "scanline2"
	cam_background.fill_rect(1, 1, 15, 15)

/datum/camera_manager/proc/update_active_camera()
	// Show static if can't use the camera
	if(!current_area || !target_z)
		world.log << "static"
		show_camera_static()
		return

	// If we're not forcing an update for some reason and the cameras are in the same location,
	// we don't need to update anything.
	// Most security cameras will end here as they're not moving.
	var/turf/new_location = get_turf(locate(target_x, target_y, target_z))
	if(last_camera_turf == new_location)
		world.log << "same loc"
		return

	// Cameras that get here are moving, and are likely attached to some moving atom such as cyborgs.
	last_camera_turf = new_location

	var/x_size = current_area.width
	var/y_size = current_area.height
	var/target = locate(current_area.center_x, current_area.center_y, target_z)
	var/list/guncamera_zone = range("[x_size]x[y_size]", target)

	var/list/visible_turfs = list()
	range_turfs.Cut()

	for(var/turf/visible_turf in guncamera_zone)
		range_turfs += visible_turf
		var/area/visible_area = visible_turf.loc
		if(!visible_area.lighting_use_dynamic || visible_turf.lighting_lumcount >= 1)
			visible_turfs += visible_turf

	var/list/bbox = get_bbox_of_atoms(visible_turfs)
	var/size_x = bbox[3] - bbox[1] + 1
	var/size_y = bbox[4] - bbox[2] + 1
	cam_screen.icon = null
	cam_screen.icon_state = "clear"
	cam_screen.vis_contents = visible_turfs
	cam_background.icon_state = "clear"
	cam_background.fill_rect(1, 1, size_x, size_y)


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
	exproof = TRUE
	var/shuttle_tag  // Used to know which shuttle we're linked to.
	var/obj/structure/dropship_equipment/selected_equipment //the currently selected equipment installed on the shuttle this console controls.
	var/list/shuttle_equipments = list() //list of the equipments on the shuttle this console controls
	var/cavebreaker = FALSE //ignore caves and other restrictions?
	var/datum/cas_fire_envelope/firemission_envelope
	var/datum/cas_fire_mission/selected_firemission
	var/datum/cas_fire_mission/editing_firemission
	var/firemission_signal //id of the signal
	var/in_firemission_mode = FALSE
	var/upgraded = MATRIX_DEFAULT // we transport upgrade var from matrixdm
	var/matrixcol //color of matrix, only used when we upgrade to nv
	var/power //level of the property
	var/datum/cas_signal/selected_cas_signal
	var/datum/simulator/simulation
	var/datum/cas_fire_mission/configuration

	// groundside maps
	var/datum/tacmap/tacmap
	var/minimap_type = MINIMAP_FLAG_USCM

	// Cameras
	var/datum/camera_manager/cam_manager
	var/camera_target_id
	var/camera_width = 11
	var/camera_height = 11

/obj/structure/machinery/computer/dropship_weapons/Initialize()
	. = ..()
	simulation = new()
	tacmap = new(src, minimap_type)

	// camera setup
	cam_manager = new("dropship_camera_[REF(src)]_map")

/obj/structure/machinery/computer/dropship_weapons/New()
	..()
	if(firemission_envelope)
		firemission_envelope.linked_console = src

/obj/structure/machinery/computer/dropship_weapons/attack_hand(mob/user)
	if(..())
		return
	if(!allowed(user))

		// everyone can access the simulator, requested feature.
		to_chat(user, SPAN_WARNING("Weapons modification access denied, attempting to launch simulation."))

		if(!selected_firemission)
			to_chat(usr, SPAN_WARNING("Firemission must be selected before attempting to run the simulation"))
			return

		tgui_interact(user)
		return 1

	user.set_interaction(src)
	ui_interact(user)

/obj/structure/machinery/computer/dropship_weapons/attackby(obj/item/W, mob/user as mob)
	if(istype(W, /obj/item/frame/matrix_frame))
		var/obj/item/frame/matrix_frame/MATRIX = W
		if(MATRIX.state == ASSEMBLY_LOCKED)
			user.drop_held_item(W, src)
			W.forceMove(src)
			to_chat(user, SPAN_NOTICE("You swap the matrix in the dropship guidance camera system, destroying the older part in the process"))
			upgraded = MATRIX.upgrade
			matrixcol = MATRIX.matrixcol
			power = MATRIX.power

		else
			to_chat(user, SPAN_WARNING("matrix is not complete!"))

/obj/structure/machinery/computer/dropship_weapons/ui_interact(mob/user, ui_key = "main", datum/nanoui/ui = null, force_open = 0)
	var/data[0]
	var/obj/docking_port/mobile/marine_dropship/dropship = SSshuttle.getShuttle(shuttle_tag)
	if (!istype(dropship))
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
			update_location(null)

	data = ui_data(usr)
	if(!tacmap.map_holder)
		tacmap.refresh_map()
	user.client.register_map_obj(tacmap.map_holder.map)
	tgui_interact(usr)

/obj/structure/machinery/computer/dropship_weapons/tgui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if (!ui)
		cam_manager.register(user)
		ui = new(user, src, "DropshipWeaponsConsole", "Weapons Console")
		ui.open()

/obj/structure/machinery/computer/dropship_weapons/ui_close(mob/user)
	. = ..()
	if(simulation.looking_at_simulation)
		simulation.stop_watching(user)

/obj/structure/machinery/computer/dropship_weapons/ui_status(mob/user, datum/ui_state/state)
	. = ..()
	if(inoperable())
		return UI_CLOSE
	if(!faction)
		return UI_CLOSE

	var/datum/cas_iff_group/cas_group = cas_groups[faction]
	if(!cas_group)
		return UI_CLOSE

/obj/structure/machinery/computer/dropship_weapons/ui_state(mob/user)
	return GLOB.not_incapacitated_and_adjacent_strict_state

/obj/structure/machinery/computer/dropship_weapons/ui_static_data(mob/user)
	. = list()
	.["tactical_map_ref"] = tacmap.map_holder.map_ref
	.["camera_map_ref"] = cam_manager.map_name

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
	.["equipment_data"] = get_sanitised_equipment(dropship)

	// medevac targets
	var/list/stretchers = list()
	for(var/obj/structure/dropship_equipment/equipment as anything in dropship.equipments)
		if (istype(equipment, /obj/structure/dropship_equipment/medevac_system))
			var/obj/structure/dropship_equipment/medevac_system/medevac = equipment
			stretchers = medevac.get_targets()
			to_chat(usr, "found medevacs")

	.["medevac_targets"] = list()
	for(var/stretcher_ref in stretchers)
		var/obj/structure/bed/medevac_stretcher/stretcher = stretchers[stretcher_ref]
		to_chat(usr, "found [stretcher]")

		var/area/AR = get_area(stretcher)
		to_chat(usr, "at [AR]")
		var/list/target_data = list()
		target_data["area"] = AR

		var/mob/living/carbon/human/occupant = stretcher.buckled_mob
		to_chat(usr, "occupant [occupant]")
		if(occupant)
			to_chat(usr, "stretcher found [occupant]")
			target_data["occupant"] = occupant.name
			if(ishuman(occupant))
				target_data["triage_card"] = occupant.holo_card_color
		else
			to_chat(usr, "stretcher empty")

		.["medevac_targets"] += list(target_data)
		to_chat(usr, "stretcher found done")

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
		.["firemission_data"] = get_firemission_data()
		.["firemission_direction"] = get_firemission_dir()
		.["firemission_offset"] = firemission_envelope.recorded_offset
		.["firemission_message"] = firemission_envelope.firemission_status_message()
		.["firemission_name"] = selected_firemission ? selected_firemission.name : ""
		.["firemission_step"] = firemission_envelope.stat
		.["firemission_selected_laser"] = firemission_envelope.recorded_loc ? firemission_envelope.recorded_loc.get_name() : "NOT SELECTED"

		var/list/firemission_edit_timeslices = list()
		for(var/ts = 1; ts <= firemission_envelope.fire_length; ts++)
			firemission_edit_timeslices += ts
		.["firemission_edit_timeslices"] = firemission_edit_timeslices

	.["configuration"] = configuration
	.["looking"] = simulation.looking_at_simulation
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
			return TRUE

		if("select_equipment")
			var/base_tag = params["equipment_id"]
			ui_equip_interact(base_tag)
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

		if("clear-camera")
			set_camera_target(null)
			return TRUE

		if("fire-weapon")
			var/weapon_tag = params["eqp_tag"]
			var/obj/structure/dropship_equipment/weapon/DEW = get_weapon(weapon_tag)
			if(!DEW)
				return FALSE

			var/datum/cas_signal/sig = get_cas_signal(camera_target_id)

			if(!sig)
				return FALSE

			DEW.open_fire(sig.signal_loc)
			return TRUE

/obj/structure/machinery/computer/dropship_weapons/proc/get_weapon(eqp_tag)
	var/obj/docking_port/mobile/marine_dropship/dropship = SSshuttle.getShuttle(shuttle_tag)
	for(var/obj/structure/dropship_equipment/equipment in dropship.equipments)
		if(istype(equipment, /obj/structure/dropship_equipment/weapon))
			//is weapon
			selected_equipment = equipment
			return equipment

/obj/structure/machinery/computer/dropship_weapons/proc/get_cas_signal(target_ref)
	if(!target_ref)
		return

	var/datum/cas_iff_group/cas_group = cas_groups[faction]
	for(var/datum/cas_signal/sig in cas_group.cas_signals)
		if(sig.target_id == target_ref)
			return sig


/obj/structure/machinery/computer/dropship_weapons/proc/set_camera_target(target_ref)
	var/datum/cas_signal/target = get_cas_signal(target_ref)

	if(!target)
		to_chat("Failed to reference [target_ref]")
		cam_manager.show_camera_static()
		return

	cam_manager.set_camera_obj(target.linked_cam, camera_width, camera_height)
	camera_target_id = target_ref

/obj/structure/machinery/computer/dropship_weapons/proc/get_screen_mode()
	. = 0
	if(selected_equipment)
		. = selected_equipment.screen_mode
	if(editing_firemission && editing_firemission.check(src) != FIRE_MISSION_CODE_ERROR)
		. = 2
	if(selected_firemission && in_firemission_mode)
		. = 3
/obj/structure/machinery/computer/dropship_weapons/proc/get_firemission_data()
	. = list()
	var/firemission_id = 1
	for(var/datum/cas_fire_mission/firemission in firemission_envelope.missions)
		if(!istype(firemission))
			continue //the fuck
		var/error_code = firemission.check(src)

		var/selected = firemission == selected_firemission
		var/can_edit = error_code != FIRE_MISSION_CODE_ERROR && !selected

		var/can_interact = firemission_envelope.stat == FIRE_MISSION_STATE_IDLE && error_code == FIRE_MISSION_ALL_GOOD
		. += list(
			list(
				"name"= sanitize(copytext(firemission.name, 1, MAX_MESSAGE_LEN)),
				"mission_tag" = firemission_id,
				"can_edit" = can_edit,
				"can_interact" = can_interact,
				"selected" = selected
			)
		)
		firemission_id++

/obj/structure/machinery/computer/dropship_weapons/proc/get_edit_firemission_data()
	. = list()
	if(!editing_firemission)
		return
	for(var/datum/cas_fire_mission_record/firerec in editing_firemission.records)
		var/gimbal = firerec.get_offsets()
		var/ammo = firerec.get_ammo()
		var/offsets = new /list(firerec.offsets.len)
		for(var/idx = 1; idx < firerec.offsets.len; idx++)
			offsets[idx] = firerec.offsets[idx] == null ? "-" : firerec.offsets[idx]
			. += list(
				"name" = sanitize(copytext(firerec.weapon.name, 1, 50)),
				"ammo" = ammo,
				"gimbal" = gimbal,
				"offsets" = firerec.offsets
			)

/obj/structure/machinery/computer/dropship_weapons/proc/get_firemission_dir()
	var/fm_direction = dir2text(firemission_envelope.recorded_dir)
	if(!fm_direction)
		fm_direction = "NOT SELECTED"
	return fm_direction

/obj/structure/machinery/computer/dropship_weapons/proc/get_sanitised_equipment(obj/docking_port/mobile/marine_dropship/dropship)
	. = list()
	var/element_nbr = 1
	for(var/obj/structure/dropship_equipment/equipment in dropship.equipments)
		var/shorthand = equipment.name
		if(istype(equipment, /obj/structure/dropship_equipment/weapon))
			var/obj/structure/dropship_equipment/weapon/W = equipment
			shorthand = W.shorthand
		. += list(
			list(
				"name"= equipment.name,
				"shorthand" = shorthand,
				"eqp_tag" = element_nbr,
				"is_weapon" = equipment.is_weapon,
				"is_interactable" = equipment.is_interactable,
				"mount_point" = equipment.ship_base.attach_id,
				"is_missile" = istype(equipment,  /obj/structure/dropship_equipment/weapon/rocket_pod),
				"ammo_name" = equipment.ammo_equipped?.name,
				"ammo" = equipment.ammo_equipped?.ammo_count,
				"max_ammo" = equipment.ammo_equipped?.max_ammo_count
			)
		)

		element_nbr++
		equipment.linked_console = src


/obj/structure/machinery/computer/dropship_weapons/proc/get_targets()
	. = list()
	var/datum/cas_iff_group/cas_group = cas_groups[faction]
	for(var/X in cas_group.cas_signals)
		var/datum/cas_signal/LT = X
		if(!istype(LT) || !LT.valid_signal())
			continue
		var/area/laser_area = get_area(LT.signal_loc)
		. += list(
			list(
				"target_name" = "[LT.name] ([laser_area.name])",
				"target_tag" = LT.target_id
			)
		)

/obj/structure/machinery/computer/dropship_weapons/Topic(href, href_list)
	if(..())
		return

	add_fingerprint(usr)

	var/obj/docking_port/mobile/marine_dropship/dropship = SSshuttle.getShuttle(shuttle_tag)
	if (!istype(dropship))
		return

	if(href_list["open_fire"])
		var/targ_id = text2num(href_list["open_fire"])
		if(!ui_open_fire(dropship, targ_id))
			return

	if(href_list["deselect"])
		ui_deselect_equipment()

	if(href_list["create_mission"])
		if(!ui_create_firemission())
			return

	if(href_list["mission_tag_delete"])
		var/ref = text2num(href_list["mission_tag_delete"])
		if(!ui_delete_firemission(ref))
			return

	if(href_list["mission_tag"])
		var/ref = text2num(href_list["mission_tag"])
		if(!ui_select_firemission(ref))
			return

	if(href_list["mission_tag_edit"])
		var/ref = text2num(href_list["mission_tag_edit"])
		if(!ui_edit_firemission(ref))
			return

	if(href_list["leave_firemission_editing"])
		if(!ui_exit_firemission_edit())
			return

	if(href_list["switch_to_firemission"])
		if(!ui_switch_to_firemission())
			return

	if(href_list["switch_to_simulation"])
		if(!selected_firemission)
			to_chat(usr, SPAN_WARNING("Select a firemission before attempting to run the simulation"))
			return

		configuration = selected_firemission

		// simulation mode
		tgui_interact(usr)

	if(href_list["leave_firemission_execution"])
		if(!ui_leave_firemission_execution())
			return

	if(href_list["change_direction"])
		if(!ui_change_direction())
			return

	if(href_list["change_offset"])
		if(!ui_change_offset())
			return

	if(href_list["select_laser_firemission"])
		var/targ_id = text2num(href_list["select_laser_firemission"])
		ui_select_laser_firemission(dropship, targ_id)


	if(href_list["execute_firemission"])
		if(!ui_execute_firemission(dropship))
			return

	if(href_list["fm_weapon_id"])
		var/weap_ref = text2num(href_list["fm_weapon_id"])+1
		var/offset_ref = text2num(href_list["fm_offset_id"])+1
		if(!ui_fire_weapon(weap_ref, offset_ref))
			return

	if(href_list["firemission_camera"])
		if(!ui_firemission_camera(dropship))
			return

	if(href_list["cas_camera"])
		var/targ_id = text2num(href_list["cas_camera"])
		if(!ui_cas_camera(dropship, targ_id))
			return

	ui_interact(usr)

/obj/structure/machinery/computer/dropship_weapons/proc/ui_equip_interact(base_tag)
	var/obj/docking_port/mobile/marine_dropship/shuttle = SSshuttle.getShuttle(shuttle_tag)
	var/obj/structure/dropship_equipment/E = shuttle.equipments[base_tag]
	E.linked_console = src
	E.equipment_interact(usr)

/obj/structure/machinery/computer/dropship_weapons/proc/can_fire_weapon()
	var/mob/weapon_operator = usr
	if(ishuman(weapon_operator))
		var/mob/living/carbon/human/human_operator = weapon_operator
		if(!human_operator.allow_gun_usage)
			to_chat(human_operator, SPAN_WARNING("Your programming prevents you from operating dropship weaponry!"))
			return FALSE
	var/obj/structure/dropship_equipment/weapon/DEW = selected_equipment
	if(!skillcheck(weapon_operator, SKILL_PILOT, DEW.skill_required)) //only pilots can fire dropship weapons.
		to_chat(weapon_operator, SPAN_WARNING("You don't have the training to fire this weapon!"))
		return FALSE

	return TRUE

/obj/structure/machinery/computer/dropship_weapons/proc/ui_open_fire(obj/docking_port/mobile/marine_dropship/dropship, targ_id)
	var/mob/weapon_operator = usr
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

	if(!faction)
		return FALSE//no faction, no weapons

	var/datum/cas_iff_group/cas_group = cas_groups[faction]

	if(!cas_group)
		return FALSE//broken group. No fighting

	for(var/datum/cas_signal/LT in cas_group.cas_signals)
		if(LT.target_id == targ_id && LT.valid_signal())
			if(dropship.mode != SHUTTLE_CALL)
				to_chat(weapon_operator, SPAN_WARNING("Dropship can only fire while in flight."))
				return FALSE
			if(dropship.door_override)
				return FALSE
			if(!selected_equipment || !selected_equipment.is_weapon)
				to_chat(weapon_operator, SPAN_WARNING("No weapon selected."))
				return FALSE
			DEW = selected_equipment // for if the weapon somehow changes
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
				return
			if (protected_by_pylon(TURF_PROTECTION_CAS, TU))
				to_chat(weapon_operator, SPAN_WARNING("INVALID TARGET: biological-pattern interference with signal."))
				return FALSE
			if(!DEW.ammo_equipped.can_fire_at(TU, weapon_operator))
				return FALSE

			DEW.open_fire(LT.signal_loc)
			break
	return TRUE

/obj/structure/machinery/computer/dropship_weapons/proc/ui_create_firemission()
	var/mob/weapon_operator = usr
	if(!skillcheck(weapon_operator, SKILL_PILOT, SKILL_PILOT_TRAINED)) //only pilots can fire dropship weapons.
		to_chat(weapon_operator, SPAN_WARNING("A screen with graphics and walls of physics and engineering values open, you immediately force it closed."))
		return FALSE
	if(firemission_envelope.max_mission_len <= firemission_envelope.missions.len)
		to_chat(weapon_operator, SPAN_WARNING("Cannot store more than [firemission_envelope.max_mission_len] Fire Missions."))
		return FALSE
	var/fm_name = stripped_input(weapon_operator, "", "Enter Fire Mission Name", "Fire Mission [firemission_envelope.missions.len+1]", 50)
	if(!fm_name || length(fm_name) < 5)
		to_chat(weapon_operator, SPAN_WARNING("Name too short (at least 5 symbols)."))
		return FALSE
	var/fm_length = stripped_input(weapon_operator, "Enter length of the Fire Mission. Has to be less than [firemission_envelope.fire_length]. Use something that divides [firemission_envelope.fire_length] for optimal performance.", "Fire Mission Length (in tiles)", "[firemission_envelope.fire_length]", 5)
	var/fm_length_n = text2num(fm_length)
	if(!fm_length_n)
		to_chat(weapon_operator, SPAN_WARNING("Incorrect input format."))
		return FALSE
	if(fm_length_n > firemission_envelope.fire_length)
		to_chat(weapon_operator, SPAN_WARNING("Fire Mission is longer than allowed by this vehicle."))
		return FALSE
	if(firemission_envelope.stat != FIRE_MISSION_STATE_IDLE)
		to_chat(weapon_operator, SPAN_WARNING("Vehicle has to be idle to allow Fire Mission editing and creation."))
		return FALSE
	//everything seems to be fine now
	firemission_envelope.generate_mission(fm_name, fm_length_n)

/obj/structure/machinery/computer/dropship_weapons/proc/ui_delete_firemission(firemission_tag)
	var/mob/weapon_operator = usr
	if(!skillcheck(weapon_operator, SKILL_PILOT, SKILL_PILOT_TRAINED)) //only pilots can fire dropship weapons.
		to_chat(usr, SPAN_WARNING("A screen with graphics and walls of physics and engineering values open, you immediately force it closed."))
		return FALSE
	if(firemission_tag > firemission_envelope.missions.len)
		to_chat(usr, SPAN_WARNING("Fire Mission ID corrupted or already deleted."))
		return FALSE
	if(selected_firemission == firemission_envelope.missions[firemission_tag])
		to_chat(usr, SPAN_WARNING("Can't delete selected Fire Mission."))
		return FALSE
	var/result = firemission_envelope.delete_firemission(firemission_tag)
	if(result != 1)
		to_chat(usr, SPAN_WARNING("Unable to delete Fire Mission while in combat."))
		return FALSE

	return TRUE

/obj/structure/machinery/computer/dropship_weapons/proc/ui_select_firemission(firemission_tag)
	var/mob/weapon_operator = usr
	if(!skillcheck(weapon_operator, SKILL_PILOT, SKILL_PILOT_TRAINED)) //only pilots can fire dropship weapons.
		to_chat(weapon_operator, SPAN_WARNING("A screen with graphics and walls of physics and engineering values open, you immediately force it closed."))
		return FALSE
	if(firemission_tag > firemission_envelope.missions.len)
		to_chat(weapon_operator, SPAN_WARNING("Fire Mission ID corrupted or deleted."))
		return FALSE
	if(firemission_envelope.stat > FIRE_MISSION_STATE_IN_TRANSIT && firemission_envelope.stat < FIRE_MISSION_STATE_COOLDOWN)
		to_chat(weapon_operator, SPAN_WARNING("Fire Mission already underway."))
		return FALSE
	if(selected_firemission == firemission_envelope.missions[firemission_tag])
		selected_firemission = null
	else
		selected_firemission = firemission_envelope.missions[firemission_tag]
	return TRUE

/obj/structure/machinery/computer/dropship_weapons/proc/ui_deselect_equipment()
	var/mob/weapon_operator = usr
	if(!skillcheck(weapon_operator, SKILL_PILOT, SKILL_PILOT_TRAINED)) //only pilots can fire dropship weapons.
		to_chat(weapon_operator, SPAN_WARNING("A screen with graphics and walls of physics and engineering values open, you immediately force it closed."))
		return
	selected_equipment = null

/obj/structure/machinery/computer/dropship_weapons/proc/ui_edit_firemission(firemission_ref)
	var/mob/human_operator = usr
	if(!skillcheck(human_operator, SKILL_PILOT, SKILL_PILOT_TRAINED)) //only pilots can fire dropship weapons.
		to_chat(human_operator, SPAN_WARNING("A screen with graphics and walls of physics and engineering values open, you immediately force it closed."))
		return FALSE
	if(firemission_ref > firemission_envelope.missions.len)
		to_chat(human_operator, SPAN_WARNING("Fire Mission ID corrupted or deleted."))
		return FALSE
	if(selected_firemission == firemission_envelope.missions[firemission_ref])
		to_chat(human_operator, SPAN_WARNING("Can't edit selected Fire Mission."))
		return FALSE
	if(firemission_envelope.stat > FIRE_MISSION_STATE_IN_TRANSIT && firemission_envelope.stat < FIRE_MISSION_STATE_COOLDOWN)
		to_chat(human_operator, SPAN_WARNING("Fire Mission already underway."))
		return FALSE
	editing_firemission = firemission_envelope.missions[firemission_ref]
	return TRUE


/obj/structure/machinery/computer/dropship_weapons/proc/ui_exit_firemission_edit()
	editing_firemission = null
	return TRUE

/obj/structure/machinery/computer/dropship_weapons/proc/ui_switch_to_firemission()
	var/mob/weapons_operator = usr
	if(!skillcheck(weapons_operator, SKILL_PILOT, SKILL_PILOT_TRAINED)) //only pilots can fire dropship weapons.
		to_chat(weapons_operator, SPAN_WARNING("A screen with graphics and walls of physics and engineering values open, you immediately force it closed."))
		return FALSE
	in_firemission_mode = TRUE
	return TRUE

/obj/structure/machinery/computer/dropship_weapons/proc/ui_leave_firemission_execution()
	var/mob/weapons_operator = usr
	if(!skillcheck(weapons_operator, SKILL_PILOT, SKILL_PILOT_TRAINED)) //only pilots can fire dropship weapons.
		to_chat(weapons_operator, SPAN_WARNING("A screen with graphics and walls of physics and engineering values open, you immediately force it closed."))
		return FALSE
	firemission_envelope.remove_user_from_tracking(usr)
	in_firemission_mode = FALSE
	return TRUE

/obj/structure/machinery/computer/dropship_weapons/proc/ui_change_direction()
	var/mob/M = usr
	if(!skillcheck(M, SKILL_PILOT, SKILL_PILOT_TRAINED)) //only pilots can fire dropship weapons.
		to_chat(usr, SPAN_WARNING("A screen with graphics and walls of physics and engineering values open, you immediately force it closed."))
		return FALSE
	var/list/directions = list(dir2text(NORTH), dir2text(SOUTH), dir2text(EAST), dir2text(WEST))
	var/chosen = tgui_input_list(usr, "Select new Direction for the strafing run", "Select Direction", directions)

	var/chosen_dir = text2dir(chosen)
	if(!chosen_dir)
		to_chat(usr, SPAN_WARNING("Error with direction detected."))
		return FALSE

	update_direction(chosen_dir)
	return TRUE

/obj/structure/machinery/computer/dropship_weapons/proc/ui_change_offset()
	var/mob/weapons_operator = usr
	if(!skillcheck(weapons_operator, SKILL_PILOT, SKILL_PILOT_TRAINED)) //only pilots can fire dropship weapons.
		to_chat(weapons_operator, SPAN_WARNING("A screen with graphics and walls of physics and engineering values open, you immediately force it closed."))
		return FALSE

	var/chosen = stripped_input(weapons_operator, "Select Fire Mission length, from 0 to [firemission_envelope.max_offset]", "Select Offset", "[firemission_envelope.recorded_offset]", 2)
	var/chosen_offset = text2num(chosen)

	if(chosen_offset == null)
		to_chat(weapons_operator, SPAN_WARNING("Error with offset detected."))
		return FALSE

	update_offset(chosen_offset)
	return TRUE

/obj/structure/machinery/computer/dropship_weapons/proc/ui_select_laser_firemission(obj/docking_port/mobile/marine_dropship/dropship, laser)
	var/mob/weapons_operator = usr
	if(!laser)
		to_chat(usr, SPAN_WARNING("Bad Target."))
		return FALSE
	if(!skillcheck(weapons_operator, SKILL_PILOT, SKILL_PILOT_TRAINED)) //only pilots can fire dropship weapons.
		to_chat(usr, SPAN_WARNING("A screen with graphics and walls of physics and engineering values open, you immediately force it closed."))
		return FALSE
	if(firemission_envelope.stat > FIRE_MISSION_STATE_IN_TRANSIT && firemission_envelope.stat < FIRE_MISSION_STATE_COOLDOWN)
		to_chat(usr, SPAN_WARNING("Fire Mission already underway."))
		return FALSE
	if(dropship.mode != SHUTTLE_CALL)
		to_chat(usr, SPAN_WARNING("Shuttle has to be in orbit."))
		return FALSE
	var/datum/cas_iff_group/cas_group = cas_groups[faction]
	var/datum/cas_signal/cas_sig
	for(var/X in cas_group.cas_signals)
		var/datum/cas_signal/LT = X
		if(LT.target_id == laser  && LT.valid_signal())
			cas_sig = LT
	if(!cas_sig)
		to_chat(usr, SPAN_WARNING("Target lost or obstructed."))
		return FALSE

	update_location(cas_sig)
	return TRUE

/obj/structure/machinery/computer/dropship_weapons/proc/ui_fire_weapon(weapon_ref, offset_ref)
	var/mob/weapons_operator = usr
	if(!skillcheck(weapons_operator, SKILL_PILOT, SKILL_PILOT_TRAINED)) //only pilots can fire dropship weapons.
		to_chat(weapons_operator, SPAN_WARNING("A screen with graphics and walls of physics and engineering values open, you immediately force it closed."))
		return FALSE
	if(!editing_firemission)
		to_chat(weapons_operator, SPAN_WARNING("You are no longer editing Fire Mission."))
		return FALSE
	if(!editing_firemission.records || editing_firemission.records.len < weapon_ref)
		to_chat(weapons_operator, SPAN_WARNING("Weapon not found."))
		return FALSE
	var/datum/cas_fire_mission_record/record = editing_firemission.records[weapon_ref]
	if(record.offsets.len < offset_ref)
		to_chat(weapons_operator, SPAN_WARNING("Issues with offsets. You have to re-create this mission."))
		return FALSE
	if(firemission_envelope.stat > FIRE_MISSION_STATE_IN_TRANSIT && firemission_envelope.stat < FIRE_MISSION_STATE_COOLDOWN)
		to_chat(weapons_operator, SPAN_WARNING("Fire Mission already underway."))
		return FALSE
	var/list/gimb = record.get_offsets()
	var/min = gimb["min"]
	var/max = gimb["max"]
	var/offset_value = stripped_input(weapons_operator, "Enter offset for the [record.weapon.name]. It has to be between [min] and [max]. Enter '-' to remove fire order on this time stamp.", "Firing offset", "[record.offsets[offset_ref]]", 2)
	if(offset_value == null)
		return FALSE
	if(offset_value == "-")
		offset_value = "-"
	else
		offset_value = text2num(offset_value)
		if(offset_value == null)
			to_chat(weapons_operator, SPAN_WARNING("Incorrect offset value."))
			return FALSE
	var/result = firemission_envelope.update_mission(firemission_envelope.missions.Find(editing_firemission), weapon_ref, offset_ref, offset_value, TRUE)
	if(result == 0)
		to_chat(weapons_operator, SPAN_WARNING("Update caused an error: [firemission_envelope.mission_error]"))
	if(result == -1)
		to_chat(weapons_operator, SPAN_WARNING("System Error. Delete this Fire Mission."))
	return TRUE

/obj/structure/machinery/computer/dropship_weapons/proc/ui_firemission_camera(obj/docking_port/mobile/marine_dropship/dropship)
	var/mob/camera_operator = usr
	if(dropship.mode != SHUTTLE_CALL)
		to_chat(camera_operator, SPAN_WARNING("Shuttle has to be in orbit."))
		return FALSE

	if(!firemission_envelope.guidance)
		to_chat(camera_operator, SPAN_WARNING("Guidance is not selected or lost."))
		return FALSE

	firemission_envelope.add_user_to_tracking(usr)

	to_chat(camera_operator, "You peek through the guidance camera.")
	return TRUE

/obj/structure/machinery/computer/dropship_weapons/proc/ui_cas_camera(obj/docking_port/mobile/marine_dropship/dropship, target_id)
	var/mob/camera_operator = usr
	if(!ishuman(camera_operator))
		to_chat(camera_operator, SPAN_WARNING("You have no idea how to do that!"))
		return FALSE
	if(dropship.mode != SHUTTLE_CALL)
		to_chat(camera_operator, SPAN_WARNING("Shuttle has to be in orbit."))
		return FALSE

	if(!faction)
		to_chat(camera_operator, SPAN_DANGER("Bug encountered, this console doesn't have a faction set, report this to a coder!"))
		return FALSE

	var/datum/cas_iff_group/cas_group = cas_groups[faction]
	if(!cas_group)
		to_chat(camera_operator, SPAN_DANGER("Bug encountered, no CAS group exists for this console, report this to a coder!"))
		return FALSE

	for(var/datum/cas_signal/LT as anything in cas_group.cas_signals)
		if(LT.target_id == target_id && LT.valid_signal())
			selected_cas_signal = LT
			break

	if(!selected_cas_signal)
		to_chat(camera_operator, SPAN_WARNING("Target lost or obstructed."))
		return FALSE
	if(selected_cas_signal && selected_cas_signal.linked_cam)
		selected_cas_signal.linked_cam.view_directly(camera_operator)
	else
		to_chat(camera_operator, SPAN_WARNING("Error!"))
		return FALSE
	give_action(camera_operator, /datum/action/human_action/cancel_view)
	RegisterSignal(camera_operator, COMSIG_MOB_RESET_VIEW, PROC_REF(remove_from_view))
	RegisterSignal(camera_operator, COMSIG_MOB_RESISTED, PROC_REF(remove_from_view))
	firemission_envelope.apply_upgrade(camera_operator)
	to_chat(camera_operator, SPAN_NOTICE("You peek through the guidance camera."))
	return TRUE

/obj/structure/machinery/computer/dropship_weapons/proc/ui_execute_firemission(obj/docking_port/mobile/marine_dropship/dropship)
	var/mob/weapon_operator = usr
	if(ishuman(weapon_operator))
		var/mob/living/carbon/human/human_operator = weapon_operator
		if(!human_operator.allow_gun_usage)
			to_chat(human_operator, SPAN_WARNING("Your programming prevents you from operating dropship weaponry!"))
			return FALSE
	if(!skillcheck(weapon_operator, SKILL_PILOT, SKILL_PILOT_TRAINED)) //only pilots can fire dropship weapons.
		to_chat(usr, SPAN_WARNING("A screen with graphics and walls of physics and engineering values open, you immediately force it closed."))
		return FALSE
	if(firemission_envelope.stat != FIRE_MISSION_STATE_IDLE)
		to_chat(usr, SPAN_WARNING("Fire Mission already underway."))
		return FALSE
	if(dropship.mode != SHUTTLE_CALL)
		to_chat(usr, SPAN_WARNING("Shuttle has to be in orbit."))
		return FALSE
	if(!firemission_envelope.recorded_loc)
		to_chat(usr, SPAN_WARNING("Target is not selected or lost."))
		return FALSE

	initiate_firemission()
	return TRUE


/obj/structure/machinery/computer/dropship_weapons/proc/remove_from_view(mob/living/carbon/human/user)
	UnregisterSignal(user, COMSIG_MOB_RESET_VIEW)
	UnregisterSignal(user, COMSIG_MOB_RESISTED)
	if(selected_cas_signal && selected_cas_signal.linked_cam)
		selected_cas_signal.linked_cam.remove_from_view(user)
	firemission_envelope.remove_upgrades(user)

/obj/structure/machinery/computer/dropship_weapons/proc/initiate_firemission()
	set waitfor = 0
	var/obj/docking_port/mobile/marine_dropship/dropship = SSshuttle.getShuttle(shuttle_tag)
	if (!istype(dropship))
		return
	if (dropship.timer && dropship.timeLeft(1) < firemission_envelope.get_total_duration())
		to_chat(usr, "Not enough time to complete the Fire Mission")
		return
	if (!dropship.in_flyby || dropship.mode != SHUTTLE_CALL)
		to_chat(usr, "Has to be in Fly By mode")
		return

	var/fmid = firemission_envelope.missions.Find(selected_firemission)
	if(!fmid)
		to_chat(usr, "No Firemission selected")
		return

	var/result = firemission_envelope.execute_firemission(firemission_envelope.recorded_loc, firemission_envelope.recorded_offset, firemission_envelope.recorded_dir, fmid)
	if(result<1)
		to_chat(usr, "Screen beeps with an error: "+ firemission_envelope.mission_error)
	else
		update_trace_loc()

/obj/structure/machinery/computer/dropship_weapons/proc/update_offset(new_offset)
	var/result = firemission_envelope.change_offset(new_offset)
	if(result<1)
		to_chat(usr, "Screen beeps with an error: "+ firemission_envelope.mission_error)
	else
		update_trace_loc()

/obj/structure/machinery/computer/dropship_weapons/proc/update_location(new_location)
	var/result = firemission_envelope.change_target_loc(new_location)
	if(result<1)
		to_chat(usr, "Screen beeps with an error: "+ firemission_envelope.mission_error)
	else
		update_trace_loc()


/obj/structure/machinery/computer/dropship_weapons/proc/update_direction(new_direction)
	var/result = firemission_envelope.change_direction(new_direction)
	if(result<1)
		to_chat(usr, "Screen beeps with an error: " + firemission_envelope.mission_error)
	else
		update_trace_loc()

/obj/structure/machinery/computer/dropship_weapons/on_unset_interaction(mob/user)
	..()
	if(firemission_envelope && firemission_envelope.guidance)
		firemission_envelope.remove_user_from_tracking(user)

/obj/structure/machinery/computer/dropship_weapons/proc/update_trace_loc()
	if(!firemission_envelope)
		return
	if(firemission_envelope.recorded_loc == null || firemission_envelope.recorded_dir == null || firemission_envelope.recorded_offset == null)
		return
	if(firemission_envelope.recorded_loc.obstructed_signal())
		if(firemission_envelope.user_is_guided(usr))
			to_chat(usr, SPAN_WARNING("Signal Obstructed. You have to go in blind."))
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
		if(firemission_envelope.user_is_guided(usr))
			to_chat(usr, SPAN_WARNING("Vision Obstructed. You have to go in blind."))
		firemission_envelope.change_current_loc()
	else
		firemission_envelope.change_current_loc(shootloc)

/obj/structure/machinery/computer/dropship_weapons/dropship1
	name = "\improper 'Alamo' weapons controls"
	req_one_access = list(ACCESS_MARINE_LEADER, ACCESS_MARINE_DROPSHIP, ACCESS_WY_CORPORATE)
	firemission_envelope = new /datum/cas_fire_envelope/uscm_dropship()

/obj/structure/machinery/computer/dropship_weapons/dropship1/New()
	..()
	shuttle_tag = DROPSHIP_ALAMO

/obj/structure/machinery/computer/dropship_weapons/dropship2
	name = "\improper 'Normandy' weapons controls"
	req_one_access = list(ACCESS_MARINE_LEADER, ACCESS_MARINE_DROPSHIP, ACCESS_WY_CORPORATE)
	firemission_envelope = new /datum/cas_fire_envelope/uscm_dropship()

/obj/structure/machinery/computer/dropship_weapons/dropship2/New()
	..()
	shuttle_tag = DROPSHIP_NORMANDY

/obj/structure/machinery/computer/dropship_weapons/Destroy()
	. = ..()
	QDEL_NULL(cam_manager)
	QDEL_NULL(firemission_envelope)
	QDEL_NULL(tacmap)

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
