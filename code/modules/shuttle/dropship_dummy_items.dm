/obj/deployer
	density = FALSE
	opacity = FALSE
	invisibility = 101
	mouse_opacity = MOUSE_OPACITY_TRANSPARENT
	flags_atom = NO_ZFALL
	unacidable = TRUE
	explo_proof = TRUE
	anchored = TRUE

/obj/deployer/shuttle/dropship
	icon = 'icons/obj/structures/machinery/omaha/misc.dmi'
	icon_state = "deployer"
	var/obj/docking_port/mobile/marine_dropship/linked_dropship
	var/item_to_deploy
	var/list/linked_items = list()

/obj/deployer/shuttle/dropship/afterShuttleMove(turf/oldT, list/movement_force, shuttle_dir, shuttle_preferred_direction, move_dir, rotation)
	. = ..()

	if(is_reserved_level(src.z))
		if(length(linked_items))
			for(var/obj/items in linked_items)
				items.moveToNullspace()
			return

	if(linked_dropship?.is_hijacked)
		if(length(linked_items))
			for(var/obj/items in linked_items)
				items.moveToNullspace()
			return

/obj/deployer/shuttle/dropship/lateShuttleMove(turf/oldT, list/movement_force, move_dir)
	. = ..()

	if(is_reserved_level(src.z))
		if(length(linked_items))
			for(var/obj/items in linked_items)
				items.moveToNullspace()
			return

	if(linked_dropship.is_hijacked)
		if(length(linked_items))
			for(var/obj/items in linked_items)
				items.moveToNullspace()
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
			linked_items += linked_button
			linked_button.pixel_y = 16
			linked_button.layer = FLY_LAYER
			linked_button.alpha = 215
			linked_button.linked_dropship = original_button.linked_dropship
			linked_button.linked_ramp_control = original_button
			linked_button.linked_single_controller = original_button.linked_single_controller
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
	var/turf/target_turf = locate(src.x-5, src.y, src.z)
	if(target_turf)
		var/turf/final_turf = SSmapping.get_turf_below(target_turf)
		if(final_turf)
			if(lines)
				lines.loc = final_turf
			else
				lines = new item_to_deploy(final_turf)
				linked_items += lines

/obj/deployer/shuttle/dropship/landing_gear
	var/offset_x = -16
	var/offset_y = -19
	var/map_offset_x
	var/map_offset_y
	var/obj/structure/shuttle/part/dropship_mohawk/landing_gear_big/land_gear
	var/obj/structure/shuttle/part/dropship_mohawk/landing_hatch_big/hatch_big
	item_to_deploy = /obj/structure/shuttle/part/dropship_mohawk/landing_gear_big
	var/item_to_deploy2 = /obj/structure/shuttle/part/dropship_mohawk/landing_hatch_big

/obj/deployer/shuttle/dropship/landing_gear/omaha
	item_to_deploy = /obj/structure/shuttle/part/dropship_mohawk/landing_gear_big/omaha
	item_to_deploy2 = /obj/structure/shuttle/part/dropship_mohawk/landing_hatch_big/omaha

/obj/deployer/shuttle/dropship/landing_gear/midway
	item_to_deploy = /obj/structure/shuttle/part/dropship_mohawk/landing_gear_big/midway
	item_to_deploy2 = /obj/structure/shuttle/part/dropship_mohawk/landing_hatch_big/midway

/obj/deployer/shuttle/dropship/landing_gear/lateShuttleMove(turf/oldT, list/movement_force, move_dir)
	. = ..()
	var/turf/open/t_below = SSmapping.get_turf_below(src.loc)
	if(t_below)
		var/turf/open/final_turf = locate(t_below.x + map_offset_x, t_below.y +map_offset_y, t_below.z)
		if(land_gear)
			land_gear.loc = final_turf
		else
			land_gear = new item_to_deploy(final_turf)
			linked_items += land_gear
			land_gear.dir = src.dir
		if(hatch_big)
			hatch_big.loc = final_turf
		else
			hatch_big = new item_to_deploy2(final_turf)
			linked_items += hatch_big
			hatch_big.dir = src.dir
			hatch_big.pixel_x = offset_x
			hatch_big.pixel_y = offset_y

/obj/deployer/shuttle/dropship/fuel_attachment_point
	name = "fuel attachment p. deployer"
	icon_state = "deployer_fuel"
	var/obj/effect/attach_point/linked_point
	var/offset_x
	var/offset_y

