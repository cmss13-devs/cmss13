/// An element for atoms that, when dragged and dropped onto a mob, opens a strip panel.
/datum/element/strippable
	element_flags = ELEMENT_BESPOKE | ELEMENT_DETACH
	id_arg_index = 2

	/// An assoc list of keys to /datum/strippable_item
	var/list/items

	/// A proc path that returns TRUE/FALSE if we should show the strip panel for this entity.
	/// If it does not exist, the strip menu will always show.
	/// Will be called with (mob/user).
	var/should_strip_proc_path

	/// An existing strip menus
	var/list/strip_menus

/datum/element/strippable/Attach(datum/target, list/items, should_strip_proc_path)
	. = ..()
	if (!isatom(target))
		return ELEMENT_INCOMPATIBLE

	RegisterSignal(target, COMSIG_ATOM_DROP_ON, PROC_REF(mouse_drop_onto))

	src.items = items
	src.should_strip_proc_path = should_strip_proc_path

/datum/element/strippable/Detach(datum/source, force)
	. = ..()

	UnregisterSignal(source, COMSIG_ATOM_DROP_ON)

	if (!isnull(strip_menus))
		QDEL_NULL(strip_menus[source])

/datum/element/strippable/proc/mouse_drop_onto(datum/source, atom/over, mob/user)
	SIGNAL_HANDLER
	if (user == source)
		return

	if (over == source)
		return

	var/mob/overmob = over
	if (!ishuman(overmob))
		return

	if (!overmob.Adjacent(source))
		return

	if (!overmob.client)
		return

	if (overmob.client != user)
		return

	if (!isnull(should_strip_proc_path) && !call(source, should_strip_proc_path)(overmob))
		return

	var/datum/strip_menu/strip_menu

	if (isnull(strip_menu))
		strip_menu = new(source, src)
		LAZYSET(strip_menus, source, strip_menu)

	INVOKE_ASYNC(strip_menu, PROC_REF(tgui_interact), overmob)

/// A representation of an item that can be stripped down
/datum/strippable_item
	/// The STRIPPABLE_ITEM_* key
	var/key

	/// Should we warn about dangerous clothing?
	var/warn_dangerous_clothing = TRUE

/// Gets the item from the given source.
/datum/strippable_item/proc/get_item(atom/source)

/// Tries to equip the item onto the given source.
/// Returns TRUE/FALSE depending on if it is allowed.
/// This should be used for checking if an item CAN be equipped.
/// It should not perform the equipping itself.
/datum/strippable_item/proc/try_equip(atom/source, obj/item/equipping, mob/user)
	if ((equipping.flags_item & ITEM_ABSTRACT))
		return FALSE
	if ((equipping.flags_item & NODROP))
		to_chat(user, SPAN_WARNING("You can't put [equipping] on [source], it's stuck to your hand!"))
		return FALSE
	if (ishuman(source))
		var/mob/living/carbon/human/sourcehuman = source
		if(HAS_TRAIT(sourcehuman, TRAIT_UNSTRIPPABLE) && !sourcehuman.is_mob_incapacitated())
			to_chat(src, SPAN_DANGER("[sourcehuman] is too strong to force [equipping] onto them!"))
			return
	return TRUE

/// Start the equipping process. This is the proc you should yield in.
/// Returns TRUE/FALSE depending on if it is allowed.
/datum/strippable_item/proc/start_equip(atom/source, obj/item/equipping, mob/user)
	source.visible_message(
		SPAN_NOTICE("[user] tries to put [equipping] on [source]."),
		SPAN_NOTICE("[user] tries to put [equipping] on you.")
	)

	if (ismob(source))
		var/mob/sourcemob = source
		sourcemob.attack_log += text("\[[time_stamp()]\] <font color='orange'>[key_name(sourcemob)] is having [equipping] put on them by [key_name(user)]</font>")
		user.attack_log += text("\[[time_stamp()]\] <font color='orange'>[key_name(user)] is putting [equipping] on [key_name(sourcemob)]</font>")

	return TRUE

/// The proc that places the item on the source. This should not yield.
/datum/strippable_item/proc/finish_equip(atom/source, obj/item/equipping, mob/user)
	SHOULD_NOT_SLEEP(TRUE)

