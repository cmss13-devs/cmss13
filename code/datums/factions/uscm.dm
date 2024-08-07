/datum/faction/uscm
	name = NAME_FACTION_USCM
	desc = "The USCM is divided into three overarching branches, called the Marine Space Forces: Sol, overseeing the core colonies and earth, the largest of the three; Eridani, operating among the Chinese and American colonised arms; Herculis, going through the Anglo-Japanese arms and the outer fringes. Each branch operates independently, but all are responsible for protecting American space territory and working together in that goal. \
	There is also a fourth group, the Reserves, which is stationed mostly on earth and serves to reinforce the other branches. They have not seen any active use yet, but who knows what the future holds. Marine Space Force, Herculis, Chinook 91 GSO station is a military space station in geosynchronous orbit around the colony world Georgia 525 (70 Ophiuchi A V), and is the headquarters for the Herculis branch of the USCM. Under its control are the 4th Colonial Marine Division, 4th Colonial Marine Brigade, 4th Aerospace Wing, and 1st Colonial Support Group of the USCM. \
	Chinook 91 reports directly to O'Neill station in Earth-Lunar space. The O'Neill station is the main communication base between the three branches. Supervising orders from the homeworld, controlling the First Fleet and rare joint operations. It is an extremely vital station and well guarded by the First Fleet in all its might. Tithonis Mountain on Bernice 378 is another large garrison of USCM troops, such as the 1st Colonial Support Group, and there are more minor garrisons along the Anglo-Japanese arm. The 2nd Company of the 2nd Battalion of the 4th Brigade, the Falling Falcons, and the USS Almayer are stationed in Herculis."

	faction_name = FACTION_USCM
	faction_tag = SIDE_FACTION_USCM
	relations_pregen = RELATIONS_FACTION_USCM
	faction_iff_tag_type = /obj/item/faction_tag/uscm

/datum/faction/uscm/modify_hud_holder(image/holder, mob/living/carbon/human/current_human)
	var/datum/squad/squad = current_human.assigned_squad
	if(istype(squad))
		var/squad_clr = current_human.assigned_squad.equipment_color
		var/marine_rk
		var/obj/item/card/id/I = current_human.get_idcard()
		var/_role
		if(current_human.job)
			_role = current_human.job
		else if(I)
			_role = I.rank
		switch(GET_DEFAULT_ROLE(_role))
			if(JOB_SQUAD_ENGI)
				marine_rk = "engi"
			if(JOB_SQUAD_SPECIALIST)
				marine_rk = "spec"
			if(JOB_SQUAD_TEAM_LEADER)
				marine_rk = "tl"
			if(JOB_SQUAD_MEDIC)
				marine_rk = "med"
			if(JOB_SQUAD_SMARTGUN)
				marine_rk = "gun"
			if(JOB_XO)
				marine_rk = "xo"
			if(JOB_CO)
				marine_rk = "co"
			if(JOB_GENERAL)
				marine_rk = "general"
			if(JOB_PILOT)
				marine_rk = "po"
			if(JOB_INTEL)
				marine_rk = "io"
			if(JOB_DROPSHIP_CREW_CHIEF)
				marine_rk = "dcc"
			if(JOB_CREWMAN)
				marine_rk = "tc"
			if(JOB_MARINE_RAIDER)
				marine_rk = "soc"
			if(JOB_MARINE_RAIDER_SL)
				marine_rk = "soctl"
			if(JOB_MARINE_RAIDER_CMD)
				marine_rk = "soccmd"
		if(squad.squad_leader == current_human)
			switch(squad.squad_type)
				if("Squad")
					marine_rk = "leader_a"
				if("Team")
					marine_rk = "soctl_a"

			current_human.langchat_styles = "langchat_bolded" // bold text for bold leaders
		else
			current_human.langchat_styles = initial(current_human.langchat_styles)

		current_human.langchat_color = current_human.assigned_squad.chat_color

		if(!marine_rk)
			marine_rk = current_human.rank_fallback
		if(marine_rk)
			var/image/IMG = image('icons/mob/hud/marine_hud.dmi', current_human, "hudsquad")
			if(squad_clr)
				IMG.color = squad_clr
			else
				IMG.color = "#5A934A"
			holder.overlays += IMG
			holder.overlays += image('icons/mob/hud/marine_hud.dmi', current_human, "hudsquad_[marine_rk]")
		if(current_human.assigned_squad && current_human.assigned_fireteam)
			var/image/IMG2 = image('icons/mob/hud/marine_hud.dmi', current_human, "hudsquad_[current_human.assigned_fireteam]")
			IMG2.color = squad_clr
			holder.overlays += IMG2
			if(current_human.assigned_squad.fireteam_leaders[current_human.assigned_fireteam] == current_human)
				var/image/IMG3 = image('icons/mob/hud/marine_hud.dmi', current_human, "hudsquad_ftl")
				IMG3.color = squad_clr
				holder.overlays += IMG3
	else
		var/marine_rk
		var/border_rk
		var/icon_prefix = "hudsquad_"
		var/obj/item/card/id/ID = current_human.get_idcard()
		var/_role
		if(current_human.mind)
			_role = current_human.job
		else if(ID)
			_role = ID.rank
		switch(_role)
			if(JOB_XO)
				marine_rk = "xo"
				border_rk = "command"
			if(JOB_CO)
				marine_rk = "co"
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
			// Provost
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
			// TIS
			if(JOB_TIS_IO)
				marine_rk = "tisio"
			if(JOB_TIS_SA)
				marine_rk = "tissa"
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
			// Colonial Marshals
			if(JOB_CMB_TL)
				marine_rk = "mar"
				icon_prefix = "cmb_"
			if(JOB_CMB)
				marine_rk = "dep"
				icon_prefix = "cmb_"
			if(JOB_CMB_SYN)
				marine_rk = "syn"
				icon_prefix = "cmb_"
			if(JOB_CMB_ICC)
				marine_rk = "icc"
				icon_prefix = "cmb_"
			if(JOB_CMB_OBS)
				marine_rk = "obs"
				icon_prefix = "cmb_"

		if(marine_rk)
			var/image/I = image('icons/mob/hud/marine_hud.dmi', current_human, "hudsquad")
			I.color = "#5A934A"
			holder.overlays += I
			holder.overlays += image('icons/mob/hud/marine_hud.dmi', current_human, "[icon_prefix][marine_rk]")
			if(border_rk)
				holder.overlays += image('icons/mob/hud/marine_hud.dmi', current_human, "hudmarineborder[border_rk]")
