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


/datum/browser/New(nuser, nwindow_id, ntitle = 0, nstylesheet = "common.css", nwidth = 0, nheight = 0, var/atom/nref = null)
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
	head_content += "<link rel='stylesheet' type='text/css' href='[other_asset.get_url_mappings()["search.js"]]'>"
	head_content += "<link rel='stylesheet' type='text/css' href='[other_asset.get_url_mappings()["loading.gif"]]'>"

	for (var/file in stylesheets)
		head_content += "<link rel='stylesheet' type='text/css' href='[SSassets.transport.get_asset_url(file)]'>"


	for (var/file in scripts)
		head_content += "<script type='text/javascript' src='[SSassets.transport.get_asset_url(file)]'></script>"

	var/title_attributes = "class='uiTitle'"
	if (title_image)
		title_attributes = "class='uiTitle icon' style='background-image: url([title_image]);'"

	return {"<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
	<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
	<head>
		[head_content]
	</head>
	<body scroll=auto>
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

/datum/browser/proc/open(var/use_onclose = TRUE)
	if(isnull(window_id))	//null check because this can potentially nuke goonchat
		to_chat(user, "<span class='userdanger'>The [title] browser you tried to open failed a sanity check! Please report this on github!</span>")
		return
	var/window_size = ""
	if (width && height)
		window_size = "size=[width]x[height];"
	common_asset.send(user)
	other_asset.send(user)
	if (stylesheets.len)
		SSassets.transport.send_assets(user, stylesheets)
	if (scripts.len)
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
// e.g. code is	: user << browse(text, "window=fred")
// then use 	: onclose(user, "fred")
//
// Optionally, specify the "ref" parameter as the controlled atom (usually src)
// to pass a "close=1" parameter or a custom list of parameters to the atom's
// Topic() proc for special handling.
// Otherwise, the user mob's machine var will be reset directly.
//
/proc/onclose(user, windowid, var/atom/ref, var/list/params)
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
/client/verb/windowclose(var/atomref as text|null, var/params as text|null)
	set hidden = 1						// hide this verb from the user's panel
	set name = ".windowclose"			// no autocomplete on cmd line

	if(atomref && atomref != "null")				// if passed a real atomref
		var/hsrc = locate(atomref)	// find the reffed atom
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

/proc/show_browser(var/target, var/browser_content, var/browser_name, var/id = null, var/window_options = null, closeref)
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
