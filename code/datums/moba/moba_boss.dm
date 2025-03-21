/datum/moba_boss
	var/boss_name = ""
	var/boss_type
	var/spawn_text = ""
	var/boon_type
	var/right_spawn = FALSE

/datum/moba_boss/proc/on_boss_kill(mob/living/simple_animal/hostile/dead_boss, datum/moba_player/killer, datum/hive_status/killing_hive, datum/moba_controller/controller)
	SHOULD_CALL_PARENT(TRUE)

	if(boon_type)
		if(killing_hive.hivenumber == XENO_HIVE_MOBA_LEFT)
			controller.team1_boons += new boon_type(controller)
		else if(killing_hive.hivenumber == XENO_HIVE_MOBA_RIGHT)
			controller.team2_boons += new boon_type(controller)


/datum/moba_boss/megacarp
	boss_name = "megacarp"
	boss_type = /mob/living/simple_animal/hostile/megacarp
	spawn_text = "The megacarp has spawned at <b>Right Side Robotics</b>!"
	right_spawn = TRUE
	boon_type = /datum/moba_boon/megacarp

/datum/moba_boss/megacarp/on_boss_kill(mob/living/simple_animal/hostile/dead_boss, datum/moba_player/killer, datum/hive_status/killing_hive, datum/moba_controller/controller)
	. = ..()
	START_COOLDOWN(controller, carp_boss_spawn_cooldown, carp_spawn_time)


/datum/moba_boss/hivebot
	boss_name = "hivebot"
	boss_type = /mob/living/simple_animal/hostile/hivebot
	spawn_text = "The hivebot has spawned at <b>Left Side Metro</b>!"
	boon_type  = /datum/moba_boon/hivebot
