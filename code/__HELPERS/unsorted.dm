/*
 * A large number of misc global proc and define helpers.
 */

// GLOBAL DEFINES //
//Whether or not the given item counts as sharp in terms of dealing damage
#define is_sharp(I) (isitem(I) && I?:sharp && I?:edge)

//Whether or not the given item counts as cutting with an edge in terms of removing limbs
#define has_edge(I) (isitem(I) && I?:edge)

//Returns 1 if the given item is capable of popping things like balloons, inflatable barriers, or cutting police tape.
// For the record, WHAT THE HELL IS THIS METHOD OF DOING IT?
#define can_puncture(W) (isitem(W) && (W.sharp || W.heat_source >= 400 || \
							HAS_TRAIT(W, TRAIT_TOOL_SCREWDRIVER) || istype(W, /obj/item/tool/pen ) || istype(W, /obj/item/tool/shovel)) \
						)

//Offuscate x for coord system
#define obfuscate_x(x) ((x) + GLOB.obfs_x)

//Offuscate y for coord system
#define obfuscate_y(y) ((y) + GLOB.obfs_y)

//Deoffuscate x for coord system
#define deobfuscate_x(x) ((x) - GLOB.obfs_x)

//Deoffuscate y for coord system
#define deobfuscate_y(y) ((y) - GLOB.obfs_y)

#define can_xeno_build(T) (!T.density && !(locate(/obj/structure/fence) in T) && !(locate(/obj/structure/tunnel) in T) && (locate(/obj/effect/alien/weeds) in T))

// For the purpose of a skillcheck, not having a skillset counts as being skilled in everything (!user.skills check)
// Note that is_skilled() checks if the skillset contains the skill internally, so a has_skill check is unnecessary
#define skillcheck(user, skill, req_level) ((!user.skills || user.skills.is_skilled((skill), (req_level))))
#define skillcheckexplicit(user, skill, req_level) ((!user.skills || user.skills.is_skilled((skill), (req_level), TRUE)))

// Ensure the frequency is within bounds of what it should be sending/receiving at
// Sets f within bounds via `clamp(floor(f), 1441, 1489)`
// If f is even, adds 1 to its value to make it odd
#define sanitize_frequency(f) ((clamp(floor(f), 1441, 1489) % 2) == 0 ? \
									clamp(floor(f), 1441, 1489) + 1 : \
									clamp(floor(f), 1441, 1489) \
								)

//Turns 1479 into 147.9
#define format_frequency(f) "[floor((f) / 10)].[(f) % 10]"

#define reverse_direction(direction) ( \
											( dir & (NORTH|SOUTH) ? ~dir & (NORTH|SOUTH) : 0 ) | \
											( dir & (EAST|WEST) ? ~dir & (EAST|WEST) : 0 ) \
										)

// The sane, counter-clockwise angle to turn to get from /direction/ A to /direction/ B
#define turning_angle(a, b) -(dir2angle(b) - dir2angle(a))


// GLOBAL PROCS //

/// Gives X position on pixel grid of an object, accounting for offsets
/proc/get_pixel_position_x(atom/subject, relative = FALSE)
	. = subject.pixel_x + subject.base_pixel_x
	if(!relative)
		. += world.icon_size * subject.x

	if(ismob(subject)) // Mobs use baked in icon_size due to eg. Xenos only using a visual size
		var/mob/mob_subject = subject
		. += (mob_subject.icon_size - world.icon_size) / 2

	else if(ismovable(subject)) // Other movables we assume use bound_height/width collision boxes
		var/atom/movable/big_subject = subject
		. += (big_subject.bound_width  - world.icon_size) / 2

/// Gives Y position on pixel grid of an object, accounting for offsets
/proc/get_pixel_position_y(atom/subject, relative = FALSE)
	. = subject.pixel_y + subject.base_pixel_y
	if(!relative)
		. += world.icon_size * subject.y

	if(ismob(subject)) // Mobs use baked in icon_size due to eg. Xenos only using a visual size
		var/mob/mob_subject = subject
		. += (mob_subject.icon_size - world.icon_size) / 2

	else if(ismovable(subject)) // Other movables we assume use bound_height/width collision boxes
		var/atom/movable/big_subject = subject
		. += (big_subject.bound_height  - world.icon_size) / 2

/// Calculate the angle between two atoms. Uses north-clockwise convention: NORTH = 0, EAST = 90, etc.
/proc/Get_Angle(atom/start, atom/end)//For beams.
	if(!start || !end)
		return 0
	if(!start.z)
		start = get_turf(start)
		if(!start)
			return 0 //Atoms are not on turfs.
	if(!end.z)
		end = get_turf(end)
		if(!end)
			return 0 //Atoms are not on turfs.
	var/dy = get_pixel_position_y(end) - get_pixel_position_y(start)
	var/dx = get_pixel_position_x(end) - get_pixel_position_x(start)
	return delta_to_angle(dx, dy)

/// Calculate the angle produced by a pair of x and y deltas. Uses north-clockwise convention: NORTH = 0, EAST = 90, etc.
/proc/delta_to_angle(dx, dy)
	. = arctan(dy, dx) //y-then-x results in north-clockwise convention: https://en.wikipedia.org/wiki/Atan2#East-counterclockwise,_north-clockwise_and_south-clockwise_conventions,_etc.
	if(. < 0)
		. += 360

/proc/angle_to_dir(angle)
	switch(angle) //diagonal directions get priority over straight directions in edge cases
		if (22.5 to 67.5)
			return NORTHEAST
		if (112.5 to 157.5)
			return SOUTHEAST
		if (202.5 to 247.5)
			return SOUTHWEST
		if (292.5 to 337.5)
			return NORTHWEST
		if (0 to 22.5)
			return NORTH
		if (67.5 to 112.5)
			return EAST
		if (157.5 to 202.5)
			return SOUTH
		if (247.5 to 292.5)
			return WEST
		else
			return NORTH

/proc/Get_Compass_Dir(atom/start, atom/end)//get_dir() only considers an object to be north/south/east/west if there is zero deviation. This uses rounding instead.
	return angle_to_dir(Get_Angle(get_turf(start), get_turf(end)))

// Among other things, used by flamethrower and boiler spray to calculate if flame/spray can pass through.
// Returns an atom for specific effects (primarily flames and acid spray) that damage things upon contact
//
// This is a copy-and-paste of the Enter() proc for turfs with tweaks related to the applications
// of LinkBlocked
/proc/LinkBlocked(atom/movable/mover, turf/start_turf, turf/target_turf, list/atom/forget)
	if (!mover)
		return null

	/// the actual dir between the start and target turf
	var/fdir = get_dir(start_turf, target_turf)
	if (!fdir)
		return null

	var/fd1 = fdir & (fdir-1)
	var/fd2 = fdir - fd1

	/// The direction that mover's path is being blocked by
	var/blocking_dir = 0

	var/obstacle
	var/turf/T
	var/atom/A

	blocking_dir |= start_turf.BlockedExitDirs(mover, fdir)
	for (obstacle in start_turf) //First, check objects to block exit
		if (mover == obstacle || (obstacle in forget))
			continue
		if (!isStructure(obstacle) && !ismob(obstacle) && !isVehicle(obstacle))
			continue
		A = obstacle
		blocking_dir |= A.BlockedExitDirs(mover, fdir)
		if ((!fd1 || blocking_dir & fd1) && (!fd2 || blocking_dir & fd2))
			return A

	// Check for atoms in adjacent turf EAST/WEST
	if (fd1 && fd1 != fdir)
		T = get_step(start_turf, fd1)
		if (T.BlockedExitDirs(mover, fd2) || T.BlockedPassDirs(mover, fd1))
			blocking_dir |= fd1
			if ((!fd1 || blocking_dir & fd1) && (!fd2 || blocking_dir & fd2))
				return T
		for (obstacle in T)
			if(obstacle in forget)
				continue
			if (!isStructure(obstacle) && !ismob(obstacle) && !isVehicle(obstacle))
				continue
			A = obstacle
			if (A.BlockedExitDirs(mover, fd2) || A.BlockedPassDirs(mover, fd1))
				blocking_dir |= fd1
				if ((!fd1 || blocking_dir & fd1) && (!fd2 || blocking_dir & fd2))
					return A
				break

	// Check for atoms in adjacent turf NORTH/SOUTH
	if (fd2 && fd2 != fdir)
		T = get_step(start_turf, fd2)
		if (T.BlockedExitDirs(mover, fd1) || T.BlockedPassDirs(mover, fd2))
			blocking_dir |= fd2
			if ((!fd1 || blocking_dir & fd1) && (!fd2 || blocking_dir & fd2))
				return T
		for (obstacle in T)
			if(obstacle in forget)
				continue
			if (!isStructure(obstacle) && !ismob(obstacle) && !isVehicle(obstacle))
				continue
			A = obstacle
			if (A.BlockedExitDirs(mover, fd1) || A.BlockedPassDirs(mover, fd2))
				blocking_dir |= fd2
				if ((!fd1 || blocking_dir & fd1) && (!fd2 || blocking_dir & fd2))
					return A
				break

	// Check the turf itself
	blocking_dir |= target_turf.BlockedPassDirs(mover, fdir)
	if ((!fd1 || blocking_dir & fd1) && (!fd2 || blocking_dir & fd2))
		return target_turf
	for (obstacle in target_turf) // Finally, check atoms in the target turf
		if(obstacle in forget)
			continue
		if (!isStructure(obstacle) && !ismob(obstacle) && !isVehicle(obstacle))
			continue
		A = obstacle
		blocking_dir |= A.BlockedPassDirs(mover, fdir)
		if((fd1 && blocking_dir == fd1) || (fd2 && blocking_dir == fd2))
			return A
		if((!fd1 || blocking_dir & fd1) && (!fd2 || blocking_dir & fd2))
			return A

	return null // Nothing found to block the link of mover from start_turf to target_turf


