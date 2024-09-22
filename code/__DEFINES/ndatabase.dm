// MIT License

// Copyright (c) 2020 Neth Iafin

// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:

// The above copyright notice and this permission notice shall be included in all
// copies or substantial portions of the Software.

// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
// SOFTWARE.
#define DB_ENTITY SSentity_manager.select
#define DB_EKEY SSentity_manager.select_by_key
#define DB_FILTER SSentity_manager.filter_then
#define DB_FILTER_LOCAL SSentity_manager.filter_local
#define DB_META SSentity_manager.tables
#define DB_VIEW SSentity_manager.view_meta
#define WAIT_DB_READY while(!SSentity_manager.ready) {stoplag();}

// MODIFY THESE TO ENABLE OR DISABLE DB ENGINES
#define NDATABASE_BSQL_SUPPORT TRUE
#define NDATABASE_RUSTG_BRSQL_SUPPORT TRUE


#define DB_LOCK_TIMEOUT 5 SECONDS
#define DB_RECHECK_TIMEOUT 1 SECONDS
#define DB_ENTITY_RECHECK_TIMEOUT 10
#define DB_ENTITY_MAX_CONNECTIONS 30
#define DB_ENTITY_USUAL_CONNECTIONS 20
#define DB_QUERY_RECHECK_TIMEOUT 1 //yes, just 0.1 of a second

#define DB_DEFAULT_ID_FIELD "id"

#define DB_ORDER_BY_DEFAULT 0
#define DB_ORDER_BY_ASC 1
#define DB_ORDER_BY_DESC 2

#define DB_CONNECTION_NOT_CONNECTED 0
#define DB_CONNECTION_BROKEN 1
#define DB_CONNECTION_READY 2
#define DB_CONNECTION_DELETED 3

#define DB_QUERY_STARTED 0
#define DB_QUERY_READING 1
#define DB_QUERY_FINISHED 2
#define DB_QUERY_BROKEN 3

//DB Entity State
//this CANNOT be bit-flag

// Something is wrong or entry is dead
#define DB_ENTITY_STATE_BROKEN -1
// We just requested this object from the pool and we didn't specify its ID,
// or we want to change only some fields (not recommended)
// this status is set when you try to select datum from DB
// if we set to this status from Synced, We suspect that outside forces changed this record.
// We want to discard any changes WE made
#define DB_ENTITY_STATE_DETACHED 0
// We properly requested this record, it was received from DB
// In this status we EXPECT that this datum is equivalent to whatever we have in database
#define DB_ENTITY_STATE_SYNCED 1
// We want to add this record to database.
// Record won't be added if datum has ID set to something other than null
#define DB_ENTITY_STATE_ADDED 2
// We want to update the record and move it to the database
#define DB_ENTITY_STATE_UPDATED 3
// We want to delete this record
#define DB_ENTITY_STATE_DELETED 4
// We are reading/writing about this record right now
#define DB_ENTITY_STATE_PROCESSING 5
// We want to add this record to database.
// But then we want to detach from this record
#define DB_ENTITY_STATE_ADD_DETACH 7
// We are unsure what is this animal. Does it exist? If it does, we add it. In any case, it should be handled somewhere else (in entity manager)
// Since this status is bigger than SYNCED, this means sync() will wait till someone handles it, which is exactly what we need
#define DB_ENTITY_STATE_ADD_OR_SELECT 8
// This is here because Neth is bad
// Basically new item, waiting for it to be read
#define DB_ENTITY_STATE_FRESH 9

//field types
#define DB_FIELDTYPE_INT /datum/db_field_type/int
#define DB_FIELDTYPE_BIGINT /datum/db_field_type/bigint
#define DB_FIELDTYPE_CHAR /datum/db_field_type/char
#define DB_FIELDTYPE_STRING_SMALL /datum/db_field_type/string/small
#define DB_FIELDTYPE_STRING_MEDIUM /datum/db_field_type/string/medium
#define DB_FIELDTYPE_STRING_LARGE /datum/db_field_type/string/large
#define DB_FIELDTYPE_STRING_MAX /datum/db_field_type/string/max
#define DB_FIELDTYPE_DATE /datum/db_field_type/date
#define DB_FIELDTYPE_TEXT /datum/db_field_type/text
#define DB_FIELDTYPE_BLOB /datum/db_field_type/blob
#define DB_FIELDTYPE_DECIMAL /datum/db_field_type/decimal

#define DB_EQUALS 0
#define DB_NOTEQUAL 1
#define DB_GREATER 2
#define DB_LESS 3
#define DB_GREATER_EQUAL 4
#define DB_LESS_EQUAL 5
#define DB_IS 6 // is null
#define DB_ISNOT 7 // is not null
#define DB_IN 8
#define DB_NOTIN 9

