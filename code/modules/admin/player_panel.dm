
/datum/admins/proc/player_panel_new()//The new one
	if (!usr.client.admin_holder || !(usr.client.admin_holder.rights & R_MOD))
		return
	var/dat = "<html>"

	//javascript, the part that does most of the work~
	dat += {"
		<head>
			<script type='text/javascript'>

				var locked_tabs = new Array();

				function updateSearch() {
					var filter_text = document.getElementById('filter');
					var filter = filter_text.value.toLowerCase();

					if (complete_list != null && complete_list != "") {
						var mtbl = document.getElementById("maintable_data_archive");
						mtbl.innerHTML = complete_list;
					}

					if (filter.value == "") {
						return;
					} else {
						var maintable_data = document.getElementById('maintable_data');
						var ltr = maintable_data.getElementsByTagName("tr");
						for (var i = 0; i < ltr.length; ++i) {
							try {
								var tr = ltr\[i\];
								if (tr.getAttribute("id").indexOf("data") != 0) {
									continue;
								}
								tr.style.display = '';
								var ltd = tr.getElementsByTagName("td");
								var td = ltd\[0\];
								var lsearch = td.getElementsByTagName("b");
								var search = lsearch\[0\];
								if (search.innerText.toLowerCase().indexOf(filter) == -1) {
									tr.style.display = 'none';
								}
							} catch(err) {}
						}
					}

					var count = 0;
					var index = -1;
					var debug = document.getElementById("debug");

					locked_tabs = new Array();
				}

				function expand(id,job,name,real_name,image,key,ip,ref) {
					clearAll();

					var span = document.getElementById(id);

					body = "<table><tr><td>";
					body += "</td><td align='center'>";
					body += "<font size='2'><b>"+job+" "+name+"</b><br><b>Real name "+real_name+"</b><br><b>Played by "+key+" ("+ip+")</b></font>"
					body += "</td><td align='center'>";

					body += "<a href='?src=\ref[src];ahelp=adminplayeropts;extra="+ref+"'>PP</a> - "
					body += "<a href='?src=\ref[src];playerpanelextended="+ref+"'>PPE</a> - "
					body += "<a href='?src=\ref[src];notes=show;mob="+ref+"'>N</a> - "
					body += "<a href='?_src_=vars;Vars="+ref+"'>VV</a> - "
					body += "<a href='?src=\ref[src];traitor="+ref+"'>TP</a> - "
					body += "<a href='?src=\ref[usr];priv_msg=\ref"+ref+"'>PM</a> - "
					body += "<a href='?src=\ref[src];subtlemessage="+ref+"'>SM</a> - "
					body += "<a href='?src=\ref[src];adminplayerobservejump="+ref+"'>JMP</a><br>"
					body += "</td></tr></table>";

					span.innerHTML = body
				}

				function clearAll() {
					var spans = document.getElementsByTagName('span');
					for (var i = 0; i < spans.length; i++) {
						var span = spans\[i\];

						var id = span.getAttribute("id");

						if(id.indexOf("item") != 0)
							continue;

						var pass = 1;

						for (var j = 0; j < locked_tabs.length; j++) {
							if (locked_tabs\[j\]==id) {
								pass = 0;
								break;
							}
						}

						if (pass != 1)
							continue;

						span.innerHTML = "";
					}
				}

				function addToLocked(id,link_id,notice_span_id) {
					var link = document.getElementById(link_id);
					var decision = link.getAttribute("name");
					if (decision == "1") {
						link.setAttribute("name","2");
					} else {
						link.setAttribute("name","1");
						removeFromLocked(id,link_id,notice_span_id);
						return;
					}

					var pass = 1;
					for (var j = 0; j < locked_tabs.length; j++) {
						if (locked_tabs\[j\]==id) {
							pass = 0;
							break;
						}
					}
					if (!pass)
						return;
					locked_tabs.push(id);
					var notice_span = document.getElementById(notice_span_id);
					notice_span.innerHTML = "<font color='red'>Locked</font> ";
				}

				function attempt(ab) {
					return ab;
				}

				function removeFromLocked(id,link_id,notice_span_id) {
					var index = 0;
					var pass = 0;
					for (var j = 0; j < locked_tabs.length; j++) {
						if (locked_tabs\[j\]==id) {
							pass = 1;
							index = j;
							break;
						}
					}
					if (!pass)
						return;
					locked_tabs\[index\] = "";
					var notice_span = document.getElementById(notice_span_id);
					notice_span.innerHTML = "";
				}

				function selectTextField() {
					var filter_text = document.getElementById('filter');
					filter_text.focus();
					filter_text.select();
				}
			</script>
		</head>


	"}

	//body tag start + onload and onkeypress (onkeyup) javascript event calls
	dat += "<body onload='selectTextField(); updateSearch();'>"

	//title + search bar
	dat += {"
		<table width='560' align='center' cellspacing='0' cellpadding='5' id='maintable'>
			<tr id='title_tr'>
				<td align='center'>
					<font size='5'><b>Player panel</b></font><br>
					Hover over a line to see more information - <a href='?src=\ref[src];check_antagonist=1'>Check antagonists</a>
					<p>
				</td>
			</tr>
			<tr id='search_tr'>
				<td align='center'>
					<b>Search:</b> <input type='text' id='filter' value='' onkeyup='updateSearch();' style='width:300px;'>
				</td>
			</tr>
		</table>
	"}

	//player table header
	dat += {"
		<span id='maintable_data_archive'>
		<table width='600' align='center' cellspacing='0' cellpadding='5' id='maintable_data'>"}

	var/list/mobs = sortmobs()
	var/i = 1
	for(var/mob/M in mobs)
		if(!M.ckey)
			continue
		
		var/color = i % 2 == 0 ? "#6289b7" : "#48709d"

		var/M_job = ""

		if(isliving(M))
			if(iscarbon(M)) //Carbon stuff
				if(ishuman(M))
					M_job = M.job
				else if(ismonkey(M))
					M_job = "Monkey"
				else if(isXeno(M))
					M_job = "Alien"
				else
					M_job = "Carbon-based"
			else if(isSilicon(M)) //silicon
				if(isAI(M))
					M_job = "AI"
				else if(isrobot(M))
					M_job = "Cyborg"
				else
					M_job = "Silicon-based"
			else if(isanimal(M)) //simple animals
				if(iscorgi(M))
					M_job = "Corgi"
				else
					M_job = "Animal"
			else
				M_job = "Living"
		else if(istype(M,/mob/new_player))
			M_job = "New player"
		else if(isobserver(M))
			M_job = "Ghost"

		M_job = replacetext(M_job, "'", "")
		M_job = replacetext(M_job, "\"", "")
		M_job = replacetext(M_job, "\\", "")

		var/M_name = M.name
		M_name = replacetext(M_name, "'", "")
		M_name = replacetext(M_name, "\"", "")
		M_name = replacetext(M_name, "\\", "")
		var/M_rname = M.real_name
		M_rname = replacetext(M_rname, "'", "")
		M_rname = replacetext(M_rname, "\"", "")
		M_rname = replacetext(M_rname, "\\", "")

		var/M_key = M.key
		M_key = replacetext(M_key, "'", "")
		M_key = replacetext(M_key, "\"", "")
		M_key = replacetext(M_key, "\\", "")

		var/extra_info = ""
		if(ishuman(M))
			var/mob/living/carbon/human/H = M
			if(H.agent_holder)
				extra_info = "(<font color='red'>Agent</font>)"

		//output for each mob
		dat += {"
			<tr id='data[i]' name='[i]' onClick="addToLocked('item[i]','data[i]','notice_span[i]')">
				<td align='center' bgcolor='[color]'>
					<span id='notice_span[i]'></span>
					<a id='link[i]'
					onmouseover='expand("item[i]","[M_job]","[M_name]","[M_rname]","--unused--","[M_key]","[M.lastKnownIP]","\ref[M]")'
					>
					<b id='search[i]'>[M_name] - [M_rname] - [M_key] ([M_job])[extra_info]</b>
					</a>
					<br><span id='item[i]'></span>
				</td>
			</tr>
		"}

		i++


	//player table ending
	dat += {"
		</table>
		</span>

		<script type='text/javascript'>
			var maintable = document.getElementById("maintable_data_archive");
			var complete_list = maintable.innerHTML;
		</script>
	</body></html>
	"}

	show_browser(usr, dat, "Admin Player Panel", "players", "size=600x480")

//Extended panel with ban related things
/datum/admins/proc/player_panel_extended()
	if (!usr.client.admin_holder || !(usr.client.admin_holder.rights & R_MOD))
		return

	var/dat = "<html>"
	dat += "<body><table border=1 cellspacing=5><B><tr><th>Key</th><th>Name</th><th>Real Name</th><th>PP</th><th>CID</th><th>IP</th><th>JMP</th><th>Notes</th></tr></B>"
	//add <th>IP:</th> to this if wanting to add back in IP checking
	//add <td>(IP: [M.lastKnownIP])</td> if you want to know their ip to the lists below
	var/list/mobs = sortmobs()

	for(var/mob/M in mobs)
		if(!M.ckey) continue

		dat += "<tr><td>[(M.client ? "[M.client]" : "No client")]</td>"
		dat += "<td><a href='?src=\ref[usr];priv_msg=\ref[M]'>[M.name]</a></td>"
		if(isAI(M))
			dat += "<td>AI</td>"
		else if(isrobot(M))
			dat += "<td>Cyborg</td>"
		else if(ishuman(M))
			dat += "<td>[M.real_name]</td>"
		else if(istype(M, /mob/new_player))
			dat += "<td>New Player</td>"
		else if(isobserver(M))
			dat += "<td>Ghost</td>"
		else if(ismonkey(M))
			dat += "<td>Monkey</td>"
		else if(isXeno(M))
			dat += "<td>Alien</td>"
		else
			dat += "<td>Unknown</td>"


		dat += {"<td align=center><a HREF='?src=\ref[src];ahelp=adminplayeropts;extra=\ref[M]'>X</a></td>
		<td>[M.computer_id]</td>
		<td>[M.lastKnownIP]</td>
		<td><a href='?src=\ref[src];adminplayerobservejump=\ref[M]'>JMP</a></td>
		<td><a href='?src=\ref[src];notes=show;mob=\ref[M]'>Notes</a></td>
		"}


	dat += "</table></body></html>"

	show_browser(usr, dat, "Player Menu", "players", "size=640x480")


/datum/admins/proc/check_antagonists()
	if(!ticker || !(ticker.current_state >= GAME_STATE_PLAYING))
		alert("The game hasn't started yet!")
		return
	
	var/dat = "<html><body><h1><B>Antagonists</B></h1>"
	dat += "Current Game Mode: <B>[ticker.mode.name]</B><BR>"
	dat += "Round Duration: <B>[round(world.time / 36000)]:[add_zero(world.time / 600 % 60, 2)]:[world.time / 100 % 6][world.time / 100 % 10]</B><BR>"
	
	if(LAZYLEN(human_agent_list))
		dat += "<br><table cellspacing=5><tr><td><B>Agents</B></td><td></td><td></td></tr>"
		for(var/mob/living/carbon/human/H in human_agent_list)
			var/location = get_area(H.loc)
			if(H)
				dat += "<tr><td><A href='?src=\ref[usr];priv_msg=\ref[H]'>[H.real_name]</a>[H.client ? "" : " <i>(logged out)</i>"][H.stat == DEAD ? " <b><font color=red>(DEAD)</font></b>" : ""]</td>"
				dat += "<td>[location]</td>"
				dat += "<td>[H.agent_holder.faction]</td>"
				dat += "<td><a href='?src=\ref[usr];track=\ref[H]'>F</a></td>"
				dat += "<td><a href='?src=\ref[src];ahelp=adminplayeropts;extra=\ref[H]'>PP</a></td>"
				dat += "<td><a href='?src=\ref[src];agent=showobjectives;extra=\ref[H]'>Show Objective</a></td></tr>"
		dat += "</table>"

	if(LAZYLEN(other_factions_human_list))
		dat += "<br><table cellspacing=5><tr><td><B>Other human factions</B></td><td></td><td></td></tr>"
		for(var/mob/living/carbon/human/H in other_factions_human_list)
			var/location = get_area(H.loc)
			if(H)
				dat += "<tr><td><A href='?src=\ref[usr];priv_msg=\ref[H]'>[H.real_name]</a>[H.client ? "" : " <i>(logged out)</i>"][H.stat == DEAD ? " <b><font color=red>(DEAD)</font></b>" : ""]</td>"
				dat += "<td>[location]</td>"
				dat += "<td>[H.faction]</td>"
				dat += "<td><a href='?src=\ref[usr];track=\ref[H]'>F</a></td>"
				dat += "<td><a href='?src=\ref[src];ahelp=adminplayeropts;extra=\ref[H]'>PP</a></td>"
		dat += "</table>"

	if(ticker.mode.survivors.len)
		dat += "<br><table cellspacing=5><tr><td><B>Survivors</B></td><td></td><td></td></tr>"
		for(var/datum/mind/L in ticker.mode.survivors)
			var/mob/M = L.current
			var/location = get_area(M.loc)
			if(M)
				dat += "<tr><td><A href='?src=\ref[usr];priv_msg=\ref[M]'>[M.real_name]</a>[M.client ? "" : " <i>(logged out)</i>"][M.stat == 2 ? " <b><font color=red>(DEAD)</font></b>" : ""]</td>"
				dat += "<td>[location]</td>"
				dat += "<td><a href='?src=\ref[usr];track=\ref[M]'>F</a></td>"
				dat += "<td><A href='?src=\ref[src];ahelp=adminplayeropts;extra=\ref[M]'>PP</A></td></TR>"
		dat += "</table>"

	if(ticker.mode.xenomorphs.len)
		dat += "<br><table cellspacing=5><tr><td><B>Aliens</B></td><td></td><td></td></tr>"
		for(var/datum/mind/L in ticker.mode.xenomorphs)
			var/mob/M = L.current
			if(M)
				var/location = get_area(M.loc)
				dat += "<tr><td><A href='?src=\ref[usr];priv_msg=\ref[M]'>[M.real_name]</a>[M.client ? "" : " <i>(logged out)</i>"][M.stat == 2 ? " <b><font color=red>(DEAD)</font></b>" : ""]</td>"
				dat += "<td>[location]</td>"
				dat += "<td><a href='?src=\ref[usr];track=\ref[M]'>F</a></td>"
				dat += "<td><A href='?src=\ref[src];ahelp=adminplayeropts;extra=\ref[M]'>PP</A></td></TR>"
		dat += "</table>"

	if(ticker.mode.survivors.len)
		dat += "<br><table cellspacing=5><tr><td><B>Survivors</B></td><td></td><td></td></tr>"
		for(var/datum/mind/L in ticker.mode.survivors)
			var/mob/M = L.current
			var/location = get_area(M.loc)
			if(M)
				dat += "<tr><td><A href='?src=\ref[usr];priv_msg=\ref[M]'>[M.real_name]</a>[M.client ? "" : " <i>(logged out)</i>"][M.stat == 2 ? " <b><font color=red>(DEAD)</font></b>" : ""]</td>"
				dat += "<td>[location]</td>"
				dat += "<td><a href='?src=\ref[usr];track=\ref[M]'>F</a></td>"
				dat += "<td><A href='?src=\ref[src];ahelp=adminplayeropts;extra=\ref[M]'>PP</A></td></TR>"
		dat += "</table>"

	dat += "</body></html>"
	show_browser(usr, dat, "Antagonists", "antagonists", "size=600x500")

/datum/admins/proc/show_agent_objectives(var/mob/living/carbon/human/H)
	if(!istype(H))
		return

	var/dat = "<html><body><h1><B>Objectives of [H.real_name]</B></h1>"
	for(var/datum/agent_objective/O in H.agent_holder.objectives_list)
		dat += "[O.description] <br><br>"

	dat += "</body></html>"
	show_browser(usr, dat, "Objectives", "objectives", "size=600x500")

/datum/admins/proc/check_round_status()
	if (ticker && ticker.current_state >= GAME_STATE_PLAYING)
		var/dat = "<html><body><h1><B>Round Status</B></h1>"
		dat += "Current Game Mode: <B>[ticker.mode.name]</B><BR>"
		dat += "Round Duration: <B>[round(world.time / 36000)]:[add_zero(world.time / 600 % 60, 2)]:[world.time / 100 % 6][world.time / 100 % 10]</B><BR>"

		if(check_rights(R_DEBUG, 0))
			dat += "<br><A HREF='?_src_=vars;Vars=\ref[EvacuationAuthority]'>VV Evacuation Controller</A><br>"
			dat += "<A HREF='?_src_=vars;Vars=\ref[shuttle_controller]'>VV Shuttle Controller</A><br><br>"

		if(check_rights(R_MOD, 0))
			dat += "<b>Evacuation:</b> "
			switch(EvacuationAuthority.evac_status)
				if(EVACUATION_STATUS_STANDING_BY) dat += 	"STANDING BY"
				if(EVACUATION_STATUS_INITIATING) dat += 	"IN PROGRESS: [EvacuationAuthority.get_status_panel_eta()]"
				if(EVACUATION_STATUS_COMPLETE) dat += 		"COMPLETE"
			dat += "<br>"

			dat += "<a href='?src=\ref[src];evac_authority=init_evac'>Initiate Evacuation</a><br>"
			dat += "<a href='?src=\ref[src];evac_authority=cancel_evac'>Cancel Evacuation</a><br>"
			dat += "<a href='?src=\ref[src];evac_authority=toggle_evac'>Toggle Evacuation Permission (does not affect evac in progress)</a><br>"
			if(check_rights(R_ADMIN, 0)) dat += "<a href='?src=\ref[src];evac_authority=force_evac'>Force Evacuation Now</a><br>"

		if(check_rights(R_ADMIN, 0))
			dat += "<b>Self Destruct:</b> "
			switch(EvacuationAuthority.dest_status)
				if(NUKE_EXPLOSION_INACTIVE) dat += 		"INACTIVE"
				if(NUKE_EXPLOSION_ACTIVE) dat += 		"ACTIVE"
				if(NUKE_EXPLOSION_IN_PROGRESS) dat += 	"IN PROGRESS"
				if(NUKE_EXPLOSION_FINISHED || NUKE_EXPLOSION_GROUND_FINISHED) dat += 		"FINISHED"
			dat += "<br>"

			dat += "<a href='?src=\ref[src];evac_authority=init_dest'>Unlock Self Destruct control panel for humans</a><br>"
			dat += "<a href='?src=\ref[src];evac_authority=cancel_dest'>Lock Self Destruct control panel for humans</a><br>"
			dat += "<a href='?src=\ref[src];evac_authority=use_dest'>Destruct the [MAIN_SHIP_NAME] NOW</a><br>"
			dat += "<a href='?src=\ref[src];evac_authority=toggle_dest'>Toggle Self Destruct Permission (does not affect evac in progress)</a><br>"

		dat += "<br><a href='?src=\ref[src];delay_round_end=1'>[ticker.delay_end ? "End Round Normally" : "Delay Round End"]</a><br>"
		dat += "</body></html>"
		show_browser(usr, dat, "Round Status", "roundstatus", "size=600x500")
	else
		alert("The game hasn't started yet!")

/proc/check_role_table(name, list/members, admins, show_objectives=1)
	var/txt = "<br><table cellspacing=5><tr><td><b>[name]</b></td><td></td></tr>"
	for(var/datum/mind/M in members)
		txt += check_role_table_row(M.current, admins, show_objectives)
	txt += "</table>"
	return txt

/proc/check_role_table_row(mob/M, admins=src, show_objectives)
	if (!istype(M))
		return "<tr><td><i>Not found!</i></td></tr>"

	var/txt = {"
		<tr>
			<td>
				<a href='?src=\ref[admins];ahelp=adminplayeropts;extra=\ref[M]'>[M.real_name]</a>
				[M.client ? "" : " <i>(logged out)</i>"]
				[M.is_dead() ? " <b><font color='red'>(DEAD)</font></b>" : ""]
			</td>
			<td>
				<a href='?src=\ref[usr];priv_msg=\ref[M]'>PM</a>
			</td>
	"}

	if (show_objectives)
		txt += {"
			<td>
				<a href='?src=\ref[admins];traitor=\ref[M]'>Show Objective</a>
			</td>
		"}

	txt += "</tr>"
	return txt

/datum/admins/proc/show_player_panel(var/mob/M in mob_list)
	set name = "Show Player Panel"
	set desc = "Edit player (respawn, ban, heal, etc)"
	set category = null

	if(!M)
		to_chat(usr, "You seem to be selecting a mob that doesn't exist anymore.")
		return
	if (!istype(src,/datum/admins))
		src = usr.client.admin_holder
	if (!istype(src,/datum/admins) || !(src.rights & R_MOD))
		to_chat(usr, "Error: you are not an admin!")
		return

	var/body = "<html>"
	body += "<body>Name: <b>[M]</b>"
	if(M.client)
		body += " - Ckey: <b>[M.client]</b> "
		body += "<A href='?src=\ref[src];editrights=show'>[M.client.admin_holder ? M.client.admin_holder.rank : "Player"]</A>"

	if(istype(M, /mob/new_player))
		body += "| <B>Hasn't Entered Game</B> "
	else
		body += {" <A href='?src=\ref[src];revive=\ref[M]'>Heal</A>
		<br><b>Mob type</b> = [M.type]<br>
		"}

	body += {"
		<a href='?_src_=vars;Vars=\ref[M]'>VV</a> -
		<a href='?src=\ref[src];traitor=\ref[M]'>TP</a> -
		<a href='?src=\ref[usr];priv_msg=\ref[M]'>PM</a> -
		<a href='?src=\ref[src];subtlemessage=\ref[M]'>SM</a> -
		<a href='?src=\ref[src];adminplayerobservejump=\ref[M]'>JMP</a> -
		<a href='?src=\ref[src];adminplayerfollow=\ref[M]'>FLW</a><br>
		<br><b>Admin Tools:</b><br>
		Ban:
		<A href='?src=\ref[src];newban=\ref[M]'>Ban</A> |
		<A href='?src=\ref[src];eorgban=\ref[M]'>EORG Ban</A> |
		<A href='?src=\ref[src];xenoresetname=\ref[M]'>Xeno Name Reset</A> |
		<A href='?src=\ref[src];xenobanname=\ref[M]'>Xeno Name Ban</A> |
		<A href='?src=\ref[src];jobban2=\ref[M]'>Jobban</A> |
		<A href='?src=\ref[src];notes=show;mob=\ref[M]'>Notes</A>
	"}

	if(M.client)
		body += "\ <br>"
		var/muted = M.client.prefs.muted
		body += {"Mute: <A class='[(muted & MUTE_IC)?"red":"blue"]' href='?src=\ref[src];mute=\ref[M];mute_type=[MUTE_IC]'>IC</a> |
			<A class='[(muted & MUTE_OOC)?"red":"blue"]' href='?src=\ref[src];mute=\ref[M];mute_type=[MUTE_OOC]'>OOC</a> |
			<A class='[(muted & MUTE_PRAY)?"red":"blue"]' href='?src=\ref[src];mute=\ref[M];mute_type=[MUTE_PRAY]'>Pray</a> |
			<A class='[(muted & MUTE_ADMINHELP)?"red":"blue"]' href='?src=\ref[src];mute=\ref[M];mute_type=[MUTE_ADMINHELP]'>Ahelp</a> |
			<A class='[(muted & MUTE_DEADCHAT)?"red":"blue"]' href='?src=\ref[src];mute=\ref[M];mute_type=[MUTE_DEADCHAT]'>Dchat</a> |
			<A class='[(muted & MUTE_ALL)?"red":"blue"]' href='?src=\ref[src];mute=\ref[M];mute_type=[MUTE_ALL]'>Toggle All</a>
		"}

	body += {"<br>Misc:
		<A href='?_src_=admin_holder;sendbacktolobby=\ref[M]'>Back to Lobby</A> | <A href='?src=\ref[src];getmob=\ref[M]'>Get</A> | <A href='?src=\ref[src];narrateto=\ref[M]'>Narrate</A> | <A href='?src=\ref[src];sendmob=\ref[M]'>Send</A>
	"}

	if (M.client)
		if(!istype(M, /mob/new_player))
			body += {"<br><br>
				<b>Transformation:</b>
				<br>Humanoid: <A href='?src=\ref[src];simplemake=human;mob=\ref[M]'>Human</A> | <a href='?src=\ref[src];makeyautja=\ref[M]'>Yautja</a> |
				<A href='?src=\ref[src];simplemake=farwa;mob=\ref[M]'>Farwa</A> |
				<A href='?src=\ref[src];simplemake=monkey;mob=\ref[M]'>Monkey</A> |
				<A href='?src=\ref[src];simplemake=neaera;mob=\ref[M]'>Neaera</A> |
				<A href='?src=\ref[src];simplemake=yiren;mob=\ref[M]'>Yiren</A>
				<br>Alien Tier 0: <A href='?src=\ref[src];simplemake=larva;mob=\ref[M]'>Larva</A>
				<br>Alien Tier 1: <A href='?src=\ref[src];simplemake=runner;mob=\ref[M]'>Runner</A> |
				<A href='?src=\ref[src];simplemake=drone;mob=\ref[M]'>Drone</A> |
				<A href='?src=\ref[src];simplemake=sentinel;mob=\ref[M]'>Sentinel</A> |
				<A href='?src=\ref[src];simplemake=defender;mob=\ref[M]'>Defender</A>
				<br>Alien Tier 2: <A href='?src=\ref[src];simplemake=lurker;mob=\ref[M]'>Lurker</A> |
				<A href='?src=\ref[src];simplemake=warrior;mob=\ref[M]'>Warrior</A> |
				<A href='?src=\ref[src];simplemake=spitter;mob=\ref[M]'>Spitter</A> |
				<A href='?src=\ref[src];simplemake=burrower;mob=\ref[M]'>Burrower</A> |
				<A href='?src=\ref[src];simplemake=hivelord;mob=\ref[M]'>Hivelord</A> |
				<A href='?src=\ref[src];simplemake=carrier;mob=\ref[M]'>Carrier</A>
				<br>Alien Tier 3: <A href='?src=\ref[src];simplemake=ravager;mob=\ref[M]'>Ravager</A> |
				<A href='?src=\ref[src];simplemake=praetorian;mob=\ref[M]'>Praetorian</A> |
				<A href='?src=\ref[src];simplemake=boiler;mob=\ref[M]'>Boiler</A> |
				<A href='?src=\ref[src];simplemake=crusher;mob=\ref[M]'>Crusher</A>
				<br>Alien Tier 4: <A href='?src=\ref[src];simplemake=queen;mob=\ref[M]'>Queen</A>
				<A href='?src=\ref[src];simplemake=predalien;mob=\ref[M]'>Predalien</A>
				<br>Misc: <A href='?src=\ref[src];makeai=\ref[M]'>AI</A> | <A href='?src=\ref[src];simplemake=cat;mob=\ref[M]'>Cat</A> |
				<A href='?src=\ref[src];simplemake=corgi;mob=\ref[M]'>Corgi</A> |
				<A href='?src=\ref[src];simplemake=crab;mob=\ref[M]'>Crab</A> | <A href='?src=\ref[src];simplemake=observer;mob=\ref[M]'>Observer</A> | <A href='?src=\ref[src];simplemake=robot;mob=\ref[M]'>Robot</A>
			"}

	body += {"<br><br><b>Other actions:</b>
		<br>
		Force: <A href='?src=\ref[src];forcespeech=\ref[M]'>Force Say</A> | <A href='?src=\ref[src];forceemote=\ref[M]'>Force Emote</A><br>
		Thunderdome: <A href='?src=\ref[src];tdome1=\ref[M]'>Thunderdome 1</A> | <A href='?src=\ref[src];tdome2=\ref[M]'>Thunderdome 2</A>
	"}

	if(ishuman(M))
		body += {"<br>Infection: <A href='?src=\ref[src];larvainfect=\ref[M]'>Xeno Larva</A> | <A href='?src=\ref[src];zombieinfect=\ref[M]'>Zombie Virus</A><br>
				Antagonist:	<A href='?src=\ref[src];makemutineer=\ref[M]'>Make Mutineering Leader</A>
	"}

	body += {"<br>
		</body></html>
	"}

	show_browser(usr, body, "Options for [M.key] played by [M.client]", "adminplayeropts", "size=570x530")
