GLOBAL_LIST_EMPTY(projectors)
GLOBAL_LIST_EMPTY(clones)
GLOBAL_LIST_EMPTY(clones_t)
GLOBAL_ALIST_EMPTY(projector_links)

SUBSYSTEM_DEF(fz_transitions)
	name = "Z-Transitions"
	wait = 1 SECONDS
	priority = SS_PRIORITY_FZ_TRANSITIONS
	init_order = SS_INIT_FZ_TRANSITIONS
	flags = SS_KEEP_TIMING|SS_NO_INIT

/datum/controller/subsystem/fz_transitions/stat_entry(msg)
	msg = "P:[length(GLOB.projectors)]|C:[length(GLOB.clones)]|T:[length(GLOB.clones_t)]"
	return ..()

/datum/controller/subsystem/fz_transitions/fire(resumed = FALSE)
	for(var/obj/effect/projector/cur_projector as anything in GLOB.projectors)
		if(!cur_projector || !cur_projector.loc)
			GLOB.projectors -= cur_projector
			continue
		if(!cur_projector.loc.clone)
			cur_projector.loc.create_clone(cur_projector.vector_x, cur_projector.vector_y, cur_projector.vector_z)

		if(cur_projector.loc.contents)
			for(var/atom/movable/thing in cur_projector.loc.contents)
				if(!istype(thing, /obj/effect/projector) && !istype(thing, /mob/dead/observer) && !istype(thing, /obj/structure/stairs) && !istype(thing, /obj/structure/catwalk) && thing.type != /atom/movable/clone)
					if(!thing.clone) //Create a clone if it's on a projector
						thing.create_clone_movable(cur_projector.vector_x, cur_projector.vector_y, cur_projector.vector_z)
					else
						thing.clone.proj_x = cur_projector.vector_x //Make sure projection is correct
						thing.clone.proj_y = cur_projector.vector_y
						thing.clone.proj_z = cur_projector.vector_z

	for(var/atom/movable/clone/cur_clone as anything in GLOB.clones)
		if(!cur_clone)
			GLOB.clones -= cur_clone
			continue
		if(cur_clone.mstr == null || !istype(cur_clone.mstr.loc, /turf))
			cur_clone.mstr.destroy_clone() //Kill clone if master has been destroyed or picked up
			continue
		if(cur_clone != cur_clone.mstr)
			cur_clone.mstr.update_clone() //NOTE: Clone updates are also forced by player movement to reduce latency

	for(var/atom/cur_turf as anything in GLOB.clones_t)
		if(!cur_turf)
			GLOB.clones_t -= cur_turf
			continue
		if(cur_turf.clone && cur_turf.icon_state) //Just keep the icon updated for explosions etc.
			cur_turf.clone.icon_state = cur_turf.icon_state
