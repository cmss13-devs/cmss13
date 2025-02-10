/*
ERROR CODES AND WHAT THEY MEAN:


ERROR CODE A1: null ammo while reloading. <------------ Only appears when initialising or reloading a weapon and switching the ammo. Somehow the argument passed a null ammo.
ERROR CODE A2: null caliber while reloading. <------------ Only appears when initialising or reloading a weapon and switching the calibre. Somehow the argument passed a null caliber.
ERROR CODE I1: projectile malfunctioned while firing. <------------ Right before the bullet is fired, the actual bullet isn't present or isn't a bullet.
ERROR CODE I2: null ammo while load_into_chamber() <------------- Somehow the ammo datum is missing or something. We need to figure out how that happened.
ERROR CODE R1: negative current_rounds on examine. <------------ Applies to ammunition only. Ammunition should never have negative rounds after spawn.

DEFINES in setup.dm, referenced here.
#define GUN_CAN_POINTBLANK 1
#define GUN_TRIGGER_SAFETY 2
#define GUN_UNUSUAL_DESIGN 4
#define GUN_SILENCED 8
#define GUN_AUTOMATIC 16
#define GUN_INTERNAL_MAG 32
#define GUN_AUTO_EJECTOR 64
#define GUN_AMMO_COUNTER 128
#define GUN_BURST_ON 256
#define GUN_BURST_FIRING 512
#define GUN_FLASHLIGHT_ON 1024
#define GUN_WY_RESTRICTED 2048
#define GUN_SPECIALIST 4096

	NOTES

	if(burst_toggled && burst_firing)
		return
	^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
	That should be on for most procs that deal with the gun doing some action. We do not want
	the gun to suddenly begin to fire when you're doing something else to it that could mess it up.
	As a general safety, make sure you remember this.


	Guns, on the front end, function off a three tier process. To successfully create some unique gun
	that has a special method of firing, you need to override these procs.

	New() //You can typically leave this one alone unless you need for the gun to do something on spawn.
	Guns that use the regular system of chamber fire should load_into_chamber() on New().

	reload() //If the gun doesn't use the normal methods of reloading, like revolvers or shotguns which use
	handfuls, you will need to specify just how it reloads. User can be passed as null.

	unload() //Same deal. If it's some unique unload method, you need to put that here. User can be passed as null.

	able_to_fire() //Unless the gun has some special check to see whether or not it may fire, you don't need this.
	You can see examples of how this is modified in smartgun/sadar code, along with others. Return ..() on a success.

	load_into_chamber() //This can get complicated, but if the gun doesn't take attachments that fire bullets from
	the Fire() process, just set them to null and leave the if(current_mag && current_mag.current_rounds > 0) check.
	The idea here is that if the gun can find a valid bullet to fire, subtract the ammo.
	This must return positive to continue the fire cycle.

	ready_in_chamber() //If the load_into_chamber is identical to the base outside of the actual bullet getting loaded,
	then you can use this in order to save on overrides. This primarily goes for anything that uses attachments like
	any standard firing cycle (attachables that fire through the firing cycle).

	reload_into_chamber() //The is the back action of the fire cycle that tells the gun to do all the stuff it needs
	to in order to prepare for the next fire cycle. This will be called if the gun fired successfully, per bullet.
	This is also where the gun will make a casing. So if your gun doesn't handle casings the regular way, modify it.
	Also where the gun will do final attachment calculations if the gun fired an attachment bullet.
	This must return positive to continue burst firing or so that you don't hear *click*.

	delete_bullet() //Important for point blanking and and jams, but can be called on for other reasons (that are
	not currently used). If the gun makes a bullet but doesn't fire it, this will be called on through clear_jam().
	This is also used to delete the bullet when you directly fire a bullet without going through the Fire() process,
	like with the mentioned point blanking/suicide.


	Other procs are pretty self explanatory, and what is listed above is what you should usually change for unusual
	cases. So long as the gun can return true on able_to_fire() then move on to load_into_chamber() and finally
	reload_into_chamber(), you're in good shape. Those three procs basically make up the fire cycle, and if they
	function correctly, everything else will follow.

	This system is incredibly robust and can be used for anything from single bullet carbines to high-end energy
	weapons. So long as the steps are followed, it will work without issue. Some guns ignore active attachables,
	since they currently do not use them, but if that changes, the related procs must also change.

	Energy guns, or guns that don't really use magazines, can gut this system a bit. You can see examples in
	predator weapons or the taser.

	Ammo is loaded dynamically based on parent type through a global list. It is located in global_lists.dm under
	__HELPERS. So never create new() datums, as the datum should just be referenced through the global list instead.
	This cuts down on unnecessary overhead, and makes bullets always have an ammo type, even if the parent weapon is
	somehow deleted or some such. Null ammo in the projectile flight stage shoulder NEVER exist. If it does, something
	has gone wrong elsewhere and should be looked at. Do not simply add if(ammo) checks. If the system is working correctly,
	you will never need them.

	The guns also have bitflags for various functions, so refer to those in case you want to create something unique.
	They're all pretty straight forward; silenced comes from attachments only, so don't try to set it as the default.
	If you want a silenced gun, attach a silencer to it on New() that cannot be removed.

	~N

	TODO:

	Add more muzzle flashes and gun sounds. Energy weapons, spear launcher, and taser for example.
	Add more guns, or unique guns. The framework should be there.
	Add ping for energy guns like the taser and plasma caster.
	Move pred check for damage effects into the actual predator files instead of the usual.
	Move the mind checks for damage and stun to actual files, or rework it somehow.
*/

