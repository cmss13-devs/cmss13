/// Patches of pumpkins spawned at roundstart from where marines can get their carvable pumpkins
/obj/structure/pumpkin_patch
	icon = 'icons/misc/events/pumpkins.dmi'
	name = "patch of pumpkins"
	var/empty_name = "\proper vines"

	can_block_movement = FALSE
	unslashable = TRUE
	health = 400 // To avoid explosions and stray gunfire destroying them too easily
	layer = LOWER_ITEM_LAYER

	var/has_vines = TRUE //! Whether there's still vines to display or not
	var/pumpkin_count = 3 //! Amount of pumpkins currently in the patch
	var/icon_prefix //! Prefix to prepend to icon states, for corrupted pumpkins
	var/pumpkin_type = /obj/item/clothing/head/pumpkin

/obj/structure/pumpkin_patch/Initialize(mapload, ...)
	. = ..()
	update_icon()

/obj/structure/pumpkin_patch/update_icon()
	overlays?.Cut()
	. = ..()
	switch(pumpkin_count)
		if(3)
			icon_state = "[icon_prefix]pumpkins_full"
		if(2)
			icon_state = "[icon_prefix]pumpkins_half"
		if(1)
			icon_state = "[icon_prefix]pumpkin"
		else  icon_state = "empty"
	if(has_vines)
		overlays += image(icon, loc, "[icon_prefix]vines")

/obj/structure/pumpkin_patch/attack_hand(mob/user)
	if(pumpkin_count < 1)
		to_chat(user, SPAN_WARNING("No more pumpkins here..."))
		return
	if(!user.get_active_hand()) //if active hand is empty
		pumpkin_count--
		var/obj/item/clothing/head/pumpkin/pumpkin = new pumpkin_type(loc)
		user.put_in_hands(pumpkin)
		playsound(loc, 'sound/effects/vegetation_hit.ogg', 25, 1)
		update_icon()
		if(pumpkin_count < 1)
			if(!has_vines)
				qdel(src)
			else
				name = empty_name
		return
	return ..()

/obj/structure/pumpkin_patch/attackby(obj/item/tool, mob/user)
	if(has_vines && (tool.sharp == IS_SHARP_ITEM_ACCURATE || tool.sharp == IS_SHARP_ITEM_BIG))
		to_chat(user, SPAN_NOTICE("You cut down the vines."))
		playsound(loc, "alien_resin_break", 25)
		has_vines = FALSE
		update_icon()
		if(pumpkin_count < 1 && !has_vines)
			qdel(src)
		return
	return ..()

/obj/structure/pumpkin_patch/corrupted
	icon_prefix = "cor_"
	name = "patch of corrupted pumpkins"
	empty_name = "\proper corrupted vines"
	pumpkin_type = /obj/item/clothing/head/pumpkin/corrupted
