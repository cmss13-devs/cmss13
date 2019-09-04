/datum/random_fact/kills/announce()
    for(var/P in player_entities)
        var/datum/entity/player_entity/E = player_entities[P]
        if(!E.death_stats.len)
            continue
        var/datum/entity/death_stats/death = pick(E.death_stats)
        if(!(death.total_kills > 1))
            continue
        message = "<b>[death.mob_name]</b> earned <b>[death.total_kills] kills</b> before dying"
        if(death.cause_name)
            message += " to <b>[death.cause_name]</b>"
        message += ". Good job!"
        break
    . = ..()
