/obj/effect/projector
	density = FALSE
	unacidable = TRUE
	anchored = TRUE
	invisibility = 101
	layer = TURF_LAYER
	var/vector_x = 0
	var/vector_y = 0
	icon = 'icons/landmarks.dmi'
	/// for map editor
	icon_state = "projector"
	/// this makes any projections have this layer if set to anything
	var/layer_override
	/// 0 for not paused, 1 for primed for pausaztion, 2 for completely paused
	var/paused = FALSE
	/// used to return after being nullspaced(cargo elevator shenanigans)
	var/list/coord_cache
	/// ability to manipulate the clones
	var/interactable_projections = TRUE

/obj/effect/projector/Initialize(mapload, ...)
	. = ..()
	coord_cache = list("x"=x,"y"=y,"z"=z)

/// TRUE n FALSE in reference to whether to pause or not
/obj/effect/projector/proc/update_state(state)
	switch(state)
		if(TRUE)
			if(!paused && loc)
				paused = TRUE
				if(loc.clone)
					loc.destroy_clone(vector_x, vector_y)
				if(loc.contents)
					for(var/atom/movable/O in loc.contents)
						if(O.clone)
							O.destroy_clone_movable()
				moveToNullspace()
				return TRUE
			else
				return FALSE
		if(FALSE)
			if(paused)
				forceMove(locate(coord_cache["x"], coord_cache["y"], coord_cache["z"]))
				paused = FALSE
				loc.create_clone(vector_x, vector_y, layer_override)
				for(var/atom/movable/O in loc.contents)
					if(!istype(O, /obj/effect/projector) && !istype(O, /mob/dead/observer) && !istype(O, /obj/structure/stairs) && !istype(O, /obj/structure/catwalk) && O.type != /atom/movable/clone)
						if(!O.clone)
							O.create_clone_movable(vector_x, vector_y, layer_override, interactable_projections)
				return TRUE
			else
				return FALSE
