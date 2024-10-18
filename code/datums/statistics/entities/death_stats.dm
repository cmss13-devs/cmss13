/datum/entity/statistic_death
	var/player_id
	var/round_id

	var/role_name
	var/faction_name
	var/mob_name
	var/area_name

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

BSQL_PROTECT_DATUM(/datum/entity/statistic_death)

/datum/entity/statistic_death/Destroy()
	if(GLOB.round_statistics)
		GLOB.round_statistics.death_stats_list -= new_death

	. = ..()

/datum/entity_meta/statistic_death
	entity_type = /datum/entity/statistic_death
	table_name = "player_statistic_death"
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
		"z" = DB_FIELDTYPE_INT,
	)

/datum/view_record/statistic_death
	var/player_id
	var/round_id

	var/role_name
	var/faction_name
	var/mob_name
	var/area_name

	var/cause_name
	var/cause_player_id
	var/cause_role_name
	var/cause_faction_name

	var/total_steps = 0
	var/total_kills = 0
	var/time_of_death
	var/total_time_alive

	var/total_brute = 0
	var/total_burn = 0
	var/total_oxy = 0
	var/total_tox = 0

	var/x
	var/y
	var/z

/datum/entity_view_meta/statistic_death_ordered
	root_record_type = /datum/entity/statistic_death
	destination_entity = /datum/view_record/statistic_death
	fields = list(
		"player_id",
		"round_id",

		"role_name",
		"faction_name",
		"mob_name",
		"area_name",

		"cause_name",
		"cause_player_id",
		"cause_role_name",
		"cause_faction_name",

		"total_steps",
		"total_kills",
		"time_of_death",
		"total_time_alive",

		"total_brute",
		"total_burn",
		"total_oxy",
		"total_tox",

		"x",
		"y",
		"z",
	)
	order_by = list("round_id" = DB_ORDER_BY_DESC)

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

	if(statistic_exempt)
		return

	var/area/area = get_area(death_loc)
	handle_observer_message(cause_data, cause_mob, death_loc, area)

	var/datum/entity/statistic_death/new_death = DB_ENTITY(/datum/entity/statistic_death)
	var/datum/entity/player/player_entity = get_player_from_key(mind ? mind.ckey : ckey)
	if(player_entity)
		new_death.player_id = player_entity.id

	new_death.round_id = SSperf_logging.round?.id

	new_death.role_name = get_role_name()
	new_death.mob_name = real_name
	new_death.faction_name = faction

	new_death.area_name = area.name

	new_death.cause_name = cause_data?.cause_name
	var/datum/entity/player/cause_player = get_player_from_key(cause_data?.ckey)
	if(cause_player)
		new_death.cause_player_id = cause_player.id
	new_death.cause_role_name = cause_data?.role
	new_death.cause_faction_name = cause_data?.faction

	if(cause_mob)
		cause_mob.life_kills_total += life_value

//RUCM START
		SEND_SIGNAL(cause_mob, COMSIG_MOB_KILL_TOTAL_INCREASED, src, cause_data)
//RUCM END

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

	var/ff_type = new_death.cause_faction_name == new_death.faction_name ? 1 : 0
	if(GLOB.round_statistics)
		GLOB.round_statistics.track_dead_participant(new_death.faction_name)
		if(ff_type)
			GLOB.round_statistics.total_friendly_kills++

	if(cause_player)
		if(isxeno(cause_mob))
			track_statistic_earned(new_death.cause_faction_name, STATISTIC_TYPE_CASTE, new_death.cause_role_name, ff_type ? STATISTICS_KILL_FF : STATISTICS_KILL, 1, cause_player)
		else if(ishuman(cause_mob))
			track_statistic_earned(new_death.cause_faction_name, STATISTIC_TYPE_JOB, new_death.cause_role_name, ff_type ? STATISTICS_KILL_FF : STATISTICS_KILL, 1, cause_player)
			if(new_death.cause_role_name)
				track_statistic_earned(new_death.cause_faction_name, STATISTIC_TYPE_WEAPON, new_death.cause_role_name, ff_type ? STATISTICS_KILL_FF : STATISTICS_KILL, 1, cause_player)

	if(player_entity)
		if(isxeno(src))
			track_statistic_earned(new_death.faction_name, STATISTIC_TYPE_CASTE, new_death.role_name, ff_type ? STATISTICS_DEATH_FF : STATISTICS_DEATH, 1, player_entity)
		else if(ishuman(src))
			track_statistic_earned(new_death.faction_name, STATISTIC_TYPE_JOB, new_death.cause_name, ff_type ? STATISTICS_DEATH_FF : STATISTICS_DEATH, 1, player_entity)

	if(GLOB.round_statistics)
		GLOB.round_statistics.death_stats_list += new_death

	new_death.save()
	new_death.detach()
	return new_death

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
