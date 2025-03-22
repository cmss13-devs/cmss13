/*
 * Photo
 */
/obj/item/photo
	name = "photo"
	icon = 'icons/obj/items/paper.dmi'
	icon_state = "photo_item"
	w_class = SIZE_TINY
	var/datum/picture/picture
	var/scribble //Scribble on the back.

/obj/item/photo/Initialize(mapload, datum/picture/P, datum_name = TRUE, datum_desc = TRUE)
	. = ..()
	set_picture(P, datum_name, datum_desc, TRUE)

/obj/item/photo/proc/set_picture(datum/picture/P, setname, setdesc, name_override = FALSE)
	if(!istype(P))
		return
	picture = P
	update_icon_state()
	if(P.caption)
		scribble = P.caption
	if(setname && P.picture_name)
		if(name_override)
			name = P.picture_name
		else
			name = "photo - [P.picture_name]"
	if(setdesc && P.picture_desc)
		desc = P.picture_desc

/obj/item/photo/proc/update_icon_state()
	if(!istype(picture) || !picture.picture_image)
		return
	var/icon/I = picture.get_small_icon(initial(icon_state))
	if(I)
		icon = I
	return

/obj/item/photo/attack_self(mob/user)
	user.examinate(src)

/obj/item/photo/attackby(obj/item/P as obj, mob/user as mob)
	if(HAS_TRAIT(P, TRAIT_TOOL_PEN) || istype(P, /obj/item/toy/crayon))
		var/txt = strip_html(input(user, "What would you like to write on the back?", "Photo Writing", null)  as text)
		txt = copytext(txt, 1, 128)
		if(loc == user && user.stat == 0)
			scribble = txt
			playsound(src, "paper_writing", 15, TRUE)
	..()

/obj/item/photo/examine(mob/user)
	. = ..()

	if(in_range(src, user) || isobserver(user))
		show(user)
	else
		. += SPAN_WARNING("You need to get closer to get a good look at this photo!")

/obj/item/photo/proc/show(mob/user)
	if(!istype(picture) || !picture.picture_image)
		to_chat(user, SPAN_WARNING("[src] seems to be blank..."))
		return
	user << browse_rsc(picture.picture_image, "tmp_photo.png")
	user << browse("<html><head><meta http-equiv='Content-Type' content='text/html; charset=UTF-8'><title>[name]</title></head>" \
		+ "<body style='overflow:hidden;margin:0;text-align:center'>" \
		+ "<img src='tmp_photo.png' width='480' style='-ms-interpolation-mode:nearest-neighbor' />" \
		+ "[scribble ? "<br>Written on the back:<br><i>[scribble]</i>" : ""]"\
		+ "</body></html>", "window=photo_showing;size=480x608")
	onclose(user, "[name]")

/obj/item/photo/verb/rename()
	set name = "Rename photo"
	set category = "Object"
	set src in usr

	var/n_name = tgui_input_text(usr, "What would you like to label the photo?", "Photo Labelling", max_length = MAX_NAME_LEN)
	//loc.loc check is for making possible renaming photos in clipboards
	if(( (loc == usr || (loc.loc && loc.loc == usr)) && usr.stat == 0))
		name = "[(n_name ? text("[n_name]") : "photo")]"
	add_fingerprint(usr)
	return

/obj/item/photo/old
	icon_state = "photo_old"
