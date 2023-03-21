/proc/get_area_name(atom/X, format_text = FALSE)
	var/area/current_area = isarea(X) ? X : get_area(X)
	if(!current_area)
		return null
	return format_text ? format_text(current_area.name) : current_area.name

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

	for(var/turf/current_turf in range(radius, centerturf))
		var/dx = current_turf.x - centerturf.x
		var/dy = current_turf.y - centerturf.y
		if(dx*dx + dy*dy <= rsq)
			turfs += current_turf
	return turfs


//var/debug_mob = 0

// Will recursively loop through an atom's contents and check for mobs, then it will loop through every atom in that atom's contents.
// It will keep doing this until it checks every content possible. This will fix any problems with mobs, that are inside objects,
// being unable to hear people due to being in a box within a bag.

/proc/recursive_mob_check(atom/container, list/L = list(), recursion_limit = 3, client_check = 1, sight_check = 1, include_radio = 1)

	//debug_mob += container.contents.len
	if(!recursion_limit)
		return L
	for(var/atom/current_atom in container.contents)

		if(ismob(current_atom))
			var/mob/current_mob = current_atom
			if(client_check && !current_mob.client)
				L |= recursive_mob_check(current_atom, L, recursion_limit - 1, client_check, sight_check, include_radio)
				continue
			if(sight_check && !isInSight(current_atom, container))
				continue
			L |= current_mob
			//world.log << "[recursion_limit] = [current_mob] - [get_turf(current_mob)] - ([current_mob.x], [current_mob.y], [current_mob.z])"

		else if(include_radio && istype(current_atom, /obj/item/device/radio))
			if(sight_check && !isInSight(current_atom, container))
				continue
			L |= current_atom

		if(isobj(current_atom) || ismob(current_atom))
			L |= recursive_mob_check(current_atom, L, recursion_limit - 1, client_check, sight_check, include_radio)
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
// Returns a list of mobs in range of the current radio from source. Used in radio and say code.
/proc/get_mobs_in_view(current_radio, atom/source)
	var/turf/current_turf = get_turf(source)
	var/list/hear = list()

	if(!current_turf)
		return hear

	var/list/range = hear(current_radio, current_turf)

	for(var/atom/current_atom in range)
		if(ismob(current_atom))
			var/mob/current_mob = current_atom
			if(current_mob.client)
				hear += current_mob
		else if (istype(current_atom, /obj/vehicle/multitile))
			var/obj/vehicle/multitile/vehicle = current_atom
			for(var/mob/current_mob in vehicle.get_passengers())
				hear += current_mob
		else if (istype(current_atom, /obj/structure/closet))
			var/obj/structure/closet/current_closet = current_atom
			if (!current_closet.store_mobs)
				continue
			for (var/mob/current_mob in current_closet)
				if (current_mob.client)
					hear += current_mob
		else if (istype(current_atom, /obj/structure/morgue))
			for (var/mob/current_mob in current_atom)
				if (current_mob.client)
					hear += current_mob
	return hear

///only gets FUNCTIONING radios
/proc/get_radios_in_view(current_radio, atom/source)
	var/turf/current_turf = get_turf(source)
	var/list/hear = list()

	if(!current_turf)
		return hear

	var/list/range = hear(current_radio, current_turf)

	for(var/atom/current_atom in range)
		if(istype(current_atom, /obj/item/device/radio))
			var/obj/item/device/radio/radio = current_atom
			if(radio.on && radio.listening)
				hear += current_atom
	return hear