/obj/deployer/shuttle/dropship/fuel_attachment_point/omaha
	item_to_deploy = /obj/effect/attach_point/fuel/dropship_omaha

/obj/deployer/shuttle/dropship/fuel_attachment_point/midway
	item_to_deploy = /obj/effect/attach_point/fuel/dropship_midway

/obj/deployer/shuttle/dropship/fuel_attachment_point/lateShuttleMove(turf/oldT, list/movement_force, move_dir)
	. = ..()
	var/turf/open/t_below = SSmapping.get_turf_below(src.loc)
	if(t_below)
		if(linked_point)
			linked_point.loc = t_below
			if(linked_point.installed_equipment)
				linked_point.installed_equipment.loc = t_below
		else
			linked_point = new item_to_deploy(t_below)
			linked_items += linked_point
			linked_point.layer = FLY_LAYER + 0.01
			linked_point.alpha = 225
			linked_point.pixel_x = offset_x
			linked_point.pixel_y = offset_y

/obj/deployer/shuttle/dropship/hardpoints
	icon_state = "deployer_gun"
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
	var/turf/open/t_below =  SSmapping.get_turf_below(src.loc)
	if(t_below)
		var/turf/open/target_turf = locate(loc.x + map_offset_x, loc.y + map_offset_y, t_below.z)
		if(linked_bottom)
			linked_bottom.loc = target_turf
		else
			linked_bottom = new item_to_deploy(target_turf)
			linked_items += linked_bottom
			linked_bottom.layer = FLY_LAYER + 0.01
			for(var/obj/effect/attach_point/attachie in src.loc.contents)
				linked_bottom.linked_attach_point = attachie
				linked_bottom.name = linked_bottom.linked_attach_point.name
				attachie.linked_bottom_point = linked_bottom
				linked_bottom.pixel_x = offset_x
				linked_bottom.pixel_y = offset_y
				break

/obj/deployer/shuttle/dropship/gibber
	icon_state = "deployer_gibber"

/obj/deployer/shuttle/dropship/gibber/afterShuttleMove(turf/newT, rotation, move_mode, obj/docking_port/mobile/moving_dock)
	. = ..()
	var/turf/turf_below = SSmapping.get_turf_below(src.loc)
	if(turf_below)
		for(var/i in turf_below.contents)
			var/atom/movable/thing = i
			turf_below.shuttleCrushThing(thing, moving_dock)

/obj/effect/drosphip_ramp_shadow
	icon = 'icons/obj/structures/machinery/omaha/shadow.dmi'
	icon_state = "shadowblast"
	unacidable = TRUE
	anchored = TRUE
	mouse_opacity = MOUSE_OPACITY_TRANSPARENT
	opacity = FALSE
	density = FALSE
	flags_atom = NO_ZFALL

/obj/effect/drosphip_ramp_shadow/proc/set_icon_state(raise = TRUE)
	if(raise)
		icon_state = "shadowblast_raise"
		addtimer(CALLBACK(src, PROC_REF(finish_raising)), 30,  TIMER_UNIQUE|TIMER_OVERRIDE|TIMER_NO_HASH_WAIT)
	else
		icon_state = "shadowblast_lower"
		addtimer(CALLBACK(src, PROC_REF(finish_lowering)), 30,  TIMER_UNIQUE|TIMER_OVERRIDE|TIMER_NO_HASH_WAIT)

/obj/effect/drosphip_ramp_shadow/proc/finish_raising()
	icon_state = "shadowblast_kill"

/obj/effect/drosphip_ramp_shadow/proc/finish_lowering()
	icon_state = "shadowblast"

/// ramp ///

/obj/deployer/shuttle/dropship/dummy_part // used to manipulate turfs, since we can't move them
	icon = 'icons/turf/floors/floors.dmi'
	icon_state = "noop"
	var/mode = ""
	opacity = FALSE
	density = FALSE
	invisibility = 101
	mouse_opacity = MOUSE_OPACITY_TRANSPARENT
	can_block_movement = FALSE
	flags_atom = NO_ZFALL
	var/turf/open/stored_turf
	var/stored_icon_state
	var/obj/structure/stairs/linked_staircase
	var/obj/structure/shuttle/part/linked_structure_ramp
	var/structure_deploy
	var/stairs_deploy_up
	var/stairs_deploy_down
	var/shadowblaster
	var/obj/effect/drosphip_ramp_shadow/shadowblast

