/datum/faction/uscm
	name = "United States Colonial Marines"
	faction_tag = FACTION_MARINE

/datum/faction/uscm/modify_hud_holder(image/holder, mob/living/carbon/human/H)
	var/datum/squad/squad = H.assigned_squad
	if(istype(squad))
		var/squad_clr = squad_colors[H.assigned_squad.color]
		var/marine_rk
		var/obj/item/card/id/I = H.get_idcard()
		var/_role
		if(H.job)
			_role = H.job
		else if(I)
			_role = I.rank
		switch(GET_DEFAULT_ROLE(_role))
			if(JOB_SQUAD_ENGI) marine_rk = "engi"
			if(JOB_SQUAD_SPECIALIST) marine_rk = "spec"
			if(JOB_SQUAD_RTO) marine_rk = "rto"
			if(JOB_SQUAD_MEDIC) marine_rk = "med"
			if(JOB_SQUAD_SMARTGUN) marine_rk = "gun"
			if(JOB_XO) marine_rk = "xo"
			if(JOB_CO) marine_rk = "co"
			if(JOB_GENERAL) marine_rk = "general"
			if(JOB_PILOT) marine_rk = "po"
			if(JOB_INTEL) marine_rk = "io"
			if(JOB_DROPSHIP_CREW_CHIEF) marine_rk = "dcc"
			if(JOB_CREWMAN) marine_rk = "tc"
			if(JOB_MARINE_RAIDER) marine_rk = "soc"
			if(JOB_MARINE_RAIDER_SL) marine_rk = "soctl"
			if(JOB_MARINE_RAIDER_CMD) marine_rk = "soccmd"
		if(squad.squad_leader == H)
			switch(squad.squad_type)
				if("Squad") marine_rk = "leader_a"
				if("Team") marine_rk = "soctl_a"

			H.langchat_styles = "langchat_bolded" // bold text for bold leaders
		else
			H.langchat_styles = initial(H.langchat_styles)

		H.langchat_color = squad_colors_chat[H.assigned_squad.color]

		if(!marine_rk) marine_rk = H.rank_fallback
		if(marine_rk)
			var/image/IMG = image('icons/mob/hud/marine_hud.dmi', H, "hudsquad")
			if(squad_clr)
				IMG.color = squad_clr
			else
				IMG.color = "#5A934A"
			holder.overlays += IMG
			holder.overlays += image('icons/mob/hud/marine_hud.dmi', H, "hudsquad_[marine_rk]")
		if(H.assigned_squad && H.assigned_fireteam)
			var/image/IMG2 = image('icons/mob/hud/marine_hud.dmi', H, "hudsquad_[H.assigned_fireteam]")
			IMG2.color = squad_clr
			holder.overlays += IMG2
			if(H.assigned_squad.fireteam_leaders[H.assigned_fireteam] == H)
				var/image/IMG3 = image('icons/mob/hud/marine_hud.dmi', H, "hudsquad_ftl")
				IMG3.color = squad_clr
				holder.overlays += IMG3
	else
		var/marine_rk
		var/border_rk
		var/obj/item/card/id/ID = H.get_idcard()
		var/_role
		if(H.mind)
			_role = H.job
		else if(ID)
			_role = ID.rank
		switch(GET_DEFAULT_ROLE(_role))
			if(JOB_XO)
				marine_rk = "xo"
				border_rk = "command"
			if(JOB_CO)
				marine_rk = "co"
				border_rk = "command"
			if(JOB_SO)
				marine_rk = "so"
				border_rk = "command"
			if(JOB_GENERAL, JOB_COLONEL, JOB_ACMC, JOB_CMC)
				marine_rk = "general"
				border_rk = "command"
			if(JOB_INTEL)
				marine_rk = "io"
			if(JOB_PILOT)
				marine_rk = "po"
			if(JOB_DROPSHIP_CREW_CHIEF)
				marine_rk = "dcc"
			if(JOB_CHIEF_POLICE)
				marine_rk = "cmp"
				border_rk = "command"
			if(JOB_POLICE)
				marine_rk = "mp"
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
			if(JOB_MESS_SERGEANT)
				marine_rk = "messtech"
			if(JOB_PROVOST_ENFORCER)
				marine_rk = "pve"
			if(JOB_PROVOST_TML)
				marine_rk = "pvtml"
			if(JOB_PROVOST_INSPECTOR)
				marine_rk = "pvi"
				border_rk = "command"
			if(JOB_PROVOST_ADVISOR)
				marine_rk = "pva"
				border_rk = "command"
			if(JOB_PROVOST_MARSHAL, JOB_PROVOST_CMARSHAL, JOB_PROVOST_SMARSHAL)
				marine_rk = "pvm"
				border_rk = "command"
			if(JOB_TIS_IO)
				marine_rk = "tisio"
			if(JOB_TIS_SA)
				marine_rk = "tissa"
			if(JOB_RIOT)
				marine_rk = "rmp"
			if(JOB_RIOT_CHIEF)
				marine_rk = "crmp"
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

		if(marine_rk)
			var/image/I = image('icons/mob/hud/marine_hud.dmi', H, "hudsquad")
			I.color = "#5A934A"
			holder.overlays += I
			holder.overlays += image('icons/mob/hud/marine_hud.dmi', H, "hudsquad_[marine_rk]")
			if(border_rk)
				holder.overlays += image('icons/mob/hud/marine_hud.dmi', H, "hudmarineborder[border_rk]")