/proc/TurfBlockedNonWindow(turf/loc)
	for(var/obj/O in loc)
		if(O.density && !istype(O, /obj/structure/window))
			return 1
	return 0



//Returns whether or not a player is a guest using their ckey as an input
/proc/IsGuestKey(key)
	if (findtext(key, "Guest-", 1, 7) != 1) //was findtextEx
		return 0

	var/i = 7, ch, len = length(key)

	if(copytext(key, 7, 8) == "W") //webclient
		i++

	for (, i <= len, ++i)
		ch = text2ascii(key, i)
		if (ch < 48 || ch > 57)
			return 0
	return 1

//This will update a mob's name, real_name, mind.name, data_core records, pda and id
//Calling this proc without an oldname will only update the mob and skip updating the pda, id and records ~Carn
/mob/proc/fully_replace_character_name(oldname, newname)
	if(!newname) return 0
	change_real_name(src, newname)

	if(oldname)
		//update the datacore records! This is goig to be a bit costly.
		var/mob_ref = WEAKREF(src)
		for(var/list/L in list(GLOB.data_core.general, GLOB.data_core.medical, GLOB.data_core.security, GLOB.data_core.locked))
			for(var/datum/data/record/record_entry in L)
				if(record_entry.fields["ref"] == mob_ref)
					record_entry.fields["name"] = newname
					record_entry.name = newname
					break

		//update our pda and id if we have them on our person
		var/list/searching = GetAllContents(searchDepth = 3)
		var/search_id = 1
		var/search_pda = 1

		for(var/A in searching)
			if( search_id && istype(A,/obj/item/card/id) )
				var/obj/item/card/id/ID = A
				if(ID.registered_name == oldname)
					ID.registered_name = newname
					ID.name = "[newname]'s ID Card ([ID.assignment])"
					if(!search_pda) break
					search_id = 0
	return 1

//Returns a list of all mobs with their name
/proc/getmobs()
	var/list/mobs = sortmobs()
	var/list/names = list()
	var/list/creatures = list()
	var/list/namecounts = list()
	for(var/mob/M in mobs)
		// This thing doesnt want to be seen, a bit snowflake.
		if(M.invisibility == INVISIBILITY_MAXIMUM && M.alpha == 0)
			continue

		var/name = M.name
		if (name in names)
			namecounts[name]++
			name = "[name] ([namecounts[name]])"
		else
			names.Add(name)
			namecounts[name] = 1
		if (M.real_name && M.real_name != M.name)
			name += " \[[M.real_name]\]"
		if (M.stat == 2)
			name += " \[dead\]"
		if(istype(M, /mob/dead/observer/))
			name += " \[ghost\]"
		creatures[name] = M

	return creatures

/proc/get_multi_vehicles()
	var/list/multi_vehicles = GLOB.all_multi_vehicles.Copy()
	var/list/names = list()
	var/list/namecounts = list()
	var/list/vehicles = list()
	for(var/obj/vehicle/multitile/MV in multi_vehicles)
		var/name = MV.name
		if(name in names)
			namecounts[name]++
			name = "[name] #([namecounts[name]])"
		else
			names.Add(name)
			namecounts[name] = 1
		vehicles[name] = MV

	return vehicles

//Unlike the above adds object reference instead of number, for 100% pinpointing the needed vehicle
/proc/get_multi_vehicles_admin()
	var/list/vehicles = list()
	for(var/obj/vehicle/multitile/MV as anything in GLOB.all_multi_vehicles)
		var/name = "[MV.name] (\ref[MV]) ([get_area(MV)])"
		vehicles[name] = MV

	return vehicles

//Orders mobs by type then by name
/proc/sortmobs()
	var/list/moblist = list()
	var/list/sortmob = sortAtom(GLOB.mob_list)
	for(var/mob/living/silicon/ai/M in sortmob)
		moblist.Add(M)
	for(var/mob/living/silicon/robot/M in sortmob)
		moblist.Add(M)
	for(var/mob/living/carbon/human/M in sortmob)
		moblist.Add(M)
	for(var/mob/living/brain/M in sortmob)
		moblist.Add(M)
	for(var/mob/living/carbon/xenomorph/M in sortmob)
		moblist.Add(M)
	for(var/mob/dead/observer/M in sortmob)
		moblist.Add(M)
	for(var/mob/new_player/M in sortmob)
		moblist.Add(M)
	for(var/mob/living/carbon/human/monkey/M in sortmob)
		moblist.Add(M)
	for(var/mob/living/simple_animal/M in sortmob)
		moblist.Add(M)
	for(var/mob/camera/imaginary_friend/friend in sortmob)
		moblist += friend
	return moblist

/proc/key_name(whom, include_link = null, include_name = 1, highlight_special_characters = 1)
	var/mob/M
	var/client/C
	var/key

	if(!whom) return "*null*"
	if(istype(whom, /client))
		C = whom
		M = C.mob
		key = C.key
	else if(ismob(whom))
		M = whom
		C = M.client
		key = M.key
	else if(istype(whom, /datum))
		var/datum/D = whom
		return "*invalid:[D.type]*"
	else
		return "*invalid*"

	. = ""

	if(key)
		if(include_link && C)
			. += "<a href='?priv_msg=[C.ckey]'>"

		. += key

		if(include_link)
			if(C) . += "</a>"
			else . += " (DC)"
	else
		. += "*no key*"

	if(include_name && M)
		var/name

		if(M.real_name)
			name = M.real_name
		else if(M.name)
			name = M.name

		. += "/([name])"

	return .

/proc/key_name_admin(whom, include_name = 1)
	return key_name(whom, 1, include_name)


// returns the turf located at the map edge in the specified direction relative to A
// used for mass driver
/proc/get_edge_target_turf(atom/A, direction)

	var/turf/target = locate(A.x, A.y, A.z)
	if(!A || !target)
		return 0
		//since NORTHEAST == NORTH & EAST, etc, doing it this way allows for diagonal mass drivers in the future
		//and isn't really any more complicated

		// Note diagonal directions won't usually be accurate
	if(direction & NORTH)
		target = locate(target.x, world.maxy, target.z)
	if(direction & SOUTH)
		target = locate(target.x, 1, target.z)
	if(direction & EAST)
		target = locate(world.maxx, target.y, target.z)
	if(direction & WEST)
		target = locate(1, target.y, target.z)

	return target

/proc/urange(dist=0, atom/center=usr, orange=0, areas=0)
	if(!dist)
		if(!orange)
			return list(center)
		else
			return list()

	var/list/turfs = RANGE_TURFS(dist, center)
	if(orange)
		turfs -= get_turf(center)
	. = list()
	for(var/turf/T as anything in turfs)
		. += T
		. += T.contents
		if(areas)
			. |= T.loc

// returns turf relative to A in given direction at set range
// result is bounded to map size
// note range is non-pythagorean
// used for disposal system
/proc/get_ranged_target_turf(atom/A, direction, range)

	var/x = A.x
	var/y = A.y
	if(direction & NORTH)
		y = min(world.maxy, y + range)
	if(direction & SOUTH)
		y = max(1, y - range)
	if(direction & EAST)
		x = min(world.maxx, x + range)
	if(direction & WEST)
		x = max(1, x - range)

	return locate(x,y,A.z)

