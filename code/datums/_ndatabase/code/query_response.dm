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
/datum/db/query_response
	var/datum/db/query/query
	var/datum/callback/success_callback
	var/datum/callback/fail_callback
	var/unique_query_id
	var/status
	var/error
	var/list/results

	var/query_text

	var/called_callback = FALSE

/datum/db/query_response/process()
	if(!query)
		if(fail_callback && !called_callback)
			called_callback = TRUE
			fail_callback.Invoke(unique_query_id, query)
		return TRUE
	query.read_single()
	status = query.status
	if(status==DB_QUERY_FINISHED)		
		results = query.results
		error = query.error
		if(success_callback && !called_callback)
			called_callback = TRUE
			success_callback.Invoke(unique_query_id, results, query)
		return TRUE
	if(status==DB_QUERY_BROKEN)
		error = query.error
		if(fail_callback && !called_callback)
			called_callback = TRUE
			fail_callback.Invoke(unique_query_id, query)
		return TRUE
	return FALSE