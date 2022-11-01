/*
 * A large number of misc global proc and define helpers.
 */

// GLOBAL DEFINES //
#define is_hot(I) (I?:heat_source)

//Whether or not the given item counts as sharp in terms of dealing damage
#define is_sharp(I) (isitem(I) && I?:sharp && I?:edge)

//Whether or not the given item counts as cutting with an edge in terms of removing limbs
#define has_edge(I) (isitem(I) && I?:edge)

//Returns 1 if the given item is capable of popping things like balloons, inflatable barriers, or cutting police tape.
// For the record, WHAT THE HELL IS THIS METHOD OF DOING IT?
#define can_puncture(W) (isitem(W) && (W.sharp || W.heat_source >= 400 || \
							HAS_TRAIT(W, TRAIT_TOOL_SCREWDRIVER) || istype(W, /obj/item/tool/pen ) || istype(W, /obj/item/tool/shovel)) \
						)

//Makes sure MIDDLE is between LOW and HIGH. If not, it adjusts it. Returns the adjusted value.
#define between(low, middle, high) (max(min(middle, high), low))

//Offuscate x for coord system
#define obfuscate_x(x) (x + obfs_x)

//Offuscate y for coord system
#define obfuscate_y(y) (y + obfs_y)

//Deoffuscate x for coord system
#define deobfuscate_x(x) (x - obfs_x)

//Deoffuscate y for coord system
#define deobfuscate_y(y) (y - obfs_y)

#define can_xeno_build(T) (!T.density && !(locate(/obj/structure/fence) in T) && !(locate(/obj/structure/tunnel) in T) && (locate(/obj/effect/alien/weeds) in T))

// For the purpose of a skillcheck, not having a skillset counts as being skilled in everything (!user.skills check)
// Note that is_skilled() checks if the skillset contains the skill internally, so a has_skill check is unnecessary
#define skillcheck(user, skill, req_level) ((!user.skills || user.skills.is_skilled(skill, req_level)))
#define skillcheckexplicit(user, skill, req_level) ((!user.skills || user.skills.is_skilled(skill, req_level, TRUE)))

// Ensure the frequency is within bounds of what it should be sending/receiving at
// Sets f within bounds via `Clamp(round(f), 1441, 1489)`
// If f is even, adds 1 to its value to make it odd
#define sanitize_frequency(f) 	((Clamp(round(f), 1441, 1489) % 2) == 0 ? \
									Clamp(round(f), 1441, 1489) + 1 : \
									Clamp(round(f), 1441, 1489) \
								)

//Turns 1479 into 147.9
#define format_frequency(f) "[round(f / 10)].[f % 10]"

#define reverse_direction(direction) 	( \
											( dir & (NORTH|SOUTH) ? ~dir & (NORTH|SOUTH) : 0 ) | \
											( dir & (EAST|WEST) ? ~dir & (EAST|WEST) : 0 ) \
										)

// The sane, counter-clockwise angle to turn to get from /direction/ A to /direction/ B
#define turning_angle(a, b) -(dir2angle(b) - dir2angle(a))


// GLOBAL PROCS //

//Returns the middle-most value
/proc/dd_range(var/low, var/high, var/num)
	return max(low,min(high,num))

//Returns whether or not A is the middle most value
/proc/InRange(var/A, var/lower, var/upper)
	if(A < lower) return 0
	if(A > upper) return 0
	return 1


/proc/Get_Angle(atom/start,atom/end)//For beams.
	if(!start || !end) return 0
	if(!start.z || !end.z) return 0 //Atoms are not on turfs.
	var/dy
	var/dx
	dy=(32*end.y+end.pixel_y)-(32*start.y+start.pixel_y)
	dx=(32*end.x+end.pixel_x)-(32*start.x+start.pixel_x)
	if(!dy)
		return (dx>=0)?90:270
	.=arctan(dx/dy)
	if(dy<0)
		.+=180
	else if(dx<0)
		.+=360

/proc/Get_Compass_Dir(atom/start,atom/end)//get_dir() only considers an object to be north/south/east/west if there is zero deviation. This uses rounding instead.
	if(!start || !end) return 0
	if(!start.z || !end.z) return 0 //Atoms are not on turfs.
	var/dy=end.y-start.y
	var/dx=end.x-start.x
	if(!dy)
		return (dx>=0)?4:8
	var/angle=arctan(dx/dy)
	if(dy<0)
		angle+=180
	else if(dx<0)
		angle+=360

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


// Among other things, used by flamethrower and boiler spray to calculate if flame/spray can pass through.
// Returns an atom for specific effects (primarily flames and acid spray) that damage things upon contact
//
// This is a copy-and-paste of the Enter() proc for turfs with tweaks related to the applications
// of LinkBlocked
/proc/LinkBlocked(var/atom/movable/mover, var/turf/start_turf, var/turf/target_turf, var/list/atom/forget)
	if (!mover)
		return null

	var/fdir = get_dir(start_turf, target_turf)
	if (!fdir)
		return null


	var/fd1 = fdir&(fdir-1)
	var/fd2 = fdir - fd1


	var/blocking_dir = 0 // The direction that mover's path is being blocked by

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
		if ((!fd1 || blocking_dir & fd1) && (!fd2 || blocking_dir & fd2))
			return A

	return null // Nothing found to block the link of mover from start_turf to target_turf


/proc/TurfBlockedNonWindow(turf/loc)
	for(var/obj/O in loc)
		if(O.density && !istype(O, /obj/structure/window))
			return 1
	return 0



