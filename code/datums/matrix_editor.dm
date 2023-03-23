
/client
	var/list/stored_matrices
	var/selected_matrix = ""

/client/proc/matrix_editor()
	set name = "Matrix Editor"
	set category = "Debug"

	if(!usr.client || !usr.client.admin_holder || !(usr.client.admin_holder.rights & R_DEBUG|R_ADMIN))
		to_chat(usr, SPAN_DANGER("develop man only >:("))
		return

	var/data = "<h2>Stored matrices</h2>"

	if(LAZYLEN(stored_matrices))
		for(var/name in stored_matrices)
			if(name == selected_matrix)
				data += "-> <b>[name]</b><br>"

				var/matrix/current_matrix = stored_matrices[name]
				data += "\[[current_matrix.a] [current_matrix.d] 0\]<br>"
				data += "\[[current_matrix.b] [current_matrix.e] 0\]<br>"
				data += "\[[current_matrix.c] [current_matrix.f] 1\]"
			else
				data += "<a href='?_src_=matrices;select_matrix=[name]'>[name]</a>"
			data += "<br>"
	else
		data += "<p>No matrices have been made!</p>"
	data += "<hr>"

	data += {"
		<h2>Matrix operations</h2>
		<a href='?_src_=matrices;operation=add'>Add</a>
		<a href='?_src_=matrices;operation=subtract'>Subtract</a>
		<a href='?_src_=matrices;operation=multiply'>Multiply</a>
		<a href='?_src_=matrices;operation=inverse'>Invert</a>
		<br><hr>
		<a href='?_src_=matrices;operation=translate'>Translate</a>
		<a href='?_src_=matrices;operation=scale'>Scale</a>
		<a href='?_src_=matrices;operation=rotate'>Rotate</a>
		<br><hr>
		<a href='?_src_=matrices;operation=new'>New matrix</a>
		<a href='?_src_=matrices;operation=copy'>Copy selected matrix</a>
		<a href='?_src_=matrices;operation=chname'>Change matrix name</a>
		<a href='?_src_=matrices;operation=delete'>Delete selected matrix</a>
	"}

	show_browser(usr, data, "Matrix Editor", "matrixeditor\ref[src]", "size=600x450")

/client/proc/matrix_editor_Topic(href, href_list)
	if(!usr.client || !usr.client.admin_holder || !(usr.client.admin_holder.rights & R_DEBUG|R_ADMIN))
		to_chat(usr, SPAN_DANGER("develop man only >:("))
		return

	if(href_list["select_matrix"])
		selected_matrix = href_list["select_matrix"]
		matrix_editor()
		return

	if(!href_list["operation"])
		return

	switch(href_list["operation"])
		if("new")
			var/matrix/current_matrix

			if(alert("Identity matrix?", "Matrix creation", "Yes", "No") == "Yes")
				current_matrix = matrix()
			else
				var/elements_str = input("Please enter the elements of the matrix as a comma-separated string. Elements should be given by column first, not row!", "Matrix elements") as null|text
				if(!elements_str)
					return
				var/list/elements = splittext(elements_str, ",")
				if(elements.len != 6)
					to_chat(usr, "When creating a custom matrix, explicitly provide all 6 elements! Only [elements.len] were provided.")
					return

				for(var/i = 1 to elements.len)
					var/num_ver = text2num(elements[i])
					if(isnull(num_ver))
						to_chat(usr, "Failed to convert element #[i] ([elements[i]]) to a number.")
						return
					elements[i] = num_ver

				// arglist doesn't work
				var/a = elements[1]
				var/b = elements[2]
				var/c = elements[3]
				var/d = elements[4]
				var/e = elements[5]
				var/f = elements[6]

				current_matrix = matrix(a,b,c,d,e,f)

			var/matrix_name = input("Name your newborn matrix", "Matrix name") as null|text
			if(!matrix_name || matrix_name == "Cancel")
				return

			if(LAZYACCESS(stored_matrices, matrix_name))
				to_chat(usr, "There's already a matrix with that name!")
				return

			LAZYSET(stored_matrices, matrix_name, current_matrix)

		if("copy")
			if(!selected_matrix)
				return

			var/matrix_name = input("Give the copy a name", "Matrix name") as null|text
			if(!matrix_name || matrix_name == "Cancel")
				return

			if(LAZYACCESS(stored_matrices, matrix_name))
				to_chat(usr, "There's already a matrix with that name!")
				return

			LAZYSET(stored_matrices, matrix_name, matrix(LAZYACCESS(stored_matrices, selected_matrix)))

		if("chname")
			if(!selected_matrix)
				return

			var/matrix/current_matrix = LAZYACCESS(stored_matrices, selected_matrix)
			if(!current_matrix)
				return

			var/matrix_name = input("Enter the new matrix name", "Matrix name") as null|text
			if(!matrix_name || matrix_name == "Cancel")
				return

			if(LAZYACCESS(stored_matrices, matrix_name))
				to_chat(usr, "There's already a matrix with that name!")
				return

			LAZYREMOVE(stored_matrices, selected_matrix)
			LAZYSET(stored_matrices, matrix_name, current_matrix)
			selected_matrix = matrix_name

		if("delete")
			if(!selected_matrix)
				return

			var/matrix/current_matrix = LAZYACCESS(stored_matrices, selected_matrix)
			if(!current_matrix)
				return

			if(alert("Are you sure you want to delete [selected_matrix]?", "Matrix deletion", "Yes", "No") != "Yes")
				return

			qdel(current_matrix)
			LAZYREMOVE(stored_matrices, selected_matrix)
			selected_matrix = ""

		if("rotate")
			if(!selected_matrix)
				return

			var/matrix/current_matrix = LAZYACCESS(stored_matrices, selected_matrix)
			if(!current_matrix)
				return

			var/deg = input("Enter how much to rotate the matrix by. The angle is clockwise rotation in degrees.", "Matrix rotation") as null|num
			if(isnull(deg))
				return

			current_matrix.Turn(deg)

		if("scale")
			if(!selected_matrix)
				return

			var/matrix/current_matrix = LAZYACCESS(stored_matrices, selected_matrix)
			if(!current_matrix)
				return

			var/sx = input("Enter how much to scale the matrix by in the X direction.", "Matrix scaling") as null|num
			if(isnull(sx))
				return

			var/sy = input("Enter how much to scale the matrix by in the Y direction.", "Matrix scaling") as null|num
			if(isnull(sy))
				return

			current_matrix.Scale(sx, sy)

		if("translate")
			if(!selected_matrix)
				return

			var/matrix/current_matrix = LAZYACCESS(stored_matrices, selected_matrix)
			if(!current_matrix)
				return

			var/tx = input("Enter how much to translate the matrix by in the X direction.", "Matrix translation") as null|num
			if(isnull(tx))
				return

			var/ty = input("Enter how much to translate the matrix by in the Y direction.", "Matrix translation") as null|num
			if(isnull(ty))
				return

			current_matrix.Translate(tx, ty)

		if("invert")
			if(!selected_matrix)
				return

			var/matrix/current_matrix = LAZYACCESS(stored_matrices, selected_matrix)
			if(!current_matrix)
				return

			current_matrix.Invert()

		if("multiply")
			if(!selected_matrix)
				return

			var/matrix/first_matrix = LAZYACCESS(stored_matrices, selected_matrix)
			if(!first_matrix)
				return

			var/other_m = tgui_input_list(usr, "Select the other matrix to multiply by:", "Matrix multiplication", (stored_matrices + "Cancel"))
			if(!other_m || other_m == "Cancel")
				return

			var/matrix/second_matrix = LAZYACCESS(stored_matrices, other_m)
			if(!second_matrix)
				return

			var/left_right = alert("Multiply with [other_m] from the left or the right?", "Matrix multiplication", "Left", "Right")
			if(left_right == "Left")
				// Since matrix multiplication directly alters the datum, store the old second_matrix so we can set it back later
				var/old_b = matrix(second_matrix)
				second_matrix.Multiply(first_matrix)
				LAZYSET(stored_matrices, selected_matrix, second_matrix)
				LAZYSET(stored_matrices, other_m, old_b)
			else if(left_right == "Right")
				first_matrix.Multiply(second_matrix)

		if("subtract")
			if(!selected_matrix)
				return

			var/matrix/first_matrix = LAZYACCESS(stored_matrices, selected_matrix)
			if(!first_matrix)
				return

			var/other_m = tgui_input_list(usr, "Select the other matrix to subtract by:", "Matrix subtraction", (stored_matrices + "Cancel"))
			if(!other_m || other_m == "Cancel")
				return

			var/matrix/second_matrix = LAZYACCESS(stored_matrices, other_m)
			if(!second_matrix)
				return

			first_matrix.Subtract(second_matrix)

		if("add")
			if(!selected_matrix)
				return

			var/matrix/first_matrix = LAZYACCESS(stored_matrices, selected_matrix)
			if(!first_matrix)
				return

			var/other_m = tgui_input_list(usr, "Select the other matrix to add by:", "Matrix addition", (stored_matrices + "Cancel"))
			if(!other_m || other_m == "Cancel")
				return

			var/matrix/second_matrix = LAZYACCESS(stored_matrices, other_m)
			if(!second_matrix)
				return

			first_matrix.Add(second_matrix)

	matrix_editor()
