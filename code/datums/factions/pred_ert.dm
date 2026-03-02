/datum/faction/military_caste
	name = "Yautja Military Caste"
	faction_tag = FACTION_MILITARY_CASTE
	base_icon_file = 'icons/mob/hud/factions/wy.dmi'

/datum/faction/wo/modify_hud_holder(image/holder, mob/living/carbon/human/human)
	var/icon/override_icon_file
	var/hud_icon_state
	var/_role = human.job
	if(!_role)
		var/obj/item/card/id/id_card = human.get_idcard()
		if(id_card)
			_role = id_card.rank
	switch(_role)
		if(JOB_MCASTE_ENFORCER)
			hud_icon_state = "sl"
		if(JOB_MCASTE_HEAVY)
			hud_icon_state = "sg"
		if(JOB_MCASTE_SOLDIER)
			hud_icon_state = "op"
	if(hud_icon_state)
		holder.overlays += image(override_icon_file ? override_icon_file : base_icon_file, human, "wo_[hud_icon_state]")
