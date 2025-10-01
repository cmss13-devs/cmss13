/datum/faction/wo
	name = "Whiteout"
	faction_tag = FACTION_WY_DEATHSQUAD
	base_icon_file = 'icons/mob/hud/factions/wy.dmi'

/datum/faction/wo/modify_hud_holder(image/holder, mob/living/carbon/human/human)
	var/icon/override_icon_file
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
		holder.overlays += image(override_icon_file ? override_icon_file : base_icon_file, human, "wo_[hud_icon_state]")
