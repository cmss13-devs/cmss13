/datum/browser
	var/mob/user
	var/title
	var/window_id // window_id is used as the window name for browse and onclose
	var/width = 0
	var/height = 0
	var/atom/ref = null
	var/window_options = "focus=0;can_close=1;can_minimize=1;can_maximize=0;can_resize=1;titlebar=1;" // window option is set using window_id
	var/stylesheets[0]
	var/stylesheet
	var/scripts[0]
	var/title_image
	var/head_elements
	var/body_elements
	var/head_content = ""
	var/content = ""
	var/title_buttons = ""
	var/static/datum/asset/simple/common/common_asset = get_asset_datum(/datum/asset/simple/common)
	var/static/datum/asset/simple/other/other_asset = get_asset_datum(/datum/asset/simple/other)


/datum/browser/New(nuser, nwindow_id, ntitle = 0, nstylesheet = "common.css", nwidth = 0, nheight = 0, atom/nref = null)
	user = nuser
	window_id = nwindow_id
	if (ntitle)
		title = format_text(ntitle)
	if (nwidth)
		width = nwidth
	if (nheight)
		height = nheight
	if (nref)
		ref = nref
	stylesheet = nstylesheet

/datum/browser/proc/set_title(ntitle)
	title = format_text(ntitle)

/datum/browser/proc/add_head_content(nhead_content)
	head_content = nhead_content

/datum/browser/proc/set_title_buttons(ntitle_buttons)
	title_buttons = ntitle_buttons

/datum/browser/proc/set_window_options(nwindow_options)
	window_options = nwindow_options

/datum/browser/proc/add_stylesheet(name, file)
	if (istype(name, /datum/asset/spritesheet))
		var/datum/asset/spritesheet/sheet = name
		stylesheets["spritesheet_[sheet.name].css"] = "data/spritesheets/[sheet.name]"
	else
		var/asset_name = "[name].css"

		stylesheets[asset_name] = file

		if (!SSassets.cache[asset_name])
			SSassets.transport.register_asset(asset_name, file)

/datum/browser/proc/add_script(name, file)
	scripts["[ckey(name)].js"] = file
	SSassets.transport.register_asset("[ckey(name)].js", file)

/datum/browser/proc/set_content(ncontent)
	content = ncontent

/datum/browser/proc/add_content(ncontent)
	content += ncontent

