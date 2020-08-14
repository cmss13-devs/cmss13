/proc/create_new_clan(var/clanname)
    var/datum/entity/clan/C = DB_ENTITY(/datum/entity/clan)
    C.name = clanname
    C.description = "This is a clan."
    C.honor = 0
    C.save()