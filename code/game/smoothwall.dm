//Separate dm because it relates to two types of atoms + ease of removal in case it's needed.
//Also assemblies.dm for falsewall checking for this when used.
//I should really make the shuttle wall check run every time it's moved, but centcom uses unsimulated floors so !effort

/atom
	//A list of paths only that each turf should tile with
	var/list/tiles_with

/atom/proc/relativewall() //atom because it should be useable both for walls, false walls, doors, windows, etc
	var/junction = 0 //flag used for icon_state
	var/i //iterator
	var/turf/current_turf //The turf we are checking
	var/j //second iterator
	var/current_atom //third iterator (I know, that's a lot, but I'm trying to make this modular, so bear with me)

	for(i in cardinal) //For all cardinal dir turfs
		current_turf = get_step(src, i)
		if(!istype(current_turf)) continue
		for(j in tiles_with) //And for all types that we tile with
			if(istype(current_turf, j))
				junction |= i
				break

			for(current_atom in current_turf)
				if(istype(current_atom, j))
					junction |= i
					break

	handle_icon_junction(junction)

/atom/proc/relativewall_neighbours()
	var/i //iterator
	var/turf/current_turf //The turf we are checking
	var/j //second iterator
	var/atom/current_atom //third iterator (I know, that's a lot, but I'm trying to make this modular, so bear with me)

	for(i in cardinal) //For all cardinal dir turfs
		current_turf = get_step(src, i)
		if(!istype(current_turf)) continue
		for(j in tiles_with) //And for all types that we tile with
			if(istype(current_turf, j))
				current_turf.relativewall() //If we tile this type, junction it
				break

			for(current_atom in current_turf)
				if(istype(current_atom, j))
					current_atom.relativewall() //get_dir to i, since current_atom is something inside the turf current_turf
					break

/atom/proc/handle_icon_junction(junction)
	return

//Windows are weird. The walls technically tile with them, but they don't tile back. At least, not really.
//They require more states or something to that effect, but this is a workaround to use what we have.
//I could introduce flags here, but I feel like the faster the better. In this case an override with copy and pasted code is fine for now.
/obj/structure/window/framed/relativewall()
	var/jun_1 = 0 //Junction 1.
	var/jun_2 = 0 //Junction 2.
	var/turf/current_turf
	var/i
	var/j
	var/current_atom

	for(i in cardinal)
		current_turf = get_step(src, i)
		if(!istype(current_turf)) continue
		for(j in tiles_with)
			if(istype(current_turf, j))
				jun_1 |= i
				break

			for(current_atom in current_turf)
				if(istype(current_atom, j))
					jun_1 |= i
					break

		for(j in tiles_special)
			for(current_atom in current_turf)
				if(istype(current_atom, j))
					jun_2 |= i
					break

	handle_icon_junction(jun_1, jun_2)

//Windows are weird. The walls technically tile with them, but they don't tile back. At least, not really.
//They require more states or something to that effect, but this is a workaround to use what we have.
//I could introduce flags here, but I feel like the faster the better. In this case an override with copy and pasted code is fine for now.
/obj/structure/window_frame/relativewall()
	var/jun_1 = 0 //Junction 1.
	var/jun_2 = 0 //Junction 2.
	var/turf/current_turf
	var/i
	var/j
	var/current_atom

	for(i in cardinal)
		current_turf = get_step(src, i)
		if(!istype(current_turf)) continue
		for(j in tiles_with)
			if(istype(current_turf, j))
				jun_1 |= i
				break

			for(current_atom in current_turf)
				if(istype(current_atom, j))
					jun_1 |= i
					break

		for(j in tiles_special)
			for(current_atom in current_turf)
				if(istype(current_atom, j))
					jun_2 |= i
					break

	handle_icon_junction(jun_1, jun_2)