/obj/deployer/shuttle/dropship/dummy_part/omaha
	item_to_deploy = /turf/closed/shuttle/dropship_omaha
	structure_deploy = /obj/structure/shuttle/part/dropship_omaha/structure_ramp
	stairs_deploy_up = /obj/structure/stairs/multiz/up/dropship_ramp/omaha
	stairs_deploy_down = /obj/structure/stairs/multiz/down/dropship_ramp/omaha

/obj/deployer/shuttle/dropship/dummy_part/omaha/adjustable_first
	mode = "first"

/obj/deployer/shuttle/dropship/dummy_part/omaha/adjustable_second
	mode = "second"

/obj/deployer/shuttle/dropship/dummy_part/omaha/adjustable_third
	mode = "third"

/obj/deployer/shuttle/dropship/dummy_part/omaha/adjustable_fourth
	mode = "fourth"

/obj/deployer/shuttle/dropship/dummy_part/omaha/adjustable_fifth
	mode = "fifth"

/obj/deployer/shuttle/dropship/dummy_part/midway
	item_to_deploy = /turf/closed/shuttle/dropship_midway
	structure_deploy = /obj/structure/shuttle/part/dropship_midway/structure_ramp
	stairs_deploy_up = /obj/structure/stairs/multiz/up/dropship_ramp/midway
	stairs_deploy_down = /obj/structure/stairs/multiz/down/dropship_ramp/midway

/obj/deployer/shuttle/dropship/dummy_part/midway/adjustable_first
	mode = "first"

/obj/deployer/shuttle/dropship/dummy_part/midway/adjustable_second
	mode = "second"

/obj/deployer/shuttle/dropship/dummy_part/midway/adjustable_third
	mode = "third"

/obj/deployer/shuttle/dropship/dummy_part/midway/adjustable_fourth
	mode = "fourth"

/obj/deployer/shuttle/dropship/dummy_part/midway/adjustable_fifth
	mode = "fifth"

/obj/deployer/shuttle/dropship/m90_minigun
	icon = 'icons/obj/structures/machinery/midway/misc_96x96.dmi'
	icon_state = "m90_minigun_deployer"
	item_to_deploy = /obj/structure/dropship_equipment/weapon/m90_minigun
	invisibility = 0
	layer = UNDER_TURF_LAYER
	var/obj/structure/dropship_equipment/weapon/m90_minigun/linked_m90

/obj/deployer/shuttle/dropship/m90_minigun/lateShuttleMove(turf/oldT, list/movement_force, move_dir)
	. = ..()
	var/turf/turf_below = SSmapping.get_turf_below(src.loc)
	if(turf_below)
		if(linked_m90)
			linked_m90.loc = turf_below
		else
			linked_m90 = new item_to_deploy(turf_below)
			linked_m90.linked_shuttle = src.linked_dropship
			linked_m90.linked_shuttle.equipments += linked_m90
			linked_items += linked_m90
			linked_m90.pixel_x = pixel_x
			linked_m90.pixel_y = pixel_y

/obj/deployer/shuttle/dropship/roof_loader
	var/list/linked_fauxes = list()
	var/datum/map_template/shuttle_roof/roof_template
	var/template_preset = "abstract"
	var/deployed_already = FALSE
	var/our_glob_list

	item_to_deploy = /turf/open/shuttle/dropship/midway/basic/invisible
	var/item_to_deploy2 = /turf/open/shuttle/dropship/midway/openspace

/obj/deployer/shuttle/dropship/roof_loader/omaha
	template_preset = "omaha"
	item_to_deploy = /turf/open/shuttle/dropship/omaha/basic/invisible

/obj/deployer/shuttle/dropship/roof_loader/omaha/Initialize()
	. = ..()
	our_glob_list = GLOB.omaha_roof_fauxes

/obj/deployer/shuttle/dropship/roof_loader/midway
	template_preset = "midway"
	item_to_deploy = /turf/open/shuttle/dropship/midway/basic/invisible

/obj/deployer/shuttle/dropship/roof_loader/midway/Initialize()
	. = ..()
	our_glob_list = GLOB.midway_roof_fauxes

/obj/deployer/shuttle/dropship/roof_loader/Initialize()
	. = ..()
	set_template(SSmapping.shuttle_roof_templates[template_preset])
	debug_chat("template name is [roof_template.name]")