//----------------------------------------------------------
			//   \\
			// EQUIPMENT AND INTERACTION  \\
			//   \\
			//   \\
//----------------------------------------------------------

/obj/item/weapon/gun/clicked(mob/user, list/mods)
	if (mods["alt"])
		if(!CAN_PICKUP(user, src))
			return ..()
		toggle_gun_safety()
		return TRUE
	return (..())

/obj/item/weapon/gun/mob_can_equip(mob/user)
	//Cannot equip wielded items or items burst firing.
	if(flags_gun_features & GUN_BURST_FIRING)
		return 0
	unwield(user)
	return ..()

/obj/item/weapon/gun/attack_hand(mob/user)
	var/obj/item/weapon/gun/in_hand = user.get_inactive_hand()

	if(in_hand == src && (flags_item & TWOHANDED))
		if(active_attachable)
			if(active_attachable.unload_attachment(user))
				return
		unload(user)//It has to be held if it's a two hander.
		return
	else
		..()

/// This function actually turns the lights on the gun off
/obj/item/weapon/gun/proc/turn_off_light(mob/bearer)
	if (!(flags_gun_features & GUN_FLASHLIGHT_ON))
		return FALSE
	for (var/slot in attachments)
		var/obj/item/attachable/attachment = attachments[slot]
		if (!attachment || !attachment.light_mod)
			continue
		attachment.activate_attachment(src, bearer)
		return TRUE
	return FALSE

/obj/item/weapon/gun/pickup(mob/user)
	..()

	unwield(user)

/obj/item/weapon/gun/proc/wy_allowed_check(mob/living/carbon/human/user)
	if(CONFIG_GET(flag/remove_gun_restrictions))
		return TRUE //Not if the config removed it.

	if(user.mind)
		switch(user.job)
			if(
				"PMC",
				"WY Agent",
				"Corporate Liaison",
				"Event",
				"UPP Armsmaster", //this rank is for the Fun - Ivan preset, it allows him to use the PMC guns randomly generated from his backpack
			) return TRUE
		switch(user.faction)
			if(
				FACTION_WY_DEATHSQUAD,
				FACTION_PMC,
				FACTION_MERCENARY,
				FACTION_FREELANCER,
			) return TRUE

		for(var/faction in user.faction_group)
			if(faction in FACTION_LIST_WY)
				return TRUE

		if(user.faction in FACTION_LIST_WY)
			return TRUE

	to_chat(user, SPAN_WARNING("[src] flashes a warning sign indicating unauthorized use!"))

// Checks whether there is anything to put your harness
/obj/item/weapon/gun/proc/retrieval_check(mob/living/carbon/human/user, retrieval_slot)
	if(retrieval_slot == WEAR_J_STORE)
		var/obj/item/suit = user.wear_suit
		if(!istype(suit, /obj/item/clothing/suit/storage/marine))
			return FALSE
	return TRUE

/obj/item/weapon/gun/proc/retrieve_to_slot(mob/living/carbon/human/user, retrieval_slot)
	if (!loc || !user)
		return FALSE
	if (!isturf(loc))
		return FALSE
	if(!retrieval_check(user, retrieval_slot))
		return FALSE
	if(!user.equip_to_slot_if_possible(src, retrieval_slot, disable_warning = TRUE))
		return FALSE
	var/message
	switch(retrieval_slot)
		if(WEAR_BACK)
			message = "[src] snaps into place on your back."
		if(WEAR_IN_BACK)
			message = "[src] snaps back into [user.back]."
		if(WEAR_IN_SCABBARD)
			message = "[src] snaps into place on [user.back]."
		if(WEAR_WAIST)
			message = "[src] snaps into place on your waist."
		if(WEAR_J_STORE)
			message = "[src] snaps into place on [user.wear_suit]."
	to_chat(user, SPAN_NOTICE(message))
	return TRUE

/obj/item/weapon/gun/proc/handle_retrieval(mob/living/carbon/human/user, retrieval_slot)
	if (!ishuman(user))
		return
	if (!retrieval_check(user, retrieval_slot))
		return
	addtimer(CALLBACK(src, PROC_REF(retrieve_to_slot), user, retrieval_slot), 0.3 SECONDS, TIMER_UNIQUE|TIMER_NO_HASH_WAIT)

/obj/item/weapon/gun/attack_self(mob/user)
	..()

	//There are only two ways to interact here.
	if(flags_item & TWOHANDED)
		if(flags_item & WIELDED)
			unwield(user) // Trying to unwield it
		else
			wield(user) // Trying to wield it
	else
		unload(user) // We just unload it.

//magnetic sling

/obj/item/weapon/gun/proc/handle_sling(mob/living/carbon/human/user)
	if (!ishuman(user))
		return

	addtimer(CALLBACK(src, PROC_REF(sling_return), user), 3, TIMER_UNIQUE|TIMER_OVERRIDE)

