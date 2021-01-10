
/proc/gibs(atom/location, var/list/viruses, var/mob/living/ml)		//CARN MARKER
	new /obj/effect/spawner/gibspawner/generic(get_turf(location),viruses,ml)

/proc/hgibs(atom/location, var/list/viruses, var/mob/living/ml, var/fleshcolor, var/bloodcolor)
	new /obj/effect/spawner/gibspawner/human(get_turf(location),viruses,ml,fleshcolor,bloodcolor)

/proc/xgibs(atom/location, var/list/viruses)
	new /obj/effect/spawner/gibspawner/xeno(get_turf(location),viruses)

/proc/robogibs(atom/location, var/list/viruses)
	new /obj/effect/spawner/gibspawner/robot(get_turf(location),viruses)

/obj/effect/spawner/gibspawner
	var/sparks = 0 //whether sparks spread on Gib()
	var/virusProb = 20 //the chance for viruses to spread on the gibs
	var/list/gibtypes = list()
	var/list/gibamounts = list()
	var/list/gibdirections = list() //of lists
	var/fleshcolor //Used for gibbed humans.
	var/bloodcolor //Used for gibbed humans.
	icon = 'icons/landmarks.dmi'
	icon_state = "landmark_gibs"
	garbage = TRUE
	var/list/viruses
	var/mob/living/ml

/obj/effect/spawner/gibspawner/Initialize(mapload, var/list/viruses, var/mob/living/ml, var/fleshcolor, var/bloodcolor)
	. = ..()

	if(fleshcolor) src.fleshcolor = fleshcolor
	if(bloodcolor) src.bloodcolor = bloodcolor

	if(istype(loc,/turf)) //basically if a badmin spawns it
		src.viruses = viruses
		src.ml = ml
		return INITIALIZE_HINT_LATELOAD
	return INITIALIZE_HINT_QDEL

/obj/effect/spawner/gibspawner/LateInitialize()
	. = ..()
	Gib(viruses,ml)
	QDEL_IN(src, 1 SECONDS)

/obj/effect/spawner/gibspawner/proc/Gib(var/list/viruses = list(), var/mob/living/ml = null)
	if(gibtypes.len != gibamounts.len || gibamounts.len != gibdirections.len)
		to_world(SPAN_DANGER("Gib list length mismatch!"))
		return

	var/obj/effect/decal/cleanable/blood/gibs/gib = null
	for(var/datum/disease/D in viruses)
		if(D.spread_type == SPECIAL)
			viruses -= D
			qdel(D)

	if(sparks)
		var/datum/effect_system/spark_spread/s = new /datum/effect_system/spark_spread
		s.set_up(2, 1, loc)
		s.start()

	for(var/i = 1, i<= gibtypes.len, i++)
		if(gibamounts[i])
			for(var/j = 1, j<= gibamounts[i], j++)
				var/gibType = gibtypes[i]
				gib = new gibType(loc)

				// Apply human species colouration to masks.
				if(fleshcolor)
					gib.fleshcolor = fleshcolor
				if(bloodcolor)
					gib.basecolor = bloodcolor

				gib.update_icon()

				if(viruses.len > 0)
					for(var/datum/disease/D in viruses)
						if(prob(virusProb))
							var/datum/disease/viruus = D.Copy(1)
							LAZYADD(gib.viruses, viruus)
							viruus.holder = gib

				var/list/directions = gibdirections[i]
				if(directions.len)
					INVOKE_ASYNC(gib, /obj/effect/decal/cleanable/blood/gibs/proc/streak, directions)


/obj/effect/spawner/gibspawner/generic
	gibtypes = list(/obj/effect/decal/cleanable/blood/gibs,/obj/effect/decal/cleanable/blood/gibs,/obj/effect/decal/cleanable/blood/gibs/core)
	gibamounts = list(2,2,1)

/obj/effect/spawner/gibspawner/generic/Initialize(mapload, list/viruses, mob/living/ml, fleshcolor, bloodcolor)
	gibdirections = list(list(WEST, NORTHWEST, SOUTHWEST, NORTH),list(EAST, NORTHEAST, SOUTHEAST, SOUTH), list())
	. = ..()



/obj/effect/spawner/gibspawner/human
	gibtypes = list(/obj/effect/decal/cleanable/blood/gibs,/obj/effect/decal/cleanable/blood/gibs,/obj/effect/decal/cleanable/blood/gibs/core)
	gibamounts = list(1,1,1)

/obj/effect/spawner/gibspawner/human/Initialize(mapload, list/viruses, mob/living/ml, fleshcolor, bloodcolor)
	gibdirections = list(alldirs, alldirs, list())
	. = ..()

/obj/effect/spawner/gibspawner/xeno
	gibtypes = list(/obj/effect/decal/cleanable/blood/gibs/xeno,/obj/effect/decal/cleanable/blood/gibs/xeno/limb,/obj/effect/decal/cleanable/blood/gibs/xeno/core)
	gibamounts = list(1,1,1)

/obj/effect/spawner/gibspawner/xeno/Initialize(mapload, list/viruses, mob/living/ml, fleshcolor, bloodcolor)
	gibdirections = list(alldirs, alldirs, list())
	. = ..()

/obj/effect/spawner/gibspawner/robot
	sparks = 1
	gibtypes = list(/obj/effect/decal/cleanable/blood/gibs/robot/up,/obj/effect/decal/cleanable/blood/gibs/robot/down,/obj/effect/decal/cleanable/blood/gibs/robot,/obj/effect/decal/cleanable/blood/gibs/robot,/obj/effect/decal/cleanable/blood/gibs/robot,/obj/effect/decal/cleanable/blood/gibs/robot/limb)
	gibamounts = list(1,1,1,1,1,1)

/obj/effect/spawner/gibspawner/robot/Initialize(mapload, list/viruses, mob/living/ml, fleshcolor, bloodcolor)
	gibdirections = list(list(NORTH, NORTHEAST, NORTHWEST),list(SOUTH, SOUTHEAST, SOUTHWEST),list(WEST, NORTHWEST, SOUTHWEST),list(EAST, NORTHEAST, SOUTHEAST), alldirs, alldirs)
	gibamounts[6] = pick(0,1,2)
	. = ..()