// returns turf relative to A for a given clockwise angle at set range
// result is bounded to map size
/proc/get_angle_target_turf(atom/A, angle, range)
	if(!istype(A))
		return null
	var/x = A.x
	var/y = A.y

	x += range * sin(angle)
	y += range * cos(angle)

	//Restricts to map boundaries while keeping the final angle the same
	var/dx = A.x - x
	var/dy = A.y - y
	var/ratio

	if(dy == 0) //prevents divide-by-zero errors
		ratio = INFINITY
	else
		ratio = dx / dy

	if(x < 1)
		y += (1 - x) / ratio
		x = 1
	else if (x > world.maxx)
		y += (world.maxx - x) / ratio
		x = world.maxx
	if(y < 1)
		x += (1 - y) * ratio
		y = 1
	else if (y > world.maxy)
		x += (world.maxy - y) * ratio
		y = world.maxy


	x = round(x,1)
	y = round(y,1)

	return locate(x,y,A.z)


// returns turf relative to A offset in dx and dy tiles
// bound to map limits
/proc/get_offset_target_turf(atom/A, dx, dy)
	var/x = min(world.maxx, max(1, A.x + dx))
	var/y = min(world.maxy, max(1, A.y + dy))
	return locate(x,y,A.z)

/proc/anim(turf/location,atom/target,a_icon,a_icon_state as text,flick_anim as text, qdel_in = 0,direction as num)
//This proc throws up either an icon or an animation for a specified amount of time.
//The variables should be apparent enough.
	var/atom/movable/overlay/animation = new(location)
	var/qdel_time = max(qdel_in, 1.5 SECONDS)
	QDEL_IN(animation, qdel_time)
	if(direction)
		animation.setDir(direction)
	animation.icon = a_icon
	animation.layer = target.layer+0.1
	if(a_icon_state)
		animation.icon_state = a_icon_state
	else
		animation.icon_state = "blank"
		animation.master = target
		flick(flick_anim, animation)

///Will return the contents of an atom recursivly to a depth of 'searchDepth', not including starting atom
/atom/proc/GetAllContents(searchDepth = 5, list/toReturn = list())
	for(var/atom/part as anything in contents)
		toReturn += part
		if(part.contents.len && searchDepth)
			part.GetAllContents(searchDepth - 1, toReturn)
	return toReturn

///Returns the src and all recursive contents as a list. Includes the starting atom.
/atom/proc/get_all_contents(ignore_flag_1)
	. = list(src)
	var/i = 0
	while(i < length(.))
		var/atom/checked_atom = .[++i]
		if(checked_atom.flags_atom & ignore_flag_1)
			continue
		. += checked_atom.contents

/// Returns list of contents of a turf recursively, much like GetAllContents
/// We only get containing atoms in the turf, excluding multitiles bordering on it
/turf/proc/GetAllTurfStrictContents(searchDepth = 5, list/toReturn = list())
	for(var/atom/part as anything in contents)
		if(part.loc != src) // That's a multitile atom, and it's not actually here stricto sensu
			continue
		toReturn += part
		if(part.contents.len && searchDepth)
			part.GetAllContents(searchDepth - 1, toReturn)
	return toReturn

//Step-towards method of determining whether one atom can see another. Similar to viewers()
/proc/can_see(atom/source, atom/target, length=5) // I couldnt be arsed to do actual raycasting :I This is horribly inaccurate.
	var/turf/current = get_turf(source)
	var/turf/target_turf = get_turf(target)
	var/steps = 0
	var/has_nightvision = FALSE
	if(ismob(source))
		var/mob/M = source
		has_nightvision = M.see_in_dark >= 12
	if(!has_nightvision && target_turf.get_lumcount() == 0)
		return FALSE

	while(current != target_turf)
		if(steps > length) return FALSE
		if(!current || current.opacity) return FALSE
		for(var/atom/A in current)
			if(A && A.opacity) return FALSE
		current = get_step_towards(current, target_turf)
		steps++

	return TRUE

/proc/is_blocked_turf(turf/T)
	if(T.density)
		return TRUE
	for(var/atom/A in T)
		if(A.density)//&&A.anchored
			return TRUE
	return FALSE


GLOBAL_DATUM(busy_indicator_clock, /image)
GLOBAL_DATUM(busy_indicator_medical, /image)
GLOBAL_DATUM(busy_indicator_build, /image)
GLOBAL_DATUM(busy_indicator_friendly, /image)
GLOBAL_DATUM(busy_indicator_hostile, /image)
GLOBAL_DATUM(emote_indicator_highfive, /image)
GLOBAL_DATUM(emote_indicator_fistbump, /image)
GLOBAL_DATUM(emote_indicator_headbutt, /image)
GLOBAL_DATUM(emote_indicator_tailswipe, /image)
GLOBAL_DATUM(emote_indicator_rock_paper_scissors, /image)
GLOBAL_DATUM(emote_indicator_rock, /image)
GLOBAL_DATUM(emote_indicator_paper, /image)
GLOBAL_DATUM(emote_indicator_scissors, /image)
GLOBAL_DATUM(action_red_power_up, /image)
GLOBAL_DATUM(action_green_power_up, /image)
GLOBAL_DATUM(action_blue_power_up, /image)
GLOBAL_DATUM(action_purple_power_up, /image)

