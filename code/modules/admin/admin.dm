
var/global/BSACooldown = 0
var/global/floorIsLava = 0


////////////////////////////////
/proc/message_admins(var/msg) // +ADMIN and above
	msg = "<span class=\"admin\"><span class=\"prefix\">ADMIN LOG:</span> <span class=\"message\">[msg]</span></span>"
	log_adminwarn(msg)
	for(var/client/C in admins)
		if(C && C.admin_holder && (R_ADMIN & C.admin_holder.rights))
			to_chat(C, msg)

/proc/message_staff(var/msg) // ALL staff - including Mentors
	msg = "<span class=\"admin\"><span class=\"prefix\">STAFF LOG:</span> <span class=\"message\">[msg]</span></span>"
	log_adminwarn(msg)
	for(var/client/C in admins)
		if(C && C.admin_holder && (R_MOD & C.admin_holder.rights))
			to_chat(C, msg)

/proc/msg_admin_attack(var/text) //Toggleable Attack Messages
	log_attack(text)
	var/rendered = "<span class=\"admin\"><span class=\"prefix\">ATTACK:</span> <span class=\"message\">[text]</span></span>"
	for(var/client/C in admins)
		if(C && C.admin_holder && (R_MOD & C.admin_holder.rights))
			if(C.prefs.toggles_chat & CHAT_ATTACKLOGS)
				var/msg = rendered
				to_chat(C, msg)

/proc/msg_admin_niche(var/msg) //Toggleable Niche Messages
	log_admin(msg)
	msg = "<span class=\"admin\"><span class=\"prefix\">ADMIN NICHE LOG:</span> <span class=\"message\">[msg]</span></span>"
	for(var/client/C in admins)
		if(C && C.admin_holder && (R_MOD & C.admin_holder.rights))
			if(C.prefs.toggles_chat & CHAT_NICHELOGS)
				to_chat(C, msg)

/proc/msg_admin_ff(var/text)
	log_attack(text) //Do everything normally BUT IN GREEN SO THEY KNOW
	var/rendered = "<span class=\"admin\"><span class=\"prefix\">ATTACK:</span> <font color=#00ff00><b>[text]</b></font></span>" //I used <font> because I never learned html correctly, fix this if you want
	for(var/client/C in admins)
		if(C && C.admin_holder && (R_MOD & C.admin_holder.rights))
			if(C.prefs.toggles_chat & CHAT_FFATTACKLOGS)
				var/msg = rendered
				to_chat(C, msg)

///////////////////////////////////////////////////////////////////////////////////////////////Panels

