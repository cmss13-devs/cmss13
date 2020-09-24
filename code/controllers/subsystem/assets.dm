SUBSYSTEM_DEF(assets)
	name = "Assets"
	init_order = SS_INIT_ASSETS
	flags = SS_NO_FIRE

	var/list/cache = list()
	var/list/preload = list()
	var/datum/asset_transport/transport = new()

/datum/subsystem/assets/Initialize()
	for(var/type in typesof(/datum/asset))
		var/datum/asset/A = type
		if(type != initial(A._abstract))
			get_asset_datum(type)

	transport.Initialize(cache)

	return ..()
