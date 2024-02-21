GLOBAL_LIST_INIT(lazy_templates, generate_lazy_template_map())

/**
 * Iterates through all lazy template datums that exist and returns a list of them as an associative list of map_name -> instance.
 *
 * Screams if more than one key exists, loudly.
 */
/proc/generate_lazy_template_map()
	. = list()
	for(var/datum/lazy_template/template as anything in subtypesof(/datum/lazy_template))
		var/map_name = initial(template.map_name)
		if(map_name in .)
			stack_trace("Found multiple lazy templates with the same map name! '[map_name]'")
		.[map_name] = new template
	return .
