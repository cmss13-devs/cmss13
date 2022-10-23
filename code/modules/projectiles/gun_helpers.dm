/*
ERROR CODES AND WHAT THEY MEAN:


ERROR CODE A1: null ammo while reloading. <------------ Only appears when initialising or reloading a weapon and switching the ammo. Somehow the argument passed a null ammo.
ERROR CODE A2: null caliber while reloading. <------------ Only appears when initialising or reloading a weapon and switching the calibre. Somehow the argument passed a null caliber.
ERROR CODE I1: projectile malfunctioned while firing. <------------ Right before the bullet is fired, the actual bullet isn't present or isn't a bullet.
ERROR CODE I2: null ammo while load_into_chamber() <------------- Somehow the ammo datum is missing or something. We need to figure out how that happened.
ERROR CODE R1: negative current_rounds on examine. <------------ Applies to ammunition only. Ammunition should never have negative rounds after spawn.

DEFINES in setup.dm, referenced here.
#define GUN_CAN_POINTBLANK		1
#define GUN_TRIGGER_SAFETY		2
#define GUN_UNUSUAL_DESIGN		4
#define GUN_SILENCED			8
#define GUN_AUTOMATIC			16
#define GUN_INTERNAL_MAG		32
#define GUN_AUTO_EJECTOR		64
#define GUN_AMMO_COUNTER		128
#define GUN_BURST_ON			256
#define GUN_BURST_FIRING		512
#define GUN_FLASHLIGHT_ON		1024
#define GUN_WY_RESTRICTED		2048
#define GUN_SPECIALIST			4096

	NOTES

	if(burst_toggled && burst_firing) return
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
			//							  \\
			// EQUIPMENT AND INTERACTION  \\
			//							  \\
			//						   	  \\
//----------------------------------------------------------

/obj/item/weapon/gun/clicked(var/mob/user, var/list/mods)
	if (mods["alt"])
		toggle_gun_safety()
		return 1
	return (..())

/obj/item/weapon/gun/mob_can_equip(mob/user)
	//Cannot equip wielded items or items burst firing.
	if(flags_gun_features & GUN_BURST_FIRING) return 0
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

/*
Note: pickup and dropped on weapons must have both the ..() to update zoom AND twohanded,
As sniper rifles have both and weapon mods can change them as well. ..() deals with zoom only.
*/
/obj/item/weapon/gun/dropped(mob/user)
	. = ..()

	stop_aim()
	if (user && user.client)
		user.update_gun_icons()

	turn_off_light(user)

	var/delay_left = (last_fired + fire_delay + additional_fire_group_delay) - world.time
	if(fire_delay_group && delay_left > 0)
		for(var/group in fire_delay_group)
			LAZYSET(user.fire_delay_next_fire, group, world.time + delay_left)

	unwield(user)

/obj/item/weapon/gun/equipped(mob/user, slot)
	. = ..()

	var/delay_left = (last_fired + fire_delay + additional_fire_group_delay) - world.time
	if(fire_delay_group && delay_left > 0)
		for(var/group in fire_delay_group)
			LAZYSET(user.fire_delay_next_fire, group, world.time + delay_left)

/obj/item/weapon/gun/proc/turn_off_light(mob/bearer)
	if (!(flags_gun_features & GUN_FLASHLIGHT_ON))
		return FALSE
	for (var/slot in attachments)
		var/obj/item/attachable/A = attachments[slot]
		if (!A || !A.light_mod)
			continue
		bearer.SetLuminosity(0, FALSE, src)
		SetLuminosity(A.light_mod)
		return TRUE
	return FALSE

/obj/item/weapon/gun/pickup(mob/user)
	..()

	if (flags_gun_features & GUN_FLASHLIGHT_ON)
		for (var/slot in attachments)
			var/obj/item/attachable/A = attachments[slot]
			if (!A || !A.light_mod)
				continue
			user.SetLuminosity(A.light_mod, FALSE, src)
			SetLuminosity(0)
			break

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
		if(user.faction in FACTION_LIST_WY)
			return TRUE

	to_chat(user, SPAN_WARNING("[src] flashes a warning sign indicating unauthorized use!"))

