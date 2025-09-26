/datum/faction/nspa
	name = "Neroid Sector Policing Authority"
	faction_tag = FACTION_NSPA
	base_icon_file = 'icons/mob/hud/factions/twe.dmi'

/datum/faction/nspa/modify_hud_holder(image/holder, mob/living/carbon/human/human)
	var/icon/override_icon_file
	var/hud_icon_state
	var/obj/item/card/id/ID = human.get_idcard()
	var/_role
	if(human.mind)
		_role = human.job
	else if(ID)
		_role = ID.rank
	switch(_role)
		if(JOB_NSPA_CST)
			hud_icon_state = "con"
		if(JOB_NSPA_SC)
			hud_icon_state = "con"
		if(JOB_NSPA_SGT)
			hud_icon_state = "con"
		if(JOB_NSPA_INSP)
			hud_icon_state = "sgt"
		if(JOB_NSPA_CINSP)
			hud_icon_state = "sgt"
		if(JOB_NSPA_CMD)
			hud_icon_state = "sgt"
		if(JOB_NSPA_DCO)
			hud_icon_state = "sgt"
		if(JOB_NSPA_COM)
			hud_icon_state = "sgt"
	if(hud_icon_state)
		holder.overlays += image(override_icon_file ? override_icon_file : base_icon_file, human, "nspa_[hud_icon_state]")
