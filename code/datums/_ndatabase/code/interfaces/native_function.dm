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
/datum/db/native_function
	var/is_aggregate = FALSE

/datum/db/native_function/proc/get_columns()
	return null

/datum/db/native_function/proc/default_to_string(var/list/alias, var/list/params)
	return null

/datum/db/native_function/count
	is_aggregate = TRUE
	var/count_column

/datum/db/native_function/count/New(_count_column)
	count_column = _count_column

/datum/db/native_function/count/get_columns()
	return list(count_column)
		
/datum/db/native_function/count/default_to_string(var/list/alias, var/list/params)
	var/field_cast = "[count_column]"
	if(alias && alias[field_cast])
		field_cast = alias[field_cast]
	return "COUNT([field_cast])"

/datum/db/native_function/sum
	is_aggregate = TRUE
	var/sum_column

/datum/db/native_function/sum/New(_sum_column)
	sum_column = _sum_column

/datum/db/native_function/sum/get_columns()
	return list(sum_column)
		
/datum/db/native_function/sum/default_to_string(var/list/alias, var/list/params)
	var/field_cast = "[sum_column]"
	if(alias && alias[field_cast])
		field_cast = alias[field_cast]
	return "SUM([field_cast])"

/datum/db/native_function/constant
	var/value

/datum/db/native_function/constant/New(_value)
	value = _value

/datum/db/native_function/constant/default_to_string(var/list/alias, var/list/params)
	params += "[value]"
	return "?"

/datum/db/native_function/case
	var/datum/db/filter/condition
	var/result_true
	var/result_false

/datum/db/native_function/case/New(var/datum/db/filter/_condition, _result_true, _result_false)
	condition = _condition
	result_true = _result_true
	result_false = _result_false

/datum/db/native_function/case/get_columns()
	var/list/result = list()
	result += condition.get_columns()
	if(result_true)
		var/datum/db/native_function/native_true = result_true
		if(istype(native_true))
			result+=native_true.get_columns()
		else
			result += "[native_true]"
	if(result_false)
		var/datum/db/native_function/native_false = result_false
		if(istype(native_false))
			result+=native_false.get_columns()
		else
			result += "[native_false]"
	return result
		
/datum/db/native_function/case/default_to_string(var/list/alias, var/list/params)
	return null // has to be redone in each service

#define DB_CONST new /datum/db/native_function/constant
#define DB_CASE new /datum/db/native_function/case