GLOBAL_LIST_INIT(lazy_templates, generate_lazy_template_map())

/**
 * Iterates through all lazy template datums that exist and returns a list of them as an associative list of type -> instance.
 * */
/proc/generate_lazy_template_map()
	. = list()
	for(var/datum/lazy_template/template as anything in subtypesof(/datum/lazy_template))
		.[template] = new template
	return .
