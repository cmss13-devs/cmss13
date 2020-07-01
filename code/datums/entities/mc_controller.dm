/datum/entity/mc_controller
	var/controller_type
	var/wait_time

/datum/entity_meta/mc_controller
	entity_type = /datum/entity/mc_controller
	table_name = "mc_controller"
	key_field = "controller_type"
	field_types = list(
			"controller_type"=DB_FIELDTYPE_STRING_LARGE,
			"wait_time"=DB_FIELDTYPE_INT
		)