// Special case for smoothing walls around multi-tile doors.
/obj/structure/machinery/door/airlock/multi_tile/relativewall_neighbours()
	var/turf/current_turf //The turf we are checking
	var/atom/current_atom
	var/j

	if (dir == SOUTH)
		current_turf = locate(x, y+2, z)
		for(j in tiles_with)
			if(istype(current_turf, j))
				current_turf.relativewall()
				break
			for(current_atom in current_turf)
				if(istype(current_atom, j))
					current_atom.relativewall()
					break

		current_turf = get_step(src, SOUTH)
		for(j in tiles_with)
			if(istype(current_turf, j))
				current_turf.relativewall()
				break
			for(current_atom in current_turf)
				if(istype(current_atom, j))
					current_atom.relativewall()
					break

	else if (dir == EAST)
		current_turf = locate(x+2, y, z)
		for(j in tiles_with)
			if(istype(current_turf, j))
				current_turf.relativewall()
				break
			for(current_atom in current_turf)
				if(istype(current_atom, j))
					current_atom.relativewall()
					break

		current_turf = get_step(src, WEST)
		for(j in tiles_with)
			if(istype(current_turf, j))
				current_turf.relativewall()
				break
			for(current_atom in current_turf)
				if(istype(current_atom, j))
					current_atom.relativewall()
					break

// Not proud of this.
/obj/structure/mineral_door/resin/handle_icon_junction(junction)
	if(junction & (SOUTH|NORTH))
		setDir(WEST)
	else if(junction & (EAST|WEST))
		setDir(NORTH)

/obj/structure/window/framed/handle_icon_junction(jun_1, jun_2)
	icon_state = "[basestate][jun_2 ? jun_2 : jun_1]" //Use junction 2 if possible, junction 1 otherwise.
	if(jun_2)
		junction = jun_2
	else
		junction = jun_1

/obj/structure/window_frame/handle_icon_junction(jun_1, jun_2)
	icon_state = "[basestate][jun_2 ? jun_2 : jun_1]_frame" //Use junction 2 if possible, junction 1 otherwise.
	if(jun_2)
		junction = jun_2
	else
		junction = jun_1



/turf/closed/wall/handle_icon_junction(junction)
	icon_state = "[walltype][junction]"
	junctiontype = junction

/obj/structure/grille/almayer/handle_icon_junction(junction)
	icon_state = "grille[junction]"


/turf/open/floor/vault/relativewall()
	return

/turf/closed/wall/vault/relativewall()
	return

/turf/closed/shuttle/relativewall()
	//TODO: Make something for this and make it work with shuttle rotations
	return

/turf/open/shuttle/relativewall()
	return

/turf/closed/wall/indestructible/relativewall()
	return


/turf/open/asphalt/cement/relativewall()
	var/junction = 0 //flag used for icon_state
	var/i //iterator
	var/turf/current_turf //The turf we are checking
	var/j //second iterator
	var/current_atom //third iterator (I know, that's a lot, but I'm trying to make this modular, so bear with me)

	for(i in alldirs) //For all cardinal dir turfs
		current_turf = get_step(src, i)
		if(!istype(current_turf)) continue
		for(j in tiles_with) //And for all types that we tile with
			if(istype(current_turf, j))
				junction |= i
				break

			for(current_atom in current_turf)
				if(istype(current_atom, j))
					junction |= i
					break

	handle_icon_junction(junction)

/turf/open/asphalt/cement_sunbleached/relativewall()
	var/junction = 0 //flag used for icon_state
	var/i //iterator
	var/turf/current_turf //The turf we are checking
	var/j //second iterator
	var/current_atom //third iterator (I know, that's a lot, but I'm trying to make this modular, so bear with me)

	for(i in alldirs) //For all cardinal dir turfs
		current_turf = get_step(src, i)
		if(!istype(current_turf)) continue
		for(j in tiles_with) //And for all types that we tile with
			if(istype(current_turf, j))
				junction |= i
				break

			for(current_atom in current_turf)
				if(istype(current_atom, j))
					junction |= i
					break

	handle_icon_junction(junction)
