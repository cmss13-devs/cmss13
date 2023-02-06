//DEFINITIONS FOR ASSET DATUMS START HERE.

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

/datum/asset/directory
	var/list/common = list()
	var/list/common_dirs = list()
	var/list/uncommon_dirs = list()

/datum/asset/directory/register()
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

/datum/asset/directory/send(client, uncommon, send_only_temp = FALSE)
	if(!client)
		log_debug("Warning! Tried to send nanoui data with a null client! (asset_list_items.dm line 76)")
		return

	if(!islist(uncommon))
		uncommon = list(uncommon)

		SSassets.transport.send_assets(client, uncommon)
	if(!send_only_temp)
		SSassets.transport.send_assets(client, common)

/datum/asset/directory/nanoui
	common_dirs = list(
		"nano/css/",
		"nano/images/",
		"nano/js/",
		"nano/js/uiscripts/",
	)
	uncommon_dirs = list(
		"nano/templates/",
	)

/datum/asset/directory/nanoui/weapons
	common_dirs = list(
		"nano/images/weapons/",
	)

	uncommon_dirs = list()

/datum/asset/directory/nanoui/weapons/send(client)
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

/datum/asset/simple/dynamic_icons/proc/update(filename)
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

/datum/asset/simple/dynamic_icons/proc/register_single(asset_name)
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
/* InsertAll("language", 'icons/misc/language.dmi')
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


/datum/asset/spritesheet/playtime_rank
	name = "playtimerank"

/datum/asset/spritesheet/playtime_rank/register()
	var/icon_file = 'icons/mob/hud/hud.dmi'
	var/tier1_state = "hudxenoupgrade1"
	var/tier2_state = "hudxenoupgrade2"
	var/tier3_state = "hudxenoupgrade3"
	var/tier4_state = "hudxenoupgrade4"

	var/icon/tier1_icon = icon(icon_file, tier1_state, SOUTH)
	var/icon/tier2_icon = icon(icon_file, tier2_state, SOUTH)
	var/icon/tier3_icon = icon(icon_file, tier3_state, SOUTH)
	var/icon/tier4_icon = icon(icon_file, tier4_state, SOUTH)


	tier1_icon.Crop(6,26,18,14)
	tier1_icon.Scale(32, 32)
	Insert("tier1_big", tier1_icon)

	tier2_icon.Crop(6,28,18,16)
	tier2_icon.Scale(32, 32)
	Insert("tier2_big", tier2_icon)

	tier3_icon.Crop(6,30,18,18)
	tier3_icon.Scale(32, 32)
	Insert("tier3_big", tier3_icon)

	tier4_icon.Crop(6,30,18,18)
	tier4_icon.Scale(32, 32)
	Insert("tier4_big", tier4_icon)
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

/datum/asset/spritesheet/ranks
	name = "squadranks"

/datum/asset/spritesheet/ranks/register()
	var/icon_file = 'icons/mob/hud/marine_hud.dmi'
	var/list/squads = list("Alpha", "Bravo", "Charlie", "Delta", "Foxtrot", "Cryo")

	var/list/icon_data = list(
		list("Mar", null),
		list("ass", "hudsquad_ass"),
		list("Eng", "hudsquad_engi"),
		list("Med", "hudsquad_med"),
		list("SG", "hudsquad_gun"),
		list("Spc", "hudsquad_spec"),
		list("RTO", "hudsquad_rto"),
		list("SL", "hudsquad_leader"),
	)

	var/i
	for(i = 1; i < length(squads); i++)
		var/squad = squads[i]
		var/color = squad_colors[i]
		for(var/iref in icon_data)
			var/list/iconref = iref
			var/icon/background = icon('icons/mob/hud/marine_hud.dmi', "hudsquad", SOUTH)
			background.Blend(color, ICON_MULTIPLY)
			if(iconref[2])
				var/icon/squad_icon = icon(icon_file, iconref[2], SOUTH)
				background.Blend(squad_icon, ICON_OVERLAY)
			background.Crop(25,25,32,32)
			background.Scale(16,16)

			Insert("squad-[squad]-hud-[iconref[1]]", background)
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
			log_debug("not atom! [item]")
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
					I.Scale(32,32)
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
	var/icon_file = 'icons/mob/xenos/fruits.dmi'
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

/datum/asset/spritesheet/gun_lineart
	name = "gunlineart"

/datum/asset/spritesheet/gun_lineart/register()
	InsertAll("", 'icons/obj/items/weapons/guns/lineart.dmi')
	..()


/datum/asset/simple/orbit
	assets = list(
		"ghost.png" = 'html/images/ghost.png'
	)

/datum/asset/simple/radar_assets
	assets = list(
		"ntosradarbackground.png" = 'icons/images/ui_images/ntosradar_background.png',
		"ntosradarpointer.png" = 'icons/images/ui_images/ntosradar_pointer.png',
		"ntosradarpointerS.png" = 'icons/images/ui_images/ntosradar_pointer_S.png'
	)

/datum/asset/simple/firemodes
	assets = list(
		"auto.png" = 'html/images/auto.png',
		"disabled_auto.png" = 'html/images/disabled_automatic.png',
		"burst.png" = 'html/images/burst.png',
		"disabled_burst.png" = 'html/images/disabled_burst.png',
		"single.png" = 'html/images/single.png',
		"disabled_single.png" = 'html/images/disabled_single.png',
	)


/datum/asset/simple/particle_editor
	assets = list(
		"motion" = 'icons/images/ui_images/particle_editor/motion.png',

		"uniform" = 'icons/images/ui_images/particle_editor/uniform_rand.png',
		"normal" ='icons/images/ui_images/particle_editor/normal_rand.png',
		"linear" = 'icons/images/ui_images/particle_editor/linear_rand.png',
		"square_rand" = 'icons/images/ui_images/particle_editor/square_rand.png',

		"num" = 'icons/images/ui_images/particle_editor/num_gen.png',
		"vector" = 'icons/images/ui_images/particle_editor/vector_gen.png',
		"box" = 'icons/images/ui_images/particle_editor/box_gen.png',
		"circle" = 'icons/images/ui_images/particle_editor/circle_gen.png',
		"sphere" = 'icons/images/ui_images/particle_editor/sphere_gen.png',
		"square" = 'icons/images/ui_images/particle_editor/square_gen.png',
		"cube" = 'icons/images/ui_images/particle_editor/cube_gen.png',
	)

/datum/asset/simple/vv
	assets = list(
		"view_variables.css" = 'html/admin/view_variables.css'
	)
