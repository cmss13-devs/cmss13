/proc/get_area_name(atom/X, format_text = FALSE)
	var/area/A = isarea(X) ? X : get_area(X)
	if(!A)
		return null
	return format_text ? format_text(A.name) : A.name

/proc/in_range(source, user)
	if(get_dist(source, user) <= 1)
		return 1

	return 0 //not in range and not telekinetic

// Like view but bypasses luminosity check

/proc/hear(var/range, var/atom/source)
	if(!source)
		return FALSE
	var/lum = source.luminosity
	source.luminosity = 6

	var/list/heard = view(range, source)
	source.luminosity = lum

	return heard

// more efficient get_dist, doesn't sqrt

/proc/get_dist_sqrd(atom/Loc1 as turf|mob|obj, atom/Loc2 as turf|mob|obj)
	var/dx = abs(Loc1.x - Loc2.x)
	var/dy = abs(Loc1.y - Loc2.y)
	return (dx * dx) + (dy * dy)


/proc/get_dist_euclidian(atom/Loc1 as turf|mob|obj,atom/Loc2 as turf|mob|obj)
	var/dx = Loc1.x - Loc2.x
	var/dy = Loc1.y - Loc2.y

	var/dist = sqrt(dx**2 + dy**2)

	return dist

/proc/circlerangeturfs(center=usr,radius=3)

	var/turf/centerturf = get_turf(center)
	var/list/turfs = new/list()
	var/rsq = radius * (radius+0.5)

	for(var/turf/T in range(radius, centerturf))
		var/dx = T.x - centerturf.x
		var/dy = T.y - centerturf.y
		if(dx*dx + dy*dy <= rsq)
			turfs += T
	return turfs


//var/debug_mob = 0

// Will recursively loop through an atom's contents and check for mobs, then it will loop through every atom in that atom's contents.
// It will keep doing this until it checks every content possible. This will fix any problems with mobs, that are inside objects,
// being unable to hear people due to being in a box within a bag.

/proc/recursive_mob_check(var/atom/O,  var/list/L = list(), var/recursion_limit = 3, var/client_check = 1, var/sight_check = 1, var/include_radio = 1)

	//debug_mob += O.contents.len
	if(!recursion_limit)
		return L
	for(var/atom/A in O.contents)

		if(ismob(A))
			var/mob/M = A
			if(client_check && !M.client)
				L |= recursive_mob_check(A, L, recursion_limit - 1, client_check, sight_check, include_radio)
				continue
			if(sight_check && !isInSight(A, O))
				continue
			L |= M
			//world.log << "[recursion_limit] = [M] - [get_turf(M)] - ([M.x], [M.y], [M.z])"

		else if(include_radio && istype(A, /obj/item/device/radio))
			if(sight_check && !isInSight(A, O))
				continue
			L |= A

		if(isobj(A) || ismob(A))
			L |= recursive_mob_check(A, L, recursion_limit - 1, client_check, sight_check, include_radio)
	return L

// The old system would loop through lists for a total of 5000 per function call, in an empty server.
// This new system will loop at around 1000 in an empty server.
// Returns a list of mobs in range of R from source. Used in radio and say code.
/proc/get_mobs_in_view(var/R, var/atom/source)
	var/turf/T = get_turf(source)
	var/list/hear = list()

	if(!T)
		return hear

	var/list/range = hear(R, T)

	for(var/atom/A in range)
		if(ismob(A))
			var/mob/M = A
			if(M.client)
				hear += M
		else if(istype(A, /obj/item/device/radio))
			hear += A
		else if (istype(A, /obj/vehicle/multitile))
			var/obj/vehicle/multitile/vehicle = A
			for(var/mob/M in vehicle.get_passengers())
				hear += M
		else if (istype(A, /obj/structure/closet))
			var/obj/structure/closet/C = A
			if (!C.store_mobs)
				continue
			for (var/mob/M in C)
				if (M.client)
					hear += M
		else if (istype(A, /obj/structure/morgue))
			for (var/mob/M in A)
				if (M.client)
					hear += M
	return hear


/proc/get_mobs_in_radio_ranges(var/list/obj/item/device/radio/radios)

	set background = 1

	. = list()
	// Returns a list of mobs who can hear any of the radios given in @radios
	var/list/speaker_coverage = list()
	for(var/obj/item/device/radio/R in radios)
		if(R)
			//Cyborg checks. Receiving message uses a bit of cyborg's charge.
			var/obj/item/device/radio/borg/BR = R
			if(istype(BR) && BR.myborg)
				var/mob/living/silicon/robot/borg = BR.myborg
				var/datum/robot_component/CO = borg.get_component("radio")
				if(!CO)
					continue //No radio component (Shouldn't happen)
				if(!borg.is_component_functioning("radio") || !borg.cell_use_power(CO.active_usage))
					continue //No power.

			var/turf/speaker = get_turf(R)
			if(speaker)
				for(var/turf/T in hear(R.canhear_range,speaker))
					speaker_coverage[T] = T


	// Try to find all the players who can hear the message
	for(var/i in GLOB.player_list)
		var/mob/M = i
		if(M)
			var/turf/ear = get_turf(M)
			if(ear)
				// Ghostship is magic: Ghosts can hear radio chatter from anywhere
				if(speaker_coverage[ear] || (istype(M, /mob/dead/observer) && (M.client) && (M.client.prefs) && (M.client.prefs.toggles_chat & CHAT_GHOSTRADIO)))
					. |= M		// Since we're already looping through mobs, why bother using |= ? This only slows things down.
	return .

