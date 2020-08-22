/datum/entity/death_stats
	var/datum/entity/player_entity/player = null // "vampmare"
	var/datum/entity/round_stats/linked_round = null // reference to current round entity
	var/mob_name = null // "bob mcbobber" or "ravager (RA-42-T)"
	var/job_name = null // "captain" or "ravager"
	var/area_name = null // simple area name storage
	var/cause_name = null // "ravager" or "grenade" or "M41A"
	var/total_kills = null // "ravager" or "grenade" or "M41A"
	var/list/total_damage = list() // list of types /datum/entity/statistic, name = "brute", value = 300
	var/time_of_death = null // time passed after round-start
	var/steps_walked = 0
	var/total_time_alive = null
	var/x = 1
	var/y = 1
	var/z = 1 // ground-side, in transit, or on almayer?

/datum/entity/death_stats/proc/count_player_death(var/mob/M)
	if (!M || !M.mind)
		return
	var/datum/mind/D = M.mind
	D.player_entity.death_stats.Insert(1, src)
	if(ishuman(M))
		// Update base human stats
		var/datum/entity/player_stats/human/human_stats = D.setup_human_stats()
		human_stats.total_deaths += 1

		// Update job-specific stats
		var/job_name = get_actual_job_name(M)
		if(job_name)
			var/datum/entity/player_stats/job/job_stats
			if(human_stats.job_stats_list[job_name])
				job_stats = human_stats.job_stats_list[job_name]
			else
				job_stats = new()
				job_stats.player = human_stats
				job_stats.name = job_name
				human_stats.job_stats_list[job_name] = job_stats
			job_stats.total_deaths += 1
		return
	else if(isXeno(M))
		// Update base xeno stats
		var/mob/living/carbon/Xenomorph/X = M
		if(!D.player_entity.player_stats["xeno"])
			D.setup_xeno_stats()
		var/datum/entity/player_stats/xeno/xeno_stats = D.player_entity.player_stats["xeno"]
		xeno_stats.total_deaths += 1

		// Update caste-specific stats
		if(X.caste_name)
			var/datum/entity/player_stats/caste/caste_stats
			if(xeno_stats.caste_stats_list[X.caste_name])
				caste_stats = xeno_stats.caste_stats_list[X.caste_name]
			else
				caste_stats = new()
				caste_stats.player = xeno_stats
				caste_stats.name = X.caste_name
				xeno_stats.caste_stats_list[X.caste_name] = caste_stats
			caste_stats.total_deaths += 1
		return

//*****************
//Mob Procs - death
//*****************

/mob/proc/track_mob_death(var/cause, var/cause_mob, var/job_name)
	if(!mind || statistic_exempt)
		return
	var/datum/entity/death_stats/new_death = new()
	if(mind.player_entity)
		new_death.player = mind.player_entity

	new_death.mob_name = real_name
	if(cause)
		new_death.cause_name = cause
	if(job_name)
		new_death.job_name = job_name

	var/area/A = get_area(src)
	new_death.area_name = A.name

	if(getBruteLoss())
		var/datum/entity/statistic/S = new()
		S.name = "brute"
		S.value = round(getBruteLoss())
		new_death.total_damage["brute"] = S
	if(getFireLoss())
		var/datum/entity/statistic/S = new()
		S.name = "fire"
		S.value = round(getFireLoss())
		new_death.total_damage["fire"] = S
	if(getOxyLoss())
		var/datum/entity/statistic/S = new()
		S.name = "oxy"
		S.value = round(getOxyLoss())
		new_death.total_damage["oxy"] = S
	if(getBrainLoss())
		var/datum/entity/statistic/S = new()
		S.name = "brain"
		S.value = round(getBrainLoss())
		new_death.total_damage["brain"] = S
	if(getCloneLoss())
		var/datum/entity/statistic/S = new()
		S.name = "clone"
		S.value = round(getCloneLoss())
		new_death.total_damage["clone"] = S
	if(getToxLoss())
		var/datum/entity/statistic/S = new()
		S.name = "tox"
		S.value = round(getToxLoss())
		new_death.total_damage["tox"] = S
	if(getHalLoss())
		var/datum/entity/statistic/S = new()
		S.name = "stun"
		S.value = round(getHalLoss())
		new_death.total_damage["stun"] = S

	new_death.time_of_death = world.time

	new_death.x = src.x
	new_death.y = src.y
	new_death.z = src.z

	new_death.total_kills = life_kills_total
	new_death.total_time_alive = life_time_total
	new_death.steps_walked = life_steps_total

	var/observer_message = "<b>[real_name]</b> has died"
	if(cause)
		observer_message += " to <b>[cause]</b>"
	if(A.name)
		observer_message += " at \the <b>[A.name]</b>"

	msg_admin_attack(observer_message, src.loc.x, src.loc.y, src.loc.z)

	for(var/mob/dead/observer/g in player_list)
		if(g.client && g.client.admin_holder && (g.client.admin_holder.rights & R_MOD) && (g.client.prefs.toggles_chat & CHAT_ATTACKLOGS))
			continue
		to_chat(g, SPAN_DEADSAY(observer_message + " (<a href='?src=\ref[g];jumptocoord=1;X=[src.loc.x];Y=[src.loc.y];Z=[src.loc.z]'>JMP</a>)"))

	if(round_statistics)
		new_death.linked_round = round_statistics
		round_statistics.track_death(new_death, faction)
	new_death.count_player_death(src)
	return new_death

/mob/living/carbon/human/track_mob_death(var/cause, var/cause_mob)
	. = ..(cause, cause_mob, job)
	if(statistic_exempt)
		return
	if(mind)
		var/datum/entity/player_stats/human/human_stats = mind.setup_human_stats()
		if(human_stats && human_stats.death_list)
			human_stats.death_list.Insert(1, .)
	if(cause_mob)
		if(!ismob(cause_mob))
			return
		var/mob/M = cause_mob
		if(!istype(M))
			return
		var/job_name = get_actual_job_name(src)
		if(!job_name)
			return

		if(M.faction == faction && round_statistics)
			round_statistics.total_friendly_fire_kills += 1
		if(!M.statistic_exempt && M != src)
			M.count_human_kill(job_name, cause)
			M.life_kills_total += 1

			if(isYautja(M) && M.client)
				M.client.add_honor(max(life_kills_total, 1))

/mob/living/carbon/Xenomorph/track_mob_death(var/cause, var/cause_mob)
	. = ..(cause, cause_mob, caste_name)
	if(statistic_exempt)
		return
	if(mind)
		var/datum/entity/player_stats/xeno/xeno_stats = mind.setup_xeno_stats()
		if(xeno_stats && xeno_stats.death_list)
			xeno_stats.death_list.Insert(1, .)
	if(cause_mob)
		if(!ismob(cause_mob))
			return
		var/mob/M = cause_mob
		if(!M.statistic_exempt && M != src)
			M.count_xeno_kill(caste_name, cause)
			M.life_kills_total += 1
			if(isYautja(M) && M.client)
				M.client.add_honor(max(life_kills_total, 1))

/mob/living/carbon/examine(mob/user)
	. = ..()
	if(isYautja(user))
		to_chat(user, SPAN_BLUE("[src] is worth [max(life_kills_total, 1)] honor."))