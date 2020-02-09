/var/create_object_html = null

/datum/admins/proc/create_object(var/mob/user)
	if (!create_object_html)
		var/objectjs = null
		objectjs = jointext(typesof(/obj), ";")
		create_object_html = file2text('html/create_object.html')
		create_object_html = replacetext(create_object_html, "null /* object types */", "\"[objectjs]\"")

	show_browser(user, replacetext(create_object_html, "/* ref src */", "\ref[src]"), "Create Object", "create_object", "size=425x475")


/datum/admins/proc/quick_create_object(var/mob/user)

	var/quick_create_object_html = null
	var/pathtext = null

	pathtext = input("Select the path of the object you wish to create.", "Path", "/obj") as null|anything in list("/obj","/obj/structure","/obj/structure/machinery","/obj/mecha","/obj/item","/obj/item/weapon","/obj/item/weapon/gun","/obj/item/ammo_magazine","/obj/item/hardpoint","/obj/item/clothing","/obj/item/storage","/obj/item/reagent_container","/obj/item/device","/obj/effect","/obj/vehicle","/obj/item/stack")
	if(!pathtext)
		return
	var path = text2path(pathtext)

	if (!quick_create_object_html)
		var/objectjs = null
		objectjs = jointext(typesof(path), ";")
		quick_create_object_html = file2text('html/create_object.html')
		quick_create_object_html = replacetext(quick_create_object_html, "null /* object types */", "\"[objectjs]\"")

	show_browser(user, replacetext(quick_create_object_html, "/* ref src */", "\ref[src]"), "Quick Create Object", "quick_create_object", "size=425x475")