/// Tries to unequip the item from the given source.
/// Returns TRUE/FALSE depending on if it is allowed.
/// This should be used for checking if it CAN be unequipped.
/// It should not perform the unequipping itself.
/datum/strippable_item/proc/try_unequip(atom/source, mob/user)
	SHOULD_NOT_SLEEP(TRUE)

	var/obj/item/item = get_item(source)
	if (isnull(item))
		return FALSE

	if (user.action_busy && !skillcheck(user, SKILL_POLICE, SKILL_POLICE_SKILLED))
		to_chat(user, SPAN_WARNING("You can't do this right now."))
		return FALSE

	if ((item.flags_inventory & CANTSTRIP) || ((item.flags_item & NODROP) && !(item.flags_item & FORCEDROP_CONDITIONAL)) || (item.flags_item & ITEM_ABSTRACT))
		return FALSE

	if (ishuman(source))
		var/mob/living/carbon/human/sourcehuman = source
		if(MODE_HAS_TOGGLEABLE_FLAG(MODE_NO_STRIPDRAG_ENEMY) && (sourcehuman.stat == DEAD || sourcehuman.health < HEALTH_THRESHOLD_CRIT) && !sourcehuman.get_target_lock(user.faction_group))
			to_chat(user, SPAN_WARNING("You can't strip items of a crit or dead member of another faction!"))
			return FALSE

		if(HAS_TRAIT(sourcehuman, TRAIT_UNSTRIPPABLE) && !sourcehuman.is_mob_incapacitated())
			to_chat(src, SPAN_DANGER("[sourcehuman] has an unbreakable grip on their equipment!"))
			return

	return TRUE

/// Start the unequipping process. This is the proc you should yield in.
/// Returns TRUE/FALSE depending on if it is allowed.
/datum/strippable_item/proc/start_unequip(atom/source, mob/user)
	var/obj/item/item = get_item(source)
	if (isnull(item))
		return FALSE

	source.visible_message(
		SPAN_WARNING("[user] tries to remove [source]'s [item]."),
		SPAN_DANGER("[user] tries to remove your [item].")
	)

	if (ismob(source))
		var/mob/sourcemob = source
		sourcemob.attack_log += text("\[[time_stamp()]\] <font color='orange'>[key_name(sourcemob)] is being stripped of [item] by [key_name(user)]</font>")
		user.attack_log += text("\[[time_stamp()]\] <font color='orange'>[key_name(user)] is stripping [key_name(sourcemob)] of [item]</font>")

	item.add_fingerprint(user)

	return TRUE

/// The proc that unequips the item from the source. This should not yield.
/datum/strippable_item/proc/finish_unequip(atom/source, mob/user)

/// Returns a STRIPPABLE_OBSCURING_* define to report on whether or not this is obscured.
/datum/strippable_item/proc/get_obscuring(atom/source)
	SHOULD_NOT_SLEEP(TRUE)
	return STRIPPABLE_OBSCURING_NONE

/// Returns the ID of this item's strippable action.
/// Return `null` if there is no alternate action.
/// Any return value of this must be in StripMenu.
/datum/strippable_item/proc/get_alternate_action(atom/source, mob/user)
	return null

/// Performs an alternative action on this strippable_item.
/// `has_alternate_action` needs to be TRUE.
/datum/strippable_item/proc/alternate_action(atom/source, mob/user)

/// Returns whether or not this item should show.
/datum/strippable_item/proc/should_show(atom/source, mob/user)
	return TRUE

/// A preset for equipping items onto mob slots
/datum/strippable_item/mob_item_slot
	/// The ITEM_SLOT_* to equip to.
	var/item_slot

/datum/strippable_item/proc/has_no_item_alt_action()
	return FALSE

/datum/strippable_item/mob_item_slot/get_item(atom/source)
	if (!ismob(source))
		return null

	var/mob/mob_source = source
	return mob_source.get_item_by_slot(key)

/datum/strippable_item/mob_item_slot/try_equip(atom/source, obj/item/equipping, mob/user)
	. = ..()
	if (!.)
		return

	if (!ismob(source))
		return FALSE
	if (user.action_busy)
		to_chat(user, SPAN_WARNING("You can't do this right now."))
		return FALSE
	if (!equipping.mob_can_equip(
		source,
		key
	))
		to_chat(user, SPAN_WARNING("\The [equipping] doesn't fit in that place!"))
		return FALSE
	if(equipping.flags_item & WIELDED)
		equipping.unwield(user)
	return TRUE

