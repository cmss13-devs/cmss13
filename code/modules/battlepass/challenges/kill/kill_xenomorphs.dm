/datum/battlepass_challenge/kill_enemies/xenomorphs
	name = "Kill Xenomorphs"
	desc = "Kill AMOUNT Xenomorphs as a human."
	challenge_category = CHALLENGE_HUMAN
	kill_requirement_lower = 2
	kill_requirement_upper = 3
	valid_kill_paths = list(
		/mob/living/carbon/xenomorph,
	)
	completion_xp = 6

/datum/battlepass_challenge/kill_enemies/xenomorphs/regenerate_desc()
	desc = "Kill [enemy_kills_required] Xenomorph\s as a human."

/datum/battlepass_challenge/kill_enemies/xenomorphs/on_kill(mob/source, mob/killed_mob, datum/cause_data/cause_data)
	if(!ishuman(source) || (source.faction == killed_mob.faction))
		return

	return ..()
