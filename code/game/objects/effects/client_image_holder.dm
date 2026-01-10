/**
 * Simple effect that holds an image
 * to be shown to one or multiple clients only.
 *
 * Pass a list of mobs in initialize() that corresponds to all mobs that can see it.
 * Code ripped from tgstation, though this has missing parts. Original path is 'code/modules/hallucination/_hallucination.dm'
 */

/obj/effect/client_image_holder
	invisibility = INVISIBILITY_OBSERVER
	anchored = TRUE

	/// A list of mobs which can see us.
	var/list/mob/who_sees_us
	/// The created image, what we look like.
	var/image/shown_image
	/// The icon file the image uses. If null, we have no image
	var/image_icon
	/// The icon state the image uses
	var/image_state
	/// The x pixel offset of the image
	var/image_pixel_x = 0
	/// The y pixel offset of the image
	var/image_pixel_y = 0
	/// Optional, the color of the image
	var/image_color
	/// The layer of the image
	var/image_layer = MOB_LAYER
	/// The plane of the image
	var/image_plane = GAME_PLANE

/obj/effect/client_image_holder/Initialize(mapload, list/mobs_which_see_us)
	if(isnull(mobs_which_see_us))
		return INITIALIZE_HINT_QDEL

	. = ..()
	shown_image = generate_image()

	if(!islist(mobs_which_see_us))
		mobs_which_see_us = list(mobs_which_see_us)

	who_sees_us = list()
	for(var/mob/seer as anything in mobs_which_see_us)
		who_sees_us += seer
		show_image_to(seer)

/obj/effect/client_image_holder/Destroy(force)
	if(shown_image)
		for(var/mob/seer as anything in who_sees_us)
			hide_image_from(seer)
			who_sees_us -= seer
		shown_image = null

	QDEL_NULL_LIST(who_sees_us)
	return ..()

/// Generates the image which we take on.
/obj/effect/client_image_holder/proc/generate_image()
	var/image/created = image(image_icon, src, image_state, image_layer, dir = src.dir)
	created.pixel_x = image_pixel_x
	created.pixel_y = image_pixel_y
	if(image_color)
		created.color = image_color
	return created

/// Shows the image we generated to the passed mob
/obj/effect/client_image_holder/proc/show_image_to(mob/show_to)
	SIGNAL_HANDLER

	show_to.client?.images |= shown_image

/// Hides the image we generated from the passed mob
/obj/effect/client_image_holder/proc/hide_image_from(mob/hide_from)
	SIGNAL_HANDLER

	hide_from.client?.images -= shown_image

/// Simple helper for refreshing / showing the image to everyone in our list.
/obj/effect/client_image_holder/proc/regenerate_image()
	for(var/mob/seer as anything in who_sees_us)
		hide_image_from(seer)

	shown_image = generate_image()

	for(var/mob/seer as anything in who_sees_us)
		show_image_to(seer)

// Whenever we perform icon updates, regenerate our image
/obj/effect/client_image_holder/update_icon(updates = ALL)
	. = ..()
	regenerate_image()

// If we move for some reason, regenerate our image
/obj/effect/client_image_holder/Moved(atom/old_loc, movement_dir, forced, list/old_locs, momentum_change = TRUE)
	. = ..()
	if(!loc)
		return
	regenerate_image()

