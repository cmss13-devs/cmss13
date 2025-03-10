GLOBAL_LIST_EMPTY(projectors)
GLOBAL_LIST_EMPTY(deselected_projectors)
GLOBAL_LIST_EMPTY(clones)
GLOBAL_LIST_EMPTY(clones_t)

SUBSYSTEM_DEF(fz_transitions)
	name = "Z-Transitions"
	wait = 1 SECONDS
	priority = SS_PRIORITY_FZ_TRANSITIONS
	init_order = SS_INIT_FZ_TRANSITIONS
	flags = SS_KEEP_TIMING
	var/list/selective_update = null

/datum/controller/subsystem/fz_transitions/stat_entry(msg)
	msg = "P:[length(GLOB.projectors)]|C:[length(GLOB.clones)]|T:[length(GLOB.clones_t)]"
	return ..()

/datum/controller/subsystem/fz_transitions/Initialize()
	selective_update = list("generic" = 1)
	return SS_INIT_SUCCESS

/datum/controller/subsystem/fz_transitions/fire(resumed = FALSE)
	for(var/obj/effect/projector/P as anything in GLOB.projectors)
		if(!P || !P.loc)
			GLOB.projectors -= P
			continue
		if(!P.loc.clone)
			P.loc.create_clone(P)

		if(P.loc.contents)
			for(var/atom/movable/O as anything in P.loc.contents)
				if(!O.clone)
					if(!(istype(O, /obj/effect/projector) || istype(O, /mob/dead/observer) || istype(O, /obj/structure/stairs) || istype(O, /obj/structure/catwalk) || O.type == /atom/movable/clone))
						O.create_clone_movable(P)
				else
					if(!(istype(O, /obj/effect/projector) || istype(O, /mob/dead/observer) || istype(O, /obj/structure/stairs) || istype(O, /obj/structure/catwalk) || O.type == /atom/movable/clone))
						O.clone.proj_x = P.vector_x //Make sure projection is correct
						O.clone.proj_y = P.vector_y


	for(var/atom/movable/clone/C as anything in GLOB.clones)
		if(C.mstr == null || !istype(C.mstr.loc, /turf))
			C.mstr.destroy_clone() //Kill clone if master has been destroyed or picked up
		else
			if(C != C.mstr && selective_update[C.proj.firing_id])
				C.mstr.update_clone() //NOTE: Clone updates are also forced by player movement to reduce latency

	for(var/atom/T as anything in GLOB.clones_t)
		if(T.clone && T.icon_state) //Just keep the icon updated for explosions etc.
			T.clone.icon_state = T.icon_state

/datum/controller/subsystem/fz_transitions/proc/toggle_selective_update(update, firing_id)
	selective_update[firing_id] = update
	if(update)
		for(var/obj/effect/projector/P as anything in GLOB.deselected_projectors)
			if(selective_update[P.firing_id])
				GLOB.deselected_projectors -= P
				GLOB.projectors += P
	else
		for(var/obj/effect/projector/P as anything in GLOB.projectors)
			if(!selective_update[P.firing_id])
				GLOB.projectors -= P
				GLOB.deselected_projectors += P
	fire()
