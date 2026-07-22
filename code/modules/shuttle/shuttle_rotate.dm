/*
All shuttleRotate procs go here

If ever any of these procs are useful for non-shuttles, rename it to proc/rotate and move it to be a generic atom proc
*/

/* ***********************************Base proc*********************************** */

/atom/proc/shuttleRotate(rotation, params=ROTATE_DIR|ROTATE_SMOOTH|ROTATE_OFFSET)
	if(params & ROTATE_DIR)
		//rotate our direction
		setDir(angle2dir(rotation+dir2angle(dir)))

	//resmooth if need be.
// if(smooth && (params & ROTATE_SMOOTH))
// queue_smooth(src)

	//rotate the pixel offsets too.
	if((pixel_x || pixel_y) && (params & ROTATE_OFFSET))
		if(rotation < 0)
			rotation += 360
		for(var/turntimes=rotation/90;turntimes>0;turntimes--)
			var/oldPX = pixel_x
			var/oldPY = pixel_y
			pixel_x = oldPY
			pixel_y = (oldPX*(-1))

/atom/proc/adjust_rotatables()
	return

/obj/effect/attach_point/fuel/adjust_rotatables()
	var/obj/effect/attach_point/fuel/naked_slot = src
	switch(naked_slot.dir)
		if(1)
			if(naked_slot.adjusted_pixel)
				naked_slot.pixel_x = -32
			else
				naked_slot.pixel_x = 0
			naked_slot.pixel_y = 0
		if(2)
			if(naked_slot.adjusted_pixel)
				naked_slot.pixel_x = 0
			else
				naked_slot.pixel_x = -32
			naked_slot.pixel_y = -8
		if(4)
			if(naked_slot.adjusted_pixel)
				naked_slot.pixel_y = 8
			else
				naked_slot.pixel_y = -24
			naked_slot.pixel_x = -6
		if(8)
			if(naked_slot.adjusted_pixel)
				naked_slot.pixel_y = -24
			else
				naked_slot.pixel_y = 8
			naked_slot.pixel_x = -26
	if(naked_slot.installed_equipment)
		naked_slot.installed_equipment.setDir(naked_slot)
		naked_slot.installed_equipment.pixel_y = naked_slot.pixel_y
		naked_slot.installed_equipment.pixel_x = naked_slot.pixel_x

/obj/structure/bed/chair/vehicle/adjust_rotatables()
	if(dir == 4 || dir == 8) //8
		pixel_x = 0
		pixel_y = init_pixel_x + 8
		buckle_offset_y = pixel_y
		buckle_offset_x = pixel_x
		if(pixel_y == 8)
			higher_layer = TRUE
	else
		pixel_y = 0
		pixel_x = init_pixel_x
		buckle_offset_x = pixel_x
		buckle_offset_y = pixel_y
		higher_layer = FALSE
	if(buckled_mob)
		buckled_mob.pixel_y = pixel_y
		buckled_mob.pixel_x = pixel_x
	handle_rotation()

