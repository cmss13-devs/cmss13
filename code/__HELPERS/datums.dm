///Check if a datum has not been deleted and is a valid source
/proc/is_valid_src(datum/source_datum)
	if(istype(source_datum))
		return !QDELETED(source_datum)
	return FALSE
