/datum/admins/var/static/create_object_html = null

/datum/admins/proc/create_object(mob/user)
	if (!create_object_html)
		var/objectjs = null
		objectjs = jointext(typesof(/obj), ";")
		create_object_html = file2text('html/create_object.html')
		create_object_html = replacetext(create_object_html, "null /* object types */", "\"[objectjs]\"")
		create_object_html = replacetext(create_object_html, "/* href token */", RawHrefToken(forceGlobal = TRUE))

	show_browser(user, replacetext(create_object_html, "/* ref src */", "\ref[src]"), "Create Object", "create_object", width = 450, height = 525)


/datum/admins/proc/quick_create_object(mob/user)

	var/quick_create_object_html = null
	var/pathtext = null
	var/list/quick_paths = list("/obj",
								"/obj/effect",
								"/obj/item",
								"/obj/item/ammo_box",
								"/obj/item/ammo_magazine",
								"/obj/item/clothing",
								"/obj/item/device",
								"/obj/item/hardpoint",
								"/obj/item/reagent_container",
								"/obj/item/stack",
								"/obj/item/storage",
								"/obj/item/explosive",
								"/obj/item/weapon",
								"/obj/item/weapon/gun",
								"/obj/structure",
								"/obj/structure/machinery",
								"/obj/vehicle"
								)

	pathtext = tgui_input_list(usr, "Select the path of the object you wish to create.", "Path", quick_paths)
	if(!pathtext)
		return
	var/path = text2path(pathtext)

	if (!quick_create_object_html)
		var/objectjs = null
		objectjs = jointext(typesof(path), ";")
		quick_create_object_html = file2text('html/create_object.html')
		quick_create_object_html = replacetext(quick_create_object_html, "null /* object types */", "\"[objectjs]\"")
		quick_create_object_html = replacetext(quick_create_object_html, "/* href token */", RawHrefToken(forceGlobal = TRUE))

	show_browser(user, replacetext(quick_create_object_html, "/* ref src */", "\ref[src]"), "Quick Create Object", "quick_create_object", width = 450, height = 525)
