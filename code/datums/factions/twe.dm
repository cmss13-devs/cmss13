/datum/faction/twe
	name = "Three World Empire"
	faction_tag = FACTION_TWE

/datum/faction/twe/modify_hud_holder(image/holder, mob/living/carbon/human/H)
	//Faction squad hud goes here

	if(!(H.mob_flags & ROGUE_UNIT) && ((H.faction == FACTION_TWE) || (FACTION_TWE in H.faction_group)))
		holder.overlays += image('icons/mob/hud/marine_hud.dmi', H, "allegiance_TWE")