// Checks whether there is anything to put your harness
/obj/item/weapon/gun/proc/retrieval_check(var/mob/living/carbon/human/user, var/retrieval_slot)
	if(retrieval_slot == WEAR_J_STORE)
		var/obj/item/I = user.wear_suit
		if(!istype(I, /obj/item/clothing/suit/storage/marine))
			return FALSE
	return TRUE

/obj/item/weapon/gun/proc/retrieve_to_slot(var/mob/living/carbon/human/user, var/retrieval_slot)
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

/obj/item/weapon/gun/proc/handle_retrieval(mob/living/carbon/human/user, var/retrieval_slot)
	if (!ishuman(user))
		return
	if (!retrieval_check(user, retrieval_slot))
		return
	addtimer(CALLBACK(src, .proc/retrieve_to_slot, user, retrieval_slot), 0.3 SECONDS, TIMER_UNIQUE|TIMER_NO_HASH_WAIT)

/obj/item/weapon/gun/attack_self(mob/user)
	..()
	if (target)
		lower_aim()
		return

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

	addtimer(CALLBACK(src, .proc/sling_return, user), 3, TIMER_UNIQUE|TIMER_OVERRIDE)

/obj/item/weapon/gun/proc/sling_return(var/mob/living/carbon/human/user)
	if (!loc || !user)
		return
	if (!isturf(loc))
		return

	if(user.equip_to_slot_if_possible(src, WEAR_BACK))
		to_chat(user, SPAN_WARNING("[src]'s magnetic sling automatically yanks it into your back."))

//Clicking stuff onto the gun.
//Attachables & Reloading
/obj/item/weapon/gun/attackby(obj/item/I, mob/user)
	if(flags_gun_features & GUN_BURST_FIRING)
		return

	if(istype(I, /obj/item/prop/helmetgarb/gunoil))
		var/oil_verb = pick("lubes", "oils", "cleans", "tends to", "gently strokes")
		if(do_after(user, 30, INTERRUPT_NO_NEEDHAND, BUSY_ICON_FRIENDLY, user, INTERRUPT_MOVED, BUSY_ICON_GENERIC))
			user.visible_message("[user] [oil_verb] [src]. It shines like new.", "You oil up and immaculately clean [src]. It shines like new.")
			src.clean_blood()
		else
			return


	if(istype(I,/obj/item/attachable))
		if(check_inactive_hand(user)) attach_to_gun(user,I)

	//the active attachment is reloadable
	else if(active_attachable && active_attachable.flags_attach_features & ATTACH_RELOADABLE)
		if(check_inactive_hand(user))
			if(istype(I,/obj/item/ammo_magazine))
				var/obj/item/ammo_magazine/MG = I
				if(istype(src, MG.gun_type))
					to_chat(user, SPAN_NOTICE("You disable [active_attachable]."))
					playsound(user, active_attachable.activation_sound, 15, 1)
					active_attachable.activate_attachment(src, null, TRUE)
					reload(user,MG)
					return
			active_attachable.reload_attachment(I, user)

	else if(istype(I,/obj/item/ammo_magazine))
		if(check_inactive_hand(user)) reload(user,I)


//tactical reloads
/obj/item/weapon/gun/MouseDrop_T(atom/dropping, mob/living/carbon/human/user)
	if(istype(dropping, /obj/item/ammo_magazine))
		if(!user.Adjacent(dropping)) return
		var/obj/item/ammo_magazine/AM = dropping
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
		if(istype(src, AM.gun_type) || (AM.type in src.accepted_ammo))
			if(current_mag)
				unload(user, FALSE, TRUE)
			to_chat(user, SPAN_NOTICE("You start a tactical reload."))
			var/old_mag_loc = AM.loc
			var/tac_reload_time = 15
			if(user.skills)
				tac_reload_time = max(15 - 5*user.skills.get_skill_level(SKILL_FIREARMS), 5)
			if(do_after(user,tac_reload_time, INTERRUPT_ALL, BUSY_ICON_FRIENDLY) && AM.loc == old_mag_loc && !current_mag)
				if(isstorage(AM.loc))
					var/obj/item/storage/S = AM.loc
					S.remove_from_storage(AM)
				reload(user, AM)
	else
		..()



