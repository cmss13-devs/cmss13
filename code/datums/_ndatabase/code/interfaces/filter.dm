/datum/db/filter

/datum/db/filter/and
	var/datum/db/filter/subfilters

/datum/db/filter/and/New()
	subfilters = args

/datum/db/filter/or
	var/datum/db/filter/subfilters

/datum/db/filter/or/New()
	subfilters = args

/datum/db/filter/comparison
	var/field
	var/operator
	var/value

/datum/db/filter/comparison/New(_field, op, _value)
	field = _field
	operator = op
	value = _value

#define DB_AND new /datum/db/filter/and
#define DB_OR new /datum/db/filter/or
#define DB_COMP new /datum/db/filter/comparison