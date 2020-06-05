/datum/decorator/manual/admin_runtime
	var/decorate_type
	var/decorate_subtypes = FALSE
	var/field
	var/value
	var/enabled = TRUE

/datum/decorator/manual/admin_runtime/New(_decorate_type, _decorate_subtypes, _field, _value)	
	decorate_type = text2path("[_decorate_type]")
	decorate_subtypes = _decorate_subtypes
	field = _field
	value = _value

/datum/decorator/manual/admin_runtime/is_active_decor()
	return TRUE

/datum/decorator/manual/admin_runtime/get_decor_types()
	if(decorate_subtypes)
		return typesof(decorate_type)
	else
		return list(decorate_type)

/datum/decorator/manual/admin_runtime/decorate(var/atom/obj)
	if(enabled)
		obj.vars[field] = value
	