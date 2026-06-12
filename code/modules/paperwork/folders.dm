/obj/item/folder
	name = "folder"
	desc = "A folder."
	icon = 'icons/obj/items/paper.dmi'
	icon_state = "folder"
	item_icons = list(
		WEAR_L_HAND = 'icons/mob/humans/onmob/inhands/items/books_lefthand.dmi',
		WEAR_R_HAND = 'icons/mob/humans/onmob/inhands/items/books_righthand.dmi'
		)
	w_class = SIZE_SMALL
	var/updateicon = 0//If they spawn with premade papers, update icon

/obj/item/folder/blue
	desc = "A blue folder."
	icon_state = "folder_blue"

/obj/item/folder/red
	desc = "A red folder."
	icon_state = "folder_red"

/obj/item/folder/yellow
	desc = "A yellow folder."
	icon_state = "folder_yellow"

/obj/item/folder/white
	desc = "A white folder."
	icon_state = "folder_white"

/obj/item/folder/black
	desc = "A black folder."
	icon_state = "folder_black"

/obj/item/folder/black_random
	desc = "A black folder. It is decorated with stripes."
	icon_state = "folder_black_green"

/obj/item/folder/black_random/Initialize()
	. = ..()
	icon_state = "folder_black[pick("_red", "_green", "_blue", "_yellow", "_white")]"

/obj/item/folder/Initialize()
	. = ..()
	if(updateicon)
		update_icon()

/obj/item/folder/update_icon()
	overlays.Cut()
	if(length(contents))
		overlays += "folder_paper"
	return

/obj/item/folder/attackby(obj/item/W as obj, mob/user as mob)
	if(istype(W, /obj/item/paper) || istype(W, /obj/item/photo) || istype(W, /obj/item/paper_bundle))
		if(user.drop_inv_item_to_loc(W, src))
			to_chat(user, SPAN_NOTICE("You put [W] into [src]."))
			update_icon()
	else if(HAS_TRAIT(W, TRAIT_TOOL_PEN))
		var/n_name = strip_html(input(usr, "What would you like to label the folder?", "Folder Labelling", null)  as text)
		if((loc == usr && usr.stat == 0))
			name = "folder[(n_name ? text("- '[n_name]'") : null)]"

/obj/item/folder/attack_self(mob/user)
	..()

	var/dat
	for(var/obj/item/paper/P in src)
		dat += "<A href='byond://?src=\ref[src];remove=\ref[P]'>Remove</A> - <A href='byond://?src=\ref[src];read=\ref[P]'>[P.name]</A><BR>"
	for(var/obj/item/photo/Ph in src)
		dat += "<A href='byond://?src=\ref[src];remove=\ref[Ph]'>Remove</A> - <A href='byond://?src=\ref[src];look=\ref[Ph]'>[Ph.name]</A><BR>"
	for(var/obj/item/paper_bundle/Pb in src)
		dat += "<A href='byond://?src=\ref[src];remove=\ref[Pb]'>Remove</A> - <A href='byond://?src=\ref[src];browse=\ref[Pb]'>[Pb.name]</A><BR>"
	show_browser(user, dat, name, "folder")
	onclose(user, "folder")
	add_fingerprint(usr)
	return

/obj/item/folder/Topic(href, href_list)
	..()
	if((usr.stat || usr.is_mob_restrained()))
		return

	if(src.loc != usr)
		return

	if(href_list["remove"])
		var/obj/item/attachment = locate(href_list["remove"])
		if(istype(attachment) && (attachment.loc == src))
			attachment.forceMove(usr.loc)
			usr.put_in_hands(attachment)

	else if(href_list["read"])
		var/obj/item/paper/paper = locate(href_list["read"])
		if(istype(paper) && (paper.loc == src))
			var/fully_readable = istype(usr, /mob/living/carbon/human) || istype(usr, /mob/dead/observer) || isRemoteControlling(usr)
			show_browser(usr, "<BODY class='paper'>[fully_readable ? paper.info : stars(paper.info)][paper.stamps]</BODY>", paper.name, "[paper.name]")
			onclose(usr, "[paper.name]")
	else if(href_list["look"])
		var/obj/item/photo/photo = locate(href_list["look"])
		if(istype(photo) && (photo.loc == src))
			photo.show(usr)
	else if(href_list["browse"])
		var/obj/item/paper_bundle/bundle = locate(href_list["browse"])
		if(istype(bundle) && (bundle.loc == src))
			bundle.attack_self(usr)
			onclose(usr, "[bundle.name]")

	//Update everything
	attack_self(usr)
	update_icon()