/datum/strippable_item/mob_item_slot/start_equip(atom/source, obj/item/equipping, mob/user)
	. = ..()
	if (!.)
		return

	if (!ismob(source))
		return FALSE

	var/time_to_strip = HUMAN_STRIP_DELAY
	var/mob/sourcemob = source

	if (ishuman(sourcemob) && ishuman(user))
		var/mob/living/carbon/human/sourcehuman = sourcemob
		var/mob/living/carbon/human/userhuman = user
		time_to_strip = userhuman.get_strip_delay(userhuman, sourcehuman)

	if (!do_after(user, time_to_strip, INTERRUPT_ALL, BUSY_ICON_FRIENDLY, source, INTERRUPT_MOVED, BUSY_ICON_FRIENDLY))
		return FALSE

	if (!equipping.mob_can_equip(
		sourcemob,
		key
	))
		return FALSE

	if (!user.temp_drop_inv_item(equipping))
		return FALSE

	return TRUE

/datum/strippable_item/mob_item_slot/finish_equip(atom/source, obj/item/equipping, mob/user)
	if (!ismob(source))
		return FALSE

	var/mob/sourcemob = source
	sourcemob.equip_to_slot_if_possible(equipping, key)

/datum/strippable_item/mob_item_slot/get_obscuring(atom/source)
	return FALSE

/datum/strippable_item/mob_item_slot/start_unequip(atom/source, mob/user)
	. = ..()
	if (!.)
		return

	return start_unequip_mob(get_item(source), source, user)

/datum/strippable_item/mob_item_slot/finish_unequip(atom/source, mob/user)
	var/obj/item/item = get_item(source)
	if (isnull(item))
		return FALSE

	if (!ismob(source))
		return FALSE

	return finish_unequip_mob(item, source, user)

/// A utility function for `/datum/strippable_item`s to start unequipping an item from a mob.
/datum/strippable_item/mob_item_slot/proc/start_unequip_mob(obj/item/item, mob/living/carbon/human/source, mob/living/carbon/human/user)
	var/time_to_strip = HUMAN_STRIP_DELAY

	if (istype(source) && istype(user))
		time_to_strip = user.get_strip_delay(user, source)

	if (!do_after(user, time_to_strip, INTERRUPT_ALL, BUSY_ICON_HOSTILE, source, INTERRUPT_MOVED, BUSY_ICON_HOSTILE))
		return FALSE

	return TRUE

/// A utility function for `/datum/strippable_item`s to finish unequipping an item from a mob.
/datum/strippable_item/mob_item_slot/proc/finish_unequip_mob(obj/item/item, mob/source, mob/user)
	if (!source.drop_inv_item_on_ground(item, force = (item.flags_item & FORCEDROP_CONDITIONAL))) //force if we can drop the item in this case
		return FALSE

	if (ismob(source))
		var/mob/sourcemob = source
		sourcemob.attack_log += text("\[[time_stamp()]\] <font color='orange'>[key_name(sourcemob)] has been stripped of [item] by [key_name(user)]</font>")
		user.attack_log += text("\[[time_stamp()]\] <font color='orange'>[key_name(user)] has been stripped of [key_name(sourcemob)] of [item]</font>")

	// Updates speed in case stripped speed affecting item
	source.recalculate_move_delay = TRUE

/// A representation of the stripping UI
/datum/strip_menu
	/// The owner who has the element /datum/element/strippable
	var/atom/movable/owner

	/// The strippable element itself
	var/datum/element/strippable/strippable

	/// A lazy list of user mobs to a list of strip menu keys that they're interacting with
	var/list/interactions

/datum/strip_menu/New(atom/movable/owner, datum/element/strippable/strippable)
	. = ..()
	src.owner = owner
	src.strippable = strippable

/datum/strip_menu/Destroy()
	owner = null
	strippable = null

	return ..()

/datum/strip_menu/tgui_interact(mob/user, datum/tgui/ui)
	. = ..()
	ui = SStgui.try_update_ui(user, src, ui)
	if (!ui)
		ui = new(user, src, "StripMenu")
		ui.open()


/datum/strip_menu/ui_assets(mob/user)
	return list(
		get_asset_datum(/datum/asset/simple/inventory),
	)

