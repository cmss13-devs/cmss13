/datum/faction/pap
	name = "People's Armed Police"
	faction_tag = FACTION_PAP

/datum/faction/pap/modify_hud_holder(image/holder, mob/living/carbon/human/human)
	var/hud_icon_state
	var/obj/item/card/id/ID = human.get_idcard()
	var/_role
	if(human.mind)
		_role = human.job
	else if(ID)
		_role = ID.rank
	switch(_role)
		if(JOB_PAP_MILITSIONER)
			hud_icon_state = "silver"
		if(JOB_PAP_STARSHIY_MILITSIONER)
			hud_icon_state = "silver"
		if(JOB_PAP_STARSHINA)
			hud_icon_state = "silver"
		if(JOB_PAP_LEYTENANT)
			hud_icon_state = "gold"
		if(JOB_PAP_KAPITAN)
			hud_icon_state = "gold"
		if(JOB_PAP_MAYOR)
			hud_icon_state = "gold"
		if(JOB_PAP_POLITKOMISSAR)
			hud_icon_state = "gold"
		if(JOB_PAP_POLKOVNIK)
			hud_icon_state = "gold"
	if(hud_icon_state)
		holder.overlays += image('icons/mob/hud/marine_hud.dmi', human, "pap_[hud_icon_state]")
