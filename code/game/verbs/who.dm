
/client/verb/who()
	set name = "Who"
	set category = "OOC"

	var/list/counted_humanoids = list(
							"Observers" = 0,
							"Admin observers" = 0,
							"Humans" = 0,
							"Infected humans" = 0,
							FACTION_MARINE = 0,
							"USCM Marines" = 0,
							"Lobby" = 0,

							FACTION_YAUTJA = 0,
							"Infected preds" = 0,

							FACTION_PMC = 0,
							FACTION_CLF = 0,
							FACTION_UPP = 0,
							FACTION_FREELANCER = 0,
							FACTION_SURVIVOR = 0,
							FACTION_DEATHSQUAD = 0,
							FACTION_COLONIST = 0,
							FACTION_MERCENARY = 0,
							FACTION_DUTCH = 0,
							FACTION_HEFA = 0,
							FACTION_GLADIATOR = 0,
							FACTION_PIRATE = 0,
							FACTION_PIZZA = 0,
							FACTION_SOUTO = 0,

							FACTION_NEUTRAL = 0,

							FACTION_ZOMBIE = 0
							)

	var/list/counted_xenos = list()

	var/msg = "<b>Current Players:</b>\n"
	var/list/Lines = list()
	if(admin_holder && ((R_ADMIN & admin_holder.rights) || (R_MOD & admin_holder.rights)))
		for(var/client/C in GLOB.clients)
			var/entry = "\t[C.key]"
			if(C.mob)	//Juuuust in case
				if(istype(C.mob, /mob/new_player))
					entry += " - In Lobby"
					counted_humanoids["Lobby"]++
				else
					entry += " - Playing as [C.mob.real_name]"

				if(isobserver(C.mob))
					counted_humanoids["Observers"]++
					if(C.admin_holder)
						counted_humanoids["Admin observers"]++
						counted_humanoids["Observers"]--
					var/mob/dead/observer/O = C.mob
					if(O.started_as_observer)
						entry += " - <font color='#777'>Observing</font>"
					else
						entry += " - <font color='#000'><b>DEAD</b></font>"
				else
					switch(C.mob.stat)
						if(UNCONSCIOUS)
							entry += " - <font color='#404040'><b>Unconscious</b></font>"
						if(DEAD)
							entry += " - <font color='#000'><b>DEAD</b></font>"

					if(C.mob && C.mob.stat != DEAD)
						if(ishuman(C.mob))
							if(C.mob.faction == FACTION_ZOMBIE)
								counted_humanoids[FACTION_ZOMBIE]++
								continue
							if(C.mob.faction == FACTION_YAUTJA)
								counted_humanoids[FACTION_YAUTJA]++
								if(C.mob.status_flags & XENO_HOST)
									counted_humanoids["Infected preds"]++
								continue
							counted_humanoids["Humans"]++
							if(C.mob.status_flags & XENO_HOST)
								counted_humanoids["Infected humans"]++
							if(C.mob.faction == FACTION_MARINE)
								counted_humanoids[FACTION_MARINE]++
								if(C.mob.job in (ROLES_MARINES))
									counted_humanoids["USCM Marines"]++
							else
								counted_humanoids[C.mob.faction]++
						if(isXeno(C.mob))
							var/mob/living/carbon/Xenomorph/X = C.mob
							counted_xenos[X.hivenumber]++
							if(X.faction == FACTION_PREDALIEN)
								counted_xenos[FACTION_PREDALIEN]++
							entry += " - <b><font color='red'>Xenomorph</font></b>"

				entry += " (<A HREF='?_src_=admin_holder;adminmoreinfo;extra=\ref[C.mob]'>?</A>)"
				Lines += entry

		for(var/line in sortList(Lines))
			msg += "[line]\n"
		msg += "<b>Total Players: [length(Lines)]</b>"
		msg += "<br><b style='color:#777'>In Lobby: [counted_humanoids["Lobby"]]</b>"
		msg += "<br><b style='color:#777'>Observers: [counted_humanoids["Observers"]] players and [counted_humanoids["Admin observers"]] staff members</b>"
		msg += "<br><b style='color:#2C7EFF'>Humans: [counted_humanoids["Humans"]]</b> <b style='color:#F00'>(Infected: [counted_humanoids["Infected humans"]])</b>"
		if(counted_humanoids[FACTION_MARINE])
			msg += "<br><b style='color:#2C7EFF'>USCM personnel: [counted_humanoids[FACTION_MARINE]]</b> <b style='color:#688944'>(Squad Marines: [counted_humanoids["USCM Marines"]])</b>"
		if(counted_humanoids[FACTION_YAUTJA])
			msg += "<br><b style='color:#7ABA19'>Predators: [counted_humanoids[FACTION_YAUTJA]]</b> [counted_humanoids["Infected preds"] ? "<b style='color:#F00'>(Infected: [counted_humanoids["Infected preds"]])</b>" : ""]"

		var/show_fact = TRUE
		for(var/i in 10 to LAZYLEN(counted_humanoids) - 2)
			if(counted_humanoids[counted_humanoids[i]])
				if(show_fact)
					msg += "<br><br>Other factions:"
					show_fact = FALSE
				msg += "<br><b style='color:#2C7EFF'>[counted_humanoids[i]]: [counted_humanoids[counted_humanoids[i]]]</b>"
		if(counted_humanoids[FACTION_NEUTRAL])
			msg += "<br><b style='color:#777'>[FACTION_NEUTRAL] humans: [counted_humanoids[FACTION_NEUTRAL]]</b>"

		show_fact = TRUE
		var/datum/hive_status/hive
		for(var/hivenumber in counted_xenos)
			// Print predalien counts last
			if(hivenumber == FACTION_PREDALIEN)
				continue
			if(show_fact)
				msg += "<br><br>Xenomorphs:"
				show_fact = FALSE
			hive = GLOB.hive_datum[hivenumber]
			if(hive)
				msg += "<br><b style='color:[hive.color ? hive.color : "#8200FF"]'>[hive.name]: [counted_xenos[hivenumber]]</b> <b style='color:#4D0096'>(Queen: [hive.living_xeno_queen ? "Alive" : "Dead"])</b>"
			else
				msg += "<br><b style='color:#F00'>Error: no hive datum detected for [hivenumber].</b>"
			hive = null
		if(counted_xenos[FACTION_PREDALIEN])
			msg += "<br><b style='color:#7ABA19'>Predaliens: [counted_xenos[FACTION_PREDALIEN]]</b>"

	else
		for(var/client/C in GLOB.clients)
			if(C.admin_holder && C.admin_holder.fakekey)
				continue

			Lines += C.key
		for(var/line in sortList(Lines))
			msg += "[line]\n"
		msg += "<b>Total Players: [length(Lines)]</b>"

	to_chat(src, msg)

