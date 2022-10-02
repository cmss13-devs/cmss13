/*	Photography!
 *	Contains:
 *		Camera
 *		Camera Film
 *		Photos
 *		Photo Albums
 */

/*
* film *
*******/
/obj/item/device/camera_film
	name = "film cartridge"
	icon = 'icons/obj/items/items.dmi'
	desc = "A camera film cartridge. Insert it into a camera to reload it."
	icon_state = "film"
	item_state = "electropack"
	w_class = SIZE_TINY


/*
* photo *
********/
/obj/item/photo
	name = "photo"
	icon = 'icons/obj/items/items.dmi'
	icon_state = "photo"
	item_state = "paper"
	w_class = SIZE_TINY
	var/icon/img	//Big photo image
	var/scribble	//Scribble on the back.
	var/icon/tiny
	var/photo_size = 3

/obj/item/photo/attack_self(mob/user)
	..()
	examine(user)

/obj/item/photo/attackby(obj/item/P as obj, mob/user as mob)
	if(istype(P, /obj/item/tool/pen) || istype(P, /obj/item/toy/crayon))
		var/txt = strip_html(input(user, "What would you like to write on the back?", "Photo Writing", null)  as text)
		txt = copytext(txt, 1, 128)
		if(loc == user && user.stat == 0)
			scribble = txt
	..()

/obj/item/photo/get_examine_text(mob/user)
	if(in_range(user, src))
		show(user)
		return list(desc)
	else
		return  list(SPAN_NOTICE("It is too far away."))

/obj/item/photo/proc/show(mob/living/user)
	if(!isicon(img)) return // this should stop a runtime error
	user << browse_rsc(img, "tmp_photo.png")
	var/dat = "<html>" \
		+ "<body style='overflow:hidden;margin:0;text-align:center' class='paper'>" \
		+ "<img src='tmp_photo.png' width='[64*photo_size]' style='-ms-interpolation-mode:nearest-neighbor' />" \
		+ "[scribble ? "<br>Written on the back:<br><i>[scribble]</i>" : ""]"\
		+ "</body></html>"
	show_browser(user, dat, name, name, "size=[80*photo_size]x[(scribble ? 100 : 82)*photo_size]")
	onclose(user, name)
	return

/obj/item/photo/verb/rename()
	set name = "Rename photo"
	set category = "Object"
	set src in usr

	var/n_name = strip_html(input(usr, "What would you like to label the photo?", "Photo Labelling", null)  as text)
	//loc.loc check is for making possible renaming photos in clipboards
	if(( (loc == usr || (loc.loc && loc.loc == usr)) && usr.stat == 0))
		name = "[(n_name ? text("[n_name]") : "photo")]"
	add_fingerprint(usr)
	return


/*
* photo album *
**************/
/obj/item/storage/photo_album
	name = "Photo album"
	icon = 'icons/obj/items/items.dmi'
	icon_state = "album"
	item_state = "briefcase"
	can_hold = list(/obj/item/photo,)

/obj/item/storage/photo_album/MouseDrop(obj/over_object as obj)

	if((istype(usr, /mob/living/carbon/human)))
		var/mob/M = usr
		if(!( istype(over_object, /atom/movable/screen) ))
			return ..()
		playsound(loc, "rustle", 15, 1, 6)
		if((!( M.is_mob_restrained() ) && !( M.stat ) && M.back == src))
			switch(over_object.name)
				if("r_hand")
					M.drop_inv_item_on_ground(src)
					M.put_in_r_hand(src)
				if("l_hand")
					M.drop_inv_item_on_ground(src)
					M.put_in_l_hand(src)
			add_fingerprint(usr)
			return
		if(over_object == usr && in_range(src, usr) || usr.contents.Find(src))
			if(usr.s_active)
				usr.s_active.storage_close(usr)
			show_to(usr)
			return
	return

