/obj/item
	name = "item"
	icon = 'icons/obj/items/items.dmi'
	mouse_drag_pointer = MOUSE_ACTIVE_POINTER
	var/image/blood_overlay = null //this saves our blood splatter overlay, which will be processed not to go over the edges of the sprite
	var/randpixel = 6

	var/item_state = null //if you don't want to use icon_state for onmob inhand/belt/back/ear/suitstorage/glove sprite.
						//e.g. most headsets have different icon_state but they all use the same sprite when shown on the mob's ears.
						//also useful for items with many icon_state values when you don't want to make an inhand sprite for each value.
	var/r_speed = 1.0
	var/force = 0
	var/damtype = "brute"
	var/embeddable = TRUE //FALSE if unembeddable
	var/embedded_organ = null
	var/attack_speed = 11  //+3, Adds up to 10.  Added an extra 4 removed from /mob/proc/do_click()
	var/list/attack_verb = list() //Used in attackby() to say how something was attacked "[x] has been [z.attack_verb] by [y] with [z]"

	health = null

	rebounds = TRUE

	var/sharp = 0		// whether this item cuts
	var/edge = 0		// whether this item is more likely to dismember
	var/pry_capable = 0 //whether this item can be used to pry things open.
	var/heat_source = 0 //whether this item is a source of heat, and how hot it is (in Kelvin).

	var/hitsound = null
	var/center_of_mass = "x=16;y=16"
	var/w_class = SIZE_MEDIUM
	var/storage_cost = null
	flags_atom = FPRINT
	var/flags_item = NO_FLAGS	//flags for item stuff that isn't clothing/equipping specific.
	var/flags_equip_slot = NO_FLAGS		//This is used to determine on which slots an item can fit.

	//Since any item can now be a piece of clothing, this has to be put here so all items share it.
	var/flags_inventory = NO_FLAGS //This flag is used for various clothing/equipment item stuff
	var/flags_inv_hide = NO_FLAGS //This flag is used to determine when items in someone's inventory cover others. IE helmets making it so you can't see glasses, etc.

	var/obj/item/master = null

	var/flags_armor_protection = NO_FLAGS //see setup.dm for appropriate bit flags
	var/flags_heat_protection = NO_FLAGS //flags which determine which body parts are protected from heat. Use the HEAD, UPPER_TORSO, LOWER_TORSO, etc. flags. See setup.dm
	var/flags_cold_protection = NO_FLAGS //flags which determine which body parts are protected from cold. Use the HEAD, UPPER_TORSO, LOWER_TORSO, etc. flags. See setup.dm

	var/max_heat_protection_temperature //Set this variable to determine up to which temperature (IN KELVIN) the item protects against heat damage. Keep at null to disable protection. Only protects areas set by flags_heat_protection flags
	var/min_cold_protection_temperature //Set this variable to determine down to which temperature (IN KELVIN) the item protects against cold damage. 0 is NOT an acceptable number due to if(varname) tests!! Keep at null to disable protection. Only protects areas set by flags_cold_protection flags

	var/list/actions = list() //list of /datum/action's that this item has.
	var/list/actions_types = list() //list of paths of action datums to give to the item on New().

	//var/heat_transfer_coefficient = 1 //0 prevents all transfers, 1 is invisible
	var/gas_transfer_coefficient = 1 // for leaking gas from turf to mask and vice-versa (for masks right now, but at some point, i'd like to include space helmets)
	var/permeability_coefficient = 1 // for chemicals/diseases
	var/siemens_coefficient = 1 // for electrical admittance/conductance (electrocution checks and shit)
	var/slowdown = 0 // How much clothing is slowing you down. Negative values speeds you up

	var/list/allowed = null //suit storage stuff.
	var/zoomdevicename = null //name used for message when binoculars/scope is used
	var/zoom = 0 //1 if item is actively being used to zoom. For scoped guns and binoculars.

	var/list/uniform_restricted //Need to wear this uniform to equip this

	var/time_to_equip = 0 // set to ticks it takes to equip a worn suit.
	var/time_to_unequip = 0 // set to ticks it takes to unequip a worn suit.

	var/icon_override = null  //Used to override hardcoded ON-MOB clothing dmis in human clothing proc (i.e. not the icon_state sprites).

	var/datum/event/event_dropped = null
	var/datum/event/event_unwield = null

	var/list/sprite_sheets = list()
	var/list/item_icons = list()

	var/list/item_state_slots = list() //overrides the default

	var/mob/living/carbon/human/locked_to_mob = null	// If the item uses flag MOB_LOCK_ON_PICKUP, this is the mob owner reference.

	var/list/equip_sounds = list() //Sounds played when this item is equipped
	var/list/unequip_sounds = list() //Same but when unequipped

	var/map_specific_decoration = FALSE
	var/blood_color = "" //color of the blood on us if there's any.
	appearance_flags = KEEP_TOGETHER //taken from blood.dm
	var/global/list/blood_overlay_cache = list() //taken from blood.dm