//----------------------------------------------------------
				//						 \\
				// GENERIC HELPER PROCS  \\
				//						 \\
				//						 \\
//----------------------------------------------------------

/obj/item/weapon/proc/unique_action(mob/M) //moved this up a path to make macroing for other weapons easier -spookydonut
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

/obj/item/weapon/gun/proc/has_attachment(A)
	if(!A)
		return FALSE
	for(var/slot in attachments)
		var/obj/item/attachable/R = attachments[slot]
		if(R && istype(R, A))
			return TRUE
	return FALSE

/obj/item/weapon/gun/proc/can_attach_to_gun(mob/user, obj/item/attachable/attachment)
	if(!attachment.can_be_attached_to_gun(user, src))
		return FALSE

	//Checks if they can attach the thing in the first place, like with fixed attachments.
	if(attachments[attachment.slot])
		var/obj/item/attachable/R = attachments[attachment.slot]
		if(R && !(R.flags_attach_features & ATTACH_REMOVABLE))
			to_chat(user, SPAN_WARNING("The attachment on [src]'s [attachment.slot] cannot be removed!"))
			return 0
	//to prevent headaches with lighting stuff
	if(attachment.light_mod)
		for(var/slot in attachments)
			var/obj/item/attachable/R = attachments[slot]
			if(!R)
				continue
			if(R.light_mod)
				to_chat(user, SPAN_WARNING("You already have a light source attachment on [src]."))
				return 0
	return 1

/obj/item/weapon/gun/proc/attach_to_gun(mob/user, obj/item/attachable/attachment)
	if(!can_attach_to_gun(user, attachment))
		return

	user.visible_message(SPAN_NOTICE("[user] begins attaching [attachment] to [src]."),
	SPAN_NOTICE("You begin attaching [attachment] to [src]."), null, 4)
	if(do_after(user, 1.5 SECONDS, INTERRUPT_ALL, BUSY_ICON_FRIENDLY, numticks = 2))
		if(attachment && attachment.loc)
			user.visible_message(SPAN_NOTICE("[user] attaches [attachment] to [src]."),
			SPAN_NOTICE("You attach [attachment] to [src]."), null, 4)
			user.temp_drop_inv_item(attachment)
			attachment.Attach(src)
			update_attachable(attachment.slot)
			playsound(user, 'sound/handling/attachment_add.ogg', 15, 1, 4)

/obj/item/weapon/gun/proc/update_attachables() //Updates everything. You generally don't need to use this.
	//overlays.Cut()
	if(attachable_offset) //Even if the attachment doesn't exist, we're going to try and remove it.
		for(var/slot in attachments)
			var/obj/item/attachable/R = attachments[slot]
			if(!R) continue
			update_overlays(R, R.slot)

/obj/item/weapon/gun/proc/update_attachable(attachable) //Updates individually.
	if(attachable_offset && attachments[attachable])
		update_overlays(attachments[attachable], attachable)

/obj/item/weapon/gun/proc/update_overlays(obj/item/attachable/A, slot)
	var/image/I = attachable_overlays[slot]
	overlays -= I
	attachable_overlays[slot] = null
	if(A && !A.hidden) //Only updates if the attachment exists for that slot.
		var/item_icon = A.icon_state
		if(A.attach_icon)
			item_icon = A.attach_icon
		I = image(A.icon,src, item_icon)
		I.pixel_x = attachable_offset["[slot]_x"] - A.pixel_shift_x + x_offset_by_attachment_type(A.type)
		I.pixel_y = attachable_offset["[slot]_y"] - A.pixel_shift_y + y_offset_by_attachment_type(A.type)
		attachable_overlays[slot] = I
		overlays += I
	else attachable_overlays[slot] = null

