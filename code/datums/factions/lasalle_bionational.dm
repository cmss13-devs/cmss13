/datum/faction/lasalle_bionational
	name = "Lasalle Bionational"
	faction_tag = FACTION_LASALLE_BIONATIONAL
	base_icon_file = 'icons/mob/hud/factions/lasalle_bionational.dmi'

/datum/faction/lasalle_bionational/modify_hud_holder_from_data(image/holder, location, job_rank, paygrade, assignment, rank_fallback, rank_override, datum/squad/squad)
	var/hud_icon_state = null
	switch(job_rank)
		if(JOB_LB_MERC)
			hud_icon_state = "merc"
		if(JOB_LB_MERC_MEDIC)
			hud_icon_state = "medic"
		if(JOB_LB_MERC_ENGI)
			hud_icon_state = "engi"
		if(JOB_LB_MERC_SP)
			hud_icon_state = "spec"
		if(JOB_LB_MERC_TL)
			hud_icon_state = "leader"
		if(JOB_LB_MERC_SYN)
			hud_icon_state = "synth"
		if(JOB_LB_MERC_SG)
			hud_icon_state = "sg"
		if(JOB_LB_MERC_COMMANDER)
			hud_icon_state = "com"
		if(JOB_LB_SEC)
			hud_icon_state = "security"
		if(JOB_LB_SEC_SYNTH)
			hud_icon_state = "synth"
		if(JOB_LB_TRAINEE)
			hud_icon_state = "trainee"
		if(JOB_LB_JUNIOR_EXECUTIVE)
			hud_icon_state = "junior_exec"
		if(JOB_LB_CORPORATE_LIAISON)
			hud_icon_state = "liaison"
		if(JOB_LB_EXECUTIVE)
			hud_icon_state = "exec"
		if(JOB_LB_SENIOR_EXECUTIVE)
			hud_icon_state = "senior_exec"
		if(JOB_LB_EXECUTIVE_SPECIALIST, JOB_LB_LEGAL_SPECIALIST)
			hud_icon_state = "exec_spec"
		if(JOB_LB_EXECUTIVE_SUPERVISOR, JOB_LB_LEGAL_SUPERVISOR)
			hud_icon_state = "exec_super"
		if(JOB_LB_ASSISTANT_MANAGER)
			hud_icon_state = "ass_man"
		if(JOB_LB_DIVISION_MANAGER)
			hud_icon_state = "div_man"
		if(JOB_LB_CHIEF_EXECUTIVE)
			hud_icon_state = "chief_man"
		if(JOB_LB_DEPUTY_DIRECTOR)
			hud_icon_state = "dep_director"
		if(JOB_LB_DIRECTOR)
			hud_icon_state = "director"

	if(hud_icon_state)
		holder.overlays += image(base_icon_file, location, "ls_[hud_icon_state]")
