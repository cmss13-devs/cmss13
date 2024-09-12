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

/proc/hear(range, atom/source)
	if(!source)
		return FALSE
	var/lum = source.luminosity
	source.luminosity = 6

	var/list/heard = view(range, source)
	source.luminosity = lum

	return heard

// more efficient get_dist, doesn't sqrt test

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

	for(var/turf/T as anything in RANGE_TURFS(radius, centerturf))
		var/dx = T.x - centerturf.x
		var/dy = T.y - centerturf.y
		if(dx*dx + dy*dy <= rsq)
			turfs += T
	return turfs

// Will recursively loop through an atom's contents and check for mobs, then it will loop through every atom in that atom's contents.
// It will keep doing this until it checks every content possible. This will fix any problems with mobs, that are inside objects,
// being unable to hear people due to being in a box within a bag.

/proc/recursive_mob_check(atom/O, list/L = list(), recursion_limit = 3, client_check = 1, sight_check = 1, include_radio = 1)

	//debug_mob += length(O.contents)
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

/// Will attempt to find what's holding this item if it's being contained by something, ie if it's in a satchel held by a human, this'll return the human
/proc/recursive_holder_check(obj/item/held_item, recursion_limit = 3)
	if(recursion_limit <= 0)
		return held_item
	if(!held_item.loc || isturf(held_item.loc))
		return held_item
	recursion_limit--
	return recursive_holder_check(held_item.loc, recursion_limit)

// The old system would loop through lists for a total of 5000 per function call, in an empty server.
// This new system will loop at around 1000 in an empty server.
// Returns a list of mobs in range of R from source. Used in radio and say code.
/proc/get_mobs_in_view(R, atom/source)
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

///only gets FUNCTIONING radios
/proc/get_radios_in_view(R, atom/source)
	var/turf/T = get_turf(source)
	var/list/hear = list()

	if(!T)
		return hear

	var/list/range = hear(R, T)

	for(var/atom/A in range)
		if(istype(A, /obj/item/device/radio))
			var/obj/item/device/radio/radio = A
			if(radio.on && radio.listening)
				hear += A
	return hear

/proc/get_mobs_in_radio_ranges(list/obj/item/device/radio/radios)

	set background = 1

	. = list()
	// Returns a list of mobs who can hear any of the radios given in @radios
	var/list/speaker_coverage = list()
	for(var/obj/item/device/radio/R in radios)
		if(R)
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
					. |= M // Since we're already looping through mobs, why bother using |= ? This only slows things down.
	return .

/proc/inLineOfSight(X1,Y1,X2,Y2,Z=1,PX1=16.5,PY1=16.5,PX2=16.5,PY2=16.5)
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
			if(floor(m*X1+b-Y1))
				Y1+=signY //Line exits tile vertically
			else
				X1+=signX //Line exits tile horizontally
			T=locate(X1,Y1,Z)
			if(T.opacity)
				return 0
	return 1
#undef SIGN

/proc/isInSight(atom/A, atom/B)
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

/**
 * Get a list of observers that can be alien candidates.
 *
 * Arguments:
 * * hive - The hive we're filling a slot for to check if the player is banished
 * * sorted - Whether to sort by larva_queue_time (default TRUE) or leave unsorted
 */