/proc/sign(x)
	return x!=0?x/abs(x):0

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
/mob/proc/fully_replace_character_name(var/oldname,var/newname)
	if(!newname)	return 0
	change_real_name(src, newname)

	if(oldname)
		//update the datacore records! This is goig to be a bit costly.
		var/mob_ref = WEAKREF(src)
		for(var/list/L in list(GLOB.data_core.general, GLOB.data_core.medical, GLOB.data_core.security, GLOB.data_core.locked))
			for(var/datum/data/record/R in L)
				if(R.fields["ref"] == mob_ref)
					R.fields["name"] = newname
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
					if(!search_pda)	break
					search_id = 0
	return 1



//Generalised helper proc for letting mobs rename themselves. Used to be clname() and ainame()
//Last modified by Carn
/mob/proc/rename_self(var/role, var/allow_numbers=0)
	var/oldname = real_name
	var/time_passed = world.time

	var/newname
	for(var/i=1,i<=3,i++)	//we get 3 attempts to pick a suitable name.
		newname = input(src,"You are a [role]. Would you like to change your name to something else?", "Name change",oldname) as text
		if((world.time-time_passed)>300)
			return	//took too long
		newname = reject_bad_name(newname,allow_numbers)	//returns null if the name doesn't meet some basic requirements. Tidies up a few other things like bad-characters.
		for(var/mob/living/M in GLOB.alive_mob_list)
			if(M == src)
				continue

			if(!newname || M.real_name == newname)
				newname = null
				break

		if(newname)
			break	//That's a suitable name!
		to_chat(src, "Sorry, that [role]-name wasn't appropriate, please try another. It's possibly too long/short, has bad characters or is already taken.")

	if(!newname)	//we'll stick with the oldname then
		return

	if(cmptext("ai",role))
		if(isAI(src))
			var/mob/living/silicon/ai/A = src
			oldname = null//don't bother with the records update crap
			A.SetName(newname)

	fully_replace_character_name(oldname,newname)



//When a borg is activated, it can choose which AI it wants to be slaved to
/proc/active_ais()
	. = list()
	for(var/mob/living/silicon/ai/A in GLOB.alive_mob_list)
		if(A.stat == DEAD)
			continue
		if(A.control_disabled == 1)
			continue
		. += A
	return .

//Find an active ai with the least borgs. VERBOSE PROCNAME HUH!
/proc/select_active_ai_with_fewest_borgs()
	var/mob/living/silicon/ai/selected
	var/list/active = active_ais()
	for(var/mob/living/silicon/ai/A in active)
		if(!selected || (selected.connected_robots > A.connected_robots))
			selected = A

	return selected

/proc/select_active_ai(var/mob/user)
	var/list/ais = active_ais()
	if(ais.len)
		if(user)	. = tgui_input_list(usr,"AI signals detected:", "AI selection", ais)
		else		. = pick(ais)
	return .

/proc/get_sorted_mobs()
	var/list/old_list = getmobs()
	var/list/AI_list = list()
	var/list/Dead_list = list()
	var/list/keyclient_list = list()
	var/list/key_list = list()
	var/list/logged_list = list()
	for(var/named in old_list)
		var/mob/M = old_list[named]
		if(isSilicon(M))
			AI_list |= M
		else if(isobserver(M) || M.stat == 2)
			Dead_list |= M
		else if(M.key && M.client)
			keyclient_list |= M
		else if(M.key)
			key_list |= M
		else
			logged_list |= M
		old_list.Remove(named)
	var/list/new_list = list()
	new_list += AI_list
	new_list += keyclient_list
	new_list += key_list
	new_list += logged_list
	new_list += Dead_list
	return new_list

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

/proc/getxenos()
	var/list/mobs = sortxenos()
	var/list/names = list()
	var/list/creatures = list()
	var/list/namecounts = list()
	for(var/mob/M in mobs)
		var/name = M.name
		if (name in names)
			namecounts[name]++
			name = "[name] ([namecounts[name]])"
		else
			names.Add(name)
			namecounts[name] = 1
		if(isobserver(M))
			name += " \[ghost\]"
		else if(M.stat == DEAD)
			name += " \[dead\]"
		creatures[name] = M
	return creatures

/proc/getpreds()
	var/list/mobs = sortpreds()
	var/list/names = list()
	var/list/creatures = list()
	var/list/namecounts = list()
	for(var/mob/M in mobs)
		if(!isYautja(M)) continue
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

/proc/gethumans()
	var/list/mobs = sorthumans()
	var/list/names = list()
	var/list/creatures = list()
	var/list/namecounts = list()
	for(var/mob/M in mobs)
		if(isYautja(M)) continue
		if(iszombie(M))	continue
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

/proc/getsurvivors()
	var/list/mobs = sortsurvivors()
	var/list/names = list()
	var/list/creatures = list()
	var/list/namecounts = list()
	for(var/mob/M in mobs)
		if(isYautja(M)) continue
		if(iszombie(M))	continue
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

/proc/getertmembers()
	var/list/mobs = sortertmembers()
	var/list/names = list()
	var/list/creatures = list()
	var/list/namecounts = list()
	for(var/mob/M in mobs)
		if(isYautja(M)) continue
		if(iszombie(M))	continue
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

/proc/getsynths()
	var/list/mobs = sortsynths()
	var/list/names = list()
	var/list/creatures = list()
	var/list/namecounts = list()
	for(var/mob/M in mobs)
		if(isYautja(M)) continue
		if(iszombie(M))	continue
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

