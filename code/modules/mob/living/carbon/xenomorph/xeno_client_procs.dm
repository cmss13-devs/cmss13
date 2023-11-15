/client/var/cached_xeno_playtime

/// playtime for all castes
/client/proc/get_total_xeno_playtime(skip_cache = FALSE)
	if(cached_xeno_playtime && !skip_cache)
		return cached_xeno_playtime

	var/total_xeno_playtime = 0

	for(var/caste in RoleAuthority.castes_by_name)
		total_xeno_playtime += get_job_playtime(src, caste)

	total_xeno_playtime += get_job_playtime(src, JOB_XENOMORPH)

	if(player_entity)
		var/past_xeno_playtime = player_entity.get_playtime(STATISTIC_XENO)
		if(past_xeno_playtime)
			total_xeno_playtime += past_xeno_playtime


	cached_xeno_playtime = total_xeno_playtime

	return total_xeno_playtime

/// playtime for drone and drone evolution castes
/client/proc/get_total_drone_playtime()
	var/total_drone_playtime = 0

	var/list/drone_evo_castes = list(XENO_CASTE_DRONE, XENO_CASTE_CARRIER, XENO_CASTE_BURROWER, XENO_CASTE_HIVELORD, XENO_CASTE_QUEEN)

	for(var/caste in RoleAuthority.castes_by_name)
		if(!(caste in drone_evo_castes))
			continue
		total_drone_playtime += get_job_playtime(src, caste)

	return total_drone_playtime

/// playtime for t3 castes and queen
/client/proc/get_total_t3_playtime()
	var/total_t3_playtime = 0
	var/datum/caste_datum/caste
	for(var/caste_name in RoleAuthority.castes_by_name)
		caste = RoleAuthority.castes_by_name[caste_name]
		if(caste.tier < 3)
			continue
		total_t3_playtime += get_job_playtime(src, caste_name)

	return total_t3_playtime
