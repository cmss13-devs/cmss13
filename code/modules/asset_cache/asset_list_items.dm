//DEFINITIONS FOR ASSET DATUMS START HERE.

/datum/asset/simple/tgui
	keep_local_name = TRUE
	assets = list(
		"tgui.bundle.js" = file("tgui/public/tgui.bundle.js"),
		"tgui.bundle.css" = file("tgui/public/tgui.bundle.css"),
	)

/datum/asset/simple/tgui_panel
	keep_local_name = TRUE
	assets = list(
		"tgui-panel.bundle.js" = file("tgui/public/tgui-panel.bundle.js"),
		"tgui-panel.bundle.css" = file("tgui/public/tgui-panel.bundle.css"),
	)

/datum/asset/simple/fontawesome
	keep_local_name = TRUE
	assets = list(
		"fa-regular-400.ttf" = 'html/font-awesome/webfonts/fa-regular-400.ttf',
		"fa-solid-900.ttf" = 'html/font-awesome/webfonts/fa-solid-900.ttf',
		"fa-v4compatibility.ttf" = 'html/font-awesome/webfonts/fa-v4compatibility.ttf',
		"font-awesome.css" = 'html/font-awesome/css/all.min.css',
		"v4shim.css" = 'html/font-awesome/css/v4-shims.min.css',
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
	if(!client)
		log_debug("Warning! Tried to send nanoui data with a null client! (asset_list_items.dm line 76)")
		return

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
	if(!client)
		log_debug("Warning! Tried to send nanoui weapon data with a null client! (asset_list_items.dm line 93)")
		return
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

/datum/asset/simple/dynamic_icons
	keep_local_name = TRUE
	assets = list()

/datum/asset/simple/dynamic_icons/proc/update(var/filename)
	var/list/filenames = list(filename)
	if(islist(filename))
		filenames = filename
	for(var/asset in filenames)
		if(!(asset in assets))
			var/key = copytext(asset, 7)
			assets += list(key)
			var/datum/asset_cache_item/ACI = SSassets.cache[key]
			if(ACI)
				SSassets.transport.preload += list(key=ACI)

/datum/asset/simple/dynamic_icons/proc/register_single(var/asset_name)
	var/datum/asset_cache_item/ACI = SSassets.transport.register_asset(asset_name, assets[asset_name])
	if (!ACI)
		log_asset("ERROR: Invalid asset: [type]:[asset_name]:[ACI]")
		return
	if (legacy)
		ACI.legacy = legacy
	if (keep_local_name)
		ACI.keep_local_name = keep_local_name
	assets[asset_name] = ACI

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


/datum/asset/spritesheet/choose_resin
	name = "chooseresin"

/datum/asset/spritesheet/choose_resin/register()
	for (var/k in GLOB.resin_constructions_list)
		var/datum/resin_construction/RC = k

		var/icon_file = 'icons/mob/hud/actions_xeno.dmi'
		var/icon_state = initial(RC.construction_name)
		var/icon_name = replacetext(icon_state, " ", "-")

		if (sprites[icon_name])
			continue

		var/icon_states_list = icon_states(icon_file)
		if(!(icon_state in icon_states_list))
			var/icon_states_string
			for (var/an_icon_state in icon_states_list)
				if (!icon_states_string)
					icon_states_string = "[json_encode(an_icon_state)](\ref[an_icon_state])"
				else
					icon_states_string += ", [json_encode(an_icon_state)](\ref[an_icon_state])"
			stack_trace("[RC] does not have a valid icon state, icon=[icon_file], icon_state=[json_encode(icon_state)](\ref[icon_state]), icon_states=[icon_states_string]")
			icon_file = 'icons/turf/floors/floors.dmi'
			icon_state = ""

		var/icon/iconNormal = icon(icon_file, icon_state, SOUTH)
		Insert(icon_name, iconNormal)

		var/icon/iconBig = icon(icon_file, icon_state, SOUTH)
		iconBig.Scale(iconNormal.Width()*2, iconNormal.Height()*2)
		Insert("[icon_name]_big", iconBig)
	return ..()


/datum/asset/spritesheet/choose_mark
	name = "choosemark"

/datum/asset/spritesheet/choose_mark/register()
	for (var/k in GLOB.resin_mark_meanings)
		var/datum/xeno_mark_define/RC = k

		var/icon_file = 'icons/mob/hud/xeno_markers.dmi'
		var/icon_state = initial(RC.icon_state)
		var/icon_name = icon_state

		if (sprites[icon_name])
			continue

		var/icon_states_list = icon_states(icon_file)
		if(!(icon_state in icon_states_list))
			var/icon_states_string
			for (var/an_icon_state in icon_states_list)
				if (!icon_states_string)
					icon_states_string = "[json_encode(an_icon_state)](\ref[an_icon_state])"
				else
					icon_states_string += ", [json_encode(an_icon_state)](\ref[an_icon_state])"
			stack_trace("[RC] does not have a valid icon state, icon=[icon_file], icon_state=[json_encode(icon_state)](\ref[icon_state]), icon_states=[icon_states_string]")
			icon_file = 'icons/turf/floors/floors.dmi'
			icon_state = ""

		var/icon/iconNormal = icon(icon_file, icon_state, SOUTH)
		Insert(icon_name, iconNormal)

		var/icon/iconBig = icon(icon_file, icon_state, SOUTH)
		iconBig.Scale(iconNormal.Width()*2, iconNormal.Height()*2)
		Insert("[icon_name]_big", iconBig)
	return ..()

/datum/asset/spritesheet/vending_products
	name = "vending"

/datum/asset/spritesheet/vending_products/register()
	for (var/k in GLOB.vending_products)
		var/atom/item = k
		var/icon_file = initial(item.icon)
		var/icon_state = initial(item.icon_state)
		var/icon/I

		if (!ispath(item, /atom))
			world.log << "not atom! [item]"
			continue

		if (sprites[icon_file])
			continue

		if(icon_state in icon_states(icon_file))
			I = icon(icon_file, icon_state, SOUTH)
			var/c = initial(item.color)
			if (!isnull(c) && c != "#FFFFFF")
				I.Blend(initial(c), ICON_MULTIPLY)
		else
			if (ispath(k, /obj/effect/essentials_set))
				var/obj/effect/essentials_set/es_set = new k()
				var/list/spawned_list = es_set.spawned_gear_list
				if(LAZYLEN(spawned_list))
					var/obj/item/target = spawned_list[1]
					icon_file = initial(target.icon)
					icon_state = initial(target.icon_state)
					var/target_obj = new target()
					I = getFlatIcon(target_obj)
					qdel(target_obj)
			else
				item = new k()
				I = icon(item.icon, item.icon_state, SOUTH)
				qdel(item)
		var/imgid = replacetext(replacetext("[k]", "/obj/item/", ""), "/", "-")

		Insert(imgid, I)
	return ..()


/datum/asset/spritesheet/choose_fruit
	name = "choosefruit"

/datum/asset/spritesheet/choose_fruit/register()
	var/icon_file = 'icons/mob/hostiles/fruits.dmi'
	var/icon_states_list = icon_states(icon_file)
	for(var/obj/effect/alien/resin/fruit/fruit as anything in typesof(/obj/effect/alien/resin/fruit))
		var/icon_state = initial(fruit.mature_icon_state)
		var/icon_name = replacetext(icon_state, " ", "-")

		if (sprites[icon_name])
			continue

		if(!(icon_state in icon_states_list))
			var/icon_states_string
			for (var/an_icon_state in icon_states_list)
				if (!icon_states_string)
					icon_states_string = "[json_encode(an_icon_state)](\ref[an_icon_state])"
				else
					icon_states_string += ", [json_encode(an_icon_state)](\ref[an_icon_state])"
			stack_trace("[fruit] does not have a valid icon state, icon=[icon_file], icon_state=[json_encode(icon_state)](\ref[icon_state]), icon_states=[icon_states_string]")
			icon_file = 'icons/turf/floors/floors.dmi'
			icon_state = ""

		var/icon/iconNormal = icon(icon_file, icon_state, SOUTH)
		Insert(icon_name, iconNormal)

		var/icon/iconBig = icon(icon_file, icon_state, SOUTH)
		iconBig.Scale(iconNormal.Width()*2, iconNormal.Height()*2)
		Insert("[icon_name]_big", iconBig)
	return ..()

/datum/asset/simple/orbit
	assets = list(
		"ghost.png" = 'html/images/ghost.png'
	)
