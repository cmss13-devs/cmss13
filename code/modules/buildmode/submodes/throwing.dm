/datum/buildmode_mode/throwing
	key = "throw"
	help = "Left Mouse Button on turf/obj/mob = Select\n\
	Right Mouse Button on turf/obj/mob = Throw"

	var/atom/movable/throw_atom = null

/datum/buildmode_mode/throwing/Destroy()
	throw_atom = null
	return ..()

/datum/buildmode_mode/throwing/when_clicked(client/c, params, obj/object)
	var/list/modifiers = params2list(params)

	if(LAZYACCESS(modifiers, LEFT_CLICK))
		if(isturf(object))
			return
		throw_atom = object
		to_chat(c, "Selected object '[throw_atom]'")
	if(LAZYACCESS(modifiers, RIGHT_CLICK))
		if(throw_atom)
			throw_atom.throw_atom(object, 16, SPEED_VERY_FAST, c.mob, TRUE)
			log_admin("Build Mode: [key_name(c)] threw [throw_atom] at [object] ([AREACOORD(object)])")
