/datum/entity/survivor_survival
	/// Round ID that we're storing data on
	var/round_id
	/// How many minutes after roundstart we're recording this
	var/time_after_roundstart
	/// How many survivors there were this round total
	var/total_survivors
	/// How many survivors are currently alive
	var/remaining_survivors = 0
	/// How many xenos have died
	var/xeno_deaths
	/// How many players on when this point was recorded
	var/total_population
	/// The name of the map played when this point was recorded
	var/map_name

/datum/entity/survivor_survival/New()
	. = ..()
	round_id = GLOB.round_id || -1
	time_after_roundstart = floor((world.time - SSticker.mode.round_time_lobby) / 600)
	total_survivors = /datum/job/civilian/survivor::total_spawned
	for(var/datum/weakref/ref as anything in GLOB.spawned_survivors)
		var/mob/living/carbon/human/human = ref.resolve()
		if(!human || (human.stat == DEAD) || (human.status_flags & XENO_HOST))
			continue

		remaining_survivors++

	xeno_deaths = GLOB.total_dead_xenos
	total_population = length(GLOB.clients)
	map_name = SSmapping.configs[GROUND_MAP]?.map_name || "Unknown Map"

/datum/entity/survivor_survival/post_creation()
	save()

/datum/entity_meta/survivor_survival
	entity_type = /datum/entity/survivor_survival
	table_name = "survivor_survival"
	field_types = list(
		"round_id" = DB_FIELDTYPE_INT,
		"time_after_roundstart" = DB_FIELDTYPE_INT,
		"total_survivors" = DB_FIELDTYPE_INT,
		"remaining_survivors" = DB_FIELDTYPE_INT,
		"xeno_deaths" = DB_FIELDTYPE_INT,
		"total_population" = DB_FIELDTYPE_INT,
		"map_name" = DB_FIELDTYPE_STRING_MEDIUM,
	)
