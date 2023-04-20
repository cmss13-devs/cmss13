/datum/faction/contractor
	name = "Vanguard's Arrow Incorporated"
	faction_tag = FACTION_CONTRACTOR

/datum/faction/contractor/modify_hud_holder(image/holder, mob/living/carbon/human/H)
	var/hud_icon_state
	var/border_icon = "normal"
	var/obj/item/card/id/ID = H.get_idcard()
	var/_role
	if(H.mind)
		_role = H.job
	else if(ID)
		_role = ID.rank
	switch(_role)
		if(JOB_CONTRACTOR_ST)
			hud_icon_state = "st"
		if(JOB_CONTRACTOR_ENGI)
			hud_icon_state = "eng"
		if(JOB_CONTRACTOR_MEDIC)
			hud_icon_state = "med"
		if(JOB_CONTRACTOR_MG)
			hud_icon_state = "mg"
		if(JOB_CONTRACTOR_TL)
			hud_icon_state = "tl"
		if(JOB_CONTRACTOR_SYN)
			hud_icon_state = "syn"
		if(JOB_CONTRACTOR_COVST)
			hud_icon_state = "st"
			border_icon = "covert"
		if(JOB_CONTRACTOR_COVENG)
			hud_icon_state = "eng"
			border_icon = "covert"
		if(JOB_CONTRACTOR_COVMED)
			hud_icon_state = "med"
			border_icon = "covert"
		if(JOB_CONTRACTOR_COVMG)
			hud_icon_state = "mg"
			border_icon = "covert"
		if(JOB_CONTRACTOR_COVTL)
			hud_icon_state = "tl"
			border_icon = "covert"
		if(JOB_CONTRACTOR_COVSYN)
			hud_icon_state = "syn"
			border_icon = "covert"

	if(hud_icon_state)
		holder.overlays += image('icons/mob/hud/marine_hud.dmi', H, "vai_[hud_icon_state]")
		if(border_icon)
			holder.overlays += image('icons/mob/hud/marine_hud.dmi', H, "vai_[border_icon]")

	if(!(H.mob_flags & ROGUE_UNIT) && ((H.faction == FACTION_CONTRACTOR) || (FACTION_CONTRACTOR in H.faction_group)))
		holder.overlays += image('icons/mob/hud/marine_hud.dmi', H, "allegiance_VAI")
