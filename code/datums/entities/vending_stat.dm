/datum/entity/vending_stat
	var/round_id
	var/item
	var/source
	var/count

/datum/entity_meta/vending_stat
	entity_type = /datum/entity/vending_stat
	table_name = "vending_stat"
	field_types = list(
		"round_id" = DB_FIELDTYPE_BIGINT,
		"item" = DB_FIELDTYPE_STRING_LARGE,
		"source" = DB_FIELDTYPE_STRING_LARGE,
		"count" = DB_FIELDTYPE_BIGINT)

/datum/entity_link/round_to_vending_stat
	parent_entity = /datum/entity/mc_round
	child_entity = /datum/entity/vending_stat
	child_field = "round_id"
	parent_name = "round"
	child_name = "vending_stat"

/proc/vending_stat_bump(item_name, source_name, bump_by = 1)
	SSperf_logging.round.sync() // should be already synced but what if someone tries to vend stuff in first 5 seconds of game starting? takes almost no time if we already done
	var/round_id = SSperf_logging.round.id // get the round id
	DB_FILTER(/datum/entity/vending_stat, DB_AND( // find all records (hopefully just one)
		DB_COMP("item", DB_EQUALS, item_name), // about this item
		DB_COMP("source", DB_EQUALS, source_name), // from this source
		DB_COMP("round_id", DB_EQUALS, round_id)), // on this round
		CALLBACK(GLOBAL_PROC, .proc/vending_stat_callback, item_name, source_name, bump_by, round_id)) // call the thing when filter is done filtering

/proc/vending_stat_callback(item_name, source_name, bump_by, round_id, var/list/datum/entity/vending_stat/stats)
	var/result_length = length(stats)
	if(result_length  == 0) // haven't found an item
		var/datum/entity/vending_stat/WS = DB_ENTITY(/datum/entity/vending_stat) // this creates a new record
		WS.item = item_name
		WS.source = source_name
		WS.count = bump_by
		WS.round_id = round_id
		WS.save() // save it
		return // we are done here
	if(result_length > 1) // oh shit oh fuck our DB is bad, what the fuck
		log_debug("DATABASE: vending_stat result_length was larger than 1")
		return
	var/datum/entity/vending_stat/WS = stats[1] // we ensured this is the only item
	WS.count += bump_by // add the thing
	WS.save() // say we wanna save it