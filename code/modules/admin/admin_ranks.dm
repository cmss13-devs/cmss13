var/list/admin_ranks = list()								//list of all ranks with associated rights

//load our rank - > rights associations
/proc/load_admin_ranks()
	admin_ranks.Cut()

	var/previous_rights = 0

	//load text from file
	var/list/Lines = file2list("config/admin_ranks.txt")

	//process each line separately
	for(var/line in Lines)
		if(!length(line))				continue
		if(copytext(line,1,2) == "#")	continue

		var/list/List = splittext(line,"+")
		if(!List.len)					continue

		var/rank = ckeyEx(List[1])
		switch(rank)
			if(null,"")		continue
			if("Removed")	continue				//Reserved

		var/rights = 0
		for(var/i=2, i<=List.len, i++)
			switch(ckey(List[i]))
				if("@","prev")					rights |= previous_rights
				if("buildmode","build")			rights |= R_BUILDMODE
				if("admin")						rights |= R_ADMIN
				if("ban")						rights |= R_BAN
				if("server")					rights |= R_SERVER
				if("debug")						rights |= R_DEBUG
				if("permissions","rights")		rights |= R_PERMISSIONS
				if("possess")					rights |= R_POSSESS
				if("stealth")					rights |= R_STEALTH
				if("rejuv","rejuvinate")		rights |= R_REJUVINATE
				if("color")						rights |= R_COLOR
				if("varedit")					rights |= R_VAREDIT
				if("event")						rights |= R_EVENT
				if("everything","host","all")	rights |= (R_HOST|R_BUILDMODE|R_ADMIN|R_BAN|R_SERVER|R_DEBUG|R_PERMISSIONS|R_POSSESS|R_STEALTH|R_REJUVINATE|R_COLOR|R_VAREDIT|R_EVENT|R_SOUNDS|R_NOLOCK|R_SPAWN|R_MOD|R_MENTOR)
				if("sound","sounds")			rights |= R_SOUNDS
				if("nolock")					rights |= R_NOLOCK
				if("spawn","create")			rights |= R_SPAWN
				if("mod")						rights |= R_MOD
				if("mentor")					rights |= R_MENTOR
				if("profiler")					rights |= R_PROFILER

		admin_ranks[rank] = rights
		previous_rights = rights

	#ifdef TESTING
	var/msg = "Permission Sets Built:\n"
	for(var/rank in admin_ranks)
		msg += "\t[rank] - [admin_ranks[rank]]\n"
	testing(msg)
	#endif

/proc/load_admins()
	//clear the datums references
	admin_datums.Cut()
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
	for(var/ckey in admin_datums)
		var/rank
		var/datum/admins/D = admin_datums[ckey]
		if(D)	rank = D.rank
		msg += "\t[ckey] - [rank]\n"
	testing(msg)
	#endif

/proc/process_rank_file(var/line, var/mentor = FALSE)
	var/list/MentorRanks = file2list("config/mentor_ranks.txt")
	if(!length(line))				return
	if(copytext(line,1,2) == "#")	return

	//Split the line at every "-"
	var/list/List = splittext(line, "-")
	if(!List.len)					return

	//ckey is before the first "-"
	var/ckey = ckey(List[1])
	if(!ckey)						return

	//rank follows the first "-"
	var/rank = ""
	if(List.len >= 2)
		rank = ckeyEx(List[2])

	if(mentor)
		if(!(LAZYISIN(MentorRanks, rank)))
			log_admin("ADMIN LOADER: WARNING: Mentors.txt attempted to override staff ranks!")
			log_admin("ADMIN LOADER: Override attempt: (Ckey/[ckey]) (Rank/[rank])")
			return

	//load permissions associated with this rank
	var/rights = admin_ranks[rank]

	//create the admin datum and store it for later use
	var/datum/admins/D = new /datum/admins(rank, rights, ckey)

	//find the client for a ckey if they are connected and associate them with the new admin datum
	D.associate(GLOB.directory[ckey])

/*
#ifdef TESTING
/client/verb/changerank(newrank in admin_ranks)
	if(holder)
		holder.rank = newrank
		holder.rights = admin_ranks[newrank]
	else
		holder = new /datum/admins(newrank,admin_ranks[newrank],ckey)
	remove_admin_verbs()
	holder.associate(src)

/client/verb/changerights(newrights as num)
	if(holder)
		holder.rights = newrights
	else
		holder = new /datum/admins("testing",newrights,ckey)
	remove_admin_verbs()
	holder.associate(src)

#endif
*/
