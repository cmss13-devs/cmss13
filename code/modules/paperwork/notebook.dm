/obj/item/notebook
	name = "notebook"
	gender = PLURAL
	icon = 'icons/obj/items/paper.dmi'
	icon_state = "notebook"
	item_state = "notebook"
	throwforce = 0
	w_class = SIZE_TINY
	throw_range = 2
	throw_speed = SPEED_FAST
	layer = MOB_LAYER
	attack_verb = list("bapped")
	var/paper_left = 10
	var/page = 1
	var/screen = 0

	var/list/color_types = list("red", "green", "black", "blue")

/obj/item/notebook/Initialize(mapload, ...)
	. = ..()

	icon_state = initial(icon_state) + "_[pick(color_types)]"
	item_state = icon_state

	for(var/i = 1 to paper_left)
		new /obj/item/paper(src)

/obj/item/notebook/attackby(obj/item/W, mob/user)
	. = ..()

	if(HAS_TRAIT(W, TRAIT_TOOL_PEN) || istype(W, /obj/item/toy/crayon))
		close_browser(usr, name) //Closes the dialog
		if(page < contents.len)
			page = contents.len
		var/obj/item/paper/P = contents[page]
		P.attackby(W, user)

	attack_self(user) //Update the browsed page.
	add_fingerprint(user)

/obj/item/notebook/attack_self(mob/user)
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

	var/obj/item/paper/P = src[page]
	if(!(istype(usr, /mob/living/carbon/human) || istype(usr, /mob/dead/observer) || isRemoteControlling(usr)))
		dat+= "<BODY class='paper'>[stars(P.info)][P.stamps]</BODY>"
	else
		dat+= "<BODY class='paper'>[P.info][P.stamps]</BODY>"
	show_browser(human_user, dat, P.name, name)
	P.add_fingerprint(usr)
	add_fingerprint(usr)
	update_icon()

/obj/item/notebook/Topic(href, href_list)
	..()
	if(src in usr.contents)
		if(href_list["next_page"])
			if(page == paper_left-1)
				screen = 2
			else if(page == 1)
				screen = 1
			else if(page == paper_left)
				screen = 0
			page++
			playsound(src.loc, "pageturn", 15, 1)
		if(href_list["prev_page"])
			if(page == 1)
				return
			else if(page == 2)
				screen = 0
			else if(page == paper_left)
				screen = 1
			page--
			playsound(src.loc, "pageturn", 15, 1)
		if(href_list["remove"])
			if(contents.len < page)
				page = contents.len
			var/obj/item/W = contents[page]
			usr.put_in_hands(W)
			to_chat(usr, SPAN_NOTICE("You rip out \the [W.name] from \the [src]."))
			paper_left--
			if(paper_left == 1)
				var/obj/item/paper/P = contents[1]
				P.forceMove(usr.loc)
				usr.drop_inv_item_on_ground(src)
				qdel(src)
				usr.put_in_hands(P)
				return
			else if(page >= paper_left)
				screen = 2
				if(page > paper_left)
					page--

		src.attack_self(src.loc)
		updateUsrDialog()
	else if(isobserver(usr))
		to_chat(usr, SPAN_NOTICE("Ghosts don't have hands, you can't flip the page!"))
	else
		to_chat(usr, SPAN_NOTICE("You need to hold it in your hands!"))

/obj/item/notebook/verb/rename()
	set name = "Rename notebook"
	set category = "Object"
	set src in usr

	var/n_name = strip_html(input(usr, "What would you like to label the notebook?", "Notebook Labelling", null)  as text)
	if((loc == usr && usr.stat == 0))
		name = "[(n_name ? text("[n_name]") : "notebook")]"
	add_fingerprint(usr)
