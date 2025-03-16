
#define CAMERA_PICTURE_SIZE_HARD_LIMIT 21
/*
* camera *
*********/
/obj/item/device/camera
	name = "camera"
	icon = 'icons/obj/items/paper.dmi'
	desc = "A polaroid camera."
	icon_state = "camera"
	item_state = "camera"
	item_icons = list(
		WEAR_WAIST = 'icons/mob/humans/onmob/clothing/belts/tools.dmi',
		WEAR_L_HAND = 'icons/mob/humans/onmob/inhands/equipment/paperwork_lefthand.dmi',
		WEAR_R_HAND = 'icons/mob/humans/onmob/inhands/equipment/paperwork_righthand.dmi'
	)
	flags_item = TWOHANDED
	w_class = SIZE_SMALL
	flags_atom = FPRINT|CONDUCT
	flags_equip_slot = SLOT_WAIST

	light_system = DIRECTIONAL_LIGHT
	light_range = 8
	light_color = COLOR_WHITE
	light_power = FLASH_LIGHT_POWER

	var/flash_enabled = TRUE
	var/state_on = "camera"
	var/state_off = "camera_off"
	var/pictures_max = 10
	var/pictures_left = 10
	var/on = TRUE
	var/cooldown = 64
	var/blending = FALSE //lets not take pictures while the previous is still processing!
	var/silent = FALSE
	var/picture_size_x = 2
	var/picture_size_y = 2
	var/picture_size_x_min = 1
	var/picture_size_y_min = 1
	var/picture_size_x_max = 4
	var/picture_size_y_max = 4
	var/can_customise = TRUE
	var/default_picture_name
	///Whether the camera should print pictures immediately when a picture is taken.
	var/print_picture_on_snap = TRUE

/obj/item/device/camera/Initialize(mapload)
	. = ..()
	set_light_on(FALSE)

/obj/item/device/camera/attack_self(mob/user) //wielding capabilities
	. = ..()
	if(flags_item & WIELDED)
		unwield(user)
		light_range = 4
	else
		wield(user)
		light_range = 8

/obj/item/device/camera/afterattack(atom/target as mob|obj|turf|area, mob/user as mob, flag)
	if(pictures_left <= 0)
		to_chat(user, SPAN_WARNING("There isn't enough film in the [src] to take a photo."))
		return
	if(ismob(target.loc) || isstorage(target.loc) || user.contains(target) || istype(target, /atom/movable/screen))
		return
	if(!can_target(target, user))
		return
	if(!photo_taken(target, user))
		return

/obj/item/device/camera/get_examine_text(mob/user)
	. = ..()
	. += "It has [pictures_left] photos left."
	. += SPAN_NOTICE("Alt-click to change its focusing, allowing you to set how big of an area it will capture.")

/obj/item/device/camera/dropped(mob/user)
	..()
	unwield(user)

/obj/item/device/camera/proc/adjust_zoom(mob/user)
	if(loc != user)
		to_chat(user, SPAN_WARNING("You must be holding the camera to continue!"))
		return FALSE
	var/desired_x = tgui_input_number(user, "How wide do you want the camera to shoot?", "Zoom", picture_size_x, picture_size_x_max, picture_size_x_min)
	if(!desired_x || QDELETED(user) || QDELETED(src) || user.is_mob_incapacitated(TRUE) || loc != user)
		return FALSE
	var/desired_y = tgui_input_number(user, "How high do you want the camera to shoot", "Zoom", picture_size_y, picture_size_y_max, picture_size_y_min)
	if(!desired_y || QDELETED(user) || QDELETED(src) || user.is_mob_incapacitated(TRUE) || loc != user)
		return FALSE
	picture_size_x = min(clamp(desired_x, picture_size_x_min, picture_size_x_max), CAMERA_PICTURE_SIZE_HARD_LIMIT)
	picture_size_y = min(clamp(desired_y, picture_size_y_min, picture_size_y_max), CAMERA_PICTURE_SIZE_HARD_LIMIT)
	return TRUE

/obj/item/device/camera/clicked(mob/user, list/mods)
	. = ..()
	if(mods["alt"] && (loc == user))
		adjust_zoom(user)

/obj/item/device/camera/attackby(obj/item/used_item, mob/user, params)
	if(istype(used_item, /obj/item/device/camera_film))
		if(pictures_left > (pictures_max - 10))
			to_chat(user, SPAN_NOTICE("[src] cannot fit more film in it!"))
			return
		to_chat(user, SPAN_NOTICE("You insert [used_item] into [src]."))
		if(user.temp_drop_inv_item(used_item))
			qdel(used_item)
			pictures_left += 10
		return
	..()

//user can be atom or mob
/obj/item/device/camera/proc/can_target(atom/target, mob/user)
	if(!on || blending || !pictures_left)
		return FALSE
	var/turf/target_turf = get_turf(target)
	if(!target_turf)
		return FALSE
	if(istype(user))
		if(user.client && !(get_turf(target) in hear(user.client.view, user)))
			return FALSE
		else if(!(get_turf(target) in hear(CONFIG_GET(string/default_view), user)))
			return FALSE
	else if(isliving(loc))
		if(!(get_turf(target) in view(world.view, loc)))
			return FALSE
	else //user is an atom or null
		if(!(get_turf(target) in view(world.view, user || src)))
			return FALSE
	return TRUE

