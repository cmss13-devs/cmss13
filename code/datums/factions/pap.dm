/datum/faction/pap
	name = "People's Armed Police"
	faction_tag = FACTION_PAP
	base_icon_file = 'icons/mob/hud/factions/upp.dmi'

/datum/faction/pap/modify_hud_holder_from_data(image/holder, location, job_rank, paygrade, assignment, rank_fallback, rank_override, datum/squad/squad)
	var/hud_icon_state = null
	switch(job_rank)
		if(JOB_PAP_MILITSIONER)
			hud_icon_state = "silver"
		if(JOB_PAP_STARSHIY_MILITSIONER)
			hud_icon_state = "silver"
		if(JOB_PAP_STARSHINA)
			hud_icon_state = "silver"
		if(JOB_PAP_LEYTENANT)
			hud_icon_state = "gold"
		if(JOB_PAP_KAPITAN)
			hud_icon_state = "gold"
		if(JOB_PAP_MAYOR)
			hud_icon_state = "gold"
		if(JOB_PAP_POLITKOMISSAR)
			hud_icon_state = "gold"
		if(JOB_PAP_POLKOVNIK)
			hud_icon_state = "gold"

	if(hud_icon_state)
		holder.overlays += image(base_icon_file, location, "pap_[hud_icon_state]")
