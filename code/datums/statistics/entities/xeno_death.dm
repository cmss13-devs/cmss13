/datum/entity/xeno_death
	/// What map this death happened on
	var/map_name
	/// X coord of the death
	var/x
	/// Y coord of the death
	var/y
	/// Z coord of the death
	var/z
	/// What minute this death happened at, rounded down
	var/death_minute
	/// What hive this xeno was in
	var/hive
	/// What caste this xeno was
	var/caste
	/// What strain this xeno was, if any
	var/strain
	/// If this xeno was a leader or not
	var/leader = FALSE
	/// How many minutes the xeno had been alive for, rounded down
	var/minutes_alive
	/// Ckey of the player who died
	var/ckey
	/// How much damage this xeno took before dying
	var/damage_taken

/datum/entity/xeno_death/New(mob/living/carbon/xenomorph/dead_xeno)
	. = ..()
	map_name = SSmapping.configs[GROUND_MAP]?.map_name
	x = dead_xeno.x
	y = dead_xeno.y
	z = dead_xeno.z
	death_minute = floor((world.time * 0.1) / 60)
	hive = dead_xeno.hive.name
	caste = dead_xeno.caste.caste_type
	strain = dead_xeno.strain?.name || "None"
	leader = (dead_xeno in dead_xeno.hive.xeno_leader_list)
	minutes_alive = floor((dead_xeno.creation_time * 0.1) / 60)
	ckey = dead_xeno.ckey || dead_xeno.persistent_ckey || ""
	damage_taken = dead_xeno.life_damage_taken_total

	SSticker?.mode?.round_stats?.xeno_deaths += src
	save()

/datum/entity_meta/xeno_death
	entity_type = /datum/entity/xeno_death
	table_name = "xeno_deaths"
	field_types = list(
		"map_name" = DB_FIELDTYPE_STRING_MEDIUM,
		"x" = DB_FIELDTYPE_INT,
		"y" = DB_FIELDTPYE_INT,
		"z" = DB_FIELDTYPE_INT,
		"death_minute" = DB_FIELDTYPE_INT,
		"hive" = DB_FIELDTYPE_STRING_MEDIUM,
		"caste" = DB_FIELDTYPE_STRING_MEDIUM,
		"strain" = DB_FIELDTYPE_STRING_MEDIUM,
		"leader" = DB_FIELDTYPE_INT,
		"minutes_alive" = DB_FIELDTYPE_INT,
		"ckey" = DB_FIELDTYPE_STRING_MEDIUM,
		"damage_taken" = DB_FIELDTYPE_INT
	)
