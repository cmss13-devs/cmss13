GLOBAL_LIST_EMPTY(admin_ranks) //list of all ranks with associated rights

//load our rank - > rights associations
/proc/load_admin_ranks()
	GLOB.admin_ranks.Cut()

	var/previous_rights = 0

	//load text from file
	var/list/Lines = file2list("config/admin_ranks.txt")

	//process each line separately
	for(var/line in Lines)
		if(!length(line)) continue
		if(copytext(line,1,2) == "#") continue

		var/list/List = splittext(line,"+")
		if(!length(List)) continue

		var/rank = ckeyEx(List[1])
		switch(rank)
			if(null,"") continue
			if("Removed") continue //Reserved

		var/rights = 0
		for(var/i=2, i<=length(List), i++)
			switch(ckey(List[i]))
				if("@","prev") rights |= previous_rights
				if("buildmode","build") rights |= R_BUILDMODE
				if("admin") rights |= R_ADMIN
				if("ban") rights |= R_BAN
				if("server") rights |= R_SERVER
				if("debug") rights |= R_DEBUG
				if("permissions","rights") rights |= R_PERMISSIONS
				if("possess") rights |= R_POSSESS
				if("stealth") rights |= R_STEALTH
				if("color") rights |= R_COLOR
				if("varedit") rights |= R_VAREDIT
				if("event") rights |= R_EVENT
				if("sound","sounds") rights |= R_SOUNDS
				if("nolock") rights |= R_NOLOCK
				if("spawn","create") rights |= R_SPAWN
				if("mod") rights |= R_MOD
				if("mentor") rights |= R_MENTOR
				if("profiler") rights |= R_PROFILER
				if("host") rights |= RL_HOST
				if("everything") rights |= RL_EVERYTHING

		GLOB.admin_ranks[rank] = rights
		previous_rights = rights

	#ifdef TESTING
	var/msg = "Permission Sets Built:\n"
	for(var/rank in GLOB.admin_ranks)
		msg += "\t[rank] - [GLOB.admin_ranks[rank]]\n"
	testing(msg)
	#endif


/proc/load_admins()
	//clear the datums references
	GLOB.admin_datums.Cut()
	for(var/client/C in GLOB.admins)
		C.remove_admin_verbs()
		C.admin_holder = null
	GLOB.admins.Cut()

	load_admin_ranks()

		//load text from file
	var/list/ALines = file2list("config/admins.txt")
	var/list/MLines = file2list("config/mentors.txt")

	//process each line separately
	for(var/line in MLines)
		process_rank_file(line, TRUE)
	for(var/line in ALines)
		process_rank_file(line)

	#ifdef TESTING
	var/msg = "Admins Built:\n"
	for(var/ckey in GLOB.admin_datums)
		var/rank
		var/datum/entity/admins/D = GLOB.admin_datums[ckey]
		if(D) rank = D.rank
		msg += "\t[ckey] - [rank]\n"
	testing(msg)
	#endif
