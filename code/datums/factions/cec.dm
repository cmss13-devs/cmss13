/datum/faction/cec
	name = "Cosmos Exploration Corps"
	faction_tag = FACTION_CEC
	base_icon_file = 'icons/mob/hud/factions/upp.dmi'

/datum/faction/cec/modify_hud_holder(image/holder, mob/living/carbon/human/human)
	var/icon/override_icon_file
	var/hud_icon_state
	var/_role = human.job
	if(!_role)
		var/obj/item/card/id/id_card = human.get_idcard()
		if(id_card)
			_role = id_card.rank
	switch(_role)
		if(JOB_CEC_SYNTH)
			hud_icon_state = "synth"
		if(JOB_CEC_TRAINEE)
			hud_icon_state = "docent"
		if(JOB_CEC_DOCENT)
			hud_icon_state = "docent"
		if(JOB_CEC_PROFESSOR)
			hud_icon_state = "red_star"
		if(JOB_CEC_VICE_RECTOR)
			hud_icon_state = "red_star"
		if(JOB_CEC_RECTOR)
			hud_icon_state = "red_star"
	if(hud_icon_state)
		holder.overlays += image(override_icon_file ? override_icon_file : base_icon_file, human, "cec_[hud_icon_state]")