/proc/get_mobs_in_radio_ranges(list/obj/item/device/radio/radios)

	set background = 1

	. = list()
	// Returns a list of mobs who can hear any of the radios given in @radios
	var/list/speaker_coverage = list()
	for(var/obj/item/device/radio/current_radio in radios)
		if(current_radio)
			//Cyborg checks. Receiving message uses a bit of cyborg's charge.
			var/obj/item/device/radio/borg/BR = current_radio
			if(istype(BR) && BR.myborg)
				var/mob/living/silicon/robot/borg = BR.myborg
				var/datum/robot_component/CO = borg.get_component("radio")
				if(!CO)
					continue //No radio component (Shouldn't happen)
				if(!borg.is_component_functioning("radio") || !borg.cell_use_power(CO.active_usage))
					continue //No power.

			var/turf/speaker = get_turf(current_radio)
			if(speaker)
				for(var/turf/current_turf in hear(current_radio.canhear_range,speaker))
					speaker_coverage[current_turf] = current_turf


	// Try to find all the players who can hear the message
	for(var/i in GLOB.player_list)
		var/mob/current_mob = i
		if(current_mob)
			var/turf/ear = get_turf(current_mob)

			if(ear)
				// Ghostship is magic: Ghosts can hear radio chatter from anywhere
				if(speaker_coverage[ear] || (istype(current_mob, /mob/dead/observer) && (current_mob.client) && (current_mob.client.prefs) && (current_mob.client.prefs.toggles_chat & CHAT_GHOSTRADIO)))
					. |= current_mob // Since we're already looping through mobs, why bother using |= ? This only slows things down.
	return .

/proc/inLineOfSight(X1,Y1,X2,Y2,Z=1,PX1=16.5,PY1=16.5,PX2=16.5,PY2=16.5)
	var/turf/current_turf
	if(X1==X2)
		if(Y1==Y2)
			return 1 //Light cannot be blocked on same tile
		else
			var/s = SIGN(Y2-Y1)
			Y1+=s
			while(Y1!=Y2)
				current_turf=locate(X1,Y1,Z)
				if(current_turf.opacity)
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
			current_turf=locate(X1,Y1,Z)
			if(current_turf.opacity)
				return 0
	return 1
#undef SIGN

/proc/isInSight(atom/first_atom, atom/second_atom)
	var/turf/first_turf = get_turf(first_atom)
	var/turf/second_turf = get_turf(second_atom)

	if(!first_turf || !second_turf)
		return 0

	if(inLineOfSight(first_turf.x,first_turf.y, second_turf.x,second_turf.y,first_turf.z))
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
		var/mob/dead/observer/current_observer = i
		// Jobban check
		if(!current_observer.client || !current_observer.client.prefs || !(current_observer.client.prefs.be_special & BE_ALIEN_AFTER_DEATH) || jobban_isbanned(current_observer, JOB_XENOMORPH))
			continue

		//players that can still be revived are skipped
		if(current_observer.mind && current_observer.mind.original && ishuman(current_observer.mind.original))
			var/mob/living/carbon/human/current_human = current_observer.mind.original
			if (current_human.check_tod() && current_human.is_revivable())
				continue

		// copied from join as xeno
		var/deathtime = world.time - current_observer.timeofdeath
		if(deathtime < 3000 && ( !current_observer.client.admin_holder || !(current_observer.client.admin_holder.rights & R_ADMIN)) )
			continue

		// Admins and AFK players cannot be drafted
		if(current_observer.client.inactivity / 600 > ALIEN_SELECT_AFK_BUFFER + 5 || (current_observer.client.admin_holder && (current_observer.client.admin_holder.rights & R_MOD)) && current_observer.adminlarva == 0)
			continue

		candidates += current_observer

	return candidates

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
		var/atom/current_atom = _a
		list_x += current_atom.x
		list_y += current_atom.y
	return list(
		min(list_x),
		min(list_y),
		max(list_x),
		max(list_y))

// makes peoples byond icon flash on the taskbar
/proc/window_flash(client/current_client)
	if(ismob(current_client))
		var/mob/current_mob = current_client
		if(current_mob.client)
			current_client = current_mob.client
	if(!current_client)
		return
	winset(current_client, "mainwindow", "flash=5")

/proc/flash_clients()
	for(var/client/current_client as anything in GLOB.clients)
		if(current_client.prefs?.toggles_flashing & FLASH_ROUNDSTART)
			window_flash(current_client)

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
