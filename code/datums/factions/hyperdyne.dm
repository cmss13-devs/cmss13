/datum/faction/hyperdyne
	name = "Hyperdyne Corporation"
	faction_tag = FACTION_HYPERDYNE
	base_icon_file = 'icons/mob/hud/factions/hyperdyne.dmi'

/datum/faction/hyperdyne/modify_hud_holder_from_data(image/holder, location, job_rank, paygrade, assignment, rank_fallback, rank_override, datum/squad/squad)
	var/hud_icon_state = null
	switch(job_rank)
		if(JOB_HC_SEC)
			hud_icon_state = "security"
		if(JOB_HC_SEC_SYNTH)
			hud_icon_state = "synth"
		if(JOB_HC_TRAINEE)
			hud_icon_state = "trainee"
		if(JOB_HC_JUNIOR_EXECUTIVE)
			hud_icon_state = "junior_exec"
		if(JOB_HC_CORPORATE_LIAISON)
			hud_icon_state = "liaison"
		if(JOB_HC_EXECUTIVE)
			hud_icon_state = "exec"
		if(JOB_HC_SENIOR_EXECUTIVE)
			hud_icon_state = "senior_exec"
		if(JOB_HC_EXECUTIVE_SPECIALIST, JOB_HC_LEGAL_SPECIALIST)
			hud_icon_state = "exec_spec"
		if(JOB_HC_EXECUTIVE_SUPERVISOR, JOB_HC_LEGAL_SUPERVISOR)
			hud_icon_state = "exec_super"
		if(JOB_HC_ASSISTANT_MANAGER)
			hud_icon_state = "ass_man"
		if(JOB_HC_DIVISION_MANAGER)
			hud_icon_state = "div_man"
		if(JOB_HC_CHIEF_EXECUTIVE)
			hud_icon_state = "chief_man"
		if(JOB_HC_DEPUTY_DIRECTOR)
			hud_icon_state = "dep_director"
		if(JOB_HC_DIRECTOR)
			hud_icon_state = "director"

	if(hud_icon_state)
		holder.overlays += image(base_icon_file, location, "hc_[hud_icon_state]")
