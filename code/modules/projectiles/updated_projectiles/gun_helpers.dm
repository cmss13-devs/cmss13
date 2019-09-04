/*
ERROR CODES AND WHAT THEY MEAN:


ERROR CODE A1: null ammo while reloading. <------------ Only appears when reloading a weapon and switching the .ammo. Somehow the argument passed a null.ammo.
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

	make_casing() //What the gun does to make a casing. If it just shoots them out (or doesn't make casings), the
	regular proc is fine. This proc uses .dir and icon_state to change the number of bullets spawned, and is the
	fastest I could make it. One thing to note about it is that if more casings are desired, they have to be
	pregenerated, usually by hand.

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
		unload(user)//It has to be held if it's a two hander.
	else ..()

/obj/item/weapon/gun/throw_at(atom/target, range, speed, thrower)
	if( harness_check(thrower) ) to_chat(usr, SPAN_WARNING("\The [src] clanks on the ground."))
	else ..()

/*
Note: pickup and dropped on weapons must have both the ..() to update zoom AND twohanded,
As sniper rifles have both and weapon mods can change them as well. ..() deals with zoom only.
*/
/obj/item/weapon/gun/dropped(mob/user)
	..()

	stop_aim()
	if (user && user.client)
		user.update_gun_icons()

	turn_off_light(user)

	unwield(user)
	harness_check(user)

/obj/item/weapon/gun/proc/turn_off_light(mob/bearer)
	if(flags_gun_features & GUN_FLASHLIGHT_ON)
		if(attachments["rail"])
			var/obj/item/attachable/A = attachments["rail"]
			bearer.SetLuminosity(-A.light_mod)
			SetLuminosity(A.light_mod)
			return 1
	return 0

/obj/item/weapon/gun/pickup(mob/user)
	..()

	if(flags_gun_features & GUN_FLASHLIGHT_ON)
		if(attachments["rail"])
			var/obj/item/attachable/A = attachments["rail"]
			user.SetLuminosity(A.light_mod)
			SetLuminosity(0)

	unwield(user)

/obj/item/weapon/gun/proc/wy_allowed_check(mob/living/carbon/human/user)
	if(config && config.remove_gun_restrictions) return 1 //Not if the config removed it.

	if(user.mind)
		switch(user.mind.assigned_role)
			if(
				"PMC",
				"WY Agent",
				"Corporate Liaison",
				"Event",
			) return 1
		switch(user.mind.special_role)
			if(
				"DEATH SQUAD",
				"PMC",
				"MERCENARIES",
				"FREELANCERS",
			) return 1
	to_chat(user, SPAN_WARNING("[src] flashes a warning sign indicating unauthorized use!"))

/*
Here we have throwing and dropping related procs.
This should fix some issues with throwing mag harnessed guns when
they're not supposed to be thrown. Either way, this fix
should be alright.
*/
/obj/item/weapon/gun/proc/harness_check(mob/user)
	if(user && ishuman(user))
		var/mob/living/carbon/human/owner = user
		if(has_attachment(/obj/item/attachable/magnetic_harness) || istype(src,/obj/item/weapon/gun/smartgun))
			var/obj/item/I = owner.wear_suit
			if(istype(I,/obj/item/clothing/suit/storage/marine))
				harness_return(user)
				return 1

/obj/item/weapon/gun/proc/harness_return(mob/living/carbon/human/user)
	set waitfor = 0
	sleep(3)
	if(loc && user)
		if(isnull(user.s_store) && isturf(loc))
			var/obj/item/I = user.wear_suit
			user.equip_to_slot_if_possible(src, WEAR_J_STORE)
			if(user.s_store == src)
				to_chat(user, SPAN_WARNING("[src] snaps into place on [I]."))
			user.update_inv_s_store()

/obj/item/weapon/gun/attack_self(mob/user)
	..()
	if (target)
		lower_aim()
		return

	//There are only two ways to interact here.
	if(flags_item & TWOHANDED)
		if(flags_item & WIELDED) unwield(user)//Trying to unwield it
		else wield(user)//Trying to wield it
	else unload(user)//We just unload it.

