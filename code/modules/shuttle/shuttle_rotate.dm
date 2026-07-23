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
	switch(dir)
		if(NORTH)
			if(adjusted_pixel)
				pixel_x = -32
			else
				pixel_x = 0
			pixel_y = 0
		if(SOUTH)
			if(adjusted_pixel)
				pixel_x = 0
			else
				pixel_x = -32
			pixel_y = -8
		if(EAST)
			if(adjusted_pixel)
				pixel_y = 8
			else
				pixel_y = -24
			pixel_x = -6
		if(WEST)
			if(adjusted_pixel)
				pixel_y = -24
			else
				pixel_y = 8
			pixel_x = -26
	if(installed_equipment)
		installed_equipment.setDir(dir)
		installed_equipment.pixel_y = pixel_y
		installed_equipment.pixel_x = pixel_x

/obj/structure/bed/chair/vehicle/adjust_rotatables()
	if(dir == EAST || dir == WEST) //8
		pixel_x = 0
		pixel_y = init_pixel_x + 8
		buckle_offset_y = pixel_y
		buckle_offset_x = pixel_x
		if(pixel_y == 8)
			higher_layer = TRUE
	else
		pixel_y = 0
		if(dir == NORTH)
			pixel_x = init_pixel_x
		else
			pixel_x = init_pixel_x * -1
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
			if(src.dir == EAST || src.dir == WEST)
				air = get_step(get_step(src.loc, WEST), WEST)
				if(air && istype(air, /turf/open/shuttle/dropship/medium_grey_single_wide_up_to_down/airlock))
					src.Move(air)
				else
					air = get_step(get_step(src.loc, EAST), EAST)
					if(air && istype(air, /turf/open/shuttle/dropship/medium_grey_single_wide_up_to_down/airlock))
						src.Move(air)
			if(src.dir == NORTH || src.dir == SOUTH)
				air = get_step(get_step(src.loc, SOUTH), SOUTH)
				if(air && istype(air, /turf/open/shuttle/dropship/medium_grey_single_wide_up_to_down/airlock))
					src.Move(air)
				else
					air = get_step(get_step(src.loc, NORTH), NORTH)
					if(air && istype(air, /turf/open/shuttle/dropship/medium_grey_single_wide_up_to_down/airlock))
						src.Move(air)

		if("port_door")
			if(src.dir == NORTH || src.dir == SOUTH)
				air = get_step(src.loc, NORTH)
				if(air && istype(air, /turf/open/shuttle/dropship/medium_grey_single_wide_up_to_down/airlock))
					src.Move(air)
				else
					air = get_step(src.loc, SOUTH)
					if(air && istype(air, /turf/open/shuttle/dropship/medium_grey_single_wide_up_to_down/airlock))
						src.Move(air)
			if(src.dir == EAST || src.dir == WEST)
				air = get_step(src.loc, WEST)
				if(air && istype(air, /turf/open/shuttle/dropship/medium_grey_single_wide_up_to_down/airlock))
					src.Move(air)
				else
					air = get_step(src.loc, EAST)
					if(air && istype(air, /turf/open/shuttle/dropship/medium_grey_single_wide_up_to_down/airlock))
						src.Move(air)

		if("starboard_door")
			if(src.dir == NORTH || src.dir == SOUTH)
				air = get_step(src.loc, NORTH)
				if(air && istype(air, /turf/open/shuttle/dropship/medium_grey_single_wide_up_to_down/airlock))
					src.Move(air)
				else
					air = get_step(src.loc, SOUTH)
					if(air && istype(air, /turf/open/shuttle/dropship/medium_grey_single_wide_up_to_down/airlock))
						src.Move(air)
			if(src.dir == EAST || src.dir == WEST)
				air = get_step(src.loc, WEST)
				if(air && istype(air, /turf/open/shuttle/dropship/medium_grey_single_wide_up_to_down/airlock))
					src.Move(air)
				else
					air = get_step(src.loc, EAST)
					if(air && istype(air, /turf/open/shuttle/dropship/medium_grey_single_wide_up_to_down/airlock))
						src.Move(air)

	src.setDir(old_dir)
	for(var/turf/closed/shuttle/tr_walls in old_locs)
		tr_walls.set_opacity(1)
	src.handle_multidoor()

/* ***********************************Object rotate procs*********************************** */

/obj/vehicle/multitile/shuttleRotate(rotation, params=ROTATE_DIR|ROTATE_SMOOTH|ROTATE_OFFSET)
	params &= ~ROTATE_OFFSET
	return ..()

/obj/vehicle/powerloader/shuttleRotate(rotation, params=ROTATE_DIR|ROTATE_SMOOTH|ROTATE_OFFSET)
	setDir(angle2dir(rotation+dir2angle(dir)))
	return

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

