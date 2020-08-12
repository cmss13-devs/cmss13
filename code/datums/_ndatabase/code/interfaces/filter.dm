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
/datum/db/filter

/datum/db/filter/proc/get_columns()
	return null

/datum/db/filter/proc/localize_column(column_name, localized_name)
	return

/datum/db/filter/and
	var/datum/db/filter/subfilters

/datum/db/filter/and/New(...)
	subfilters = list()
	subfilters += args

/datum/db/filter/and/get_columns()
	var/list/column_list = list()
	for(var/datum/db/filter/F in subfilters)
		var/list/cols = F.get_columns()
		if(!cols)
			continue
		column_list.Add(cols)
	return column_list

/datum/db/filter/or
	var/datum/db/filter/subfilters

/datum/db/filter/or/New(...)
	subfilters = list()
	subfilters += args

/datum/db/filter/or/get_columns()
	var/list/column_list = list()
	for(var/datum/db/filter/F in subfilters)
		var/list/cols = F.get_columns()
		if(!cols)
			continue
		column_list.Add(cols)
	return column_list

/datum/db/filter/comparison
	var/field
	var/operator
	var/value

/datum/db/filter/comparison/New(_field, op, _value)
	field = _field
	operator = op
	value = _value

/datum/db/filter/comparison/get_columns()
	return field

/datum/db/filter/compare_two
	var/field1
	var/operator
	var/field2

/datum/db/filter/compare_two/New(_field1, op, _field2)
	field1 = _field1
	operator = op
	field2 = _field2

/datum/db/filter/compare_two/get_columns()
	return list(field1, field2)

/datum/db/filter/link
	var/a_table
	var/a_field
	var/b_table
	var/b_field

/datum/db/filter/link/New(_a_table,_a_field,_b_table,_b_field)
	a_table = _a_table
	a_field = _a_field
	b_table = _b_table
	b_field = _b_field

/datum/db/filter/link/get_columns()
	CRASH("NOT SUPPORTED. USE compare_two EQUALS")

#define DB_AND new /datum/db/filter/and
#define DB_OR new /datum/db/filter/or
#define DB_COMP new /datum/db/filter/comparison
#define DB_COMP2 new /datum/db/filter/compare_two