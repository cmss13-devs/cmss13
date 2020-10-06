var/global/list/pred_ships = list()
var/global/list/clan_locations = list()

/proc/load_clan_ship(var/clan_id)
    if("[clan_id]" in pred_ships)
        return

    world.maxz += 1
    var/zlevel = world.maxz
    
    clan_locations += list("[zlevel]" = list())

    var/datum/map_load_metadata/M = maploader.load_map('maps/predship/huntership.dmm', 5, 5, zlevel)

    for(var/atom/A in M.atoms_to_initialise)
        if(isobj(A))
            var/obj/O = A
            O.update_icon()

    pred_ships += list("[clan_id]" = "[zlevel]")

/proc/get_clan_spawnpoints(var/clan_id)
    load_clan_ship(clan_id)

    return clan_locations[pred_ships["[clan_id]"]]

/obj/effect/landmark/clan_spawn
    name = "clan spawn"

/obj/effect/landmark/clan_spawn/New()
    . = ..()
    var/zlevel = src.z

    if("[zlevel]" in clan_locations)
        clan_locations["[zlevel]"] += loc
    
    qdel(src)