/obj/item/weapon/gun/proc/sling_return(mob/living/carbon/human/user)
	if (!loc || !user)
		return
	if (!isturf(loc))
		return

	if(user.equip_to_slot_if_possible(src, WEAR_BACK))
		to_chat(user, SPAN_WARNING("[src]'s magnetic sling automatically yanks it into your back."))

//Clicking stuff onto the gun.
//Attachables & Reloading
/obj/item/weapon/gun/attackby(obj/item/attack_item, mob/user)
	if(flags_gun_features & GUN_BURST_FIRING)
		return

	if(istype(attack_item, /obj/item/prop/helmetgarb/gunoil))
		var/oil_verb = pick("lubes", "oils", "cleans", "tends to", "gently strokes")
		if(do_after(user, 30, INTERRUPT_NO_NEEDHAND, BUSY_ICON_FRIENDLY, user, INTERRUPT_MOVED, BUSY_ICON_GENERIC))
			user.visible_message("[user] [oil_verb] [src]. It shines like new.", "You oil up and immaculately clean [src]. It shines like new.")
			src.clean_blood()
		else
			return


	if(istype(attack_item,/obj/item/attachable))
		if(check_inactive_hand(user))
			attach_to_gun(user,attack_item)

	//the active attachment is reloadable
	else if(active_attachable && active_attachable.flags_attach_features & ATTACH_RELOADABLE)
		if(check_inactive_hand(user))
			if(istype(attack_item,/obj/item/ammo_magazine))
				var/obj/item/ammo_magazine/attachment_magazine = attack_item
				if(istype(src, attachment_magazine.gun_type))
					to_chat(user, SPAN_NOTICE("You disable [active_attachable]."))
					playsound(user, active_attachable.activation_sound, 15, 1)
					active_attachable.activate_attachment(src, null, TRUE)
					reload(user,attachment_magazine)
					return
			active_attachable.reload_attachment(attack_item, user)

	else if(istype(attack_item,/obj/item/ammo_magazine))
		if(check_inactive_hand(user))
			reload(user,attack_item)


//tactical reloads
/obj/item/weapon/gun/MouseDrop_T(atom/dropping, mob/living/carbon/human/user)
	if(istype(dropping, /obj/item/ammo_magazine))
		if(!user.Adjacent(dropping))
			return
		var/obj/item/ammo_magazine/magazine = dropping
		if(!istype(user) || user.is_mob_incapacitated(TRUE))
			return
		if(src != user.r_hand && src != user.l_hand)
			to_chat(user, SPAN_WARNING("[src] must be in your hand to do that."))
			return
		if(flags_gun_features & GUN_INTERNAL_MAG)
			to_chat(user, SPAN_WARNING("Can't do tactical reloads with [src]."))
			return
		//no tactical reload for the untrained.
		if(user.skills.get_skill_level(SKILL_FIREARMS) == 0)
			to_chat(user, SPAN_WARNING("You don't know how to do tactical reloads."))
			return
		if(istype(src, magazine.gun_type) || (magazine.type in src.accepted_ammo))
			if(current_mag)
				unload(user, FALSE, TRUE)
			to_chat(user, SPAN_NOTICE("You start a tactical reload."))
			var/old_mag_loc = magazine.loc
			var/tac_reload_time = 15
			if(user.skills)
				tac_reload_time = max(15 - 5*user.skills.get_skill_level(SKILL_FIREARMS), 5)
			if(do_after(user,tac_reload_time, (INTERRUPT_ALL & (~INTERRUPT_MOVED)) , BUSY_ICON_FRIENDLY) && magazine.loc == old_mag_loc && !current_mag)
				if(isstorage(magazine.loc))
					var/obj/item/storage/master_storage = magazine.loc
					master_storage.remove_from_storage(magazine)
				reload(user, magazine)
	else
		..()



//----------------------------------------------------------
				//  \\
				// GENERIC HELPER PROCS  \\
				//  \\
				//  \\
//----------------------------------------------------------

/obj/item/weapon/proc/unique_action(mob/user) //moved this up a path to make macroing for other weapons easier -spookydonut
	return

/obj/item/weapon/gun/proc/check_inactive_hand(mob/user)
	if(user)
		var/obj/item/weapon/gun/in_hand = user.get_inactive_hand()
		if( in_hand != src ) //It has to be held.
			to_chat(user, SPAN_WARNING("You have to hold [src] to do that!"))
			return
	return 1

/obj/item/weapon/gun/proc/check_both_hands(mob/user)
	if(user)
		var/obj/item/weapon/gun/in_handL = user.l_hand
		var/obj/item/weapon/gun/in_handR = user.r_hand
		if( in_handL != src && in_handR != src ) //It has to be held.
			to_chat(user, SPAN_WARNING("You have to hold [src] to do that!"))
			return
	return 1

/obj/item/weapon/gun/proc/has_attachment(attachment)
	if(!attachment)
		return FALSE
	for(var/slot in attachments)
		var/obj/item/attachable/attached_attachment = attachments[slot]
		if(attached_attachment && istype(attached_attachment, attachment))
			return TRUE
	return FALSE