/proc/get_holograms()
	var/list/holograms = list()
	var/list/namecounts = list()
	for(var/i in GLOB.hologram_list)
		var/mob/hologram/H = i
		var/name = H.name
		if(name in namecounts)
			namecounts[name]++
			name = "[name] #([namecounts[name]])"
		else
			namecounts[name] = 1

		holograms[name] = H

	return holograms

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
	for(var/mob/living/carbon/Xenomorph/M in sortmob)
		moblist.Add(M)
	for(var/mob/dead/observer/M in sortmob)
		moblist.Add(M)
	for(var/mob/new_player/M in sortmob)
		moblist.Add(M)
	for(var/mob/living/carbon/human/monkey/M in sortmob)
		moblist.Add(M)
	for(var/mob/living/simple_animal/M in sortmob)
		moblist.Add(M)
	return moblist

/proc/sortxenos()
	var/list/xenolist = list()
	var/list/sortmob = sortAtom(GLOB.xeno_mob_list)
	for(var/mob/living/carbon/Xenomorph/M in sortmob)
		if(!M.client)
			continue
		xenolist.Add(M)
	return xenolist

/proc/sortpreds()
	var/list/predlist = list()
	var/list/sortmob = sortAtom(GLOB.human_mob_list)
	for(var/mob/living/carbon/human/M in sortmob)
		if(!M.client || !M.species.name == "Yautja")
			continue
		predlist.Add(M)
	return predlist

/proc/sorthumans()
	var/list/humanlist = list()
	var/list/sortmob = sortAtom(GLOB.human_mob_list)
	for(var/mob/living/carbon/human/M in sortmob)
		if(!M.client || M.species.name == "Yautja")
			continue
		humanlist.Add(M)
	return humanlist

/proc/sortsurvivors()
	var/list/survivorlist = list()
	var/list/sortmob = sortAtom(GLOB.human_mob_list)
	for(var/mob/living/carbon/human/M in sortmob)
		if(!M.client || M.species.name == "Yautja")
			continue
		if(M.faction == FACTION_SURVIVOR)
			survivorlist.Add(M)
	return survivorlist

/proc/sortertmembers()
	var/list/ertmemberlist = list()
	var/list/sortmob = sortAtom(GLOB.human_mob_list)
	for(var/mob/living/carbon/human/M in sortmob)
		if(!M.client)
			continue
		if(M.faction in FACTION_LIST_ERT)
			ertmemberlist.Add(M)
	return ertmemberlist

/proc/sortsynths()
	var/list/synthlist = list()
	var/list/sortmob = sortAtom(GLOB.human_mob_list)
	for(var/mob/living/carbon/human/M in sortmob)
		if(!M.client || !isSynth(M))
			continue
		synthlist.Add(M)
	return synthlist

/proc/key_name(var/whom, var/include_link = null, var/include_name = 1, var/highlight_special_characters = 1)
	var/mob/M
	var/client/C
	var/key

	if(!whom)	return "*null*"
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
			if(C)	. += "</a>"
			else	. += " (DC)"
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

/proc/key_name_admin(var/whom, var/include_name = 1)
	return key_name(whom, 1, include_name)


// returns the turf located at the map edge in the specified direction relative to A
// used for mass driver
/proc/get_edge_target_turf(var/atom/A, var/direction)

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
	for(var/V in turfs)
		var/turf/T = V
		. += T
		. += T.contents
		if(areas)
			. |= T.loc

// returns turf relative to A in given direction at set range
// result is bounded to map size
// note range is non-pythagorean
// used for disposal system
/proc/get_ranged_target_turf(var/atom/A, var/direction, var/range)

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
/proc/get_angle_target_turf(var/atom/A, var/angle, var/range)
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
/proc/get_offset_target_turf(var/atom/A, var/dx, var/dy)
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

//Will return the contents of an atom recursivly to a depth of 'searchDepth'
/atom/proc/GetAllContents(searchDepth = 5, list/toReturn = list())
	for(var/atom/part as anything in contents)
		toReturn += part
		if(part.contents.len && searchDepth)
			part.GetAllContents(searchDepth - 1, toReturn)
	return toReturn

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
/proc/can_see(var/atom/source, var/atom/target, var/length=5) // I couldnt be arsed to do actual raycasting :I This is horribly inaccurate.
	var/turf/current = get_turf(source)
	var/turf/target_turf = get_turf(target)
	var/steps = 0
	var/has_nightvision = FALSE
	if(ismob(source))
		var/mob/M = source
		has_nightvision = M.see_in_dark >= 12
	if(!has_nightvision && target_turf.lighting_lumcount == 0)
		return FALSE

	while(current != target_turf)
		if(steps > length) return FALSE
		if(!current || current.opacity) return FALSE
		for(var/atom/A in current)
			if(A && A.opacity) return FALSE
		current = get_step_towards(current, target_turf)
		steps++

	return TRUE

/proc/is_blocked_turf(var/turf/T)
	if(T.density)
		return TRUE
	for(var/atom/A in T)
		if(A.density)//&&A.anchored
			return TRUE
	return FALSE


var/global/image/busy_indicator_clock
var/global/image/busy_indicator_medical
var/global/image/busy_indicator_build
var/global/image/busy_indicator_friendly
var/global/image/busy_indicator_hostile
var/global/image/emote_indicator_highfive
var/global/image/emote_indicator_fistbump
var/global/image/emote_indicator_headbutt
var/global/image/emote_indicator_tailswipe
var/global/image/emote_indicator_rock_paper_scissors
var/global/image/emote_indicator_rock
var/global/image/emote_indicator_paper
var/global/image/emote_indicator_scissors
var/global/image/action_red_power_up
var/global/image/action_green_power_up
var/global/image/action_blue_power_up
var/global/image/action_purple_power_up

