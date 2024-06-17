/datum/tech/xeno
	name = "Xeno Tech"

	var/hivenumber = XENO_HIVE_NORMAL
	var/datum/hive_status/hive

/datum/tech/xeno/on_tree_insertion(datum/techtree/xenomorph/tree)
	. = ..()
	hivenumber = tree.hivenumber
	hive = GLOB.hive_datum[hivenumber]

/datum/tech/xeno/on_unlock()
	. = ..()
	xeno_message("The hive has unlocked the '[name]' evolution.", 3, hivenumber)
	for(var/m in hive.totalXenos)
		var/mob/M = m
		playsound_client(M.client, "queen")
