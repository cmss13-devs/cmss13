/obj/deployer
	density = FALSE
	opacity = FALSE
	invisibility = 101
	mouse_opacity = MOUSE_OPACITY_TRANSPARENT
	flags_atom = NO_ZFALL
	unacidable = TRUE
	explo_proof = TRUE

/obj/deployer/shuttle/dropship
	icon = 'icons/obj/structures/machinery/omaha/misc.dmi'
	icon_state = "deployer"
	var/obj/docking_port/mobile/marine_dropship/linked_dropship
	var/item_to_deploy

/obj/deployer/shuttle/dropship/afterShuttleMove(turf/oldT, list/movement_force, shuttle_dir, shuttle_preferred_direction, move_dir, rotation)
	. = ..()
	if(is_reserved_level(src.z))
		return
	if(linked_dropship.is_hijacked)
		return

/obj/deployer/shuttle/dropship/ramp_button
	var/obj/structure/machinery/door_control/dropship_ramp_dummy/linked_button
	item_to_deploy = /obj/structure/machinery/door_control/dropship_ramp_dummy

/obj/deployer/shuttle/dropship/ramp_button/omaha
	item_to_deploy = /obj/structure/machinery/door_control/dropship_ramp_dummy/omaha_aft
/obj/deployer/shuttle/dropship/ramp_button/midway
	item_to_deploy = /obj/structure/machinery/door_control/dropship_ramp_dummy/midway_aft

/obj/deployer/shuttle/dropship/ramp_button/afterShuttleMove(turf/oldT, list/movement_force, shuttle_dir, shuttle_preferred_direction, move_dir, rotation)
	. = ..()
	if(linked_button)
		linked_button.loc = SSmapping.get_turf_below(src.loc)
		linked_button.pixel_y = 16
	else
		for(var/obj/structure/machinery/door_control/shuttle_ramp/original_button in range(8, src.loc))
			linked_button = new item_to_deploy(SSmapping.get_turf_below(src.loc))
			linked_button.pixel_y = 16
			linked_button.layer = FLY_LAYER
			linked_button.alpha = 215
			linked_button.linked_dropship = original_button.linked_dropship
			linked_button.linked_ramp_control = original_button
			linked_button.linked_single_controller = original_button.linked_single_controller //
			break

/obj/deployer/shuttle/dropship/belly
	var/obj/structure/shuttle/part/fuel_lines/lines
	item_to_deploy = /obj/structure/shuttle/part/fuel_lines

/obj/deployer/shuttle/dropship/belly/omaha
	item_to_deploy = /obj/structure/shuttle/part/fuel_lines/omaha
/obj/deployer/shuttle/dropship/belly/midway
	item_to_deploy = /obj/structure/shuttle/part/fuel_lines/midway

/obj/deployer/shuttle/dropship/belly/lateShuttleMove()
	.=..()
	if(is_reserved_level(src.z))
		if(lines)
			lines.moveToNullspace()
		return
	var/turf/target_turf = locate(src.x-5, src.y, src.z)
	if(target_turf)
		var/turf/final_turf = SSmapping.get_turf_below(target_turf)
		if(final_turf)
			if(lines)
				lines.loc = final_turf
			else
				lines = new item_to_deploy(final_turf)

/obj/deployer/shuttle/dropship/landing_gear
	var/offset_x = -16
	var/offset_y = -19
	var/map_offset_x
	var/map_offset_y
	var/obj/structure/shuttle/part/dropship_omaha/landing_gear_big/land_gear
	var/obj/structure/shuttle/part/dropship_omaha/landing_hatch_big/hatch_big
	item_to_deploy = /obj/structure/shuttle/part/dropship_omaha/landing_gear_big
	var/item_to_deploy2 = /obj/structure/shuttle/part/dropship_omaha/landing_hatch_big

/obj/deployer/shuttle/dropship/landing_gear/omaha
	item_to_deploy = /obj/structure/shuttle/part/dropship_omaha/landing_gear_big/omaha
	item_to_deploy2 = /obj/structure/shuttle/part/dropship_omaha/landing_hatch_big/omaha

/obj/deployer/shuttle/dropship/landing_gear/midway
	item_to_deploy = /obj/structure/shuttle/part/dropship_omaha/landing_gear_big/midway
	item_to_deploy2 = /obj/structure/shuttle/part/dropship_omaha/landing_hatch_big/midway