/obj/item/proc/on_dropped()
	if(event_dropped)
		event_dropped.fire_event(src)

/obj/item/proc/add_dropped_handler(datum/event_handler/handler)
	if(!event_dropped)
		event_dropped = new /datum/event()
	event_dropped.add_handler(handler)

/obj/item/proc/remove_dropped_handler(datum/event_handler/handler)
	if(event_dropped)
		event_dropped.remove_handler(handler)

/obj/item/proc/on_unwield()
	if(event_unwield)
		event_unwield.fire_event(src)

/obj/item/proc/add_unwield_handler(datum/event_handler/handler)
	if(!event_unwield)
		event_unwield = new /datum/event()
	event_unwield.add_handler(handler)

/obj/item/proc/remove_unwield_handler(datum/event_handler/handler)
	if(event_unwield)
		event_unwield.remove_handler(handler)

/obj/item/New(loc)
	..()

	item_list += src
	for(var/path in actions_types)
		new path(src)
	if(w_class <= SIZE_MEDIUM) //pulling small items doesn't slow you down much
		drag_delay = 1

/obj/item/Destroy()
	flags_item &= ~DELONDROP //to avoid infinite loop of unequip, delete, unequip, delete.
	flags_item &= ~NODROP //so the item is properly unequipped if on a mob.
	QDEL_NULL_LIST(actions)
	QDEL_NULL(event_unwield)
	QDEL_NULL(event_dropped)
	master = null
	locked_to_mob = null
	item_list -= src

	var/obj/item/storage/S = loc
	if(istype(S))
		for(var/mob/M in S.can_see_content())
			if(M.client)
				M.client.screen -= src

	return ..()

/obj/item/ex_act(severity, explosion_direction)
	switch(severity)
		if(0 to EXPLOSION_THRESHOLD_LOW)
			if(prob(5))
				if(!indestructible)
					qdel(src)
			else
				explosion_throw(severity, explosion_direction)
		if(EXPLOSION_THRESHOLD_LOW to EXPLOSION_THRESHOLD_MEDIUM)
			if(prob(50))
				if(!indestructible)
					qdel(src)
			else
				explosion_throw(severity, explosion_direction)
		if(EXPLOSION_THRESHOLD_MEDIUM to INFINITY)
			if(!indestructible)
				qdel(src)

/obj/item/mob_launch_collision(var/mob/living/L)
	forceMove(L.loc)
	..()

//user: The mob that is suiciding
//damagetype: The type of damage the item will inflict on the user
//BRUTELOSS = 1
//FIRELOSS = 2
//TOXLOSS = 4
//OXYLOSS = 8
//Output a creative message and then return the damagetype done
/obj/item/proc/suicide_act(mob/user)
	return

/obj/item/verb/move_to_top()
	set name = "Move To Top"
	set category = "Object"
	set src in oview(1)

	if(!istype(src.loc, /turf) || usr.stat || usr.is_mob_restrained() )
		return

	var/turf/T = src.loc

	src.loc = null

	src.loc = T

