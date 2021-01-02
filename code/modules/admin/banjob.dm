/*
Rank is stripped down with ckey() in order to remove any capitals or spaces, so those do not matter.
If the system encounters a rank that it doesn't recognize, it will automatically add it to the list.
As such, ranks shouldn't really change to maintain consistency. You can see some older bans list
stuff like sulacochiefmedicalofficer, to where now they list it as chiefmedicalofficer. The system
won't recognize the older one, as an example.

*/

var/jobban_runonce			// Updates legacy bans with new info
var/jobban_keylist[0]		//to store the keys & ranks

/proc/check_jobban_path(X)
	. = ckey(X)
	if(!islist(jobban_keylist[.])) //If it's not a list, we're in trouble.
		jobban_keylist[.] = list()

/proc/jobban_fullban(mob/M, rank, reason)
	if (!M || !M.ckey) return
	rank = check_jobban_path(rank)
	jobban_keylist[rank][M.ckey] = reason

/proc/jobban_client_fullban(ckey, rank)
	if (!ckey || !rank) return
	rank = check_jobban_path(rank)
	jobban_keylist[rank][ckey] = "Reason Unspecified"

//returns a reason if M is banned from rank, returns 0 otherwise
/proc/jobban_isbanned(mob/M, rank, var/datum/entity/player/P = null)
	if(!rank)
		return "Non-existant job"
	rank = ckey(rank)
	if(P)
		// asking for a friend
		if(!P.jobbans_loaded)
			return "Not yet loaded"
		var/datum/entity/player_job_ban/PJB = P.job_bans[rank]
		return PJB ? PJB.text : null
	if(M)
		if(!M.client || !M.client.player_data || !M.client.player_data.jobbans_loaded)
			return "Not yet loaded"
		if(guest_jobbans(rank))
			if(CONFIG_GET(flag/guest_jobban) && IsGuestKey(M.key))
				return "Guest Job-ban"
			if(CONFIG_GET(flag/usewhitelist) && !check_whitelist(M))
				return "Whitelisted Job"
		var/datum/entity/player_job_ban/PJB = M.client.player_data.job_bans[rank]
		return PJB ? PJB.text : null

/proc/jobban_loadbanfile()
	var/savefile/S=new("data/job_new.ban")
	S["new_bans"] >> jobban_keylist
	log_admin("Loading jobban_rank")
	S["runonce"] >> jobban_runonce

	if (!length(jobban_keylist))
		jobban_keylist=list()
		log_admin("jobban_keylist was empty")

/proc/jobban_savebanfile()
	var/savefile/S=new("data/job_new.ban")
	S["new_bans"] << jobban_keylist

/proc/jobban_unban(mob/M, rank)
	jobban_remove("[M.ckey] - [ckey(rank)]")

/proc/ban_unban_log_save(var/formatted_log)
	text2file(formatted_log,"data/ban_unban_log.txt")

/proc/jobban_remove(X)
	var/regex/r1 = new("(.*) - (.*)")
	if(r1.Find(X))
		var/L[] = jobban_keylist[r1.group[2]]
		L.Remove(r1.group[1])
		return 1

/client/proc/cmd_admin_job_ban(var/mob/M)
	if(!check_rights(R_BAN|R_MOD))
		return

	if(admin_holder)
		admin_holder.job_ban(M)

/datum/admins/proc/job_ban(var/mob/M)
	if(!ismob(M))
		to_chat(usr, "This can only be used on instances of type /mob")
		return

	if(!M.ckey)	//sanity
		to_chat(usr, "This mob has no ckey")
		return
	if(!RoleAuthority)
		to_chat(usr, "The Role Authority is not set up!")
		return

	var/datum/entity/player/P = M.client?.player_data

	if(!P)
		P = get_player_from_key(M.ckey)

	var/dat = ""
	var/body
	var/jobs = ""

/***********************************WARNING!************************************
					The jobban stuff looks mangled and disgusting
							But it looks beautiful in-game
									-Nodrak
************************************WARNING!***********************************/
//Regular jobs
//Command (Blue)
	jobs += generate_job_ban_list(M, P, ROLES_CIC, "CIC", "ddddff")
	jobs += "<br>"
// SUPPORT
	jobs += generate_job_ban_list(M, P, ROLES_AUXIL_SUPPORT, "Support", "ccccff")
	jobs += "<br>"
// MPs
	jobs += generate_job_ban_list(M, P, ROLES_POLICE, "Police", "ffdddd")
	jobs += "<br>"
//Engineering (Yellow)
	jobs += generate_job_ban_list(M, P, ROLES_ENGINEERING, "Engineering", "fff5cc")
	jobs += "<br>"
//Cargo (Yellow) //Copy paste, yada, yada. Hopefully Snail can rework this in the future.
	jobs += generate_job_ban_list(M, P, ROLES_REQUISITION, "Requisition", "fff5cc")
	jobs += "<br>"
//Medical (White)
	jobs += generate_job_ban_list(M, P, ROLES_MEDICAL, "Medical", "ffeef0")
	jobs += "<br>"
//Marines
	jobs += generate_job_ban_list(M, P, ROLES_MARINES, "Marines", "ffeeee")
	jobs += "<br>"
// MISC
	jobs += generate_job_ban_list(M, P, ROLES_MISC, "Misc", "aaee55")
	jobs += "<br>"
// Xenos (Orange)
	jobs += generate_job_ban_list(M, P, ROLES_XENO, "Xenos", "a268b1")
	jobs += "<br>"
//Extra (Orange)
	var/isbanned_dept = jobban_isbanned(M, "Syndicate", P)
	jobs += "<table cellpadding='1' cellspacing='0' width='100%'>"
	jobs += "<tr bgcolor='ffeeaa'><th colspan='10'><a href='?src=\ref[src];jobban3=Syndicate;jobban4=\ref[M]'>Extras</a></th></tr><tr align='center'>"

	//ERT
	if(jobban_isbanned(M, "Emergency Response Team", P) || isbanned_dept)
		jobs += "<td width='20%'><a href='?src=\ref[src];jobban3=Emergency Response Team;jobban4=\ref[M]'><font color=red>Emergency Response Team</font></a></td>"
	else
		jobs += "<td width='20%'><a href='?src=\ref[src];jobban3=Emergency Response Team;jobban4=\ref[M]'>Emergency Response Team</a></td>"

	//Survivor
	if(jobban_isbanned(M, "Survivor", P) || isbanned_dept)
		jobs += "<td width='20%'><a href='?src=\ref[src];jobban3=Survivor;jobban4=\ref[M]'><font color=red>Survivor</font></a></td>"
	else
		jobs += "<td width='20%'><a href='?src=\ref[src];jobban3=Survivor;jobban4=\ref[M]'>Survivor</a></td>"

	if(jobban_isbanned(M, "Agent", P) || isbanned_dept)
		jobs += "<td width='20%'><a href='?src=\ref[src];jobban3=Agent;jobban4=\ref[M]'><font color=red>Agent</font></a></td>"
	else
		jobs += "<td width='20%'><a href='?src=\ref[src];jobban3=Agent;jobban4=\ref[M]'>Agent</a></td>"

	body = "<body>[jobs]</body>"
	dat = "<tt>[body]</tt>"
	show_browser(usr, dat, "Job-Ban Panel: [M.name]", "jobban2", "size=800x490")
	return
