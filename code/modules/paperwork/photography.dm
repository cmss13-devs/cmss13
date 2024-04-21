/* Photography!
 * Contains:
 * Camera
 * Camera Film
 * Photos
 * Photo Albums
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

/** Picture metadata */
/datum/picture
	var/name = "image"
	var/list/fields = list()

/*
* photo *
********/
/obj/item/photo
	name = "photo"
	icon = 'icons/obj/items/items.dmi'
	icon_state = "photo"
	item_state = "paper"
	w_class = SIZE_TINY
	var/icon/img //Big photo image
	var/scribble //Scribble on the back.
	var/icon/tiny
	var/photo_size = 3

/obj/item/photo/attack_self(mob/user)
	..()
	examine(user)

/obj/item/photo/attackby(obj/item/P as obj, mob/user as mob)
	if(HAS_TRAIT(P, TRAIT_TOOL_PEN) || istype(P, /obj/item/toy/crayon))
		var/txt = strip_html(input(user, "What would you like to write on the back?", "Photo Writing", null)  as text)
		txt = copytext(txt, 1, 128)
		if(loc == user && user.stat == 0)
			scribble = txt
			playsound(src, "paper_writing", 15, TRUE)
	..()

/obj/item/photo/get_examine_text(mob/user)
	if(in_range(user, src) || isobserver(user))
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
	storage_slots = 28

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
	desc = "A polaroid camera."
	icon_state = "camera"
	item_state = "camera"
	item_icons = list(
		WEAR_L_HAND = 'icons/mob/humans/onmob/items_lefthand_0.dmi',
		WEAR_R_HAND = 'icons/mob/humans/onmob/items_righthand_0.dmi'
		)
	flags_item = TWOHANDED
	w_class = SIZE_SMALL
	flags_atom = FPRINT|CONDUCT
	flags_equip_slot = SLOT_WAIST
	matter = list("metal" = 2000)
	black_market_value = 20
	var/pictures_max = 10
	var/pictures_left = 10
	var/size = 7

/obj/item/device/camera/get_examine_text(mob/user)
	. = ..()
	. += "It has [pictures_left] photos left."

/obj/item/device/camera/attack_self(mob/user) //wielding capabilities
	. = ..()
	if(flags_item & WIELDED)
		unwield(user)
	else
		wield(user)

/obj/item/device/camera/dropped(mob/user)
	..()
	unwield(user)

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

/obj/item/device/camera/attackby(obj/item/I, mob/user)
	if(istype(I, /obj/item/device/camera_film))
		if(pictures_left > (pictures_max - 10))
			to_chat(user, SPAN_NOTICE("[src] cannot fit more film in it!"))
			return
		to_chat(user, SPAN_NOTICE("You insert [I] into [src]."))
		if(user.temp_drop_inv_item(I))
			qdel(I)
			pictures_left += 10
		return
	..()


/obj/item/device/camera/proc/get_icon(list/turfs, turf/center)

	//Bigger icon base to capture those icons that were shifted to the next tile
	//i.e. pretty much all wall-mounted machinery
	var/icon/res = icon('icons/effects/96x96.dmi', "")
	res.Scale(size*32, size*32)
	// Initialize the photograph to black.
	res.Blend("#000", ICON_OVERLAY)
	CHECK_TICK

	var/pixel_size = world.icon_size
	var/radius = (size - 1) * 0.5
	var/center_offset = radius * pixel_size + 1
	var/x_min = center.x - radius
	var/x_max = center.x + radius
	var/y_min = center.y - radius
	var/y_max = center.y + radius

	var/list/atoms = list()
	for(var/turf/the_turf as anything in turfs)
		// Add ourselves to the list of stuff to draw
		atoms.Add(the_turf);

		// As well as anything that isn't invisible.
		for(var/atom/cur_atom as anything in the_turf)
			if(!cur_atom || cur_atom.invisibility)
				continue
			atoms.Add(cur_atom)

	// Sort the atoms into their layers
	var/list/sorted = sort_atoms_by_layer(atoms)
	for(var/atom/cur_atom as anything in sorted)
		if(QDELETED(cur_atom))
			continue

		if(cur_atom.x < x_min || cur_atom.x > x_max || cur_atom.y < y_min || cur_atom.y > y_max)
			// they managed to move out of frame with all this CHECK_TICK...
			continue

		var/icon/cur_icon = getFlatIcon(cur_atom)//build_composite_icon(cur_atom)

		// If what we got back is actually a picture, draw it.
		if(istype(cur_icon, /icon))
			// Check if we're looking at a mob that's lying down
			if(istype(cur_atom, /mob/living))
				var/mob/living/cur_mob = cur_atom
				if(!isxeno(cur_mob) && cur_mob.body_position == LYING_DOWN) //xenos don't use icon rotatin for lying.
					cur_icon.BecomeLying()

			// Calculate where we are relative to the center of the photo
			var/xoff = (cur_atom.x - center.x) * pixel_size + center_offset
			var/yoff = (cur_atom.y - center.y) * pixel_size + center_offset
			if(istype(cur_atom, /atom/movable))
				xoff += cur_atom:step_x
				yoff += cur_atom:step_y
			res.Blend(cur_icon, blendMode2iconMode(cur_atom.blend_mode),  cur_atom.pixel_x + xoff, cur_atom.pixel_y + yoff)

		CHECK_TICK

	// Lastly, render any contained effects on top.
	for(var/turf/the_turf as anything in turfs)
		// Calculate where we are relative to the center of the photo
		var/xoff = (the_turf.x - center.x) * pixel_size + center_offset
		var/yoff = (the_turf.y - center.y) * pixel_size + center_offset
		var/image/cur_icon = getFlatIcon(the_turf.loc)
		CHECK_TICK

		if(cur_icon)
			res.Blend(cur_icon, blendMode2iconMode(the_turf.blend_mode), xoff, yoff)
			CHECK_TICK
	return res