/obj/deployer/shuttle/dropship/roof_loader/proc/set_template(datum/map_template/new_template)
	if(!istype(new_template))
		return
	roof_template = new_template
	debug_chat("template name is [roof_template.name]")

/obj/deployer/shuttle/dropship/roof_loader/beforeShuttleMove(turf/newT, rotation, move_mode, obj/docking_port/mobile/moving_dock)
	. = ..()
	if(deployed_already)
		if(is_ground_level(src.z) || linked_dropship.is_hijacked && !is_reserved_level(src.z))
			var/turf/our_loc
			for(var/obj/fauxie in linked_fauxes)
				our_loc = fauxie.loc
				our_loc.ScrapeAway()
				addtimer(CALLBACK(our_loc, TYPE_PROC_REF(/turf/open, update_vis_contents)), 3) // idk, calling an update after movetonullspace also doesnt work but timer i find working all the time
				fauxie.moveToNullspace()

/obj/deployer/shuttle/dropship/roof_loader/lateShuttleMove(turf/oldT, list/movement_force, move_dir)
	.=..()
	if(is_ground_level(src.z) || linked_dropship.is_hijacked)
		var/turf/target_turf = SSmapping.get_turf_above(src.loc)
		if(target_turf)
			if(deployed_already)
				move_into_position(target_turf)
				place_walkable()
				crush_shit()
				update_visuals()
			else
				roof_template.load(target_turf, TRUE, FALSE)
				setup_link()
				update_fauxes_icons()
				place_walkable()
				crush_shit()
				update_visuals()
				deployed_already = TRUE

/obj/deployer/shuttle/dropship/roof_loader/proc/setup_link()
	var/turf/turf_above = SSmapping.get_turf_above(src.loc)
	if(turf_above)
		for(var/obj/faux_turf/open/dropship/roof/our_faux in range(12, turf_above))
			linked_fauxes += our_faux
			our_faux.recorded_offset_X = our_faux.x - src.x
			our_faux.recorded_offset_Y = our_faux.y - src.y

/obj/deployer/shuttle/dropship/roof_loader/proc/update_fauxes_icons()
	var/count_X = 0
	var/count_Y = 0
	for(var/obj/faux_turf/open/dropship/roof/fauxie in our_glob_list)
		fauxie.icon_state = "[count_X],[count_Y]"
		count_X ++
		if(count_X == 17)
			count_X = 0
			count_Y ++
	for(var/obj/faux_turf/open/dropship/roof/empty_space/useless in linked_fauxes)
		linked_fauxes -= useless
		our_glob_list -= useless
		QDEL_NULL(useless)

/obj/deployer/shuttle/dropship/roof_loader/proc/place_walkable()
	var/obj/faux_turf/open/dropship/roof/solid/snake
	var/obj/faux_turf/open/dropship/roof/edge/runner
	var/obj/faux_turf/open/dropship/roof/canopy/canopius
	var/turf/turf_loc
	for(snake in linked_fauxes)
		turf_loc = snake.loc
		turf_loc.place_on_top(item_to_deploy)
	for(runner in linked_fauxes)
		turf_loc = runner.loc
		if(istransparentturf(turf_loc))
			turf_loc.place_on_top(item_to_deploy2)
		else
			turf_loc.ScrapeAway() // just so that there's a bit of a gradeint being like tiled floor and then goes like plating, its gon look better this way trust me
	for(canopius in linked_fauxes)
		turf_loc = canopius.loc
		turf_loc.place_on_top(item_to_deploy2)

/obj/deployer/shuttle/dropship/roof_loader/proc/crush_shit()
	var/obj/docking_port/moving_dock = src.linked_dropship
	var/turf/our_loc
	for(var/obj/fauxie in linked_fauxes)
		our_loc = fauxie.loc
		for(var/i in our_loc.contents) // yeah zone
			var/atom/movable/thing = i
			our_loc.shuttleCrushThing(thing, moving_dock)

/obj/deployer/shuttle/dropship/roof_loader/proc/update_visuals()
	var/turf/our_loc
	for(var/obj/fauxie in linked_fauxes)
		our_loc = fauxie.loc
		our_loc.update_vis_contents()

/obj/deployer/shuttle/dropship/roof_loader/proc/move_into_position(turf/target_turf)
	for(var/obj/faux_turf/open/dropship/roof/fauxie in linked_fauxes)
		fauxie.loc = locate(src.x + fauxie.recorded_offset_X, src.y + fauxie.recorded_offset_Y, target_turf.z)