/obj/item/weapon/gun/proc/can_attach_to_gun(mob/user, obj/item/attachable/attachment)
	if(!attachment.can_be_attached_to_gun(user, src))
		return FALSE

	//Checks if they can attach the thing in the first place, like with fixed attachments.
	if(attachments[attachment.slot])
		var/obj/item/attachable/attached_attachment = attachments[attachment.slot]
		if(attached_attachment && !(attached_attachment.flags_attach_features & ATTACH_REMOVABLE))
			to_chat(user, SPAN_WARNING("The attachment on [src]'s [attachment.slot] cannot be removed!"))
			return 0
	//to prevent headaches with lighting stuff
	if(attachment.light_mod)
		for(var/slot in attachments)
			var/obj/item/attachable/attached_attachment = attachments[slot]
			if(!attached_attachment)
				continue
			if(attached_attachment.light_mod)
				to_chat(user, SPAN_WARNING("You already have a light source attachment on [src]."))
				return 0
	return 1

/obj/item/weapon/gun/proc/attach_to_gun(mob/user, obj/item/attachable/attachment)
	if(!can_attach_to_gun(user, attachment))
		return FALSE

	user.visible_message(SPAN_NOTICE("[user] begins attaching [attachment] to [src]."),
	SPAN_NOTICE("You begin attaching [attachment] to [src]."), null, 4)
	if(do_after(user, 1.5 SECONDS, INTERRUPT_ALL, BUSY_ICON_FRIENDLY, numticks = 2))
		if(attachment && attachment.loc)
			user.visible_message(SPAN_NOTICE("[user] attaches [attachment] to [src]."),
			SPAN_NOTICE("You attach [attachment] to [src]."), null, 4)
			user.temp_drop_inv_item(attachment)
			attachment.Attach(src, user)
			update_attachable(attachment.slot)
			playsound(user, 'sound/handling/attachment_add.ogg', 15, 1, 4)
			return TRUE

/obj/item/weapon/gun/proc/on_detach(mob/user, obj/item/attachable/attachment)
	return

/obj/item/weapon/gun/proc/update_attachables() //Updates everything. You generally don't need to use this.
	//overlays.Cut()
	if(attachable_offset) //Even if the attachment doesn't exist, we're going to try and remove it.
		for(var/slot in attachments)
			var/obj/item/attachable/attached_attachment = attachments[slot]
			if(!attached_attachment)
				continue
			update_overlays(attached_attachment, attached_attachment.slot)

/obj/item/weapon/gun/proc/update_attachable(attachable) //Updates individually.
	if(attachable_offset && attachments[attachable])
		update_overlays(attachments[attachable], attachable)

/obj/item/weapon/gun/proc/update_overlays(obj/item/attachable/attachment, slot)
	var/image/gun_image = attachable_overlays[slot]
	overlays -= gun_image
	attachable_overlays[slot] = null
	if(attachment && !attachment.hidden) //Only updates if the attachment exists for that slot.
		var/item_icon = attachment.icon_state
		if(attachment.attach_icon)
			item_icon = attachment.attach_icon
		gun_image = image(attachment.icon,src, item_icon)
		gun_image.pixel_x = attachable_offset["[slot]_x"] - attachment.pixel_shift_x + x_offset_by_attachment_type(attachment.type)
		gun_image.pixel_y = attachable_offset["[slot]_y"] - attachment.pixel_shift_y + y_offset_by_attachment_type(attachment.type)
		attachable_overlays[slot] = gun_image
		overlays += gun_image
	else
		attachable_overlays[slot] = null

/obj/item/weapon/gun/proc/x_offset_by_attachment_type(attachment_type)
	return 0

/obj/item/weapon/gun/proc/y_offset_by_attachment_type(attachment_type)
	return 0

/obj/item/weapon/gun/proc/update_mag_overlay()
	var/image/gun_image = attachable_overlays["mag"]
	if(istype(gun_image))
		overlays -= gun_image
		attachable_overlays["mag"] = null
	if(current_mag && current_mag.bonus_overlay)
		gun_image = image(current_mag.icon,src,current_mag.bonus_overlay)
		gun_image.pixel_x += bonus_overlay_x
		gun_image.pixel_y += bonus_overlay_y
		attachable_overlays["mag"] = gun_image
		overlays += gun_image
	else
		attachable_overlays["mag"] = null
	return

/obj/item/weapon/gun/proc/update_special_overlay(new_icon_state)
	overlays -= attachable_overlays["special"]
	attachable_overlays["special"] = null
	var/image/gun_image = image(icon,src,new_icon_state)
	attachable_overlays["special"] = gun_image
	overlays += gun_image

/obj/item/weapon/gun/proc/update_force_list()
	switch(force)
		if(-50 to 15)
			attack_verb = list("struck", "hit", "bashed") //Unlikely to ever be -50, but just to be safe.
		if(16 to 35)
			attack_verb = list("smashed", "struck", "whacked", "beaten", "cracked")
		else
			attack_verb = list("slashed", "stabbed", "speared", "torn", "punctured", "pierced", "gored") //Greater than 35