/obj/item/device/camera/proc/get_mob_descriptions(turf/the_turf, existing_descripion)
	var/mob_detail = existing_descripion
	for(var/mob/living/carbon/cur_carbon in the_turf)
		if(cur_carbon.invisibility)
			continue

		var/holding = null
		if(cur_carbon.l_hand || cur_carbon.r_hand)
			if(cur_carbon.l_hand)
				holding = "They are holding \a [cur_carbon.l_hand]"
			if(cur_carbon.r_hand)
				if(holding)
					holding += " and \a [cur_carbon.r_hand]"
				else
					holding = "They are holding \a [cur_carbon.r_hand]"

		var/hurt = ""
		if(cur_carbon.health < 75)
			hurt = prob(25) ? " - they look hurt" : " - [cur_carbon] looks hurt"

		if(!mob_detail)
			mob_detail = "You can see [cur_carbon] in the photo[hurt].[holding ? " [holding]" : "."]."
		else
			mob_detail += " You [prob(50) ? "can" : "also"] see [cur_carbon] in the photo[hurt].[holding ? " [holding]" : "."]."
	return mob_detail

/obj/item/device/camera/afterattack(atom/target as mob|obj|turf|area, mob/user as mob, flag)
	if(pictures_left <= 0)
		to_chat(user, SPAN_WARNING("There isn't enough film in the [src] to take a photo."))
		return
	if(ismob(target.loc) || isstorage(target.loc) || user.contains(target) || istype(target, /atom/movable/screen))
		return
	if(!(flags_item & WIELDED))
		to_chat(user, SPAN_WARNING("You need to wield the [src] with both hands to take a photo!"))
		return
	playsound(loc, pick('sound/items/polaroid1.ogg', 'sound/items/polaroid2.ogg'), 15, 1)
	pictures_left--
	to_chat(user, SPAN_NOTICE("[pictures_left] photos left."))

	addtimer(CALLBACK(src, PROC_REF(captureimage), target, user, flag), 1 SECONDS)

/obj/item/device/camera/proc/captureimage(atom/target, mob/user, flag)
	var/mob_descriptions = ""
	var/radius = (size-1)*0.5
	var/list/turf/turfs = RANGE_TURFS(radius, target) & view(GLOB.world_view_size + radius, user.client)
	for(var/turf/the_turf as anything in turfs)
		mob_descriptions = get_mob_descriptions(the_turf, mob_descriptions)
	var/datum/picture/the_picture = createpicture(target, user, turfs, mob_descriptions, flag)

	if(QDELETED(user))
		return

	printpicture(user, the_picture)

