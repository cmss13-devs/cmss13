#define MAX_NOTICES 8

/obj/structure/noticeboard
	name = "notice board"
	desc = "A board for pinning important notices upon."
	icon = 'icons/obj/structures/props/furniture/noticeboard.dmi'
	icon_state = "noticeboard"
	density = FALSE
	anchored = TRUE
	var/notices = 0

/obj/structure/noticeboard/Initialize(mapload)
	. = ..()
	if(!mapload)
		return

	for(var/obj/item/I in loc)
		if(notices >= MAX_NOTICES)
			break
		if(istype(I, /obj/item/paper))
			I.forceMove(src)
			notices++
	update_overlays()

//attaching papers!!
/obj/structure/noticeboard/attackby(obj/item/O, mob/user, params)
	if(istype(O, /obj/item/paper) || istype(O, /obj/item/photo))
		if(!allowed(user))
			to_chat(user, SPAN_WARNING("You are not authorized to add notices!"))
			return
		if(notices < MAX_NOTICES)
			if(!user.drop_inv_item_to_loc(O, src))
				return
			notices++
			update_overlays()
			to_chat(user, SPAN_NOTICE("You pin the [O] to the noticeboard."))
		else
			to_chat(user, SPAN_WARNING("The notice board is full!"))
	else if(istype(O, /obj/item/tool/pen))
		user.set_interaction(src)
		tgui_interact(user)
	else
		return ..()

/obj/structure/noticeboard/attack_hand(mob/user)
	. = ..()
	user.set_interaction(src)
	tgui_interact(user)

/obj/structure/noticeboard/ui_state(mob/user)
	return GLOB.physical_state

/obj/structure/noticeboard/tgui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "NoticeBoard", name)
		ui.open()

/obj/structure/noticeboard/ui_data(mob/user)
	var/list/data = list()
	data["allowed"] = allowed(user)
	data["items"] = list()
	for(var/obj/item/content in contents)
		var/list/content_data = list(
			name = content.name,
			ref = REF(content)
		)
		data["items"] += list(content_data)
	return data

/obj/structure/noticeboard/ui_act(action, params)
	. = ..()
	if(.)
		return

	var/obj/item/item = locate(params["ref"]) in contents
	if(!istype(item) || item.loc != src)
		return

	var/mob/user = usr

	switch(action)
		if("examine")
			user.examinate(item)
			return TRUE
		if("write")
			var/obj/item/writing_tool = user.get_held_item()
			if(!istype(writing_tool, /obj/item/tool/pen))
				balloon_alert(user, "you need a pen for that!")
				return
			item.attackby(writing_tool, user)
			return TRUE
		if("remove")
			if(!allowed(user))
				return
			remove_item(item, user)
			return TRUE

/obj/structure/noticeboard/proc/update_overlays()
	if(overlays)
		overlays.Cut()
	if(notices)
		overlays += image(icon, "notices_[notices]")

/obj/structure/noticeboard/proc/remove_item(obj/item/item, mob/user)
	item.forceMove(loc)
	if(user)
		user.put_in_hands(item)
		balloon_alert(user, "removed from board")
	notices--
	update_overlays()