/proc/get_busy_icon(busy_type)
	if(busy_type == BUSY_ICON_GENERIC)
		if(!busy_indicator_clock)
			busy_indicator_clock = image('icons/mob/mob.dmi', null, "busy_generic", "pixel_y" = 22)
			busy_indicator_clock.layer = FLY_LAYER
		return busy_indicator_clock
	else if(busy_type == BUSY_ICON_MEDICAL)
		if(!busy_indicator_medical)
			busy_indicator_medical = image('icons/mob/mob.dmi', null, "busy_medical", "pixel_y" = 0) //This shows directly on top of the mob, no offset!
			busy_indicator_medical.layer = FLY_LAYER
		return busy_indicator_medical
	else if(busy_type == BUSY_ICON_BUILD)
		if(!busy_indicator_build)
			busy_indicator_build = image('icons/mob/mob.dmi', null, "busy_build", "pixel_y" = 22)
			busy_indicator_build.layer = FLY_LAYER
		return busy_indicator_build
	else if(busy_type == BUSY_ICON_FRIENDLY)
		if(!busy_indicator_friendly)
			busy_indicator_friendly = image('icons/mob/mob.dmi', null, "busy_friendly", "pixel_y" = 22)
			busy_indicator_friendly.layer = FLY_LAYER
		return busy_indicator_friendly
	else if(busy_type == BUSY_ICON_HOSTILE)
		if(!busy_indicator_hostile)
			busy_indicator_hostile = image('icons/mob/mob.dmi', null, "busy_hostile", "pixel_y" = 22)
			busy_indicator_hostile.layer = FLY_LAYER
		return busy_indicator_hostile
	else if(busy_type == EMOTE_ICON_HIGHFIVE)
		if(!emote_indicator_highfive)
			emote_indicator_highfive = image('icons/mob/mob.dmi', null, "emote_highfive", "pixel_y" = 22)
			emote_indicator_highfive.layer = FLY_LAYER
		return emote_indicator_highfive
	else if(busy_type == EMOTE_ICON_FISTBUMP)
		if(!emote_indicator_fistbump)
			emote_indicator_fistbump = image('icons/mob/mob.dmi', null, "emote_fistbump", "pixel_y" = 22)
			emote_indicator_fistbump.layer = FLY_LAYER
		return emote_indicator_fistbump
	else if(busy_type == EMOTE_ICON_ROCK_PAPER_SCISSORS)
		if(!emote_indicator_rock_paper_scissors)
			emote_indicator_rock_paper_scissors = image('icons/mob/mob.dmi', null, "emote_rps", "pixel_y" = 22)
			emote_indicator_rock_paper_scissors.layer = FLY_LAYER
		return emote_indicator_rock_paper_scissors
	else if(busy_type == EMOTE_ICON_ROCK)
		if(!emote_indicator_rock)
			emote_indicator_rock = image('icons/mob/mob.dmi', null, "emote_rock", "pixel_y" = 22)
			emote_indicator_rock.layer = FLY_LAYER
		return emote_indicator_rock
	else if(busy_type == EMOTE_ICON_PAPER)
		if(!emote_indicator_paper)
			emote_indicator_paper = image('icons/mob/mob.dmi', null, "emote_paper", "pixel_y" = 22)
			emote_indicator_paper.layer = FLY_LAYER
		return emote_indicator_paper
	else if(busy_type == EMOTE_ICON_SCISSORS)
		if(!emote_indicator_scissors)
			emote_indicator_scissors = image('icons/mob/mob.dmi', null, "emote_scissors", "pixel_y" = 22)
			emote_indicator_scissors.layer = FLY_LAYER
		return emote_indicator_scissors
	else if(busy_type == EMOTE_ICON_HEADBUTT)
		if(!emote_indicator_headbutt)
			emote_indicator_headbutt = image('icons/mob/mob.dmi', null, "emote_headbutt", "pixel_y" = 22)
			emote_indicator_headbutt.layer = FLY_LAYER
		return emote_indicator_headbutt
	else if(busy_type == EMOTE_ICON_TAILSWIPE)
		if(!emote_indicator_tailswipe)
			emote_indicator_tailswipe = image('icons/mob/mob.dmi', null, "emote_tailswipe", "pixel_y" = 22)
			emote_indicator_tailswipe.layer = FLY_LAYER
		return emote_indicator_tailswipe
	else if(busy_type == ACTION_RED_POWER_UP)
		if(!action_red_power_up)
			action_red_power_up = image('icons/effects/effects.dmi', null, "anger", "pixel_x" = 16)
			action_red_power_up.layer = FLY_LAYER
		return action_red_power_up
	else if(busy_type == ACTION_GREEN_POWER_UP)
		if(!action_green_power_up)
			action_green_power_up = image('icons/effects/effects.dmi', null, "vitality", "pixel_x" = 16)
			action_green_power_up.layer = FLY_LAYER
		return action_green_power_up
	else if(busy_type == ACTION_BLUE_POWER_UP)
		if(!action_blue_power_up)
			action_blue_power_up = image('icons/effects/effects.dmi', null, "shock", "pixel_x" = 16)
			action_blue_power_up.layer = FLY_LAYER
		return action_blue_power_up
	else if(busy_type == ACTION_PURPLE_POWER_UP)
		if(!action_purple_power_up)
			action_purple_power_up = image('icons/effects/effects.dmi', null, "pain", "pixel_x" = 16)
			action_purple_power_up.layer = FLY_LAYER
		return action_purple_power_up