/obj/item/weapon/gun/proc/get_active_firearm(mob/user, restrictive = TRUE)
	if(user.is_mob_incapacitated() || !isturf(usr.loc))
		return
	if(!ishuman(user) && !HAS_TRAIT(user, TRAIT_OPPOSABLE_THUMBS))
		to_chat(user, SPAN_WARNING("Not right now."))
		return

	var/obj/item/weapon/gun/held_item = user.get_held_item()

	if(!istype(held_item)) // if active hand is not a gun
		if(restrictive) // if restrictive we return right here
			to_chat(user, SPAN_WARNING("You need a gun in your active hand to do that!"))
			return
		else // else check inactive hand
			held_item = user.get_inactive_hand()
			if(!istype(held_item)) // if inactive hand is ALSO not a gun we return
				to_chat(user, SPAN_WARNING("You need a gun in one of your hands to do that!"))
				return

	if(held_item?.flags_gun_features & GUN_BURST_FIRING)
		return

	return held_item

//----------------------------------------------------------
					//    \\
					// GUN VERBS PROCS \\
					//    \\
					//    \\
//----------------------------------------------------------



/mob/living/carbon/human/proc/can_unholster_from_storage_slot(obj/item/storage/slot)
	if(isnull(slot))
		return FALSE
	if(slot == shoes)//Snowflakey check for shoes and uniform
		if(shoes.stored_item && isweapon(shoes.stored_item))
			return shoes
		return FALSE

	if(slot == w_uniform)
		for(var/obj/item/storage/internal/accessory/holster/cycled_holster in w_uniform.accessories)
			if(cycled_holster.current_gun)
				return w_uniform
		for(var/obj/item/clothing/accessory/storage/holster/cycled_holster in w_uniform.accessories)
			var/obj/item/storage/internal/accessory/holster/holster = cycled_holster.hold
			if(holster.current_gun)
				return holster.current_gun

		for(var/obj/item/clothing/accessory/storage/cycled_accessory in w_uniform.accessories)
			var/obj/item/storage/internal/accessory/accessory_storage = cycled_accessory.hold
			if(accessory_storage.storage_flags & STORAGE_ALLOW_QUICKDRAW)
				return accessory_storage

		return FALSE

	if(istype(slot) && (slot.storage_flags & STORAGE_ALLOW_QUICKDRAW))
		for(var/obj/cycled_object in slot.return_inv())
			if(cycled_object.flags_atom & QUICK_DRAWABLE)
				return slot

	if(slot.flags_atom & QUICK_DRAWABLE)
		return slot

	return FALSE

///For the holster hotkey
/mob/living/carbon/human/verb/holster_verb(unholster_number_offset = 1 as num)
	set name = "holster"
	set hidden = TRUE
	if(usr.is_mob_incapacitated(TRUE) || usr.is_mob_restrained() || IsKnockDown() || HAS_TRAIT_FROM(src, TRAIT_UNDENSE, LYING_DOWN_TRAIT))
		to_chat(src, SPAN_WARNING("You can't draw a weapon in your current state."))
		return

	var/obj/item/active_hand = get_active_hand()
	if(active_hand)
		if(active_hand.preferred_storage)
			for(var/storage in active_hand.preferred_storage)
				var/list/items_in_slot
				if(islist(get_item_by_slot(active_hand.preferred_storage[storage])))
					items_in_slot = get_item_by_slot(active_hand.preferred_storage[storage])
				else
					items_in_slot = list(get_item_by_slot(active_hand.preferred_storage[storage]))

				for(var/item_in_slot in items_in_slot)
					if(istype(item_in_slot, storage))
						var/slot = active_hand.preferred_storage[storage]
						switch(slot)
							if(WEAR_ACCESSORY)
								slot = WEAR_IN_ACCESSORY
							if(WEAR_WAIST)
								slot = WEAR_IN_BELT
							if(WEAR_BACK)
								slot = WEAR_IN_BACK
							if(WEAR_J_STORE)
								slot = WEAR_IN_J_STORE
							if(WEAR_HEAD)
								slot = WEAR_IN_HELMET
							if(WEAR_FEET)
								slot = WEAR_IN_SHOES

						if(equip_to_slot_if_possible(active_hand, slot, ignore_delay = TRUE, del_on_fail = FALSE, disable_warning = TRUE, redraw_mob = TRUE))
							return TRUE
		if(w_uniform)
			for(var/obj/accessory in w_uniform.accessories)
				var/obj/item/storage/internal/accessory/holster/holster = accessory
				if(istype(holster) && !holster.current_gun && holster.can_be_inserted(active_hand))
					holster._item_insertion(active_hand, src)
					return

				var/obj/item/clothing/accessory/storage/holster/holster_ammo = accessory
				if(istype(holster_ammo))
					var/obj/item/storage/internal/accessory/holster/storage = holster_ammo.hold
					if(storage.can_be_inserted(active_hand, src, stop_messages = TRUE))
						storage.handle_item_insertion(active_hand, user = src)
						return

		quick_equip()
	else //empty hand, start checking slots and holsters

		//default order: suit, belt, back, pockets, uniform, shoes
		var/list/slot_order = list("s_store", "belt", "back", "l_store", "r_store", "w_uniform", "shoes")

		var/obj/item/slot_selected

		for(var/slot in slot_order)
			var/slot_type = can_unholster_from_storage_slot(vars[slot])
			if(slot_type)
				slot_selected = slot_type
				if(unholster_number_offset == 1)
					break
				else
					unholster_number_offset--

		if(slot_selected)
			slot_selected.attack_hand(src)


