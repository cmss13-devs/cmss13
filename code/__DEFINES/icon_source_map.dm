GLOBAL_LIST_EMPTY(icon_source_files)

/proc/get_icon_from_source(source_name)
	if(GLOB.icon_source_files[source_name])
		return GLOB.icon_source_files[source_name]
	GLOB.icon_source_files[source_name] = file(source_name)
	return GLOB.icon_source_files[source_name]
