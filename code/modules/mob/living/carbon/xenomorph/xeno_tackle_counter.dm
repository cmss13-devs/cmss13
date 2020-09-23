/datum/tackle_counter
    var/tackle_count = 0
    var/min_tackles
    var/max_tackles
    var/tackle_chance
    var/tackle_reset_id

/datum/tackle_counter/New(var/min, var/max, var/chance)
    min_tackles = min
    max_tackles = max
    tackle_chance = chance

/datum/tackle_counter/Destroy()
    ..()
    return GC_HINT_RECYCLE

/datum/tackle_counter/proc/attempt_tackle(var/tackle_bonus = 0)
    tackle_count++

    if (tackle_count >= max_tackles)
        return TRUE
    else if (tackle_count < min_tackles)
        return FALSE
    else if (prob(tackle_chance + tackle_bonus))
        return TRUE
    
    return FALSE