/datum/browser/proc/get_header()
	head_content += "<link rel='stylesheet' type='text/css' href='[common_asset.get_url_mappings()[stylesheet]]'>"
	head_content += "<link rel='stylesheet' type='text/css' href='[other_asset.get_url_mappings()["loading.gif"]]'>"

	for (var/file in stylesheets)
		head_content += "<link rel='stylesheet' type='text/css' href='[SSassets.transport.get_asset_url(file)]'>"


	for (var/file in scripts)
		head_content += "<script type='text/javascript' src='[SSassets.transport.get_asset_url(file)]'></script>"
	head_content += "<script type='text/javascript' src='[other_asset.get_url_mappings()["search.js"]]'></script>"

	var/title_attributes = "class='uiTitle'"
	if (title_image)
		title_attributes = "class='uiTitle icon' style='background-image: url([title_image]);'"

	return {"<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
	<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
	<head>
		[head_content]
	</head>
	<body scroll=auto onload='selectFilterField()'>
		<div class='uiWrapper'>
			[title ? "<div class='uiTitleWrapper'><div [title_attributes]><tt>[title]</tt></div><div class='uiTitleButtons'>[title_buttons]</div></div>" : ""]
			<div class='uiContent'>
	"}

/datum/browser/proc/get_footer()
	return {"
			</div>
		</div>
	</body>
</html>"}

/datum/browser/proc/get_content()
	return {"
	[get_header()]
	[content]
	[get_footer()]
	"}

/datum/browser/proc/open(use_onclose = TRUE)
	if(isnull(window_id)) //null check because this can potentially nuke goonchat
		to_chat(user, SPAN_USERDANGER("The [title] browser you tried to open failed a sanity check! Please report this on github!"))
		return
	var/window_size = ""
	if (width && height)
		window_size = "size=[width]x[height];"
	common_asset.send(user)
	other_asset.send(user)
	if (length(stylesheets))
		SSassets.transport.send_assets(user, stylesheets)
	if (length(scripts))
		SSassets.transport.send_assets(user, scripts)

	user << browse(get_content(), "window=[window_id];[window_size][window_options]")

	if (use_onclose)
		setup_onclose()

/datum/browser/proc/setup_onclose()
	set waitfor = 0 //winexists sleeps, so we don't need to.
	for (var/i in 1 to 10)
		if (user && winexists(user, window_id))
			onclose(user, window_id, ref)
			break

/datum/browser/proc/close()
	if(!isnull(window_id))//null check because this can potentially nuke goonchat
		close_browser(user, "[window_id]")

// This will allow you to show an icon in the browse window
// This is added to mob so that it can be used without a reference to the browser object
// There is probably a better place for this...
/mob/proc/browse_rsc_icon(icon, icon_state, dir = -1)
	/*
	var/icon/I
	if (dir >= 0)
		I = new /icon(icon, icon_state, dir)
	else
		I = new /icon(icon, icon_state)
		dir = "default"

	var/filename = "[ckey("[icon]_[icon_state]_[dir]")].png"
	src << browse_rsc(I, filename)
	return filename
	*/


// Registers the on-close verb for a browse window (client/verb/.windowclose)
// this will be called when the close-button of a window is pressed.
//
// This is usually only needed for devices that regularly update the browse window,
// e.g. canisters, timers, etc.
//
// windowid should be the specified window name
// e.g. code is : user << browse(text, "window=fred")
// then use : onclose(user, "fred")
//
// Optionally, specify the "ref" parameter as the controlled atom (usually src)
// to pass a "close=1" parameter or a custom list of parameters to the atom's
// Topic() proc for special handling.
// Otherwise, the user mob's machine var will be reset directly.
//
/proc/onclose(user, windowid, atom/ref, list/params)
	var/client/C = user

	if (ismob(user))
		var/mob/M = user
		C = M.client

	if (!istype(C))
		return

	var/ref_string = "null"
	if (ref)
		ref_string = "\ref[ref]"

	var/params_string = "null"
	if (params)
		params_string = ""
		for (var/param in params)
			params_string += "[param]=[params[param]];"
		params_string = copytext(params_string, 1, -1)

	winset(C, windowid, "on-close=\".windowclose \\\"[ref_string]\\\" \\\"[params_string]\\\"\"")


// the on-close client verb
// called when a browser popup window is closed after registering with proc/onclose()
// if a valid atom reference is supplied, call the atom's Topic() with "close=1" or
// a custom list of parameters
// otherwise, just reset the client mob's machine var.
//
/client/verb/windowclose(atomref as text|null, params as text|null)
	set hidden = TRUE // hide this verb from the user's panel
	set name = ".windowclose" // no autocomplete on cmd line

	if(atomref && atomref != "null") // if passed a real atomref
		var/hsrc = locate(atomref) // find the reffed atom
		if(hsrc)
			usr = src.mob
			var/param_string = "close=1"
			var/list/param_list = list("close"="1")

			if (params && params != "null")
				param_string = params
				param_list = params2list(params)

			// this will direct to the atom's Topic() proc via client.Topic()
			Topic(param_string, param_list, hsrc)
			return

	// no atomref specified (or not found)
	// so just reset the user mob's machine var
	if(mob && !isVehicle(mob.interactee))
		mob.unset_interaction()
	return

/proc/show_browser(target, browser_content, browser_name, id = null, window_options = null, closeref)
	var/client/C = target

	if (ismob(target))
		var/mob/M = target
		C = M.client

	if (!istype(C))
		return

	var/stylesheet = C.prefs.stylesheet
	if (!(stylesheet in GLOB.stylesheets))
		C.prefs.stylesheet = "Modern"
		stylesheet = "Modern"

	var/datum/browser/popup = new(C, id ? id : browser_name, browser_name, GLOB.stylesheets[stylesheet], nref = closeref)
	popup.set_content(browser_content)
	if (window_options)
		popup.set_window_options(window_options)
	popup.open()

/datum/browser/modal
	var/opentime = 0
	var/timeout
	var/selectedbutton = 0
	var/stealfocus

/datum/browser/modal/New(nuser, nwindow_id, ntitle = 0, nstylesheet = "common.css", nwidth = 0, nheight = 0, atom/nref = null, StealFocus = 1, Timeout = 6000)
	..()
	stealfocus = StealFocus
	if (!StealFocus)
		window_options += "focus=false;"
	timeout = Timeout


/datum/browser/modal/close()
	.=..()
	opentime = 0

/datum/browser/modal/open(use_onclose)
	set waitfor = FALSE
	opentime = world.time

	if (stealfocus)
		. = ..(use_onclose = 1)
	else
		var/focusedwindow = winget(user, null, "focus")
		. = ..(use_onclose = 1)

		//waits for the window to show up client side before attempting to un-focus it
		//winexists sleeps until it gets a reply from the client, so we don't need to bother sleeping
		for (var/i in 1 to 10)
			if (user && winexists(user, window_id))
				if (focusedwindow)
					winset(user, focusedwindow, "focus=true")
				else
					winset(user, "mapwindow", "focus=true")
				break
	if (timeout)
		addtimer(CALLBACK(src, PROC_REF(close)), timeout)

/datum/browser/modal/proc/wait()
	while (opentime && selectedbutton <= 0 && (!timeout || opentime+timeout > world.time))
		stoplag(1)
/datum/browser/modal/listpicker
	var/valueslist = list()

/datum/browser/modal/listpicker/New(User,Message,Title,Button1="Ok",Button2,Button3,StealFocus = 1, Timeout = FALSE,list/values,inputtype="checkbox", width, height)
	if (!User)
		return

	var/output = {"<form><input type="hidden" name="src" value="[REF(src)]"><ul class="sparse">"}
	if (inputtype == "checkbox" || inputtype == "radio")
		output += {"<table border=1 cellspacing=0 cellpadding=3 style='border: 1px solid black;'>"}
		for (var/i in values)
			output += {"<tr>
							<td><input type="[inputtype]" value="1" name="[i["name"]]"[i["checked"] ? " checked" : ""][i["allowed_edit"] ? "" : " onclick='return false' onkeydown='return false'"]></td>
							<td>[i["name"]]</td>
						</tr>"}
		output += {"</table>"}
	else
		for (var/i in values)
			output += {"<li><input id="name="[i["name"]]"" style="width: 50px" type="[type]" name="[i["name"]]" value="[i["value"]]">
			<label for="[i["name"]]">[i["name"]]</label></li>"}
	output += {"</ul><div style="text-align:center">
		<button type="submit" name="button" value="[Button1]" style="font-size:large;float:[( Button2 ? "left" : "right" )]">[Button1]</button>"}

	if (Button2)
		output += {"<button type="submit" name="button" value="[Button2]" style="font-size:large;[( Button3 ? "" : "float:right" )]">[Button2]</button>"}

	if (Button3)
		output += {"<button type="submit" name="button" value="[Button3]" style="font-size:large;float:right">[Button3]</button>"}

	output += {"</form></div>"}
	..(User, ckey("[User]-[Message]-[Title]-[world.time]-[rand(1,10000)]"), Title, "common.css", width, height, src, StealFocus, Timeout)
	set_content(output)

/datum/browser/modal/listpicker/Topic(href,href_list)
	if (href_list["close"] || !user || !user.client)
		opentime = 0
		return
	if (href_list["button"])
		selectedbutton = href_list["button"]
	for (var/item in href_list)
		switch(item)
			if ("close", "button", "src")
				continue
			else
				valueslist[item] = href_list[item]
	opentime = 0
	close()

/proc/presentpicker(mob/User,Message, Title, Button1="Ok", Button2, Button3, StealFocus = 1,Timeout = 6000,list/values, inputtype = "checkbox", width, height)
	if (!istype(User))
		if (istype(User, /client/))
			var/client/C = User
			User = C.mob
		else
			return
	var/datum/browser/modal/listpicker/A = new(User, Message, Title, Button1, Button2, Button3, StealFocus,Timeout, values, inputtype, width, height)
	A.open()
	A.wait()
	if (A.selectedbutton)
		return list("button" = A.selectedbutton, "values" = A.valueslist)

/proc/input_bitfield(mob/User, title, bitfield, current_value, nwidth = 350, nheight = 350, allowed_edit_list = null)
	if (!User || !(bitfield in GLOB.bitfields))
		return
	var/list/pickerlist = list()
	for (var/i in GLOB.bitfields[bitfield])
		var/can_edit = 1
		if(!isnull(allowed_edit_list) && !(allowed_edit_list & GLOB.bitfields[bitfield][i]))
			can_edit = 0
		if (current_value & GLOB.bitfields[bitfield][i])
			pickerlist += list(list("checked" = 1, "value" = GLOB.bitfields[bitfield][i], "name" = i, "allowed_edit" = can_edit))
		else
			pickerlist += list(list("checked" = 0, "value" = GLOB.bitfields[bitfield][i], "name" = i, "allowed_edit" = can_edit))
	var/list/result = presentpicker(User, "", title, Button1="Save", Button2 = "Cancel", Timeout=FALSE, values = pickerlist, width = nwidth, height = nheight)
	if (islist(result))
		if (result["button"] != "Save") // If the user pressed the cancel button
			return
		. = 0
		for (var/flag in result["values"])
			. |= GLOB.bitfields[bitfield][flag]
	else
		return