//Clicking stuff onto the gun.
//Attachables & Reloading
/obj/item/weapon/gun/attackby(obj/item/I, mob/user)
	if(flags_gun_features & GUN_BURST_FIRING) return

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
		if(user.mind && user.mind.cm_skills && user.mind.cm_skills.firearms == 0)
			to_chat(user, SPAN_WARNING("You don't know how to do tactical reloads."))
			return
		if(istype(src, AM.gun_type))
			if(current_mag)
				unload(user,0,1)
			to_chat(user, SPAN_NOTICE("You start a tactical reload."))
			var/old_mag_loc = AM.loc
			var/tac_reload_time = 15
			if(user.mind && user.mind.cm_skills)
				tac_reload_time = max(15 - 5*user.mind.cm_skills.firearms, 5)
			if(do_after(user,tac_reload_time, INTERRUPT_ALL, BUSY_ICON_FRIENDLY) && AM.loc == old_mag_loc && !current_mag)
				if(istype(AM.loc, /obj/item/storage))
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

///obj/item/weapon/gun/proc/unique_action(mob/M) //Anything unique the gun can do, like pump or spin or whatever.
//	return

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
	if(!A) return
	for(var/slot in attachments)
		var/obj/item/attachable/R = attachments[slot]
		if(R && istype(R, A))
			return 1

/obj/item/weapon/gun/proc/check_iff()
	iff_enabled_current = FALSE
	for(var/slot in attachments)
		var/obj/item/attachable/R = attachments[slot]
		if(R && R.has_marine_iff)
			iff_enabled_current = TRUE
	if(iff_enabled)
		iff_enabled_current = TRUE
	if(in_chamber) //Hi, I'm an old bullet. I don't have a fucking IFF enabled yet.
		qdel(in_chamber)
		in_chamber = create_bullet(ammo, initial(name)) //OK

/obj/item/weapon/gun/proc/can_attach_to_gun(mob/user, obj/item/attachable/attachment)
	if(attachable_allowed && !(attachment.type in attachable_allowed) )
		to_chat(user, SPAN_WARNING("[attachment] doesn't fit on [src]!"))
		return 0

	//Checks if they can attach the thing in the first place, like with fixed attachments.
	var/can_attach = 1
	if(attachments[attachment.slot])
		var/obj/item/attachable/R = attachments[attachment.slot]
		if(R && !(R.flags_attach_features & ATTACH_REMOVABLE)) can_attach = 0

	if(!can_attach)
		to_chat(user, SPAN_WARNING("The attachment on [src]'s [attachment.slot] cannot be removed!"))
		return 0
	return 1

/obj/item/weapon/gun/proc/attach_to_gun(mob/user, obj/item/attachable/attachment)
	if(!can_attach_to_gun(user, attachment))
		return

	user.visible_message(SPAN_NOTICE("[user] begins attaching [attachment] to [src]."),
	SPAN_NOTICE("You begin attaching [attachment] to [src]."), null, 4)
	if(do_after(user, 20, INTERRUPT_ALL, BUSY_ICON_FRIENDLY, numticks = 2))
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
	qdel(I)
	if(A) //Only updates if the attachment exists for that slot.
		var/item_icon = A.icon_state
		if(A.attach_icon)
			item_icon = A.attach_icon
		I = image(A.icon,src, item_icon)
		I.pixel_x = attachable_offset["[slot]_x"] - A.pixel_shift_x
		I.pixel_y = attachable_offset["[slot]_y"] - A.pixel_shift_y
		attachable_overlays[slot] = I
		overlays += I
	else attachable_overlays[slot] = null

/obj/item/weapon/gun/proc/update_mag_overlay()
	if(!attachable_overlays["mag"])
		return
	var/image/I = attachable_overlays["mag"]
	overlays -= I
	qdel(I)
	if(current_mag && current_mag.bonus_overlay)
		I = image(current_mag.icon,src,current_mag.bonus_overlay)
		attachable_overlays["mag"] = I
		overlays += I
	else attachable_overlays["mag"] = null

