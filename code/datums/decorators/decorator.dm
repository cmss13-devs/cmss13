/datum/decorator
	var/priority = DECORATOR_USUAL

/datum/decorator/proc/is_active_decor()
	return FALSE

/datum/decorator/proc/get_decor_types()
	return null

/datum/decorator/proc/decorate(atom/object)
	return

// Decorators that are forced during round. They will never initialize
/datum/decorator/manual