/obj/item/weapon/gun/proc/x_offset_by_attachment_type(var/attachment_type)
	return 0

/obj/item/weapon/gun/proc/y_offset_by_attachment_type(var/attachment_type)
	return 0

/obj/item/weapon/gun/proc/update_mag_overlay()
	var/image/I = attachable_overlays["mag"]
	if(istype(I))
		overlays -= I
		attachable_overlays["mag"] = null
	if(current_mag && current_mag.bonus_overlay)
		I = image(current_mag.icon,src,current_mag.bonus_overlay)
		I.pixel_x += bonus_overlay_x
		I.pixel_y += bonus_overlay_y
		attachable_overlays["mag"] = I
		overlays += I
	else
		attachable_overlays["mag"] = null
	return

/obj/item/weapon/gun/proc/update_special_overlay(new_icon_state)
	overlays -= attachable_overlays["special"]
	attachable_overlays["special"] = null
	var/image/I = image(icon,src,new_icon_state)
	attachable_overlays["special"] = I
	overlays += I

/obj/item/weapon/gun/proc/update_force_list()
	switch(force)
		if(-50 to 15) attack_verb = list("struck", "hit", "bashed") //Unlikely to ever be -50, but just to be safe.
		if(16 to 35) attack_verb = list("smashed", "struck", "whacked", "beaten", "cracked")
		else attack_verb = list("slashed", "stabbed", "speared", "torn", "punctured", "pierced", "gored") //Greater than 35

/obj/item/weapon/gun/proc/get_active_firearm(mob/user, restrictive = TRUE)
	if(!ishuman(usr)) return
	if(!user.canmove || user.stat || user.is_mob_restrained() || !user.loc || !isturf(usr.loc))
		to_chat(user, SPAN_WARNING("Not right now."))
		return

	var/obj/item/weapon/gun/G = user.get_held_item()

	if(!istype(G) && !restrictive)
		G = user.get_inactive_hand()
	if(!istype(G) && G != null)
		G = user.get_active_hand()
	if(!istype(G) && restrictive)
		to_chat(user, SPAN_WARNING("You need a gun in your active hand to do that!"))
		return

	if(G?.flags_gun_features & GUN_BURST_FIRING)
		return

	return G

//----------------------------------------------------------
					//				   \\
					// GUN VERBS PROCS \\
					//				   \\
					//				   \\
//----------------------------------------------------------



/mob/living/carbon/human/proc/can_unholster_from_storage_slot(var/obj/item/storage/slot)
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
		return FALSE

	if(istype(slot) && (slot.storage_flags & STORAGE_ALLOW_QUICKDRAW))
		for(var/obj/cycled_weapon in slot.return_inv())
			if(isweapon(cycled_weapon))
				return slot

	if(isweapon(slot)) //then check for weapons
		return slot

	return FALSE

//For the holster hotkey
/mob/living/silicon/robot/verb/holster_verb(var/unholster_number_offset = 1 as num)
	set name = "holster"
	set hidden = 1
	uneq_active()

