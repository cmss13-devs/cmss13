//DEFINITIONS FOR ASSET DATUMS START HERE.

/datum/asset/simple/tgui_common
	keep_local_name = TRUE
	assets = list(
		"tgui-common.bundle.js" = 'tgui/public/tgui-common.bundle.js',
	)

/datum/asset/simple/tgui
	keep_local_name = TRUE
	assets = list(
		"tgui.bundle.js" = 'tgui/public/tgui.bundle.js',
		"tgui.bundle.css" = 'tgui/public/tgui.bundle.css',
	)

/datum/asset/simple/tgui_panel
	keep_local_name = TRUE
	assets = list(
		"tgui-panel.bundle.js" = 'tgui/public/tgui-panel.bundle.js',
		"tgui-panel.bundle.css" = 'tgui/public/tgui-panel.bundle.css',
	)

/datum/asset/simple/fontawesome
	keep_local_name = TRUE
	assets = list(
		"fa-regular-400.eot"  = 'html/font-awesome/webfonts/fa-regular-400.eot',
		"fa-regular-400.woff" = 'html/font-awesome/webfonts/fa-regular-400.woff',
		"fa-solid-900.eot"    = 'html/font-awesome/webfonts/fa-solid-900.eot',
		"fa-solid-900.woff"   = 'html/font-awesome/webfonts/fa-solid-900.woff',
		"font-awesome.css" = 'html/font-awesome/css/all.min.css'
	)

/datum/asset/simple/changelog
	keep_local_name = TRUE
	assets = list(
		"88x31.png" = 'html/88x31.png',
		"bug-minus.png" = 'html/bug-minus.png',
		"cross-circle.png" = 'html/cross-circle.png',
		"hard-hat-exclamation.png" = 'html/hard-hat-exclamation.png',
		"image-minus.png" = 'html/image-minus.png',
		"image-plus.png" = 'html/image-plus.png',
		"music-minus.png" = 'html/music-minus.png',
		"music-plus.png" = 'html/music-plus.png',
		"tick-circle.png" = 'html/tick-circle.png',
		"wrench-screwdriver.png" = 'html/wrench-screwdriver.png',
		"spell-check.png" = 'html/spell-check.png',
		"burn-exclamation.png" = 'html/burn-exclamation.png',
		"chevron.png" = 'html/chevron.png',
		"chevron-expand.png" = 'html/chevron-expand.png',
		"changelog.css" = 'html/changelog.css'
	)

/datum/asset/simple/common
	assets = list(
		"common.css" = 'html/browser/common.css',
		"legacy.css" = 'html/browser/legacy.css',
	)

/datum/asset/simple/jquery
	legacy = TRUE
	assets = list(
		"jquery.min.js" = 'html/jquery.min.js',
	)

/datum/asset/nanoui
	var/list/common = list()

	var/list/common_dirs = list(
		"nano/css/",
		"nano/images/",
		"nano/js/",
		"nano/js/uiscripts/",
	)
	var/list/uncommon_dirs = list(
		"nano/templates/",
	)

/datum/asset/nanoui/register()
	// Crawl the directories to find files.
	for(var/path in common_dirs)
		var/list/filenames = flist(path)
		for(var/filename in filenames)
			if(copytext(filename, length(filename)) == "/") // Ignore directories.
				continue
			if(!fexists(path + filename))
				continue
			common[filename] = fcopy_rsc(path + filename)
			SSassets.transport.register_asset(filename, common[filename])

	for(var/path in uncommon_dirs)
		var/list/filenames = flist(path)
		for(var/filename in filenames)
			if(copytext(filename, length(filename)) == "/") // Ignore directories.
				continue
			if(!fexists(path + filename))
				continue
			SSassets.transport.register_asset(filename, fcopy_rsc(path + filename))

/datum/asset/nanoui/send(client, uncommon, var/send_only_temp = FALSE)
	if(!islist(uncommon))
		uncommon = list(uncommon)

		SSassets.transport.send_assets(client, uncommon)
	if(!send_only_temp)
		SSassets.transport.send_assets(client, common)

/datum/asset/nanoui/weapons
	common = list()

	common_dirs = list(
		"nano/images/weapons/",
	)

	uncommon_dirs = list()

/datum/asset/nanoui/weapons/send(client)
	SSassets.transport.send_assets(client, common)


/datum/asset/simple/nanoui_images
	keep_local_name = TRUE

	assets = list(
		"auto.png" = 'nano/images/weapons/auto.png',
		"burst.png" = 'nano/images/weapons/burst.png',
		"single.png" = 'nano/images/weapons/single.png',
		"disabled_automatic.png" = 'nano/images/weapons/disabled_automatic.png',
		"disabled_burst.png" = 'nano/images/weapons/disabled_burst.png',
		"disabled_single.png" = 'nano/images/weapons/disabled_single.png',
		"no_name.png" = 'nano/images/weapons/no_name.png',
	)

	var/list/common_dirs = list(
		"nano/images/",
	)

/datum/asset/simple/nanoui_images/register()
	// Crawl the directories to find files.
	for(var/path in common_dirs)
		var/list/filenames = flist(path)
		for(var/filename in filenames)
			if(copytext(filename, length(filename)) == "/") // Ignore directories.
				continue
			if(!fexists(path + filename))
				continue
			assets[filename] = fcopy_rsc(path + filename)
	..()


/datum/asset/simple/other
	keep_local_name = TRUE
	assets = list(
		"search.js" = 'html/search.js',
		"loading.gif" = 'html/loading.gif',
	)

/datum/asset/simple/paper
	keep_local_name = TRUE
	assets = list(
		"wylogo.png" = 'html/images/wylogo.png',
		"uscmlogo.png" = 'html/images/uscmlogo.png',
		"faxwylogo.png" = 'html/images/faxwylogo.png',
		"faxbackground.jpg" = 'html/images/faxbackground.jpg',
	)

/datum/asset/spritesheet/chat
	name = "chat"

/datum/asset/spritesheet/chat/register()
	InsertAll("emoji", 'icons/emoji.dmi')
	// pre-loading all lanugage icons also helps to avoid meta
/*	InsertAll("language", 'icons/misc/language.dmi')
	// catch languages which are pulling icons from another file
	for(var/path in typesof(/datum/language))
		var/datum/language/L = path
		var/icon = initial(L.icon)
		if (icon != 'icons/misc/language.dmi')
			var/icon_state = initial(L.icon_state)
			Insert("language-[icon_state]", icon, icon_state=icon_state)*/
	..()

