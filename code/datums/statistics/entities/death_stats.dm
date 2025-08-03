/datum/entity/statistic/death
	var/player_id
	var/round_id

	var/role_name
	var/faction_name
	var/mob_name
	var/area_name

	var/is_xeno

	var/cause_name
	var/cause_player_id
	var/cause_role_name
	var/cause_faction_name

	var/total_steps = 0
	var/total_kills = 0
	var/time_of_death
	var/total_time_alive
	var/total_damage_taken
	var/total_revives_done = 0
	var/total_ib_fixed = 0

	var/total_brute = 0
	var/total_burn = 0
	var/total_oxy = 0
	var/total_tox = 0

	var/x
	var/y
	var/z

/datum/entity_meta/statistic_death
	entity_type = /datum/entity/statistic/death
	table_name = "log_player_statistic_death"
	field_types = list(
		"player_id" = DB_FIELDTYPE_BIGINT,
		"round_id" = DB_FIELDTYPE_BIGINT,

		"role_name" = DB_FIELDTYPE_STRING_LARGE,
		"faction_name" = DB_FIELDTYPE_STRING_LARGE,
		"mob_name" = DB_FIELDTYPE_STRING_LARGE,
		"area_name" = DB_FIELDTYPE_STRING_LARGE,

		"cause_name" = DB_FIELDTYPE_STRING_LARGE,
		"cause_player_id" = DB_FIELDTYPE_BIGINT,
		"cause_role_name" = DB_FIELDTYPE_STRING_LARGE,
		"cause_faction_name" = DB_FIELDTYPE_STRING_LARGE,

		"total_steps" = DB_FIELDTYPE_INT,
		"total_kills" = DB_FIELDTYPE_INT,
		"time_of_death" = DB_FIELDTYPE_BIGINT,
		"total_time_alive" = DB_FIELDTYPE_BIGINT,
		"total_damage_taken" = DB_FIELDTYPE_INT,
		"total_revives_done" = DB_FIELDTYPE_INT,
		"total_ib_fixed" = DB_FIELDTYPE_INT,

		"total_brute" = DB_FIELDTYPE_INT,
		"total_burn" = DB_FIELDTYPE_INT,
		"total_oxy" = DB_FIELDTYPE_INT,
		"total_tox" = DB_FIELDTYPE_INT,

		"x" = DB_FIELDTYPE_INT,
		"y" = DB_FIELDTYPE_INT,
		"z" = DB_FIELDTYPE_INT
	)

/mob/proc/track_mob_death(datum/cause_data/cause_data, turf/death_loc)
	if(cause_data && !istype(cause_data))
		stack_trace("track_mob_death called with string cause ([cause_data]) instead of datum")
		cause_data = create_cause_data(cause_data)

	var/log_message = "\[[time_stamp()]\] [key_name(src)] died to "
	if(cause_data)
		log_message += "[cause_data.cause_name]"
	else
		log_message += "unknown causes"
	var/mob/cause_mob = cause_data?.resolve_mob()
	if(cause_mob)
		log_message += " from [key_name(cause_data.resolve_mob())]"
		cause_mob.attack_log += "\[[time_stamp()]\] [key_name(cause_mob)] killed [key_name(src)] with [cause_data.cause_name]."

	attack_log += "[log_message]."

	if(!mind || statistic_exempt)
		return

	var/area/area = get_area(death_loc)
	handle_observer_message(cause_data, cause_mob, death_loc, area)

	// Perform logging above before get_player_from_key to avoid delays
	var/datum/entity/statistic/death/new_death = DB_ENTITY(/datum/entity/statistic/death)
	var/datum/entity/player/player_entity = get_player_from_key(mind.ckey)
	if(player_entity)
		new_death.player_id = player_entity.id

	if(SSperf_logging)
		new_death.round_id = SSperf_logging.round.id

	new_death.role_name = get_role_name()
	new_death.mob_name = real_name
	new_death.faction_name = faction
	new_death.is_xeno = FALSE
	new_death.area_name = area.name

	new_death.cause_name = cause_data?.cause_name
	var/datum/entity/player/cause_player = get_player_from_key(cause_data?.ckey)
	if(cause_player)
		new_death.cause_player_id = cause_player.id
	new_death.cause_role_name = cause_data?.role
	new_death.cause_faction_name = cause_data?.faction

	if(cause_mob)
		cause_mob.life_kills_total += life_value

	if(getBruteLoss())
		new_death.total_brute = floor(getBruteLoss())
	if(getFireLoss())
		new_death.total_burn = floor(getFireLoss())
	if(getOxyLoss())
		new_death.total_oxy = floor(getOxyLoss())
	if(getToxLoss())
		new_death.total_tox = floor(getToxLoss())

	new_death.time_of_death = world.time

	new_death.x = death_loc.x
	new_death.y = death_loc.y
	new_death.z = death_loc.z

	new_death.total_steps = life_steps_total
	new_death.total_kills = life_kills_total
	new_death.total_time_alive = life_time_total
	new_death.total_damage_taken = life_damage_taken_total
	new_death.total_revives_done = life_revives_total
	new_death.total_ib_fixed = life_ib_total

	if(GLOB.round_statistics)
		GLOB.round_statistics.track_death(new_death)

	new_death.save()
	return new_death

/mob/living/carbon/human/track_mob_death(datum/cause_data/cause_data, turf/death_loc)
	. = ..()
	if(statistic_exempt || !mind)
		return
	var/datum/entity/player_stats/human/human_stats = mind.setup_human_stats()
	if(human_stats && human_stats.death_list)
		human_stats.death_list.Insert(1, .)

/mob/living/carbon/xenomorph/track_mob_death(datum/cause_data/cause_data, turf/death_loc)
	var/datum/entity/statistic/death/new_death = ..()
	if(!new_death)
		return
	new_death.is_xeno = TRUE // this was placed beneath the if below, which meant gibbing as a xeno wouldn't track properly in stats
	if(statistic_exempt || !mind)
		return
	var/datum/entity/player_stats/xeno/xeno_stats = mind.setup_xeno_stats()
	if(xeno_stats && xeno_stats.death_list)
		xeno_stats.death_list.Insert(1, new_death)

/mob/proc/handle_observer_message(datum/cause_data/cause_data, mob/cause_mob, turf/death_loc, area/death_area)
	var/observer_message = "<b>[real_name]</b> has died"
	if(cause_data && cause_data.cause_name)
		observer_message += " to <b>[cause_data.cause_name]</b>"
	if(death_area.name)
		observer_message += " at \the <b>[death_area.name]</b>"
	if(cause_data && cause_mob)
		observer_message += " from <b>[cause_mob]</b>"

	msg_admin_attack(observer_message, death_loc.x, death_loc.y, death_loc.z)

	if(src)
		to_chat(src, SPAN_DEADSAY(observer_message))
	for(var/mob/dead/observer/g in GLOB.observer_list)
		to_chat(g, SPAN_DEADSAY("[observer_message] [OBSERVER_JMP(g, death_loc)]"))

/mob/living/carbon/xenomorph/handle_observer_message(datum/cause_data/cause_data, mob/cause_mob, turf/death_loc, area/death_area)
	if(hardcore)
		return
	return ..()
