/datum/faction/nspa
	name = "Neroid Sector Policing Authority"
	faction_tag = FACTION_NSPA
	base_icon_file = 'icons/mob/hud/factions/twe.dmi'

/datum/faction/nspa/modify_hud_holder_from_data(image/holder, location, job_rank, paygrade, assignment, rank_fallback, rank_override, datum/squad/squad)
	var/hud_icon_state = null
	switch(job_rank)
		if(JOB_NSPA_CST)
			hud_icon_state = "con"
		if(JOB_NSPA_SC)
			hud_icon_state = "sc"
		if(JOB_NSPA_SGT)
			hud_icon_state = "sgt"
		if(JOB_NSPA_INSP)
			hud_icon_state = "insp"
		if(JOB_NSPA_CINSP)
			hud_icon_state = "cinsp"
		if(JOB_NSPA_CMD)
			hud_icon_state = "cmd"
		if(JOB_NSPA_DCO)
			hud_icon_state = "dco"
		if(JOB_NSPA_COM)
			hud_icon_state = "com"
		if(JOB_NSPA_SYN)
			hud_icon_state = "syn"

	if(hud_icon_state)
		holder.overlays += image(base_icon_file, location, "nspa_[hud_icon_state]")
