/datum/db_field
	/// The name of the field on the DB, should only contain lowercase letters and underscores.
	var/name
	/// The type on the DB, should be a subtype of /datum/db_field_type (see: `__DEFINES/ndatabase.dm`).
	var/field_type
	/// The actual value of the field (not necessarily persisted to DB)
	var/value
	/// The typepath of the entity datum that holds the field
	var/parent_entity_type
