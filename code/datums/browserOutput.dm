/*********************************
For the main html chat area
*********************************/

//Precaching a bunch of shit
var/savefile/iconCache = new /savefile("data/iconCache.sav") //Cache of icons for the browser output

//On client, created on login
/datum/chatOutput
	var/client/owner = null 			//client ref
	var/loaded = FALSE 					//Has the client loaded the browser output area?
	var/list/messageQueue = list() 		//If they haven't loaded chat, this is where messages will go until they do
	var/cookieSent = FALSE				//Has the client sent a cookie for analysis
	var/list/connectionHistory = list() //Contains the connection history passed from chat cookie

/datum/chatOutput/New(client/C)
	. = ..()

	if (C)
		owner = C

/datum/chatOutput/proc/start()
	//Check for existing chat
	if (!owner) 
		return 0

	if (winget(owner, "browseroutput", "is-disabled") == "false") //Already setup
		doneLoading()

	else //Not setup
		load()

	return TRUE

/datum/chatOutput/proc/load()
	set waitfor = FALSE
	if (!owner) // Client logged off or something else
		return

	for(var/load_attempts = 1 to 5) //Try to load 5 times, every 20 seconds
		var/datum/asset/stuff = get_asset_datum(/datum/asset/group/goonchat)
		stuff.send(owner)

		owner << browse(file("browserassets/html/browserOutput.html"), "window=browseroutput")

		sleep(20 SECONDS)
		if(!owner || loaded)
			break

/datum/chatOutput/Topic(var/href, var/list/href_list)
	if(usr.client != owner)
		return TRUE
	// Build arguments.
	// Arguments are in the form "param[paramname]=thing"
	var/list/params = list()
	for(var/key in href_list)
		if(length(key) > 7 && findtext(key, "param")) // 7 is the amount of characters in the basic param key template.
			var/param_name = copytext(key, 7, -1)
			var/item       = href_list[key]

			params[param_name] = item

	var/data // Data to be sent back to the chat.
	switch(href_list["proc"])
		if("doneLoading")
			data = doneLoading(arglist(params))

		if("debug")
			data = debug(arglist(params))

		if("ping")
			data = ping(arglist(params))

		if("analyzeClientData")
			data = analyzeClientData(arglist(params))

	if(data)
		browser_send(data = data)

//Called on chat output done-loading by JS.
/datum/chatOutput/proc/doneLoading()
	if (loaded)
		return
	
	loaded = TRUE
	winset(owner, "browseroutput", "is-disabled=false")

	for (var/msg in messageQueue)
		to_chat_forced(owner, msg)
	
	messageQueue = null
	sendClientData()

//Sends client connection details to the chat to handle and save
/datum/chatOutput/proc/sendClientData()
	//Get dem deets
	var/list/deets = list("clientData" = list())
	deets["clientData"]["ckey"] = src.owner.ckey
	deets["clientData"]["ip"] = src.owner.address
	deets["clientData"]["compid"] = src.owner.computer_id
	var/data = json_encode(deets)
	browser_send(data = data)

//Called by client, sent data to investigate (cookie history so far)
/datum/chatOutput/proc/analyzeClientData(cookie = "")
	if (!cookie) 
		return

	if (cookie != "none")
		var/list/connData = json_decode(cookie)
		if (connData && islist(connData) && connData.len > 0 && connData["connData"])
			connectionHistory = connData["connData"] //lol fuck
			var/list/found = list()
			for(var/i = connectionHistory.len; i >= 1; i--)
				var/list/row = connectionHistory[i]
				if (!row || row.len < 3 || (!row["ckey"] && !row["compid"] && !row["ip"])) //Passed malformed history object
					return
				if (world.IsBanned(row["ckey"], row["compid"], row["ip"]))
					found = row
					break

			//Uh oh this fucker has a history of playing on a banned account!!
			if (found.len > 0)
				//TODO: add a new evasion ban for the CURRENT client details, using the matched row details
				message_admins("[key_name(owner)] has a cookie from a banned account! (Matched: [found["ckey"]], [found["ip"]], [found["compid"]])")
				log_admin("[key_name(owner)] has a cookie from a banned account! (Matched: [found["ckey"]], [found["ip"]], [found["compid"]])")
	cookieSent = 1