/*
 *	do_after handles timed actions
 *	The flags indicate which actions from the user and a target (if there is a target) interrupt a given action.
 *	This proc can handle timed actions with one person alone or one person and a target atom.
 *
 *	show_remaining_time: If TRUE, return the percentage of time remaining in the timed action.
 *	numticks: 	If a value is given, denotes how often the timed action checks for interrupting actions. By default, there are 5 checks every delay/5 deciseconds.
 *				Note: 'delay' should be divisible by numticks in order for the timing to work as intended. numticks should also be a whole number.
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
	var/mob/living/L = user
	if(!istype(L))
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
			busy_icon.appearance_flags = RESET_ALPHA|KEEP_APART
			busy_icon.alpha = 255
			L.overlays += busy_icon

	var/image/target_icon
	if(show_target_icon) //putting a busy overlay on top of the target
		target_icon = get_busy_icon(show_target_icon)
		if(target_icon)
			target_icon.appearance_flags = RESET_ALPHA|KEEP_APART
			target_icon.alpha = 255
			target.overlays += target_icon

	if(user_flags & BEHAVIOR_IMMOBILE)
		L.status_flags |= IMMOBILE_ACTION

	L.action_busy++ // target is not tethered by action, the action is tethered by target though
	L.resisting = FALSE
	L.clicked_something = list()
	if(has_target && target_is_mob)
		T.resisting = FALSE
		T.clicked_something = list()

	var/cur_user_zone_sel = L.zone_selected
	var/cur_target_zone_sel
	var/delayfraction = Ceiling(delay/numticks)
	var/user_orig_loc = L.loc
	var/user_orig_turf = get_turf(L)
	var/target_orig_loc
	var/target_orig_turf
	if(has_target)
		target_orig_loc = target.loc
		target_orig_turf = get_turf(target)
	var/obj/user_holding = L.get_active_hand()
	var/obj/target_holding
	var/cur_user_lying = L.lying
	var/cur_target_lying
	var/expected_total_time = delayfraction*numticks
	var/time_remaining = expected_total_time

	if(has_target && istype(T))
		cur_target_zone_sel = T.zone_selected
		target_holding = T.get_active_hand()
		cur_target_lying = T.lying

	. = TRUE
	for(var/i in 1 to numticks)
		sleep(delayfraction)
		time_remaining -= delayfraction
		if(!istype(L) || has_target && !istype(target)) // Checks if L exists and is not dead and if the target exists and is not destroyed
			. = FALSE
			break
		if(user_flags & INTERRUPT_DIFF_LOC && L.loc != user_orig_loc || \
			has_target && (target_flags & INTERRUPT_DIFF_LOC && target.loc != target_orig_loc)
		)
			. = FALSE
			break
		if(user_flags & INTERRUPT_DIFF_TURF && get_turf(L) != user_orig_turf || \
			has_target && (target_flags & INTERRUPT_DIFF_TURF && get_turf(target) != target_orig_turf)
		)
			. = FALSE
			break
		if(user_flags & INTERRUPT_UNCONSCIOUS && L.stat || \
			target_is_mob && (target_flags & INTERRUPT_UNCONSCIOUS && T.stat)
		)
			. = FALSE
			break
		if(user_flags & INTERRUPT_KNOCKED_DOWN && L.knocked_down || \
			target_is_mob && (target_flags & INTERRUPT_KNOCKED_DOWN && T.knocked_down)
		)
			. = FALSE
			break
		if(user_flags & INTERRUPT_STUNNED && L.stunned || \
			target_is_mob && (target_flags & INTERRUPT_STUNNED && T.stunned)
		)
			. = FALSE
			break
		if(user_flags & INTERRUPT_DAZED && L.dazed)
			. = FALSE
			break
		if(user_flags & INTERRUPT_EMOTE && !L.flags_emote)
			. = FALSE
			break
		if(user_flags & INTERRUPT_NEEDHAND)
			if(user_holding)
				if(!user_holding.loc || L.get_active_hand() != user_holding) //no longer holding the required item
					. = FALSE
					break
			else if(L.get_active_hand()) //something in active hand when we need it to stay empty
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
		if(user_flags & INTERRUPT_RESIST && L.resisting || \
			target_is_mob && (target_flags & INTERRUPT_RESIST && T.resisting)
		)
			. = FALSE
			break
		if(user_flags & INTERRUPT_DIFF_SELECT_ZONE && cur_user_zone_sel != L.zone_selected || \
			target_is_mob && (target_flags & INTERRUPT_DIFF_SELECT_ZONE && cur_target_zone_sel != T.zone_selected)
		)
			. = FALSE
			break
		if((user_flags|target_flags) & INTERRUPT_OUT_OF_RANGE && target && get_dist(L, target) > max_dist)
			. = FALSE
			break
		if(user_flags & INTERRUPT_LCLICK && L.clicked_something["left"] || \
			target_is_mob && (target_flags & INTERRUPT_LCLICK && T.clicked_something["left"])
		)
			. = FALSE
			break
		if(user_flags & INTERRUPT_RCLICK && L.clicked_something["right"] || \
			target_is_mob && (target_flags & INTERRUPT_RCLICK && T.clicked_something["right"])
		)
			. = FALSE
			break
		if(user_flags & INTERRUPT_SHIFTCLICK && L.clicked_something["left"] && L.clicked_something["shift"] || \
			target_is_mob && (target_flags & INTERRUPT_SHIFTCLICK && T.clicked_something["left"] && T.clicked_something["shift"])
		)
			. = FALSE
			break
		if(user_flags & INTERRUPT_ALTCLICK && L.clicked_something["left"] && L.clicked_something["alt"] || \
			target_is_mob && (target_flags & INTERRUPT_ALTCLICK && T.clicked_something["left"] && T.clicked_something["alt"])
		)
			. = FALSE
			break
		if(user_flags & INTERRUPT_CTRLCLICK && L.clicked_something["left"] && L.clicked_something["ctrl"] || \
			target_is_mob && (target_flags & INTERRUPT_CTRLCLICK && T.clicked_something["left"] && T.clicked_something["ctrl"])
		)
			. = FALSE
			break
		if(user_flags & INTERRUPT_MIDDLECLICK && L.clicked_something["middle"] || \
			target_is_mob && (target_flags & INTERRUPT_MIDDLECLICK && T.clicked_something["middle"])
		)
			. = FALSE
			break
		if(user_flags & INTERRUPT_CHANGED_LYING && L.lying != cur_user_lying || \
			target_is_mob && (target_flags & INTERRUPT_CHANGED_LYING && T.lying != cur_target_lying)
		)
			. = FALSE
			break

	if(L && busy_icon)
		L.overlays -= busy_icon
	if(target && target_icon)
		target.overlays -= target_icon

	L.action_busy--
	L.resisting = FALSE
	if(target_is_mob)
		T.resisting = FALSE
	L.status_flags &= ~IMMOBILE_ACTION

	if (show_remaining_time)
		return (. ? 0 : time_remaining/expected_total_time) // If action was not interrupted, return 0 for no time left, otherwise return ratio of time remaining

//Takes: Anything that could possibly have variables and a varname to check.
//Returns: 1 if found, 0 if not.
/proc/hasvar(var/datum/A, var/varname)
	if(A.vars.Find(lowertext(varname))) return 1
	else return 0

//Returns: all the non-lighting areas in the world, sorted.
/proc/return_sorted_areas()
	var/list/area/AL = list()
	for(var/area/A in GLOB.sorted_areas)
		if(!A.lighting_subarea)
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
	var/list/area/LA
	if(!length(A.related))
		LA = list(A)
	else LA = A.related
	for(var/area/Ai in LA)
		for(var/turf/T in Ai)
			turfs += T

	return turfs

/datum/coords //Simple datum for storing coordinates.
	var/x_pos = null
	var/y_pos = null
	var/z_pos = null

/datum/coords/New(var/turf/location)
	. = ..()
	if(location)
		x_pos = location.x
		y_pos = location.y
		z_pos = location.z

/datum/coords/proc/get_turf_from_coord()
	if(!x_pos || !y_pos || !z_pos)
		return

	return locate(x_pos, y_pos, z_pos)

/area/proc/move_contents_to(var/area/A, var/turftoleave=null, var/direction = null)
	//Takes: Area. Optional: turf type to leave behind.
	//Returns: Nothing.
	//Notes: Attempts to move the contents of one area to another area.
	//       Movement based on lower left corner. Tiles that do not fit
	//		 into the new area will not be moved.

	if(!A || !src) return 0

	var/list/turfs_src = get_area_turfs(src.type)
	var/list/turfs_trg = get_area_turfs(A.type)

	var/src_min_x = 0
	var/src_min_y = 0
	for (var/turf/T in turfs_src)
		if(T.x < src_min_x || !src_min_x) src_min_x	= T.x
		if(T.y < src_min_y || !src_min_y) src_min_y	= T.y

	var/trg_min_x = 0
	var/trg_min_y = 0
	for (var/turf/T in turfs_trg)
		if(T.x < trg_min_x || !trg_min_x) trg_min_x	= T.x
		if(T.y < trg_min_y || !trg_min_y) trg_min_y	= T.y

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
						corner.density = 1
						corner.anchored = 1
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

//					var/area/AR = X.loc

//					if(AR.lighting_use_dynamic)							//TODO: rewrite this code so it's not messed by lighting ~Carn
//						X.opacity = !X.opacity
//						X.SetOpacity(!X.opacity)

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
/proc/get_perpen_dir(var/dir)
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

proc/get_true_location(var/atom/loc)
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
		if(NORTH) 		return list(SOUTH,     SOUTHEAST, SOUTHWEST)
		if(NORTHEAST) 	return list(SOUTHWEST, SOUTH,     WEST)
		if(EAST) 		return list(WEST,      SOUTHWEST, NORTHWEST)
		if(SOUTHEAST) 	return list(NORTHWEST, NORTH,     WEST)
		if(SOUTH) 		return list(NORTH,     NORTHEAST, NORTHWEST)
		if(SOUTHWEST) 	return list(NORTHEAST, NORTH,     EAST)
		if(WEST) 		return list(EAST,      NORTHEAST, SOUTHEAST)
		if(NORTHWEST) 	return list(SOUTHEAST, SOUTH,     EAST)

/*
Checks if that loc and dir has a item on the wall
*/
var/list/WALLITEMS = list(
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
	/obj/structure/machinery/computer/security/telescreen,
	/obj/item/storage/secure/safe,
	/obj/structure/machinery/brig_cell,
	/obj/structure/machinery/flasher,
	/obj/structure/machinery/keycard_auth,
	/obj/structure/mirror,
	/obj/structure/closet/fireaxecabinet,
	/obj/structure/machinery/computer/security/telescreen/entertainment,
	)
