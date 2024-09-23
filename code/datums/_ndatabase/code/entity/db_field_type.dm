// These IDs must be sequential and MUST maintain order specified here. Can add more types if needed but the type ID needs to be incremented.
#define TYPE_ID_INT 1
#define TYPE_ID_BIGINT 2
#define TYPE_ID_CHAR 3
#define TYPE_ID_STRING_SMALL 4
#define TYPE_ID_STRING_MEDIUM 5
#define TYPE_ID_STRING_LARGE 6
#define TYPE_ID_STRING_MAX 7
#define TYPE_ID_DATE 8
#define TYPE_ID_TEXT 9
#define TYPE_ID_BLOB 10
#define TYPE_ID_DECIMAL 11

/// A standard list where each index is mapped to a specific DB field type
/// by the field type's `type_id` var.
GLOBAL_LIST_INIT(db_field_types, setup_db_field_types())

/proc/setup_db_field_types()
	var/list/result = list()
	for (var/datum/db_field_type/field_type in subtypesof(/datum/db_field_type))
		if (!field_type::valid)
			continue
		var/type_id = field_type::type_id
		if (length(result) < type_id)
			result.len = type_id
		result[type_id] = field_type
	return result

/datum/db_field_type
	/// Should be TRUE for everything but interface parent types
	var/valid = FALSE
	var/type_id

/datum/db_field_type/int
	valid = TRUE
	type_id = TYPE_ID_INT

/datum/db_field_type/bigint
	valid = TRUE
	type_id = TYPE_ID_BIGINT

/// Field that allows only 1 symbol
/datum/db_field_type/char
	valid = TRUE
	type_id = TYPE_ID_CHAR

/datum/db_field_type/string
	valid = FALSE

/// Field that allows 16 symbols
/datum/db_field_type/string/small
	valid = TRUE
	type_id = TYPE_ID_STRING_SMALL

/// Field that allows 64 symbols
/datum/db_field_type/string/medium
	valid = TRUE
	type_id = TYPE_ID_STRING_MEDIUM

/// Field that allows 256 symbols
/datum/db_field_type/string/large
	valid = TRUE
	type_id = TYPE_ID_STRING_LARGE

/// Field that allows 4000 symbols
/datum/db_field_type/string/max
	valid = TRUE
	type_id = TYPE_ID_STRING_MAX

/datum/db_field_type/date
	valid = TRUE
	type_id = TYPE_ID_DATE

/// Field that allows any amount of symbols but really inefficient
/datum/db_field_type/text
	valid = TRUE
	type_id = TYPE_ID_TEXT

/datum/db_field_type/blob
	valid = TRUE
	type_id = TYPE_ID_BLOB

/datum/db_field_type/decimal
	valid = TRUE
	type_id = TYPE_ID_DECIMAL

#undef TYPE_ID_INT
#undef TYPE_ID_BIGINT
#undef TYPE_ID_CHAR
#undef TYPE_ID_STRING_SMALL
#undef TYPE_ID_STRING_MEDIUM
#undef TYPE_ID_STRING_LARGE
#undef TYPE_ID_STRING_MAX
#undef TYPE_ID_DATE
#undef TYPE_ID_TEXT
#undef TYPE_ID_BLOB
#undef TYPE_ID_DECIMAL