// list of hints for indexes

// this is cluster index. This means that this index sets the default order of the table
// if there are more than one cluster index on the table, you won't be able to start the app
#define DB_INDEXHINT_CLUSTER 1

// this is unique index. This means that if you try to add a record with same values for this set of fields
// it will fail
#define DB_INDEXHINT_UNIQUE 2

// list of hints for tables

// This table is for local filtering only. Use for logs that you want to query this round
#define DB_TABLEHINT_LOCAL 1

#define DB_AND new /datum/db/filter/and
#define DB_OR new /datum/db/filter/or
#define DB_COMP new /datum/db/filter/comparison
#define DB_COMP2 new /datum/db/filter/compare_two

// Interface for setting up entities to replace the boilerplate
/// Define an entity in database and corresponding table to store them in.
/// Can also define not part of DB-schema here (akin to SUBSYSTEM_DEF define).
#define DEFINE_ENTITY(entity, table_name) \
/datum/db_field/##entity; \
/datum/entity/##entity/field_type = /datum/db_field/##name; \
/datum/entity_meta/##entity/entity_type = /datum/entity/##name; \
/datum/entity_meta/##entity/table_name = table_name; \
/datum/entity/##entity

/**
 * FIELD_{TYPE}(entity, field) \
 * Defines a field of type TYPE on the entity passed to the define
 *
 * First add the field as a variable on the entity object.
 * Then add the field and its type to the entity schema stored in the
 * entity's associated metadata singleton.
 */

/**
 * FIELD_DEFAULT_VALUE_{TYPE}(entity, field, default) \
 * Same as corresponding FIELD_{TYPE} define, but passes a default value
 * to the entity's field on the field's initialization. Occurs on initialization
 * to allow for runtime-calculated values to be passed to the field.
 */

#define FIELD_INT(entity, field) \
/datum/db_field/##entity/##field{ name = #field; field_type = DB_FIELDTYPE_INT; parent_entity_type = /datum/entity/##entity; }; \
/datum/entity/##entity/var/datum/db_field/##entity/##field/##field; \
/datum/entity_meta/##entity/setup_field_types() { \
	..(); \
	LAZYSET(field_types, #field, /datum/db_field/##entity/##field); \
}
#define FIELD_DEFAULT_VALUE_INT(entity, field, default) \
/datum/db_field/##entity/##field{ name = #field; field_type = DB_FIELDTYPE_INT; parent_entity_type = /datum/entity/##entity; }; \
/datum/db_field/##entity/##field/New() { . = ..(); value = default; } \
/datum/entity/##entity/var/datum/db_field/##entity/##field/##field; \
/datum/entity_meta/##entity/setup_field_types() { \
	..(); \
	LAZYSET(field_types, #field, /datum/db_field/##entity/##field); \
}

#define FIELD_BIGINT(entity, field) \
/datum/db_field/##entity/##field{ name = #field; field_type = DB_FIELDTYPE_BIGINT; parent_entity_type = /datum/entity/##entity; }; \
/datum/entity/##entity/var/datum/db_field/##entity/##field/##field; \
/datum/entity_meta/##entity/setup_field_types() { \
	..(); \
	LAZYSET(field_types, #field, /datum/db_field/##entity/##field); \
}
#define FIELD_DEFAULT_VALUE_BIGINT(entity, field, default) \
/datum/db_field/##entity/##field{ name = #field; field_type = DB_FIELDTYPE_BIGINT; parent_entity_type = /datum/entity/##entity; }; \
/datum/db_field/##entity/##field/New() { . = ..(); value = default; } \
/datum/entity/##entity/var/datum/db_field/##entity/##field/##field; \
/datum/entity_meta/##entity/setup_field_types() { \
	..(); \
	LAZYSET(field_types, #field, /datum/db_field/##entity/##field); \
}

#define FIELD_CHAR(entity, field) \
/datum/db_field/##entity/##field{ name = #field; field_type = DB_FIELDTYPE_CHAR; parent_entity_type = /datum/entity/##entity; }; \
/datum/entity/##entity/var/datum/db_field/##entity/##field/##field; \
/datum/entity_meta/##entity/setup_field_types() { \
	..(); \
	LAZYSET(field_types, #field, /datum/db_field/##entity/##field); \
}
#define FIELD_DEFAULT_VALUE_CHAR(entity, field, default) \
/datum/db_field/##entity/##field{ name = #field; field_type = DB_FIELDTYPE_CHAR; parent_entity_type = /datum/entity/##entity; }; \
/datum/db_field/##entity/##field/New() { . = ..(); value = default; } \
/datum/entity/##entity/var/datum/db_field/##entity/##field/##field; \
/datum/entity_meta/##entity/setup_field_types() { \
	..(); \
	LAZYSET(field_types, #field, /datum/db_field/##entity/##field); \
}