/obj/item/device/camera/proc/createpicture(atom/target, mob/user, list/turfs, description, flag)
	var/icon/photoimage = get_icon(turfs, target)

	if(!description)
		description = "A very scenic photo"

	var/icon/small_img = icon(photoimage)
	var/icon/tiny_img = icon(photoimage)
	var/icon/item_icon = icon('icons/obj/items/items.dmi',"photo")
	var/icon/paper_icon = icon('icons/obj/items/paper.dmi', "photo")
	small_img.Scale(8, 8)
	tiny_img.Scale(4, 4)
	item_icon.Blend(small_img, ICON_OVERLAY, 10, 13)
	CHECK_TICK
	paper_icon.Blend(tiny_img, ICON_OVERLAY, 12, 19)
	CHECK_TICK

	var/datum/picture/the_picture = new()
	the_picture.fields["author"] = user
	the_picture.fields["icon"] = item_icon
	the_picture.fields["tiny"] = paper_icon
	the_picture.fields["img"] = photoimage
	the_picture.fields["desc"] = description
	the_picture.fields["pixel_x"] = rand(-10, 10)
	the_picture.fields["pixel_y"] = rand(-10, 10)
	the_picture.fields["size"] = size

	return the_picture

/obj/item/device/camera/proc/printpicture(mob/user, datum/picture/P)
	var/obj/item/photo/Photo = new/obj/item/photo()
	Photo.forceMove(user.loc)
	if(!user.get_inactive_hand())
		user.put_in_inactive_hand(Photo)
	Photo.construct(P)


/obj/item/device/camera/oldcamera
	name = "Old Camera"
	desc = "An old, slightly beat-up digital camera, with a cheap photo printer taped on. It's a nice shade of blue."
	icon_state = "oldcamera"
	pictures_left = 30

/obj/item/device/camera/broadcasting
	name = "Broadcasting Camera"
	desc = "Actively document everything you see, from the mundanity of shipside to the brutal battlefields below. Has a built-in printer for action shots."
	icon_state = "broadcastingcamera"
	item_state = "broadcastingcamera"
	pictures_left = 20
	pictures_max = 20
	w_class = SIZE_HUGE
	flags_equip_slot = NO_FLAGS //cannot be equiped
	var/obj/structure/machinery/camera/correspondent/linked_cam

/obj/item/device/camera/broadcasting/Initialize(mapload, ...)
	. = ..()
	linked_cam = new(loc, src)
	linked_cam.status = FALSE
	RegisterSignal(src, COMSIG_COMPONENT_ADDED, PROC_REF(handle_rename))

/obj/item/device/camera/broadcasting/Destroy()
	clear_broadcast()
	return ..()

/obj/item/device/camera/broadcasting/wield(mob/user)
	. = ..()
	if(!.)
		return
	flags_atom |= (USES_HEARING|USES_SEEING)
	if(!linked_cam || QDELETED(linked_cam))
		linked_cam = new(loc, src)
	else
		linked_cam.status = TRUE
		linked_cam.forceMove(loc)
	SEND_SIGNAL(src, COMSIG_BROADCAST_GO_LIVE)
	to_chat(user, SPAN_NOTICE("[src] begins to buzz softly as you go live."))

/obj/item/device/camera/broadcasting/unwield(mob/user)
	. = ..()
	flags_atom &= ~(USES_HEARING|USES_SEEING)
	linked_cam.status = FALSE

/obj/item/device/camera/broadcasting/proc/handle_rename(obj/item/camera, datum/component/label)
	SIGNAL_HANDLER
	if(!istype(label, /datum/component/label))
		return
	linked_cam.c_tag = get_broadcast_name()

/obj/item/device/camera/broadcasting/proc/clear_broadcast()
	if(!QDELETED(linked_cam))
		QDEL_NULL(linked_cam)

/obj/item/device/camera/broadcasting/proc/get_broadcast_name()
	var/datum/component/label/src_label_component = GetComponent(/datum/component/label)
	if(src_label_component)
		return src_label_component.label_name
	return "Broadcast [serial_number]"

/obj/item/device/camera/broadcasting/hear_talk(mob/living/sourcemob, message, verb = "says", datum/language/language, italics = FALSE)
	SEND_SIGNAL(src, COMSIG_BROADCAST_HEAR_TALK, sourcemob, message, verb, language, italics, get_dist(sourcemob, src) < 3)

/obj/item/device/camera/broadcasting/see_emote(mob/living/sourcemob, emote, audible = FALSE)
	SEND_SIGNAL(src, COMSIG_BROADCAST_SEE_EMOTE, sourcemob, emote, audible, get_dist(sourcemob, src) < 3 && audible)

/obj/item/photo/proc/construct(datum/picture/P)
	icon = P.fields["icon"]
	tiny = P.fields["tiny"]
	img = P.fields["img"]
	desc = P.fields["desc"]
	pixel_x = P.fields["pixel_x"]
	pixel_y = P.fields["pixel_y"]
	photo_size = P.fields["size"]
