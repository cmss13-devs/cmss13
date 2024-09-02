/*
shuttle_backend.dm
by MadSnailDisease, 12/29/16
**************************************

/datum/shuttle_area_info :
--------------------------------
This is just a datum that holds the hard-coded coordinate datums.
An instance of it named s_info is found in the shuttle controller
--------------------------------

/datum/coords :
--------------------------------
An object that just hold x, y, and z positions coordinates



/proc/get_shuttle_turfs(turf/ref, shuttle) :
--------------------------------
ref: the reference turf, gotten from its respective landmark
shuttle: The name of the shuttle in question. Synonymous with the name of the ref landmark.

Return: A list of coordinate datums indexed by turfs.

Notes:
The list size will vary dependind on which shuttle you used.
See the documentation of /datum/shuttle_area_info for more.



/proc/rotate_shuttle_turfs(list/L, deg = 0)
--------------------------------
L: The shuttle turfs to rotate. MUST be coord datums indexed by turf, a la get_shuttle_turfs()
deg: In degrees, how much to rotate the shuttle (clockwise).

Return: the new list on success, null on failure

Notes:
If deg % 90 != 0 then this will return 0
When using this in-game, this will rotate treating the reference turf as the origin,
so keep in mind that a 180 degree turn will reflect the shuttle through the turf,
e.g. Something up to the right relative to its landmark will end up down to the left
ONLY called when moving to either the trg landmark or a crs landmark


/proc/move_shuttle_to(turf/trg, turftoleave = null, list/source, iselevator = 0, datum/shuttle/ferry/marine/shuttle)
--------------------------------
trg: The target reference turf, see var/turf/ref from the previous proc
turftoleave: Allows leaving other turfs behind as needed. Note: must be a path
source: A list of coordinate datums indexed by turfs. See Return from the previous proc
iselevator: Used as a simple boolean. Dictates whether or not the shuttle is in fact an elevator

The shuttle variable should always be present to reference back the existing shuttle.
Should be reworked in the future. Right now it references evac pods only, and only matters for them,
but it should be brought up to all marine ferries.

Notes:
iselevator is admittedly a hair "hacky"
TODO: Create /datum/shuttle/ferry/marine/elevator and depreciate this

*/

/*

DOCUMENTATION ON HOW TO ADD A NEW SHUTTLE: Fourkhan, 6/7/19

- Step one is to map the physical shuttle somewhere on the map.

- Step two is to add the shuttle datum to shuttle_controller.dm
	- the shuttle_tag var is the primary identifier of the shuttle, we'll see this again later on
	- the info_tag is how you identify the shuttle in the s_info assoc. list, that's the next step

- Step three is the worst part: map out the s_info listing based on the physical shuttle.
	- follow the examaples already here as a guideline and this should be fairly straightforward.
	- keep in mind this is will be retrieved with info_tag on the shuttle datum so those need to EXACTLY match.

- Step four: decide which subtype of landmark you need you need the shuttle to be placed into, or
	define a new one to suit your needs. Either way, the landmarks need to properly register
	(at ABSOLUTE MINIMUM) turfs in locs_move, locs_dock, and locs_land which map to the starting,
	transit, and end locations of the shuttle respectively.

- Step five: map the landmarks onto the map. These need to have the EXACT same name and be translateable
	somehow to the master shuttle tag, the macros further down in this file are a good example
	for the most part. Convention is to name the landmarks 1, 2, 3, etc. as necessary.

- Step six: add a shuttle console, this is code-by-copypaste for the most part.

*/



/proc/get_shuttle_turfs(turf/ref, list/L)

	var/list/source = list()

	var/i
	var/datum/coords/C
	for(i in L)
		C = i
		if(!istype(C)) continue
		var/turf/T = locate(ref.x + C.x_pos, ref.y + C.y_pos, ref.z) //Who is in the designated area?
		source += T //We're taking you with us
		source[T] = C //Remember which exact /datum/coords that you used though

	return source

/proc/rotate_shuttle_turfs(list/L, deg = 0)

	if((deg % 90) != 0) return //Not a right or straight angle, don't do anything
	if(!istype(L) || !length(L)) return null

	var/i //iterator
	var/x //Placeholder while we do math
	var/y //Placeholder while we do math
	var/datum/coords/C
	var/datum/coords/C1
	var/list/toReturn = list()
	for(i in L)
		C = L[i]
		if(!istype(C)) continue
		C1 = new
		x = C.x_pos
		y = C.y_pos
		C1.x_pos = x*cos(deg) + y*sin(deg)
		C1.y_pos = y*cos(deg) - x*sin(deg)
		C1.x_pos = round(C.x_pos, 1) //Sometimes you get very close to the right number but off by around 1e-15 and I want integers dammit
		C1.y_pos = round(C.y_pos, 1)
		toReturn += i
		toReturn[i] = C1

	return toReturn