/client/verb/staffwho()
	set name = "Staffwho"
	set category = "OOC"

	var/list/mappings
	LAZYSET(mappings, "Admins", R_ADMIN)
	if(CONFIG_GET(flag/show_mods))
		LAZYSET(mappings, "Moderators", R_MOD)
	if(CONFIG_GET(flag/show_mentors))
		LAZYSET(mappings, "Mentors", R_MENTOR)

	var/list/listings
	for(var/category in mappings)
		LAZYSET(listings, category, list())

	for(var/client/C in GLOB.admins)
		if(C.admin_holder?.fakekey && !CLIENT_IS_STAFF(src))
			continue
		for(var/category in mappings)
			if(CLIENT_HAS_RIGHTS(C, mappings[category]))
				LAZYADD(listings[category], C)
				break
	
	var/output = ""
	for(var/category in listings)
		output += "\n<b>Current [category] ([length(listings[category])]):</b>\n"
		for(var/client/entry in listings[category])
			output += "\t[entry.key] is a [entry.admin_holder.rank]"
			if(CLIENT_IS_STAFF(src))
				if(entry.admin_holder?.fakekey)
					output += " <i>(HIDDEN)</i>"
				if(istype(entry.mob, /mob/dead/observer))
					output += " - Observing"
				else if(istype(entry.mob, /mob/new_player))
					output += " - Lobby"
				else
					output += " - Playing"
				if(entry.is_afk())
					output += " (AFK)"
			output += "\n"
	to_chat(src, output)