/proc/get_busy_icon(busy_type)
	if(busy_type == BUSY_ICON_GENERIC)
		if(!GLOB.busy_indicator_clock)
			GLOB.busy_indicator_clock = image('icons/mob/mob.dmi', null, "busy_generic", "pixel_y" = 22)
			GLOB.busy_indicator_clock.layer = FLY_LAYER
			GLOB.busy_indicator_clock.plane = ABOVE_GAME_PLANE
		return GLOB.busy_indicator_clock
	else if(busy_type == BUSY_ICON_MEDICAL)
		if(!GLOB.busy_indicator_medical)
			GLOB.busy_indicator_medical = image('icons/mob/mob.dmi', null, "busy_medical", "pixel_y" = 0) //This shows directly on top of the mob, no offset!
			GLOB.busy_indicator_medical.layer = FLY_LAYER
			GLOB.busy_indicator_medical.plane = ABOVE_GAME_PLANE
		return GLOB.busy_indicator_medical
	else if(busy_type == BUSY_ICON_BUILD)
		if(!GLOB.busy_indicator_build)
			GLOB.busy_indicator_build = image('icons/mob/mob.dmi', null, "busy_build", "pixel_y" = 22)
			GLOB.busy_indicator_build.layer = FLY_LAYER
			GLOB.busy_indicator_build.plane = ABOVE_GAME_PLANE
		return GLOB.busy_indicator_build
	else if(busy_type == BUSY_ICON_FRIENDLY)
		if(!GLOB.busy_indicator_friendly)
			GLOB.busy_indicator_friendly = image('icons/mob/mob.dmi', null, "busy_friendly", "pixel_y" = 22)
			GLOB.busy_indicator_friendly.layer = FLY_LAYER
			GLOB.busy_indicator_friendly.plane = ABOVE_GAME_PLANE
		return GLOB.busy_indicator_friendly
	else if(busy_type == BUSY_ICON_HOSTILE)
		if(!GLOB.busy_indicator_hostile)
			GLOB.busy_indicator_hostile = image('icons/mob/mob.dmi', null, "busy_hostile", "pixel_y" = 22)
			GLOB.busy_indicator_hostile.layer = FLY_LAYER
			GLOB.busy_indicator_hostile.plane = ABOVE_GAME_PLANE
		return GLOB.busy_indicator_hostile
	else if(busy_type == EMOTE_ICON_HIGHFIVE)
		if(!GLOB.emote_indicator_highfive)
			GLOB.emote_indicator_highfive = image('icons/mob/mob.dmi', null, "emote_highfive", "pixel_y" = 22)
			GLOB.emote_indicator_highfive.layer = FLY_LAYER
			GLOB.emote_indicator_highfive.plane = ABOVE_GAME_PLANE
		return GLOB.emote_indicator_highfive
	else if(busy_type == EMOTE_ICON_FISTBUMP)
		if(!GLOB.emote_indicator_fistbump)
			GLOB.emote_indicator_fistbump = image('icons/mob/mob.dmi', null, "emote_fistbump", "pixel_y" = 22)
			GLOB.emote_indicator_fistbump.layer = FLY_LAYER
			GLOB.emote_indicator_fistbump.plane = ABOVE_GAME_PLANE
		return GLOB.emote_indicator_fistbump
	else if(busy_type == EMOTE_ICON_ROCK_PAPER_SCISSORS)
		if(!GLOB.emote_indicator_rock_paper_scissors)
			GLOB.emote_indicator_rock_paper_scissors = image('icons/mob/mob.dmi', null, "emote_rps", "pixel_y" = 22)
			GLOB.emote_indicator_rock_paper_scissors.layer = FLY_LAYER
			GLOB.emote_indicator_rock_paper_scissors.plane = ABOVE_GAME_PLANE
		return GLOB.emote_indicator_rock_paper_scissors
	else if(busy_type == EMOTE_ICON_ROCK)
		if(!GLOB.emote_indicator_rock)
			GLOB.emote_indicator_rock = image('icons/mob/mob.dmi', null, "emote_rock", "pixel_y" = 22)
			GLOB.emote_indicator_rock.layer = FLY_LAYER
			GLOB.emote_indicator_rock.plane = ABOVE_GAME_PLANE
		return GLOB.emote_indicator_rock
	else if(busy_type == EMOTE_ICON_PAPER)
		if(!GLOB.emote_indicator_paper)
			GLOB.emote_indicator_paper = image('icons/mob/mob.dmi', null, "emote_paper", "pixel_y" = 22)
			GLOB.emote_indicator_paper.layer = FLY_LAYER
			GLOB.emote_indicator_paper.plane = ABOVE_GAME_PLANE
		return GLOB.emote_indicator_paper
	else if(busy_type == EMOTE_ICON_SCISSORS)
		if(!GLOB.emote_indicator_scissors)
			GLOB.emote_indicator_scissors = image('icons/mob/mob.dmi', null, "emote_scissors", "pixel_y" = 22)
			GLOB.emote_indicator_scissors.layer = FLY_LAYER
			GLOB.emote_indicator_scissors.plane = ABOVE_GAME_PLANE
		return GLOB.emote_indicator_scissors
	else if(busy_type == EMOTE_ICON_HEADBUTT)
		if(!GLOB.emote_indicator_headbutt)
			GLOB.emote_indicator_headbutt = image('icons/mob/mob.dmi', null, "emote_headbutt", "pixel_y" = 22)
			GLOB.emote_indicator_headbutt.layer = FLY_LAYER
			GLOB.emote_indicator_headbutt.plane = ABOVE_GAME_PLANE
		return GLOB.emote_indicator_headbutt
	else if(busy_type == EMOTE_ICON_TAILSWIPE)
		if(!GLOB.emote_indicator_tailswipe)
			GLOB.emote_indicator_tailswipe = image('icons/mob/mob.dmi', null, "emote_tailswipe", "pixel_y" = 22)
			GLOB.emote_indicator_tailswipe.layer = FLY_LAYER
			GLOB.emote_indicator_tailswipe.plane = ABOVE_GAME_PLANE
		return GLOB.emote_indicator_tailswipe
	else if(busy_type == ACTION_RED_POWER_UP)
		if(!GLOB.action_red_power_up)
			GLOB.action_red_power_up = image('icons/effects/effects.dmi', null, "anger", "pixel_x" = 16)
			GLOB.action_red_power_up.layer = FLY_LAYER
			GLOB.action_red_power_up.plane = ABOVE_GAME_PLANE
		return GLOB.action_red_power_up
	else if(busy_type == ACTION_GREEN_POWER_UP)
		if(!GLOB.action_green_power_up)
			GLOB.action_green_power_up = image('icons/effects/effects.dmi', null, "vitality", "pixel_x" = 16)
			GLOB.action_green_power_up.layer = FLY_LAYER
			GLOB.action_green_power_up.plane = ABOVE_GAME_PLANE
		return GLOB.action_green_power_up
	else if(busy_type == ACTION_BLUE_POWER_UP)
		if(!GLOB.action_blue_power_up)
			GLOB.action_blue_power_up = image('icons/effects/effects.dmi', null, "shock", "pixel_x" = 16)
			GLOB.action_blue_power_up.layer = FLY_LAYER
			GLOB.action_blue_power_up.plane = ABOVE_GAME_PLANE
		return GLOB.action_blue_power_up
	else if(busy_type == ACTION_PURPLE_POWER_UP)
		if(!GLOB.action_purple_power_up)
			GLOB.action_purple_power_up = image('icons/effects/effects.dmi', null, "pain", "pixel_x" = 16)
			GLOB.action_purple_power_up.layer = FLY_LAYER
			GLOB.action_purple_power_up.plane = ABOVE_GAME_PLANE
		return GLOB.action_purple_power_up


/*
 * do_after handles timed actions
 * The flags indicate which actions from the user and a target (if there is a target) interrupt a given action.
 * This proc can handle timed actions with one person alone or one person and a target atom.
 *
 * show_remaining_time: If TRUE, return the percentage of time remaining in the timed action.
 * numticks: If a value is given, denotes how often the timed action checks for interrupting actions. By default, there are 5 checks every delay/5 deciseconds.
 * Note: 'delay' should be divisible by numticks in order for the timing to work as intended. numticks should also be a whole number.
 */
