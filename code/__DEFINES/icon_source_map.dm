GLOBAL_LIST_EMPTY(icon_source_files)

/proc/get_icon_from_source(source_name)
	var/icon/I = null
	GLOB.icon_source_files[source_name] = file(source_name)
	I = GLOB.icon_source_files[source_name]
	return I