/obj/item/weapon/gun/verb/field_strip()
	set category = "Weapons"
	set name = "Field Strip Weapon"
	set desc = "Remove all attachables from a weapon."
	set src = usr.contents //We want to make sure one is picked at random, hence it's not in a list.

	var/obj/item/weapon/gun/active_firearm = get_active_firearm(usr, FALSE) // don't see why it should be restrictive

	if(!active_firearm)
		return

	src = active_firearm

	if(usr.action_busy)
		return

	if(zoom)
		to_chat(usr, SPAN_WARNING("You cannot conceivably do that while looking down \the [src]'s scope!"))
		return

	var/list/choices = list()
	var/list/choice_to_attachment = list()
	for(var/slot in attachments)
		var/obj/item/attachable/attached_attachment = attachments[slot]
		if(attached_attachment && (attached_attachment.flags_attach_features & ATTACH_REMOVABLE))
			var/capitalized_name = capitalize_first_letters(attached_attachment.name)
			choices[capitalized_name] = image(icon = attached_attachment.icon, icon_state = attached_attachment.icon_state)
			choice_to_attachment[capitalized_name] = attached_attachment

	if(!length(choices))
		to_chat(usr, SPAN_WARNING("[src] has no removable attachments."))
		return

	var/obj/item/attachable/attachment
	if(length(choices) == 1)
		attachment = choice_to_attachment[choices[1]]
	else
		var/use_radials = usr.client.prefs?.no_radials_preference ? FALSE : TRUE
		var/choice = use_radials ? show_radial_menu(usr, usr, choices, require_near = TRUE) : tgui_input_list(usr, "Which attachment to remove?", "Remove Attachment", choices)
		attachment = choice_to_attachment[choice]

	if(!attachment || get_active_firearm(usr) != src || usr.action_busy || zoom || (!(attachment == attachments[attachment.slot])) || !(attachment.flags_attach_features & ATTACH_REMOVABLE))
		return

	usr.visible_message(SPAN_NOTICE("[usr] begins stripping [attachment] from [src]."),
	SPAN_NOTICE("You begin stripping [attachment] from [src]."), null, 4)

	if(!do_after(usr, 1.5 SECONDS, INTERRUPT_ALL, BUSY_ICON_FRIENDLY))
		return

	if(!(attachment == attachments[attachment.slot]))
		return
	if(!(attachment.flags_attach_features & ATTACH_REMOVABLE))
		return

	if(zoom)
		return

	usr.visible_message(SPAN_NOTICE("[usr] strips [attachment] from [src]."),
	SPAN_NOTICE("You strip [attachment] from [src]."), null, 4)
	attachment.Detach(usr, src)

	playsound(src, 'sound/handling/attachment_remove.ogg', 15, 1, 4)
	update_icon()

/obj/item/weapon/gun/proc/do_toggle_firemode(datum/source, datum/keybinding, new_firemode)
	SIGNAL_HANDLER
	if(flags_gun_features & GUN_BURST_FIRING)//can't toggle mid burst
		return

	if(!length(gun_firemode_list))
		CRASH("[src] called do_toggle_firemode() with an empty gun_firemode_list")

	if(length(gun_firemode_list) == 1)
		to_chat(source, SPAN_NOTICE("[icon2html(src, source)] This gun only has one firemode."))
		return

	if(new_firemode)
		if(!(new_firemode in gun_firemode_list))
			CRASH("[src] called do_toggle_firemode() with [new_firemode] new_firemode, not on gun_firemode_list")
		gun_firemode = new_firemode
	else
		var/mode_index = gun_firemode_list.Find(gun_firemode)
		if(++mode_index <= length(gun_firemode_list))
			gun_firemode = gun_firemode_list[mode_index]
		else
			gun_firemode = gun_firemode_list[1]

	playsound(source, 'sound/weapons/handling/gun_burst_toggle.ogg', 15, 1)

	if(ishuman(source))
		to_chat(source, SPAN_NOTICE("[icon2html(src, source)] You switch to <b>[gun_firemode]</b>."))
	SEND_SIGNAL(src, COMSIG_GUN_FIRE_MODE_TOGGLE, gun_firemode)

/obj/item/weapon/gun/proc/add_firemode(added_firemode, mob/user)
	gun_firemode_list |= added_firemode

	if(!length(gun_firemode_list))
		CRASH("add_firemode called with a resulting gun_firemode_list length of [length(gun_firemode_list)].")

/obj/item/weapon/gun/proc/remove_firemode(removed_firemode, mob/user)
	if(!(removed_firemode in gun_firemode_list))
		return

	if(!length(gun_firemode_list) || (length(gun_firemode_list) == 1))
		CRASH("remove_firemode called with gun_firemode_list length [length(gun_firemode_list)].")

	gun_firemode_list -= removed_firemode

	if(gun_firemode == removed_firemode)
		gun_firemode = gun_firemode_list[1]
		do_toggle_firemode(user, gun_firemode)