/obj/item/weapon/gun/proc/update_special_overlay(new_icon_state)
	overlays -= attachable_overlays["special"]
	qdel(attachable_overlays["special"])
	var/image/I = image(icon,src,new_icon_state)
	attachable_overlays["special"] = I
	overlays += I

/obj/item/weapon/gun/proc/update_force_list()
	switch(force)
		if(-50 to 15) attack_verb = list("struck", "hit", "bashed") //Unlikely to ever be -50, but just to be safe.
		if(16 to 35) attack_verb = list("smashed", "struck", "whacked", "beaten", "cracked")
		else attack_verb = list("slashed", "stabbed", "speared", "torn", "punctured", "pierced", "gored") //Greater than 35

/obj/item/weapon/gun/proc/get_active_firearm(mob/user)
	if(!ishuman(usr)) return

	if(!user.canmove || user.stat || user.is_mob_restrained() || !user.loc || !isturf(usr.loc))
		to_chat(user, SPAN_WARNING("Not right now."))
		return

	var/obj/item/weapon/gun/G = user.get_held_item()

	if(!istype(G))
		to_chat(user, SPAN_WARNING("You need a gun in your active hand to do that!"))
		return

	if(G.flags_gun_features & GUN_BURST_FIRING) return

	return G

//----------------------------------------------------------
					//				   \\
					// GUN VERBS PROCS \\
					//				   \\
					//				   \\
//----------------------------------------------------------

//For the holster hotkey
/mob/living/silicon/robot/verb/holster_verb(var/keymod = "none" as text)
	set name = "holster"
	set hidden = 1
	uneq_active()

