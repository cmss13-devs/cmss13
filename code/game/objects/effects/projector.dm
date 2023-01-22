/obj/effect/projector
	density = FALSE
	unacidable = TRUE
	anchored = 1
	invisibility = 101
	layer = TURF_LAYER
	var/vector_x = 0
	var/vector_y = 0
	icon = 'icons/landmarks.dmi'
	icon_state = "projector"//for map editor
	var/layer_override
	var/paused = FALSE // 0 for not paused, 1 for primed for pausaztion, 2 for completely paused
	var/list/coord_cache //used to return after moving

/obj/effect/projector/Initialize(mapload, ...)
	. = ..()
	coord_cache = list("x"=x,"y"=y,"z"=z)

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
							O.create_clone_movable(vector_x, vector_y, layer_override)
				return TRUE
			else
				return FALSE
