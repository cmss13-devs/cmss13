/datum/faction/clf
	name = NAME_FACTION_CLF
	desc = "The Colonial Liberation Front is a paramilitary group primarily located in the Neroid sector of United Americas space. Their stated goal is to secure the independence of all of the colonies in the Neroid sector. They are the largest and most active militant group pushing for the independence of the colonies. \
	The United Americas government classifies the CLF as a terrorist organization, with membership in the organization or providing financial or material support for the CLF being prosecutable offenses. The CLF grew organically from several different groups that formed in the wake of the Slaughter of Xibou in 2164. Prior to the slaughter of Xibou the conflicts between the United Americas government and the colonists of the Neroid sector had remained mostly non-violent. \
	The sudden increase in tensions after Xibou, combined with the images of slaughtered fighters and civilians alike, greatly increased the willingness of the colonists to take up arms against the United Americas. Several different militant groups formed in the years following the Slaughter, and as they negotiated with one another and found common cause the CLF was formed from their union."

	faction_name = FACTION_CLF
	faction_tag = SIDE_FACTION_CLF
	relations_pregen = RELATIONS_FACTION_CLF

/datum/faction/clf/modify_hud_holder(image/holder, mob/living/carbon/human/human)
	var/hud_icon_state
	var/obj/item/card/id/id_card = human.get_idcard()
	var/_role
	if(human.mind)
		_role = human.job
	else if(id_card)
		_role = id_card.rank
	switch(_role)
		if(JOB_CLF_ENGI)
			hud_icon_state = "engi"
