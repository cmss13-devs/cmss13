/datum/faction/pap
	name = "People's Armed Police"
	faction_tag = FACTION_PAP
	base_icon_file = 'icons/mob/hud/factions/upp.dmi'

/datum/faction/pap/modify_hud_holder(image/holder, mob/living/carbon/human/human)
	var/icon/override_icon_file
	var/hud_icon_state
	var/_role = human.job
	if(!_role)
		var/obj/item/card/id/id_card = human.get_idcard()
		if(id_card)
			_role = id_card.rank
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
		holder.overlays += image(override_icon_file ? override_icon_file : base_icon_file, human, "pap_[hud_icon_state]")
