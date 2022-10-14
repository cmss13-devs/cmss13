
// reference: /client/proc/modify_variables(var/atom/O, var/param_var_name = null, var/autodetect_class = 0)

/datum/proc/is_datum_protected()
	return FALSE

/datum/proc/can_vv_get()
	return TRUE

/datum/proc/can_vv_modify()
	return TRUE

/client/can_vv_modify()
	return FALSE

/client/proc/debug_variables(datum/D in world)
	set category = "Debug"
	set name = "View Variables"

	if(!usr.client || !usr.client.admin_holder || !(usr.client.admin_holder.rights & R_MOD))
		to_chat(usr, SPAN_DANGER("You need to be a moderator or higher to access this."))
		return

	if(!D)
		return

	var/title = ""
	var/body = ""

	//Sort of a temporary solution for right now.
	if(istype(D,/datum/admins) && !(ishost(usr))) //Prevents non-hosts from changing their own permissions.
		to_chat(usr, SPAN_WARNING("You need host permission to access this."))
		return

	if(( !D.can_vv_get() || D.is_datum_protected() ) && !(usr.client.admin_holder.rights & R_DEBUG))
		to_chat(usr, SPAN_WARNING("You need debugging permission to access this."))
		return

	if(istype(D, /atom))
		var/atom/A = D
		title = "[A.name] (\ref[A]) = [A.type]"

		#ifdef VARSICON
		if (A.icon)
			body += debug_variable("icon", new/icon(A.icon, A.icon_state, A.dir), 0)
		#endif

	var/icon/sprite

	if(istype(D,/atom))
		var/atom/AT = D
		if(AT.icon && AT.icon_state)
			sprite = new /icon(AT.icon, AT.icon_state)
			usr << browse_rsc(sprite, "view_vars_sprite.png")

	title = "[D] (\ref[D]) = [D.type]"

	body += {"<script type="text/javascript">

				function updateSearch(){
					var filter_text = document.getElementById('filter');
					var filter = filter_text.value.toLowerCase();

					if(filter.value == ""){
						return;
					}

					var vars_ol = document.getElementById('vars');
					var lis = vars_ol.getElementsByTagName("li");

					for ( var i = 0; i < lis.length; ++i )
					{
						var li = lis\[i\];
						if ( li.innerText.toLowerCase().indexOf(filter) == -1 )
						{
							li.style.display = "none"
						} else {
							li.style.display = "block"
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
			</script> "}

	body += "<body onload='selectTextField(); updateSearch()'>"

	body += "<div align='center'><table width='100%'><tr><td width='50%'>"

	if(sprite)
		body += "<table align='center' width='100%'><tr><td><img src='view_vars_sprite.png'></td><td>"
	else
		body += "<table align='center' width='100%'><tr><td>"

	body += "<div align='center'>"

	if(istype(D,/atom))
		var/atom/A = D
		if(isliving(A))
			body += "<a href='?_src_=vars;rename=\ref[D]'><b>[D]</b></a>"
			if(A.dir)
				body += "<br><font size='1'><a href='?_src_=vars;rotatedatum=\ref[D];rotatedir=left'><<</a> <a href='?_src_=vars;datumedit=\ref[D];varnameedit=dir'>[dir2text(A.dir)]</a> <a href='?_src_=vars;rotatedatum=\ref[D];rotatedir=right'>>></a></font>"
			var/mob/living/M = A
			body += "<br><font size='1'><a href='?_src_=vars;datumedit=\ref[D];varnameedit=ckey'>[M.ckey ? M.ckey : "No ckey"]</a> / <a href='?_src_=vars;datumedit=\ref[D];varnameedit=real_name'>[M.real_name ? M.real_name : "No real name"]</a></font>"
			body += {"
			<br><font size='1'>
			BRUTE:<font size='1'><a href='?_src_=vars;mobToDamage=\ref[D];adjustDamage=brute'>[M.getBruteLoss()]</a>
			FIRE:<font size='1'><a href='?_src_=vars;mobToDamage=\ref[D];adjustDamage=fire'>[M.getFireLoss()]</a>
			TOXIN:<font size='1'><a href='?_src_=vars;mobToDamage=\ref[D];adjustDamage=toxin'>[M.getToxLoss()]</a>
			OXY:<font size='1'><a href='?_src_=vars;mobToDamage=\ref[D];adjustDamage=oxygen'>[M.getOxyLoss()]</a>
			CLONE:<font size='1'><a href='?_src_=vars;mobToDamage=\ref[D];adjustDamage=clone'>[M.getCloneLoss()]</a>
			BRAIN:<font size='1'><a href='?_src_=vars;mobToDamage=\ref[D];adjustDamage=brain'>[M.getBrainLoss()]</a>
			</font>


			"}
		else
			body += "<a href='?_src_=vars;datumedit=\ref[D];varnameedit=name'><b>[D]</b></a>"
			if(A.dir)
				body += "<br><font size='1'><a href='?_src_=vars;rotatedatum=\ref[D];rotatedir=left'><<</a> <a href='?_src_=vars;datumedit=\ref[D];varnameedit=dir'>[dir2text(A.dir)]</a> <a href='?_src_=vars;rotatedatum=\ref[D];rotatedir=right'>>></a></font>"
	else
		body += "<b>[D]</b>"

	body += "</div>"

	body += "</tr></td></table>"

	var/formatted_type = text("[D.type]")
	if(length(formatted_type) > 25)
		var/middle_point = length(formatted_type) / 2
		var/splitpoint = findtext(formatted_type,"/",middle_point)
		if(splitpoint)
			formatted_type = "[copytext(formatted_type,1,splitpoint)]<br>[copytext(formatted_type,splitpoint)]"
		else
			formatted_type = "Type too long" //No suitable splitpoint (/) found.

	body += "<div align='center'><b><font size='1'>[formatted_type]</font></b>"

	if(admin_holder && admin_holder.marked_datums && (D in admin_holder.marked_datums))
		body += "<br><font size='1' color='red'><b>Marked Object</b></font>"

	body += "</div>"

	body += "</div></td>"

	body += "<td width='50%'><div align='center'><a href='?_src_=vars;datumrefresh=\ref[D]'>Refresh</a>"

	//if(ismob(D))
	//	body += "<br><a href='?_src_=vars;mob_player_panel=\ref[D]'>Show player panel</a></div></td></tr></table></div><hr>"

	body += {"	<form>
				<select name="file" size="1"
				onchange="loadPage(this.form.elements\[0\])"
				target="_parent._top"
				onmouseclick="this.focus()"
				style="background-color:#ffffff">
			"}

	body += {"	<option value>Select option</option>
				<option value> </option>
			"}

	if(admin_holder)
		body += "<option value='?_src_=vars;mark_object=\ref[D]'>[(D in admin_holder.marked_datums) ? "Unm" : "M"]ark Datum</option>"
	body += "<option value='?_src_=vars;adv_proccall=\ref[D]'>Advanced ProcCall</option>"
	body += "<option value>----------</option>"

	var/list/datum_options = D.get_vv_options()
	if(length(datum_options))
		for(var/specific_option in datum_options)
			body += specific_option

	body += "</select></form>"

	body += "</div></td></tr></table></div><hr>"

	body += "<font size='1'><b>E</b> - Edit, tries to determine the variable type by itself.<br>"
	body += "<b>C</b> - Change, asks you for the var type first.<br>"
	body += "<b>M</b> - Mass modify: changes this variable for all objects of this type.</font><br>"

	body += "<hr><table width='100%'><tr><td width='20%'><div align='center'><b>Search:</b></div></td><td width='80%'><input type='text' id='filter' name='filter_text' value='' onkeyup='updateSearch()' style='width:100%;'></td></tr></table><hr>"

	body += "<ol id='vars'>"

	var/list/names = list()
	for (var/V in D.vars)
		names += V

	names = sortList(names)

	for (var/V in names)
		CHECK_TICK
		body += debug_variable(V, D.vars[V], 0, D)

	body += "</ol>"

	var/html = "<html><head>"
	if (title)
		html += "<title>[title]</title>"
	html += {"<style>
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
</style>"}
	html += "</head><body>"
	html += body

	html += {"
		<script type='text/javascript'>
			var vars_ol = document.getElementById("vars");
			var complete_list = vars_ol.innerHTML;
		</script>
	"}

	html += "</body></html>"

	show_browser(usr, html, "View Variables", "variables\ref[D]", "size=475x650")

	return

/datum/proc/get_vv_options()
	return list()

/atom/get_vv_options()
	. = ..()
	. += "<option value='?_src_=vars;enablepixelscaling=\ref[src]'>Enable Pixel Scaling</option>"

/turf/get_vv_options()
	. = ..()
	. += "<option value='?_src_=vars;explode=\ref[src]'>Trigger explosion</option>"
	. += "<option value='?_src_=vars;emp=\ref[src]'>Trigger EM pulse</option>"
	. += "<option value='?_src_=vars;setmatrix=\ref[src]'>Set Base Matrix</option>"

/mob/get_vv_options()
	. = ..()
	. += "<option value='?_src_=vars;explode=\ref[src]'>Trigger explosion</option>"
	. += "<option value='?_src_=vars;emp=\ref[src]'>Trigger EM pulse</option>"
	. += "<option value='?_src_=vars;setmatrix=\ref[src]'>Set Base Matrix</option>"

/obj/get_vv_options()
	. = ..()
	. += "<option value='?_src_=vars;explode=\ref[src]'>Trigger explosion</option>"
	. += "<option value='?_src_=vars;emp=\ref[src]'>Trigger EM pulse</option>"
	. += "<option value='?_src_=vars;setmatrix=\ref[src]'>Set Base Matrix</option>"
	. += "<option value>-----OBJECT-----</option>"
	. += "<option value='?_src_=vars;delall=\ref[src]'>Delete all of type</option>"

/client/proc/is_safe_variable(name)
	if(name == "step_x" || name == "step_y" || name == "bound_x" || name == "bound_y" || name == "bound_height" || name == "bound_width" || name == "bounds")
		return FALSE
	return TRUE

/client/proc/debug_variable(name, value, level, var/datum/DA = null)
	var/html = ""
	var/change = 0
	//to make the value bold if changed
	if(!(admin_holder.rights & R_DEBUG) && !is_safe_variable(name))
		return html
	if(DA)
		html += "<li style='backgroundColor:white'><a href='?_src_=vars;datumedit=\ref[DA];varnameedit=[name]'>E</a><a href='?_src_=vars;datumchange=\ref[DA];varnamechange=[name]'>C</a><a href='?_src_=vars;datummass=\ref[DA];varnamemass=[name]'>M</a> "
		if(value != initial(DA.vars[name]))
			html += "<font color='#B300B3'>"
			change = 1
	else
		html += "<li>"

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
		html += "<a href='?_src_=vars;Vars=\ref[value]'>[name] \ref[value]</a> = [D.type]"

	else if (istype(value, /client))
		var/client/C = value
		html += "<a href='?_src_=vars;Vars=\ref[value]'>[name] \ref[value]</a> = [C] [C.type]"
//
	else if (istype(value, /list))
		var/list/L = value
		html += "[name] = /list ([L.len])"

		if (L.len > 0 && !(name == "underlays" || name == "overlays" || name == "vars" || L.len > 500))
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
	if(change)
		html += "</font>"

	html += "</li>"

	return html

/client/proc/view_var_Topic(href, href_list, hsrc)
	//This should all be moved over to datum/admins/Topic() or something ~Carn
	if((usr.client != src) || !src.admin_holder || !(admin_holder.rights & R_MOD))
		return

	if(href_list["Vars"])
		debug_variables(locate(href_list["Vars"]))

	//~CARN: for renaming mobs (updates their name, real_name, mind.name, their ID/PDA and datacore records).
	else if(href_list["rename"])
		if(!check_rights(R_VAREDIT))
			return

		var/mob/M = locate(href_list["rename"])
		if(!istype(M))
			to_chat(usr, "This can only be used on instances of type /mob")
			return

		var/new_name = stripped_input(usr,"What would you like to name this mob?","Input a name",M.real_name,MAX_NAME_LEN)
		if(!new_name || !M)
			return

		message_staff("Admin [key_name_admin(usr)] renamed [key_name_admin(M)] to [new_name].")
		M.fully_replace_character_name(M.real_name,new_name)
		href_list["datumrefresh"] = href_list["rename"]

	else if(href_list["varnameedit"] && href_list["datumedit"])
		if(!check_rights(R_VAREDIT))
			return

		var/D = locate(href_list["datumedit"])
		if(!istype(D,/datum) && !istype(D,/client))
			to_chat(usr, "This can only be used on instances of types /client or /datum")
			return

		modify_variables(D, href_list["varnameedit"], 1)

	else if(href_list["varnamechange"] && href_list["datumchange"])
		if(!check_rights(R_VAREDIT))
			return

		var/D = locate(href_list["datumchange"])
		if(!istype(D,/datum) && !istype(D,/client))
			to_chat(usr, "This can only be used on instances of types /client or /datum")
			return

		modify_variables(D, href_list["varnamechange"], 0)

	else if(href_list["varnamemass"] && href_list["datummass"])
		if(!check_rights(R_VAREDIT))
			return

		var/atom/A = locate(href_list["datummass"])
		if(!istype(A))
			to_chat(usr, "This can only be used on instances of type /atom")
			return

		cmd_mass_modify_object_variables(A, href_list["varnamemass"])

	else if(href_list["mob_player_panel"])
		if(!check_rights(0))
			return

		var/mob/M = locate(href_list["mob_player_panel"])
		if(!istype(M))
			to_chat(usr, "This can only be used on instances of type /mob")
			return

		addtimer(CALLBACK(admin_holder, /datum/admins.proc/show_player_panel, M), 0.5 SECONDS)
		href_list["datumrefresh"] = href_list["mob_player_panel"]

	else if(href_list["give_disease"])
		if(!check_rights(R_ADMIN))
			return

		var/mob/M = locate(href_list["give_disease"])
		if(!istype(M))
			to_chat(usr, "This can only be used on instances of type /mob")
			return

		src.give_disease(M)
		href_list["datumrefresh"] = href_list["give_disease"]

	else if(href_list["build_mode"])
		if(!check_rights(R_ADMIN))
			return

		var/mob/M = locate(href_list["build_mode"])
		if(!istype(M))
			to_chat(usr, "This can only be used on instances of type /mob")
			return

		if(!M.client || !M.client.admin_holder || !(M.client.admin_holder.rights & R_MOD))
			to_chat(usr, "This can only be used on people with +MOD permissions")
			return

		log_admin("[key_name(usr)] has toggled buildmode on [key_name(M)]")
		message_staff("[key_name_admin(usr)] has toggled buildmode on [key_name_admin(M)]")

		togglebuildmode(M)
		href_list["datumrefresh"] = href_list["build_mode"]

	else if(href_list["gib"])
		if(!check_rights(0))
			return

		var/mob/M = locate(href_list["gib"])
		if(!istype(M))
			to_chat(usr, "This can only be used on instances of type /mob")
			return

		src.cmd_admin_gib(M)

	else if(href_list["drop_everything"])
		if(!check_rights(R_DEBUG|R_ADMIN))
			return

		var/mob/M = locate(href_list["drop_everything"])
		if(!istype(M))
			to_chat(usr, "This can only be used on instances of type /mob")
			return

		if(usr.client)
			usr.client.cmd_admin_drop_everything(M)

	else if(href_list["direct_control"])
		if(!check_rights(0))
			return

		var/mob/M = locate(href_list["direct_control"])
		if(!istype(M))
			to_chat(usr, "This can only be used on instances of type /mob")
			return

		if(usr.client)
			usr.client.cmd_assume_direct_control(M)

	else if(href_list["delall"])
		if(!check_rights(R_DEBUG|R_SERVER))
			return

		var/obj/O = locate(href_list["delall"])
		if(!isobj(O))
			to_chat(usr, "This can only be used on instances of type /obj")
			return

		var/action_type = alert("Strict type ([O.type]) or type and all subtypes?",,"Strict type","Type and subtypes","Cancel")
		if(action_type == "Cancel" || !action_type)
			return

		if(alert("Are you really sure you want to delete all objects of type [O.type]?",,"Yes","No") != "Yes")
			return

		if(alert("Second confirmation required. Delete?",,"Yes","No") != "Yes")
			return

		var/O_type = O.type
		switch(action_type)
			if("Strict type")
				var/i = 0
				for(var/obj/Obj in GLOB.object_list)
					if(Obj.type == O_type)
						i++
						qdel(Obj)
				if(!i)
					to_chat(usr, "No objects of this type exist")
					return
				message_staff("[key_name(usr)] deleted all objects of type [O_type] ([i] objects deleted) ")
			if("Type and subtypes")
				var/i = 0
				for(var/obj/Obj in GLOB.object_list)
					if(istype(Obj,O_type))
						i++
						qdel(Obj)
				if(!i)
					to_chat(usr, "No objects of this type exist")
					return
				message_staff("[key_name(usr)] deleted all objects of type or subtype of [O_type] ([i] objects deleted) ")

	else if(href_list["enablepixelscaling"])
		if(!check_rights(R_DEBUG|R_VAREDIT))
			return

		var/atom/A = locate(href_list["enablepixelscaling"])
		if(!istype(A, /atom))
			return

		A.enable_pixel_scaling()

	else if(href_list["explode"])
		if(!check_rights(R_DEBUG))
			return

		var/atom/A = locate(href_list["explode"])
		if(!isobj(A) && !ismob(A) && !isturf(A))
			to_chat(usr, "This can only be done to instances of type /obj, /mob and /turf")
			return

		cell_explosion(A, 150, 100, , create_cause_data("divine intervention"))
		message_staff("[key_name(src, TRUE)] has exploded [A]!")
		href_list["datumrefresh"] = href_list["explode"]

	else if(href_list["emp"])
		if(!check_rights(R_DEBUG))
			return

		var/atom/A = locate(href_list["emp"])
		if(!isobj(A) && !ismob(A) && !isturf(A))
			to_chat(usr, "This can only be done to instances of type /obj, /mob and /turf")
			return

		src.cmd_admin_emp(A)
		href_list["datumrefresh"] = href_list["emp"]

	else if(href_list["mark_object"])
		if(!check_rights(0))
			return

		var/datum/D = locate(href_list["mark_object"])
		if(!istype(D))
			to_chat(usr, "This can only be done to instances of type /datum")
			return

		if(D.is_datum_protected())
			to_chat(usr, SPAN_WARNING("This datum is protected. Access Denied"))
			return

		if(D in admin_holder.marked_datums)
			admin_holder.marked_datums -= D
		else
			admin_holder.marked_datums += D
		href_list["datumrefresh"] = href_list["mark_object"]

	else if(href_list["adv_proccall"])
		if(!check_rights(R_DEBUG))
			return

		var/datum/D = locate(href_list["adv_proccall"])
		callproc(D)


	else if(href_list["rotatedatum"])
		if(!check_rights(0))
			return

		var/atom/A = locate(href_list["rotatedatum"])
		if(!istype(A))
			to_chat(usr, "This can only be done to instances of type /atom")
			return

		switch(href_list["rotatedir"])
			if("right")	A.setDir(turn(A.dir, -45))
			if("left")	A.setDir(turn(A.dir, 45))
		href_list["datumrefresh"] = href_list["rotatedatum"]

	else if(href_list["makemonkey"])
		if(!check_rights(R_SPAWN))
			return

		var/mob/living/carbon/human/H = locate(href_list["makemonkey"])
		if(!istype(H))
			to_chat(usr, "This can only be done to instances of type /mob/living/carbon/human")
			return

		if(alert("Confirm mob type change?",,"Transform","Cancel") != "Transform")	return
		if(!H)
			to_chat(usr, "Mob doesn't exist anymore")
			return
		admin_holder.Topic(href, list("monkeyone"=href_list["makemonkey"], "admin_token" = RawHrefToken()))

	else if(href_list["makerobot"])
		if(!check_rights(R_SPAWN))
			return

		var/mob/living/carbon/human/H = locate(href_list["makerobot"])
		if(!istype(H))
			to_chat(usr, "This can only be done to instances of type /mob/living/carbon/human")
			return

		if(alert("Confirm mob type change?",,"Transform","Cancel") != "Transform")	return
		if(!H)
			to_chat(usr, "Mob doesn't exist anymore")
			return
		admin_holder.Topic(href, list("makerobot"=href_list["makerobot"], "admin_token" = RawHrefToken()))

	else if(href_list["makealien"])
		if(!check_rights(R_SPAWN))
			return

		var/mob/living/carbon/human/H = locate(href_list["makealien"])
		if(!istype(H))
			to_chat(usr, "This can only be done to instances of type /mob/living/carbon/human")
			return

		if(alert("Confirm mob type change?",,"Transform","Cancel") != "Transform")	return
		if(!H)
			to_chat(usr, "Mob doesn't exist anymore")
			return
		admin_holder.Topic(href, list("makealien"=href_list["makealien"], "admin_token" = RawHrefToken()))

	else if(href_list["changehivenumber"])
		if(!check_rights(R_DEBUG|R_ADMIN))
			return

		var/mob/living/carbon/X = locate(href_list["changehivenumber"])
		if(!istype(X))
			to_chat(usr, "This can only be done to instances of type /mob/living/carbon")
			return

		admin_holder.Topic(href, list("changehivenumber"=href_list["changehivenumber"], "admin_token" = RawHrefToken()))

	else if(href_list["makeai"])
		if(!check_rights(R_SPAWN))
			return

		var/mob/living/carbon/human/H = locate(href_list["makeai"])
		if(!istype(H))
			to_chat(usr, "This can only be done to instances of type /mob/living/carbon/human")
			return

		if(alert("Confirm mob type change?",,"Transform","Cancel") != "Transform")	return
		if(!H)
			to_chat(usr, "Mob doesn't exist anymore")
			return
		admin_holder.Topic(href, list("makeai"=href_list["makeai"], "admin_token" = RawHrefToken()))

	else if(href_list["selectequipment"])
		if(!check_rights(R_SPAWN))
			return

		var/mob/living/carbon/human/H = locate(href_list["selectequipment"])
		if(!istype(H))
			to_chat(usr, "This can only be done to instances of type /mob/living/carbon/human")
			return

		cmd_admin_dress(H)

	else if(href_list["setspecies"])
		if(!check_rights(R_SPAWN))
			return

		var/mob/living/carbon/human/H = locate(href_list["setspecies"])
		if(!istype(H))
			to_chat(usr, "This can only be done to instances of type /mob/living/carbon/human")
			return

		var/new_species = tgui_input_list(usr, "Please choose a new species.","Species",GLOB.all_species)

		if(!new_species) return

		if(!H)
			to_chat(usr, "Mob doesn't exist anymore")
			return

		if(H.set_species(new_species))
			to_chat(usr, "Set species of [H] to [H.species].")
		else
			to_chat(usr, "Failed! Something went wrong.")

	else if(href_list["edit_skill"])
		if(!check_rights(R_SPAWN))
			return

		var/mob/living/carbon/human/H = locate(href_list["edit_skill"])
		if(!istype(H))
			to_chat(usr, "This can only be done to instances of type /mob/living/carbon/human")
			return

		if(!H.skills)
			H.skills = new /datum/skills/pfc(H)

		var/selected_skill = tgui_input_list(usr, "Please choose a skill to edit.","Skills", GLOB.all_skills)
		if(!selected_skill)
			return

		if(!H)
			to_chat(usr, "Mob doesn't exist anymore")
			return

		var/new_skill_level = tgui_input_number(usr, "Select a new level for the [selected_skill] skill ","New Skill Level")

		if(isnull(new_skill_level))
			return

		if(!H)
			to_chat(usr, "Mob doesn't exist anymore")
			return

		H.skills.set_skill(selected_skill, new_skill_level)
		to_chat(usr, "[H]'s [selected_skill] skill is now set to [new_skill_level].")

	else if(href_list["addlanguage"])
		if(!check_rights(R_SPAWN))
			return

		var/mob/H = locate(href_list["addlanguage"])
		if(!istype(H))
			to_chat(usr, "This can only be done to instances of type /mob")
			return

		var/new_language = tgui_input_list(usr, "Please choose a language to add.","Language", GLOB.all_languages)

		if(!new_language)
			return

		if(!H)
			to_chat(usr, "Mob doesn't exist anymore")
			return

		if(H.add_language(new_language))
			to_chat(usr, "Added [new_language] to [H].")
		else
			to_chat(usr, "Mob already knows that language.")

	else if(href_list["remlanguage"])
		if(!check_rights(R_SPAWN))
			return

		var/mob/H = locate(href_list["remlanguage"])
		if(!istype(H))
			to_chat(usr, "This can only be done to instances of type /mob")
			return

		if(!H.languages.len)
			to_chat(usr, "This mob knows no languages.")
			return

		var/datum/language/rem_language = tgui_input_list(usr, "Please choose a language to remove.","Language", H.languages)

		if(!rem_language)
			return

		if(!H)
			to_chat(usr, "Mob doesn't exist anymore")
			return

		if(H.remove_language(rem_language.name))
			to_chat(usr, "Removed [rem_language] from [H].")
		else
			to_chat(usr, "Mob doesn't know that language.")

	else if(href_list["addverb"])
		if(!check_rights(R_DEBUG))
			return

		var/mob/living/H = locate(href_list["addverb"])

		if(!istype(H))
			to_chat(usr, "This can only be done to instances of type /mob/living")
			return
		var/list/possibleverbs = list()
		possibleverbs += "Cancel" 								// One for the top...
		possibleverbs += typesof(/mob/proc,/mob/verb,/mob/living/proc,/mob/living/verb)
		switch(H.type)
			if(/mob/living/carbon/human)
				possibleverbs += typesof(/mob/living/carbon/proc,/mob/living/carbon/verb,/mob/living/carbon/human/verb,/mob/living/carbon/human/proc)
			if(/mob/living/silicon/robot)
				possibleverbs += typesof(/mob/living/silicon/proc,/mob/living/silicon/robot/proc,/mob/living/silicon/robot/verb)
			if(/mob/living/silicon/ai)
				possibleverbs += typesof(/mob/living/silicon/proc,/mob/living/silicon/ai/proc)
		possibleverbs -= H.verbs
		possibleverbs += "Cancel" 								// ...And one for the bottom

		var/verb = tgui_input_list(usr, "Select a verb!", "Verbs", possibleverbs)
		if(!H)
			to_chat(usr, "Mob doesn't exist anymore")
			return
		if(!verb || verb == "Cancel")
			return
		else
			add_verb(H, verb)

	else if(href_list["remverb"])
		if(!check_rights(R_DEBUG))
			return

		var/mob/H = locate(href_list["remverb"])

		if(!istype(H))
			to_chat(usr, "This can only be done to instances of type /mob")
			return
		var/verb = tgui_input_list(usr, "Please choose a verb to remove.","Verbs", H.verbs)
		if(!H)
			to_chat(usr, "Mob doesn't exist anymore")
			return
		if(!verb)
			return
		else
			remove_verb(H, verb)

	else if(href_list["addorgan"])
		if(!check_rights(R_SPAWN))
			return

		var/mob/living/carbon/M = locate(href_list["addorgan"])
		if(!istype(M))
			to_chat(usr, "This can only be done to instances of type /mob/living/carbon")
			return

		var/new_organ = tgui_input_list(usr, "Please choose an organ to add.","Organ",null, typesof(/datum/internal_organ)-/datum/internal_organ)

		if(!new_organ)
			return FALSE

		if(!M)
			to_chat(usr, "Mob doesn't exist anymore")
			return

		if(locate(new_organ) in M.internal_organs)
			to_chat(usr, "Mob already has that organ.")
			return

		if(istype(M,/mob/living/carbon/human))
			var/mob/living/carbon/human/H = M
			var/datum/internal_organ/I = new new_organ(H)

			var/organ_slot = input(usr, "Which slot do you want the organ to go in ('default' for default)?")  as text|null

			if(!organ_slot)
				return

			if(organ_slot != "default")
				organ_slot = sanitize(copytext(organ_slot,1,MAX_MESSAGE_LEN))
			else
				if(I.removed_type)
					var/obj/item/organ/O = new I.removed_type()
					organ_slot = O.organ_tag
					qdel(O)
				else
					organ_slot = "unknown organ"

			if(H.internal_organs_by_name[organ_slot])
				to_chat(usr, "[H] already has an organ in that slot.")
				qdel(I)
				return

			H.internal_organs_by_name[organ_slot] = I
			to_chat(usr, "Added new [new_organ] to [H] as slot [organ_slot].")
		else
			new new_organ(M)
			to_chat(usr, "Added new [new_organ] to [M].")

	else if(href_list["remorgan"])
		if(!check_rights(R_SPAWN))
			return

		var/mob/living/carbon/M = locate(href_list["remorgan"])
		if(!istype(M))
			to_chat(usr, "This can only be done to instances of type /mob/living/carbon")
			return

		var/rem_organ = tgui_input_list(usr, "Please choose an organ to remove.","Organ",null, M.internal_organs)

		if(!M)
			to_chat(usr, "Mob doesn't exist anymore")
			return

		if(!(locate(rem_organ) in M.internal_organs))
			to_chat(usr, "Mob does not have that organ.")
			return

		to_chat(usr, "Removed [rem_organ] from [M].")
		qdel(rem_organ)


	else if(href_list["addlimb"])
		if(!check_rights(R_SPAWN))
			return

		var/mob/living/carbon/human/M = locate(href_list["addlimb"])
		if(!istype(M))
			to_chat(usr, "This can only be done to instances of type /mob/living/carbon/human")
			return

		var/new_limb = tgui_input_list(usr, "Please choose an organ to add.","Organ", typesof(/obj/limb)-/obj/limb)

		if(!M)
			to_chat(usr, "Mob doesn't exist anymore")
			return

		var/obj/limb/EO = locate(new_limb) in M.limbs
		if(!EO)
			return
		if(!(EO.status & LIMB_DESTROYED))
			to_chat(usr, "Mob already has that organ.")
			return

		EO.status = NO_FLAGS
		EO.perma_injury = 0
		EO.reset_limb_surgeries()
		M.update_body(0)
		M.updatehealth()
		M.UpdateDamageIcon()

	else if(href_list["amplimb"])
		if(!check_rights(R_SPAWN))
			return

		var/mob/living/carbon/human/M = locate(href_list["amplimb"])
		if(!istype(M))
			to_chat(usr, "This can only be done to instances of type /mob/living/carbon/human")
			return

		var/rem_limb = tgui_input_list(usr, "Please choose a limb to remove.","Organ", M.limbs)

		if(!M)
			to_chat(usr, "Mob doesn't exist anymore")
			return

		var/obj/limb/EO = locate(rem_limb) in M.limbs
		if(!EO)
			return
		if(EO.status & LIMB_DESTROYED)
			to_chat(usr, "Mob doesn't have that limb.")
			return
		EO.droplimb(1)

	else if(href_list["remlimb"])
		if(!check_rights(R_SPAWN))
			return

		var/mob/living/carbon/human/M = locate(href_list["remlimb"])
		if(!istype(M))
			to_chat(usr, "This can only be done to instances of type /mob/living/carbon/human")
			return

		var/rem_limb = tgui_input_list(usr, "Please choose a limb to remove.","Organ", M.limbs)

		if(!M)
			to_chat(usr, "Mob doesn't exist anymore")
			return

		var/obj/limb/EO = locate(rem_limb) in M.limbs
		if(!EO)
			return
		if(EO.status & LIMB_DESTROYED)
			to_chat(usr, "Mob doesn't have that limb.")
			return
		EO.droplimb()

	else if(href_list["regenerateicons"])
		if(!check_rights(0))
			return

		var/mob/M = locate(href_list["regenerateicons"])
		if(!ismob(M))
			to_chat(usr, "This can only be done to instances of type /mob")
			return
		M.regenerate_icons()

	else if(href_list["adjustDamage"] && href_list["mobToDamage"])
		if(!check_rights(R_DEBUG|R_ADMIN))
			return

		var/mob/living/L = locate(href_list["mobToDamage"])
		if(!istype(L))
			return

		var/Text = href_list["adjustDamage"]

		var/amount = tgui_input_real_number(usr, "Deal how much damage to mob? (Negative values here heal)","Adjust [Text]loss",0)

		if(!L)
			to_chat(usr, "Mob doesn't exist anymore")
			return

		switch(Text)
			if("brute")
				L.apply_damage(amount, BRUTE, force = TRUE)
			if("fire")
				L.apply_damage(amount, BURN, force = TRUE)
			if("toxin")
				L.apply_damage(amount, TOX, force = TRUE)
			if("oxygen")
				L.apply_damage(amount, OXY, force = TRUE)
			if("brain")
				L.apply_damage(amount, BRAIN, force = TRUE)
			if("clone")
				L.adjustCloneLoss(amount)
			else
				to_chat(usr, "You caused an error. DEBUG: Text:[Text] Mob:[L]")
				return
		L.updatehealth()

		if(amount != 0)
			message_staff("[key_name(usr)] dealt [amount] amount of [Text] damage to [L] ")
			href_list["datumrefresh"] = href_list["mobToDamage"]

	else if(href_list["addtrait"])
		if(!check_rights(R_DEBUG|R_ADMIN|R_SPAWN))
			return

		var/mob/living/carbon/C = locate(href_list["addtrait"])
		if(!istype(C))
			to_chat(usr, "This can only be done to instances of type /mob/living/carbon")
			return
		var/trait_new = tgui_input_list(usr, "Select a trait to add", "Trait", GLOB.mob_traits)
		if(!trait_new)
			return
		ADD_TRAIT(C, trait_new, TRAIT_SOURCE_ADMIN)
		message_staff("TRAIT: [key_name(usr)] added trait '[trait_new]' to [key_name(C)]")

	else if(href_list["removetrait"])
		if(!check_rights(R_DEBUG|R_ADMIN|R_SPAWN))
			return

		var/mob/living/carbon/C = locate(href_list["removetrait"])
		if(!istype(C))
			to_chat(usr, "This can only be done to instances of type /mob/living/carbon")
			return

		var/trait_old = tgui_input_list(usr, "Select a trait to remove", "Trait", C.status_traits)
		if(!trait_old)
			return
		REMOVE_TRAIT(C, trait_old, null)
		message_staff("TRAIT: [key_name(usr)] removed trait '[trait_old]' from [key_name(C)]")

	else if(href_list["setmatrix"])
		if(!check_rights(R_DEBUG|R_ADMIN|R_VAREDIT))
			return

		var/atom/A = locate(href_list["setmatrix"])
		if(!isobj(A) && !ismob(A))
			to_chat(usr, "This can only be done to instances of type /obj and /mob")
			return

		if(!LAZYLEN(stored_matrices))
			to_chat(usr, "You don't have any matrices stored!")
			return

		var/matrix_name = tgui_input_list(usr, "Choose a matrix", "Matrix", (stored_matrices + "Revert to Default" + "Cancel"))
		if(!matrix_name || matrix_name == "Cancel")
			return
		else if (matrix_name == "Revert to Default")
			A.base_transform = null
			A.transform = matrix()
			A.disable_pixel_scaling()
			return

		var/matrix/MX = LAZYACCESS(stored_matrices, matrix_name)
		if(!MX)
			return

		A.base_transform = MX
		A.transform = MX

		if (alert(usr, "Would you like to enable pixel scaling?", "Confirm", "Yes", "No") == "Yes")
			A.enable_pixel_scaling()

		href_list["datumrefresh"] = href_list["setmatrix"]

	if(href_list["datumrefresh"])
		var/datum/DAT = locate(href_list["datumrefresh"])
		if(!istype(DAT, /datum))
			return
		src.debug_variables(DAT)

	return
