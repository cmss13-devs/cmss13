/client/verb/who()//likely don't touch any... this is easy can die. (:troll_fale:)
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
							FACTION_WY_DEATHSQUAD = 0,
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

	var/players = length(GLOB.clients)

	var/dat = "<html><body><B>Current Players:</B><BR>"
	var/list/Lines = list()
	if(admin_holder && ((R_ADMIN & admin_holder.rights) || (R_MOD & admin_holder.rights)))
		for(var/client/C in GLOB.clients)
			var/entry = "[C.key]"
			if(C.mob) //Juuuust in case
				if(istype(C.mob, /mob/new_player))
					entry += " - In Lobby"
					counted_humanoids["Lobby"]++
				else
					entry += " - Playing as [C.mob.real_name]"

				if(isobserver(C.mob))
					counted_humanoids["Observers"]++
					if(C.admin_holder?.rights & R_MOD)
						counted_humanoids["Admin observers"]++
						counted_humanoids["Observers"]--
					var/mob/dead/observer/O = C.mob
					if(O.started_as_observer)
						entry += " - <font color='#808080'>Observing</font>"
					else
						entry += " - <font color='#A000D0'><b>DEAD</B></font>"
				else
					switch(C.mob.stat)
						if(UNCONSCIOUS)
							entry += " - <font color='#B0B0B0'><b>Unconscious</B></font>"
						if(DEAD)
							entry += " - <font color='#A000D0'><b>DEAD</B></font>"

					if(C.mob && C.mob.stat != DEAD)
						if(ishuman(C.mob))
							if(C.mob.faction == FACTION_ZOMBIE)
								counted_humanoids[FACTION_ZOMBIE]++
								entry += " - <font color='#2DACB1'><B>Zombie</B></font>"
							else if(C.mob.faction == FACTION_YAUTJA)
								counted_humanoids[FACTION_YAUTJA]++
								entry += " - <font color='#7ABA19'><B>Predator</B></font>"
								if(C.mob.status_flags & XENO_HOST)
									counted_humanoids["Infected preds"]++
							else
								counted_humanoids["Humans"]++
								if(C.mob.status_flags & XENO_HOST)
									counted_humanoids["Infected humans"]++
								if(C.mob.faction == FACTION_MARINE)
									counted_humanoids[FACTION_MARINE]++
									if(C.mob.job in (ROLES_MARINES))
										counted_humanoids["USCM Marines"]++
								else
									counted_humanoids[C.mob.faction]++
						else if(isxeno(C.mob))
							var/mob/living/carbon/xenomorph/X = C.mob
							counted_xenos[X.hivenumber]++
							if(X.faction == FACTION_PREDALIEN)
								counted_xenos[FACTION_PREDALIEN]++
							entry += " - <B><font color='red'>Xenomorph</font></B>"
				entry += " (<A HREF='?_src_=admin_holder;[HrefToken(forceGlobal = TRUE)];adminplayeropts=\ref[C.mob]'>?</A>)"
				Lines += entry

		for(var/line in sortList(Lines))
			dat += "[line]<BR>"
		dat += "<B>Total Players: [players]</B>"
		dat += "<BR><B style='color:#777'>In Lobby: [counted_humanoids["Lobby"]]</B>"
		dat += "<BR><B style='color:#777'>Observers: [counted_humanoids["Observers"]] players and [counted_humanoids["Admin observers"]] staff members</B>"
		dat += "<BR><B style='color:#2C7EFF'>Humans: [counted_humanoids["Humans"]]</B> <B style='color:#F00'>(Infected: [counted_humanoids["Infected humans"]])</B>"
		if(counted_humanoids[FACTION_MARINE])
			dat += "<BR><B style='color:#2C7EFF'>USCM personnel: [counted_humanoids[FACTION_MARINE]]</B> <B style='color:#688944'>(Marines: [counted_humanoids["USCM Marines"]])</B>"
		if(counted_humanoids[FACTION_YAUTJA])
			dat += "<BR><B style='color:#7ABA19'>Predators: [counted_humanoids[FACTION_YAUTJA]]</B> [counted_humanoids["Infected preds"] ? "<b style='color:#F00'>(Infected: [counted_humanoids["Infected preds"]])</b>" : ""]"
		if(counted_humanoids[FACTION_ZOMBIE])
			dat += "<BR><B style='color:#2DACB1'>Zombies: [counted_humanoids[FACTION_ZOMBIE]]</B>"

		var/show_fact = TRUE
		for(var/i in 10 to LAZYLEN(counted_humanoids) - 2)
			if(counted_humanoids[counted_humanoids[i]])
				if(show_fact)
					dat += "<br><BR>Other factions:"
					show_fact = FALSE
				dat += "<BR><B style='color:#2C7EFF'>[counted_humanoids[i]]: [counted_humanoids[counted_humanoids[i]]]</B>"
		if(counted_humanoids[FACTION_NEUTRAL])
			dat += "<BR><B style='color:#688944'>[FACTION_NEUTRAL] Humans: [counted_humanoids[FACTION_NEUTRAL]]</B>"

		show_fact = TRUE
		var/datum/hive_status/hive
		for(var/hivenumber in counted_xenos)
			// Print predalien counts last
			if(hivenumber == FACTION_PREDALIEN)
				continue
			if(show_fact)
				dat += "<BR><BR>Xenomorphs:"
				show_fact = FALSE
			hive = GLOB.hive_datum[hivenumber]
			if(hive)
				dat += "<BR><B style='color:[hive.color ? hive.color : "#8200FF"]'>[hive.name]: [counted_xenos[hivenumber]]</B> <B style='color:#4D0096'>(Queen: [hive.living_xeno_queen ? "Alive" : "Dead"])</B>"
			else
				dat += "<BR><B style='color:#F00'>Error: no hive datum detected for [hivenumber].</B>"
			hive = null
		if(counted_xenos[FACTION_PREDALIEN])
			dat += "<BR><B style='color:#7ABA19'>Predaliens: [counted_xenos[FACTION_PREDALIEN]]</B>"

	else
		for(var/client/C in GLOB.clients)
			if(C.admin_holder && C.admin_holder.fakekey)
				continue

			Lines += C.key
		for(var/line in sortList(Lines))
			dat += "[line]<br>"
		dat += "<b>Total Players: [players]</b><br>"

	dat += "</body></html>"
	show_browser(usr, dat, "Who", "who", "size=600x800")


