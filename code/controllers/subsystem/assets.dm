var/datum/subsystem/assets/SSassets

/datum/subsystem/assets
	name = "Assets"
	init_order = SS_INIT_ASSETS
	flags = SS_NO_FIRE

	var/list/cache = list()
	var/list/preload = list()


/datum/subsystem/assets/New()
	NEW_SS_GLOBAL(SSassets)

/datum/subsystem/assets/Initialize()
	for(var/type in typesof(/datum/asset))
		var/datum/asset/A = type
		if(type != initial(A._abstract))
			get_asset_datum(type)

	preload = cache.Copy() //don't preload assets generated during the round

	for(var/client/C in clients)
		add_timer(CALLBACK(GLOBAL_PROC, .proc/get_files_slot, C, preload, FALSE), 10)
	return ..()
