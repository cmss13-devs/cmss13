/obj/item/notepad
	name = "notepad"
	gender = PLURAL
	icon = 'icons/obj/items/paper.dmi'
	icon_state = "notebook"
	item_icons = list(
		WEAR_L_HAND = 'icons/mob/humans/onmob/inhands/equipment/paperwork_lefthand.dmi',
		WEAR_R_HAND = 'icons/mob/humans/onmob/inhands/equipment/paperwork_righthand.dmi'
		)
	throwforce = 0
	w_class = SIZE_TINY
	throw_range = 2
	throw_speed = SPEED_FAST
	layer = MOB_LAYER
	attack_verb = list("bapped")
	var/paper_left = 10
	var/page = 1
	var/screen = 0

	var/list/cover_colors = list("red", "green", "black", "blue")
	var/cover_color

/obj/item/notepad/Initialize(mapload, ...)
	. = ..()
	if(!cover_color)
		cover_color = pick(cover_colors)
	icon_state = initial(icon_state) + "_[cover_color]"
	item_state = initial(icon_state) + "_[cover_color]"

	for(var/i = 1 to paper_left)
		new /obj/item/paper(src)

/obj/item/notepad/attackby(obj/item/attack_item, mob/user)
	. = ..()

	if(HAS_TRAIT(attack_item, TRAIT_TOOL_PEN) || istype(attack_item, /obj/item/toy/crayon))
		close_browser(usr, name) //Closes the dialog
		if(page < length(contents))
			page = 1
		var/obj/item/paper/paper = contents[page]
		paper.attackby(attack_item, user)

	attack_self(user) //Update the browsed page.
	add_fingerprint(user)

/obj/item/notepad/attack_self(mob/user)
	..()

	if(!(ishuman(user) || isobserver(user)))
		return

	var/mob/living/carbon/human/human_user = user
	var/dat
	switch(screen)
		if(0)
			dat+= "<DIV STYLE='float:left; text-align:left; width:33.33333%'></DIV>"
			dat+= "<DIV STYLE='float:left; text-align:center; width:33.33333%'><A href='byond://?src=\ref[src];remove=1'>Remove paper</A></DIV>"
			dat+= "<DIV STYLE='float:left; text-align:right; width:33.33333%'><A href='byond://?src=\ref[src];next_page=1'>Next Page</A></DIV><BR><HR>"
		if(1)
			dat+= "<DIV STYLE='float:left; text-align:left; width:33.33333%'><A href='byond://?src=\ref[src];prev_page=1'>Previous Page</A></DIV>"
			dat+= "<DIV STYLE='float:left; text-align:center; width:33.33333%'><A href='byond://?src=\ref[src];remove=1'>Remove paper</A></DIV>"
			dat+= "<DIV STYLE='float:left; text-align:right; width:33.33333%'><A href='byond://?src=\ref[src];next_page=1'>Next Page</A></DIV><BR><HR>"
		if(2)
			dat+= "<DIV STYLE='float:left; text-align:left; width:33.33333%'><A href='byond://?src=\ref[src];prev_page=1'>Previous Page</A></DIV>"
			dat+= "<DIV STYLE='float:left; text-align:center; width:33.33333%'><A href='byond://?src=\ref[src];remove=1'>Remove paper</A></DIV><BR><HR>"
			dat+= "<DIV STYLE='float;left; text-align:right; with:33.33333%'></DIV>"

	var/obj/item/paper/paper = src[page]
	if(!(istype(usr, /mob/living/carbon/human) || istype(usr, /mob/dead/observer) || isRemoteControlling(usr)))
		dat += "<BODY class='paper'>[stars(paper.info)][paper.stamps]</BODY>"
	else
		dat += "<BODY class='paper'>[paper.info][paper.stamps]</BODY>"
	show_browser(human_user, dat, paper.name, name)
	paper.add_fingerprint(usr)
	add_fingerprint(usr)
	update_icon()

/obj/item/notepad/Topic(href, href_list)
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
			playsound(loc, "pageturn", 15, 1)
		if(href_list["prev_page"])
			if(page == 1)
				return
			else if(page == 2)
				screen = 0
			else if(page == paper_left)
				screen = 1
			page--
			playsound(loc, "pageturn", 15, 1)
		if(href_list["remove"])
			if(length(contents) < page)
				page = length(contents)
			var/obj/item/ripped_out_page = contents[page]
			usr.put_in_hands(ripped_out_page)
			to_chat(usr, SPAN_NOTICE("You rip out [ripped_out_page] from [src]."))
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

		attack_self(loc)
		updateUsrDialog()
	else if(isobserver(usr))
		to_chat(usr, SPAN_NOTICE("Ghosts don't have hands, you can't flip the page!"))
	else
		to_chat(usr, SPAN_NOTICE("You need to hold it in your hands!"))

/obj/item/notepad/proc/operator[](index_num)
	return contents[index_num]

/obj/item/notepad/verb/rename()
	set name = "Rename notepad"
	set category = "Object"
	set src in usr

	var/n_name = strip_html(tgui_input_text(usr, "What would you like to label the notepad?", "notepad Labelling", null, 16))
	if((loc == usr && usr.stat == CONSCIOUS))
		name = "[(n_name ? text("[n_name]") : "notepad")]"
	add_fingerprint(usr)

/obj/item/notepad/black
	cover_color = "black"

/obj/item/notepad/blue
	cover_color = "blue"

/obj/item/notepad/green
	cover_color = "green"

/obj/item/notepad/red
	cover_color = "red"
