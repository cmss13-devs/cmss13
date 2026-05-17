/datum/faction/uscm
	name = "United States Colonial Marines"
	faction_tag = FACTION_MARINE
	base_icon_file = 'icons/mob/hud/factions/marine.dmi'

/datum/faction/uscm/modify_hud_holder(image/holder, mob/living/carbon/human/current_human)
	var/datum/squad/squad = current_human.assigned_squad
	var/icon/override_icon_file
	if(istype(squad))
		var/squad_clr = current_human.assigned_squad.equipment_color
		var/marine_rk
		var/_role = current_human.job
		if(!_role)
			var/obj/item/card/id/id_card = current_human.get_idcard()
			if(id_card)
				_role = id_card.rank
		switch(GET_DEFAULT_ROLE(_role))
			if(JOB_SQUAD_ENGI)
				marine_rk = "engi"
			if(JOB_SQUAD_SPECIALIST)
				marine_rk = "spec"
			if(JOB_SQUAD_TEAM_LEADER)
				marine_rk = "tl"
			if(JOB_SQUAD_MEDIC)
				if(current_human.rank_fallback == "medk9")
					marine_rk = "medk9" //We don't need Medics to lose their job when converting to K9 Handlers as it would duplicate JOB_SQUAD_MEDIC
				else
					marine_rk = "med"
			if(JOB_SQUAD_SMARTGUN)
				marine_rk = "gun"
			if(JOB_XO)
				marine_rk = "xo"
			if(JOB_CO)
				marine_rk = "co"
			if(JOB_GENERAL)
				marine_rk = "general"
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
			if(JOB_ARMY_SYN)
				marine_rk = "syn_army"
		if(squad.squad_leader == current_human)
			switch(squad.squad_type)
				if("Squad")
					marine_rk = "leader_a"
				if("Team")
					marine_rk = "soctl_a"

		current_human.langchat_color = current_human.assigned_squad.chat_color

		var/icon/file_to_use = override_icon_file ? override_icon_file : base_icon_file
		if(!marine_rk)
			marine_rk = current_human.rank_fallback
		if(current_human.rank_override && squad.squad_leader != current_human)
			marine_rk = current_human.rank_override
		if(marine_rk)
			var/image/IMG = image(file_to_use, current_human, "hudsquad")
			if(squad_clr)
				IMG.color = squad_clr
			else
				IMG.color = "#5A934A"
			holder.overlays += IMG
			holder.overlays += image(file_to_use, current_human, "hudsquad_[marine_rk]")
		if(current_human.assigned_squad && current_human.assigned_fireteam)
			var/image/IMG2 = image(file_to_use, current_human, "hudsquad_[current_human.assigned_fireteam]")
			IMG2.color = squad_clr
			holder.overlays += IMG2
			if(current_human.assigned_squad.fireteam_leaders[current_human.assigned_fireteam] == current_human)
				var/image/IMG3 = image(file_to_use, current_human, "hudsquad_ftl")
				IMG3.color = squad_clr
				holder.overlays += IMG3
	else
		var/marine_rk
		var/border_rk
		var/_role = current_human.job
		if(!_role)
			var/obj/item/card/id/id_card = current_human.get_idcard()
			if(id_card)
				_role = id_card.rank
		switch(_role)
			if(JOB_XO)
				marine_rk = "xo"
				border_rk = "command"
			if(JOB_CO)
				marine_rk = "co"
				border_rk = "command"
			if(JOB_USCM_OBSV)
				marine_rk = "vo"
				border_rk = "command"
			if(JOB_SO)
				marine_rk = "so"
				border_rk = "command"
			if(JOB_AUXILIARY_OFFICER)
				marine_rk = "aso"
				border_rk = "command"
			if(JOB_GENERAL, JOB_COLONEL, JOB_ACMC, JOB_CMC)
				marine_rk = "general"
				border_rk = "command"
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
				border_rk = "command"
			if(JOB_POLICE)
				if(current_human.rank_fallback == "hgmp")
					marine_rk = "hgmp"
				else
					marine_rk = "mp"
			if(JOB_POLICE_HG)
				marine_rk = "hgmp"
			if(JOB_TANK_CREW)
				marine_rk = "tc"
			if(JOB_WARDEN)
				marine_rk = "warden"
				border_rk = "command"
			if(JOB_CHIEF_REQUISITION)
				marine_rk = "ro"
			if(JOB_CARGO_TECH)
				marine_rk = "ct"
			if(JOB_CHIEF_ENGINEER)
				marine_rk = "ce"
				border_rk = "command"
			if(JOB_MAINT_TECH)
				marine_rk = "mt"
			if(JOB_ORDNANCE_TECH)
				marine_rk = "ot"
			if(JOB_CMO)
				marine_rk = "cmo"
				border_rk = "command"
			if(JOB_DOCTOR)
				marine_rk = "doctor"
				border_rk = "command"
			if(JOB_FIELD_DOCTOR)
				marine_rk = "field_doctor"
				border_rk = "command"
			if(JOB_RESEARCHER)
				marine_rk = "researcher"
				border_rk = "command"
			if(JOB_NURSE)
				marine_rk = "nurse"
			if(JOB_SEA)
				marine_rk = "sea"
				border_rk = "command"
			if(JOB_SYNTH)
				marine_rk = "syn"
				var/datum/equipment_preset/synth/preset = current_human.assigned_equipment_preset
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
				border_rk = "command"
			if(JOB_PROVOST_UNDERCOVER)
				marine_rk = "pvuc"
				border_rk = "command"
			if(JOB_PROVOST_CINSPECTOR)
				marine_rk = "pvci"
				border_rk = "command"
			if(JOB_PROVOST_ADVISOR)
				marine_rk = "pva"
				border_rk = "command"
			if(JOB_PROVOST_DMARSHAL)
				marine_rk = "pvdm"
				border_rk = "command"
			if(JOB_PROVOST_MARSHAL, JOB_PROVOST_CMARSHAL, JOB_PROVOST_SMARSHAL)
				marine_rk = "pvm"
				border_rk = "command"
			//CIA
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
			if(JOB_WO_CREWMAN)
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
			if(JOB_SQUAD_ENGI)
				marine_rk = "engi"
			if(JOB_SQUAD_MEDIC)
				marine_rk = "med"
			if(JOB_SQUAD_SPECIALIST)
				marine_rk = "spec"
			if(JOB_SQUAD_SMARTGUN)
				marine_rk = "gun"
			if(JOB_SQUAD_TEAM_LEADER)
				marine_rk = "tl"
			if(JOB_SQUAD_LEADER)
				marine_rk = "leader"
		if(current_human.rank_override)
			marine_rk = current_human.rank_override

		var/icon/file_to_use = override_icon_file ? override_icon_file : base_icon_file
		if(marine_rk)
			var/image/I = image(file_to_use, current_human, "hudsquad")
			I.color = "#5A934A"
			holder.overlays += I
			holder.overlays += image(file_to_use, current_human, "hudsquad_[marine_rk]")
			if(border_rk)
				holder.overlays += image(file_to_use, current_human, "hudmarineborder[border_rk]")