/obj/item/device/camera/proc/photo_taken(atom/target, mob/user)

	on = FALSE
	addtimer(CALLBACK(src, PROC_REF(cooldown)), cooldown)

	icon_state = state_off

	INVOKE_ASYNC(src, PROC_REF(captureimage), target, user, picture_size_x - 1, picture_size_y - 1)
	return TRUE

/obj/item/device/camera/proc/cooldown()
	UNTIL(!blending)
	icon_state = state_on
	on = TRUE

/obj/item/device/camera/proc/captureimage(atom/target, mob/user, size_x = 1, size_y = 1)
	if(flash_enabled)
		set_light_on(TRUE)
		addtimer(CALLBACK(src, PROC_REF(flash_end)), FLASH_LIGHT_DURATION, TIMER_OVERRIDE|TIMER_UNIQUE)
	blending = TRUE
	var/turf/target_turf = get_turf(target)
	if(!isturf(target_turf))
		blending = FALSE
		return FALSE
	size_x = clamp(size_x, 0, CAMERA_PICTURE_SIZE_HARD_LIMIT)
	size_y = clamp(size_y, 0, CAMERA_PICTURE_SIZE_HARD_LIMIT)
	var/list/desc = list("This is a photo of an area of [size_x+1] meters by [size_y+1] meters.")
	var/list/mobs_spotted = list()
	var/list/dead_spotted = list()
	var/list/seen
	var/list/viewlist = user?.client ? getviewsize(user.client.view) : getviewsize(world.view)
	var/viewr = max(viewlist[1], viewlist[2]) + max(size_x, size_y)
	var/viewc = user?.client ? user.client.eye : target
	seen = hear(viewr, viewc)
	var/list/turfs = list()
	var/list/mobs = list()
	var/clone_area = SSmapping.request_turf_block_reservation(size_x * 2 + 1, size_y * 2 + 1, 1)

	var/width = size_x * 2 + 1
	var/height = size_y * 2 + 1
	for(var/turf/placeholder as anything in CORNER_BLOCK_OFFSET(target_turf, width, height, -size_x, -size_y))
		while(istype(placeholder, /turf/open_space)) //Multi-z photography
			placeholder = SSmapping.get_turf_below(placeholder)
			if(!placeholder)
				break

		if(placeholder && (placeholder in seen))
			turfs += placeholder
			for(var/mob/seen_mob in placeholder)
				mobs += seen_mob

	for(var/mob/mob as anything in mobs)
		mobs_spotted += mob
		if(mob.stat == DEAD)
			dead_spotted += mob
		desc += mob.get_photo_description(src)

	var/psize_x = (size_x * 2 + 1) * 32
	var/psize_y = (size_y * 2 + 1) * 32
	var/icon/get_icon = camera_get_icon(turfs, target_turf, psize_x, psize_y, clone_area, size_x, size_y, (size_x * 2 + 1), (size_y * 2 + 1))
	qdel(clone_area)
	get_icon.Blend("#000", ICON_UNDERLAY)

	var/datum/picture/picture = new("picture", desc.Join("<br>"), mobs_spotted, dead_spotted, get_icon, null, psize_x, psize_y)
	after_picture(user, picture)
	blending = FALSE
	return picture

/obj/item/device/camera/proc/after_picture(mob/user, datum/picture/picture)
	if(print_picture_on_snap)
		printpicture(user, picture)

	if(!silent)
		playsound(loc, pick('sound/items/polaroid1.ogg', 'sound/items/polaroid2.ogg'), 15, 1)

/obj/item/device/camera/proc/flash_end()
	set_light_on(FALSE)

/obj/item/device/camera/proc/printpicture(mob/user, datum/picture/picture) //Normal camera proc for creating photos
	pictures_left--
	var/obj/item/photo/new_photo = new(get_turf(src), picture)
	if(user)
		if(in_range(new_photo, user))
			to_chat(user, SPAN_NOTICE("[pictures_left] photos left."))

		if(can_customise)
			var/customise = user.is_holding(new_photo) && tgui_alert(user, "Do you want to customize the photo?", "Customization", list("Yes", "No"))
			if(customise == "Yes")
				var/name1 = user.is_holding(new_photo) && tgui_input_text(user, "Set a name for this photo, or leave blank.", "Name", max_length = 32)
				var/desc1 = user.is_holding(new_photo) && tgui_input_text(user, "Set a description to add to photo, or leave blank.", "Description", max_length = 128)
				var/caption = user.is_holding(new_photo) && tgui_input_text(user, "Set a caption for this photo, or leave blank.", "Caption", max_length = 256)
				if(name1)
					picture.picture_name = name1
				if(desc1)
					picture.picture_desc = "[desc1] - [picture.picture_desc]"
				if(caption)
					picture.caption = caption
			else if(default_picture_name)
				picture.picture_name = default_picture_name
	else if(isliving(loc))
		var/mob/living/holder = loc
		if(holder.put_in_hands(new_photo))
			to_chat(holder, SPAN_NOTICE("[pictures_left] photos left."))

	new_photo.set_picture(picture, TRUE, TRUE)

#undef CAMERA_PICTURE_SIZE_HARD_LIMIT
