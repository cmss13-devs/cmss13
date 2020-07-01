/datum/entity/mc_record
	var/round_time
	var/round_id
	var/controller_id
	var/time_taken

/datum/entity_meta/mc_record
	entity_type = /datum/entity/mc_record
	table_name = "mc_record"
	field_types = list("round_time"=DB_FIELDTYPE_BIGINT,
			"round_id"=DB_FIELDTYPE_BIGINT,
			"controller_id"=DB_FIELDTYPE_BIGINT,
			"time_taken"=DB_FIELDTYPE_INT
		)
