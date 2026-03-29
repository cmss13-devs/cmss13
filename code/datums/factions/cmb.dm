/datum/faction/cmb
	name = "Colonial Marshal Bureau"
	faction_tag = FACTION_MARSHAL
	base_icon_file = 'icons/mob/hud/factions/cmb.dmi'

/datum/faction/cmb/modify_hud_holder(image/holder, mob/living/carbon/human/human)
	var/icon/override_icon_file
	var/hud_icon_state
	var/_role = human.job
	var/anchorpoint_marine
	if(!_role)
		var/obj/item/card/id/id_card = human.get_idcard()
		if(id_card)
			_role = id_card.rank
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

	//Anchorpoint Marines
		if(JOB_SQUAD_MARINE)
			hud_icon_state = "grunt"
			anchorpoint_marine = TRUE
		if(JOB_SQUAD_ENGI)
			hud_icon_state = "engi"
			anchorpoint_marine = TRUE
		if(JOB_SQUAD_TEAM_LEADER)
			hud_icon_state = "tl"
			anchorpoint_marine = TRUE
		if(JOB_SQUAD_MEDIC)
			hud_icon_state = "med"
			anchorpoint_marine = TRUE
		if(JOB_SQUAD_SMARTGUN)
			hud_icon_state = "gun"
			anchorpoint_marine = TRUE

	if(anchorpoint_marine)
		var/image/IMG = image('icons/mob/hud/factions/marine.dmi', human, "hudsquad")
		IMG.color = "#194877"
		holder.overlays += IMG
		holder.overlays += image('icons/mob/hud/factions/marine.dmi', human, "hudsquad_[hud_icon_state]")
		return

	if(hud_icon_state)
		holder.overlays += image(override_icon_file ? override_icon_file : base_icon_file, human, "cmb_[hud_icon_state]")
