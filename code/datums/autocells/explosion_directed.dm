/datum/automata_cell/explosion/directed
	should_merge = FALSE

	var/original_dir = null

/datum/automata_cell/explosion/directed/setup_new_cell(var/datum/automata_cell/explosion/directed/E)
	E.original_dir = original_dir

/datum/automata_cell/explosion/directed/get_propagation_dirs()
	var/list/propagation_dirs = list()

	if(isnull(original_dir))
		return null

	for(var/dir in alldirs)
		// All directions ahead, including diagonals
		if(dir & original_dir)
			propagation_dirs += dir

	return propagation_dirs