/*
* camera *
*********/
/obj/item/device/camera
	name = "camera"
	icon = 'icons/obj/items/items.dmi'
	desc = "A polaroid camera. 10 photos left."
	icon_state = "camera"
	item_state = "electropack"
	w_class = SIZE_SMALL
	flags_atom = FPRINT|CONDUCT
	flags_equip_slot = SLOT_WAIST
	matter = list("metal" = 2000)
	var/pictures_max = 10
	var/pictures_left = 10
	var/on = 1
	var/icon_on = "camera"
	var/icon_off = "camera_off"
	var/size = 3

/obj/item/device/camera/verb/change_size()
	set name = "Set Photo Focus"
	set src in usr
	set category = "Object"
	var/nsize = tgui_input_list(usr, "Photo Size","Pick a size of resulting photo.", list(1,3,5,7))
	if(nsize)
		size = nsize
		to_chat(usr, SPAN_NOTICE("Camera will now take [size]x[size] photos."))

/obj/item/device/camera/attack(mob/living/carbon/human/M, mob/user)
	return

/obj/item/device/camera/attack_self(mob/user)
	..()
	on = !on
	if(on)
		src.icon_state = icon_on
	else
		src.icon_state = icon_off
	to_chat(user, "You switch the camera [on ? "on" : "off"].")

/obj/item/device/camera/attackby(obj/item/I, mob/user)
	if(istype(I, /obj/item/device/camera_film))
		if(pictures_left)
			to_chat(user, SPAN_NOTICE("[src] still has some film in it!"))
			return
		to_chat(user, SPAN_NOTICE("You insert [I] into [src]."))
		if(user.temp_drop_inv_item(I))
			qdel(I)
			pictures_left = pictures_max
		return
	..()


/obj/item/device/camera/proc/get_icon(list/turfs, turf/center)

	//Bigger icon base to capture those icons that were shifted to the next tile
	//i.e. pretty much all wall-mounted machinery
	var/icon/res = icon('icons/effects/96x96.dmi', "")
	res.Scale(size*32, size*32)
	// Initialize the photograph to black.
	res.Blend("#000", ICON_OVERLAY)

	var/atoms[] = list()
	for(var/turf/the_turf in turfs)
		// Add outselves to the list of stuff to draw
		atoms.Add(the_turf);
		// As well as anything that isn't invisible.
		for(var/atom/A in the_turf)
			if(A.invisibility) continue
			atoms.Add(A)

	// Sort the atoms into their layers
	var/list/sorted = sort_atoms_by_layer(atoms)
	var/center_offset = (size-1)/2 * 32 + 1
	for(var/i; i <= sorted.len; i++)
		var/atom/A = sorted[i]
		if(A)
			var/icon/IM = getFlatIcon(A)//build_composite_icon(A)

			// If what we got back is actually a picture, draw it.
			if(istype(IM, /icon))
				// Check if we're looking at a mob that's lying down
				if(istype(A, /mob/living))
					var/mob/living/L = A
					if(!istype(L, /mob/living/carbon/Xenomorph)) //xenos don't use icon rotatin for lying.
						if(L.lying)
							// If they are, apply that effect to their picture.
							IM.BecomeLying()
				// Calculate where we are relative to the center of the photo
				var/xoff = (A.x - center.x) * 32 + center_offset
				var/yoff = (A.y - center.y) * 32 + center_offset
				if (istype(A,/atom/movable))
					xoff+=A:step_x
					yoff+=A:step_y
				res.Blend(IM, blendMode2iconMode(A.blend_mode),  A.pixel_x + xoff, A.pixel_y + yoff)

	// Lastly, render any contained effects on top.
	for(var/turf/the_turf as anything in turfs)
		// Calculate where we are relative to the center of the photo
		var/xoff = (the_turf.x - center.x) * 32 + center_offset
		var/yoff = (the_turf.y - center.y) * 32 + center_offset
		var/image/IM = getFlatIcon(the_turf.loc)
		if(IM)
			res.Blend(IM, blendMode2iconMode(the_turf.blend_mode),xoff,yoff)
	return res