/proc/do_after(mob/user, delay, user_flags = INTERRUPT_ALL, show_busy_icon, atom/movable/target, target_flags = INTERRUPT_MOVED, show_target_icon, max_dist = 1, \
		show_remaining_time = FALSE, numticks = DA_DEFAULT_NUM_TICKS) // These args should primarily be named args, since you only modify them in niche situations
	if(!istype(user) || delay < 0)
		return FALSE

	if(delay == 0) // Nothing to wait for, so action passes
		return TRUE

	// Check if there is even a target
	var/has_target = FALSE
	if(istype(target))
		has_target = TRUE

	// Only living mobs can perform timed actions.
	var/mob/living/busy_user = user
	if(!istype(busy_user))
		return FALSE

	// This var will only be used for checks that require target to be living.
	var/mob/living/T = target
	var/target_is_mob = FALSE
	if(has_target && istype(T))
		target_is_mob = TRUE

	var/image/busy_icon
	if(show_busy_icon)
		busy_icon = get_busy_icon(show_busy_icon)
		if(busy_icon)
			busy_user.overlays += busy_icon

	var/image/target_icon
	if(show_target_icon) //putting a busy overlay on top of the target
		target_icon = get_busy_icon(show_target_icon)
		if(target_icon)
			target.overlays += target_icon

	if(user_flags & BEHAVIOR_IMMOBILE)
		busy_user.status_flags |= IMMOBILE_ACTION

	busy_user.action_busy++ // target is not tethered by action, the action is tethered by target though
	busy_user.resisting = FALSE
	busy_user.clicked_something = list()
	if(has_target && target_is_mob)
		T.resisting = FALSE
		T.clicked_something = list()

	var/cur_user_zone_sel = busy_user.zone_selected
	var/cur_target_zone_sel
	var/delayfraction = ceil(delay/numticks)
	var/user_orig_loc = busy_user.loc
	var/user_orig_turf = get_turf(busy_user)
	var/target_orig_loc
	var/target_orig_turf
	if(has_target)
		target_orig_loc = target.loc
		target_orig_turf = get_turf(target)
	var/obj/user_holding = busy_user.get_active_hand()
	var/obj/target_holding
	var/cur_user_lying = busy_user.body_position
	var/cur_target_lying
	var/expected_total_time = delayfraction*numticks
	var/time_remaining = expected_total_time

	if(has_target && istype(T))
		cur_target_zone_sel = T.zone_selected
		target_holding = T.get_active_hand()
		cur_target_lying = T.body_position

	. = TRUE
	for(var/i in 1 to numticks)
		sleep(delayfraction)
		time_remaining -= delayfraction
		if(!istype(busy_user) || has_target && !istype(target)) // Checks if busy_user exists and is not dead and if the target exists and is not destroyed
			. = FALSE
			break
		if(user_flags & INTERRUPT_DIFF_LOC && busy_user.loc != user_orig_loc || \
			has_target && (target_flags & INTERRUPT_DIFF_LOC && target.loc != target_orig_loc)
		)
			. = FALSE
			break
		if(user_flags & INTERRUPT_DIFF_TURF && get_turf(busy_user) != user_orig_turf || \
			has_target && (target_flags & INTERRUPT_DIFF_TURF && get_turf(target) != target_orig_turf)
		)
			. = FALSE
			break
		if(user_flags & INTERRUPT_UNCONSCIOUS && busy_user.stat || \
			target_is_mob && (target_flags & INTERRUPT_UNCONSCIOUS && T.stat)
		)
			. = FALSE
			break
		if(user_flags & INTERRUPT_KNOCKED_DOWN && HAS_TRAIT(busy_user, TRAIT_FLOORED) || \
			target_is_mob && (target_flags & INTERRUPT_KNOCKED_DOWN && HAS_TRAIT(T, TRAIT_FLOORED))
		)
			. = FALSE
			break
		if(user_flags & INTERRUPT_STUNNED && HAS_TRAIT(busy_user, TRAIT_INCAPACITATED)|| \
			target_is_mob && (target_flags & INTERRUPT_STUNNED && HAS_TRAIT(T, TRAIT_INCAPACITATED))
		)
			. = FALSE
			break
		if(user_flags & INTERRUPT_DAZED && HAS_TRAIT(busy_user, TRAIT_DAZED))
			. = FALSE
			break
		if(user_flags & INTERRUPT_EMOTE && !busy_user.flags_emote)
			. = FALSE
			break
		if(user_flags & INTERRUPT_NEEDHAND)
			if(user_holding)
				if(!user_holding.loc || busy_user.get_active_hand() != user_holding) //no longer holding the required item in active hand
					. = FALSE
					break
			else if(busy_user.get_active_hand()) //something in active hand when we need it to stay empty
				. = FALSE
				break
		if(target_is_mob && target_flags & INTERRUPT_NEEDHAND)
			if(target_holding)
				if(!target_holding.loc || T.get_active_hand() != target_holding)
					. = FALSE
					break
			else if(T.get_active_hand())
				. = FALSE
				break
		if(user_flags & INTERRUPT_NO_NEEDHAND)
			if(user_holding)
				if(!user_holding.loc || (busy_user.l_hand != user_holding && busy_user.r_hand != user_holding)) //no longer holding the required item in either hand
					. = FALSE
					break
		if(user_flags & INTERRUPT_RESIST && busy_user.resisting || \
			target_is_mob && (target_flags & INTERRUPT_RESIST && T.resisting)
		)
			. = FALSE
			break
		if(user_flags & INTERRUPT_DIFF_SELECT_ZONE && cur_user_zone_sel != busy_user.zone_selected || \
			target_is_mob && (target_flags & INTERRUPT_DIFF_SELECT_ZONE && cur_target_zone_sel != T.zone_selected)
		)
			. = FALSE
			break
		if((user_flags|target_flags) & INTERRUPT_OUT_OF_RANGE && target && get_dist(busy_user, target) > max_dist)
			. = FALSE
			break
		if(user_flags & INTERRUPT_LCLICK && busy_user.clicked_something["left"] || \
			target_is_mob && (target_flags & INTERRUPT_LCLICK && T.clicked_something["left"])
		)
			. = FALSE
			break
		if(user_flags & INTERRUPT_RCLICK && busy_user.clicked_something["right"] || \
			target_is_mob && (target_flags & INTERRUPT_RCLICK && T.clicked_something["right"])
		)
			. = FALSE
			break
		if(user_flags & INTERRUPT_SHIFTCLICK && busy_user.clicked_something["left"] && busy_user.clicked_something["shift"] || \
			target_is_mob && (target_flags & INTERRUPT_SHIFTCLICK && T.clicked_something["left"] && T.clicked_something["shift"])
		)
			. = FALSE
			break
		if(user_flags & INTERRUPT_ALTCLICK && busy_user.clicked_something["left"] && busy_user.clicked_something["alt"] || \
			target_is_mob && (target_flags & INTERRUPT_ALTCLICK && T.clicked_something["left"] && T.clicked_something["alt"])
		)
			. = FALSE
			break
		if(user_flags & INTERRUPT_CTRLCLICK && busy_user.clicked_something["left"] && busy_user.clicked_something["ctrl"] || \
			target_is_mob && (target_flags & INTERRUPT_CTRLCLICK && T.clicked_something["left"] && T.clicked_something["ctrl"])
		)
			. = FALSE
			break
		if(user_flags & INTERRUPT_MIDDLECLICK && busy_user.clicked_something["middle"] || \
			target_is_mob && (target_flags & INTERRUPT_MIDDLECLICK && T.clicked_something["middle"])
		)
			. = FALSE
			break
		if(user_flags & INTERRUPT_CHANGED_LYING && busy_user.body_position != cur_user_lying || \
			target_is_mob && (target_flags & INTERRUPT_CHANGED_LYING && T.body_position != cur_target_lying)
		)
			. = FALSE
			break

	if(busy_user && busy_icon)
		busy_user.overlays -= busy_icon
	if(target && target_icon)
		target.overlays -= target_icon

	busy_user.action_busy--
	busy_user.resisting = FALSE
	if(target_is_mob)
		T.resisting = FALSE
	busy_user.status_flags &= ~IMMOBILE_ACTION

	if (show_remaining_time)
		return (. ? 0 : time_remaining/expected_total_time) // If action was not interrupted, return 0 for no time left, otherwise return ratio of time remaining

//Takes: Anything that could possibly have variables and a varname to check.
//Returns: 1 if found, 0 if not.
/proc/hasvar(datum/A, varname)
	if(A.vars.Find(lowertext(varname))) return 1
	else return 0

//Returns: all the areas in the world, sorted.
/proc/return_sorted_areas()
	var/list/area/AL = list()
	for(var/area/A in GLOB.sorted_areas)
		AL += A
	return AL

//Takes: Area type as text string or as typepath OR an instance of the area.
//Returns: A list of all turfs in areas of that type of that type in the world.
/proc/get_area_turfs(areatype)
	if(!areatype)
		return

	if(istext(areatype))
		areatype = text2path(areatype)

	if(isarea(areatype))
		var/area/areatemp = areatype
		areatype = areatemp.type

	var/list/turfs = list()
	var/area/A = GLOB.areas_by_type[areatype]

	// Fix it up with /area/var/related due to lighting shenanigans
	for(var/turf/T in A)
		turfs += T

	return turfs

/datum/coords //Simple datum for storing coordinates.
	var/x_pos = null
	var/y_pos = null
	var/z_pos = null

/datum/coords/New(turf/location)
	. = ..()
	if(location)
		x_pos = location.x
		y_pos = location.y
		z_pos = location.z

/datum/coords/proc/get_turf_from_coord()
	if(!x_pos || !y_pos || !z_pos)
		return

	return locate(x_pos, y_pos, z_pos)

/area/proc/move_contents_to(area/A, turftoleave=null, direction = null)
	//Takes: Area. Optional: turf type to leave behind.
	//Returns: Nothing.
	//Notes: Attempts to move the contents of one area to another area.
	//    Movement based on lower left corner. Tiles that do not fit
	//  into the new area will not be moved.

	if(!A || !src) return 0

	var/list/turfs_src = get_area_turfs(src.type)
	var/list/turfs_trg = get_area_turfs(A.type)

	var/src_min_x = 0
	var/src_min_y = 0
	for (var/turf/T in turfs_src)
		if(T.x < src_min_x || !src_min_x) src_min_x = T.x
		if(T.y < src_min_y || !src_min_y) src_min_y = T.y

	var/trg_min_x = 0
	var/trg_min_y = 0
	for (var/turf/T in turfs_trg)
		if(T.x < trg_min_x || !trg_min_x) trg_min_x = T.x
		if(T.y < trg_min_y || !trg_min_y) trg_min_y = T.y

	var/list/refined_src = new/list()
	for(var/turf/T in turfs_src)
		refined_src += T
		refined_src[T] = new/datum/coords
		var/datum/coords/C = refined_src[T]
		C.x_pos = (T.x - src_min_x)
		C.y_pos = (T.y - src_min_y)

	var/list/refined_trg = new/list()
	for(var/turf/T in turfs_trg)
		refined_trg += T
		refined_trg[T] = new/datum/coords
		var/datum/coords/C = refined_trg[T]
		C.x_pos = (T.x - trg_min_x)
		C.y_pos = (T.y - trg_min_y)

	var/list/fromupdate = new/list()
	var/list/toupdate = new/list()

	moving:
		for (var/turf/T in refined_src)
			var/datum/coords/C_src = refined_src[T]
			for (var/turf/B in refined_trg)
				var/datum/coords/C_trg = refined_trg[B]
				if(C_src.x_pos == C_trg.x_pos && C_src.y_pos == C_trg.y_pos)

					var/old_dir1 = T.dir
					var/old_icon_state1 = T.icon_state
					var/old_icon1 = T.icon

					var/turf/X = B.ChangeTurf(T.type)
					if (X)
						X.setDir(old_dir1)
						X.icon_state = old_icon_state1
						X.icon = old_icon1 //Shuttle floors are in shuttle.dmi while the defaults are floors.dmi

					/* Quick visual fix for some weird shuttle corner artefacts when on transit space tiles */
					if(direction && findtext(X.icon_state, "swall_s"))

						// Spawn a new shuttle corner object
						var/obj/corner = new()
						corner.forceMove(X)
						corner.density = TRUE
						corner.anchored = TRUE
						corner.icon = X.icon
						corner.icon_state = replacetext(X.icon_state, "_s", "_f")
						corner.tag = "delete me"
						corner.name = "wall"

						// Find a new turf to take on the property of
						var/turf/nextturf = get_step(corner, direction)
						if(!nextturf || !istype(nextturf, /turf/open/space))
							nextturf = get_step(corner, turn(direction, 180))


						// Take on the icon of a neighboring scrolling space icon
						X.icon = nextturf.icon
						X.icon_state = nextturf.icon_state


					for(var/obj/O in T)
						// Reset the shuttle corners
						if(O.tag == "delete me")
							X.icon = 'icons/turf/shuttle.dmi'
							X.icon_state = replacetext(O.icon_state, "_f", "_s") // revert the turf to the old icon_state
							X.name = "wall"
							qdel(O) // prevents multiple shuttle corners from stacking
							continue
						if(!istype(O,/obj)) continue
						O.forceMove(X)
					for(var/mob/M in T)
						if(!istype(M,/mob) || istype(M, /mob/aiEye)) continue // If we need to check for more mobs, I'll add a variable
						M.forceMove(X)

