/datum/entity/mc_timing_info
	var/round_id
	var/round_time
	var/client_count
	var/human_count
	var/xeno_count
	var/total_time_taken

/datum/entity_meta/mc_timing_info
	entity_type = /datum/entity/mc_timing_info
	table_name = "mc_timing_info"
	field_types = list(
			"round_id"=DB_FIELDTYPE_BIGINT,
			"round_time"=DB_FIELDTYPE_INT,
			"client_count"=DB_FIELDTYPE_INT,
			"human_count"=DB_FIELDTYPE_INT,
			"xeno_count"=DB_FIELDTYPE_INT,
			"total_time_taken"=DB_FIELDTYPE_BIGINT
		)