/obj/item/weapon/gun/proc/setup_firemodes()
	var/old_firemode = gun_firemode
	gun_firemode_list.len = 0

	if(start_automatic)
		gun_firemode_list |= GUN_FIREMODE_AUTOMATIC

	if(start_semiauto)
		gun_firemode_list |= GUN_FIREMODE_SEMIAUTO

	if(burst_amount > BURST_AMOUNT_TIER_1)
		gun_firemode_list |= GUN_FIREMODE_BURSTFIRE

	if(!length(gun_firemode_list))
		CRASH("[src] called setup_firemodes() with an empty gun_firemode_list")

	else if(old_firemode in gun_firemode_list)
		gun_firemode = old_firemode

	else
		gun_firemode = gun_firemode_list[1]

/obj/item/weapon/gun/verb/use_toggle_burst()
	set category = "Weapons"
	set name = "Toggle Firemode"
	set desc = "Cycles through your gun's firemodes. Automatic modes greatly reduce accuracy."
	set src = usr.contents

	var/obj/item/weapon/gun/active_firearm = get_active_firearm(usr)
	if(!active_firearm)
		return
	src = active_firearm

	do_toggle_firemode(usr)

/obj/item/weapon/gun/verb/empty_mag()
	set category = "Weapons"
	set name = "Unload Weapon"
	set desc = "Removes the magazine from your current gun and drops it on the ground, or clears the chamber if your gun is already empty."
	set src = usr.contents

	var/mob/user = usr
	var/obj/item/weapon/gun/active_firearm = get_active_firearm(user)
	if(!active_firearm)
		return
	src = active_firearm
	if(active_firearm.active_attachable)
		// unload the attachment
		var/drop_to_ground = TRUE
		if(user.client?.prefs && (user.client?.prefs?.toggle_prefs & TOGGLE_EJECT_MAGAZINE_TO_HAND))
			drop_to_ground = FALSE
			unwield(user)
		if(active_firearm.active_attachable.unload_attachment(usr, FALSE, drop_to_ground))
			return

	//unloading a regular gun
	var/drop_to_ground = TRUE
	if(user.client?.prefs && (user.client?.prefs?.toggle_prefs & TOGGLE_EJECT_MAGAZINE_TO_HAND))
		drop_to_ground = FALSE
		unwield(user)
		if(!(active_firearm.flags_gun_features & GUN_INTERNAL_MAG))
			user.swap_hand()

	unload(user, FALSE, drop_to_ground) //We want to drop the mag on the ground.

/obj/item/weapon/gun/verb/use_unique_action()
	set category = "Weapons"
	set name = "Unique Action"
	set desc = "Use anything unique your firearm is capable of. Includes pumping a shotgun or spinning a revolver. If you have an active attachment, this will activate on the attachment instead."
	set src = usr.contents

	var/obj/item/weapon/gun/active_firearm = get_active_firearm(usr)
	if(!active_firearm)
		return
	if(active_firearm.active_attachable)
		src = active_firearm.active_attachable
	else
		src = active_firearm

	unique_action(usr)

/obj/item/weapon/gun/verb/toggle_gun_safety()
	set category = "Weapons"
	set name = "Toggle Gun Safety"
	set desc = "Toggle the safety of the held gun."
	set src = usr.contents //We want to make sure one is picked at random, hence it's not in a list.

	var/obj/item/weapon/gun/active_firearm = get_active_firearm(usr,FALSE) // safeties shouldn't be restrictive

	if(!active_firearm)
		return

	src = active_firearm

	if(flags_gun_features & GUN_BURST_FIRING)
		return

	if(!ishuman(usr) && !HAS_TRAIT(usr, TRAIT_OPPOSABLE_THUMBS))
		return

	if(usr.is_mob_incapacitated() || !usr.loc || !isturf(usr.loc))
		to_chat(usr, "Not right now.")
		return

	flags_gun_features ^= GUN_TRIGGER_SAFETY
	gun_safety_handle(usr)


/obj/item/weapon/gun/proc/gun_safety_handle(mob/user)
	to_chat(user, SPAN_NOTICE("You toggle the safety [SPAN_BOLD(flags_gun_features & GUN_TRIGGER_SAFETY ? "on" : "off")]."))
	playsound(user, 'sound/weapons/handling/safety_toggle.ogg', 25, 1)

/obj/item/weapon/gun/verb/activate_attachment_verb()
	set category = "Weapons"
	set name = "Use Attachment"
	set desc = "Activates one of the attached attachments on the gun."
	set src = usr.contents

	var/obj/item/weapon/gun/active_firearm = get_active_firearm(usr, FALSE)
	if(!active_firearm)
		return
	src = active_firearm

	var/obj/item/attachable/chosen_attachment

	var/usable_attachments[] = list() //Basic list of attachments to compare later.
	for(var/slot in attachments)
		var/obj/item/attachable/attachment = attachments[slot]
		if(attachment && (attachment.flags_attach_features & ATTACH_ACTIVATION) )
			usable_attachments += attachment

	if(!length(usable_attachments)) //No usable attachments.
		to_chat(usr, SPAN_WARNING("[src] does not have any usable attachments!"))
		return

	if(length(usable_attachments) == 1) //Activates the only attachment if there is only one.
		chosen_attachment = usable_attachments[1]
	else
		chosen_attachment = tgui_input_list(usr, "Which attachment to activate?", "Activate attachment", usable_attachments)
		if(!chosen_attachment || chosen_attachment.loc != src)
			return
	if(chosen_attachment)
		chosen_attachment.activate_attachment(src, usr)

