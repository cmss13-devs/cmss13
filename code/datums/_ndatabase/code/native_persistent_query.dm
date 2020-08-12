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
/datum/db/query/native
	var/database/query/query
	var/database/db

	var/completed = FALSE
	var/affected_rows = 0

/datum/db/query/native/read_single()
	if(status >= DB_QUERY_FINISHED || completed) //broken or finished
		return
	
	if(!completed)
		completed = TRUE
		var/status = query.Execute(db)
		if(!status)
			status = DB_QUERY_BROKEN
			error = query.ErrorMsg()
			return
	status = DB_QUERY_READING
	if(!results)
		results = list()
	var/list/cols = query.Columns()
	if(cols && cols.len>0)
		while(query.NextRow())
			var/list/current_row = query.GetRowData()
			results += list(current_row)
	affected_rows = query.RowsAffected()	
	status = DB_QUERY_FINISHED