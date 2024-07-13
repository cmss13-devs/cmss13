/obj/item/paper_bundle
	name = "paper bundle"
	gender = PLURAL
	icon = 'icons/obj/items/paper.dmi'
	icon_state = "paper"
	item_state = "paper"
	throwforce = 0
	w_class = SIZE_TINY
	throw_range = 2
	throw_speed = SPEED_FAST
	layer = MOB_LAYER
	attack_verb = list("bapped")
	var/amount = 0 //Amount of items clipped to the paper
	var/page = 1
	var/screen = 0

/obj/item/paper_bundle/attackby(obj/item/W, mob/user)
	..()
	var/obj/item/paper/P
	if(istype(W, /obj/item/paper))
		P = W
		if (istype(P, /obj/item/paper/carbon))
			var/obj/item/paper/carbon/C = P
			if (!C.iscopy && !C.copied)
				to_chat(user, SPAN_NOTICE("Take off the carbon copy first."))
				add_fingerprint(user)
				return
		if(loc == user)
			user.drop_inv_item_on_ground(P)
			attach_doc(P, user)
	else if(istype(W, /obj/item/photo))
		if(loc == user)
			user.drop_inv_item_on_ground(W)
			attach_doc(W, user)
	else if(W.heat_source >= 400)
		burnpaper(W, user)
	else if(istype(W, /obj/item/paper_bundle))
		if(loc == user)
			user.drop_inv_item_on_ground(W)
			for(var/obj/O in W)
				attach_doc(O, user, TRUE)
			to_chat(user, SPAN_NOTICE("You add \the [W.name] to [(src.name == "paper bundle") ? "the paper bundle" : src.name]."))
			qdel(W)
	else
		if(HAS_TRAIT(W, TRAIT_TOOL_PEN) || istype(W, /obj/item/toy/crayon))
			close_browser(usr, name) //Closes the dialog
		if(page < length(contents))
			page = length(contents)
		P = contents[page]
		P.attackby(W, user)

	update_icon()
	attack_self(user) //Update the browsed page.
	add_fingerprint(user)

/obj/item/paper_bundle/proc/burnpaper(obj/item/P, mob/user)
	var/class = "<span class='warning'>"

	if(P.heat_source >= 400 && !user.is_mob_restrained())
		if(istype(P, /obj/item/tool/lighter/zippo))
			class = "<span class='rose'>"

		user.visible_message("[class][user] holds \the [P] up to \the [src], it looks like \he's trying to burn it!</span>", \
		"[class]You hold \the [P] up to \the [src], burning it slowly.</span>")

		spawn(20)
			if(get_dist(src, user) < 2 && user.get_active_hand() == P && P.heat_source)
				user.visible_message("[class][user] burns right through \the [src], turning it to ash. It flutters through the air before settling on the floor in a heap.</span>", \
				"[class]You burn right through \the [src], turning it to ash. It flutters through the air before settling on the floor in a heap.</span>")

				if(user.get_inactive_hand() == src)
					user.drop_inv_item_on_ground(src)

				new /obj/effect/decal/cleanable/ash(src.loc)
				qdel(src)

			else
				to_chat(user, SPAN_DANGER("You must hold \the [P] steady to burn \the [src]."))

/obj/item/paper_bundle/get_examine_text(mob/user)
	. = list(desc)
	if(in_range(user, src) || isobserver(user))
		src.attack_self(user)
	else
		. += SPAN_NOTICE("It is too far away.")

/obj/item/paper_bundle/attack_self(mob/user)
	..()

	if(!(ishuman(user) || isobserver(user)))
		return

	var/mob/living/carbon/human/human_user = user
	var/dat
	switch(screen)
		if(0)
			dat+= "<DIV STYLE='float:left; text-align:left; width:33.33333%'></DIV>"
			dat+= "<DIV STYLE='float:left; text-align:center; width:33.33333%'><A href='?src=\ref[src];remove=1'>Remove [(istype(src[page], /obj/item/paper)) ? "paper" : "photo"]</A></DIV>"
			dat+= "<DIV STYLE='float:left; text-align:right; width:33.33333%'><A href='?src=\ref[src];next_page=1'>Next Page</A></DIV><BR><HR>"
		if(1)
			dat+= "<DIV STYLE='float:left; text-align:left; width:33.33333%'><A href='?src=\ref[src];prev_page=1'>Previous Page</A></DIV>"
			dat+= "<DIV STYLE='float:left; text-align:center; width:33.33333%'><A href='?src=\ref[src];remove=1'>Remove [(istype(src[page], /obj/item/paper)) ? "paper" : "photo"]</A></DIV>"
			dat+= "<DIV STYLE='float:left; text-align:right; width:33.33333%'><A href='?src=\ref[src];next_page=1'>Next Page</A></DIV><BR><HR>"
		if(2)
			dat+= "<DIV STYLE='float:left; text-align:left; width:33.33333%'><A href='?src=\ref[src];prev_page=1'>Previous Page</A></DIV>"
			dat+= "<DIV STYLE='float:left; text-align:center; width:33.33333%'><A href='?src=\ref[src];remove=1'>Remove [(istype(src[page], /obj/item/paper)) ? "paper" : "photo"]</A></DIV><BR><HR>"
			dat+= "<DIV STYLE='float;left; text-align:right; with:33.33333%'></DIV>"
	if(istype(src[page], /obj/item/paper))
		var/obj/item/paper/P = src[page]
		if(!(istype(usr, /mob/living/carbon/human) || istype(usr, /mob/dead/observer) || isRemoteControlling(usr)))
			dat+= "<BODY class='paper'>[stars(P.info)][P.stamps]</BODY>"
		else
			dat+= "<BODY class='paper'>[P.info][P.stamps]</BODY>"
		show_browser(human_user, dat, P.name, name)
		P.add_fingerprint(usr)
	else if(istype(src[page], /obj/item/photo))
		var/obj/item/photo/P = src[page]
		human_user << browse_rsc(P.img, "tmp_photo.png")
		dat += "<html>" \
		+ "<body style='overflow:hidden'>" \
		+ "<div> <img src='tmp_photo.png' width = '180'" \
		+ "[P.scribble ? "<div> Written on the back:<br><i>[P.scribble]</i>" : null]"\
		+ "</body></html>"
		show_browser(human_user, dat, P.name, name)
		P.add_fingerprint(usr)
	add_fingerprint(usr)
	update_icon()

