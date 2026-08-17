/datum/faction/uscm
	name = "United States Colonial Marines"
	faction_tag = FACTION_MARINE
	base_icon_file = 'icons/mob/hud/factions/marine.dmi'

	// Simple map from role name to icon, invariant to any dynamic state on mobs
	var/list/simple_role_icon_map = list(
		"default" = "grunt",
		// Squad roles
		JOB_SQUAD_LEADER = "leader",
		JOB_SQUAD_TEAM_LEADER = "tl",
		JOB_SQUAD_SPECIALIST = "spec",
		JOB_SQUAD_SMARTGUN = "gun",
		JOB_SQUAD_ENGI = "engi",
		JOB_SQUAD_MEDIC = "med",
		// Command
		JOB_CO = "co",
		JOB_XO = "xo",
		JOB_CMC = "cmc",
		JOB_ACMC = "acmc",
		JOB_GENERAL = "general",
		JOB_SO = "so",
		// Auxiliary roles
		JOB_AUXILIARY_OFFICER = "aso",
		JOB_CAS_PILOT = "gp",
		JOB_DROPSHIP_PILOT = "dp",
		JOB_TANK_CREW = "tc",
		JOB_INTEL = "io",
		JOB_DROPSHIP_CREW_CHIEF = "dcc",
		JOB_COMBAT_REPORTER = "comrec",
		JOB_ORDNANCE_TECH = "ot",
		JOB_MESS_SERGEANT = "messtech",
		JOB_SEA = "sea",
		JOB_SYNTH = "syn",
		// Requisitions
		JOB_CHIEF_REQUISITION = "ro",
		JOB_CARGO_TECH = "ct",
		// Engineering
		JOB_CHIEF_ENGINEER = "ce",
		JOB_MAINT_TECH = "mt",
		// MPs
		JOB_CHIEF_POLICE = "cmp",
		JOB_WARDEN = "warden",
		JOB_POLICE = "mp",
		// Medbay
		JOB_CMO = "cmo",
		JOB_FIELD_DOCTOR = "field_doctor",
		JOB_RESEARCHER = "researcher",
		JOB_NURSE = "nurse",
		// Raiders
		JOB_MARINE_RAIDER = "soc_grunt",
		JOB_MARINE_RAIDER_SG = "soc_sg",
		JOB_MARINE_RAIDER_SL = "soctl",
		JOB_MARINE_RAIDER_CMD = "soccmd",
		// US Army
		JOB_ARMY_TROOPER = "trpr",
		JOB_ARMY_ENGI = "cet",
		JOB_ARMY_MEDIC = "cmt",
		JOB_ARMY_MARKSMAN = "snpr",
		JOB_ARMY_SMARTGUNNER = "mmg",
		JOB_ARMY_SNCO = "sl_army",
		JOB_ARMY_CO = "co_army",
		JOB_ARMY_TANK = "tc_army",
		JOB_ARMY_SYN = "syn_army",
		// Whiskey outpost
		JOB_WO_CO = "wo_co",
		JOB_WO_XO = "wo_xo",
		JOB_WO_SO = "vhg",
		JOB_WO_CHIEF_POLICE = "hgsl",
		JOB_WO_WARDEN = "hgspec",
		JOB_WO_POLICE = "hg",
		JOB_WO_CMO = "wo_cmo",
		JOB_WO_DOCTOR = "wo_doctor",
		JOB_WO_RESEARCHER = "wo_chemist",
		JOB_WO_CHIEF_REQUISITION = "wo_ro",
		JOB_WO_PILOT = "wo_mcrew",
		JOB_WO_SQUAD_LEADER = "leader",
		JOB_WO_SQUAD_SPECIALIST = "spec",
		JOB_WO_SQUAD_SMARTGUNNER = "gun",
		JOB_WO_SQUAD_ENGINEER = "engi",
		JOB_WO_SQUAD_MEDIC = "med",
		JOB_WO_SYNTH = "syn",
		// Misc.
		JOB_FORECON_SUPPORT = "tech",
		JOB_PLT_MED = "med",
		JOB_PLT_SL = "leader",
		JOB_USCM_OBSV = "vo",
		JOB_POLICE_HG = "hgmp",
		JOB_COLONEL = "col",
		JOB_SYNTH_K9 = "syn_k9",
		// Provost
		JOB_PROVOST_ENFORCER = "pve",
		JOB_PROVOST_TML = "pvtml",
		JOB_PROVOST_INSPECTOR = "pvi",
		JOB_PROVOST_UNDERCOVER = "pvuc",
		JOB_PROVOST_CINSPECTOR = "pvci",
		JOB_PROVOST_ADVISOR = "pva",
		JOB_PROVOST_DMARSHAL = "pvdm",
		JOB_PROVOST_MARSHAL = "pvm",
		JOB_PROVOST_SMARSHAL = "pvsm",
		JOB_PROVOST_CMARSHAL = "pvcm",
		// CIA
		JOB_CIA_LIAISON = "cialo",
		JOB_CIA_UACQS_ADMN = "uacqs",
		JOB_CIA_UACQS_COMR = "uacqs_com",
		JOB_CIA_UACQS_SEC = "uacqs_sec",
		// Riot MPs
		JOB_RIOT = "rmp",
		JOB_RIOT_CHIEF = "crmp",
	)