//Called by js client on a pang
/datum/chatOutput/proc/ping()
	return "pong"

//Called by js client on js error
/datum/chatOutput/proc/debug(error)
	world.log = "\[[time2text(world.realtime, "YYYY-MM-DD hh:mm:ss")]\] Client: [(src.owner.key ? src.owner.key : src.owner)] triggered JS error: [error]"

// Budget version of ehjax
/datum/chatOutput/proc/browser_send(var/C = owner, var/data)
	if(islist(data))
		data = json_encode(data)
	C << output("[data]", "["browseroutput"]:ehjaxCallback")

// Converts the icons to html and stores them for display
/proc/htmlicon(object, target = world)
	if(!object)
		return

	if(target == world)
		target = clients

	var/list/targets
	if(!islist(target))
		targets = list(target)
	else
		targets = target
		if(!targets.len)
			return
	
	var/key
	var/icon/I = object
	if(!isicon(I))
		if(isfile(object)) 
			var/name = sanitize_filename("[generate_asset_name(object)].png")
			register_asset(name, object)
			for(var/mob in targets)
				send_asset(mob, key, FALSE)
			return "<img class='icon icon-misc' src=\"[url_encode(name)]\">"
		
	var/atom/A = object
	I = A.icon

	I = icon(I, A.icon_state, A.dir, 1, FALSE)

	key = "[generate_asset_name(I)].png"
	register_asset(key, I)
	for(var/mob in targets)
		send_asset(mob, key, FALSE)

	return "<img class='icon icon-[A.icon_state]' src=\"[url_encode(key)]\">" 

/proc/to_chat_forced(var/target, var/message)
	if (istype(message, /image) || istype(message, /sound) || istype(target, /savefile))
		target << message
		CRASH("DEBUG: to_chat called with invalid message")
		return

	//Otherwise, we're good to throw it at the user
	if(!istext(message))
		return

	if(target == world)
		target = clients

	//Some macros remain in the string even after parsing and fuck up the eventual output
	message = replacetext(message, "\improper", "")
	message = replacetext(message, "\proper", "")
	message = replacetext(message, "\n", "<br>")
	message = replacetext(message, "\t", "["&nbsp;&nbsp;&nbsp;&nbsp;"]["&nbsp;&nbsp;&nbsp;&nbsp;"]")

	var/encoded_message = url_encode(url_encode(message))
	//Grab us a client if possible
	if(islist(target))
		for(var/T in target)
			var/client/C

			if (istype(target, /client))
				C = target
			else if (istype(target, /mob))
				C = target:client
			else if (istype(target, /datum/mind) && target:current)
				C = target:current:client
			
			if(!C)
				continue

			if (C && C.chatOutput && !C.chatOutput.loaded && C.chatOutput.messageQueue && islist(C.chatOutput.messageQueue))
				//Client sucks at loading things, put their messages in a queue
				C.chatOutput.messageQueue += message
				continue

			C << output(encoded_message, "browseroutput:output")
	else
		var/client/C
		if (istype(target, /client))
			C = target
		else if (istype(target, /mob))
			C = target:client
		else if (istype(target, /datum/mind) && target:current)
			C = target:current:client

		if(!C)
			return

		if (C && C.chatOutput && !C.chatOutput.loaded && C.chatOutput.messageQueue && islist(C.chatOutput.messageQueue))
			C.chatOutput.messageQueue += message
			return

		C << output(encoded_message, "browseroutput:output")

/proc/to_world(var/message)
	to_chat(world, message)

/proc/to_chat(var/target, var/message)
	if(!SSchat?.initialized)
		to_chat_forced(target, message)
		return
	SSchat.queue(target, message)