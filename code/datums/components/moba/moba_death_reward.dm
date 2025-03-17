/datum/component/moba_death_reward
	dupe_mode = COMPONENT_DUPE_UNIQUE
	/// How much gold to award on death
	var/gold = 0
	/// How much XP to award on death
	var/xp = 0
	/// What hive we're friendly to, if any
	var/allied_hive
	/// If TRUE, only award the gold to the killer
	var/gold_award_to_killer = TRUE
	/// What percent of the gold (floored) should we award to nearby allies of the killer if we only reward gold to the killer? This gold is effectively duplicated
	var/percent_gold_to_allies = 0

/datum/component/moba_death_reward/Initialize(gold, xp, allied_hive, gold_award_to_killer, percent_gold_to_allies)
	. = ..()
	if(!istype(parent, /mob/living))
		return COMPONENT_INCOMPATIBLE

	src.gold = gold
	src.xp = xp
	src.allied_hive = allied_hive
	src.gold_award_to_killer = gold_award_to_killer
	src.percent_gold_to_allies = percent_gold_to_allies

/datum/component/moba_death_reward/RegisterWithParent()
	..()
	RegisterSignal(parent, COMSIG_MOB_DEATH, PROC_REF(on_death))

/datum/component/moba_death_reward/proc/on_death(datum/source, datum/cause_data/cause)
	SIGNAL_HANDLER

	var/list/awarding_xenos = list()

	for(var/mob/living/carbon/xenomorph/xeno in view(world.view, parent))
		if(!xeno.client || (xeno.stat == DEAD)) // Must be a player and can't be dead
			continue

		if(xeno.hive.hivenumber == allied_hive) // We don't reward our allies when we die
			continue

		awarding_xenos += xeno

	for(var/mob/living/carbon/xenomorph/xeno as anything in awarding_xenos)
		if(gold && !gold_award_to_killer)
			SEND_SIGNAL(xeno, COMSIG_MOBA_GIVE_GOLD, floor(gold / length(awarding_xenos)))

		if(xp)
			SEND_SIGNAL(xeno, COMSIG_MOBA_GIVE_XP, floor(xp / length(awarding_xenos)))

	if(gold && gold_award_to_killer)
		var/mob/killer
		if(cause?.weak_mob)
			killer = cause.weak_mob.resolve()

		if(killer)
			SEND_SIGNAL(killer, COMSIG_MOBA_GIVE_GOLD, gold)

		if(percent_gold_to_allies)
			var/gold_percent = gold * percent_gold_to_allies
			for(var/mob/living/carbon/xenomorph/xeno as anything in awarding_xenos)
				if(xeno == killer)
					continue

				SEND_SIGNAL(xeno, COMSIG_MOBA_GIVE_GOLD, gold_percent)