/obj/structure/machinery/door/airlock/multi_tile/almayer/dropshiprear/adjust_rotatables() // look up locs list
	var/turf/open/shuttle/dropship/air
	var/old_dir = src.dir
	var/list/old_locs = src.locs
	switch(src.id)
		if("aft_door")
			if(src.dir == 4 || src.dir == 8)
				air = get_step(get_step(src.loc, WEST), WEST)
				if(air && istype(air, /turf/open/shuttle/dropship/medium_grey_single_wide_up_to_down/airlock))
					src.Move(air)
				else
					air = get_step(get_step(src.loc, EAST), EAST)
					if(air && istype(air, /turf/open/shuttle/dropship/medium_grey_single_wide_up_to_down/airlock))
						src.Move(air)
			if(src.dir == 1 || src.dir == 2)
				air = get_step(get_step(src.loc, SOUTH), SOUTH)
				if(air && istype(air, /turf/open/shuttle/dropship/medium_grey_single_wide_up_to_down/airlock))
					src.Move(air)
				else
					air = get_step(get_step(src.loc, NORTH), NORTH)
					if(air && istype(air, /turf/open/shuttle/dropship/medium_grey_single_wide_up_to_down/airlock))
						src.Move(air)

		if("port_door")
			if(src.dir == 1 || src.dir == 2)
				air = get_step(src.loc, NORTH)
				if(air && istype(air, /turf/open/shuttle/dropship/medium_grey_single_wide_up_to_down/airlock))
					src.Move(air)
				else
					air = get_step(src.loc, SOUTH)
					if(air && istype(air, /turf/open/shuttle/dropship/medium_grey_single_wide_up_to_down/airlock))
						src.Move(air)
			if(src.dir == 4 || src.dir == 8)
				air = get_step(src.loc, WEST)
				if(air && istype(air, /turf/open/shuttle/dropship/medium_grey_single_wide_up_to_down/airlock))
					src.Move(air)
				else
					air = get_step(src.loc, EAST)
					if(air && istype(air, /turf/open/shuttle/dropship/medium_grey_single_wide_up_to_down/airlock))
						src.Move(air)

		if("starboard_door")
			if(src.dir == 1 || src.dir == 2)
				air = get_step(src.loc, NORTH)
				if(air && istype(air, /turf/open/shuttle/dropship/medium_grey_single_wide_up_to_down/airlock))
					src.Move(air)
				else
					air = get_step(src.loc, SOUTH)
					if(air && istype(air, /turf/open/shuttle/dropship/medium_grey_single_wide_up_to_down/airlock))
						src.Move(air)
			if(src.dir == 4 || src.dir == 8)
				air = get_step(src.loc, WEST)
				if(air && istype(air, /turf/open/shuttle/dropship/medium_grey_single_wide_up_to_down/airlock))
					src.Move(air)
				else
					air = get_step(src.loc, EAST)
					if(air && istype(air, /turf/open/shuttle/dropship/medium_grey_single_wide_up_to_down/airlock))
						src.Move(air)

	src.setDir(old_dir)
	for(var/turf/closed/shuttle/tr_walls in old_locs)
		update_icon()
		tr_walls.set_opacity(TRUE)
	src.handle_multidoor()

/* ***********************************Object rotate procs*********************************** */

/obj/vehicle/multitile/shuttleRotate(rotation, params=ROTATE_DIR|ROTATE_SMOOTH|ROTATE_OFFSET)
	params &= ~ROTATE_OFFSET
	return ..()


/* ***********************************Turf rotate procs*********************************** */

/turf/closed/mineral/shuttleRotate(rotation, params=ROTATE_DIR|ROTATE_SMOOTH|ROTATE_OFFSET)
	params &= ~ROTATE_OFFSET
	return ..()

/* ***********************************Mob rotate procs*********************************** */

//override to avoid rotating pixel_xy on mobs
/mob/shuttleRotate(rotation, params=ROTATE_DIR|ROTATE_SMOOTH|ROTATE_OFFSET)
	params = NONE
	. = ..()
	if(!buckled)
		setDir(angle2dir(rotation+dir2angle(dir)))

/mob/dead/observer/shuttleRotate(rotation, params=ROTATE_DIR|ROTATE_SMOOTH|ROTATE_OFFSET)
	. = ..()
	update_icons()

/* ***********************************Structure rotate procs*********************************** */

//Fixes dpdir on shuttle rotation
/obj/structure/disposalpipe/shuttleRotate(rotation, params=ROTATE_DIR|ROTATE_SMOOTH|ROTATE_OFFSET)
	. = ..()
	var/new_dpdir = 0
	for(var/D in GLOB.cardinals)
		if(dpdir & D)
			new_dpdir = new_dpdir | angle2dir(rotation+dir2angle(D))
	dpdir = new_dpdir

/obj/structure/alien/weeds/shuttleRotate(rotation, params=ROTATE_DIR|ROTATE_SMOOTH|ROTATE_OFFSET)
	params &= ~ROTATE_OFFSET
	return ..()