/proc/gotwallitem(loc, dir)
	for(var/obj/O in loc)
		for(var/item in WALLITEMS)
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
		for(var/item in WALLITEMS)
			if(istype(O, item))
				if(O.pixel_x == 0 && O.pixel_y == 0)
					return 1
	return 0

/proc/format_text(text)
	return replacetext(replacetext(text,"\proper ",""),"\improper ","")

/proc/getline(atom/M, atom/N, include_from_atom = TRUE)//Ultra-Fast Bresenham Line-Drawing Algorithm
	var/px=M.x		//starting x
	var/py=M.y
	var/line[] = list(locate(px,py,M.z))
	var/dx=N.x-px	//x distance
	var/dy=N.y-py
	var/dxabs=abs(dx)//Absolute value of x distance
	var/dyabs=abs(dy)
	var/sdx=sign(dx)	//Sign of x distance (+ or -)
	var/sdy=sign(dy)
	var/x=dxabs>>1	//Counters for steps taken, setting to distance/2
	var/y=dyabs>>1	//Bit-shifting makes me l33t.  It also makes getline() unnessecarrily fast.
	var/j			//Generic integer for counting
	if(dxabs>=dyabs)	//x distance is greater than y
		for(j=0;j<dxabs;j++)//It'll take dxabs steps to get there
			y+=dyabs
			if(y>=dxabs)	//Every dyabs steps, step once in y direction
				y-=dxabs
				py+=sdy
			px+=sdx		//Step on in x direction
			if(j > 0 || include_from_atom)
				line+=locate(px,py,M.z)//Add the turf to the list
	else
		for(j=0;j<dyabs;j++)
			x+=dxabs
			if(x>=dyabs)
				x-=dyabs
				px+=sdx
			py+=sdy
			if(j > 0 || include_from_atom)
				line+=locate(px,py,M.z)
	return line