/mob/living/carbon/human/verb/holster_verb(var/unholster_number_offset = 1 as num)
	set name = "holster"
	set hidden = 1
	if(usr.is_mob_incapacitated(TRUE) || usr.is_mob_restrained())
		to_chat(src, SPAN_WARNING("You can't draw a weapon in your current state."))
		return

	var/obj/item/W = get_active_hand()
	if(W)
		if(w_uniform)
			for(var/obj/A in w_uniform.accessories)
				var/obj/item/storage/internal/accessory/holster/H = A
				if(istype(H) && !H.current_gun && H.can_be_inserted(W))
					H._item_insertion(W, src)
					return

				var/obj/item/clothing/accessory/storage/holster/HS = A
				if(istype(HS))
					var/obj/item/storage/internal/accessory/holster/S = HS.hold
					if(S.can_be_inserted(W, TRUE))
						S.handle_item_insertion(W, user = src)
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

	var/obj/item/weapon/gun/G = get_active_firearm(usr, FALSE) // don't see why it should be restrictive

	if(!G)
		return

	src = G

	if(usr.action_busy)
		return

	if(zoom)
		to_chat(usr, SPAN_WARNING("You cannot conceivably do that while looking down \the [src]'s scope!"))
		return

	var/list/choices = list()
	var/list/choice_to_attachment = list()
	for(var/slot in attachments)
		var/obj/item/attachable/R = attachments[slot]
		if(R && (R.flags_attach_features & ATTACH_REMOVABLE))
			var/capitalized_name = capitalize_first_letters(R.name)
			choices[capitalized_name] = image(icon = R.icon, icon_state = R.icon_state)
			choice_to_attachment[capitalized_name] = R

	if(!length(choices))
		to_chat(usr, SPAN_WARNING("[src] has no removable attachments."))
		return

	var/obj/item/attachable/A
	if(length(choices) == 1)
		A = choice_to_attachment[choices[1]]
	else
		var/use_radials = usr.client.prefs?.no_radials_preference ? FALSE : TRUE
		var/choice = use_radials ? show_radial_menu(usr, usr, choices, require_near = TRUE) : tgui_input_list(usr, "Which attachment to remove?", "Remove Attachment", choices)
		A = choice_to_attachment[choice]

	if(!A || get_active_firearm(usr) != src || usr.action_busy || zoom || (!(A == attachments[A.slot])) || !(A.flags_attach_features & ATTACH_REMOVABLE))
		return

	usr.visible_message(SPAN_NOTICE("[usr] begins stripping [A] from [src]."),
	SPAN_NOTICE("You begin stripping [A] from [src]."), null, 4)

	if(!do_after(usr, 1.5 SECONDS, INTERRUPT_ALL, BUSY_ICON_FRIENDLY))
		return

	if(!(A == attachments[A.slot]))
		return
	if(!(A.flags_attach_features & ATTACH_REMOVABLE))
		return

	if(zoom)
		return

	usr.visible_message(SPAN_NOTICE("[usr] strips [A] from [src]."),
	SPAN_NOTICE("You strip [A] from [src]."), null, 4)
	A.Detach(src)

	playsound(src, 'sound/handling/attachment_remove.ogg', 15, 1, 4)
	update_icon()