// var/area/AR = X.loc

// if(AR.lighting_use_dynamic) //TODO: rewrite this code so it's not messed by lighting ~Carn
// X.opacity = !X.opacity
// X.set_opacity(!X.opacity)

					toupdate += X

					if(turftoleave)
						fromupdate += T.ChangeTurf(turftoleave)
					else
						T.ChangeTurf(/turf/open/space)

					refined_src -= T
					refined_trg -= B
					continue moving

	var/list/doors = new/list()

	if(toupdate.len)
		for(var/turf/T1 in toupdate)
			for(var/obj/structure/machinery/door/D2 in T1)
				doors += D2
			/*if(T1.parent)
				air_master.groups_to_rebuild += T1.parent
			else
				air_master.tiles_to_update += T1*/

	if(fromupdate.len)
		for(var/turf/T2 in fromupdate)
			for(var/obj/structure/machinery/door/D2 in T2)
				doors += D2
			/*if(T2.parent)
				air_master.groups_to_rebuild += T2.parent
			else
				air_master.tiles_to_update += T2*/

/proc/get_cardinal_dir(atom/A, atom/B)
	var/dx = abs(B.x - A.x)
	var/dy = abs(B.y - A.y)
	return get_dir(A, B) & (rand() * (dx+dy) < dy ? 3 : 12)


//Returns the 2 dirs perpendicular to the arg
/proc/get_perpen_dir(dir)
	if(dir & (dir-1))
		return 0 //diagonals
	if(dir & (EAST|WEST))
		return list(SOUTH, NORTH)
	else
		return list(EAST, WEST)


/proc/parse_zone(zone)
	if(zone == "r_hand") return "right hand"
	else if (zone == "l_hand") return "left hand"
	else if (zone == "l_arm") return "left arm"
	else if (zone == "r_arm") return "right arm"
	else if (zone == "l_leg") return "left leg"
	else if (zone == "r_leg") return "right leg"
	else if (zone == "l_foot") return "left foot"
	else if (zone == "r_foot") return "right foot"
	else if (zone == "l_hand") return "left hand"
	else if (zone == "r_hand") return "right hand"
	else if (zone == "l_foot") return "left foot"
	else if (zone == "r_foot") return "right foot"
	else return zone

/proc/get_true_location(atom/loc)
	var/atom/subLoc = loc
	while(subLoc.z == 0)
		if (istype(subLoc.loc, /atom))
			subLoc = subLoc.loc
		else
			return subLoc
	return subLoc

#define get_true_turf(loc) get_turf(get_true_location(loc))

/proc/reverse_nearby_direction(direction)
	switch(direction)
		if(NORTH) return list(SOUTH,  SOUTHEAST, SOUTHWEST)
		if(NORTHEAST) return list(SOUTHWEST, SOUTH,  WEST)
		if(EAST) return list(WEST,   SOUTHWEST, NORTHWEST)
		if(SOUTHEAST) return list(NORTHWEST, NORTH,  WEST)
		if(SOUTH) return list(NORTH,  NORTHEAST, NORTHWEST)
		if(SOUTHWEST) return list(NORTHEAST, NORTH,  EAST)
		if(WEST) return list(EAST,   NORTHEAST, SOUTHEAST)
		if(NORTHWEST) return list(SOUTHEAST, SOUTH,  EAST)

/*
Checks if that loc and dir has a item on the wall
*/
GLOBAL_LIST_INIT(WALLITEMS, list(
	/obj/structure/machinery/power/apc,
	/obj/structure/machinery/alarm,
	/obj/item/device/radio/intercom,
	/obj/structure/extinguisher_cabinet,
	/obj/structure/reagent_dispensers/peppertank,
	/obj/structure/machinery/status_display,
	/obj/structure/machinery/requests_console,
	/obj/structure/machinery/light_switch,
	/obj/structure/machinery/newscaster,
	/obj/structure/machinery/firealarm,
	/obj/structure/noticeboard,
	/obj/structure/machinery/door_control,
	/obj/structure/machinery/computer/cameras/telescreen,
	/obj/item/storage/secure/safe,
	/obj/structure/machinery/brig_cell,
	/obj/structure/machinery/flasher,
	/obj/structure/machinery/keycard_auth,
	/obj/structure/mirror,
	/obj/structure/closet/fireaxecabinet,
	/obj/structure/machinery/computer/cameras/telescreen/entertainment,
	))

/proc/gotwallitem(loc, dir)
	for(var/obj/O in loc)
		for(var/item in GLOB.WALLITEMS)
			if(istype(O, item))
				//Direction works sometimes
				if(O.dir == dir)
					return 1

				//Some stuff doesn't use dir properly, so we need to check pixel instead
				switch(dir)
					if(SOUTH)
						if(O.pixel_y > 10)
							return 1
					if(NORTH)
						if(O.pixel_y < -10)
							return 1
					if(WEST)
						if(O.pixel_x > 10)
							return 1
					if(EAST)
						if(O.pixel_x < -10)
							return 1


	//Some stuff is placed directly on the wallturf (signs)
	for(var/obj/O in get_step(loc, dir))
		for(var/item in GLOB.WALLITEMS)
			if(istype(O, item))
				if(O.pixel_x == 0 && O.pixel_y == 0)
					return 1
	return 0

/proc/format_text(text)
	return replacetext(replacetext(text,"\proper ",""),"\improper ","")

/**
 * Get a list of turfs in a line from `start_atom` to `end_atom`.
 *
 * Based on a linear interpolation method from [Red Blob Games](https://www.redblobgames.com/grids/line-drawing/#optimization).
 *
 * Arguments:
 * * start_atom - starting point of the line
 * * end_atom - ending point of the line
 * * include_start_atom - when truthy includes start_atom in the list, default TRUE
 *
 * Returns:
 * list - turfs from start_atom (in/exclusive) to end_atom (inclusive)
 */
/proc/get_line(atom/start_atom, atom/end_atom, include_start_atom = TRUE)
	var/turf/start_turf = get_turf(start_atom)
	var/turf/end_turf = get_turf(end_atom)
	var/start_z = start_turf.z

	var/list/line = list()
	if(include_start_atom)
		line += start_turf

	var/step_count = get_dist(start_turf, end_turf)
	if(!step_count)
		return line

	//as step_count and step size (1) are known can pre-calculate a lerp step, tiny number (1e-5) for rounding consistency
	var/step_x = (end_turf.x - start_turf.x) / step_count + 1e-5
	var/step_y = (end_turf.y - start_turf.y) / step_count + 1e-5

	//locate() truncates the fraction, adding 0.5 so its effectively rounding to nearest coords for free
	var/x = start_turf.x + 0.5
	var/y = start_turf.y + 0.5
	for(var/step in 1 to (step_count - 1)) //increment then locate() skips start_turf (in 1), since end_turf is known can skip that step too (step_count - 1)
		x += step_x
		y += step_y
		line += locate(x, y, start_z)

	line += end_turf

	return line

//Key thing that stops lag. Cornerstone of performance in ss13, Just sitting here, in unsorted.dm.

