/datum/faction/cmb
	name = "Colonial Marshal Bureau"
	faction_tag = FACTION_MARSHAL

/datum/faction/cmb/modify_hud_holder(image/holder, mob/living/carbon/human/H)
	var/hud_icon_state
	var/obj/item/card/id/ID = H.get_idcard()
	var/_role
	if(H.mind)
		_role = H.job
	else if(ID)
		_role = ID.rank
	switch(_role)
		if(JOB_CMB)
			hud_icon_state = "dep"
		if(JOB_CMB_ENG)
			hud_icon_state = "brch"
		if(JOB_CMB_ICC)
			hud_icon_state = "icc"
		if(JOB_CMB_MED)
			hud_icon_state = "medt"
		if(JOB_CMB_RSYN)
			hud_icon_state = "rsyn"
		if(JOB_CMB_OBS)
			hud_icon_state = "obs"
		if(JOB_CMB_RIOT)
			hud_icon_state = "rco"
		if(JOB_CMB_SYN)
			hud_icon_state = "syn"
		if(JOB_CMB_TL)
			hud_icon_state = "mar"
		if(JOB_CMB_SWAT)
			hud_icon_state = "spec"
	if(hud_icon_state)
		holder.overlays += image('icons/mob/hud/marine_hud.dmi', H, "cmb_[hud_icon_state]")