/obj/deployer/shuttle/dropship/landing_gear/lateShuttleMove(turf/oldT, list/movement_force, move_dir)
	. = ..()
	if(is_reserved_level(src.z))
		if(land_gear)
			land_gear.moveToNullspace()
		if(hatch_big)
			hatch_big.moveToNullspace()
		return
	var/turf/open/t_below = SSmapping.get_turf_below(src.loc)
	if(t_below)
		var/turf/open/final_turf = locate(t_below.x + map_offset_x, t_below.y +map_offset_y, t_below.z)
		if(land_gear)
			land_gear.loc = final_turf
		else
			land_gear = new item_to_deploy(final_turf)
			land_gear.dir = src.dir
		if(hatch_big)
			hatch_big.loc = final_turf
		else
			hatch_big = new item_to_deploy2(final_turf)
			hatch_big.dir = src.dir
			hatch_big.pixel_x = offset_x
			hatch_big.pixel_y = offset_y

/obj/deployer/shuttle/dropship/fuel_attachment_point
	var/obj/effect/attach_point/linked_point
	var/offset_x
	var/offset_y

/obj/deployer/shuttle/dropship/fuel_attachment_point/omaha
	item_to_deploy = /obj/effect/attach_point/fuel/dropship_omaha

/obj/deployer/shuttle/dropship/fuel_attachment_point/midway
	item_to_deploy = /obj/effect/attach_point/fuel/dropship_midway

/obj/deployer/shuttle/dropship/fuel_attachment_point/lateShuttleMove(turf/oldT, list/movement_force, move_dir)
	. = ..()
	if(is_reserved_level(src.z))
		if(linked_point)
			linked_point.moveToNullspace()
		if(linked_point.installed_equipment)
			linked_point.installed_equipment.moveToNullspace()
		return

	var/turf/open/t_below = SSmapping.get_turf_below(src.loc)
	if(t_below)
		if(linked_point)
			linked_point.loc = t_below
			if(linked_point.installed_equipment)
				linked_point.installed_equipment.loc = t_below
		else
			linked_point = new item_to_deploy(t_below)
			linked_point.layer = FLY_LAYER + 0.01
			linked_point.alpha = 225
			linked_point.pixel_x = offset_x
			linked_point.pixel_y = offset_y

/obj/deployer/shuttle/dropship/hardpoints
	var/obj/effect/attach_point_dummy/linked_bottom
	var/map_offset_x
	var/map_offset_y
	var/offset_x
	var/offset_y

/obj/deployer/shuttle/dropship/hardpoints/omaha
	item_to_deploy = /obj/effect/attach_point_dummy/omaha

/obj/deployer/shuttle/dropship/hardpoints/midway
	item_to_deploy = /obj/effect/attach_point_dummy/midway

/obj/deployer/shuttle/dropship/hardpoints/afterShuttleMove(turf/oldT, list/movement_force, shuttle_dir, shuttle_preferred_direction, move_dir, rotation)
	. = ..()
	if(is_reserved_level(src.z))
		if(linked_bottom)
			linked_bottom.moveToNullspace()
			return
	var/turf/open/t_below =  SSmapping.get_turf_below(src.loc)
	if(t_below)
		var/turf/open/target_turf = locate(loc.x + map_offset_x, loc.y + map_offset_y, t_below.z)
		if(linked_bottom)
			linked_bottom.loc = target_turf
		else
			linked_bottom = new item_to_deploy(target_turf)
			linked_bottom.layer = FLY_LAYER + 0.01
			for(var/obj/effect/attach_point/attachie in src.loc.contents)
				linked_bottom.linked_attach_point = attachie
				linked_bottom.name = linked_bottom.linked_attach_point.name
				attachie.linked_bottom_point = linked_bottom
				linked_bottom.pixel_x = offset_x
				linked_bottom.pixel_y = offset_y
				break

/obj/deployer/shuttle/dropship/gibber

/obj/deployer/shuttle/dropship/gibber/afterShuttleMove(turf/newT, rotation, move_mode, obj/docking_port/mobile/moving_dock)
	. = ..()
	var/turf/turf_below = SSmapping.get_turf_below(src.loc)
	if(turf_below)
		for(var/i in turf_below.contents)
			var/atom/movable/thing = i
			turf_below.shuttleCrushThing(thing, moving_dock)
