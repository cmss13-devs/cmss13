/// Like [subtypesof] but returns only datum types that haven't been marked as abstract
/proc/subtypesof_real(input_path)
	var/list/paths = subtypesof(input_path)
	. = list()
	for(var/datum/path as anything in paths)
		if(path.abstract_type != path)
			. += path
