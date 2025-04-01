GLOBAL_SUBTYPE_PATHS_LIST_INDEXED(traits_with_elements, /datum/element/traitbound, associated_trait)

/datum/element/traitbound
	var/associated_trait = ""
	var/compatible_types = list(/datum)

/datum/element/traitbound/Attach(datum/target)
	if(!is_type_in_list(target, compatible_types))
		return ELEMENT_INCOMPATIBLE
	return ..()