//Increases delay as the server gets more overloaded,
//as sleeps aren't cheap and sleeping only to wake up and sleep again is wasteful
#define DELTA_CALC max(((max(TICK_USAGE, world.cpu) / 100) * max(Master.sleep_delta-1,1)), 1)

//returns the number of ticks slept
/proc/stoplag(initial_delay)
	if (!Master || !(Master.current_runlevel & RUNLEVELS_DEFAULT))
		sleep(world.tick_lag)
		return 1
	if (!initial_delay)
		initial_delay = world.tick_lag
	. = 0
	var/i = DS2TICKS(initial_delay)
	do
		. += ceil(i*DELTA_CALC)
		sleep(i*world.tick_lag*DELTA_CALC)
		i *= 2
	while (TICK_USAGE > min(TICK_LIMIT_TO_RUN, Master.current_ticklimit))

#undef DELTA_CALC

/proc/get_random_turf_in_range(atom/origin, outer_range, inner_range)
	origin = get_turf(origin)
	if(!origin)
		return
	var/list/turfs = list()
	for(var/turf/T in orange(origin, outer_range))
		if(!inner_range || get_dist(origin, T) >= inner_range)
			turfs += T
	if(turfs.len)
		return pick(turfs)

// Returns true if arming a given explosive might be considered grief
// Explosives are considered "griefy" if they are primed when all the following are true:
// * The explosive is on the Almayer/dropship transit z levels
// * The alert level is green/blue (alternatively, not red+)
// * The dropship crash hasn't happened yet
// * An admin hasn't disabled explosive antigrief
// Certain areas may be exempt from this check. Look up explosive_antigrief_exempt_areas
/proc/explosive_antigrief_check(obj/item/explosive/explosive, mob/user)
	var/turf/Turf = get_turf(explosive)
	if(!(Turf.loc.type in GLOB.explosive_antigrief_exempt_areas))
		var/crash_occurred = (SSticker?.mode?.is_in_endgame)
		if((Turf.z in SSmapping.levels_by_any_trait(list(ZTRAIT_MARINE_MAIN_SHIP, ZTRAIT_RESERVED))) && (GLOB.security_level < SEC_LEVEL_RED) && !crash_occurred)
			switch(CONFIG_GET(number/explosive_antigrief))
				if(ANTIGRIEF_DISABLED)
					return FALSE
				if(ANTIGRIEF_NEW_PLAYERS) //if they have less than 10 hours, dont let them prime nades
					if(user.client && user.client.get_total_human_playtime() < JOB_PLAYTIME_TIER_1)
						return TRUE
				else //ANTIGRIEF_ENABLED
					return TRUE
	return FALSE

/proc/flick_overlay(atom/target, overlay, time)
	target.overlays += overlay
	addtimer(CALLBACK(GLOBAL_PROC, GLOBAL_PROC_REF(remove_timed_overlay), target, overlay), time)

/proc/remove_timed_overlay(atom/target, overlay)
	target.overlays -= overlay

// A proc purely for a callback that returns TRUE (and does nothing else)
/proc/_callback_true()
	return TRUE

// A proc purely for a callback that returns FALSE (and does nothing else)
/proc/_callback_false()
	return FALSE

/atom/proc/contains(atom/A)
	if(!A)
		return FALSE
	for(var/atom/location = A.loc, location, location = location.loc)
		if(location == src)
			return TRUE

GLOBAL_DATUM_INIT(dview_mob, /mob/dview, new)

/// Version of view() which ignores darkness, because BYOND doesn't have it (I actually suggested it but it was tagged redundant, BUT HEARERS IS A T- /rant).
/proc/dview(range = world.view, center, invis_flags = 0)
	if(!center)
		return

	GLOB.dview_mob.loc = center

	GLOB.dview_mob.see_invisible = invis_flags

	. = view(range, GLOB.dview_mob)
	GLOB.dview_mob.loc = null

/mob/dview
	name = "INTERNAL DVIEW MOB"
	invisibility = 101
	density = FALSE
	see_in_dark = 1e6
	var/ready_to_die = FALSE

/mob/dview/Initialize() //Properly prevents this mob from gaining huds or joining any global lists
	SHOULD_CALL_PARENT(FALSE)
	if(flags_atom & INITIALIZED)
		stack_trace("Warning: [src]([type]) initialized multiple times!")
	flags_atom |= INITIALIZED
	return INITIALIZE_HINT_NORMAL

/mob/dview/Destroy(force = FALSE)
	if(!ready_to_die)
		stack_trace("ALRIGHT WHICH FUCKER TRIED TO DELETE *MY* DVIEW?")

		if (!force)
			return QDEL_HINT_LETMELIVE

		log_world("EVACUATE THE SHITCODE IS TRYING TO STEAL MUH JOBS")
		GLOB.dview_mob = new
	return ..()


#define FOR_DVIEW(type, range, center, invis_flags) \
	GLOB.dview_mob.loc = center;           \
	GLOB.dview_mob.see_invisible = invis_flags; \
	for(type in view(range, GLOB.dview_mob))

#define FOR_DVIEW_END GLOB.dview_mob.loc = null

/proc/get_turf_pixel(atom/AM)
	if(!istype(AM))
		return

	//Find AM's matrix so we can use it's X/Y pixel shifts
	var/matrix/M = matrix(AM.transform)

	var/pixel_x_offset = AM.pixel_x + M.get_x_shift()
	var/pixel_y_offset = AM.pixel_y + M.get_y_shift()

	//Irregular objects
	var/icon/AMicon = icon(AM.icon, AM.icon_state)
	var/AMiconheight = AMicon.Height()
	var/AMiconwidth = AMicon.Width()
	if(AMiconheight != world.icon_size || AMiconwidth != world.icon_size)
		pixel_x_offset += ((AMiconwidth/world.icon_size)-1)*(world.icon_size*0.5)
		pixel_y_offset += ((AMiconheight/world.icon_size)-1)*(world.icon_size*0.5)

	//DY and DX
	var/rough_x = floor(round(pixel_x_offset,world.icon_size)/world.icon_size)
	var/rough_y = floor(round(pixel_y_offset,world.icon_size)/world.icon_size)

	//Find coordinates
	var/turf/T = get_turf(AM) //use AM's turfs, as it's coords are the same as AM's AND AM's coords are lost if it is inside another atom
	if(!T)
		return null
	var/final_x = T.x + rough_x
	var/final_y = T.y + rough_y

	if(final_x || final_y)
		return locate(final_x, final_y, T.z)

//used to check if a mob can examine an object
/atom/proc/can_examine(mob/user)
	if(!user.client)
		return FALSE
	if(isRemoteControlling(user))
		return TRUE
	// If the user is not a xeno (with active ability) with the shift click pref on, we examine. God forgive me for snowflake
	if(user.client?.prefs && !(user.client?.prefs?.toggle_prefs & TOGGLE_MIDDLE_MOUSE_CLICK))
		if(isxeno(user))
			var/mob/living/carbon/xenomorph/X = user
			if(X.selected_ability)
				return FALSE
		else if(ishuman(user))
			var/mob/living/carbon/human/H = user
			if(H.selected_ability)
				return FALSE
	if(user.client.eye == user && !user.is_mob_incapacitated(TRUE))
		user.face_atom(src)
	return TRUE

#define VARSET_LIST_CALLBACK(target, var_name, var_value) CALLBACK(GLOBAL_PROC, GLOBAL_PROC_REF(___callbackvarset), ##target, ##var_name, ##var_value)
//dupe code because dm can't handle 3 level deep macros
#define VARSET_CALLBACK(datum, var, var_value) CALLBACK(GLOBAL_PROC, GLOBAL_PROC_REF(___callbackvarset), ##datum, NAMEOF(##datum, ##var), ##var_value)
/// Same as VARSET_CALLBACK, but uses a weakref to the datum.
/// Use this if the timer is exceptionally long.
#define VARSET_WEAK_CALLBACK(datum, var, var_value) CALLBACK(GLOBAL_PROC, GLOBAL_PROC_REF(___callbackvarset), WEAKREF(##datum), NAMEOF(##datum, ##var), ##var_value)

/proc/___callbackvarset(list_or_datum, var_name, var_value)
	if(length(list_or_datum))
		list_or_datum[var_name] = var_value
		return

	var/datum/datum = list_or_datum

	if (isweakref(datum))
		var/datum/weakref/datum_weakref = datum
		datum = datum_weakref.resolve()
		if (isnull(datum))
			return

	if(IsAdminAdvancedProcCall())
		datum.vv_edit_var(var_name, var_value) //same result generally, unless badmemes
	else
		datum.vars[var_name] = var_value

