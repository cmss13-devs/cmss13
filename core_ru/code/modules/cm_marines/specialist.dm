/datum/specialist_set/stormtropper
	name = "Stormtrooper Set"
	role_name = "Stormtrooper"
	skill_to_give = SKILL_SPEC_ST
	kit_typepath = /obj/item/storage/box/spec/stormtrooper

/datum/specialist_set/stormtropper/redeem_set(mob/living/redeemer, kit)
	. = ..()
	if(!.)
		return .

	if(!skillcheck(redeemer, SKILL_ENDURANCE, SKILL_ENDURANCE_MAX))
		redeemer.skills?.set_skill(SKILL_ENDURANCE, SKILL_ENDURANCE_MAX)
	if(!skillcheck(redeemer, SKILL_MELEE_WEAPONS, SKILL_MELEE_SUPER))
		redeemer.skills?.set_skill(SKILL_MELEE_WEAPONS, SKILL_MELEE_SUPER)
	return TRUE
