var/list/projectors = list()
var/list/clones = list()
var/list/clones_t = list()

SUBSYSTEM_DEF(fz_transitions)
	name			= "Z-Transitions"
	wait			= 1 SECONDS
	priority 		= SS_PRIORITY_FZ_TRANSITIONS
	init_order		= SS_INIT_FZ_TRANSITIONS
	flags     		= SS_KEEP_TIMING

/datum/controller/subsystem/fz_transitions/stat_entry()
	..("P:[projectors.len]|C:[clones.len]|T:[clones_t.len]")

/datum/controller/subsystem/fz_transitions/Initialize()
	for(var/obj/effect/projector/P in world)
		projectors.Add(P)
	return ..()

/datum/controller/subsystem/fz_transitions/fire(resumed = FALSE)
	for(var/obj/effect/projector/P in projectors)
		if(!P || !P.loc)
			projectors -= P
			continue
		if(!P.loc.clone)
			P.loc.create_clone(P.vector_x, P.vector_y)

		if(P.loc.contents)
			for(var/atom/movable/O in P.loc.contents)
				if(!istype(O, /obj/effect/projector) && !istype(O, /mob/dead/observer) && !istype(O, /obj/structure/stairs) && !istype(O, /obj/structure/catwalk) && O.type != /atom/movable/clone)
					if(!O.clone) //Create a clone if it's on a projector
						O.create_clone_movable(P.vector_x, P.vector_y)
					else
						O.clone.proj_x = P.vector_x //Make sure projection is correct
						O.clone.proj_y = P.vector_y


	for(var/atom/movable/clone/C in clones)
		if(C.mstr == null || !istype(C.mstr.loc, /turf))
			C.mstr.destroy_clone() //Kill clone if master has been destroyed or picked up
		else
			if(C != C.mstr)
				C.mstr.update_clone() //NOTE: Clone updates are also forced by player movement to reduce latency

	for(var/atom/T in clones_t)
		if(T.clone && T.icon_state) //Just keep the icon updated for explosions etc.
			T.clone.icon_state = T.icon_state