/datum/admins/proc/show_player_panel(var/mob/M in mob_list)
	set category = null
	set name = "Show Player Panel"
	set desc="Edit player (respawn, ban, heal, etc)"

	if(!M)
		to_chat(usr, "You seem to be selecting a mob that doesn't exist anymore.")
		return
	if (!istype(src,/datum/admins))
		src = usr.client.admin_holder
	if (!istype(src,/datum/admins) || !(src.rights & R_MOD))
		to_chat(usr, "Error: you are not an admin!")
		return

	var/body = "<html><head><title>Options for [M.key] played by [M.client]</title></head>"
	body += "<body>Name: <b>[M]</b>"
	if(M.client)
		body += " - Ckey: <b>[M.client]</b> "
		body += "\[<A href='?src=\ref[src];editrights=show'>[M.client.admin_holder ? M.client.admin_holder.rank : "Player"]</A>\]"

	if(istype(M, /mob/new_player))
		body += "| <B>Hasn't Entered Game</B> "
	else
		body += {" \[<A href='?src=\ref[src];revive=\ref[M]'>Heal</A>\]
		<br><b>Mob type</b> = [M.type]<br>
		"}

	body += {"
		\[
		<a href='?_src_=vars;Vars=\ref[M]'>VV</a> -
		<a href='?src=\ref[src];traitor=\ref[M]'>TP</a> -
		<a href='?src=\ref[usr];priv_msg=\ref[M]'>PM</a> -
		<a href='?src=\ref[src];subtlemessage=\ref[M]'>SM</a> -
		<a href='?src=\ref[src];adminplayerobservejump=\ref[M]'>JMP</a> -
		<a href='?src=\ref[src];adminplayerfollow=\ref[M]'>FLW</a> ]<br>
		<br><b>Admin Tools:</b><br>
		\[ Ban:
		<A href='?src=\ref[src];newban=\ref[M]'>Ban</A> |
		<A href='?src=\ref[src];eorgban=\ref[M]'>EORG Ban</A> |
		<A href='?src=\ref[src];jobban2=\ref[M]'>Jobban</A> |
		<A href='?src=\ref[src];notes=show;mob=\ref[M]'>Notes</A> ]
	"}

	if(M.client)
		body += "\ <br>"
		var/muted = M.client.prefs.muted
		body += {"\[ Mute: <A href='?src=\ref[src];mute=\ref[M];mute_type=[MUTE_IC]'><font color='[(muted & MUTE_IC)?"red":"blue"]'>IC</font></a> |
			<A href='?src=\ref[src];mute=\ref[M];mute_type=[MUTE_OOC]'><font color='[(muted & MUTE_OOC)?"red":"blue"]'>OOC</font></a> |
			<A href='?src=\ref[src];mute=\ref[M];mute_type=[MUTE_PRAY]'><font color='[(muted & MUTE_PRAY)?"red":"blue"]'>Pray</font></a> |
			<A href='?src=\ref[src];mute=\ref[M];mute_type=[MUTE_ADMINHELP]'><font color='[(muted & MUTE_ADMINHELP)?"red":"blue"]'>Ahelp</font></a> |
			<A href='?src=\ref[src];mute=\ref[M];mute_type=[MUTE_DEADCHAT]'><font color='[(muted & MUTE_DEADCHAT)?"red":"blue"]'>Dchat</font></a> |
			 <A href='?src=\ref[src];mute=\ref[M];mute_type=[MUTE_ALL]'><font color='[(muted & MUTE_ALL)?"red":"blue"]'>Toggle All</font></a> ]
		"}

	body += {"<br>\[ Misc:
		<A href='?_src_=admin_holder;sendbacktolobby=\ref[M]'>Back to Lobby</A> | <A href='?src=\ref[src];getmob=\ref[M]'>Get</A> | <A href='?src=\ref[src];narrateto=\ref[M]'>Narrate</A> | <A href='?src=\ref[src];sendmob=\ref[M]'>Send</A> ]
	"}

	if (M.client)
		if(!istype(M, /mob/new_player))
			body += {"<br><br>
				<b>Transformation:</b>
				<br>\[ Humanoid: <A href='?src=\ref[src];simplemake=human;mob=\ref[M]'>Human</A> | <a href='?src=\ref[src];makeyautja=\ref[M]'>Yautja</a> |
				<A href='?src=\ref[src];simplemake=farwa;mob=\ref[M]'>Farwa</A> |
				<A href='?src=\ref[src];simplemake=monkey;mob=\ref[M]'>Monkey</A> |
				<A href='?src=\ref[src];simplemake=neaera;mob=\ref[M]'>Neaera</A> |
				<A href='?src=\ref[src];simplemake=yiren;mob=\ref[M]'>Yiren</A> \]
				<br>\[ Alien Tier 0: <A href='?src=\ref[src];simplemake=larva;mob=\ref[M]'>Larva</A> \]
				<br>\[ Alien Tier 1: <A href='?src=\ref[src];simplemake=runner;mob=\ref[M]'>Runner</A> |
				<A href='?src=\ref[src];simplemake=drone;mob=\ref[M]'>Drone</A> |
				<A href='?src=\ref[src];simplemake=sentinel;mob=\ref[M]'>Sentinel</A> |
				<A href='?src=\ref[src];simplemake=defender;mob=\ref[M]'>Defender</A> \]
				<br>\[ Alien Tier 2: <A href='?src=\ref[src];simplemake=lurker;mob=\ref[M]'>Lurker</A> |
				<A href='?src=\ref[src];simplemake=warrior;mob=\ref[M]'>Warrior</A> |
				<A href='?src=\ref[src];simplemake=spitter;mob=\ref[M]'>Spitter</A> |
				<A href='?src=\ref[src];simplemake=burrower;mob=\ref[M]'>Burrower</A> |
				<A href='?src=\ref[src];simplemake=hivelord;mob=\ref[M]'>Hivelord</A> |
				<A href='?src=\ref[src];simplemake=carrier;mob=\ref[M]'>Carrier</A> \]
				<br>\[ Alien Tier 3: <A href='?src=\ref[src];simplemake=ravager;mob=\ref[M]'>Ravager</A> |
				<A href='?src=\ref[src];simplemake=praetorian;mob=\ref[M]'>Praetorian</A> |
				<A href='?src=\ref[src];simplemake=boiler;mob=\ref[M]'>Boiler</A> |
				<A href='?src=\ref[src];simplemake=crusher;mob=\ref[M]'>Crusher</A> \]
				<br>\[ Alien Tier 4: <A href='?src=\ref[src];simplemake=queen;mob=\ref[M]'>Queen</A> \]
				<br>\[ Alien Specials: <A href='?src=\ref[src];simplemake=ravenger;mob=\ref[M]'>Ravenger</A> |
				<A href='?src=\ref[src];simplemake=predalien;mob=\ref[M]'>Predalien</A> \]
				<br>\[ Misc: <A href='?src=\ref[src];makeai=\ref[M]'>AI</A> | <A href='?src=\ref[src];simplemake=cat;mob=\ref[M]'>Cat</A> |
				<A href='?src=\ref[src];simplemake=corgi;mob=\ref[M]'>Corgi</A> |
				<A href='?src=\ref[src];simplemake=crab;mob=\ref[M]'>Crab</A> | <A href='?src=\ref[src];simplemake=observer;mob=\ref[M]'>Observer</A> | <A href='?src=\ref[src];simplemake=robot;mob=\ref[M]'>Robot</A> \]
			"}

	body += {"<br><br><b>Other actions:</b>
		<br>
		\[ Force: <A href='?src=\ref[src];forcespeech=\ref[M]'>Force Say</A> | <A href='?src=\ref[src];forceemote=\ref[M]'>Force Emote</A> ]<br>
		\[ Thunderdome: <A href='?src=\ref[src];tdome1=\ref[M]'>Thunderdome 1</A> | <A href='?src=\ref[src];tdome2=\ref[M]'>Thunderdome 2</A> ]
	"}

	if(ishuman(M))
		body += {"<br>\[ Infection: <A href='?src=\ref[src];larvainfect=\ref[M]'>Xeno Larva</A> | <A href='?src=\ref[src];zombieinfect=\ref[M]'>Zombie Virus</A> ]
	"}

	if(isXeno(M))
		body += "<br>\[ Upgrade: <A href='?src=\ref[src];xenoupgrade=\ref[M]'>Upgrade Xeno</A> ]"

	body += {"<br>
		</body></html>
	"}

	usr << browse(body, "window=adminplayeropts;size=550x515")
	 


/datum/player_info/var/author // admin who authored the information
/datum/player_info/var/rank //rank of admin who made the notes
/datum/player_info/var/content // text content of the information
/datum/player_info/var/timestamp // Because this is bloody annoying

#define PLAYER_NOTES_ENTRIES_PER_PAGE 50
/datum/admins/proc/player_notes_list()
	set category = "Admin"
	set name = "Player Notes List"
	if (!istype(src,/datum/admins))
		src = usr.client.admin_holder
	if (!istype(src,/datum/admins) || !(src.rights & R_MOD))
		to_chat(usr, "Error: you are not an admin!")
		return
	PlayerNotesPage(1)

/datum/admins/proc/PlayerNotesPage(page)
	var/dat = "<B>Player notes</B><HR>"
	var/savefile/S=new("data/player_notes.sav")
	var/list/note_keys
	S >> note_keys
	if(!note_keys)
		dat += "No notes found."
	else
		dat += "<table>"
		note_keys = sortList(note_keys)

		// Display the notes on the current page
		var/number_pages = note_keys.len / PLAYER_NOTES_ENTRIES_PER_PAGE
		// Emulate ceil(why does BYOND not have ceil)
		if(number_pages != round(number_pages))
			number_pages = round(number_pages) + 1
		var/page_index = page - 1
		if(page_index < 0 || page_index >= number_pages)
			return

		var/lower_bound = page_index * PLAYER_NOTES_ENTRIES_PER_PAGE + 1
		var/upper_bound = (page_index + 1) * PLAYER_NOTES_ENTRIES_PER_PAGE
		upper_bound = min(upper_bound, note_keys.len)
		for(var/index = lower_bound, index <= upper_bound, index++)
			var/t = note_keys[index]
			dat += "<tr><td><a href='?src=\ref[src];notes=show;ckey=[t]'>[t]</a></td></tr>"

		dat += "</table><br>"

		// Display a footer to select different pages
		for(var/index = 1, index <= number_pages, index++)
			if(index == page)
				dat += "<b>"
			dat += "<a href='?src=\ref[src];notes=list;index=[index]'>[index]</a> "
			if(index == page)
				dat += "</b>"

	usr << browse(dat, "window=player_notes;size=400x400")


/datum/admins/proc/player_has_info(var/key as text)
	var/savefile/info = new("data/player_saves/[copytext(key, 1, 2)]/[key]/info.sav")
	var/list/infos
	info >> infos
	if(!infos || !infos.len) return 0
	else return 1


/datum/admins/proc/player_notes_show(var/key as text)
	set category = "Admin"
	set name = "Player Notes Show"
	if (!istype(src,/datum/admins))
		src = usr.client.admin_holder
	if (!istype(src,/datum/admins) || !(src.rights & R_MOD))
		to_chat(usr, "Error: you are not an admin!")
		return
	var/dat = "<html><head><title>Info on [key]</title></head>"
	dat += "<body>"

	var/savefile/info = new("data/player_saves/[copytext(key, 1, 2)]/[key]/info.sav")
	var/list/infos
	info >> infos
	if(!infos)
		dat += "No information found on the given key.<br>"
	else
		var/update_file = 0
		var/i = 0
		for(var/datum/player_info/I in infos)
			i += 1
			if(!I.timestamp)
				I.timestamp = "Pre-4/3/2012"
				update_file = 1
			if(!I.rank)
				I.rank = "N/A"
				update_file = 1
			dat += "<font color=#008800>[I.content]</font> <i>by [I.author] ([I.rank])</i> on <i><font color=blue>[I.timestamp]</i></font> "
			if(I.author == usr.key || I.author == "Adminbot" || ishost(usr))
				dat += "<A href='?src=\ref[src];remove_player_info=[key];remove_index=[i]'>Remove</A>"
			dat += "<br><br>"
		if(update_file) info << infos

	dat += "<br>"
	dat += "<A href='?src=\ref[src];add_player_info=[key]'>Add Comment</A><br>"
	dat += "<A href='?src=\ref[src];player_notes_copy=[key]'>Copy Player Notes</A><br>"

	dat += "</body></html>"
	usr << browse(dat, "window=adminplayerinfo;size=480x480")


/datum/admins/proc/player_notes_copy(var/key as text)
	set category = null
	set name = "Player Notes Copy"
	if (!istype(src,/datum/admins))
		src = usr.client.admin_holder
	if (!istype(src,/datum/admins) || !(src.rights & R_MOD))
		to_chat(usr, "Error: you are not an admin!")
		return
	var/dat = "<html><head><title>Copying notes for [key]</title></head>"
	dat += "<body>"
	var/savefile/info = new("data/player_saves/[copytext(key, 1, 2)]/[key]/info.sav")
	var/list/infos
	info >> infos
	if(!infos)
		dat += "No information found on the given key.<br>"
	else
		dat += "Some notes might need to be omitted for security/privacy reasons!<br><hr>"
		var/i = 0
		for(var/datum/player_info/I in infos)
			i += 1
			if(!I.timestamp)
				I.timestamp = "Pre-4/3/2012"
			dat += "<font color=#008800>[I.content]</font> | <i><font color=blue>[I.timestamp]</i></font>"
			dat += "<br><br>"
	dat += "</body></html>"
	// Using regex to remove the note author for bans done in admin/topic.dm
	var/regex/remove_author = new("(?=Banned by).*?(?=\\|)", "g")
	dat = remove_author.Replace(dat, "Banned ")

	usr << browse(dat, "window=notescopy;size=480x480")


/datum/admins/proc/Jobbans()
	if(!check_rights(R_BAN)) return
	var/L[] //List reference.
	var/r //rank --This will always be a string.
	var/c //ckey --This will always be a string.
	var/i //individual record / ban reason
	var/t //text to show in the window
	var/u //unban button href arg
	var/dat = "<b>Job Bans!</b><hr><table>"
	for(r in jobban_keylist)
		L = jobban_keylist[r]
		for(c in L)
			i = jobban_keylist[r][c] //These are already strings, as you're iterating through them. Anyway, establish jobban.
			t = "[c] - [r] ## [i]"
			u = "[c] - [r]"
			dat += "<tr><td>[t] (<A href='?src=\ref[src];removejobban=[u]'>unban</A>)</td></tr>"
	dat += "</table>"
	usr << browse(dat, "window=ban;size=400x400")

/datum/admins/proc/Chem()
	if(!check_rights(R_MOD)) return

	var/dat = {"<center><B>Chem Panel</B></center><hr>\n"}
	if(check_rights(R_MOD,0))
		dat += {"<A href='?src=\ref[src];chem_panel=view_reagent'>View Reagent</A><br>
				"}
	if(check_rights(R_VAREDIT,0))
		dat += {"<A href='?src=\ref[src];chem_panel=view_reaction'>View Reaction</A><br>
				<br>"}
	if(check_rights(R_SPAWN,0))
		dat += {"<A href='?src=\ref[src];chem_panel=spawn_reagent'>Spawn Reagent in Container</A><br>
				<br>"}
	if(check_rights(R_FUN,0))
		dat += {"<A href='?src=\ref[src];chem_panel=create_random_reagent'>Generate Reagent</A><br>
				<br>
				<A href='?src=\ref[src];chem_panel=create_custom_reagent'>Create Custom Reagent</A><br>
				<A href='?src=\ref[src];chem_panel=create_custom_reaction'>Create Custom Reaction</A><br>
				"}

	usr << browse(dat, "window=chempanel;size=210x300")
	return

/datum/admins/proc/Game()
	if(!check_rights(0))	return

	var/dat = {"
		<center><B>Game Panel</B></center><hr>\n
		<A href='?src=\ref[src];c_mode=1'>Change Game Mode</A><br>
		"}
	if(master_mode == "secret")
		dat += "<A href='?src=\ref[src];f_secret=1'>(Force Secret Mode)</A><br>"

	dat += {"
		<BR>
		<A href='?src=\ref[src];create_object=1'>Create Object</A><br>
		<A href='?src=\ref[src];quick_create_object=1'>Quick Create Object</A><br>
		<A href='?src=\ref[src];create_turf=1'>Create Turf</A><br>
		<A href='?src=\ref[src];create_mob=1'>Create Mob</A><br>
		"}

	usr << browse(dat, "window=admin2;size=210x280")
	return

/datum/admins/proc/Secrets()
	if(!check_rights(0))	return

	var/dat = "<B>The first rule of adminbuse is: you don't talk about the adminbuse.</B><HR>"

	if(check_rights(R_ADMIN,0))
		dat += {"
			<B>Admin Secrets</B><BR>
			<BR>
			<A href='?src=\ref[src];secretsadmin=list_bombers'>Bombing List</A><BR>
			<A href='?src=\ref[src];secretsadmin=check_antagonist'>Check Antagonists</A><BR>
			<A href='?src=\ref[src];secretsadmin=list_signalers'>Show last [length(lastsignalers)] signalers</A><BR>
			<A href='?src=\ref[src];secretsadmin=list_lawchanges'>Show last [length(lawchanges)] law changes</A><BR>
			<A href='?src=\ref[src];secretsadmin=showgm'>Show Game Mode</A><BR>
			<A href='?src=\ref[src];secretsadmin=manifest'>Show Crew Manifest</A><BR>
			<A href='?src=\ref[src];secretsadmin=DNA'>List DNA (Blood)</A><BR>
			<A href='?src=\ref[src];secretsfun=launchshuttle'>Launch a shuttle normally</A> (inop)<BR>
			<A href='?src=\ref[src];secretsfun=moveshuttle'>Move a shuttle instantly</A> (inop)<BR>
			<BR>
			"}

	if(check_rights(R_FUN,0))
		dat += {"

			<B>Game master section</B><BR>
			<BR>
			<A href='?src=\ref[src];secretsfun=decrease_defcon'>Decrease DEFCON level</A><BR>
			<A href='?src=\ref[src];secretsfun=give_defcon_points'>Give DEFCON points</A><BR>
			<A href='?src=\ref[src];secretsfun=unpower'>Unpower ship SMESs and APCs</A><BR>
			<A href='?src=\ref[src];secretsfun=power'>Power ship SMESs and APCs</A><BR>
			<A href='?src=\ref[src];secretsfun=quickpower'>Power ship SMESs</A><BR>
			<A href='?src=\ref[src];secretsfun=powereverything'>Power ALL SMESs and APCs everywhere</A><BR>
			<A href='?src=\ref[src];secretsfun=powershipreactors'>Power all ship reactors</A><BR>
			<A href='?src=\ref[src];secretsfun=blackout'>Break all lights</A><BR>
			<A href='?src=\ref[src];secretsfun=whiteout'>Fix all lights</A><BR>
			<BR>
			<B>'Random' Events</B><BR>
			<BR>
			<A href='?src=\ref[src];secretsfun=gravity'>Toggle station artificial gravity</A> (inop)<BR> <!--Needs to not affect planets-->
			<A href='?src=\ref[src];secretsfun=spiders'>Trigger a Spider infestation</A> (inop)<BR> <!--Not working -->
			<A href='?src=\ref[src];secretsfun=radiation'>Irradiate the station</A> (inop)<BR> <!--Not working -->
			<A href='?src=\ref[src];secretsfun=virus'>Trigger a Virus Outbreak</A> (inop)<BR> <!--Not working -->
			<A href='?src=\ref[src];secretsfun=lightsout'>Toggle a "lights out" event</A> (inop)<BR> <!--Not working -->
			<A href='?src=\ref[src];secretsfun=spacevines'>Spawn Space-Vines</A> (inop)<BR> <!--Not working -->
			<A href='?src=\ref[src];secretsfun=comms_blackout'>Trigger a Communication Blackout</A><BR>
			<BR>
			<B>Fun Secrets</B><BR>
			<BR>
			<A href='?src=\ref[src];secretsfun=unpower'>Unpower ship SMESs and APCs</A><BR>
			<A href='?src=\ref[src];secretsfun=power'>Power ship SMESs and APCs</A><BR>
			<A href='?src=\ref[src];secretsfun=quickpower'>Power ship SMESs</A><BR>
			<A href='?src=\ref[src];secretsfun=powereverything'>Power ALL SMESs and APCs everywhere</A><BR>
			<A href='?src=\ref[src];secretsfun=powershipreactors'>Power all ship reactors</A><BR>
			<A href='?src=\ref[src];secretsfun=blackout'>Break all lights</A><BR>
			<A href='?src=\ref[src];secretsfun=whiteout'>Fix all lights</A><BR>
			<BR>
			<B>Mass-Teleportation</B><BR>
			<BR>
			<A href='?src=\ref[src];secretsfun=gethumans'>Get ALL humans</A><BR>
			<A href='?src=\ref[src];secretsfun=getxenos'>Get ALL Xenos</A><BR>
			<A href='?src=\ref[src];secretsfun=getall'>Get ALL living, cliented mobs</A><BR>
			<BR>
			<B>Mass-Rejuvenate</B><BR>
			<BR>
			<A href='?src=\ref[src];secretsfun=rejuvall'>Rejuv ALL living, cliented mobs</A><BR>
			"}

	if(check_rights(R_DEBUG,0))
		dat += {"
			<BR>
			<A href='?src=\ref[src];secretscoder=spawn_objects'>Admin Log</A><BR>
			<BR>
			"}

	usr << browse(dat, "window=secrets")
	return



/////////////////////////////////////////////////////////////////////////////////////////////////admins2.dm merge
//i.e. buttons/verbs


/datum/admins/proc/restart()
	set category = "Server"
	set name = "Restart"
	set desc="Restarts the world"
	if (!usr.client.admin_holder || !(usr.client.admin_holder.rights & R_MOD))
		return
	var/confirm = alert("Restart the game world?", "Restart", "Yes", "Cancel")
	if(confirm == "Cancel")
		return
	if(confirm == "Yes")
		to_world(SPAN_DANGER("<b>Restarting world!</b> [SPAN_NOTICE("Initiated by [usr.client.admin_holder.fakekey ? "Admin" : usr.key]!")]"))
		log_admin("[key_name(usr)] initiated a reboot.")

		sleep(50)
		world.Reboot()


/datum/admins/proc/announce()
	set category = "Special Verbs"
	set name = "Announce"
	set desc="Announce your desires to the world"
	if(!check_rights(0))	return

	var/message = input("Global message to send:", "Admin Announce", null, null)  as message
	if(message)
		if(!check_rights(R_SERVER,0))
			message = adminscrub(message,500)
		to_world(SPAN_NOTICE(" <b>[usr.client.admin_holder.fakekey ? "Administrator" : usr.key] Announces:</b>\n \t [message]"))
		log_admin("Announce: [key_name(usr)] : [message]")
	 

/datum/admins/proc/toggleooc()
	set category = "Server"
	set desc="Globally Toggles OOC"
	set name="Toggle OOC"
	ooc_allowed = !( ooc_allowed )
	if (ooc_allowed)
		to_world("<B>The OOC channel has been globally enabled!</B>")
	else
		to_world("<B>The OOC channel has been globally disabled!</B>")
	log_admin("[key_name(usr)] toggled OOC.")
	message_admins("[key_name_admin(usr)] toggled OOC.", 1)
	 

/datum/admins/proc/togglelooc()
	set category = "Server"
	set desc="Globally Toggles LOOC"
	set name="Toggle LOOC"
	looc_allowed = !( looc_allowed )
	if (looc_allowed)
		to_world("<B>The LOOC channel has been globally enabled!</B>")
	else
		to_world("<B>The LOOC channel has been globally disabled!</B>")
	log_admin("[key_name(usr)] toggled LOOC.")
	message_admins("[key_name_admin(usr)] toggled LOOC.", 1)
	 

/datum/admins/proc/toggledsay()
	set category = "Server"
	set desc = "Globally Toggles Deadchat"
	set name = "Toggle Deadchat"
	dsay_allowed = !( dsay_allowed )
	if(dsay_allowed)
		to_world("<B>Deadchat has been globally enabled!</B>")
	else
		to_world("<B>Deadchat has been globally disabled!</B>")
	log_admin("[key_name(usr)] toggled deadchat.")
	message_admins("[key_name_admin(usr)] toggled deadchat.", 1)
	 

/datum/admins/proc/toggleoocdead()
	set category = "Server"
	set desc="Toggle the ability for dead people to use OOC chat"
	set name="Toggle Dead OOC"
	dooc_allowed = !( dooc_allowed )

	log_admin("[key_name(usr)] toggled Dead OOC.")
	message_admins("[key_name_admin(usr)] toggled Dead OOC.", 1)
	 

/datum/admins/proc/toggleloocdead()
	set category = "Server"
	set desc="Toggle the ability for dead people to use LOOC chat"
	set name="Toggle Dead LOOC"
	dlooc_allowed = !( dlooc_allowed )

	log_admin("[key_name(usr)] toggled Dead LOOC.")
	message_admins("[key_name_admin(usr)] toggled Dead LOOC.", 1)
	 

/datum/admins/proc/toggletraitorscaling()
	set category = "Server"
	set desc="Toggle traitor scaling"
	set name="Toggle Traitor Scaling"
	traitor_scaling = !traitor_scaling
	log_admin("[key_name(usr)] toggled Traitor Scaling to [traitor_scaling].")
	message_admins("[key_name_admin(usr)] toggled Traitor Scaling [traitor_scaling ? "on" : "off"].", 1)
	 

/datum/admins/proc/startnow()
	set category = "Server"
	set desc="Start the round RIGHT NOW"
	set name="Start Now"
	if (!ticker)
		alert("Unable to start the game as it is not set up.")
		return
	if (alert("Are you sure you want to start the round early?",,"Yes","No") != "Yes")
		return
	if (ticker.current_state == GAME_STATE_PREGAME)
		ticker.current_state = GAME_STATE_SETTING_UP
		log_admin("[usr.key] has started the game.")
		message_admins("<font color='blue'>[usr.key] has started the game.</font>")
		 
		return 1
	else
		to_chat(usr, "<font color='red'>Error: Start Now: Game has already started.</font>")
		return 0

/datum/admins/proc/togglejoin()
	set category = "Server"
	set desc="Players can still log into the server, but Marines won't be able to join the game as a new mob."
	set name="Toggle Joining"
	enter_allowed = !( enter_allowed )
	if (!( enter_allowed ))
		to_world("<B>New players may no longer join the game.</B>")
	else
		to_world("<B>New players may now join the game.</B>")
	log_admin("[key_name(usr)] toggled new player game joining.")
	message_admins(SPAN_NOTICE("[key_name_admin(usr)] toggled new player game joining."), 1)
	world.update_status()
	 

/datum/admins/proc/toggleAI()
	set category = "Server"
	set desc="People can't be AI"
	set name="Toggle AI"
	config.allow_ai = !( config.allow_ai )
	if (!( config.allow_ai ))
		to_world("<B>The AI job is no longer chooseable.</B>")
	else
		to_world("<B>The AI job is chooseable now.</B>")
	log_admin("[key_name(usr)] toggled AI allowed.")
	world.update_status()
	 

/datum/admins/proc/toggleaban()
	set category = "Server"
	set desc="Respawn basically"
	set name="Toggle Respawn"
	abandon_allowed = !( abandon_allowed )
	if (abandon_allowed)
		to_world("<B>You may now respawn.</B>")
	else
		to_world("<B>You may no longer respawn :(</B>")
	message_admins(SPAN_NOTICE("[key_name_admin(usr)] toggled respawn to [abandon_allowed ? "On" : "Off"]."), 1)
	log_admin("[key_name(usr)] toggled respawn to [abandon_allowed ? "On" : "Off"].")
	world.update_status()
	 

/datum/admins/proc/end_round()
	set category = "Server"
	set desc="Immediately ends the round, be very careful"
	set name="End Round"

	if(!check_rights(R_SERVER))	return
	if (ticker)
		var/confirm = input("Are you sure you want to end the round?", "Are you sure:") in list("Yes", "No")
		if(confirm != "Yes") return
		ticker.mode.round_finished = MODE_INFESTATION_DRAW_DEATH
		log_admin("[key_name(usr)] has made the round end early.")
		message_admins(SPAN_NOTICE("[key_name(usr)] has made the round end early."), 1)
		for(var/client/C in admins)
			to_chat(C, {"
			<hr>
			[SPAN_CENTERBOLD("Staff-Only Alert: <EM>[usr.key]</EM> has made the round end early")]
			<hr>
			"})

		return

/datum/admins/proc/delay()
	set category = "Server"
	set desc="Delay the game start/end"
	set name="Delay"

	if(!check_rights(R_SERVER))	return
	if (!ticker || ticker.current_state != GAME_STATE_PREGAME)
		ticker.delay_end = !ticker.delay_end
		log_admin("[key_name(usr)] [ticker.delay_end ? "delayed the round end" : "has made the round end normally"].")
		message_admins("[SPAN_NOTICE("[key_name(usr)] [ticker.delay_end ? "delayed the round end" : "has made the round end normally"].")]", 1)
		for(var/client/C in admins)
			to_chat(C, {"<hr>
			[SPAN_CENTERBOLD("Staff-Only Alert: <EM>[usr.key]</EM> [ticker.delay_end ? "delayed the round end" : "has made the round end normally"]")]
			<hr>"})

		return //alert("Round end delayed", null, null, null, null, null)
	going = !( going )
	if (!( going ))
		to_world("<hr>")
		to_world("<span class='centerbold'>The game start has been delayed.</span>")
		to_world("<hr>")
		log_admin("[key_name(usr)] delayed the game.")
	else
		to_world("<hr>")
		to_world("<span class='centerbold'>The game will start soon!</span>")
		to_world("<hr>")
		log_admin("[key_name(usr)] removed the delay.")
	 

/datum/admins/proc/adjump()
	set category = "Server"
	set desc="Toggle admin jumping"
	set name="Toggle Jump"
	config.allow_admin_jump = !(config.allow_admin_jump)
	message_admins(SPAN_NOTICE("Toggled admin jumping to [config.allow_admin_jump]."))
	 

/datum/admins/proc/adspawn()
	set category = "Server"
	set desc="Toggle admin spawning"
	set name="Toggle Spawn"
	config.allow_admin_spawning = !(config.allow_admin_spawning)
	message_admins(SPAN_NOTICE("Toggled admin item spawning to [config.allow_admin_spawning]."))
	 

/datum/admins/proc/adrev()
	set category = "Server"
	set desc="Toggle admin revives"
	set name="Toggle Revive"
	config.allow_admin_rev = !(config.allow_admin_rev)
	message_admins(SPAN_NOTICE("Toggled reviving to [config.allow_admin_rev]."))
	 

/datum/admins/proc/immreboot()
	set category = "Server"
	set desc="Reboots the server post haste"
	set name="Immediate Reboot"
	if(!usr.client.admin_holder || !(usr.client.admin_holder.rights & R_MOD))	return
	if( alert("Reboot server?",,"Yes","No") == "No")
		return
	to_world(SPAN_DANGER("<b>Rebooting world!</b> \blue Initiated by [usr.client.admin_holder.fakekey ? "Admin" : usr.key]!"))
	log_admin("[key_name(usr)] initiated an immediate reboot.")

	world.Reboot()

/datum/admins/proc/unprison(var/mob/M in mob_list)
	set category = "Admin"
	set name = "Unprison"
	if (M.z == 2)
		if (config.allow_admin_jump)
			M.loc = pick(latejoin)
			message_admins("[key_name_admin(usr)] has unprisoned [key_name_admin(M)]", 1)
			log_admin("[key_name(usr)] has unprisoned [key_name(M)]")
		else
			alert("Admin jumping disabled")
	else
		alert("[M.name] is not prisoned.")
	 

////////////////////////////////////////////////////////////////////////////////////////////////ADMIN HELPER PROCS

/proc/is_special_character(mob/M as mob) // returns 1 for specail characters and 2 for heroes of gamemode
	if(!ticker || !ticker.mode)
		return 0
	if(!istype(M))
		return 0
	if(M.mind && M.mind.special_role)//If they have a mind and special role, they are some type of traitor or antagonist.
		return 1

	return 0

/datum/admins/proc/spawn_atom(var/object as text)
	set category = "Debug"
	set desc = "(atom path) Spawn an atom"
	set name = "Spawn"

	if(!check_rights(R_SPAWN))	return

	var/list/types = typesof(/atom)
	var/list/matches = new()

	for(var/path in types)
		if(findtext("[path]", object))
			matches += path

	if(matches.len==0)
		return

	var/chosen
	if(matches.len==1)
		chosen = matches[1]
	else
		chosen = input("Select an atom type", "Spawn Atom", matches[1]) as null|anything in matches
		if(!chosen)
			return

	if(ispath(chosen,/turf))
		var/turf/T = get_turf(usr.loc)
		T.ChangeTurf(chosen)
	else
		new chosen(usr.loc)

	log_admin("[key_name(usr)] spawned [chosen] at ([usr.x],[usr.y],[usr.z])")
	 


/datum/admins/proc/show_traitor_panel(var/mob/M in mob_list)
	set category = "Admin"
	set desc = "Edit mobs's memory and role"
	set name = "Show Traitor Panel"

	if(!istype(M))
		to_chat(usr, "This can only be used on instances of type /mob")
		return
	if(!M.mind)
		to_chat(usr, "This mob has no mind!")
		return

	M.mind.edit_memory()
	 


/datum/admins/proc/toggletintedweldhelmets()
	set category = "Debug"
	set desc="Reduces view range when wearing welding helmets"
	set name="Toggle tinted welding helmes"
	tinted_weldhelh = !( tinted_weldhelh )
	if (tinted_weldhelh)
		to_world("<B>The tinted_weldhelh has been enabled!</B>")
	else
		to_world("<B>The tinted_weldhelh has been disabled!</B>")
	log_admin("[key_name(usr)] toggled tinted_weldhelh.")
	message_admins("[key_name_admin(usr)] toggled tinted_weldhelh.", 1)
	 

/datum/admins/proc/toggleguests()
	set category = "Server"
	set desc="Guests can't enter"
	set name="Toggle Guest Joining"
	guests_allowed = !( guests_allowed )
	if (!( guests_allowed ))
		to_world("<B>Guests may no longer enter the game.</B>")
	else
		to_world("<B>Guests may now enter the game.</B>")
	log_admin("[key_name(usr)] toggled guests game entering [guests_allowed?"":"dis"]allowed.")
	message_admins(SPAN_NOTICE("[key_name_admin(usr)] toggled guests game entering [guests_allowed ? "":"dis"]allowed."), 1)
	 

/client/proc/update_mob_sprite(mob/living/carbon/human/H as mob)
	set category = "Admin"
	set name = "Update Mob Sprite"
	set desc = "Should fix any mob sprite update errors."

	if (!admin_holder || !(admin_holder.rights & R_MOD))
		to_chat(src, "Only administrators may use this command.")
		return

	if(istype(H))
		H.regenerate_icons()


/*
	helper proc to test if someone is a mentor or not.  Got tired of writing this same check all over the place.
*/
/proc/is_mentor(client/C)

	if(!istype(C))
		return 0
	if(!C.admin_holder)
		return 0

	if(AHOLD_IS_ONLY_MENTOR(C.admin_holder))
		return 1
	return 0

/datum/admins/proc/togglesleep(var/mob/living/M as mob in mob_list)
	set category = "Admin"
	set name = "Toggle Sleeping"

	if(!check_rights(0))	return

	if (M.sleeping > 0)
		M.sleeping = 0
	else
		M.sleeping = 9999999

	log_admin("[key_name(usr)] used Toggle Sleeping on [key_name(M)].")
	message_staff("[key_name(usr)] used Toggle Sleeping on [key_name(M)].")

	return

/datum/admins/proc/sleepall()
	set category = "Admin"
	set name = "Toggle Sleep All in View"

	if(!check_rights(0))	return

	if(alert("This will toggle a sleep/awake status on ALL mobs within your view range (for Administration purposes). Are you sure?",,"Yes","Cancel") == "Yes")
		for(var/mob/living/M in view())
			if (M.sleeping > 0)
				M.sleeping = 0
			else
				M.sleeping = 9999999
	else
		return

	log_admin("[key_name(usr)] used Toggle Sleep All in View.")
	message_admins("[key_name(usr)] used Toggle Sleep All in View.")

	return

/proc/ishost(whom)
	if(!whom)
		return 0
	var/client/C
	var/mob/M
	if(istype(whom, /client))
		C = whom
	else if(istype(whom, /mob))
		M = whom
		if(M.client)
			C = M.client
		else
			return 0
	else
		return 0
	if(C.admin_holder && R_HOST & C.admin_holder.rights)
		return 1
	else
		return 0

/datum/admins/proc/admin_force_distress()
	set category = "Admin"
	set name = "Distress Beacon"
	set desc = "Call a distress beacon. This should not be done if the shuttle's already been called."

	if (!ticker  || !ticker.mode)
		return

	if(!check_rights(R_ADMIN))	return

	if(ticker.mode.picked_call)
		var/confirm = alert(src, "There's already been a distress call sent. Are you sure you want to send another one? This will probably break things.", "Send a distress call?", "Yes", "No")
		if(confirm != "Yes") return

		//Reset the distress call
		ticker.mode.picked_call.members = list()
		ticker.mode.picked_call.candidates = list()
		ticker.mode.waiting_for_candidates = 0
		ticker.mode.has_called_emergency = 0
		ticker.mode.picked_call = null

	var/list/list_of_calls = list()
	for(var/datum/emergency_call/L in ticker.mode.all_calls)
		if(L && L.name != "name")
			list_of_calls += L.name
	list_of_calls = sortList(list_of_calls)

	list_of_calls += "Randomize"

	var/choice = input("Which distress call?") as null|anything in list_of_calls
	if(!choice)
		return

	if(choice == "Randomize")
		ticker.mode.picked_call	= ticker.mode.get_random_call()
	else
		for(var/datum/emergency_call/C in ticker.mode.all_calls)
			if(C && C.name == choice)
				ticker.mode.picked_call = C
				break

	if(!istype(ticker.mode.picked_call))
		return


	var/is_announcing = TRUE
	var/announce = alert(src, "Would you like to announce the distress beacon to the server population? This will reveal the distress beacon to all players.", "Announce distress beacon?", "Yes", "No")
	if(announce == "No")
		is_announcing = FALSE

	ticker.mode.picked_call.activate(is_announcing)

	 
	log_admin("[key_name(usr)] admin-called a [choice == "Randomize" ? "randomized ":""]distress beacon: [ticker.mode.picked_call.name]")
	message_admins(SPAN_NOTICE("[key_name_admin(usr)] admin-called a [choice == "Randomize" ? "randomized ":""]distress beacon: [ticker.mode.picked_call.name]"), 1)

/datum/admins/proc/admin_force_ERT_shuttle()
	set category = "Admin"
	set name = "Force ERT Shuttle"
	set desc = "Force Launch the ERT Shuttle."

	if (!ticker  || !ticker.mode) return
	if(!check_rights(R_ADMIN))	return

	var/tag = input("Which ERT shuttle should be force launched?", "Select an ERT Shuttle:") as null|anything in list("Distress", "Distress_PMC", "Distress_UPP", "Distress_Big")
	if(!tag) return

	var/datum/shuttle/ferry/ert/shuttle = shuttle_controller.shuttles[tag]
	if(!shuttle || !istype(shuttle))
		message_admins("Warning: Distress shuttle not found. Aborting.")
		return

	if(shuttle.location) //in start zone in admin z level
		var/dock_id
		var/dock_list = list("Port", "Starboard", "Aft")
		if(shuttle.use_umbilical)
			dock_list = list("Port Hangar", "Starboard Hangar")
		var/dock_name = input("Where on the [MAIN_SHIP_NAME] should the shuttle dock?", "Select a docking zone:") as null|anything in dock_list
		switch(dock_name)
			if("Port") dock_id = /area/shuttle/distress/arrive_2
			if("Starboard") dock_id = /area/shuttle/distress/arrive_1
			if("Aft") dock_id = /area/shuttle/distress/arrive_3
			if("Port Hangar") dock_id = /area/shuttle/distress/arrive_s_hangar
			if("Starboard Hangar") dock_id = /area/shuttle/distress/arrive_n_hangar
			else return
		for(var/datum/shuttle/ferry/ert/F in shuttle_controller.process_shuttles)
			if(F != shuttle)
				//other ERT shuttles already docked on almayer or about to be
				if(!F.location || F.moving_status != SHUTTLE_IDLE)
					if(F.area_station.type == dock_id)
						message_admins("Warning: That docking zone is already taken by another shuttle. Aborting.")
						return

		for(var/area/A in all_areas)
			if(A.type == dock_id)
				shuttle.area_station = A
				break


	if(!shuttle.can_launch())
		message_admins("Warning: Unable to launch this Distress shuttle at this moment. Aborting.")
		return

	shuttle.launch()

	 
	log_admin("[key_name(usr)] force launched a distress shuttle ([tag])")
	message_admins(SPAN_NOTICE("[key_name_admin(usr)] force launched a distress shuttle ([tag])"), 1)

/datum/admins/proc/admin_force_selfdestruct()
	set category = "Admin"
	set name = "Self Destruct"
	set desc = "Trigger self destruct countdown. This should not be done if the self destruct has already been called."

	if (!ticker  || !ticker.mode)
		return

	if(!check_rights(R_ADMIN))	return

	if(get_security_level() == "delta")
		return

	set_security_level(SEC_LEVEL_DELTA)

	 
	log_admin("[key_name(usr)] admin-started self destruct stystem.")
	message_admins(SPAN_NOTICE("[key_name_admin(usr)] admin-started self destruct stystem."), 1)