/proc/move_shuttle_to(turf/reference, turftoleave = null, list/source, iselevator = 0, deg = 0, datum/shuttle/ferry/marine/shuttle)
	//var/list/turfsToUpdate = list()

	if(shuttle.sound_misc) playsound(source[shuttle.sound_target], shuttle.sound_misc, 75, 1)

	var/area/departure_area = get_area(source[shuttle.sound_target])
	var/area/landing_area
	departure_area.base_muffle = 0
	if (deg)
		source = rotate_shuttle_turfs(source, deg)

	var/list/mob/living/knocked_down_mobs = list()
	var/datum/coords/C = null

	var/list/targets = list()
	for (var/turf/T in source)
		C = source[T]
		var/turf/target = locate(reference.x + C.x_pos, reference.y + C.y_pos, reference.z)
		landing_area = target.loc
		if(istype(landing_area, /area/shuttle) && landing_area.base_muffle == 0)
			landing_area.base_muffle = shuttle.ambience_muffle

		// Delete objects and gib living things in the destination
		for (var/atom/A in target)
			if (isobj(A) && A.loc == target)
				qdel(A)
				continue

			if (isliving(A))
				var/mob/living/L = A
				L.last_damage_data = create_cause_data("dropship flattening")
				L.gib()

		target = target.ChangeTurf(/turf/open/gm/empty)

		targets.Add(T)
		targets[T] = target

	for(var/turf/T in source)
		C = source[T]
		var/turf/target = targets[T]
		landing_area = target.loc

		// Moving the turfs over
		var/old_dir = T.dir
		var/old_icon_state = T.icon_state
		var/old_icon = T.icon

		target.ChangeTurf(T.type)
		target.setDir(old_dir)
		target.icon_state = old_icon_state
		target.icon = old_icon

		if(istype(target, /turf/closed/shuttle)) //better than underlaying everyturf, just need the parts that have see through parts. Which are all closed turfs
			target.underlays.Cut()
			target.underlays += mutable_appearance(reference.icon, reference.icon_state, TURF_LAYER, FLOOR_PLANE)

		for (var/atom/movable/A in T)
			// fix for multitile stuff like vehicles drifting on jump
			if(A.loc != T)
				continue

			if (isobj(A))
				A.forceMove(target)

			if (ismob(A))
				A.forceMove(target)
				if(iscarbon(A))
					var/mob/living/carbon/M = A
					if(M.client)
						if(M.buckled && !iselevator)
							to_chat(M, SPAN_WARNING("Sudden acceleration presses you into [M.buckled]!"))
							shake_camera(M, 3, 1)
						else if (!M.buckled)
							to_chat(M, SPAN_WARNING("The floor lurches beneath you!"))
							shake_camera(M, iselevator ? 2 : 10, 1)

					if(!iselevator)
						if(!M.buckled)
							knocked_down_mobs += M
				landing_area.Entered(A)

		if(turftoleave && ispath(turftoleave))
			T.ChangeTurf(turftoleave)
		else
			T.ChangeTurf(/turf/open/floor/plating)

	shuttle.move_scheduled = 0
	shuttle.already_moving = 0
	// Do this after because it's expensive.
	for (var/mob/living/L in knocked_down_mobs)
		L.apply_effect(3, WEAKEN)

	/*
	Commented out since it doesn't do anything with shuttle walls and the like yet.
	It will pending smoothwall.dm rewrite

	if(deg) //If we rotated, update the icons
		i = null //reset it, cuz why not
		var/j //iterator
		var/turf/updating
		for(i in turfsToUpdate)
			updating = i
			if(!istype(updating)) continue
			updating.relativewall()
	*/

/* Commented out since this functionality was moved to /datum/shuttle/ferry/marine/close_doors() and open_doors()
	if(air_master) // If that crazy bug is gonna happen, it may as well happen on landing.
		var/turf/T
		for(i in update_air)
			T = i
			if(!istype(T)) continue
			air_master.mark_for_update(T)
*/