#define FIELD_STRING_SMALL(entity, field) \
/datum/db_field/##entity/##field{ name = #field; field_type = DB_FIELDTYPE_STRING_SMALL; parent_entity_type = /datum/entity/##entity; }; \
/datum/entity/##entity/var/datum/db_field/##entity/##field/##field; \
/datum/entity_meta/##entity/setup_field_types() { \
	..(); \
	LAZYSET(field_types, #field, /datum/db_field/##entity/##field); \
}
#define FIELD_DEFAULT_VALUE_STRING_SMALL(entity, field, default) \
/datum/db_field/##entity/##field{ name = #field; field_type = DB_FIELDTYPE_STRING_SMALL; parent_entity_type = /datum/entity/##entity; }; \
/datum/db_field/##entity/##field/New() { . = ..(); value = default; } \
/datum/entity/##entity/var/datum/db_field/##entity/##field/##field; \
/datum/entity_meta/##entity/setup_field_types() { \
	..(); \
	LAZYSET(field_types, #field, /datum/db_field/##entity/##field); \
}

#define FIELD_STRING_MEDIUM(entity, field) \
/datum/db_field/##entity/##field{ name = #field; field_type = DB_FIELDTYPE_STRING_MEDIUM; parent_entity_type = /datum/entity/##entity; }; \
/datum/entity/##entity/var/datum/db_field/##entity/##field/##field; \
/datum/entity_meta/##entity/setup_field_types() { \
	..(); \
	LAZYSET(field_types, #field, /datum/db_field/##entity/##field); \
}
#define FIELD_DEFAULT_VALUE_STRING_MEDIUM(entity, field, default) \
/datum/db_field/##entity/##field{ name = #field; field_type = DB_FIELDTYPE_STRING_MEDIUM; parent_entity_type = /datum/entity/##entity; }; \
/datum/db_field/##entity/##field/New() { . = ..(); value = default; } \
/datum/entity/##entity/var/datum/db_field/##entity/##field/##field; \
/datum/entity_meta/##entity/setup_field_types() { \
	..(); \
	LAZYSET(field_types, #field, /datum/db_field/##entity/##field); \
}

#define FIELD_STRING_LARGE(entity, field) \
/datum/db_field/##entity/##field{ name = #field; field_type = DB_FIELDTYPE_STRING_LARGE; parent_entity_type = /datum/entity/##entity; }; \
/datum/entity/##entity/var/datum/db_field/##entity/##field/##field; \
/datum/entity_meta/##entity/setup_field_types() { \
	..(); \
	LAZYSET(field_types, #field, /datum/db_field/##entity/##field); \
}
#define FIELD_DEFAULT_VALUE_STRING_LARGE(entity, field, default) \
/datum/db_field/##entity/##field{ name = #field; field_type = DB_FIELDTYPE_STRING_LARGE; parent_entity_type = /datum/entity/##entity; }; \
/datum/db_field/##entity/##field/New() { . = ..(); value = default; } \
/datum/entity/##entity/var/datum/db_field/##entity/##field/##field; \
/datum/entity_meta/##entity/setup_field_types() { \
	..(); \
	LAZYSET(field_types, #field, /datum/db_field/##entity/##field); \
}

#define FIELD_STRING_MAX(entity, field) \
/datum/db_field/##entity/##field{ name = #field; field_type = DB_FIELDTYPE_STRING_MAX; parent_entity_type = /datum/entity/##entity; }; \
/datum/entity/##entity/var/datum/db_field/##entity/##field/##field; \
/datum/entity_meta/##entity/setup_field_types() { \
	..(); \
	LAZYSET(field_types, #field, /datum/db_field/##entity/##field); \
}
#define FIELD_DEFAULT_VALUE_STRING_MAX(entity, field, default) \
/datum/db_field/##entity/##field{ name = #field; field_type = DB_FIELDTYPE_STRING_MAX; parent_entity_type = /datum/entity/##entity; }; \
/datum/db_field/##entity/##field/New() { . = ..(); value = default; } \
/datum/entity/##entity/var/datum/db_field/##entity/##field/##field; \
/datum/entity_meta/##entity/setup_field_types() { \
	..(); \
	LAZYSET(field_types, #field, /datum/db_field/##entity/##field); \
}

