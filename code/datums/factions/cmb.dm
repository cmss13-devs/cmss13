/datum/faction/cmb
	name = "Colonial Marshal Bureau"
	faction_tag = FACTION_MARSHAL
	base_icon_file = 'icons/mob/hud/factions/cmb.dmi'

/datum/faction/cmb/modify_hud_holder_from_data(image/holder, location, job_rank, paygrade, assignment, rank_fallback, rank_override, datum/squad/squad)
	var/hud_icon_state = null
	var/anchorpoint_marine = FALSE
	switch(job_rank)
		if(JOB_CMB)
			hud_icon_state = "dep"
		if(JOB_CMB_ENG)
			hud_icon_state = "brch"
		if(JOB_CMB_ICC)
			hud_icon_state = "icc"
		if(JOB_CMB_MED)
			hud_icon_state = "medt"
		if(JOB_CMB_RSYN)
			hud_icon_state = "rsyn"
		if(JOB_CMB_OBS)
			hud_icon_state = "obs"
		if(JOB_CMB_RIOT)
			hud_icon_state = "rco"
		if(JOB_CMB_SYN)
			hud_icon_state = "syn"
		if(JOB_CMB_TL)
			hud_icon_state = "mar"
		if(JOB_CMB_SWAT)
			hud_icon_state = "spec"
		//Anchorpoint Marines
		if(JOB_SQUAD_MARINE)
			hud_icon_state = "grunt"
			anchorpoint_marine = TRUE
		if(JOB_SQUAD_ENGI)
			hud_icon_state = "engi"
			anchorpoint_marine = TRUE
		if(JOB_SQUAD_TEAM_LEADER)
			hud_icon_state = "tl"
			anchorpoint_marine = TRUE
		if(JOB_SQUAD_MEDIC)
			hud_icon_state = "med"
			anchorpoint_marine = TRUE
		if(JOB_SQUAD_SMARTGUN)
			hud_icon_state = "gun"
			anchorpoint_marine = TRUE

	if(anchorpoint_marine)
		var/image/background = image('icons/mob/hud/factions/marine.dmi', location, "hudsquad")
		background.color = "#194877"
		holder.overlays += background
		holder.overlays += image('icons/mob/hud/factions/marine.dmi', location, "hudsquad_[hud_icon_state]")
		return

	if(hud_icon_state)
		holder.overlays += image(base_icon_file, location, "cmb_[hud_icon_state]")
