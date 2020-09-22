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
	var/noWindow = FALSE				//If the user has the new skin.dm
	var/list/connectionHistory = list() //Contains the connection history passed from chat cookie
	var/oldChat = TRUE					//If they are using the old chat

/datum/chatOutput/New(client/C)
	. = ..()

	if(C)
		owner = C

/datum/chatOutput/proc/start()
	//Check for existing chat
	if (!owner || !istype(owner) || owner.disposed)
		return FALSE

	if(!winexists(owner, "browseroutput"))
		set waitfor = FALSE
		noWindow = TRUE
		. = FALSE
		alert(owner.mob, "Goonchat hasn't loaded for you. Please wait a minute or try reconnecting.")
		return

	if(owner && winget(owner, "browseroutput", "is-disabled") == "false") //Already setup
		doneLoading()
	else //Not setup
		load()

	return TRUE

/datum/chatOutput/proc/load()
	if(!owner) // Client logged off or something else
		return

	var/datum/asset/stuff = get_asset_datum(/datum/asset/group/goonchat)
	stuff.send(owner)

	owner << browse(file("browserassets/html/browserOutput.html"), "window=browseroutput")

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
	oldChat = FALSE
	enableChat()

	for (var/msg in messageQueue)
		to_chat_forced(owner, msg)

	messageQueue = null
	sendClientData()
	check_window_skin()

/datum/chatOutput/proc/enableChat()
	if (!owner || !istype(owner))
		return FALSE
	winset(owner, "output", "is-visible=false")
	winset(owner, "browseroutput", "is-disabled=false;is-visible=true")

//Sends client connection details to the chat to handle and save
/datum/chatOutput/proc/sendClientData()
	if (!owner || !istype(owner))
		return FALSE
	//Get dem deets
	var/list/deets = list("clientData" = list())
	deets["clientData"]["ckey"] = src.owner.ckey
	deets["clientData"]["ip"] = src.owner.address
	deets["clientData"]["compid"] = src.owner.computer_id
	var/data = json_encode(deets)
	browser_send(data = data)

/datum/chatOutput/proc/check_window_skin()
	if(!owner || !istype(owner))
		return FALSE

	if(owner.prefs.window_skin & TOGGLE_WINDOW_SKIN)
		browser_send(owner, "night_skin")
	else
		browser_send(owner, "white_skin")

/datum/chatOutput/proc/toggle_window_skin()
	owner.toggle_window_skin()

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
				message_staff("[key_name(owner)] has a cookie from a banned account! (Matched: [found["ckey"]], [found["ip"]], [found["compid"]])")
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

/// Generate a filename for this asset
/// The same asset will always lead to the same asset name
/// (Generated names do not include file extention.)
/proc/generate_asset_name(file)
	return "asset.[md5(fcopy_rsc(file))]"

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
			if(!SSassets.cache[name])
				SSassets.transport.register_asset(name, object)
			for(var/object2 in targets)
				SSassets.transport.send_assets(object2, name)
			return "<img class='icon icon-misc' src='[SSassets.transport.get_asset_url(name)]'>"

	var/atom/A = object
	if(!istype(A))
		return ""
	I = A.icon

	I = icon(I, A.icon_state, A.dir, 1, FALSE)

	key = "[generate_asset_name(I)].png"
	if(!SSassets.cache[key])
		SSassets.transport.register_asset(key, I)
	for(var/object2 in targets)
		SSassets.transport.send_assets(object2, key)
	return "<img class='icon icon-[A.icon_state]' src='[SSassets.transport.get_asset_url(key)]'>"

/proc/to_chat_forced(var/target, var/message)
	if (istype(message, /image) || istype(message, /sound) || istype(target, /savefile))
		target << message
		CRASH("DEBUG: to_chat called with invalid message")

	//Otherwise, we're good to throw it at the user
	if(!istext(message))
		return

	if(target == world)
		target = clients

	var/clean_message = message

	//Some macros remain in the string even after parsing and fuck up the eventual output
	message = replacetextEx(message, "\n", "<br>")
	message += "<br>"

	var/encoded_message = message
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

			// If they are using the old chat, send it the old way
			if(C.chatOutput && C.chatOutput.oldChat || !C.chatOutput)
				C << clean_message

			if (C.chatOutput && !C.chatOutput.noWindow && !C.chatOutput.loaded && C.chatOutput.messageQueue && islist(C.chatOutput.messageQueue))
				//Client sucks at loading things, put their messages in a queue
				C.chatOutput.messageQueue += message
				continue

			C << output(url_encode(json_encode(list("message"=encoded_message))), "browseroutput:output")
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

		if(C.chatOutput && C.chatOutput.oldChat || !C.chatOutput)
			C << clean_message

		if (C.chatOutput && !C.chatOutput.noWindow && !C.chatOutput.loaded && C.chatOutput.messageQueue && islist(C.chatOutput.messageQueue))
			C.chatOutput.messageQueue += message
			return

		C << output(json_encode(list("message"=encoded_message)), "browseroutput:output")

/proc/to_world(var/message)
	to_chat(world, message)

/proc/to_chat(var/target, var/message)
	if (!target || !message)
		return

	if(!SSchat?.initialized)
		to_chat_forced(target, message)
		return
	SSchat.queue(target, message)