/datum/faction/clf
	name = "Colonial Liberation Front"
	faction_tag = FACTION_CLF

/datum/faction/clf/modify_hud_holder(var/image/holder, var/mob/living/carbon/human/H)
	var/hud_icon_state
	var/obj/item/card/id/ID = H.get_idcard()
	var/_role
	if(H.mind)
		_role = H.job
	else if(ID)
		_role = ID.rank
	switch(_role)
		if(JOB_CLF_ENGI)
			hud_icon_state = "engi"
		if(JOB_CLF_MEDIC)
			hud_icon_state = "med"
		if(JOB_CLF_SPECIALIST)
			hud_icon_state = "spec"
		if(JOB_CLF_LEADER)
			hud_icon_state = "sl"
		if(JOB_CLF_SYNTH)
			hud_icon_state = "synth"
		if(JOB_CLF_COMMANDER)
			hud_icon_state = "cellcom"
	if(hud_icon_state)
		holder.icon_state = "clf_[hud_icon_state]"
