/datum/faction/conam
	name = "Con-Amalagated Corporation"
	faction_tag = FACTION_CONAM
	base_icon_file = 'icons/mob/hud/factions/conam.dmi'

/datum/faction/conam/modify_hud_holder(image/holder, mob/living/carbon/human/user)
	var/icon/override_icon_file
	var/hud_icon_state
	var/obj/item/card/id/id_card = user.get_idcard()
	var/role
	if(user.mind)
		role = user.job
	else if(id_card)
		role = id_card.rank
	switch(role)
		if(JOB_CA_TRAINEE)
			hud_icon_state = "trainee"
		if(JOB_CA_JUNIOR_EXECUTIVE)
			hud_icon_state = "junior_exec"
		if(JOB_CA_CORPORATE_LIAISON)
			hud_icon_state = "liaison"
		if(JOB_CA_EXECUTIVE)
			hud_icon_state = "liaison"
		if(JOB_CA_SENIOR_EXECUTIVE)
			hud_icon_state = "senior_exec"
		if(JOB_CA_EXECUTIVE_SPECIALIST, JOB_CA_LEGAL_SPECIALIST)
			hud_icon_state = "exec_spec"
		if(JOB_CA_EXECUTIVE_SUPERVISOR, JOB_CA_LEGAL_SUPERVISOR)
			hud_icon_state = "exec_super"
	if(hud_icon_state)
		holder.overlays += image(override_icon_file ? override_icon_file : base_icon_file, user, "hc_[hud_icon_state]")