/mob/living/carbon/human/verb/holster_verb(var/keymod = "none" as text)
	set name = "holster"
	set hidden = 1
	if(usr.is_mob_incapacitated(TRUE) || usr.is_mob_restrained())
		to_chat(src, SPAN_WARNING("You can't draw a weapon in your current state."))
		return

	var/obj/item/weapon/W = get_active_hand()
	var/obj/item/clothing/under/U = w_uniform
	var/obj/item/clothing/accessory/holster/T
	if(istype(U))
		for(var/obj/item/clothing/accessory/holster/HS in U.accessories)
			if(HS.holstered)
				continue
			T = HS
			break
	if(W)
		if(istype(T) && istype(W) && !T.holstered && T.can_holster(W))
			T.holster(W, src)
		else
			quick_equip()
	else //empty hand, start checking slots and holsters
		switch(keymod)
			if("none") //default order: uniform, suit, belt, back, pockets, shoes
				if(w_uniform)
					for(var/obj/item/clothing/accessory/holster/HS in U.accessories)
						if(istype(HS) && HS.holstered)
							w_uniform.attack_hand(src)
							return

				if(s_store)
					if(istype(s_store, /obj/item/storage)) //check storages(?)
						var/obj/item/storage/S = s_store
						for(var/obj/item/weapon/wep in S.return_inv())
							s_store.attack_hand(src)
							return
					else if(istype(s_store, /obj/item/weapon)) //then check for weapons
						s_store.attack_hand(src)
						return

				if(belt)
					if(istype(belt, /obj/item/storage/belt/gun/) || istype(belt, /obj/item/storage/large_holster)) //check belts and holsters
						var/obj/item/storage/G = belt
						for(var/obj/item/weapon/gun in G.return_inv())
							belt.attack_hand(src)
							return
					if(istype(belt, /obj/item/weapon/)) //then check for weapons
						belt.attack_hand(src)
						return

				if(back)
					if(istype(back, /obj/item/storage/large_holster)) //check holsters
						var/obj/item/storage/large_holster/B = back
						if(B.return_inv().len)
							back.attack_hand(src)
							return
					if(istype(back,/obj/item/weapon)) //then check for weapons
						back.attack_hand(src)
						return

				if(l_store)
					if(istype(l_store, /obj/item/storage/pouch))  //check pouches
						var/obj/item/storage/pouch/P = l_store
						for(var/obj/item/weapon/wep in P.return_inv())
							l_store.attack_hand(src)
							return
					if(istype(l_store, /obj/item/weapon)) //then check for weapons
						l_store.attack_hand(src)
						return

				if(r_store)
					if(istype(r_store, /obj/item/storage/pouch))  //check pouches
						var/obj/item/storage/pouch/P = r_store
						for(var/obj/item/weapon/wep in P.return_inv())
							r_store.attack_hand(src)
							return
					if(istype(r_store, /obj/item/weapon)) //then check for weapons
						r_store.attack_hand(src)
						return

				if(shoes)
					if(istype(shoes, /obj/item/clothing/shoes))
						var/obj/item/clothing/shoes/S = shoes
						if(S.stored_item && istype(S.stored_item, /obj/item/weapon))
							shoes.attack_hand(src)
							return

			if("shift") //shift keymod, do common secondary weapon locations first. order: belt, back, pockets, shoes, uniform, suit.
				if(belt)
					if(istype(belt, /obj/item/storage/belt/gun/) || istype(belt, /obj/item/storage/large_holster))
						var/obj/item/storage/G = belt
						for(var/obj/item/weapon/gun in G.return_inv())
							belt.attack_hand(src)
							return
					if(istype(belt, /obj/item/weapon/))
						belt.attack_hand(src)
						return

				if(back)
					if(istype(back, /obj/item/storage/large_holster))
						var/obj/item/storage/large_holster/B = back
						if(B.return_inv().len)
							back.attack_hand(src)
							return
					if(istype(back,/obj/item/weapon))
						back.attack_hand(src)
						return

				if(l_store)
					if(istype(l_store, /obj/item/storage/pouch))
						var/obj/item/storage/pouch/P = l_store
						for(var/obj/item/weapon/wep in P.return_inv())
							l_store.attack_hand(src)
							return
					if(istype(l_store, /obj/item/weapon))
						l_store.attack_hand(src)
						return

				if(r_store)
					if(istype(r_store, /obj/item/storage/pouch))
						var/obj/item/storage/pouch/P = r_store
						for(var/obj/item/weapon/wep in P.return_inv())
							r_store.attack_hand(src)
							return
					if(istype(r_store, /obj/item/weapon))
						r_store.attack_hand(src)
						return

				if(shoes)
					if(istype(shoes, /obj/item/clothing/shoes))
						var/obj/item/clothing/shoes/S = shoes
						if(S.stored_item && istype(S.stored_item, /obj/item/weapon))
							shoes.attack_hand(src)
							return

				if(w_uniform)
					for(var/obj/item/clothing/accessory/holster/HS in w_uniform.accessories)
						if(istype(HS) && HS.holstered)
							w_uniform.attack_hand(src)
							return

				if(s_store)
					if(istype(s_store, /obj/item/storage))
						var/obj/item/storage/S = s_store
						for(var/obj/item/weapon/wep in S.return_inv())
							s_store.attack_hand(src)
							return
					else if(istype(s_store, /obj/item/weapon))
						s_store.attack_hand(src)
						return



