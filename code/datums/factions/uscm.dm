/datum/faction/uscm
	name = "United States Colonial Marines"
	faction_tag = FACTION_MARINE
	base_icon_file = 'icons/mob/hud/factions/marine.dmi'

/datum/faction/uscm/modify_hud_holder_from_data(image/holder, location, job_rank, paygrade, assignment, rank_fallback, rank_override, datum/squad/squad)
	var/marine_rk = rank_fallback

	if(istype(squad))
		var/squad_clr = squad.equipment_color
		switch(GET_DEFAULT_ROLE(job_rank))
			if(JOB_SQUAD_ENGI, JOB_WO_SQUAD_ENGINEER)
				marine_rk = "engi"
			if(JOB_SQUAD_SPECIALIST, JOB_WO_SQUAD_SPECIALIST)
				marine_rk = "spec"
			if(JOB_SQUAD_TEAM_LEADER, JOB_WO_SQUAD_LEADER)
				marine_rk = "tl"
			if(JOB_SQUAD_MEDIC, JOB_WO_SQUAD_MEDIC)
				if(rank_fallback == "medk9")
					marine_rk = "medk9" //We don't need Medics to lose their job when converting to K9 Handlers as it would duplicate JOB_SQUAD_MEDIC
				else
					marine_rk = "med"
			if(JOB_SQUAD_SMARTGUN, JOB_WO_SQUAD_SMARTGUNNER)
				marine_rk = "gun"
			if(JOB_XO, JOB_WO_XO)
				marine_rk = "xo"
			if(JOB_CO, JOB_WO_CO)
				marine_rk = "co"
			if(JOB_CAS_PILOT)
				marine_rk = "gp"
			if(JOB_DROPSHIP_PILOT)
				marine_rk = "dp"
			if(JOB_TANK_CREW)
				marine_rk = "tc"
			if(JOB_INTEL)
				marine_rk = "io"
			if(JOB_DROPSHIP_CREW_CHIEF)
				marine_rk = "dcc"
			if(JOB_MARINE_RAIDER)
				marine_rk = "soc_grunt"
			if(JOB_MARINE_RAIDER_SG)
				marine_rk = "soc_sg"
			if(JOB_MARINE_RAIDER_SL)
				marine_rk = "soctl"
			if(JOB_MARINE_RAIDER_CMD)
				marine_rk = "soccmd"
			if(JOB_FORECON_SUPPORT)
				marine_rk = "tech"
			// US Army
			if(JOB_ARMY_TROOPER)
				marine_rk = "trpr"
			if(JOB_ARMY_ENGI)
				marine_rk = "cet"
			if(JOB_ARMY_MEDIC)
				marine_rk = "cmt"
			if(JOB_ARMY_MARKSMAN)
				marine_rk = "snpr"
			if(JOB_ARMY_SMARTGUNNER)
				marine_rk = "mmg"
			if(JOB_ARMY_SNCO)
				marine_rk = "sl_army"
			if(JOB_ARMY_CO)
				marine_rk = "co_army"
			if(JOB_ARMY_TANK)
				marine_rk = "tc_army"
			if(JOB_ARMY_SYN)
				marine_rk = "syn_army"
		if(squad.squad_leader == location)
			switch(squad.squad_type)
				if("Squad")
					marine_rk = "leader_a"
				if("Team")
					marine_rk = "soctl_a"

		var/mob/living/carbon/human/human
		if(ishuman(location))
			human = location
			human.langchat_color = squad.chat_color // This really ought to be done elsewhere

		if(rank_override && squad.squad_leader != location)
			marine_rk = rank_override

		if(marine_rk)
			var/image/background = image(base_icon_file, location, "hudsquad")
			if(squad_clr)
				background.color = squad_clr
			else
				background.color = "#5A934A"
			holder.overlays += background
			holder.overlays += image(base_icon_file, location, "hudsquad_[marine_rk]")

		// Relying on location to be a human means we can't programically get an overlay caring about fireteam
		if(human?.assigned_fireteam)
			var/image/fireteam_background = image(base_icon_file, location, "hudsquad_[human.assigned_fireteam]")
			fireteam_background.color = squad_clr
			holder.overlays += fireteam_background

			if(human.assigned_squad.fireteam_leaders[human.assigned_fireteam] == human)
				var/image/fireteam_leader = image(base_icon_file, location, "hudsquad_ftl")
				fireteam_leader.color = squad_clr
				holder.overlays += fireteam_leader
		return

	// Not in a squad
	switch(job_rank)
		if(JOB_CMC)
			marine_rk = "cmc"
		if(JOB_ACMC)
			marine_rk = "acmc"
		if(JOB_GENERAL)
			marine_rk = "general"
		if(JOB_COLONEL)
			switch(paygrade)
				if(PAY_SHORT_MO4)
					marine_rk = "ltcol"
				if(PAY_SHORT_MO5)
					marine_rk  = "col"
		if(JOB_XO, JOB_WO_XO)
			marine_rk = "xo"
		if(JOB_CO, JOB_WO_CO)
			marine_rk = "co"
		if(JOB_USCM_OBSV)
			marine_rk = "vo"
		if(JOB_SO, JOB_WO_SO)
			marine_rk = "so"
		if(JOB_AUXILIARY_OFFICER)
			marine_rk = "aso"
		if(JOB_PLT_MED)
			marine_rk = "med"
		if(JOB_PLT_SL)
			marine_rk = "leader"
		if(JOB_FORECON_SUPPORT)
			marine_rk = "tech"
		// US Army
		if(JOB_ARMY_TROOPER)
			marine_rk = "trpr"
		if(JOB_ARMY_MEDIC)
			marine_rk = "cmt"
		if(JOB_ARMY_ENGI)
			marine_rk = "cet"
		if(JOB_ARMY_MARKSMAN)
			marine_rk = "snpr"
		if(JOB_ARMY_SMARTGUNNER)
			marine_rk = "mmg"
		if(JOB_ARMY_SNCO)
			marine_rk = "sl_army"
		if(JOB_ARMY_CO)
			marine_rk = "co_army"
		if(JOB_ARMY_SYN)
			marine_rk = "syn_army"
		if(JOB_INTEL)
			marine_rk = "io"
		if(JOB_CAS_PILOT)
			marine_rk = "gp"
		if(JOB_DROPSHIP_PILOT)
			marine_rk = "dp"
		if(JOB_DROPSHIP_CREW_CHIEF)
			marine_rk = "dcc"
		if(JOB_CHIEF_POLICE)
			marine_rk = "cmp"
		if(JOB_POLICE)
			if(rank_fallback == "hgmp")
				marine_rk = "hgmp"
			else
				marine_rk = "mp"
		if(JOB_POLICE_HG)
			marine_rk = "hgmp"
		if(JOB_TANK_CREW)
			marine_rk = "tc"
		if(JOB_WARDEN)
			marine_rk = "warden"
		if(JOB_CHIEF_REQUISITION)
			marine_rk = "ro"
		if(JOB_CARGO_TECH)
			marine_rk = "ct"
		if(JOB_CHIEF_ENGINEER)
			marine_rk = "ce"
		if(JOB_MAINT_TECH)
			marine_rk = "mt"
		if(JOB_ORDNANCE_TECH)
			marine_rk = "ot"
		if(JOB_COMBAT_REPORTER)
			marine_rk = "comrec"
		if(JOB_CMO)
			marine_rk = "cmo"
		if(JOB_DOCTOR)
			if(assignment == JOB_SURGEON)
				marine_rk = "surgeon"
			else if(assignment == JOB_PHARMACIST)
				marine_rk = "pharmacist"
			else
				marine_rk = "doctor"
		if(JOB_FIELD_DOCTOR)
			marine_rk = "field_doctor"
		if(JOB_RESEARCHER)
			marine_rk = "researcher"
		if(JOB_NURSE)
			marine_rk = "nurse"
		if(JOB_SEA)
			marine_rk = "sea"
		if(JOB_SYNTH, JOB_WO_SYNTH)
			marine_rk = "syn"
			// Relying on location to be a human means to programically set this we would have to use rank_override for the preset subtype
			if(ishuman(location))
				var/mob/living/carbon/human/human = location
				var/datum/equipment_preset/synth/preset = human.assigned_equipment_preset
				if(preset?.subtype)
					marine_rk = "syn_[preset.subtype]"
		if(JOB_SYNTH_K9)
			marine_rk = "syn_k9"
		if(JOB_MESS_SERGEANT)
			marine_rk = "messtech"
		// Provost
		if(JOB_PROVOST_ENFORCER)
			marine_rk = "pve"
		if(JOB_PROVOST_TML)
			marine_rk = "pvtml"
		if(JOB_PROVOST_INSPECTOR)
			marine_rk = "pvi"
		if(JOB_PROVOST_UNDERCOVER)
			marine_rk = "pvuc"
		if(JOB_PROVOST_CINSPECTOR)
			marine_rk = "pvci"
		if(JOB_PROVOST_ADVISOR)
			marine_rk = "pva"
		if(JOB_PROVOST_DMARSHAL)
			marine_rk = "pvdm"
		if(JOB_PROVOST_MARSHAL)
			marine_rk = "pvm"
		if(JOB_PROVOST_SMARSHAL)
			marine_rk = "pvsm"
		if(JOB_PROVOST_CMARSHAL)
			marine_rk = "pvcm"
		// CIA
		if(JOB_CIA_LIAISON)
			marine_rk = "cialo"
		if(JOB_CIA_UACQS_ADMN)
			marine_rk = "uacqs"
		if(JOB_CIA_UACQS_COMR)
			marine_rk = "uacqs_com"
		if(JOB_CIA_UACQS_SEC)
			marine_rk = "uacqs_sec"
		// Riot MPs
		if(JOB_RIOT)
			marine_rk = "rmp"
		if(JOB_RIOT_CHIEF)
			marine_rk = "crmp"
		// Whiskey Outpost
		if(JOB_WO_CO)
			marine_rk = "wo_co"
		if(JOB_WO_XO)
			marine_rk = "wo_xo"
		if(JOB_WO_CHIEF_POLICE)
			marine_rk = "hgsl"
		if(JOB_WO_SO)
			marine_rk = "vhg"
		if(JOB_WO_WARDEN)
			marine_rk = "hgspec"
		if(JOB_WO_POLICE)
			marine_rk = "hg"
		if(JOB_WO_CMO)
			marine_rk = "wo_cmo"
		if(JOB_WO_DOCTOR)
			marine_rk = "wo_doctor"
		if(JOB_WO_RESEARCHER)
			marine_rk = "wo_chemist"
		if(JOB_WO_CHIEF_REQUISITION)
			marine_rk = "wo_ro"
		if(JOB_WO_PILOT)
			marine_rk = "wo_mcrew"
		// Check squad marines here too, for the unique ones
		if(JOB_SQUAD_ENGI, JOB_WO_SQUAD_ENGINEER)
			marine_rk = "engi"
		if(JOB_SQUAD_MEDIC, JOB_WO_SQUAD_MEDIC)
			marine_rk = "med"
		if(JOB_SQUAD_SPECIALIST, JOB_WO_SQUAD_SPECIALIST)
			marine_rk = "spec"
		if(JOB_SQUAD_SMARTGUN, JOB_WO_SQUAD_SMARTGUNNER)
			marine_rk = "gun"
		if(JOB_SQUAD_TEAM_LEADER)
			marine_rk = "tl"
		if(JOB_SQUAD_LEADER, JOB_WO_SQUAD_LEADER)
			marine_rk = "leader"

	if(rank_override)
		marine_rk = rank_override

	if(marine_rk)
		var/image/background = image(base_icon_file, location, "hudsquad")
		background.color = "#5A934A"
		holder.overlays += background
		holder.overlays += image(base_icon_file, location, "hudsquad_[marine_rk]")