/obj/item/weapon/gun/verb/activate_rail_attachment_verb()
	set category = "Weapons"
	set name = "Use Rail Attachment"
	set desc = "Use the attachment that is mounted on your rail."
	set src = usr.contents

	var/obj/item/weapon/gun/active_firearm = get_active_firearm(usr, FALSE)
	if(!active_firearm)
		return
	src = active_firearm

	var/obj/item/attachable/attachment = attachments["rail"]
	if(attachment)
		attachment.activate_attachment(src, usr)
	else
		to_chat(usr, SPAN_WARNING("[src] does not have any usable rail attachments!"))
		return

/obj/item/weapon/gun/verb/toggle_auto_eject_verb()
	set category = "Weapons"
	set name = "Toggle Auto Eject"
	set desc = "Enable/Disable the gun's magazine ejection system"
	set src = usr.contents

	var/obj/item/weapon/gun/active_firearm = get_active_firearm(usr)
	if(!active_firearm)
		return
	src = active_firearm

	if(src.flags_gun_features & GUN_ANTIQUE || src.flags_gun_features & GUN_INTERNAL_MAG  || src.flags_gun_features & GUN_UNUSUAL_DESIGN)
		to_chat(usr, SPAN_WARNING("[src] has no auto ejection system!"))
		return
	else
		src.flags_gun_features ^= GUN_AUTO_EJECTOR
		to_chat(usr, SPAN_INFO("You toggle the auto ejector [src.flags_gun_features & GUN_AUTO_EJECTOR ? "on" : "off"]"))


/obj/item/weapon/gun/verb/toggle_underbarrel_attachment_verb()
	set category = "Weapons"
	set name = "Toggle Underbarrel Attachment"
	set desc = "Use the attachment that is mounted on your underbarrel."
	set src = usr.contents

	var/obj/item/weapon/gun/active_firearm = get_active_firearm(usr,FALSE)
	if(!active_firearm)
		return
	src = active_firearm

	var/obj/item/attachable/attachment = attachments["under"]
	if(attachment)
		attachment.activate_attachment(src, usr)
	else
		to_chat(usr, SPAN_WARNING("[src] does not have any usable underbarrel attachments!"))
		return

/obj/item/weapon/gun/verb/toggle_stock_attachment_verb()
	set category = "Weapons"
	set name = "Toggle Stock Attachment"
	set desc = "Use the stock attachment that is mounted on your gun."
	set src = usr.contents

	var/obj/item/weapon/gun/active_firearm = get_active_firearm(usr, FALSE) // incase someone
	if(!active_firearm)
		return
	src = active_firearm

	var/obj/item/attachable/attachment = attachments["stock"]
	if(attachment)
		attachment.activate_attachment(src, usr)
	else
		to_chat(usr, SPAN_WARNING("[src] does not have any usable stock attachments!"))
		return


/obj/item/weapon/gun/item_action_slot_check(mob/user, slot)
	if(slot != WEAR_L_HAND && slot != WEAR_R_HAND)
		return FALSE
	return TRUE

/**
 * Returns one of the two override values if either are null, preferring the argument value.
 * Otherwise, returns TRUE if it is in a civilian usable category (Handguns or SMGs), FALSE if it is not.
 */
/obj/item/weapon/gun/proc/is_civilian_usable(mob/user, arg_override)
	if(!isnull(arg_override))
		return arg_override

	if(!isnull(civilian_usable_override))
		return civilian_usable_override

	if(gun_category in UNTRAINED_USABLE_CATEGORIES)
		return TRUE

	return FALSE

///Helper proc that processes a clicked target, if the target is not black tiles, it will not change it. If they are it will return the turf of the black tiles. It will return null if the object is a screen object other than black tiles.
/proc/get_turf_on_clickcatcher(atom/target, mob/user, params)
	var/list/modifiers = params2list(params)
	if(!istype(target, /atom/movable/screen))
		return target
	if(!istype(target, /atom/movable/screen/click_catcher))
		return null
	return params2turf(modifiers["screen-loc"], get_turf(user), user.client)

/// check if the gun contains any light source that is currently turned on.
/obj/item/weapon/gun/proc/light_sources()
	var/obj/item/attachable/flashlight/torch
	for(var/slot in attachments)
		torch = attachments[slot]
		if(istype(torch) && torch.light_on == TRUE)
			return TRUE // an attachment has light enabled.
	return FALSE

/// If this gun has a relevant flashlight attachable attached, (de)activate it
/obj/item/weapon/gun/proc/force_light(on)
	var/obj/item/attachable/flashlight/torch
	for(var/slot in attachments)
		torch = attachments[slot]
		if(istype(torch))
			break
	if(!torch)
		return FALSE
	torch.turn_light(toggle_on = on, forced = TRUE)
	return TRUE
