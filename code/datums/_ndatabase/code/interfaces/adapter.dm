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
/datum/db/adapter

/datum/db/adapter/proc/sync_table_meta()
	return

/datum/db/adapter/proc/sync_table(type_name, table_name, var/list/field_types)
	return

/datum/db/adapter/proc/read_table(table_name, var/list/ids, var/datum/callback/CB, sync=FALSE)
	return

/datum/db/adapter/proc/update_table(table_name, var/list/values, var/datum/callback/CB, sync=FALSE)
	return

/datum/db/adapter/proc/insert_table(table_name, var/list/values, var/datum/callback/CB, sync=FALSE)
	return

/datum/db/adapter/proc/delete_table(table_name, var/list/ids, var/datum/callback/CB, sync=FALSE)
	return

/datum/db/adapter/proc/read_filter(table_name, var/datum/db/filter, var/datum/callback/CB, sync=FALSE)
	return

/datum/db/adapter/proc/prepare_view(var/datum/entity_view_meta/view)
	return

/datum/db/adapter/proc/read_view(var/datum/entity_view_meta/view, var/datum/db/filter/filter, var/datum/callback/CB, sync=FALSE)
	return


// DEFAULT IMPLEMENTATIONS
// DO NOT USE EXCEPT IN ADAPTER CODE

/datum/db/adapter/proc/get_filter_comparison(var/datum/db/filter/comparison/filter, var/list/casts, var/list/pflds)
	var/field_cast = "[filter.field]"
	if(casts && casts[field_cast])
		field_cast = casts[field_cast]
	switch(filter.operator)
		if(DB_EQUALS)
			pflds.Add("[filter.value]")
			return "[field_cast] = ?"
		if(DB_NOTEQUAL)
			pflds.Add("[filter.value]")
			return "[field_cast] <> ?"
		if(DB_GREATER)
			pflds.Add("[filter.value]")
			return "[field_cast] > ?"
		if(DB_LESS)
			pflds.Add("[filter.value]")
			return "[field_cast] < ?"
		if(DB_GREATER_EQUAL)
			pflds.Add("[filter.value]")
			return "[field_cast] >= ?"
		if(DB_LESS_EQUAL)
			pflds.Add("[filter.value]")
			return "[field_cast] <= ?"
		if(DB_IS)
			return "[field_cast] IS NULL"
		if(DB_ISNOT)
			return "[field_cast] IS NOT NULL"
		if(DB_IN)
			var/text = ""
			var/first = TRUE
			for(var/item in filter.value)
				if(!first)
					text += ","
				pflds.Add("[item]")
				text += "?"
				first = FALSE
			return "[field_cast] IN ([text])"
		if(DB_NOTIN)
			var/text = ""
			var/first = TRUE
			for(var/item in filter.value)
				if(!first)
					text += ","
				pflds.Add("[item]")
				text += "?"
				first = FALSE
			return "[field_cast] NOTIN ([text])"
	return "1=1" // shunt

/datum/db/adapter/proc/get_filter_comparetwo(var/datum/db/filter/compare_two/filter, var/list/casts, var/list/pflds)
	var/field1_cast = "[filter.field1]"
	if(casts && casts[field1_cast])
		field1_cast = casts[field1_cast]
	var/field2_cast = "[filter.field2]"
	if(casts && casts[field2_cast])
		field2_cast = casts[field2_cast]
	switch(filter.operator)
		if(DB_EQUALS)
			return "[field1_cast] = [field2_cast]"
		if(DB_NOTEQUAL)
			return "[field1_cast] <> [field2_cast]"
		if(DB_GREATER)
			return "[field1_cast] > [field2_cast]"
		if(DB_LESS)
			return "[field1_cast] < [field2_cast]"
		if(DB_GREATER_EQUAL)
			return "[field1_cast] >= [field2_cast]"
		if(DB_LESS_EQUAL)
			return "[field1_cast] <= [field2_cast]"
	return "1=1" // shunt

/datum/db/adapter/proc/get_filter_and(var/datum/db/filter/and/filter, var/list/casts, var/list/pflds)
	var/first = TRUE
	var/text = ""
	for(var/item in filter.subfilters)
		if(first)
			first = FALSE
		else
			text += " AND "
		text += "([get_filter(item, casts, pflds)])"
	if(!text)
		text = "(1=1)"
	return text
	
/datum/db/adapter/proc/get_filter_or(var/datum/db/filter/or/filter, var/list/casts, var/list/pflds)
	var/first = TRUE
	var/text = ""
	for(var/item in filter.subfilters)
		if(first)
			first = FALSE
		else
			text += " OR "
		text += "([get_filter(item, casts, pflds)])"
	if(!text)
		text = "(1=1)"
	return text

/datum/db/adapter/proc/get_filter_link(var/datum/db/filter/link/filter)
	return "([filter.a_table].[filter.a_field] = [filter.b_table].[filter.b_field])"

/datum/db/adapter/proc/get_filter(var/datum/db/filter/filter, var/list/casts, var/list/pflds)
	if(istype(filter,/datum/db/filter/and))
		return get_filter_and(filter, casts, pflds)
	if(istype(filter,/datum/db/filter/or))
		return get_filter_or(filter, casts, pflds)
	if(istype(filter,/datum/db/filter/comparison))
		return get_filter_comparison(filter, casts, pflds)
	if(istype(filter,/datum/db/filter/compare_two))
		return get_filter_comparetwo(filter, casts, pflds)
	if(istype(filter,/datum/db/filter/link))
		return get_filter_link(filter)
	return "1=1" // shunt

