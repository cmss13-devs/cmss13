/datum/faction/iasf
	name = "TWE - Imperial Armed Space Force"
	faction_tag = FACTION_IASF
	base_icon_file = 'icons/mob/hud/factions/twe.dmi'

/datum/faction/iasf/modify_hud_holder(image/holder, mob/living/carbon/human/human)
	var/icon/override_icon_file
	var/hud_icon_state
	var/_role = human.job
	if(!_role)
		var/obj/item/card/id/id_card = human.get_idcard()
		if(id_card)
			_role = id_card.rank
	switch(_role)
		if(JOB_TWE_IASF_PARA_LIEUTENANT)
			hud_icon_state = "lieutenant"
		if(JOB_TWE_IASF_PARA_SQUAD_LEADER)
			hud_icon_state = "teamleader"
		if(JOB_TWE_IASF_PARA_SNIPER)
			hud_icon_state = "sniper"
		if(JOB_TWE_IASF_PARA_MEDIC)
			hud_icon_state = "medic"
		if(JOB_TWE_IASF_PARA)
			hud_icon_state = "rifleman"
		if(JOB_TWE_IASF_PARA_SMARTGUNNER)
			hud_icon_state = "smartgunner"
		if(JOB_TWE_IASF_PARA_SPECIALIST)
			hud_icon_state = "spec"
		if(JOB_TWE_IASF_PARA_PILOT)
			hud_icon_state = "pilot"
		if(JOB_TWE_IASF_PARA_ENGI)
			hud_icon_state = "engi"
		if(JOB_TWE_IASF_PARA_CAPTAIN)
			hud_icon_state = "commander"
		if(JOB_TWE_IASF_PARA_MAJOR)
			hud_icon_state = "major"
		if (JOB_TWE_IASF_PARA_COMMANDER)
			hud_icon_state = "commander"
		if (JOB_TWE_IASF_PARA_SYNTH)
			hud_icon_state = "synth"
	if(hud_icon_state)
		holder.overlays += image(override_icon_file ? override_icon_file : base_icon_file, human, "iasf_[hud_icon_state]")
