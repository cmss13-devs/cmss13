//DEFINITIONS FOR ASSET DATUMS START HERE.
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
		"common.css" = 'html/browser/common.css'
	)


/datum/asset/group/goonchat
	children = list(
		/datum/asset/simple/jquery,
		/datum/asset/simple/goonchat,
		/datum/asset/spritesheet/goonchat
	)

/datum/asset/simple/jquery
	legacy = TRUE
	assets = list(
		"jquery.min.js" = 'browserassets/js/jquery.min.js',
	)

/datum/asset/simple/goonchat
	keep_local_name = TRUE
	assets = list(
		"json2.min.js"             = 'browserassets/js/json2.min.js',
		"browserOutput.js"         = 'browserassets/js/browserOutput.js',
		"fontawesome-webfont.eot"  = 'browserassets/css/fonts/fontawesome-webfont.eot',
		"fontawesome-webfont.svg"  = 'browserassets/css/fonts/fontawesome-webfont.svg',
		"fontawesome-webfont.ttf"  = 'browserassets/css/fonts/fontawesome-webfont.ttf',
		"fontawesome-webfont.woff" = 'browserassets/css/fonts/fontawesome-webfont.woff',
		"font-awesome.css"	       = 'browserassets/css/font-awesome.css',
		"browserOutput.css"	       = 'browserassets/css/browserOutput.css',
		"browserOutput_night.css"  = 'browserassets/css/browserOutput_night.css',
	)

/datum/asset/spritesheet/goonchat
	name = "chat"


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
		"panels.css" = 'html/panels.css',
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