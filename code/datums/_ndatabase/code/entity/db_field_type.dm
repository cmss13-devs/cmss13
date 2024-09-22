/// Should be TRUE for everything but interface parent types
/datum/db_field_type
	var/valid = FALSE

/datum/db_field_type/int
	valid = TRUE

/datum/db_field_type/bigint
	valid = TRUE

/// Field that allows only 1 symbol
/datum/db_field_type/char
	valid = TRUE

/datum/db_field_type/string
	valid = FALSE

/// Field that allows 16 symbols
/datum/db_field_type/string/small
	valid = TRUE

/// Field that allows 64 symbols
/datum/db_field_type/string/medium
	valid = TRUE

/// Field that allows 256 symbols
/datum/db_field_type/string/large
	valid = TRUE

/// Field that allows 4000 symbols
/datum/db_field_type/string/max
	valid = TRUE

/datum/db_field_type/date
	valid = TRUE

/// Field that allows any amount of symbols but really inefficient
/datum/db_field_type/text
	valid = TRUE

/datum/db_field_type/blob
	valid = TRUE

/datum/db_field_type/decimal
	valid = TRUE