/*Global item proc for all of your unique item skin needs. Works with any
item, and will change the skin to whatever you specify here. You can also
manually override the icon with a unique skin if wanted, for the outlier
cases. Override_icon_state should be a list.*/
/obj/item/proc/select_gamemode_skin(expected_type, list/override_icon_state, list/override_protection)
	if(type == expected_type && !istype(src, /obj/item/clothing/suit/storage/marine/fluff) && !istype(src, /obj/item/clothing/head/helmet/marine/fluff) && !istype(src, /obj/item/clothing/under/marine/fluff))
		var/new_icon_state
		var/new_protection
		var/new_item_state
		if(override_icon_state && override_icon_state.len)
			new_icon_state = override_icon_state[map_tag]
		if(override_protection && override_protection.len)
			new_protection = override_protection[map_tag]
		switch(map_tag)
			if(MAP_ICE_COLONY, MAP_CORSAT, MAP_SOROKYNE_STRATA)
				icon_state = new_icon_state ? new_icon_state : "s_" + icon_state
				item_state = new_item_state ? new_item_state : "s_" + item_state
			if(MAP_WHISKEY_OUTPOST, MAP_DESERT_DAM, MAP_BIG_RED, MAP_KUTJEVO)
				icon_state = new_icon_state ? new_icon_state : "d_" + icon_state
				item_state = new_item_state ? new_item_state : "d_" + item_state
			if(MAP_PRISON_STATION)
				icon_state = new_icon_state ? new_icon_state : "c_" + icon_state
				item_state = new_item_state ? new_item_state : "c_" + item_state
		if(new_protection)
			min_cold_protection_temperature = new_protection
	else return


