/datum/faction/wy
	name = "Weyland-Yutani Corporation"
	desc = "Weyland Yutani also known as \"the Company\", has a wide range of business. This includes dealing with high-tech armaments, synthetic humanoids, spaceships, computer parts, terraforming equipment, and household appliances. They also offers shipping and receiving services, among other ventures. Following an aggressive expansion into terraforming new colonial world, Weyland-Yutani secured rights and privileges from the United States government. One of those privileges is the close relationship with the USCM. \
	the Colonial Marines use corporate-supplied equipment in exchange for protecting and monitoring border colonies. This, however, does not mean that the interests of the company are aligned with the USCM. It is more accurate to say that Weyland-Yutani considers the USCM a valuable, but still disposable, asset. This has led to an increasing amount of hostility between the two factions. Weyland-Yutani has enough wealth and influence to hire private military contractors. These are highly trained mercenaries, generally ex-military veterans. \
	They do black site protection detail, undertaking dangerous assignments, and otherwise supply Weyland-Yutani with firepower in the absence of the USCM. They are compensated well for their services, and demand is always there. Rumors speak of even more well-equipped and well-selected military units within Weyland-Yutani's employment, but that is not officially verified. The Company has refused to comment on it."
	code_identificator = FACTION_WY

	relations_pregen = RELATIONS_FACTION_WY

	faction_iff_tag_type = /obj/item/faction_tag/wy

/datum/faction/wy/modify_hud_holder(image/holder, mob/living/carbon/human/user)
	var/hud_icon_state
	var/obj/item/card/id/id_card = user.get_idcard()
	var/role
	if(user.mind)
		role = user.job
	else if(id_card)
		role = id_card.rank
	switch(role)
		if(JOB_WY_GOON)
			hud_icon_state = "goon_normal"
		if(JOB_WY_GOON_LEAD)
			hud_icon_state = "goon_leader"
		if(JOB_WY_GOON_RESEARCHER)
			hud_icon_state = "goon_sci"
		if(JOB_WY_GOON_TECH)
			hud_icon_state = "goon_engi"
		if(JOB_CORPORATE_LIAISON)
			hud_icon_state = "liaison"
		if(JOB_EXECUTIVE)
			hud_icon_state = "liaison"
		if(JOB_SENIOR_EXECUTIVE)
			hud_icon_state = "senior_exec"
		if(JOB_EXECUTIVE_SPECIALIST)
			hud_icon_state = "exec_spec"
		if(JOB_EXECUTIVE_SUPERVISOR)
			hud_icon_state = "exec_super"
		if(JOB_ASSISTANT_MANAGER)
			hud_icon_state = "ass_man"
		if(JOB_DIVISION_MANAGER)
			hud_icon_state = "div_man"
		if(JOB_CHIEF_EXECUTIVE)
			hud_icon_state = "chief_man"
		if(JOB_TRAINEE)
			hud_icon_state = "trainee"
		if(JOB_JUNIOR_EXECUTIVE)
			hud_icon_state = "junior_exec"
		if(JOB_DIRECTOR)
			hud_icon_state = "director"
	if(hud_icon_state)
		holder.overlays += image('icons/mob/hud/marine_hud.dmi', user, "wy_[hud_icon_state]")
