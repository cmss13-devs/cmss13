/datum/faction/lacn
	name = "Latin American Colonial Navy"
	faction_tag = FACTION_LACN
	base_icon_file = 'icons/mob/hud/factions/marine.dmi'

/datum/faction/lacn/modify_hud_holder_from_data(image/holder, location, job_rank, paygrade, assignment, rank_fallback, rank_override, datum/squad/squad)
	var/hud_icon_state = null

	switch(job_rank)
		if(JOB_LACN_COMMANDER)
			hud_icon_state = "xo"
		if(JOB_LACN_SL) //not used on map
			hud_icon_state = "tl"
		if(JOB_LACN_ENGI) //not used on map
			hud_icon_state = "engi"
		if(JOB_LACN_MEDIC)
			hud_icon_state = "medic"
		if(JOB_LACN_MARINE)
			hud_icon_state = "rifleman"
		if(JOB_LACN_POLICE)
			hud_icon_state = "mp"
		if(JOB_LACN_PILOT)
			hud_icon_state = "dp"
		if(JOB_LACN_GROUND)
			hud_icon_state = "ot"
		if(JOB_LACN_TANK)
			hud_icon_state = "tc"
		if(JOB_LACN_DOCTOR)
			hud_icon_state = "field_doctor"
		if (JOB_LACN_FIREFIGHTER)
			hud_icon_state = "wo_mcrew"
		if (JOB_LACN_SYN)
			hud_icon_state = "synth"

	if(hud_icon_state)
		var/image/background = image(base_icon_file, location, "hudsquad")
		background.color = "#50855D"
		holder.overlays += background
		holder.overlays += image(base_icon_file, location, "hudsquad_[hud_icon_state]")
