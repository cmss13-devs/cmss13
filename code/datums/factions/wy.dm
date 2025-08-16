/datum/faction/wy
	name = "Weyland-Yutani Corporation"
	faction_tag = FACTION_WY

/datum/faction/wy/modify_hud_holder(image/holder, mob/living/carbon/human/user)
	var/hud_icon_state
	var/obj/item/card/id/id_card = user.get_idcard()
	var/role
	if(user.mind)
		role = user.job
	else if(id_card)
		role = id_card.rank
	switch(role)
		if(JOB_CORPORATE_BODYGUARD)
			hud_icon_state = "liaison_guard"
		if(JOB_WY_GOON)
			hud_icon_state = "goon_normal"
		if(JOB_WY_GOON_LEAD)
			hud_icon_state = "goon_leader"
		if(JOB_WY_GOON_SYNTH)
			hud_icon_state = "goon_synth"
		if(JOB_WY_RESEARCHER)
			hud_icon_state = "researcher"
		if(JOB_WY_RESEARCH_LEAD)
			hud_icon_state = "research_lead"
		if(JOB_WY_GOON_TECH)
			hud_icon_state = "goon_engi"
		if(JOB_WY_GOON_MEDIC)
			hud_icon_state = "goon_medic"
		if(JOB_WY_SEC)
			hud_icon_state = "sec"
		if(JOB_WY_SEC_SYNTH)
			hud_icon_state = "synth"
		if(JOB_TRAINEE)
			hud_icon_state = "trainee"
		if(JOB_JUNIOR_EXECUTIVE)
			hud_icon_state = "junior_exec"
		if(JOB_CORPORATE_LIAISON)
			hud_icon_state = "liaison"
		if(JOB_EXECUTIVE)
			hud_icon_state = "liaison"
		if(JOB_SENIOR_EXECUTIVE)
			hud_icon_state = "senior_exec"
		if(JOB_EXECUTIVE_SPECIALIST, JOB_LEGAL_SPECIALIST)
			hud_icon_state = "exec_spec"
		if(JOB_EXECUTIVE_SUPERVISOR, JOB_LEGAL_SUPERVISOR)
			hud_icon_state = "exec_super"
		if(JOB_ASSISTANT_MANAGER)
			hud_icon_state = "ass_man"
		if(JOB_DIVISION_MANAGER)
			hud_icon_state = "div_man"
		if(JOB_CHIEF_EXECUTIVE)
			hud_icon_state = "chief_man"
		if(JOB_DEPUTY_DIRECTOR)
			hud_icon_state = "dep_director"
		if(JOB_DIRECTOR)
			hud_icon_state = "director"
	if(hud_icon_state)
		holder.overlays += image('icons/mob/hud/marine_hud.dmi', user, "wy_[hud_icon_state]")
