/proc/create_new_clan(clanname)
	var/datum/entity/clan/C = DB_ENTITY(/datum/entity/clan)
	C.name = clanname
	C.description = "This is a clan."
	C.honor = 0
	C.save()
