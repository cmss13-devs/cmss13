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
// Something is wrong
#define DB_ENTITY_STATE_BROKEN -1
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
#define DB_FIELDTYPE_INT 1
#define DB_FIELDTYPE_BIGINT 2
#define DB_FIELDTYPE_CHAR 3 // 1 symbol
#define DB_FIELDTYPE_STRING_SMALL 4 // 16 symbols
#define DB_FIELDTYPE_STRING_MEDIUM 5 // 64 symbols
#define DB_FIELDTYPE_STRING_LARGE 6 // 256 symbols
#define DB_FIELDTYPE_STRING_MAX 7 // 4000 symbols
#define DB_FIELDTYPE_DATE 8
#define DB_FIELDTYPE_TEXT 9 // any amount of symbols but really inefficient
#define DB_FIELDTYPE_BLOB 10
#define DB_FIELDTYPE_DECIMAL 11

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