/obj/item/weapon/gun/verb/field_strip()
	set category = "Weapons"
	set name = "Field Strip Weapon"
	set desc = "Remove all attachables from a weapon."
	set src = usr.contents //We want to make sure one is picked at random, hence it's not in a list.

	var/obj/item/weapon/gun/G = get_active_firearm(usr)

	if(!G)
		return

	src = G

	if(usr.action_busy)
		return

	if(zoom)
		to_chat(usr, SPAN_WARNING("You cannot conceviably do that while looking down \the [src]'s scope!"))
		return

	var/list/possible_attachments = list()
	for(var/slot in attachments)
		var/obj/item/attachable/R = attachments[slot]
		if(R && (R.flags_attach_features & ATTACH_REMOVABLE))
			possible_attachments += R

	if(!possible_attachments.len)
		to_chat(usr, SPAN_WARNING("[src] has no removable attachments."))
		return

	var/obj/item/attachable/A
	if(possible_attachments.len == 1)
		A = possible_attachments[1]
	else
		A = input("Which attachment to remove?") as null|anything in possible_attachments

	if(!A || get_active_firearm(usr) != src || usr.action_busy || zoom || (!(A == attachments[A.slot])) || !(A.flags_attach_features & ATTACH_REMOVABLE))
		return

	usr.visible_message(SPAN_NOTICE("[usr] begins stripping [A] from [src]."),
	SPAN_NOTICE("You begin stripping [A] from [src]."), null, 4)

	if(!do_after(usr, 35, INTERRUPT_ALL, BUSY_ICON_FRIENDLY))
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
	if(burst_amount < 2)
		to_chat(usr, SPAN_WARNING("This weapon does not have a burst fire mode!"))
		return

	if(flags_gun_features & GUN_BURST_FIRING)//can't toggle mid burst
		return

	playsound(usr, 'sound/machines/click.ogg', 15, 1)
	if(flags_gun_features & GUN_HAS_FULL_AUTO)
		if(flags_gun_features & GUN_BURST_ON)
			if(flags_gun_features & GUN_FULL_AUTO_ON)
				flags_gun_features &= ~GUN_FULL_AUTO_ON
				flags_gun_features &= ~GUN_BURST_ON
				to_chat(usr, SPAN_NOTICE("\icon[src] You set [src] to single fire mode."))
			else
				flags_gun_features|= GUN_FULL_AUTO_ON
				to_chat(usr, SPAN_NOTICE("\icon[src] You set [src] to full auto mode."))
		else
			flags_gun_features |= GUN_BURST_ON
			to_chat(usr, SPAN_NOTICE("\icon[src] You set [src] to burst fire mode."))
	else
		flags_gun_features ^= GUN_BURST_ON

		to_chat(usr, SPAN_NOTICE("\icon[src] You [flags_gun_features & GUN_BURST_ON ? "<B>enable</b>" : "<B>disable</b>"] [src]'s burst fire mode."))


/obj/item/weapon/gun/verb/empty_mag()
	set category = "Weapons"
	set name = "Unload Weapon"
	set desc = "Removes the magazine from your current gun and drops it on the ground, or clears the chamber if your gun is already empty."
	set src = usr.contents

	var/obj/item/weapon/gun/G = get_active_firearm(usr)
	if(!G) return
	src = G

	unload(usr,,1) //We want to drop the mag on the ground.

/obj/item/weapon/gun/verb/use_unique_action()
	set category = "Weapons"
	set name = "Unique Action"
	set desc = "Use anything unique your firearm is capable of. Includes pumping a shotgun or spinning a revolver."
	set src = usr.contents

	var/obj/item/weapon/gun/G = get_active_firearm(usr)
	if(!G) return
	src = G

	unique_action(usr)


/obj/item/weapon/gun/verb/toggle_gun_safety()
	set category = "Weapons"
	set name = "Toggle Gun Safety"
	set desc = "Toggle the safety of the held gun."
	set src = usr.contents //We want to make sure one is picked at random, hence it's not in a list.

	var/obj/item/weapon/gun/G = get_active_firearm(usr)

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

	to_chat(usr, SPAN_NOTICE("You toggle the safety [flags_gun_features & GUN_TRIGGER_SAFETY ? "<b>off</b>" : "<b>on</b>"]."))
	playsound(usr, 'sound/weapons/handling/safety_toggle.ogg', 25, 1)
	flags_gun_features ^= GUN_TRIGGER_SAFETY



/obj/item/weapon/gun/verb/activate_attachment_verb()
	set category = "Weapons"
	set name = "Load From Attachment"
	set desc = "Load from a gun attachment, such as a mounted grenade launcher, shotgun, or flamethrower."
	set src = usr.contents

	var/obj/item/weapon/gun/G = get_active_firearm(usr)
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
		A = input("Which attachment to activate?") as null|anything in usable_attachments
		if(!A || A.loc != src)
			return
	if(A)
		A.activate_attachment(src, usr)

