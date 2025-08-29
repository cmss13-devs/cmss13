/datum/faction/cia
	name = "Central Intelligence Agency"
	faction_tag = FACTION_CIA

/datum/faction/cia/modify_hud_holder(image/holder, mob/living/carbon/human/H)
	var/hud_icon_state
	var/obj/item/card/id/ID = H.get_idcard()
	var/_role
	if(H.mind)
		_role = H.job
	else if(ID)
		_role = ID.rank
	switch(_role)
		if(JOB_CIA_LIAISON)
			hud_icon_state = "cialo"
		if(JOB_CIA_UACQS_ADMN)
			hud_icon_state = "uacqs"
		if(JOB_CIA_UACQS_COMR)
			hud_icon_state = "uacqs_com"
		if(JOB_CIA_UACQS_SEC)
			hud_icon_state = "uacqs_sec"
		if(JOB_CIA_GRS_OPR)
			hud_icon_state = "grs_opr"
		if(JOB_CIA_GRS_MED)
			hud_icon_state = "grs_med"
		if(JOB_CIA_GRS_ENG)
			hud_icon_state = "grs_eng"
		if(JOB_CIA_GRS_HVY)
			hud_icon_state = "grs_hvy"
		if(JOB_CIA_GRS_TL)
			hud_icon_state = "grs_tl"
	if(hud_icon_state)
		holder.overlays += image('icons/mob/hud/marine_hud.dmi', H, "hudsquad_[hud_icon_state]")

/datum/faction/cia/united_americas
	name = FACTION_UA
	faction_tag = FACTION_UA
