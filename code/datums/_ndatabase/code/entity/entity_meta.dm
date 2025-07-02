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
/datum/entity_meta
	var/entity_type
	var/table_name
	var/list/field_types
	var/active_entity = TRUE
	var/key_field = null

	// bitwise hint field
	var/hints = 0

	var/list/datum/db/index/indexes

	var/list/datum/entity/managed
	var/list/datum/entity/key_managed
	var/list/datum/entity/to_read
	var/list/datum/entity/to_insert
	var/list/datum/entity/to_update
	var/list/datum/entity/to_delete
	var/list/datum/entity/inserting

	var/list/datum/entity_link/inbound_links
	var/list/datum/entity_link/outbound_links

/datum/entity_meta/New()
	managed = list()
	to_read = list()
	to_insert = list()
	to_update = list()
	to_delete = list()
	inserting = list()
	key_managed = list()
	inbound_links = list()
	outbound_links = list()

// redefine this for faster operations
/datum/entity_meta/proc/map(datum/entity/ET, list/values)
	var/strid = "[values[DB_DEFAULT_ID_FIELD]]"
	ET.id = strid
	for(var/F in field_types)
		ET.vars[F] = values[F]

// redefine this for faster operations
/datum/entity_meta/proc/unmap(datum/entity/ET, include_id = TRUE)
	var/list/values = list()
	if(include_id)
		values[DB_DEFAULT_ID_FIELD] = ET.id
	for(var/F in field_types)
		values[F] = ET.vars[F]
	return values

/datum/entity_meta/proc/make_new(id = null, invalidate = TRUE)
	var/strid = "[id]"
	if(managed[strid])
		return managed[strid]
	var/datum/entity/ET = new entity_type()
	ET.metadata = src
	if(id)
		ET.id = text2num(id)
		managed[strid] = ET
		if(invalidate)
			ET.invalidate()

	ET.post_creation()

	return ET

/datum/entity_meta/proc/make_new_by_key(key_value)
	if(!key_field)
		CRASH("Attempted to create entity on table without key field. Entity is [type]")
	if(!key_value)
		CRASH("Attempted to create entity without ley value. Entity is [type]")
	var/strval = "[key_value]"
	if(key_managed[strval])
		return key_managed[strval]
	var/datum/entity/ET = new entity_type()
	ET.metadata = src
	ET.vars[key_field] = key_value
	key_managed[strval] = ET
	return ET

/datum/entity_meta/proc/on_read(datum/entity/ET)
	return

/datum/entity_meta/proc/on_update(datum/entity/ET)
	return

/datum/entity_meta/proc/on_insert(datum/entity/ET)
	return

/datum/entity_meta/proc/on_action(datum/entity/ET)
	return

/datum/entity_meta/proc/on_delete(datum/entity/ET)
	qdel(ET)
	return

/datum/entity_meta/proc/filter_list(list/datum/entity/EL, datum/db/filter/F)
	var/list/results = list()
	for(var/item in EL)
		if(get_filter(item, F))
			results.Add(item)
	return results

/datum/entity_meta/proc/filter_assoc_list(list/datum/entity/EL, datum/db/filter/F)
	var/list/results = list()
	for(var/item in EL)
		if(get_filter(EL[item], F))
			results.Add(EL[item])
	return results

/datum/entity_meta/proc/get_filter_comparison(datum/entity/E, datum/db/filter/comparison/filter)
	switch(filter.operator)
		if(DB_EQUALS)
			return E.vars[filter.field] == filter.value
		if(DB_NOTEQUAL)
			return E.vars[filter.field] != filter.value
		if(DB_GREATER)
			return E.vars[filter.field] > filter.value
		if(DB_LESS)
			return E.vars[filter.field] < filter.value
		if(DB_GREATER_EQUAL)
			return E.vars[filter.field] >= filter.value
		if(DB_LESS_EQUAL)
			return E.vars[filter.field] <= filter.value
		if(DB_IS)
			return E.vars[filter.field] == null
		if(DB_ISNOT)
			return E.vars[filter.field] != null
		if(DB_IN)
			var/list/values = filter.value
			return values.Find(E.vars[filter.field]) > 0
		if(DB_NOTIN)
			var/list/values = filter.value
			return values.Find(E.vars[filter.field]) == 0
	return TRUE // shunt

/datum/entity_meta/proc/get_filter_and(datum/entity/E, datum/db/filter/and/filter)
	for(var/item in filter.subfilters)
		if(!get_filter(E, item))
			return FALSE
	return TRUE

/datum/entity_meta/proc/get_filter_or(datum/entity/E, datum/db/filter/or/filter)
	for(var/item in filter.subfilters)
		if(get_filter(E, item))
			return TRUE
	return FALSE

/datum/entity_meta/proc/get_filter(datum/entity/E, datum/db/filter/filter)
	if(istype(filter,/datum/db/filter/and))
		return get_filter_and(E,filter)
	if(istype(filter,/datum/db/filter/or))
		return get_filter_or(E,filter)
	if(istype(filter,/datum/db/filter/comparison))
		return get_filter_comparison(E,filter)
	return TRUE
