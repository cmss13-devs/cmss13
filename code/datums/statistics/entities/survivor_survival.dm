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

/datum/entity/survivor_survival/New()
	. = ..()
	round_id = GLOB.round_id || -1
	time_after_roundstart = floor((world.time - SSticker.mode.round_time_lobby) / 600)
	total_survivors = /datum/job/civilian/survivor::total_spawned
	for(var/mob/living/carbon/human/human as anything in GLOB.alive_human_list)
		if(QDELETED(human))
			continue

		if(issurvivorjob(human.job))
			remaining_survivors++
	xeno_deaths = GLOB.total_dead_xenos

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
	)