//Bresenham's algorithm. This one deals efficiently with all 8 octants.
//Just don't ask me how it works.
/proc/getline2(atom/from_atom, atom/to_atom, include_from_atom = TRUE)
	if(!from_atom || !to_atom) return 0
	var/list/turf/turfs = list()

	var/cur_x = from_atom.x
	var/cur_y = from_atom.y

	var/w = to_atom.x - from_atom.x
	var/h = to_atom.y - from_atom.y
	var/dx1 = 0
	var/dx2 = 0
	var/dy1 = 0
	var/dy2 = 0
	if(w < 0)
		dx1 = -1
		dx2 = -1
	else if(w > 0)
		dx1 = 1
		dx2 = 1
	if(h < 0) dy1 = -1
	else if(h > 0) dy1 = 1
	var/longest = abs(w)
	var/shortest = abs(h)
	if(!(longest > shortest))
		longest = abs(h)
		shortest = abs(w)
		if(h < 0) dy2 = -1
		else if (h > 0) dy2 = 1
		dx2 = 0

	var/numerator = longest >> 1
	var/i
	for(i = 0; i <= longest; i++)
		if(i > 0 || include_from_atom)
			turfs += locate(cur_x,cur_y,from_atom.z)
		numerator += shortest
		if(!(numerator < longest))
			numerator -= longest
			cur_x += dx1
			cur_y += dy1
		else
			cur_x += dx2
			cur_y += dy2


	return turfs


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
		. += CEILING(i*DELTA_CALC, 1)
		sleep(i*world.tick_lag*DELTA_CALC)
		i *= 2
	while (TICK_USAGE > min(TICK_LIMIT_TO_RUN, Master.current_ticklimit))

#undef DELTA_CALC

/proc/get_random_turf_in_range(var/atom/origin, var/outer_range, var/inner_range)
	origin = get_turf(origin)
	if(!origin)
		return
	var/list/turfs = list()
	for(var/turf/T in orange(origin, outer_range))
		if(!inner_range || get_dist(origin, T) >= inner_range)
			turfs += T
	if(turfs.len)
		return pick(turfs)

/proc/input_marked_datum(var/list/marked_datums)
	if(!marked_datums.len)
		return null

	var/list/options = list()
	for(var/datum/D in marked_datums)
		options += "Marked datum ([D] - \ref[D])"
	var/choice = tgui_input_list(usr, "Select marked datum", "Marked datums", options)

	if(!choice)
		return null

	for(var/datum/D in marked_datums)
		if(findtext(choice, "\ref[D]"))
			return D

	return null

// Returns true if arming a given explosive might be considered grief
// Explosives are considered "griefy" if they are primed when all the following are true:
// * The explosive is on the Almayer/dropship transit z levels
// * The alert level is green/blue (alternatively, not red+)
// * The dropship crash hasn't happened yet
// * An admin hasn't disabled explosive antigrief
// Certain areas may be exempt from this check. Look up explosive_antigrief_exempt_areas
/proc/explosive_antigrief_check(var/obj/item/explosive/explosive, var/mob/user)
	var/turf/Turf = get_turf(explosive)
	if(!(Turf.loc.type in GLOB.explosive_antigrief_exempt_areas))
		var/crash_occured = (SSticker?.mode?.is_in_endgame)
		if((Turf.z in SSmapping.levels_by_any_trait(list(ZTRAIT_MARINE_MAIN_SHIP, ZTRAIT_LOWORBIT))) && (security_level < SEC_LEVEL_RED) && !crash_occured)
			switch(CONFIG_GET(number/explosive_antigrief))
				if(ANTIGRIEF_DISABLED)
					return FALSE
				if(ANTIGRIEF_NEW_PLAYERS) //if they have less than 10 hours, dont let them prime nades
					if(user.client && user.client.get_total_human_playtime() < JOB_PLAYTIME_TIER_1)
						return TRUE
				else //ANTIGRIEF_ENABLED
					return TRUE
	return FALSE

