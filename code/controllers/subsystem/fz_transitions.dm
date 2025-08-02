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
	for(var/obj/effect/projector/target_projector as anything in GLOB.projectors)
		if(!target_projector || !target_projector.loc)
			GLOB.projectors -= target_projector
			continue
		if(!target_projector.loc.clone)
			target_projector.loc.create_clone(target_projector)

		if(target_projector.loc.contents)
			for(var/atom/movable/target_atom as anything in target_projector.loc.contents)
				if(!target_atom.clone)
					if(!(istype(target_atom, /obj/effect/projector) || istype(target_atom, /mob/dead/observer) || istype(target_atom, /obj/structure/stairs) || istype(target_atom, /obj/structure/catwalk) || target_atom.type == /atom/movable/clone))
						target_atom.create_clone_movable(target_projector)
				else
					if(!(istype(target_atom, /obj/effect/projector) || istype(target_atom, /mob/dead/observer) || istype(target_atom, /obj/structure/stairs) || istype(target_atom, /obj/structure/catwalk) || target_atom.type == /atom/movable/clone))
						target_atom.clone.proj_x = target_projector.vector_x //Make sure projection is correct
						target_atom.clone.proj_y = target_projector.vector_y


	for(var/atom/movable/clone/target_clone as anything in GLOB.clones)
		if(target_clone.mstr == null || !istype(target_clone.mstr.loc, /turf))
			target_clone.mstr.destroy_clone() //Kill clone if master has been destroyed or picked up
		else
			if(target_clone != target_clone.mstr && selective_update[target_clone.proj.firing_id])
				target_clone.mstr.update_clone() //NOTE: Clone updates are also forced by player movement to reduce latency

	for(var/atom/T as anything in GLOB.clones_t)
		if(T.clone && T.icon_state) //Just keep the icon updated for explosions etc.
			T.clone.icon_state = T.icon_state

/datum/controller/subsystem/fz_transitions/proc/toggle_selective_update(update, firing_id)
	selective_update[firing_id] = update
	if(update)
		for(var/obj/effect/projector/target_projector as anything in GLOB.deselected_projectors)
			if(selective_update[target_projector.firing_id])
				GLOB.deselected_projectors -= target_projector
				GLOB.projectors += target_projector
	else
		for(var/obj/effect/projector/target_projector as anything in GLOB.projectors)
			if(!selective_update[target_projector.firing_id])
				GLOB.projectors -= target_projector
				GLOB.deselected_projectors += target_projector
	fire()