/datum/strip_menu/ui_data(mob/user)
	var/list/data = list()

	var/list/items = list()

	for (var/strippable_key in strippable.items)
		var/datum/strippable_item/item_data = strippable.items[strippable_key]

		if (!item_data.should_show(owner, user))
			continue

		var/list/result

		if(strippable_key in LAZYACCESS(interactions, user))
			LAZYSET(result, "interacting", TRUE)

		var/obscuring = item_data.get_obscuring(owner)
		if (obscuring != STRIPPABLE_OBSCURING_NONE)
			LAZYSET(result, "obscured", obscuring)
			items[strippable_key] = result
			continue

		var/obj/item/item = item_data.get_item(owner)
		if (isnull(item))
			if (item_data.has_no_item_alt_action())
				LAZYINITLIST(result)
				result["no_item_action"] = item_data.get_alternate_action(owner, user)
			items[strippable_key] = result
			continue

		LAZYINITLIST(result)

		result["icon"] = icon2base64(icon(item.icon, item.icon_state, frame = 1))
		result["name"] = item.name
		result["alternate"] = item_data.get_alternate_action(owner, user)

		items[strippable_key] = result

	data["items"] = items

	// While most `\the`s are implicit, this one is not.
	// In this case, `\The` would otherwise be used.
	// This doesn't match with what it's used for, which is to say "Stripping the alien drone",
	// as opposed to "Stripping The alien drone".
	// Human names will still show without "the", as they are proper nouns.
	data["name"] = "\the [owner]"

	return data

/datum/strip_menu/ui_act(action, list/params, datum/tgui/ui, datum/ui_state/state)
	. = ..()
	if (.)
		return

	. = TRUE

	var/mob/user = ui.user

	switch (action)
		if ("equip")
			var/key = params["key"]
			var/datum/strippable_item/strippable_item = strippable.items[key]

			if (isnull(strippable_item))
				return

			if (!strippable_item.should_show(owner, user))
				return

			if (strippable_item.get_obscuring(owner) == STRIPPABLE_OBSCURING_COMPLETELY)
				return

			var/item = strippable_item.get_item(owner)
			if (!isnull(item))
				return

			var/obj/item/held_item = user.get_held_item()
			if (isnull(held_item))
				return

			if (!strippable_item.try_equip(owner, held_item, user))
				return

			LAZYORASSOCLIST(interactions, user, key)

			// Yielding call
			var/should_finish = strippable_item.start_equip(owner, held_item, user)

			LAZYREMOVEASSOC(interactions, user, key)

			if (!should_finish)
				return

			if (QDELETED(src) || QDELETED(owner))
				return

			// They equipped an item in the meantime
			if (!isnull(strippable_item.get_item(owner)))
				return

			if (!user.Adjacent(owner))
				return

			strippable_item.finish_equip(owner, held_item, user)
		if ("strip")
			var/key = params["key"]
			var/datum/strippable_item/strippable_item = strippable.items[key]

			if (isnull(strippable_item))
				return

			if (!strippable_item.should_show(owner, user))
				return

			if (strippable_item.get_obscuring(owner) == STRIPPABLE_OBSCURING_COMPLETELY)
				return

			var/item = strippable_item.get_item(owner)
			if (isnull(item))
				return

			if (!strippable_item.try_unequip(owner, user))
				return

			LAZYORASSOCLIST(interactions, user, key)

			var/should_unequip = strippable_item.start_unequip(owner, user)

			LAZYREMOVEASSOC(interactions, user, key)

			// Yielding call
			if (!should_unequip)
				return

			if (QDELETED(src) || QDELETED(owner))
				return

			// They changed the item in the meantime
			if (strippable_item.get_item(owner) != item)
				return

			if (!user.Adjacent(owner))
				return

			strippable_item.finish_unequip(owner, user)
		if ("alt")
			var/key = params["key"]
			var/datum/strippable_item/strippable_item = strippable.items[key]

			if (isnull(strippable_item))
				return

			if (!strippable_item.should_show(owner, user))
				return

			if (strippable_item.get_obscuring(owner) == STRIPPABLE_OBSCURING_COMPLETELY)
				return

			var/item = strippable_item.get_item(owner)
			if (isnull(item) && !strippable_item.has_no_item_alt_action())
				return

			if (isnull(strippable_item.get_alternate_action(owner, user)))
				return

			LAZYORASSOCLIST(interactions, user, key)

			// Potentially yielding
			strippable_item.alternate_action(owner, user)

			LAZYREMOVEASSOC(interactions, user, key)

/datum/strip_menu/ui_host(mob/user)
	return owner

/datum/strip_menu/ui_status(mob/user, datum/ui_state/state)
	. = ..()

	if (isliving(user))
		var/mob/living/living_user = user

		if (
			. == UI_UPDATE \
			&& user.stat == CONSCIOUS \
			&& living_user.body_position == LYING_DOWN \
			&& user.Adjacent(owner)
		)
			return UI_INTERACTIVE

/// Creates an assoc list of keys to /datum/strippable_item
/proc/create_strippable_list(types)
	var/list/strippable_items = list()

	for (var/strippable_type in types)
		var/datum/strippable_item/strippable_item = new strippable_type
		strippable_items[strippable_item.key] = strippable_item

	return strippable_items
