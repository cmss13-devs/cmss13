/datum/faction/wo
	name = "Whiteout"
	faction_tag = FACTION_WY_DEATHSQUAD

/datum/faction/wo/modify_hud_holder(image/holder, mob/living/carbon/human/human)
	var/hud_icon_state
	var/obj/item/card/id/ID = human.get_idcard()
	var/_role
	if(human.mind)
		_role = human.job
	else if(ID)
		_role = ID.rank
	switch(_role)
		if(JOB_DS_SL)
			hud_icon_state = "sl"
		if(JOB_DS_CK)
			hud_icon_state = "med"
		if(JOB_DS_SUP)
			hud_icon_state = "sg"
		if(JOB_DS_CU)
			hud_icon_state = "op"
	if(hud_icon_state)
		holder.overlays += image('icons/mob/hud/marine_hud.dmi', human, "wo_[hud_icon_state]")