/proc/get_alien_candidates(datum/hive_status/hive = null, sorted = TRUE, abomination = FALSE)
	var/list/candidates = list()

	for(var/mob/dead/observer/cur_obs as anything in GLOB.observer_list)
		// Preference check
		if(!cur_obs.client || !cur_obs.client.prefs || !(cur_obs.client.prefs.be_special & BE_ALIEN_AFTER_DEATH))
			continue

		// Jobban check
		if(jobban_isbanned(cur_obs, JOB_XENOMORPH))
			continue

		//players that can still be revived are skipped
		if(cur_obs.mind && cur_obs.mind.original && ishuman(cur_obs.mind.original))
			var/mob/living/carbon/human/cur_human = cur_obs.mind.original
			if(cur_human.check_tod() && cur_human.is_revivable())
				continue

		// copied from join as xeno
		var/deathtime = world.time - cur_obs.timeofdeath
		if(deathtime < XENO_JOIN_DEAD_TIME && ( !cur_obs.client.admin_holder || !(cur_obs.client.admin_holder.rights & R_ADMIN)) && !cur_obs.bypass_time_of_death_checks)
			continue

		// AFK players cannot be drafted
		if(cur_obs.client.inactivity > XENO_JOIN_AFK_TIME_LIMIT)
			continue

		// Mods with larva protection cannot be drafted
		if(check_client_rights(cur_obs.client, R_MOD, FALSE) && cur_obs.admin_larva_protection)
			continue

		if(hive)
			var/banished = FALSE
			for(var/mob_name in hive.banished_ckeys)
				if(hive.banished_ckeys[mob_name] == cur_obs.ckey)
					banished = TRUE
					break
			if(banished)
				continue

		if(abomination)
			if(!(/datum/tutorial/xenomorph/abomination::tutorial_id in cur_obs.client.prefs.completed_tutorials))
				to_chat(cur_obs, SPAN_BOLDNOTICE("You were passed over for playing as an Abomination because you have not completed its tutorial."))
				continue

		candidates += cur_obs

	// Optionally sort by larva_queue_time
	if(sorted && length(candidates))
		candidates = sort_list(candidates, GLOBAL_PROC_REF(cmp_obs_larvaqueuetime_asc))

	GLOB.xeno_queue_candidate_count = length(candidates)

	return candidates

/**
 * Messages observers that are currently candidates an update on the queue.
 *
 * Arguments:
 * * candidates - The list of observers from get_alien_candidates()
 * * dequeued - How many candidates to skip messaging because they were dequeued
 * * cache_only - Whether to not actually send a to_chat message and instead only update larva_queue_cached_message
 */
/proc/message_alien_candidates(list/candidates, dequeued, cache_only = FALSE)
	for(var/i in (1 + dequeued) to length(candidates))
		var/mob/dead/observer/cur_obs = candidates[i]

		// Generate the messages
		var/cached_message = "You are currently [i-dequeued]\th in the larva queue."
		cur_obs.larva_queue_cached_message = cached_message
		if(!cache_only)
			var/chat_message = dequeued ? replacetext(cached_message, "currently", "now") : cached_message
			to_chat(candidates[i], SPAN_XENONOTICE(chat_message))

/proc/convert_k2c(temp)
	return ((temp - T0C))

/proc/convert_c2k(temp)
	return ((temp + T0C))

/proc/getWireFlag(wire)
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

// makes peoples byond icon flash on the taskbar
/proc/window_flash(client/C)
	if(ismob(C))
		var/mob/M = C
		if(M.client)
			C = M.client
	if(!C)
		return
	winset(C, "mainwindow", "flash=5")

/proc/flash_clients()
	for(var/client/C as anything in GLOB.clients)
		if(C.prefs?.toggles_flashing & FLASH_ROUNDSTART)
			window_flash(C)

/// Removes an image from a client's `.images`. Useful as a callback.
/proc/remove_image_from_client(image/image_to_remove, client/remove_from)
	remove_from?.images -= image_to_remove

///Like remove_image_from_client, but will remove the image from a list of clients
/proc/remove_images_from_clients(image/image_to_remove, list/show_to)
	for(var/client/remove_from in show_to)
		remove_from.images -= image_to_remove

///Add an image to a list of clients and calls a proc to remove it after a duration
/proc/flick_overlay_to_clients(image/image_to_show, list/show_to, duration)
	for(var/client/add_to in show_to)
		add_to.images += image_to_show
	addtimer(CALLBACK(GLOBAL_PROC, GLOBAL_PROC_REF(remove_images_from_clients), image_to_show, show_to), duration, TIMER_CLIENT_TIME)

/// Get active players who are playing in the round
/proc/get_active_player_count(alive_check = FALSE, afk_check = FALSE, faction_check = FALSE, faction = FACTION_NEUTRAL)
	var/active_players = 0
	for(var/mob/current_mob in GLOB.player_list)
		if(!(current_mob && current_mob.client))
			continue
		if(alive_check && current_mob.stat)
			continue
		else if(afk_check && current_mob.client.is_afk())
			continue
		else if(faction_check)
			if(!isliving(current_mob))
				continue
			var/mob/living/current_living = current_mob
			if(faction != current_living.faction)
				continue
		else if(isnewplayer(current_mob))
			continue
		else if(isobserver(current_mob))
			var/mob/dead/observer/current_observer = current_mob
			if(current_observer.started_as_observer)
				continue
		active_players++
	return active_players