/obj/item/weapon/gun/verb/toggle_burst()
	set category = "Weapons"
	set name = "Toggle Burst Fire Mode"
	set desc = "Toggle on or off your weapon burst mode, if it has one. Greatly reduces accuracy."
	set src = usr.contents

	var/obj/item/weapon/gun/G = get_active_firearm(usr)
	if(!G) return
	src = G

	//Burst of 1 doesn't mean anything. The weapon will only fire once regardless.
	//Just a good safety to have all weapons that can equip a scope with 1 burst_amount.
	if(burst_amount < 2 && !(flags_gun_features & GUN_HAS_FULL_AUTO))
		to_chat(usr, SPAN_WARNING("This weapon does not have a burst fire mode!"))
		return

	if(flags_gun_features & GUN_BURST_FIRING)//can't toggle mid burst
		return

	if(flags_gun_features & GUN_BURST_ONLY)
		if(!(flags_gun_features & GUN_BURST_ON))
			stack_trace("[src] has GUN_BURST_ONLY flag but not GUN_BURST_ON.")
			flags_gun_features |= GUN_BURST_ON
			return

		to_chat(usr, SPAN_NOTICE("\The [src] can only be fired in bursts!"))
		return

	if(flags_gun_features & GUN_FULL_AUTO_ONLY)
		if(!(flags_gun_features & GUN_FULL_AUTO_ON))
			stack_trace("[src] has GUN_FULL_AUTO_ONLY flag but not GUN_FULL_AUTO_ON.")
			flags_gun_features |= GUN_FULL_AUTO_ON
			RegisterSignal(usr.client, COMSIG_CLIENT_LMB_DOWN, .proc/full_auto_start)
			RegisterSignal(usr.client, COMSIG_CLIENT_LMB_UP, .proc/full_auto_stop)
			RegisterSignal(usr.client, COMSIG_CLIENT_LMB_DRAG, .proc/full_auto_new_target)
			return

		to_chat(usr, SPAN_NOTICE("\The [src] can only be fired in full auto mode!"))
		return

	playsound(usr, 'sound/weapons/handling/gun_burst_toggle.ogg', 15, 1)

	if(flags_gun_features & GUN_HAS_FULL_AUTO)
		if((flags_gun_features & GUN_BURST_ON) || (burst_amount < 2 && !(flags_gun_features & GUN_FULL_AUTO_ON)))
			flags_gun_features &= ~GUN_BURST_ON
			flags_gun_features |= GUN_FULL_AUTO_ON

			// Register the full auto click listeners
			RegisterSignal(usr.client, COMSIG_CLIENT_LMB_DOWN, .proc/full_auto_start)
			RegisterSignal(usr.client, COMSIG_CLIENT_LMB_UP, .proc/full_auto_stop)
			RegisterSignal(usr.client, COMSIG_CLIENT_LMB_DRAG, .proc/full_auto_new_target)

			to_chat(usr, SPAN_NOTICE("[icon2html(src, usr)] You set [src] to full auto mode."))
			return
		else if(flags_gun_features & GUN_FULL_AUTO_ON)
			flags_gun_features &= ~GUN_FULL_AUTO_ON
			full_auto_stop() // If the LMBUP hasn't been called for any reason.
			UnregisterSignal(usr.client, list(
				COMSIG_CLIENT_LMB_DOWN,
				COMSIG_CLIENT_LMB_UP,
				COMSIG_CLIENT_LMB_DRAG,
			))

			to_chat(usr, SPAN_NOTICE("[icon2html(src, usr)] You set [src] to single fire mode."))
			return


	flags_gun_features ^= GUN_BURST_ON
	to_chat(usr, SPAN_NOTICE("[icon2html(src, usr)] You [flags_gun_features & GUN_BURST_ON ? "<B>enable</b>" : "<B>disable</b>"] [src]'s burst fire mode."))


/obj/item/weapon/gun/verb/empty_mag()
	set category = "Weapons"
	set name = "Unload Weapon"
	set desc = "Removes the magazine from your current gun and drops it on the ground, or clears the chamber if your gun is already empty."
	set src = usr.contents

	var/mob/user = usr
	var/obj/item/weapon/gun/G = get_active_firearm(user)
	if(!G)
		return
	src = G
	if(G.active_attachable)
		// unload the attachment
		var/drop_to_ground = TRUE
		if(user.client?.prefs && (user.client?.prefs?.toggle_prefs & TOGGLE_EJECT_MAGAZINE_TO_HAND))
			drop_to_ground = FALSE
			unwield(user)
		if(G.active_attachable.unload_attachment(usr, FALSE, drop_to_ground))
			return

	//unloading a regular gun
	var/drop_to_ground = TRUE
	if(user.client?.prefs && (user.client?.prefs?.toggle_prefs & TOGGLE_EJECT_MAGAZINE_TO_HAND))
		drop_to_ground = FALSE
		unwield(user)
		if(!(G.flags_gun_features & GUN_INTERNAL_MAG))
			user.swap_hand()

	unload(user, FALSE, drop_to_ground) //We want to drop the mag on the ground.

/obj/item/weapon/gun/verb/use_unique_action()
	set category = "Weapons"
	set name = "Unique Action"
	set desc = "Use anything unique your firearm is capable of. Includes pumping a shotgun or spinning a revolver. If you have an active attachment, this will activate on the attachment instead."
	set src = usr.contents

	var/obj/item/weapon/gun/G = get_active_firearm(usr)
	if(!G) return
	if(G.active_attachable)
		src = G.active_attachable
	else
		src = G

	unique_action(usr)