//don't question just accept
/proc/pass(...)
	return

//gives us the stack trace from CRASH() without ending the current proc.
/proc/stack_trace(msg)
	CRASH(msg)

// \ref behaviour got changed in 512 so this is necesary to replicate old behaviour.
// If it ever becomes necesary to get a more performant REF(), this lies here in wait
// #define REF(thing) (thing && istype(thing, /datum) && (thing:datum_flags & DF_USE_TAG) && thing:tag ? "[thing:tag]" : "\ref[thing]")
/proc/REF(input)
	if(istype(input, /datum))
		var/datum/thing = input
		if(thing.datum_flags & DF_USE_TAG)
			if(!thing.tag)
				stack_trace("A ref was requested of an object with DF_USE_TAG set but no tag: [thing]")
				thing.datum_flags &= ~DF_USE_TAG
			else
				return "\[[url_encode(thing.tag)]\]"
	return "\ref[input]"

/proc/CallAsync(datum/source, proctype, list/arguments)
	set waitfor = FALSE
	return call(source, proctype)(arglist(arguments))

// Helper to proxy speech from an hearing object to a mob, usually containing
// This allows hearing independently of speech broadcast by say.dm
// Currently useful due to the lack of recursion by speech code and its perf impact
// Disable by commenting/undefining the line below!
#define OBJECTS_PROXY_SPEECH
#ifdef OBJECTS_PROXY_SPEECH
/proc/proxy_object_heard(obj/object, mob/living/sourcemob, mob/living/targetmob, message, verb, language, italics)
	if(QDELETED(sourcemob) || !istype(sourcemob) || QDELETED(targetmob) || !istype(targetmob) || (targetmob.stat == DEAD))
		return
	targetmob.hear_say(message, verb, language, "", italics, sourcemob) // proxies speech itself to the mob
	if(targetmob && targetmob.client && targetmob.client.prefs && !targetmob.client.prefs.lang_chat_disabled \
	   && !targetmob.ear_deaf && targetmob.say_understands(sourcemob, language))
		sourcemob.langchat_display_image(targetmob) // strap langchat display on
#endif // ifdef OBJECTS_PROXY_SPEECH

#define UNTIL(X) while(!(X)) stoplag()

//Repopulates sortedAreas list
/proc/repopulate_sorted_areas()
	GLOB.sorted_areas = list()

	for(var/area/A in world)
		GLOB.sorted_areas.Add(A)

	sortTim(GLOB.sorted_areas, GLOBAL_PROC_REF(cmp_name_asc))

/atom/proc/GetAllContentsIgnoring(list/ignore_typecache)
	if(!length(ignore_typecache))
		return GetAllContents()
	var/list/processing = list(src)
	var/list/assembled = list()
	while(processing.len)
		var/atom/A = processing[1]
		processing.Cut(1,2)
		if(!ignore_typecache[A.type])
			processing += A.contents
			assembled += A
	return assembled

// Returns a list where [1] is all x values and [2] is all y values that overlap between the given pair of rectangles
/proc/get_overlap(x1, y1, x2, y2, x3, y3, x4, y4)
	var/list/region_x1 = list()
	var/list/region_y1 = list()
	var/list/region_x2 = list()
	var/list/region_y2 = list()

	// These loops create loops filled with x/y values that the boundaries inhabit
	// ex: list(5, 6, 7, 8, 9)
	for(var/i in min(x1, x2) to max(x1, x2))
		region_x1["[i]"] = TRUE
	for(var/i in min(y1, y2) to max(y1, y2))
		region_y1["[i]"] = TRUE
	for(var/i in min(x3, x4) to max(x3, x4))
		region_x2["[i]"] = TRUE
	for(var/i in min(y3, y4) to max(y3, y4))
		region_y2["[i]"] = TRUE

	return list(region_x1 & region_x2, region_y1 & region_y2)

//Vars that will not be copied when using /DuplicateObject
GLOBAL_LIST_INIT(duplicate_forbidden_vars,list(
	"tag", "datum_components", "area", "type", "loc", "locs", "vars", "parent", "parent_type", "verbs", "ckey", "key",
	"power_supply", "contents", "reagents", "stat", "x", "y", "z", "group", "atmos_adjacent_turfs", "comp_lookup",
	"client_mobs_in_contents", "bodyparts", "internal_organs", "hand_bodyparts", "overlays_standing", "hud_list",
	"actions", "AIStatus", "appearance", "managed_overlays", "managed_vis_overlays", "computer_id", "lastKnownIP", "implants",
	"tgui_shared_states"
	))

/proc/DuplicateObject(atom/original, perfectcopy = TRUE, sameloc, atom/newloc = null)
	RETURN_TYPE(original.type)
	if(!original)
		return
	var/atom/O

	if(sameloc)
		O = new original.type(original.loc)
	else
		O = new original.type(newloc)

	if(perfectcopy && O && original)
		for(var/V in original.vars - GLOB.duplicate_forbidden_vars)
			if(islist(original.vars[V]))
				var/list/L = original.vars[V]
				O.vars[V] = L.Copy()
			else if(istype(original.vars[V], /datum) || ismob(original.vars[V]))
				continue // this would reference the original's object, that will break when it is used or deleted.
			else
				O.vars[V] = original.vars[V]

	if(ismob(O)) //Overlays are carried over despite disallowing them, if a fix is found remove this.
		var/mob/M = O
		M.overlays.Cut()
		M.regenerate_icons()
	return O

///Returns a list of all items of interest with their name
/proc/getpois(mobs_only = FALSE, skip_mindless = FALSE, specify_dead_role = TRUE)
	var/list/mobs = sortmobs()
	var/list/namecounts = list()
	var/list/pois = list()
	for(var/mob/M as anything in mobs)
		if(skip_mindless && (!M.mind && !M.ckey))
			continue
		if(M.client?.admin_holder)
			if(M.client.admin_holder.fakekey || M.client.admin_holder.invisimined) //stealthmins
				continue
		var/name = avoid_assoc_duplicate_keys(M.name, namecounts)

		if(M.real_name && M.real_name != M.name)
			name += " \[[M.real_name]\]"
		if(M.stat == DEAD && specify_dead_role)
			if(isobserver(M))
				name += " \[ghost\]"
			else
				name += " \[dead\]"
		pois[name] = M

	pois.Add(get_multi_vehicles())

	return pois

//takes an input_key, as text, and the list of keys already used, outputting a replacement key in the format of "[input_key] ([number_of_duplicates])" if it finds a duplicate
//use this for lists of things that might have the same name, like mobs or objects, that you plan on giving to a player as input
/proc/avoid_assoc_duplicate_keys(input_key, list/used_key_list)
	if(!input_key || !istype(used_key_list))
		return
	if(used_key_list[input_key])
		used_key_list[input_key]++
		input_key = "[input_key] ([used_key_list[input_key]])"
	else
		used_key_list[input_key] = 1
	return input_key

//Returns the atom sitting on the turf.
//For example, using this on a disk, which is in a bag, on a mob, will return the mob because it's on the turf.
//Optional arg 'type' to stop once it reaches a specific type instead of a turf.
/proc/get_atom_on_turf(atom/movable/M, stop_type)
	var/atom/turf_to_check = M
	while(turf_to_check?.loc && !isturf(turf_to_check.loc))
		turf_to_check = turf_to_check.loc
		if(stop_type && istype(turf_to_check, stop_type))
			break
	return turf_to_check

/// Given a direction, return the direction and the +-45 degree directions next to it
/proc/get_related_directions(direction = NORTH)
	switch(direction)
		if(NORTH)
			return list(NORTH, NORTHEAST, NORTHWEST)

		if(EAST)
			return list(EAST, NORTHEAST, SOUTHEAST)

		if(SOUTH)
			return list(SOUTH, SOUTHEAST, SOUTHWEST)

		if(WEST)
			return list(WEST, NORTHWEST, SOUTHWEST)

		if(NORTHEAST)
			return list(NORTHEAST, NORTH, EAST)

		if(SOUTHEAST)
			return list(SOUTHEAST, EAST, SOUTH)

		if(SOUTHWEST)
			return list(SOUTHWEST, SOUTH, WEST)

		if(NORTHWEST)
			return list(NORTHWEST, NORTH, WEST)

/// Returns TRUE if the target is somewhere that the game should not interact with if possible
/// In this case, admin Zs and tutorial areas
/proc/should_block_game_interaction(atom/target)
	if(is_admin_level(target.z))
		return TRUE

	var/area/target_area = get_area(target)
	if(target_area?.block_game_interaction)
		return TRUE

	return FALSE
