/datum/controller/structs
	/**
	 * Value for calculating the index of the struct currently being
	 * generated
	 * Should always be above 1, as index 1 is reserved for the struct name
	 */
	var/static/current_struct_idx = STRUCT_PROP_STARTING_INDEX

	var/list/structs_datum_in_built_vars

/datum/controller/structs/New()
	if(STRUCTS)
		CRASH("Multiple instances of structs controller created")
	STRUCTS = src

	var/datum/controller/exclude_these = new
	// I know this is dumb but the nested vars list hangs a ref to the datum. This fixes that
	var/list/controller_vars = exclude_these.vars.Copy()
	controller_vars["vars"] = null
	structs_datum_in_built_vars = controller_vars + list(NAMEOF(src, current_struct_idx))

	QDEL_IN(exclude_these, 0) //signal logging isn't ready

	log_world("[length(vars) - length(structs_datum_in_built_vars)] structs")

	Initialize()

/datum/controller/structs/Initialize()
	var/list/struct_initializers = typesof(/datum/controller/structs/proc)
	var/expected_len = length(vars) - length(structs_datum_in_built_vars)
	if(length(struct_initializers) != expected_len)
		warning("Unable to detect all struct initialization procs! Expected [expected_len] got [length(struct_initializers)]!")
		if(length(struct_initializers))
			var/list/expected_struct_initializers = vars - structs_datum_in_built_vars
			for(var/initializer in struct_initializers)
				expected_struct_initializers -= replacetext("[initializer]", "generate_struct_", "")
			log_world("Structs with missing initializers: [expected_struct_initializers.Join(", ")]")
	for(var/initializer in struct_initializers)
		var/start_tick = world.time
		call(src, initializer)()
		var/end_tick = world.time
		if(end_tick - start_tick)
			warning("Struct [replacetext("[initializer]", "generate_struct_", "")] slept during initialization!")