// Returns only the perimeter of the block given by the min and max turfs
/proc/blockhollow(var/turf/min, var/turf/max)
	var/list/perimeter_turfs = list()

	// Upper/lower perimeters
	for(var/x_coord = min.x to max.x)
		perimeter_turfs += locate(x_coord, min.y, min.z)
		perimeter_turfs += locate(x_coord, max.y, min.z)

	// Left/right perimeters
	for(var/y_coord = min.y + 1 to max.y - 1)
		perimeter_turfs += locate(min.x, y_coord, min.z)
		perimeter_turfs += locate(max.x, y_coord, min.z)

	return perimeter_turfs

/proc/flick_overlay(var/atom/target, overlay, time)
	target.overlays += overlay
	addtimer(CALLBACK(GLOBAL_PROC, /proc/remove_timed_overlay, target, overlay), time)

/proc/remove_timed_overlay(var/atom/target, overlay)
	target.overlays -= overlay

/*
	Returns a list of random-looking, zero-sum variances.

	Imagine a straight line divided up into n segments,
	then divide each segment into 2 subsegments again, so each original segment gets "its own point" that divides the subsegments
	Then displace the first segment's dividing point by e.g. 5.
	Then displace the second segment's dividing point by -5.
	Then displace the third segment's dividing point by 5, and so on, alternating between a displacement of 5 and -5
	(If there's an odd number of segments just don't displace the last point at all)

	At the end, you'll have a zig-zaggy line. You then go through each segment end and
	take away/add some random amount of displacement from its point. If you keep track of how much
	net displacement has been added/removed, you can distribute it among other points
	and end up with net 0 displacement (i.e. 0 total variance)

	Basically, this is what happens: https://i.imgur.com/AuY7HHd.png
*/
/proc/get_random_zero_sum_variances(var/amount, var/max_variance)
	// Displace each "point" to max variance
	var/list/variances[amount]
	for(var/i in 1 to variances.len)
		if(i == variances.len && (variances.len % 2))
			variances[i] = 0
		else
			variances[i] = (i % 2 ? 1 : -1) * max_variance

	// Jiggle each variance a random amount towards the "center line"/0 variance
	var/net_displacement = 0
	for(var/i in 1 to variances.len)
		var/to_redistribute = (i % 2 ? -1 : 1) * rand(0, max_variance/2)

		net_displacement += to_redistribute
		variances[i] += to_redistribute

	// Lucky! Everything jiggled towards 0 in a way that left 0 net displacement
	if(!net_displacement)
		return variances

	// Redistribute the net displacement evenly on the side of the center line that needs it
	// Only half the points are gonna be affected.
	var/to_redistribute = abs(Ceiling(net_displacement / (variances.len/2)))
	for(var/i in 1 to variances.len)
		if(!net_displacement)
			break

		// Positive net displacement, only distribute to points that were given negative variance to begin with
		if(net_displacement > 0 && !(i % 2))
			variances[i] -= min(abs(net_displacement), to_redistribute)
			net_displacement -= to_redistribute
		// Negative net displacement, only distribute to points that were given positive variance to begin with
		else if(net_displacement < 0 && i % 2)
			variances[i] += min(abs(net_displacement), to_redistribute)
			net_displacement += to_redistribute

	return variances

/proc/check_bitflag(var/flag, var/bit)
	if(flag & bit)
		return TRUE
	return FALSE

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

//used to check if a mob can examine an object
/atom/proc/can_examine(var/mob/user)
	if(!user.client)
		return FALSE
	if(isRemoteControlling(user))
		return TRUE
	// If the user is not a xeno (with active ability) with the shift click pref on, we examine. God forgive me for snowflake
	if(user.client?.prefs && !(user.client?.prefs?.toggle_prefs & TOGGLE_MIDDLE_MOUSE_CLICK))
		if(isXeno(user))
			var/mob/living/carbon/Xenomorph/X = user
			if(X.selected_ability)
				return FALSE
		else if(ishuman(user))
			var/mob/living/carbon/human/H = user
			if(H.selected_ability)
				return FALSE
	if(user.client.eye == user)
		user.face_atom(src)
	return TRUE

//datum may be null, but it does need to be a typed var
#define NAMEOF(datum, X) (#X || ##datum.##X)

#define VARSET_CALLBACK(datum, var, var_value) CALLBACK(GLOBAL_PROC, /proc/___callbackvarset, ##datum, NAMEOF(##datum, ##var), ##var_value)

/proc/___callbackvarset(list_or_datum, var_name, var_value)
	if(length(list_or_datum))
		list_or_datum[var_name] = var_value
		return
	var/datum/D = list_or_datum
	D.vars[var_name] = var_value

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

/proc/IsValidSrc(datum/D)
	if(istype(D))
		return !QDELETED(D)
	return FALSE

//Repopulates sortedAreas list
/proc/repopulate_sorted_areas()
	GLOB.sorted_areas = list()

	for(var/area/A in world)
		GLOB.sorted_areas.Add(A)

	sortTim(GLOB.sorted_areas, /proc/cmp_name_asc)

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

#define TURF_FROM_COORDS_LIST(List) (locate(List[1], List[2], List[3]))

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

/proc/convert_to_json_text(var/json_file_string)
	var/json_file = file(json_file_string)
	json_file = file2text(json_file)
	json_file = json_decode(json_file)
	return json_file

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
