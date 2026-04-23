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

/datum/db/index
	var/list/fields
	var/hints

	// name for the database
	var/name

// redefine this for faster operations
/datum/db/index/proc/make_filters_for_index(...)
	. = list()
	for(var/i = 1 to length(fields))
		. += DB_COMP(fields[i], DB_EQUALS, args[i])
	if(length(.) == 1)
		return .[1]
	return DB_AND(arglist(.))

// redefine this for faster operations
/datum/db/index/proc/get_strval(list/values)
	. = ""
	for(var/i = 1 to length(fields))
		. += "[fields[i]]:[values[i]];"

// redefine this for faster operations
/datum/db/index/proc/assign_entity_values(datum/entity/ET, list/values)
	for(var/i = 1 to length(fields))
		ET.vars[fields[i]] = values[i]
