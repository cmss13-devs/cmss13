/client/proc/debug_global_variables()
	set category = "Debug.Controllers"
	set name = "View Global Variables"

	if(!usr.client || !usr.client.admin_holder || !(usr.client.admin_holder.rights & R_MOD))
		to_chat(usr, SPAN_DANGER("You need to be a moderator or higher to access this."))
		return
	if(tgui_alert(usr, "Are you sure you want to view global variables? This will cause a large lag spike.", "Confirmation", list("Yes", "No"), 20 SECONDS) != "Yes")
		return

	var/body = {"<script type="text/javascript">

				function updateSearch(){
					var filter_text = document.getElementById('filter');
					var filter = filter_text.value.toLowerCase();

					var vars_ol = document.getElementById('vars');
					var lis = vars_ol.children;

					for(var i = 0; i < lis.length; ++i)
					{
						var li = lis\[i\];
						if(filter.value == "" || li.innerText.toLowerCase().indexOf(filter) != -1)
						{
							li.style.display = "block"
						} else {
							li.style.display = "none"
						}
					}
				}

				function selectTextField(){
					var filter_text = document.getElementById('filter');
					filter_text.focus();
					filter_text.select();
				}

				function loadPage(list) {
					if(list.options\[list.selectedIndex\].value == ""){
						return;
					}

					location.href=list.options\[list.selectedIndex\].value;
				}
			</script>

			<body onload='selectTextField(); updateSearch()'>
			<div align='center'><table width='100%'>
				<tr>
					<td>Global Variables</td>
					<td width='50%'>
						<div align='center'><a href='byond://?_src_=glob_vars;refresh=1'>Refresh</a></div>
					</td>
				</tr>
			</table></div>
			<hr>
			<font size='1'><b>E</b> - Edit, tries to determine the variable type by itself.<br>
			<b>C</b> - Change, asks you for the var type first.<br>
			<hr>
			<table width='100%'>
				<tr>
					<td width='20%'>
						<div align='center'>
							<b>Search:</b>
						</div>
					</td>

					<td width='80%'>
						<input type='search' id='filter' name='filter_text' value='' onkeyup='updateSearch()' onblur='updateSearch()' style='width:100%;'>
					</td>
				</tr>
			</table>
			<hr>
			<ol id='vars'>
			"}

	var/list/names = list()
	for (var/V in global.vars)
		names += V

	names = sortList(names)

	for(var/V in names)
		body += debug_global_variable(V, global.vars[V], 0)

	body += "</ol>"

	var/html = {"<html><head>
		<title>Global Variables</title>
		<style>
			body
			{
				font-family: Verdana, sans-serif;
				font-size: 9pt;
			}
			.value
			{
				font-family: "Courier New", monospace;
				font-size: 8pt;
			}
		</style>
		</head><body>
	"}
	html += body

	html += {"
		<script type='text/javascript'>
			var vars_ol = document.getElementById("glob_vars");
			var complete_list = vars_ol.innerHTML;
		</script>
	"}

	html += "</body></html>"

	show_browser(usr, html, "View Global Variables", "global_variables", width = 475, height = 650)

	return

/client/proc/debug_global_variable(name, value, level)
	var/html = ""
	//to make the value bold if changed
	if(!(admin_holder.rights & R_DEBUG))
		return html

	html += "<li style='backgroundColor:white'><a href='byond://?_src_=glob_vars;varnameedit=[name]'>E</a><a href='byond://?_src_=glob_vars;varnamechange=[name]'>C</a> "

	if (isnull(value))
		html += "[name] = <span class='value'>null</span>"

	else if (istext(value))
		html += "[name] = <span class='value'>\"[value]\"</span>"

	else if (isicon(value))
		#ifdef VARSICON
		var/icon/I = new/icon(value)
		var/rnd = rand(1,10000)
		var/rname = "tmp\ref[I][rnd].png"
		usr << browse_rsc(I, rname)
		html += "[name] = (<span class='value'>[value]</span>) <img class=icon src=\"[rname]\">"
		#else
		html += "[name] = /icon (<span class='value'>[value]</span>)"
		#endif

	else if (isfile(value))
		html += "[name] = <span class='value'>'[value]'</span>"

	else if (istype(value, /datum))
		var/datum/D = value
		html += "<a href='byond://?_src_=vars;Vars=\ref[value]'>[name] \ref[value]</a> = [D.type]"

	else if (istype(value, /client))
		var/client/C = value
		html += "<a href='byond://?_src_=vars;Vars=\ref[value]'>[name] \ref[value]</a> = [C] [C.type]"

	else if (istype(value, /list))
		var/list/L = value
		html += "[name] = /list ([length(L)])"

		if (length(L) > 0 && !(name == "underlays" || name == "overlays" || name == "vars" || length(L) > 500))
			// not sure if this is completely right...
			html += "<ul>"
			var/index = 1
			for (var/entry in L)
				if(istext(entry))
					html += debug_variable(entry, L[entry], level + 1)
				//html += debug_variable("[index]", L[index], level + 1)
				else
					html += debug_variable(index, L[index], level + 1)
				index++
			html += "</ul>"

	else
		html += "[name] = <span class='value'>[value]</span>"

	html += "</li>"

	return html

/client/proc/view_glob_var_Topic(href, href_list, hsrc)
	if((usr.client != src) || !src.admin_holder || !(admin_holder.rights & R_MOD))
		return

	if(href_list["refresh"])
		debug_global_variables()
		return

	else if(href_list["varnameedit"])
		if(!check_rights(R_VAREDIT))
			return

		modify_global_variables(href_list["varnameedit"], TRUE)

	else if(href_list["varnamechange"])
		if(!check_rights(R_VAREDIT))
			return

		modify_global_variables(href_list["varnamechange"], FALSE)

/client/proc/modify_global_variables(param_var_name = null, autodetect_class = 0)
	if(!check_rights(R_VAREDIT))
		return

	var/list/locked = list("vars")

	var/class
	var/variable
	var/var_value

	if(param_var_name)
		if(!(param_var_name in global.vars))
			to_chat(src, "A variable with this name ([param_var_name]) doesn't exist among global variables")
			return

		if((param_var_name in locked) && !check_rights(R_DEBUG))
			return

		variable = param_var_name

		var_value = global.vars[variable]

		if(autodetect_class)
			if(isnull(var_value))
				to_chat(usr, "Unable to determine variable type.")
				class = null
				autodetect_class = null
			else if(isnum(var_value))
				to_chat(usr, "Variable appears to be <b>NUM</b>.")
				class = "num"
				dir = 1

			else if(istext(var_value))
				to_chat(usr, "Variable appears to be <b>TEXT</b>.")
				class = "text"

			else if(isloc(var_value))
				to_chat(usr, "Variable appears to be <b>REFERENCE</b>.")
				class = "reference"

			else if(isicon(var_value))
				to_chat(usr, "Variable appears to be <b>ICON</b>.")
				var_value = "\icon[var_value]"
				class = "icon"

			else if(istype(var_value,/matrix))
				to_chat(usr, "Variable appears to be <b>MATRIX</b>.")
				class = "matrix"

			else if(istype(var_value,/atom) || istype(var_value,/datum))
				to_chat(usr, "Variable appears to be <b>TYPE</b>.")
				class = "type"

			else if(istype(var_value,/list))
				to_chat(usr, "Variable appears to be <b>LIST</b>.")
				class = "list"

			else if(istype(var_value,/client))
				to_chat(usr, "Variable appears to be <b>CLIENT</b>.")
				class = "cancel"
			else
				to_chat(usr, "Variable appears to be <b>FILE</b>.")
				class = "file"
	else
		var/list/names = list()
		for (var/V in global.vars)
			names += V

		names = sortList(names)

		variable = tgui_input_list(usr, "Which var?","Var", names)
		if(!variable)
			return
		var_value = global.vars[variable]

		if((variable in locked) && !check_rights(R_DEBUG))
			return

	if(!autodetect_class)
		var/dir
		if(isnull(var_value))
			to_chat(usr, "Unable to determine variable type.")

		else if(isnum(var_value))
			to_chat(usr, "Variable appears to be <b>NUM</b>.")

			dir = 1

		else if(istext(var_value))
			to_chat(usr, "Variable appears to be <b>TEXT</b>.")


		else if(isloc(var_value))
			to_chat(usr, "Variable appears to be <b>REFERENCE</b>.")


		else if(isicon(var_value))
			to_chat(usr, "Variable appears to be <b>ICON</b>.")
			var_value = "\icon[var_value]"


		else if(istype(var_value,/matrix))
			to_chat(usr, "Variable appears to be <b>MATRIX</b>.")
			class = "matrix"

		else if(istype(var_value,/atom) || istype(var_value,/datum))
			to_chat(usr, "Variable appears to be <b>TYPE</b>.")


		else if(istype(var_value,/list))
			to_chat(usr, "Variable appears to be <b>LIST</b>.")


		else if(istype(var_value,/client))
			to_chat(usr, "Variable appears to be <b>CLIENT</b>.")


		else
			to_chat(usr, "Variable appears to be <b>FILE</b>.")


		to_chat(usr, "Variable contains: [var_value]")
		if(dir)
			switch(var_value)
				if(1)
					dir = "NORTH"
				if(2)
					dir = "SOUTH"
				if(4)
					dir = "EAST"
				if(8)
					dir = "WEST"
				if(5)
					dir = "NORTHEAST"
				if(6)
					dir = "SOUTHEAST"
				if(9)
					dir = "NORTHWEST"
				if(10)
					dir = "SOUTHWEST"
				else
					dir = null
			if(dir)
				to_chat(usr, "If a direction, direction is: [dir]")


		var/list/possible_classes = list("text","num","type","reference","mob reference","icon","file","list")
		if(LAZYLEN(stored_matrices))
			possible_classes += "matrix"
		if(admin_holder && admin_holder.marked_datum)
			possible_classes += "marked datum"
		possible_classes += "edit referenced object"

		class = tgui_input_list(usr, "What kind of variable?","Variable Type", possible_classes)
		if(!class)
			return

	switch(class)

		if("list")
			mod_list(global.vars[variable])
			return

		if("edit referenced object")
			return .(global.vars[variable])

		if("text")
			var/var_new = input("Enter new text:","Text",global.vars[variable]) as null|text
			if(var_new==null)
				return
			global.vars[variable] = var_new

		if("num")
			var/var_new = tgui_input_real_number(usr, "Enter new number:", "Num", global.vars[variable])
			if(var_new==null)
				return
			global.vars[variable] = var_new

		if("type")
			var/var_new = tgui_input_list(usr, "Enter type:","Type", typesof(/obj,/mob,/area,/turf))
			if(var_new==null)
				return
			global.vars[variable] = var_new

		if("reference")
			var/var_new = input("Select reference:","Reference",global.vars[variable]) as null|mob|obj|turf|area in world
			if(var_new==null)
				return
			global.vars[variable] = var_new

		if("mob reference")
			var/var_new = input("Select reference:","Reference",global.vars[variable]) as null|mob in GLOB.mob_list
			if(var_new==null)
				return
			global.vars[variable] = var_new

		if("file")
			var/var_new = input("Pick file:","File",global.vars[variable]) as null|file
			if(var_new==null)
				return
			global.vars[variable] = var_new

		if("icon")
			var/var_new = pick_and_customize_icon(pick_only=TRUE)
			if(var_new==null)
				return
			global.vars[variable] = var_new

		if("matrix")
			var/matrix_name = tgui_input_list(usr, "Choose a matrix", "Matrix", (stored_matrices + "Cancel"))
			if(!matrix_name || matrix_name == "Cancel")
				return

			var/matrix/M = LAZYACCESS(stored_matrices, matrix_name)
			if(!M)
				return

			global.vars[variable] = M

			world.log << "### Global VarEdit by [key_name(src)]: '[variable]': [var_value] => matrix \"[matrix_name]\" with columns ([M.a], [M.b], [M.c]), ([M.d], [M.e], [M.f])"
			message_admins("[key_name_admin(src)] modified global variable '[variable]': [var_value] => matrix \"[matrix_name]\" with columns ([M.a], [M.b], [M.c]), ([M.d], [M.e], [M.f])", 1)

			return

		if("marked datum")
			var/datum/D = admin_holder.marked_datum
			global.vars[variable] = D

	world.log << "### Global VarEdit by [key_name(src)]: '[variable]': [var_value] => [html_encode("[global.vars[variable]]")]"
	message_admins("[key_name_admin(src)] modified global variable '[variable]': [var_value] => [global.vars[variable]]", 1)
