/datum/faction/upp
	name = "Union of Progressive Peoples"
	faction_tag = FACTION_UPP

/datum/faction/upp/modify_hud_holder(var/image/holder, var/mob/living/carbon/human/H)
	var/hud_icon_state
	var/obj/item/card/id/ID = H.get_idcard()
	var/_role
	if(H.mind)
		_role = H.job
	else if(ID)
		_role = ID.rank
	switch(_role)
		if(JOB_UPP_MEDIC)
			hud_icon_state = "med"
		if(JOB_UPP_ENGI)
			hud_icon_state = "sapper"
		if(JOB_UPP_SPECIALIST)
			hud_icon_state = "spec"
		if(JOB_UPP_LEADER)
			hud_icon_state = "sl"
		if(JOB_UPP_POLICE)
			hud_icon_state = "mp"
		if(JOB_UPP_LT_OFFICER)
			hud_icon_state = "lt"
		if(JOB_UPP_SRLT_OFFICER)
			hud_icon_state = "slt"
		if(JOB_UPP_MAY_OFFICER)
			hud_icon_state = "may"
		if(JOB_UPP_KOL_OFFICER)
			hud_icon_state = "kol"
		if(JOB_UPP_COMBAT_SYNTH)
			hud_icon_state = "synth"
		if(JOB_UPP_COMMANDO)
			hud_icon_state = "com"
		if(JOB_UPP_COMMANDO_MEDIC)
			hud_icon_state = "commed"
		if(JOB_UPP_COMMANDO_LEADER)
			hud_icon_state = "comsl"
		if(JOB_UPP_CREWMAN)
			hud_icon_state = "vc"
		if(JOB_UPP_LT_DOKTOR)
			hud_icon_state = "doc"
	if(hud_icon_state)
		holder.icon_state = "upp_[hud_icon_state]"