/datum/faction/uscm/modify_hud_holder(image/holder, mob/living/carbon/human/current_human)
	var/datum/squad/squad = current_human.assigned_squad
	var/icon/override_icon_file

	var/_role = current_human.job
	var/obj/item/card/id/id_card = current_human.get_idcard()
	if(!_role && id_card)
		_role = id_card.rank

	var/rank_icon_substate
	if(_role in simple_role_icon_map)
		rank_icon_substate = simple_role_icon_map[_role]

	// Special cases
	var/default_role = GET_DEFAULT_ROLE(_role)
	if(default_role == JOB_SQUAD_MEDIC || default_role == JOB_WO_SQUAD_MEDIC)
		if(current_human.rank_fallback == "medk9")
			rank_icon_substate = "medk9" //We don't need Medics to lose their job when converting to K9 Handlers as it would duplicate JOB_SQUAD_MEDIC
		else
			rank_icon_substate = "med"

	switch(_role)
		if(JOB_COLONEL)
			if(id_card && id_card.paygrade)
				switch(id_card.paygrade)
					if(PAY_SHORT_MO4)
						rank_icon_substate = "ltcol"
					if(PAY_SHORT_MO5)
						rank_icon_substate  = "col"
		if(JOB_POLICE)
			if(current_human.rank_fallback == "hgmp")
				rank_icon_substate = "hgmp"
			else
				rank_icon_substate = "mp"
		if(JOB_DOCTOR)
			if(id_card.assignment == JOB_SURGEON)
				rank_icon_substate = "surgeon"
			else if(id_card.assignment == JOB_PHARMACIST)
				rank_icon_substate = "pharmacist"
			else
				rank_icon_substate = "doctor"
		if(JOB_SYNTH, JOB_WO_SYNTH)
			rank_icon_substate = "syn"
			var/datum/equipment_preset/synth/preset = current_human.assigned_equipment_preset
			if(preset?.subtype)
				rank_icon_substate = "syn_[preset.subtype]"

	if(current_human.rank_override)
		rank_icon_substate = current_human.rank_override

	if(!rank_icon_substate)
		rank_icon_substate = current_human.rank_fallback

	// Deal with dynamic squad-related conditions like squad color and acting SLs
	var/squad_color
	if(istype(squad))
		current_human.langchat_color = current_human.assigned_squad.chat_color
		squad_color = current_human.assigned_squad.equipment_color
		// Hard override to SL icon if we're the the acting SL
		if(squad.squad_leader == current_human)
			switch(squad.squad_type)
				if("Squad")
					rank_icon_substate = "leader_a"
				if("Team")
					rank_icon_substate = "soctl_a"

	// Construct the overlay
	var/icon/file_to_use = override_icon_file ? override_icon_file : base_icon_file
	if(rank_icon_substate)
		var/image/base_hud_layer = image(file_to_use, current_human, "hudsquad")
		base_hud_layer.color = "#5A934A"
		if(squad_color)
			base_hud_layer.color = squad_color
		holder.overlays += base_hud_layer
		holder.overlays += image(file_to_use, current_human, "hudsquad_[rank_icon_substate]")

	if(current_human.assigned_squad && current_human.assigned_fireteam)
		var/image/fireteam_overlay = image(file_to_use, current_human, "hudsquad_[current_human.assigned_fireteam]")
		fireteam_overlay.color = squad_color
		holder.overlays += fireteam_overlay

		if(current_human.assigned_squad.fireteam_leaders[current_human.assigned_fireteam] == current_human)
			var/image/fireteam_lead_overlay = image(file_to_use, current_human, "hudsquad_ftl")
			fireteam_lead_overlay.color = squad_color
			holder.overlays += fireteam_lead_overlay

// Construct a role HUD icon without basing it on dynamic state
/datum/faction/uscm/get_simple_icon(role)
	RETURN_TYPE(/icon)

	var/rank_icon_substate
	if(!(role in simple_role_icon_map))
		role = "default"
	rank_icon_substate = simple_role_icon_map[role]

	if(rank_icon_substate)
		var/icon/base_hud_layer = icon(base_icon_file, icon_state = "hudsquad")
		base_hud_layer.Blend("#5A934A", ICON_MULTIPLY)
		base_hud_layer.Blend(icon(base_icon_file, icon_state = "hudsquad_[rank_icon_substate]"), ICON_OVERLAY)
		return base_hud_layer

	return null
