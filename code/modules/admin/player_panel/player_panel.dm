
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

		//output for each mob
		dat += {"
			<tr id='data[i]' name='[i]' onClick="addToLocked('item[i]','data[i]','notice_span[i]')">
				<td align='center' bgcolor='[color]'>
					<span id='notice_span[i]'></span>
					<a id='link[i]'
					onmouseover='expand("item[i]","[M_job]","[M_name]","[M_rname]","--unused--","[M_key]","[M.lastKnownIP]","\ref[M]")'
					>
					<b id='search[i]'>[M_name] - [M_rname] - [M_key] ([M_job])</b>
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
	if(!SSticker || !(SSticker.current_state >= GAME_STATE_PLAYING))
		alert("The game hasn't started yet!")
		return

	var/dat = "<html><body><h1><B>Antagonists</B></h1>"
	dat += "Current Game Mode: <B>[SSticker.mode.name]</B><BR>"
	dat += "Round Duration: <B>[round(world.time / 36000)]:[add_zero(world.time / 600 % 60, 2)]:[world.time / 100 % 6][world.time / 100 % 10]</B><BR>"

	if(length(GLOB.other_factions_human_list))
		dat += "<br><table cellspacing=5><tr><td><B>Other human factions</B></td><td></td><td></td></tr>"
		for(var/i in GLOB.other_factions_human_list)
			var/mob/living/carbon/human/H = i
			var/location = get_area(H.loc)
			if(H)
				dat += "<tr><td><A href='?src=\ref[usr];priv_msg=\ref[H]'>[H.real_name]</a>[H.client ? "" : " <i>(logged out)</i>"][H.stat == DEAD ? " <b><font color=red>(DEAD)</font></b>" : ""]</td>"
				dat += "<td>[location]</td>"
				dat += "<td>[H.faction]</td>"
				dat += "<td><a href='?src=\ref[usr];track=\ref[H]'>F</a></td>"
				dat += "<td><a href='?src=\ref[src];ahelp=adminplayeropts;extra=\ref[H]'>PP</a></td>"
		dat += "</table>"

	if(SSticker.mode.survivors.len)
		dat += "<br><table cellspacing=5><tr><td><B>Survivors</B></td><td></td><td></td></tr>"
		for(var/datum/mind/L in SSticker.mode.survivors)
			var/mob/M = L.current
			var/location = get_area(M.loc)
			if(M)
				dat += "<tr><td><A href='?src=\ref[usr];priv_msg=\ref[M]'>[M.real_name]</a>[M.client ? "" : " <i>(logged out)</i>"][M.stat == 2 ? " <b><font color=red>(DEAD)</font></b>" : ""]</td>"
				dat += "<td>[location]</td>"
				dat += "<td><a href='?src=\ref[usr];track=\ref[M]'>F</a></td>"
				dat += "<td><A href='?src=\ref[src];ahelp=adminplayeropts;extra=\ref[M]'>PP</A></td></TR>"
		dat += "</table>"

	if(SSticker.mode.xenomorphs.len)
		dat += "<br><table cellspacing=5><tr><td><B>Aliens</B></td><td></td><td></td></tr>"
		for(var/datum/mind/L in SSticker.mode.xenomorphs)
			var/mob/M = L.current
			if(M)
				var/location = get_area(M.loc)
				dat += "<tr><td><A href='?src=\ref[usr];priv_msg=\ref[M]'>[M.real_name]</a>[M.client ? "" : " <i>(logged out)</i>"][M.stat == 2 ? " <b><font color=red>(DEAD)</font></b>" : ""]</td>"
				dat += "<td>[location]</td>"
				dat += "<td><a href='?src=\ref[usr];track=\ref[M]'>F</a></td>"
				dat += "<td><A href='?src=\ref[src];ahelp=adminplayeropts;extra=\ref[M]'>PP</A></td></TR>"
		dat += "</table>"

	if(SSticker.mode.survivors.len)
		dat += "<br><table cellspacing=5><tr><td><B>Survivors</B></td><td></td><td></td></tr>"
		for(var/datum/mind/L in SSticker.mode.survivors)
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

/datum/admins/proc/check_round_status()
	if (SSticker.current_state >= GAME_STATE_PLAYING)
		var/dat = "<html><body><h1><B>Round Status</B></h1>"
		dat += "Current Game Mode: <B>[SSticker.mode.name]</B><BR>"
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

		dat += "<br><a href='?src=\ref[src];delay_round_end=1'>[SSticker.delay_end ? "End Round Normally" : "Delay Round End"]</a><br>"
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

/datum/player_panel
	var/mob/targetMob

/datum/player_panel/New(var/mob/target)
	. = ..()
	targetMob = target


/datum/player_panel/Destroy(force, ...)
	targetMob = null

	SStgui.close_uis(src)
	return ..()


/datum/player_panel/tgui_interact(mob/user, datum/tgui/ui)
	if(!targetMob)
		return

	ui = SStgui.try_update_ui(user, src, ui)
	if (!ui)
		ui = new(user, src, "PlayerPanel", "[targetMob.name] Player Panel")
		ui.open()
		ui.set_autoupdate(FALSE)

// Player panel
/datum/player_panel/ui_data(mob/user)
	. = list()
	.["mob_name"] = targetMob.name

	.["mob_sleeping"] = targetMob.sleeping
	.["mob_frozen"] = targetMob.frozen

	.["mob_speed"] = targetMob.speed
	.["mob_status_flags"] = targetMob.status_flags

	if(isliving(targetMob))
		var/mob/living/L = targetMob
		.["mob_feels_pain"] = L.pain?.feels_pain

	.["current_permissions"] = user.client?.admin_holder?.rights

	if(targetMob.client)
		var/client/targetClient = targetMob.client

		.["client_key"] = targetClient.key
		.["client_ckey"] = targetClient.ckey

		.["client_muted"] = targetClient.prefs.muted
		.["client_rank"] = targetClient.admin_holder ? targetClient.admin_holder.rank : "Player"
		.["client_muted"] = targetClient.prefs.muted

/datum/player_panel/ui_state(mob/user)
	return GLOB.admin_state

GLOBAL_LIST_INIT(mute_bits, list(
	list(name = "IC", bitflag = MUTE_IC),
	list(name = "OOC", bitflag = MUTE_OOC),
	list(name = "Pray", bitflag = MUTE_PRAY),
	list(name = "Adminhelp", bitflag = MUTE_ADMINHELP),
	list(name = "Deadchat", bitflag = MUTE_DEADCHAT)
))

GLOBAL_LIST_INIT(narrate_span, list(
	list(name = "Notice", span = "notice"),
	list(name = "Warning", span = "warning"),
	list(name = "Alert", span = "alert"),
	list(name = "Info", span = "info"),
	list(name = "Danger", span = "danger"),
	list(name = "Helpful", span = "helpful")
))

GLOBAL_LIST_INIT(pp_hives, pp_generate_hives())

/proc/pp_generate_hives()
	. = list()
	for(var/hivenumber in GLOB.hive_datum)
		var/datum/hive_status/H = GLOB.hive_datum[hivenumber]
		.[H.name] = H.hivenumber

GLOBAL_LIST_INIT(pp_limbs, list(
	"Head" = "head",
	"Left leg" = "l_leg",
	"Right leg" = "r_leg",
	"Left arm" = "l_arm",
	"Right arm" = "r_arm"
))

GLOBAL_LIST_INIT(pp_status_flags, list(
	"Stun" = CANSTUN,
	"Knockdown" = CANKNOCKDOWN,
	"Knockout" = CANKNOCKOUT,
	"Push" = CANPUSH,
	"Slow" = CANSLOW,
	"Daze" = CANDAZE,
	"Godmode" = GODMODE
))

/datum/player_panel/ui_static_data(mob/user)
	. = list()
	.["mob_type"] = targetMob.type

	.["is_human"] = ishuman(targetMob)
	.["is_xeno"] = isXeno(targetMob)

	.["glob_status_flags"] = GLOB.pp_status_flags
	.["glob_limbs"] = GLOB.pp_limbs
	.["glob_hives"] = GLOB.pp_hives
	.["glob_mute_bits"] = GLOB.mute_bits
	.["glob_pp_actions"] = GLOB.pp_actions_data
	.["glob_span"] = GLOB.narrate_span
	.["glob_pp_transformables"] = GLOB.pp_transformables

/datum/player_panel/ui_act(action, list/params, datum/tgui/ui, datum/ui_state/state)
	. = ..()

	if(.)
		return

	var/client/clUser = ui.user.client

	var/datum/player_action/P = GLOB.pp_actions[action]
	if(!P)
		return

	if(!check_client_rights(clUser, P.permissions_required))
		return

	return P.act(clUser, targetMob, params)

/datum/admins/proc/show_player_panel(var/mob/M in GLOB.mob_list)
	set name = "Show Player Panel"
	set desc = "Edit player (respawn, ban, heal, etc)"
	set category = null

	if(!M)
		to_chat(owner, "You seem to be selecting a mob that doesn't exist anymore.")
		return

	// this is stupid, thanks byond
	if(istype(src, /client))
		var/client/C = src
		src = C.admin_holder

	if (!istype(src,/datum/admins) || !(src.rights & R_MOD))
		to_chat(owner, "Error: you are not an admin!")
		return

	if(!M.mob_panel)
		M.create_player_panel()

	M.mob_panel.tgui_interact(owner.mob)