/obj/item/weapon/gun/verb/activate_rail_attachment_verb()
	set category = "Weapons"
	set name = "Use Rail Attachment"
	set desc = "Use the attachment that is mounted on your rail."
	set src = usr.contents

	var/obj/item/weapon/gun/G = get_active_firearm(usr)
	if(!G) return
	src = G

	var/obj/item/attachable/A = attachments["rail"]
	if(A)
		A.activate_attachment(src, usr)
	else
		to_chat(usr, SPAN_WARNING("[src] does not have any usable rail attachments!"))
		return

obj/item/weapon/gun/item_action_slot_check(mob/user, slot)
	if(slot != WEAR_L_HAND && slot != WEAR_R_HAND)
		return FALSE
	return TRUE


//----------------------------------------------------------
				//				   	   \\
				// UNUSED EXAMPLE CODE \\
				//				  	   \\
				//				   	   \\
//----------------------------------------------------------

	/*
	//This works, but it's also pretty slow in comparison to the updated method.
	var/turf/current_turf = get_turf(src)
	var/obj/item/ammo_casing/casing = locate() in current_turf
	var/icon/I = new( 'icons/obj/items/ammo.dmi', current_mag.icon_spent, pick(1,2,4,5,6,8,9,10) ) //Feeding dir is faster than doing Turn().
	I.Shift(pick(1,2,4,5,6,8,9,10),rand(0,11))
	if(casing) //If there is already something on the ground, takes the firs thing it finds. Can take a long time if there are a lot of things.
		//Still better than making a billion casings.
		if(casing.name != "spent casings")
			casing.name += "s"
		I.Blend(casing.icon,ICON_UNDERLAY) //We want to overlay it on top.
		casing.icon = I
	else //If not, make one.
		var/obj/item/ammo_casing/new_casing = new(current_turf)
		new_casing.icon = I
	playsound(current_turf, sound_to_play, 20, 1)
	*/

/*
//Leaving this here because I think it's excellent code in terms of something you can do. But it is not the
//most efficient. Also, this particular example crashes the client upon Blend(). Not sure what is causing it,
//but the code was entirely replaced so it's irrelevant now. ~N
//If the gun has spent shells and we either have no ammo remaining or we're reloading it on the go.
if(current_mag.casings_to_eject.len && casing_override) //We have some spent casings to eject.
	var/turf/current_turf = get_turf(src)
	var/obj/item/ammo_casing/casing = locate() in current_turf
	var/icon/G

	if(!casing)
		//Feeding dir is faster than doing Turn().
		G = new( 'icons/obj/items/ammo.dmi', current_mag.icon_spent, pick(1,2,4,5,6,8,9,10) ) //We make a new icon.
		G.Shift(pick(1,2,4,5,6,8,9,10),rand(0,11)) //Shift it randomy.
		var/obj/item/ammo_casing/new_casing = new(current_turf) //Then we create a new casing.
		new_casing.icon = G //We give this new casing the icon we just generated.
		casing = new_casing //Our casing from earlier is now this csaing.
		current_mag.casings_to_eject.Cut(1,2) //Cut the list so that it's one less.
		playsound(current_turf, sound_to_play, 20, 1) //Play the sound.

	G = casing.icon //Get the icon from the casing icon if it spawned or was there previously.
	var/i
	for(i = 1 to current_mag.casings_to_eject.len) //We want to run this for each item in the list.
		var/icon/I = new( 'icons/obj/items/ammo.dmi', current_mag.icon_spent, pick(1,2,4,5,6,8,9,10) )
		I.Shift(pick(1,2,4,5,6,8,9,10),rand(0,11))
		G.Blend(I,ICON_OVERLAY) //<---- Crashes the client. //Blend them two in, with I overlaying what's already there.
		playsound(current_turf, sound_to_play, 20, 1)

	G.Blend(casing.icon,ICON_UNDERLAY)
	casing.icon = G
	if(casing.name != "spent casings")
		casing.name += "s"
	current_mag.casings_to_eject = list() //Empty list.

else if(!casing_override)//So we're not reloading/emptying, we're firing the gun.
	//I would add a check here for attachables, but you can't fit the masterkey on a revolver/shotgun.
	current_mag.casings_to_eject += ammo.casing_type //Other attachables are processed beforehand and don't matter here.
*/