#define FIELD_DATE(entity, field) \
/datum/db_field/##entity/##field{ name = #field; field_type = DB_FIELDTYPE_DATE; parent_entity_type = /datum/entity/##entity; }; \
/datum/entity/##entity/var/datum/db_field/##entity/##field/##field; \
/datum/entity_meta/##entity/setup_field_types() { \
	..(); \
	LAZYSET(field_types, #field, /datum/db_field/##entity/##field); \
}
#define FIELD_DEFAULT_VALUE_DATE(entity, field, default) \
/datum/db_field/##entity/##field{ name = #field; field_type = DB_FIELDTYPE_DATE; parent_entity_type = /datum/entity/##entity; }; \
/datum/db_field/##entity/##field/New() { . = ..(); value = default; } \
/datum/entity/##entity/var/datum/db_field/##entity/##field/##field; \
/datum/entity_meta/##entity/setup_field_types() { \
	..(); \
	LAZYSET(field_types, #field, /datum/db_field/##entity/##field); \
}

#define FIELD_TEXT(entity, field) \
/datum/db_field/##entity/##field{ name = #field; field_type = DB_FIELDTYPE_TEXT; parent_entity_type = /datum/entity/##entity; }; \
/datum/entity/##entity/var/datum/db_field/##entity/##field/##field; \
/datum/entity_meta/##entity/setup_field_types() { \
	..(); \
	LAZYSET(field_types, #field, /datum/db_field/##entity/##field); \
}
#define FIELD_DEFAULT_VALUE_TEXT(entity, field, default) \
/datum/db_field/##entity/##field{ name = #field; field_type = DB_FIELDTYPE_TEXT; parent_entity_type = /datum/entity/##entity; }; \
/datum/db_field/##entity/##field/New() { . = ..(); value = default; } \
/datum/entity/##entity/var/datum/db_field/##entity/##field/##field; \
/datum/entity_meta/##entity/setup_field_types() { \
	..(); \
	LAZYSET(field_types, #field, /datum/db_field/##entity/##field); \
}

#define FIELD_BLOB(entity, field) \
/datum/db_field/##entity/##field{ name = #field; field_type = DB_FIELDTYPE_BLOB; parent_entity_type = /datum/entity/##entity; }; \
/datum/entity/##entity/var/datum/db_field/##entity/##field/##field; \
/datum/entity_meta/##entity/setup_field_types() { \
	..(); \
	LAZYSET(field_types, #field, /datum/db_field/##entity/##field); \
}
#define FIELD_DEFAULT_VALUE_BLOB(entity, field, default) \
/datum/db_field/##entity/##field{ name = #field; field_type = DB_FIELDTYPE_BLOB; parent_entity_type = /datum/entity/##entity; }; \
/datum/db_field/##entity/##field/New() { . = ..(); value = default; } \
/datum/entity/##entity/var/datum/db_field/##entity/##field/##field; \
/datum/entity_meta/##entity/setup_field_types() { \
	..(); \
	LAZYSET(field_types, #field, /datum/db_field/##entity/##field); \
}

#define FIELD_DECIMAL(entity, field) \
/datum/db_field/##entity/##field{ name = #field; field_type = DB_FIELDTYPE_DECIMAL; parent_entity_type = /datum/entity/##entity; }; \
/datum/entity/##entity/var/datum/db_field/##entity/##field/##field; \
/datum/entity_meta/##entity/setup_field_types() { \
	..(); \
	LAZYSET(field_types, #field, /datum/db_field/##entity/##field); \
}
#define FIELD_DEFAULT_VALUE_DECIMAL(entity, field, default) \
/datum/db_field/##entity/##field{ name = #field; field_type = DB_FIELDTYPE_DECIMAL; parent_entity_type = /datum/entity/##entity; }; \
/datum/db_field/##entity/##field/New() { . = ..(); value = default; } \
/datum/entity/##entity/var/datum/db_field/##entity/##field/##field; \
/datum/entity_meta/##entity/setup_field_types() { \
	..(); \
	LAZYSET(field_types, #field, /datum/db_field/##entity/##field); \
}

/// Defines an entity link where `child_entity` refers to `parent_entity` through its column `foreign_key`.
/// `foreign_key` should NOT be a string but instead the actual foreign key field type.
#define DEFINE_ENTITY_LINK(parent_entity, child_entity, foreign_key) \
/datum/controller/subsytem/entity_manager/get_entity_links(list/datum/entity_link/entity_links) { \
	..(); \
	entity_links += new /datum/entity_link(parent_entity, child_entity, foreign_key); \
}
