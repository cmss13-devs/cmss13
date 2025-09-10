/datum/modpack/roundstart_spawns
	name = "Roundstart Spawns Modpack"
	desc = "Спавны объектов до начала раунда."
	author = "phantomru"

// Спавн объектов после загрузки карт (Грауд и Аламо)
/datum/controller/subsystem/mapping/Initialize(timeofday)
	. = ..()
	if(. != SS_INIT_SUCCESS)
		return .

	// Создаем и храним все спавнеры
	for(var/spawn_type in subtypesof(/datum/roundstart_spawn))
		var/datum/roundstart_spawn/S = new spawn_type()
		S.process_spawns()
		// QDEL_NULL(S)

	return SS_INIT_SUCCESS