/obj/item/examine(mob/user)
	var/size
	switch(w_class)
		if(SIZE_TINY)
			size = "tiny"
		if(SIZE_SMALL)
			size = "small"
		if(SIZE_MEDIUM)
			size = "normal-sized"
		if(SIZE_LARGE)
			size = "bulky"
		if(SIZE_HUGE)
			size = "huge"
		if(SIZE_MASSIVE)
			size = "massive"
		else
	to_chat(user, "This is a [blood_color ? blood_color != "#030303" ? "bloody " : "oil-stained " : ""][htmlicon(src, user)][src.name]. It is a [size] item.")
	if(desc)
		to_chat(user, desc)

/obj/item/attack_hand(mob/user)
	if (!user) return

	if(anchored)
		to_chat(user, "[src] is anchored to the ground.")
		return

	if(!Adjacent(user)) // needed because of alt-click
		if(src.clone && !src.clone.Adjacent(user)) // Is the clone adjacent?
			return

	if(istype(loc, /obj/item/weapon/gun)) // more alt-click hijinx
		return

	if(isstorage(loc))
		var/obj/item/storage/S = loc
		S.remove_from_storage(src, user.loc)

	throwing = 0

	if(loc == user)
		if(!user.drop_inv_item_on_ground(src))
			return
	else
		user.next_move = max(user.next_move+2,world.time + 2)
	if(!QDELETED(src)) //item may have been qdel'd by the drop above.
		pickup(user)
		add_fingerprint(user)
		if(!user.put_in_active_hand(src))
			dropped(user)

// Due to storage type consolidation this should get used more now.
// I have cleaned it up a little, but it could probably use more.  -Sayu
/obj/item/attackby(obj/item/W, mob/user)
	if(istype(W,/obj/item/storage))
		var/obj/item/storage/S = W
		if(S.storage_flags & STORAGE_CLICK_GATHER && isturf(loc))
			if(S.storage_flags & STORAGE_GATHER_SIMULTAENOUSLY) //Mode is set to collect all items on a tile and we clicked on a valid one.
				var/list/rejections = list()
				var/success = 0
				var/failure = 0

				for(var/obj/item/I in src.loc)
					if(I.type in rejections) // To limit bag spamming: any given type only complains once
						continue
					if(!S.can_be_inserted(I))	// Note can_be_inserted still makes noise when the answer is no
						rejections += I.type	// therefore full bags are still a little spammy
						failure = 1
						continue
					success = 1
					S.handle_item_insertion(I, TRUE, user)	//The 1 stops the "You put the [src] into [S]" insertion message from being displayed.
				if(success && !failure)
					to_chat(user, SPAN_NOTICE("You put everything in [S]."))
				else if(success)
					to_chat(user, SPAN_NOTICE("You put some things in [S]."))
				else
					to_chat(user, SPAN_NOTICE("You fail to pick anything up with [S]."))

			else if(S.can_be_inserted(src))
				S.handle_item_insertion(src, FALSE, user)

	return

/obj/item/proc/talk_into(mob/M as mob, text)
	return

/obj/item/proc/moved(mob/user as mob, old_loc as turf)
	return

// apparently called whenever an item is removed from a slot, container, or anything else.
//the call happens after the item's potential loc change.
/obj/item/proc/dropped(mob/user as mob)
	on_dropped()

	for(var/X in actions)
		var/datum/action/A = X
		A.remove_action(user)

	if(flags_item & DELONDROP)
		qdel(src)

	SEND_SIGNAL(src, COMSIG_ITEM_DROPPED, user)

// called just as an item is picked up (loc is not yet changed)
/obj/item/proc/pickup(mob/user)
	src.dir = SOUTH//Always rotate it south. This resets it to default position, so you wouldn't be putting things on backwards
	return

// called when this item is removed from a storage item, which is passed on as S. The loc variable is already set to the new destination before this is called.
/obj/item/proc/on_exit_storage(obj/item/storage/S as obj)
	return

// called when this item is added into a storage item, which is passed on as S. The loc variable is already set to the storage item.
/obj/item/proc/on_enter_storage(obj/item/storage/S as obj)
	return

// called when "found" in pockets and storage items. Returns 1 if the search should end.
/obj/item/proc/on_found(mob/finder as mob)
	return

// called after an item is placed in an equipment slot
// user is mob that equipped it
// slot uses the slot_X defines found in setup.dm
// for items that can be placed in multiple slots
// note this isn't called during the initial dressing of a player
/obj/item/proc/equipped(mob/user, slot)
	if((flags_item & MOB_LOCK_ON_EQUIP) && !locked_to_mob)
		locked_to_mob = user

	src.dir = SOUTH//Always rotate it south. This resets it to default position, so you wouldn't be putting things on backwards
	for(var/X in actions)
		var/datum/action/A = X
		if(item_action_slot_check(user, slot)) //some items only give their actions buttons when in a specific slot.
			A.give_action(user)

//sometimes we only want to grant the item's action if it's equipped in a specific slot.
/obj/item/proc/item_action_slot_check(mob/user, slot)
	return TRUE

// The mob M is attempting to equip this item into the slot passed through as 'slot'. Return 1 if it can do this and 0 if it can't.
// If you are making custom procs but would like to retain partial or complete functionality of this one, include a 'return ..()' to where you want this to happen.
// Set disable_warning to 1 if you wish it to not give you outputs.
// warning_text is used in the case that you want to provide a specific warning for why the item cannot be equipped.
/obj/item/proc/mob_can_equip(M as mob, slot, disable_warning = 0)
	if(!slot)
		return FALSE
	if(!M)
		return FALSE

	if(flags_item & MOB_LOCK_ON_EQUIP && locked_to_mob)
		if(locked_to_mob.undefibbable && locked_to_mob.stat == DEAD || QDELETED(locked_to_mob))
			locked_to_mob = null

		if(locked_to_mob != M)
			if(!disable_warning)
				to_chat(M, SPAN_WARNING("This item has been ID-locked to [locked_to_mob]."))
			return FALSE

	if(ishuman(M))
		//START HUMAN
		var/mob/living/carbon/human/H = M
		var/list/mob_equip = list()
		if(H.hud_used && H.hud_used.equip_slots)
			mob_equip = H.hud_used.equip_slots

		if(H.species && !(slot in mob_equip))
			return FALSE

		switch(slot)
			if(WEAR_L_HAND)
				if(H.l_hand)
					return FALSE
				return 1
			if(WEAR_R_HAND)
				if(H.r_hand)
					return FALSE
				return 1
			if(WEAR_FACE)
				if(H.wear_mask)
					return FALSE
				if(!(flags_equip_slot & SLOT_FACE))
					return FALSE
				return 1
			if(WEAR_BACK)
				if(H.back)
					return FALSE
				if(!(flags_equip_slot & SLOT_BACK))
					return FALSE
				return 1
			if(WEAR_JACKET)
				if(H.wear_suit)
					return FALSE
				if(!(flags_equip_slot & SLOT_OCLOTHING))
					return FALSE
				return 1
			if(WEAR_HANDS)
				if(H.gloves)
					return FALSE
				if(!(flags_equip_slot & SLOT_HANDS))
					return FALSE
				return 1
			if(WEAR_FEET)
				if(H.shoes)
					return FALSE
				if(!(flags_equip_slot & SLOT_FEET))
					return FALSE
				return 1
			if(WEAR_WAIST)
				if(H.belt)
					return FALSE
				if(!H.w_uniform && (WEAR_BODY in mob_equip))
					if(!disable_warning)
						to_chat(H, SPAN_WARNING("You need a jumpsuit before you can attach this [name]."))
					return FALSE
				if(!(flags_equip_slot & SLOT_WAIST))
					return
				return 1
			if(WEAR_EYES)
				if(H.glasses)
					return FALSE
				if(!(flags_equip_slot & SLOT_EYES))
					return FALSE
				return 1
			if(WEAR_HEAD)
				if(H.head)
					return FALSE
				if(!(flags_equip_slot & SLOT_HEAD))
					return FALSE
				return 1
			if(WEAR_EAR)
				if(H.wear_ear)
					return FALSE
				if(!(flags_equip_slot & SLOT_EAR))
					return FALSE
				return 1
			if(WEAR_BODY)
				if(H.w_uniform)
					return FALSE
				if(!(flags_equip_slot & SLOT_ICLOTHING))
					return FALSE
				return 1
			if(WEAR_ID)
				if(H.wear_id)
					return FALSE
				if(!(flags_equip_slot & SLOT_ID))
					return FALSE
				return 1
			if(WEAR_L_STORE)
				if(H.l_store)
					return FALSE
				if(!H.w_uniform && (WEAR_BODY in mob_equip))
					if(!disable_warning)
						to_chat(H, SPAN_WARNING("You need a jumpsuit before you can attach this [name]."))
					return FALSE
				if(flags_equip_slot & SLOT_NO_STORE)
					return FALSE
				if(w_class <= SIZE_SMALL || (flags_equip_slot & SLOT_STORE))
					return 1
			if(WEAR_R_STORE)
				if(H.r_store)
					return FALSE
				if(!H.w_uniform && (WEAR_BODY in mob_equip))
					if(!disable_warning)
						to_chat(H, SPAN_WARNING("You need a jumpsuit before you can attach this [name]."))
					return FALSE
				if(flags_equip_slot & SLOT_NO_STORE)
					return FALSE
				if(w_class <= SIZE_SMALL || (flags_equip_slot & SLOT_STORE))
					return 1
				return FALSE
			if(WEAR_J_STORE)
				if(H.s_store)
					return FALSE
				if(!H.wear_suit && (WEAR_JACKET in mob_equip))
					if(!disable_warning)
						to_chat(H, SPAN_WARNING("You need a suit before you can attach this [name]."))
					return FALSE
				if(H.wear_suit && !H.wear_suit.allowed)
					if(!disable_warning)
						to_chat(usr, "You somehow have a suit with no defined allowed items for suit storage, stop that.")
					return FALSE
				if(istype(src, /obj/item/tool/pen) ||(H.wear_suit && is_type_in_list(src, H.wear_suit.allowed)))
					return 1
				return FALSE
			if(WEAR_HANDCUFFS)
				if(H.handcuffed)
					return FALSE
				if(!istype(src, /obj/item/handcuffs))
					return FALSE
				return 1
			if(WEAR_LEGCUFFS)
				if(H.legcuffed)
					return FALSE
				if(!istype(src, /obj/item/legcuffs))
					return FALSE
				return 1
			if(WEAR_IN_ACCESSORY)
				if(H.w_uniform)
					for(var/obj/item/clothing/accessory/storage/T in H.w_uniform.accessories)
						var/obj/item/storage/internal/I = T.hold
						if(I.can_be_inserted(src, 1))
							return 1
				return FALSE
			if(WEAR_IN_JACKET)
				if(H.wear_suit)
					var/obj/item/clothing/suit/storage/S = H.wear_suit
					if(istype(S) && S.pockets)//not all suits have pockits
						var/obj/item/storage/internal/I = S.pockets
						if(I.can_be_inserted(src,1))
							return 1
				return FALSE
			if(WEAR_IN_BACK)
				if (H.back && isstorage(H.back))
					var/obj/item/storage/B = H.back
					if(B.can_be_inserted(src, 1))
						return 1
				return FALSE
			if(WEAR_IN_SHOES)
				if(H.shoes && istype(H.shoes, /obj/item/clothing/shoes))
					var/obj/item/clothing/shoes/S = H.shoes
					if(!S.stored_item && S.items_allowed && S.items_allowed.len)
						for (var/i in S.items_allowed)
							if(istype(src, i))
								return 1
				return FALSE
			if(WEAR_IN_SCABBARD)
				if(H.back && istype(H.back, /obj/item/storage/large_holster))
					var/obj/item/storage/large_holster/B = H.back
					if(B.can_be_inserted(src, 1))
						return 1
				return FALSE
			if(WEAR_IN_BELT)
				if(H.belt &&  isstorage(H.belt))
					var/obj/item/storage/B = H.belt
					if(B.can_be_inserted(src, 1))
						return 1
				return FALSE
			if(WEAR_IN_J_STORE)
				if(H.s_store && isstorage(H.s_store))
					var/obj/item/storage/B = H.s_store
					if(B.can_be_inserted(src, 1))
						return 1
				return FALSE
			if(WEAR_IN_L_STORE)
				if(H.l_store && istype(H.l_store, /obj/item/storage/pouch))
					var/obj/item/storage/pouch/P = H.l_store
					if(P.can_be_inserted(src, 1))
						return 1
				return FALSE
			if(WEAR_IN_R_STORE)
				if(H.r_store && istype(H.r_store, /obj/item/storage/pouch))
					var/obj/item/storage/pouch/P = H.r_store
					if(P.can_be_inserted(src, 1))
						return 1
				return FALSE
		return FALSE //Unsupported slot
		//END HUMAN

/obj/item/verb/verb_pickup()
	set src in oview(1)
	set category = "Object"
	set name = "Pick up"

	if(!(usr)) //BS12 EDIT
		return
	if(!usr.canmove || usr.stat || usr.is_mob_restrained() || !Adjacent(usr))
		return
	if((!istype(usr, /mob/living/carbon)) || (istype(usr, /mob/living/brain)))//Is humanoid, and is not a brain
		to_chat(usr, SPAN_DANGER("You can't pick things up!"))
		return
	if( usr.stat || usr.is_mob_restrained() )//Is not asleep/dead and is not restrained
		to_chat(usr, SPAN_DANGER("You can't pick things up!"))
		return
	if(src.anchored) //Object isn't anchored
		to_chat(usr, SPAN_DANGER("You can't pick that up!"))
		return
	if(!usr.hand && usr.r_hand) //Right hand is not full
		to_chat(usr, SPAN_DANGER("Your right hand is full."))
		return
	if(usr.hand && usr.l_hand) //Left hand is not full
		to_chat(usr, SPAN_DANGER("Your left hand is full."))
		return
	if(!istype(src.loc, /turf)) //Object is on a turf
		to_chat(usr, SPAN_DANGER("You can't pick that up!"))
		return
	//All checks are done, time to pick it up!
	if (world.time <= usr.next_move)
		return
	usr.next_move += 6 // stop insane pickup speed
	usr.UnarmedAttack(src)
	return


//This proc is executed when someone clicks the on-screen UI button. To make the UI button show, set the 'icon_action_button' to the icon_state of the image of the button in actions.dmi
//The default action is attack_self().
//Checks before we get to here are: mob is alive, mob is not restrained, paralyzed, asleep, resting, laying, item is on the mob.
/obj/item/proc/ui_action_click()
	if(src in usr)
		attack_self(usr)


/obj/item/proc/IsShield()
	return 0

/obj/item/proc/get_loc_turf()
	var/atom/L = loc
	while(L && !istype(L, /turf/))
		L = L.loc
	return loc


/obj/item/proc/showoff(mob/user)
	for (var/mob/M in view(user))
		M.show_message("[user] holds up [src]. <a HREF=?src=\ref[M];lookitem=\ref[src]>Take a closer look.</a>",1)

/mob/living/carbon/verb/showoff()
	set name = "Show Held Item"
	set category = "Object"

	var/obj/item/I = get_active_hand()
	if(I && !(I.flags_item & ITEM_ABSTRACT))
		I.showoff(src)

/datum/event_handler/event_gun_zoom
	var/obj/item/zooming_item
	var/mob/living/calee
	flags_handler = HNDLR_FLAG_SINGLE_FIRE

/datum/event_handler/event_gun_zoom/New(obj/item/_zooming_item, mob/living/_calee)
	zooming_item = _zooming_item
	calee = _calee

/datum/event_handler/event_gun_zoom/Destroy()
	if(zooming_item)
		zooming_item.zoom_event_handler = null
		zooming_item = null
	calee = null
	. = ..()

/datum/event_handler/event_gun_zoom/handle(sender, datum/event_args/event_args)
	if(calee && calee.client) //Dropped when disconnected, whoops
		if(zooming_item && zooming_item.zoom && calee) //sanity check
			zooming_item.zoom(calee)

/*
For zooming with scope or binoculars. This is called from
modules/mob/mob_movement.dm if you move you will be zoomed out
modules/mob/living/carbon/human/life.dm if you die, you will be zoomed out.
keep_zoom - do we keep zoom during movement. be careful with setting this to 1
*/

/obj/item/var/zoom_event_handler

/obj/item/proc/zoom(mob/living/user, tileoffset = 11, viewsize = 12, keep_zoom = 0) //tileoffset is client view offset in the direction the user is facing. viewsize is how far out this thing zooms. 7 is normal view
	if(!user)
		return
	var/zoom_device = zoomdevicename ? "\improper [zoomdevicename] of [src]" : "\improper [src]"

	for(var/obj/item/I in user.contents)
		if(I.zoom && I != src)
			to_chat(user, SPAN_WARNING("You are already looking through \the [zoom_device]."))
			return //Return in the interest of not unzooming the other item. Check first in the interest of not fucking with the other clauses

	if(user.eye_blind)
		to_chat(user, SPAN_WARNING("You are too blind to see anything."))
	else if(user.stat || !ishuman(user))
		to_chat(user, SPAN_WARNING("You are unable to focus through \the [zoom_device]."))
	else if(!zoom && user.client && user.update_tint())
		to_chat(user, SPAN_WARNING("Your welding equipment gets in the way of you looking through \the [zoom_device]."))
	else if(!zoom && user.get_active_hand() != src && !istype(src, /obj/item/clothing/mask))
		to_chat(user, SPAN_WARNING("You need to hold \the [zoom_device] to look through it."))
	else if(zoom) //If we are zoomed out, reset that parameter.
		user.visible_message(SPAN_NOTICE("[user] looks up from [zoom_device]."),
		SPAN_NOTICE("You look up from [zoom_device]."))
		zoom = !zoom
		user.zoom_cooldown = world.time + 20
		user.on_zoomout(src, new /datum/event_args())
		if(zoom_event_handler)
			user.remove_movement_handler(zoom_event_handler)
			remove_dropped_handler(zoom_event_handler)
			remove_unwield_handler(zoom_event_handler)
			qdel(zoom_event_handler)
	else //Otherwise we want to zoom in.
		if(world.time <= user.zoom_cooldown) //If we are spamming the zoom, cut it out
			return
		user.zoom_cooldown = world.time + 20

		if(user.client)
			user.client.change_view(viewsize)

			if(zoom_event_handler)
				qdel(zoom_event_handler)
			zoom_event_handler = new /datum/event_handler/event_gun_zoom(src, user)
			if(!keep_zoom)
				user.add_movement_handler(zoom_event_handler)
			add_dropped_handler(zoom_event_handler)
			add_unwield_handler(zoom_event_handler)

			var/tilesize = 32
			var/viewoffset = tilesize * tileoffset

			switch(user.dir)
				if(NORTH)
					user.client.pixel_x = 0
					user.client.pixel_y = viewoffset
				if(SOUTH)
					user.client.pixel_x = 0
					user.client.pixel_y = -viewoffset
				if(EAST)
					user.client.pixel_x = viewoffset
					user.client.pixel_y = 0
				if(WEST)
					user.client.pixel_x = -viewoffset
					user.client.pixel_y = 0

		user.visible_message(SPAN_NOTICE("[user] peers through \the [zoom_device]."),
		SPAN_NOTICE("You peer through \the [zoom_device]."))
		zoom = !zoom
		if(user.interactee)
			user.unset_interaction()
		else
			user.set_interaction(src)
		return

	//General reset in case anything goes wrong, the view will always reset to default unless zooming in.
	if(user.client)
		user.client.change_view(world_view_size)
		user.client.pixel_x = 0
		user.client.pixel_y = 0

/obj/item/proc/get_icon_state(mob/user_mob, slot)
	var/mob_state
	if(item_state_slots && item_state_slots[slot])
		mob_state = item_state_slots[slot]
	else if (item_state && (slot == WEAR_R_HAND || slot == WEAR_L_HAND || slot == WEAR_ID || slot == WEAR_WAIST))
		mob_state = item_state
	else
		mob_state = icon_state
	return mob_state