/obj/item/paper_bundle/Topic(href, href_list)
	..()
	if((src in usr.contents) || (istype(src.loc, /obj/item/folder) && (src.loc in usr.contents)))
		if(href_list["next_page"])
			if(page == amount-1)
				screen = 2
			else if(page == 1)
				screen = 1
			else if(page == amount)
				return
			page++
			playsound(src.loc, "pageturn", 15, 1)
		if(href_list["prev_page"])
			if(page == 1)
				return
			else if(page == 2)
				screen = 0
			else if(page == amount)
				screen = 1
			page--
			playsound(src.loc, "pageturn", 15, 1)
		if(href_list["remove"])
			if(length(contents) < page)
				page = length(contents)
			var/obj/item/W = contents[page]
			usr.put_in_hands(W)
			to_chat(usr, SPAN_NOTICE("You remove the [W.name] from the bundle."))
			amount--
			if(amount == 1)
				var/obj/item/paper/P = contents[1]
				P.forceMove(usr.loc)
				usr.drop_inv_item_on_ground(src)
				qdel(src)
				usr.put_in_hands(P)
				return
			else if(page >= amount)
				screen = 2
				if(page > amount)
					page--

			update_icon()

		src.attack_self(src.loc)
		updateUsrDialog()
	else if(isobserver(usr))
		to_chat(usr, SPAN_NOTICE("Ghosts don't have hands, you can't flip the page!"))
	else
		to_chat(usr, SPAN_NOTICE("You need to hold it in your hands!"))

/obj/item/paper_bundle/proc/operator[](index_num)
	return contents[index_num]

/obj/item/paper_bundle/verb/rename()
	set name = "Rename bundle"
	set category = "Object"
	set src in usr

	var/n_name = strip_html(input(usr, "What would you like to label the bundle?", "Bundle Labelling", null)  as text)
	if((loc == usr && usr.stat == 0))
		name = "[(n_name ? text("[n_name]") : "paper")]"
	add_fingerprint(usr)

/obj/item/paper_bundle/verb/remove_all()
	set name = "Loose bundle"
	set category = "Object"
	set src in usr

	to_chat(usr, SPAN_NOTICE("You loosen the bundle."))
	for(var/obj/O in src)
		O.forceMove(usr.loc)
		O.add_fingerprint(usr)
	usr.drop_inv_item_on_ground(src)
	qdel(src)

/obj/item/paper_bundle/update_icon()
	if(length(contents))
		var/obj/item/I = contents[1]
		icon_state = I.icon_state
		overlays = I.overlays
	underlays = 0
	var/i = 0
	var/photo = 0
	for(var/obj/O in src)
		var/image/IMG = image('icons/obj/items/paper.dmi')
		if(istype(O, /obj/item/paper))
			IMG.icon_state = O.icon_state
			IMG.pixel_x -= min(1*i, 2)
			IMG.pixel_y -= min(1*i, 2)
			pixel_x = min(0.5*i, 1)
			pixel_y = min(  1*i, 2)
			underlays += IMG
			i++
		else if(istype(O, /obj/item/photo))
			var/obj/item/photo/PH = O
			IMG = PH.tiny
			photo++
			overlays += IMG
	if(i>1)
		desc =  "[i] papers clipped to each other."
	else
		desc = "A single sheet of paper."
	if(photo)
		if(photo > 1)
			desc += "\nThere are also [photo] photos attached to it."
		else
			desc += "\nThere is also a photo attached to it."
	overlays += image('icons/obj/items/paper.dmi', "clip")

/obj/item/paper_bundle/proc/attach_doc(obj/item/I, mob/living/user, no_message)
	if(I.loc == user)
		user.drop_inv_item_on_ground(I)
	I.forceMove(src)
	I.add_fingerprint(user)
	amount++
	if(!no_message)
		to_chat(user, SPAN_NOTICE("You add [I] to [src]."))
	if(screen == 2)
		screen = 1
	update_icon()
