/datum/faction/wo
	name = "Whiteout"
	faction_tag = FACTION_WY_DEATHSQUAD
	base_icon_file = 'icons/mob/hud/factions/wy.dmi'

/datum/faction/wo/modify_hud_holder_from_data(image/holder, location, job_rank, paygrade, datum/squad/squad)
	var/hud_icon_state = null
	switch(job_rank)
		if(JOB_DS_SL)
			hud_icon_state = "sl"
		if(JOB_DS_CK)
			hud_icon_state = "med"
		if(JOB_DS_SUP)
			hud_icon_state = "sg"
		if(JOB_DS_CU)
			hud_icon_state = "op"

	if(hud_icon_state)
		holder.overlays += image(base_icon_file, location, "wo_[hud_icon_state]")
