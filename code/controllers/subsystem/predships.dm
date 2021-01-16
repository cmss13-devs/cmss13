SUBSYSTEM_DEF(predships)
	name          = "PredShips"
	init_order    = SS_INIT_PREDSHIPS
	flags         = SS_NO_FIRE

	var/datum/map_template/ship_template // Current ship template in use
	var/list/list/managed_z              // Maps initating clan id to list(datum/space_level, list/turf(spawns))
	var/list/turf/spawnpoints            // List of all spawn landmark locations

/datum/controller/subsystem/predships/Initialize(timeofday)
	if(!ship_template)
		ship_template = new /datum/map_template(HUNTERSHIPS_TEMPLATE_PATH, cache = TRUE)
	LAZYINITLIST(managed_z)
	return ..()

/datum/controller/subsystem/predships/proc/init_spawnpoint(obj/effect/landmark/clan_spawn/SP)
	LAZYADD(spawnpoints, get_turf(SP))

/datum/controller/subsystem/predships/proc/get_clan_spawnpoints(clan_id)
	RETURN_TYPE(/list/turf)
	if(clan_id in managed_z)
		return managed_z[clan_id][2]

/datum/controller/subsystem/predships/proc/is_clanship_loaded(clan_id)
	if(clan_id == CLAN_SHIP_ALMAYER) // Actually just means 'go to almayer'... bruh
		var/list/shipz = SSmapping.levels_by_trait(ZTRAIT_MARINE_MAIN_SHIP)
		if(length(shipz))
			return TRUE
	if((clan_id in managed_z) && managed_z[clan_id][2])
		return TRUE
	return FALSE

/datum/controller/subsystem/predships/proc/load_new(initiating_clan_id)
	RETURN_TYPE(/list)
	if(!ship_template || !initiating_clan_id || isnum(initiating_clan_id))
		return NONE
	if(initiating_clan_id == CLAN_SHIP_ALMAYER) // Skychiefs already have a ship
		return NONE
	if(initiating_clan_id in managed_z)
		return managed_z[initiating_clan_id]
	var/datum/space_level/level = ship_template.load_new_z()
	if(level)
		var/new_z = level.z_value
		var/list/turf/new_spawns = list()
		for(var/turf/spawnpoint in spawnpoints)
			if(spawnpoint?.z == new_z)
				new_spawns += spawnpoint
		managed_z[initiating_clan_id] = list(level, new_spawns)
	return managed_z[initiating_clan_id]