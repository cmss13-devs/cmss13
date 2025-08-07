//-------------------------------------------------------
//HEAVY WEAPONS

/obj/item/weapon/gun/launcher
	gun_category = GUN_CATEGORY_HEAVY
	has_empty_icon = FALSE
	has_open_icon = FALSE
	mouse_pointer = 'icons/effects/mouse_pointer/explosive_mouse.dmi'

	///gun update_icon doesn't detect that guns with no magazine are loaded or not, and will always append _o or _e if possible.
	var/GL_has_empty_icon = TRUE
	///gun update_icon doesn't detect that guns with no magazine are loaded or not, and will always append _o or _e if possible.
	var/GL_has_open_icon = FALSE

	///Internal storage item used as magazine. Must be initialised to work! Set parameters by variables or it will inherit standard numbers from storage.dm. Got to call it *something* and 'magazine' or w/e would be confusing.
	var/obj/item/storage/internal/cylinder
	/// Variable that initializes the above.
	var/has_cylinder = FALSE
	///What single item to fill the storage with, if any. This does not respect w_class.
	var/preload
	///How many items can be inserted. "Null" = backpack-style size-based inventory. You'll have to set max_storage_space too if you do that, and arrange any initial contents. Iff you arrange to put in more items than the storage can hold, they can be taken out but not replaced.
	var/internal_slots
	///how big an item can be inserted.
	var/internal_max_w_class
	///the sfx played when the storage is opened.
	var/use_sound = null
	///Whether clicking a held weapon with an empty hand will open its inventory or draw a munition out.
	var/direct_draw = TRUE
	var/can_be_reloaded = TRUE

/obj/item/weapon/gun/launcher/Initialize(mapload, spawn_empty) //If changing vars on init, be sure to do the parent proccall *after* the change.
	. = ..()
	if(has_cylinder)
		cylinder = new /obj/item/storage/internal(src)
		cylinder.storage_slots = internal_slots
		cylinder.max_w_class = internal_max_w_class
		cylinder.use_sound = use_sound
		if(direct_draw)
			cylinder.storage_flags ^= STORAGE_USING_DRAWING_METHOD
		if(preload && !spawn_empty)
			for(var/i = 1 to cylinder.storage_slots)
			new preload(cylinder)
		update_icon()

/obj/item/weapon/gun/launcher/Destroy(force)
	QDEL_NULL(cylinder)
	return ..()

/obj/item/weapon/gun/launcher/verb/toggle_draw_mode()
	set name = "Switch Storage Drawing Method"
	set category = "Object"
	set src in usr

	cylinder.storage_draw_logic(src.name)
