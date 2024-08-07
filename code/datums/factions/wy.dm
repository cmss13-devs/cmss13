/datum/faction/wy
	name = NAME_FACTION_WY
	desc = "Weyland Yutani also known as \"the Company\", has a wide range of business. This includes dealing with high-tech armaments, synthetic humanoids, spaceships, computer parts, terraforming equipment, and household appliances. They also offers shipping and receiving services, among other ventures. Following an aggressive expansion into terraforming new colonial world, Weyland-Yutani secured rights and privileges from the United States government. One of those privileges is the close relationship with the USCM. \
	the Colonial Marines use corporate-supplied equipment in exchange for protecting and monitoring border colonies. This, however, does not mean that the interests of the company are aligned with the USCM. It is more accurate to say that Weyland-Yutani considers the USCM a valuable, but still disposable, asset. This has led to an increasing amount of hostility between the two factions. Weyland-Yutani has enough wealth and influence to hire private military contractors. These are highly trained mercenaries, generally ex-military veterans. \
	They do black site protection detail, undertaking dangerous assignments, and otherwise supply Weyland-Yutani with firepower in the absence of the USCM. They are compensated well for their services, and demand is always there. Rumors speak of even more well-equipped and well-selected military units within Weyland-Yutani's employment, but that is not officially verified. The Company has refused to comment on it."

	faction_name = FACTION_WY
	faction_tag = SIDE_FACTION_WY
	relations_pregen = RELATIONS_FACTION_WY
	faction_iff_tag_type = /obj/item/faction_tag/wy

/datum/faction/wy/modify_hud_holder(image/holder, mob/living/carbon/human/H)
	var/hud_icon_state
	var/obj/item/card/id/ID = H.get_idcard()
	var/_role
	if(H.mind)
		_role = H.job
	else if(ID)
		_role = ID.rank
	switch(_role)
		if(JOB_PMC_DIRECTOR)
			hud_icon_state = "sd"
		if(JOB_PMC_LEADER, JOB_PMC_LEAD_INVEST)
			hud_icon_state = "ld"
		if(JOB_PMC_DOCTOR)
			hud_icon_state = "td"
		if(JOB_PMC_ENGINEER)
			hud_icon_state = "ct"
		if(JOB_PMC_MEDIC, JOB_PMC_INVESTIGATOR)
			hud_icon_state = "md"
		if(JOB_PMC_SYNTH)
			hud_icon_state = "syn"
	if(hud_icon_state)
		holder.overlays += image('icons/mob/hud/marine_hud.dmi', H, "pmc_[hud_icon_state]")
