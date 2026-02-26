/datum/faction/hyperdyne
	name = "Hyperdyne Corporation"
	faction_tag = FACTION_HYPERDYNE
	base_icon_file = 'icons/mob/hud/factions/hyperdyne.dmi'

/datum/faction/hyperdyne/modify_hud_holder(image/holder, mob/living/carbon/human/human)
	var/icon/override_icon_file
	var/hud_icon_state
	var/_role = human.job
	if(!_role)
		var/obj/item/card/id/id_card = human.get_idcard()
		if(id_card)
			_role = id_card.rank
	switch(_role)
		if(JOB_HC_TRAINEE)
			hud_icon_state = "trainee"
		if(JOB_HC_JUNIOR_EXECUTIVE)
			hud_icon_state = "junior_exec"
		if(JOB_HC_CORPORATE_LIAISON)
			hud_icon_state = "liaison"
		if(JOB_HC_EXECUTIVE)
			hud_icon_state = "liaison"
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
		holder.overlays += image(override_icon_file ? override_icon_file : base_icon_file, human, "hc_[hud_icon_state]")
