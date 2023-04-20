/datum/faction/contractor
	name = "Vanguard's Arrow Incorporated"
	faction_tag = FACTION_CONTRACTOR

/datum/faction/contractor/modify_hud_holder(image/holder, mob/living/carbon/human/H)
	//Faction squad hud goes here

	if(!(H.mob_flags & ROGUE_UNIT) && ((H.faction == FACTION_CONTRACTOR) || (FACTION_CONTRACTOR in H.faction_group)))
		holder.overlays += image('icons/mob/hud/marine_hud.dmi', H, "allegiance_VAI")
