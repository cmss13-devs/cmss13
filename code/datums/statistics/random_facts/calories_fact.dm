/datum/random_fact/calories/announce()
    for(var/P in player_entities)
        var/datum/entity/player_entity/E = player_entities[P]
        if(!E.death_stats.len)
            continue
        var/datum/entity/death_stats/death = pick(E.death_stats)
        message = "<b>[death.mob_name]</b> burned <b>[death.steps_walked / 10] calories</b> before dying"
        if(death.cause_name)
            message += " to <b>[death.cause_name]</b>"
        message += ". Good job!"
        break
    . = ..()