/obj/item/device/camera/proc/get_mobs(turf/the_turf as turf)
	var/mob_detail
	for(var/mob/living/carbon/A in the_turf)
		if(A.invisibility) continue
		var/holding = null
		if(A.l_hand || A.r_hand)
			if(A.l_hand) holding = "They are holding \a [A.l_hand]"
			if(A.r_hand)
				if(holding)
					holding += " and \a [A.r_hand]"
				else
					holding = "They are holding \a [A.r_hand]"

		if(!mob_detail)
			mob_detail = "You can see [A] on the photo[A:health < 75 ? " - [A] looks hurt":""].[holding ? " [holding]":"."]. "
		else
			mob_detail += "You can also see [A] on the photo[A:health < 75 ? " - [A] looks hurt":""].[holding ? " [holding]":"."]."
	return mob_detail

/obj/item/device/camera/afterattack(atom/target as mob|obj|turf|area, mob/user as mob, flag)
	if(!on || !pictures_left || ismob(target.loc) || isstorage(target.loc)) return
	if(user.contains(target) || istype(target, /atom/movable/screen)) return
	captureimage(target, user, flag)

	playsound(loc, pick('sound/items/polaroid1.ogg', 'sound/items/polaroid2.ogg'), 15, 1)

	pictures_left--
	desc = "A polaroid camera. It has [pictures_left] photos left."
	to_chat(user, SPAN_NOTICE("[pictures_left] photos left."))
	icon_state = icon_off
	on = 0
	spawn(64)
		icon_state = icon_on
		on = 1

/obj/item/device/camera/proc/captureimage(atom/target, mob/user, flag)
	var/mobs = ""
	var/radius = (size-1)*0.5
	var/list/turf/turfs = RANGE_TURFS(radius, target) & view(world_view_size + radius, user.client)
	for(var/turf/T as anything in turfs)
		mobs += get_mobs(T)
	var/datum/picture/P = createpicture(target, user, turfs, mobs, flag)
	printpicture(user, P)

/obj/item/device/camera/proc/createpicture(atom/target, mob/user, list/turfs, mobs, flag)
	var/icon/photoimage = get_icon(turfs, target)

	var/icon/small_img = icon(photoimage)
	var/icon/tiny_img = icon(photoimage)
	var/icon/ic = icon('icons/obj/items/items.dmi',"photo")
	var/icon/pc = icon('icons/obj/items/paper.dmi', "photo")
	small_img.Scale(8, 8)
	tiny_img.Scale(4, 4)
	ic.Blend(small_img,ICON_OVERLAY, 10, 13)
	pc.Blend(tiny_img,ICON_OVERLAY, 12, 19)

	var/datum/picture/P = new()
	P.fields["author"] = user
	P.fields["icon"] = ic
	P.fields["tiny"] = pc
	P.fields["img"] = photoimage
	P.fields["desc"] = mobs
	P.fields["pixel_x"] = rand(-10, 10)
	P.fields["pixel_y"] = rand(-10, 10)
	P.fields["size"] = size

	return P

/obj/item/device/camera/proc/printpicture(mob/user, var/datum/picture/P)
	var/obj/item/photo/Photo = new/obj/item/photo()
	Photo.forceMove(user.loc)
	if(!user.get_inactive_hand())
		user.put_in_inactive_hand(Photo)
	Photo.construct(P)


/obj/item/device/camera/oldcamera
	name = "Old Camera"
	desc = "An old, slightly beat-up digital camera, with a cheap photo printer taped on. It's a nice shade of blue."
	icon_state = "oldcamera"
	icon_on = "oldcamera"
	icon_off = "oldcamera_off"
	pictures_left = 30


/obj/item/photo/proc/construct(var/datum/picture/P)
	icon = P.fields["icon"]
	tiny = P.fields["tiny"]
	img = P.fields["img"]
	desc = P.fields["desc"]
	pixel_x = P.fields["pixel_x"]
	pixel_y = P.fields["pixel_y"]
	photo_size = P.fields["size"]
