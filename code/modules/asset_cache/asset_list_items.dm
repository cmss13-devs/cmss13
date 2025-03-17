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

/datum/asset/directory/get_url_mappings()
	. = ..()

	for (var/asset_name in common)
		.[asset_name] = SSassets.transport.get_asset_url(asset_name)

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

/datum/asset/simple/nanoui_images
	keep_local_name = TRUE

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
		"logo_wy.png" = 'html/paper_assets/logo_wy.png',
		"logo_wy_inv.png" = 'html/paper_assets/logo_wy_inv.png',
		"logo_uscm.png" = 'html/paper_assets/logo_uscm.png',
		"logo_provost.png" = 'html/paper_assets/logo_provost.png',
		"logo_upp.png" = 'html/paper_assets/logo_upp.png',
		"logo_cmb.png" = 'html/paper_assets/logo_cmb.png',
		"background_white.jpg" = 'html/paper_assets/background_white.jpg',
		"background_dark.jpg" = 'html/paper_assets/background_dark.jpg',
		"background_dark2.jpg" = 'html/paper_assets/background_dark2.jpg',
		"background_dark_fractal.png" = 'html/paper_assets/background_dark_fractal.png',
		"colonialspacegruntsEZ.png" = 'html/paper_assets/colonialspacegruntsEZ.png',
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
	var/tier1_state = "hudxenoupgrade2"
	var/tier2_state = "hudxenoupgrade3"
	var/tier3_state = "hudxenoupgrade4"
	var/tier4_state = "hudxenoupgrade5"

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

	var/list/icon_data = list(
		list("Mar", null),
		list("ass", "hudsquad_ass"),
		list("load", "hudsquad_load"),
		list("Eng", "hudsquad_engi"),
		list("Med", "hudsquad_med"),
		list("medk9", "hudsquad_medk9"),
		list("SG", "hudsquad_gun"),
		list("Spc", "hudsquad_spec"),
		list("TL", "hudsquad_tl"),
		list("SL", "hudsquad_leader"),
	)

	for(var/datum/squad/marine/squad in GLOB.RoleAuthority.squads)
		var/color = squad.equipment_color
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
	var/list/additional_preload_icons = list(
		/obj/item/storage/box,
		/obj/item/ammo_box,
		/obj/item/reagent_container,
		/obj/item/ammo_magazine,
		/obj/item/device/binoculars,
		/obj/item/clothing/under/marine,
		/obj/item/clothing/suit/storage/marine,
		/obj/item/clothing/head/helmet/marine,
		/obj/item/clothing/suit/storage/jacket/marine,
		/obj/item/storage/backpack/marine,
		/obj/item/storage/large_holster,
		/obj/item/storage/backpack/general_belt,
		/obj/item/storage/belt,
		/obj/item/storage/pill_bottle,
		/obj/item/weapon,
	)

/datum/asset/spritesheet/vending_products/register()
	for (var/current_product in GLOB.vending_products)
		var/atom/item = current_product
		var/icon_file = initial(item.icon)
		var/icon_state = initial(item.icon_state)
		var/icon/new_icon

		if (!ispath(item, /atom))
			log_debug("not atom! [item]")
			continue

		var/imgid = replacetext(replacetext("[current_product]", "/obj/item/", ""), "/", "-")

		if(sprites[imgid])
			continue

		if(icon_state in icon_states(icon_file))
			if(is_path_in_list(current_product, additional_preload_icons))
				item = new current_product()
				if(ispath(current_product, /obj/item/weapon))
					new_icon = icon(item.icon, item.icon_state, SOUTH)
					var/new_color = initial(item.color)
					if(!isnull(new_color) && new_color != "#FFFFFF")
						new_icon.Blend(new_color, ICON_MULTIPLY)
				else
					new_icon = getFlatIcon(item)
					new_icon.Scale(32,32)
				qdel(item)
			else
				new_icon = icon(icon_file, icon_state, SOUTH)
				var/new_color = initial(item.color)
				if(!isnull(new_color) && new_color != "#FFFFFF")
					new_icon.Blend(new_color, ICON_MULTIPLY)
		else
			if(ispath(current_product, /obj/effect/essentials_set))
				var/obj/effect/essentials_set/essentials = new current_product()
				var/list/spawned_list = essentials.spawned_gear_list
				if(LAZYLEN(spawned_list))
					var/obj/item/target = spawned_list[1]
					icon_file = initial(target.icon)
					icon_state = initial(target.icon_state)
					var/target_obj = new target()
					new_icon = getFlatIcon(target_obj)
					new_icon.Scale(32,32)
					qdel(target_obj)
			else
				item = new current_product()
				new_icon = icon(item.icon, item.icon_state, SOUTH)
				qdel(item)

		Insert(imgid, new_icon)
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

/datum/asset/spritesheet/tutorial
	name = "tutorial"

/datum/asset/spritesheet/tutorial/register()
	for(var/icon_state in icon_states('icons/misc/tutorial.dmi'))
		var/icon/icon_sprite = icon('icons/misc/tutorial.dmi', icon_state)
		icon_sprite.Scale(128, 128)
		Insert(icon_state, icon_sprite)

	var/icon/retrieved_icon = icon('icons/mob/hud/human_dark.dmi', "intent_all")
	retrieved_icon.Scale(128, 128)
	Insert("intents", retrieved_icon)

	retrieved_icon = icon('icons/mob/xenos/castes/tier_4/predalien.dmi', "Normal Predalien Walking")
	retrieved_icon.Scale(128, 128)
	Insert("predalien", retrieved_icon)

	return ..()


/datum/asset/spritesheet/gun_lineart
	name = "gunlineart"

/datum/asset/spritesheet/gun_lineart/register()
	var/icon_file = 'icons/obj/items/weapons/guns/lineart.dmi'
	InsertAll("", icon_file)

	for(var/obj/item/weapon/gun/current_gun as anything in subtypesof(/obj/item/weapon/gun))
		if(isnull(initial(current_gun.icon_state)))
			continue
		if(initial(current_gun.flags_gun_features) & GUN_UNUSUAL_DESIGN)
			continue // These don't have a way to inspect weapon stats
		var/obj/item/weapon/gun/temp_gun = new current_gun
		var/icon_state = temp_gun.base_gun_icon // base_gun_icon is set in Initialize generally
		qdel(temp_gun)
		if(icon_state && isnull(sprites[icon_state]))
			// downgrade this to a log_debug if we don't want missing lineart to be a lint
			stack_trace("[current_gun] does not have a valid lineart icon state, icon=[icon_file], icon_state=[json_encode(icon_state)]")

	..()

/datum/asset/spritesheet/gun_lineart_modes
	name = "gunlineartmodes"

/datum/asset/spritesheet/gun_lineart_modes/register()
	InsertAll("", 'icons/obj/items/weapons/guns/lineart_modes.dmi')
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

/datum/asset/directory/book_assets
	common_dirs = list(
		"html/book_assets/",
	)
