/datum/faction/uscm
	name = "United States Colonial Marines"
	faction_tag = FACTION_MARINE
	hud_icon_prefix = "hudsquad_"

/datum/faction/uscm/modify_hud_holder(image/holder, mob/living/carbon/human/current_human)
	var/marine_rk
	var/used_icon_file = hud_icon_file

	var/obj/item/card/id/id_card = current_human.get_idcard()
	var/_role
	if(current_human.job)
		_role = current_human.job
	else if(id_card)
		_role = id_card.rank

	var/datum/squad/squad = current_human.assigned_squad
	if(istype(squad))
		var/squad_clr = current_human.assigned_squad.equipment_color
		switch(GET_DEFAULT_ROLE(_role))
			if(JOB_SQUAD_ENGI) marine_rk = "engi"
			if(JOB_SQUAD_SPECIALIST) marine_rk = "spec"
			if(JOB_SQUAD_TEAM_LEADER) marine_rk = "tl"
			if(JOB_SQUAD_MEDIC) marine_rk = "med"
			if(JOB_SQUAD_SMARTGUN) marine_rk = "gun"
			if(JOB_XO) marine_rk = "xo"
			if(JOB_CO) marine_rk = "co"
			if(JOB_GENERAL) marine_rk = "general"
			if(JOB_CAS_PILOT) marine_rk = "gp"
			if(JOB_DROPSHIP_PILOT) marine_rk = "dp"
			if(JOB_TANK_CREW) marine_rk = "tc"
			if(JOB_INTEL) marine_rk = "io"
			if(JOB_DROPSHIP_CREW_CHIEF) marine_rk = "dcc"
			if(JOB_MARINE_RAIDER) marine_rk = "soc"
			if(JOB_MARINE_RAIDER_SL) marine_rk = "soctl"
			if(JOB_MARINE_RAIDER_CMD) marine_rk = "soccmd"
			if(JOB_SQUAD_TECH) marine_rk = "tech"
		if(squad.squad_leader == current_human)
			switch(squad.squad_type)
				if("Squad") marine_rk = "leader_a"
				if("Team") marine_rk = "soctl_a"

			current_human.langchat_styles = "langchat_bolded" // bold text for bold leaders
		else
			current_human.langchat_styles = initial(current_human.langchat_styles)

		current_human.langchat_color = current_human.assigned_squad.chat_color

		if(!marine_rk)
			marine_rk = current_human.rank_icon_state_override
		if(marine_rk)
			var/image/IMG = image(used_icon_file, current_human, "hudsquad")
			if(squad_clr)
				IMG.color = squad_clr
			else
				IMG.color = "#5A934A"
			holder.overlays += IMG
			holder.overlays += image(used_icon_file, current_human, "[hud_icon_prefix][marine_rk]")
		if(current_human.assigned_squad && current_human.assigned_fireteam)
			var/image/IMG2 = image(used_icon_file, current_human, "[hud_icon_prefix][current_human.assigned_fireteam]")
			IMG2.color = squad_clr
			holder.overlays += IMG2
			if(current_human.assigned_squad.fireteam_leaders[current_human.assigned_fireteam] == current_human)
				var/image/IMG3 = image(used_icon_file, current_human, "[hud_icon_prefix]ftl")
				IMG3.color = squad_clr
				holder.overlays += IMG3
	else
		switch(_role)
			if(JOB_XO)
				marine_rk = "xo"
			if(JOB_CO)
				marine_rk = "co"
			if(JOB_USCM_OBSV)
				marine_rk = "vo"
			if(JOB_SO)
				marine_rk = "so"
			if(JOB_AUXILIARY_OFFICER)
				marine_rk = "aso"
			if(JOB_GENERAL, JOB_COLONEL, JOB_ACMC, JOB_CMC)
				marine_rk = "general"
			if(JOB_PLT_MED)
				marine_rk = "med"
			if(JOB_PLT_SL)
				marine_rk = "leader"
			if(JOB_SQUAD_TECH)
				marine_rk = "tech"
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
				marine_rk = "mp"
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
			if(JOB_CMO)
				marine_rk = "cmo"
			if(JOB_DOCTOR)
				marine_rk = "doctor"
			if(JOB_RESEARCHER)
				marine_rk = "researcher"
			if(JOB_NURSE)
				marine_rk = "nurse"
			if(JOB_SEA)
				marine_rk = "sea"
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
			if(JOB_PROVOST_UNDERCOVER)
				marine_rk = "pvuc"
			if(JOB_PROVOST_CINSPECTOR)
				marine_rk = "pvci"
			if(JOB_PROVOST_ADVISOR)
				marine_rk = "pva"
			if(JOB_PROVOST_DMARSHAL)
				marine_rk = "pvdm"
			if(JOB_PROVOST_MARSHAL, JOB_PROVOST_CMARSHAL, JOB_PROVOST_SMARSHAL)
				marine_rk = "pvm"
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
				hud_icon_prefix = "cmb_"
			if(JOB_CMB)
				marine_rk = "dep"
				hud_icon_prefix = "cmb_"
			if(JOB_CMB_SYN)
				marine_rk = "syn"
				hud_icon_prefix = "cmb_"
			if(JOB_CMB_ICC)
				marine_rk = "icc"
				hud_icon_prefix = "cmb_"
			if(JOB_CMB_OBS)
				marine_rk = "obs"
				hud_icon_prefix = "cmb_"
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

		if(current_human.rank_icon_file_override)
			used_icon_file = current_human.rank_icon_file_override
		if(current_human.rank_icon_state_override)
			marine_rk = current_human.rank_icon_state_override
		if(current_human.rank_icon_prefix_override)
			hud_icon_prefix = current_human.rank_icon_prefix_override



		if(marine_rk)
			var/image/I = image(used_icon_file, current_human, "hudsquad")
			I.color = "#5A934A"
			holder.overlays += I
			holder.overlays += image(used_icon_file, current_human, "[hud_icon_prefix][marine_rk]")