#define SIGN(X) ((X<0)?-1:1)

proc
	inLineOfSight(X1,Y1,X2,Y2,Z=1,PX1=16.5,PY1=16.5,PX2=16.5,PY2=16.5)
		var/turf/T
		if(X1==X2)
			if(Y1==Y2)
				return 1 //Light cannot be blocked on same tile
			else
				var/s = SIGN(Y2-Y1)
				Y1+=s
				while(Y1!=Y2)
					T=locate(X1,Y1,Z)
					if(T.opacity)
						return 0
					Y1+=s
		else
			var/m=(32*(Y2-Y1)+(PY2-PY1))/(32*(X2-X1)+(PX2-PX1))
			var/b=(Y1+PY1/32-0.015625)-m*(X1+PX1/32-0.015625) //In tiles
			var/signX = SIGN(X2-X1)
			var/signY = SIGN(Y2-Y1)
			if(X1<X2)
				b+=m
			while(X1!=X2 || Y1!=Y2)
				if(round(m*X1+b-Y1))
					Y1+=signY //Line exits tile vertically
				else
					X1+=signX //Line exits tile horizontally
				T=locate(X1,Y1,Z)
				if(T.opacity)
					return 0
		return 1
#undef SIGN

proc/isInSight(var/atom/A, var/atom/B)
	var/turf/Aturf = get_turf(A)
	var/turf/Bturf = get_turf(B)

	if(!Aturf || !Bturf)
		return 0

	if(inLineOfSight(Aturf.x,Aturf.y, Bturf.x,Bturf.y,Aturf.z))
		return 1

	else
		return 0

/proc/get_cardinal_step_away(atom/start, atom/finish) //returns the position of a step from start away from finish, in one of the cardinal directions
	//returns only NORTH, SOUTH, EAST, or WEST
	var/dx = finish.x - start.x
	var/dy = finish.y - start.y
	if(abs(dy) > abs (dx)) //slope is above 1:1 (move horizontally in a tie)
		if(dy > 0)
			return get_step(start, SOUTH)
		else
			return get_step(start, NORTH)
	else
		if(dx > 0)
			return get_step(start, WEST)
		else
			return get_step(start, EAST)

// Same as above but for alien candidates.
/proc/get_alien_candidates()
	var/list/candidates = list()

	for(var/i in GLOB.observer_list)
		var/mob/dead/observer/O = i
		// Jobban check
		if(!O.client || !O.client.prefs || !(O.client.prefs.be_special & BE_ALIEN_AFTER_DEATH) || jobban_isbanned(O, "Alien"))
			continue

		//players that can still be revived are skipped
		if(O.mind && O.mind.original && ishuman(O.mind.original))
			var/mob/living/carbon/human/H = O.mind.original
			if (H.check_tod() && H.is_revivable())
				continue

		// copied from join as xeno
		var/deathtime = world.time - O.timeofdeath
		if(deathtime < 3000 && ( !O.client.admin_holder || !(O.client.admin_holder.rights & R_ADMIN)) )
			continue

		// Admins and AFK players cannot be drafted
		if(O.client.inactivity / 600 > ALIEN_SELECT_AFK_BUFFER + 5 || (O.client.admin_holder && (O.client.admin_holder.rights & R_MOD)) && O.adminlarva == 0)
			continue

		candidates += O

	return candidates

/proc/convert_k2c(var/temp)
	return ((temp - T0C))

/proc/convert_c2k(var/temp)
	return ((temp + T0C))

/proc/getWireFlag(var/wire)
	return 2**(wire-1)

/**
 * Get a bounding box of a list of atoms.
 *
 * Arguments:
 * - atoms - List of atoms. Can accept output of view() and range() procs.
 *
 * Returns: list(x1, y1, x2, y2)
 */
/proc/get_bbox_of_atoms(list/atoms)
	var/list/list_x = list()
	var/list/list_y = list()
	for(var/_a in atoms)
		var/atom/a = _a
		list_x += a.x
		list_y += a.y
	return list(
		min(list_x),
		min(list_y),
		max(list_x),
		max(list_y))
