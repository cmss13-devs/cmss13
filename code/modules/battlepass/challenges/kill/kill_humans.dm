/datum/battlepass_challenge/kill_enemies/humans
	name = "Kill Humans"
	desc = "Kill AMOUNT humans as a Xenomorph."
	challenge_category = CHALLENGE_XENO
	kill_requirement_lower = 3
	kill_requirement_upper = 5
	valid_kill_paths = list(
		/mob/living/carbon/human,
	)
	completion_xp = 6
	pick_weight = 10

/datum/battlepass_challenge/kill_enemies/humans/regenerate_desc()
	desc = "Kill [enemy_kills_required] human\s as a Xenomorph."

/datum/battlepass_challenge/kill_enemies/humans/on_kill(mob/source, mob/killed_mob, datum/cause_data/cause_data)
	if(!isxeno(source) || (source.faction == killed_mob.faction))
		return

	if(!ishuman(killed_mob))
		return

	var/mob/living/carbon/human/killed_human = killed_mob

	// Synths, preds, etc. don't count towards this
	if(!isspecieshuman(killed_human))
		return

	return ..()
