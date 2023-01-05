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
/datum/db/query/brsql
	var/job_id
	var/list/parameters
	var/list/columns
	var/affected_rows = 0
	var/last_insert_id

/datum/db/query/brsql/read_single()
	if(status >= DB_QUERY_FINISHED) //broken or finished
		return
	
	status = DB_QUERY_STARTED
	var/job_result = rustg_sql_check_query(job_id)
	if(job_result == RUSTG_JOB_NO_RESULTS_YET)
		return
	
	var/result = json_decode(job_result)
	switch(result["status"])
		if("ok")
			columns = result["columns"]
			// MOVE THIS STUFF TO THE ASSIGNOR, THIS IS HERE TO TEST AND UNOPTIMAL AS FUCK
			if(columns)
				results = list()
				var/list/col_list = list()
				for(var/col in columns)
					col_list.Add(col["name"])
				var/col_len = length(col_list)
				for(var/row in result["rows"])
					var/adapted_row = list()
					for(var/i = 1; i<=col_len; i++)
						adapted_row[col_list[i]] = row[i]
					results.Add(list(adapted_row))
			affected_rows = result["affected"]
			last_insert_id = result["last_insert_id"]
			status = DB_QUERY_FINISHED
			return
		if("err")
			error = result["data"]
			status = DB_QUERY_BROKEN
			return
		if("offline")
			error = "CONNECTION OFFLINE"
			status = DB_QUERY_BROKEN
			return