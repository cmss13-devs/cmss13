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
	/// How much gold to give to each person on the team regardless of distance
	var/global_gold = 0

/datum/component/moba_death_reward/Initialize(gold = 0, xp = 0, allied_hive, gold_award_to_killer = TRUE, percent_gold_to_allies = 0, global_gold = 0)
	. = ..()
	if(!isliving(parent))
		return COMPONENT_INCOMPATIBLE

	src.gold = gold
	src.xp = xp
	src.allied_hive = allied_hive
	src.gold_award_to_killer = gold_award_to_killer
	src.percent_gold_to_allies = percent_gold_to_allies
	src.global_gold = global_gold

/datum/component/moba_death_reward/RegisterWithParent()
	..()
	RegisterSignal(parent, COMSIG_MOB_DEATH, PROC_REF(on_death))

/datum/component/moba_death_reward/proc/on_death(datum/source, datum/cause_data/cause)
	SIGNAL_HANDLER

	var/list/awarding_xenos = list()
	var/parent_level = -1
	var/list/parent_level_list = list()
	SEND_SIGNAL(parent, COMSIG_MOBA_GET_LEVEL, parent_level_list)
	if(length(parent_level_list))
		parent_level = parent_level_list[1]

	for(var/mob/living/carbon/xenomorph/xeno in view(world.view, parent))
		if(!xeno.client || (xeno.stat == DEAD)) // Must be a player and can't be dead
			continue

		if(xeno.hive.hivenumber == allied_hive) // We don't reward our allies when we die
			continue

		if(global_gold)
			SEND_SIGNAL(xeno, COMSIG_MOBA_GIVE_GOLD, global_gold)

		awarding_xenos += xeno

	for(var/mob/living/carbon/xenomorph/xeno as anything in awarding_xenos)
		if(gold && !gold_award_to_killer)
			SEND_SIGNAL(xeno, COMSIG_MOBA_GIVE_GOLD, floor(gold / length(awarding_xenos)))

		if(xp)
			if(parent_level != -1)
				var/list/level_list = list()
				SEND_SIGNAL(xeno, COMSIG_MOBA_GET_LEVEL, level_list)
				var/level_diff = parent_level - level_list[1]
				var/xp_to_award = floor(xp / length(awarding_xenos))
				if(level_diff >= MOBA_LEVEL_DIFF_XP_FALLOFF_THRESHOLD)
					xp_to_award *= (1 - (MOBA_LEVEL_DIFF_XP_MOD * level_diff)) // If we're >=2 levels ahead of whoever we're killing, we get 20% less XP per level difference
				SEND_SIGNAL(xeno, COMSIG_MOBA_GIVE_XP, xp_to_award)
			else
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

