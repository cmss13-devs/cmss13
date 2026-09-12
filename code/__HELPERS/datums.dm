/// Marks a type as abstract. This means that it should not be instantiated and only exists as a type
#define ABSTRACT_TYPE(type) type/abstract_type = type

///Check if a datum has not been deleted and is a valid source
/proc/is_valid_src(datum/source_datum)
	if(istype(source_datum))
		return !QDELETED(source_datum)
	return FALSE
