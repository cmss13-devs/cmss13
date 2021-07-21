/obj/item/folder
	name = "folder"
	desc = "A folder."
	icon = 'icons/obj/items/paper.dmi'
	icon_state = "folder"
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
	if(contents.len)
		overlays += "folder_paper"
	return

/obj/item/folder/attackby(obj/item/W as obj, mob/user as mob)
	if(istype(W, /obj/item/paper) || istype(W, /obj/item/photo) || istype(W, /obj/item/paper_bundle))
		if(user.drop_inv_item_to_loc(W, src))
			to_chat(user, SPAN_NOTICE("You put the [W] into \the [src]."))
			update_icon()
	else if(istype(W, /obj/item/tool/pen))
		var/n_name = strip_html(input(usr, "What would you like to label the folder?", "Folder Labelling", null)  as text)
		if((loc == usr && usr.stat == 0))
			name = "folder[(n_name ? text("- '[n_name]'") : null)]"

/obj/item/folder/attack_self(mob/user)
	..()

	var/dat
	for(var/obj/item/paper/P in src)
		dat += "<A href='?src=\ref[src];remove=\ref[P]'>Remove</A> - <A href='?src=\ref[src];read=\ref[P]'>[P.name]</A><BR>"
	for(var/obj/item/photo/Ph in src)
		dat += "<A href='?src=\ref[src];remove=\ref[Ph]'>Remove</A> - <A href='?src=\ref[src];look=\ref[Ph]'>[Ph.name]</A><BR>"
	for(var/obj/item/paper_bundle/Pb in src)
		dat += "<A href='?src=\ref[src];remove=\ref[Pb]'>Remove</A> - <A href='?src=\ref[src];browse=\ref[Pb]'>[Pb.name]</A><BR>"
	show_browser(user, dat, name, "folder")
	onclose(user, "folder")
	add_fingerprint(usr)
	return

/obj/item/folder/Topic(href, href_list)
	..()
	if((usr.stat || usr.is_mob_restrained()))
		return

	if(src.loc == usr)

		if(href_list["remove"])
			var/obj/item/P = locate(href_list["remove"])
			if(P && (P.loc == src) && istype(P))
				P.forceMove(usr.loc)
				usr.put_in_hands(P)

		else if(href_list["read"])
			var/obj/item/paper/P = locate(href_list["read"])
			if(P && (P.loc == src) && istype(P))
				if(!(istype(usr, /mob/living/carbon/human) || istype(usr, /mob/dead/observer) || isRemoteControlling(usr)))
					show_browser("<BODY class='paper'>[stars(P.info)][P.stamps]</BODY>", P.name, "[P.name]")
					onclose(usr, "[P.name]")
				else
					show_browser("<BODY class='paper'>[P.info][P.stamps]</BODY>", P.name, "[P.name]")
					onclose(usr, "[P.name]")
		else if(href_list["look"])
			var/obj/item/photo/P = locate(href_list["look"])
			if(P && (P.loc == src) && istype(P))
				P.show(usr)
		else if(href_list["browse"])
			var/obj/item/paper_bundle/P = locate(href_list["browse"])
			if(P && (P.loc == src) && istype(P))
				P.attack_self(usr)
				onclose(usr, "[P.name]")

		//Update everything
		attack_self(usr)
		update_icon()
	return
