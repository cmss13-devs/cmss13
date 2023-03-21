var/list/projectors = list()
var/list/clones = list()
var/list/clones_t = list()

SUBSYSTEM_DEF(fz_transitions)
	name = "Z-Transitions"
	wait = 1 SECONDS
	priority = SS_PRIORITY_FZ_TRANSITIONS
	init_order = SS_INIT_FZ_TRANSITIONS
	flags = SS_KEEP_TIMING

/datum/controller/subsystem/fz_transitions/stat_entry(msg)
	msg = "P:[projectors.len]|C:[clones.len]|T:[clones_t.len]"
	return ..()

/datum/controller/subsystem/fz_transitions/Initialize()
	for(var/obj/effect/projector/transition_projector in world)
		projectors.Add(transition_projector)
	return SS_INIT_SUCCESS

/datum/controller/subsystem/fz_transitions/fire(resumed = FALSE)
	for(var/obj/effect/projector/transition_projector in projectors)
		if(!transition_projector || !transition_projector.loc)
			projectors -= transition_projector
			continue
		if(!transition_projector.loc.clone)
			transition_projector.loc.create_clone(transition_projector.vector_x, transition_projector.vector_y)

		if(transition_projector.loc.contents)
			for(var/atom/movable/current_atom in transition_projector.loc.contents)
				if(!istype(current_atom, /obj/effect/projector) && !istype(current_atom, /mob/dead/observer) && !istype(current_atom, /obj/structure/stairs) && !istype(current_atom, /obj/structure/catwalk) && current_atom.type != /atom/movable/clone)
					if(!current_atom.clone) //Create a clone if it's on a projector
						current_atom.create_clone_movable(transition_projector.vector_x, transition_projector.vector_y)
					else
						current_atom.clone.proj_x = transition_projector.vector_x //Make sure projection is correct
						current_atom.clone.proj_y = transition_projector.vector_y


	for(var/atom/movable/clone/cloned_atom in clones)
		if(cloned_atom.mstr == null || !istype(cloned_atom.mstr.loc, /turf))
			cloned_atom.mstr.destroy_clone() //Kill clone if master has been destroyed or picked up
		else
			if(cloned_atom != cloned_atom.mstr)
				cloned_atom.mstr.update_clone() //NOTE: Clone updates are also forced by player movement to reduce latency

	for(var/atom/cloned_atom in clones_t)
		if(cloned_atom.clone && cloned_atom.icon_state) //Just keep the icon updated for explosions etc.
			cloned_atom.clone.icon_state = cloned_atom.icon_state