/client/verb/staffwho()
	set name = "Staffwho"
	set category = "Admin"

	var/dat = ""
	var/list/mappings
	if(CONFIG_GET(flag/show_manager))
		LAZYSET(mappings, "<B style='color:purple'>Management</B>", R_HOST)
	if(CONFIG_GET(flag/show_devs))
		LAZYSET(mappings, "<B style='color:blue'>Maintainers</B>", R_PROFILER)
	LAZYSET(mappings, "<B style='color:red'>Admins</B>", R_ADMIN)
	if(CONFIG_GET(flag/show_mods))
		LAZYSET(mappings, "<B style='color:orange'>Moderators</B>", R_MOD)
	if(CONFIG_GET(flag/show_mentors))
		LAZYSET(mappings, "<B style='color:green'>Mentors</B>", R_MENTOR)

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

	for(var/category in listings)
		dat += "<BR><B>Current [category] ([length(listings[category])]):<BR></B>\n"
		for(var/client/entry in listings[category])
			dat += "\t[entry.key] is a [entry.admin_holder.rank]"
			if(entry.admin_holder.extra_titles?.len)
				for(var/srank in entry.admin_holder.extra_titles)
					dat += " & [srank]"
			if(CLIENT_IS_STAFF(src))
				if(entry.admin_holder?.fakekey)
					dat += " <i>(HIDDEN)</i>"
				if(istype(entry.mob, /mob/dead/observer))
					dat += "<B> - <font color='#808080'>Observing</font></B>"
				else if(istype(entry.mob, /mob/new_player))
					dat += "<B> - <font color='#FFFFFF'>Lobby</font></B>"
				else
					dat += "<B> - <font color='#688944'>Playing</font></B>"
				if(entry.is_afk())
					dat += "<B> <font color='#A040D0'> (AFK)</font></B>"
			dat += "<BR>"
	dat += "</body></html>"
	show_browser(usr, dat, "Staffwho", "staffwho", "size=600x800")