/obj/item/weapon/gun/verb/toggle_gun_safety()
	set category = "Weapons"
	set name = "Toggle Gun Safety"
	set desc = "Toggle the safety of the held gun."
	set src = usr.contents //We want to make sure one is picked at random, hence it's not in a list.

	var/obj/item/weapon/gun/G = get_active_firearm(usr,FALSE) // safeties shouldn't be restrictive

	if(!G)
		return

	src = G

	if(flags_gun_features & GUN_BURST_FIRING)
		return

	if(!ishuman(usr))
		return

	if(usr.is_mob_incapacitated() || !usr.loc || !isturf(usr.loc))
		to_chat(usr, "Not right now.")
		return

	flags_gun_features ^= GUN_TRIGGER_SAFETY
	gun_safety_message(usr)


/obj/item/weapon/gun/proc/gun_safety_message(var/mob/user)
	to_chat(user, SPAN_NOTICE("You toggle the safety [SPAN_BOLD(flags_gun_features & GUN_TRIGGER_SAFETY ? "on" : "off")]."))
	playsound(user, 'sound/weapons/handling/safety_toggle.ogg', 25, 1)

/obj/item/weapon/gun/verb/activate_attachment_verb()
	set category = "Weapons"
	set name = "Use Attachment"
	set desc = "Activates one of the attached attachments on the gun."
	set src = usr.contents

	var/obj/item/weapon/gun/G = get_active_firearm(usr, FALSE)
	if(!G) return
	src = G

	var/obj/item/attachable/A

	var/usable_attachments[] = list() //Basic list of attachments to compare later.
	for(var/slot in attachments)
		var/obj/item/attachable/R = attachments[slot]
		if(R && (R.flags_attach_features & ATTACH_ACTIVATION) )
			usable_attachments += R

	if(!usable_attachments.len) //No usable attachments.
		to_chat(usr, SPAN_WARNING("[src] does not have any usable attachments!"))
		return

	if(usable_attachments.len == 1) //Activates the only attachment if there is only one.
		A = usable_attachments[1]
	else
		A = tgui_input_list(usr, "Which attachment to activate?", "Activate attachment", usable_attachments)
		if(!A || A.loc != src)
			return
	if(A)
		A.activate_attachment(src, usr)

/obj/item/weapon/gun/verb/activate_rail_attachment_verb()
	set category = "Weapons"
	set name = "Use Rail Attachment"
	set desc = "Use the attachment that is mounted on your rail."
	set src = usr.contents

	var/obj/item/weapon/gun/G = get_active_firearm(usr, FALSE)
	if(!G) return
	src = G

	var/obj/item/attachable/A = attachments["rail"]
	if(A)
		A.activate_attachment(src, usr)
	else
		to_chat(usr, SPAN_WARNING("[src] does not have any usable rail attachments!"))
		return

/obj/item/weapon/gun/verb/toggle_auto_eject_verb()
	set category = "Weapons"
	set	name = "Toggle Auto Eject"
	set desc = "Enable/Disable the gun's magazine ejection system"
	set src = usr.contents

	var/obj/item/weapon/gun/G = get_active_firearm(usr)
	if(!G) return
	src = G

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

	var/obj/item/weapon/gun/G = get_active_firearm(usr,FALSE)
	if(!G) return
	src = G

	var/obj/item/attachable/A = attachments["under"]
	if(A)
		A.activate_attachment(src, usr)
	else
		to_chat(usr, SPAN_WARNING("[src] does not have any usable underbarrel attachments!"))
		return

/obj/item/weapon/gun/verb/toggle_stock_attachment_verb()
	set category = "Weapons"
	set name = "Toggle Stock Attachment"
	set desc = "Use the stock attachment that is mounted on your gun."
	set src = usr.contents

	var/obj/item/weapon/gun/G = get_active_firearm(usr, FALSE) // incase someone
	if(!G) return
	src = G

	var/obj/item/attachable/A = attachments["stock"]
	if(A)
		A.activate_attachment(src, usr)
	else
		to_chat(usr, SPAN_WARNING("[src] does not have any usable stock attachments!"))
		return


/obj/item/weapon/gun/item_action_slot_check(mob/user, slot)
	if(slot != WEAR_L_HAND && slot != WEAR_R_HAND)
		return FALSE
	return TRUE
