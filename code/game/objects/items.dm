/obj/item
	name = "item"
	icon = 'icons/obj/items/items.dmi'
	mouse_drag_pointer = MOUSE_ACTIVE_POINTER
	layer = ITEM_LAYER
	light_system = MOVABLE_LIGHT
	/// this saves our blood splatter overlay, which will be processed not to go over the edges of the sprite
	var/image/blood_overlay = null
	var/randpixel = 6

	var/item_state = null //if you don't want to use icon_state for onmob inhand/belt/back/ear/suitstorage/glove sprite.
						//e.g. most headsets have different icon_state but they all use the same sprite when shown on the mob's ears.
						//also useful for items with many icon_state values when you don't want to make an inhand sprite for each value.
	/// When set to true, every single sprite can be found in the one icon .dmi, rather than being spread into onmobs, inhands, and objects
	var/contained_sprite = FALSE

	var/r_speed = 1
	var/force = 0
	var/damtype = BRUTE
	var/embeddable = TRUE //FALSE if unembeddable
	var/embedded_organ = null
	var/attack_speed = 11  //+3, Adds up to 10.  Added an extra 4 removed from /mob/proc/do_click()
	///Used in attackby() to say how something was attacked "[x] has been [z.attack_verb] by [y] with [z]"
	var/list/attack_verb
	/// A multiplier to an object's force when used against a stucture.
	var/demolition_mod = 1

	health = null

	rebounds = TRUE

	/// whether this item cuts
	var/sharp = 0
	/// whether this item is more likely to dismember
	var/edge = 0
	/// whether this item can be used to pry things open.
	var/pry_capable = 0
	/// whether this item is a source of heat, and how hot it is (in Kelvin).
	var/heat_source = 0

	//SOUND VARS
	///Sound to be played when item is picked up
	var/pickup_sound
	///Volume of pickup sound
	var/pickupvol = 15
	///Whether the pickup sound will vary in pitch/frequency
	var/pickup_vary = TRUE

	///Sound to be played when item is dropped
	var/drop_sound
	///Volume of drop sound
	var/dropvol = 15
	///Whether the drop sound will vary in pitch/frequency
	var/drop_vary = TRUE

	///Play this when you thwack someone with the item
	var/hitsound

	var/center_of_mass = "x=16;y=16"
	///Adjusts the item's position in the HUD, currently only by guns with stock/barrel attachments.
	var/hud_offset = 0
	var/w_class = SIZE_MEDIUM
	var/storage_cost = null
	flags_atom = FPRINT
	/// flags for item stuff that isn't clothing/equipping specific.
	var/flags_item = NO_FLAGS
	/// This is used to determine on which slots an item can fit.
	var/flags_equip_slot = NO_FLAGS

	//Since any item can now be a piece of clothing, this has to be put here so all items share it.
	/// This flag is used for various clothing/equipment item stuff
	var/flags_inventory = NO_FLAGS
	/// This flag is used to determine when items in someone's inventory cover others. IE helmets making it so you can't see glasses, etc.
	var/flags_inv_hide = NO_FLAGS

	var/obj/item/master = null

	/// see setup.dm for appropriate bit flags
	var/flags_armor_protection = NO_FLAGS
	/// flags which determine which body parts are protected from heat. Use the HEAD, UPPER_TORSO, LOWER_TORSO, etc. flags. See setup.dm
	var/flags_heat_protection = NO_FLAGS
	/// flags which determine which body parts are protected from cold. Use the HEAD, UPPER_TORSO, LOWER_TORSO, etc. flags. See setup.dm
	var/flags_cold_protection = NO_FLAGS
	/// Set this variable to determine up to which temperature (IN KELVIN) the item protects against heat damage. Keep at null to disable protection. Only protects areas set by flags_heat_protection flags
	var/max_heat_protection_temperature
	/// Set this variable to determine down to which temperature (IN KELVIN) the item protects against cold damage. 0 is NOT an acceptable number due to if(varname) tests!! Keep at null to disable protection. Only protects areas set by flags_cold_protection flags
	var/min_cold_protection_temperature
	/// list of /datum/action's that this item has.
	var/list/actions
	/// list of paths of action datums to give to the item on New().
	var/list/actions_types

	//var/heat_transfer_coefficient = 1 //0 prevents all transfers, 1 is invisible

	/// for leaking gas from turf to mask and vice-versa (for masks right now, but at some point, i'd like to include space helmets)
	var/gas_transfer_coefficient = 1
	/// for chemicals/diseases
	var/permeability_coefficient = 1
	/// for electrical admittance/conductance (electrocution checks and shit)
	var/siemens_coefficient = 1
	/// How much clothing is slowing you down. Negative values speeds you up
	var/slowdown = 0
	/// suit storage stuff.
	var/list/allowed = null
	/// name used for message when binoculars/scope is used
	var/zoomdevicename = null
	/// 1 if item is actively being used to zoom. For scoped guns and binoculars.
	var/zoom = 0
	/// the initial dir the mob faces when it zooms in
	var/zoom_initial_mob_dir = null
	/// Need to wear this uniform to equip this
	var/list/obj/item/uniform_restricted
	/// set to ticks it takes to equip a worn suit.
	var/time_to_equip = 0
	/// set to ticks it takes to unequip a worn suit.
	var/time_to_unequip = 0
	/// Used to override hardcoded ON-MOB clothing dmis in human clothing proc (i.e. not the icon_state sprites).
	var/icon_override = null

	var/list/sprite_sheets
	var/list/item_icons
	/// overrides the default
	var/list/item_state_slots

	/// If the item uses flag MOB_LOCK_ON_PICKUP, this is the mob owner reference.
	var/mob/living/carbon/human/locked_to_mob = null
	/// Sounds played when this item is equipped
	var/list/equip_sounds
	/// Sounds played when this item is unequipped
	var/list/unequip_sounds

	///Vision impairing effect if worn on head/mask/glasses.
	var/vision_impair = VISION_IMPAIR_NONE

	///Used for stepping onto flame and seeing how much dmg you take and if you're ignited.
	var/fire_intensity_resistance

	var/map_specific_decoration = FALSE
	/// color of the blood on us if there's any.
	var/blood_color = ""
	/// taken from blood.dm
	appearance_flags = KEEP_TOGETHER
	/// lets us know if the item is an objective or not
	var/is_objective = FALSE

	/// Allows for bigger than 32x32 sprites.
	var/worn_x_dimension = 32
	var/worn_y_dimension = 32

	/// Allows for bigger than 32x32 sprites, these govern inhand sprites. (Like a longer sword that's normal-sized on your back)
	var/inhand_x_dimension = 32
	var/inhand_y_dimension = 32

	/// checks if the item is set up in the table or not
	var/table_setup = FALSE
	/// checks if the item will be specially placed on the table
	var/has_special_table_placement = FALSE

	var/list/inherent_traits

	/// How much to offset the item randomly either way alongside X visually
	var/ground_offset_x = 0
	/// How much to offset the item randomly either way alongside Y visually
	var/ground_offset_y = 0

/obj/item/Initialize(mapload, ...)
	. = ..()

	if(inherent_traits)
		for(var/trait in inherent_traits)
			ADD_TRAIT(src, trait, TRAIT_SOURCE_INHERENT)
	for(var/path in actions_types)
		new path(src)
	if(w_class <= SIZE_MEDIUM) //pulling small items doesn't slow you down much
		drag_delay = 1
	if(isstorage(loc))
		appearance_flags |= NO_CLIENT_COLOR //It's spawned in an inventory item, so saturation/desaturation etc. effects shouldn't affect it.

	if(flags_item & ITEM_PREDATOR)
		AddElement(/datum/element/yautja_tracked_item)

	if(flags_item & MOB_LOCK_ON_EQUIP)
		AddComponent(/datum/component/id_lock)

	scatter_item()

/obj/item/Destroy()
	flags_item &= ~DELONDROP //to avoid infinite loop of unequip, delete, unequip, delete.
	flags_item &= ~NODROP //so the item is properly unequipped if on a mob.
	QDEL_NULL_LIST(actions)
	master = null
	locked_to_mob = null

	var/obj/item/storage/S = loc
	if(istype(S))
		for(var/mob/M in S.can_see_content())
			if(M.client)
				M.client.remove_from_screen(src)
	if(ismob(loc))
		dropped(loc)

	return ..()

/obj/item/ex_act(severity, explosion_direction)
	var/msg = pick("is destroyed by the blast!", "is obliterated by the blast!", "shatters as the explosion engulfs it!", "disintegrates in the blast!", "perishes in the blast!", "is mangled into uselessness by the blast!")
	explosion_throw(severity, explosion_direction)
	switch(severity)
		if(0 to EXPLOSION_THRESHOLD_LOW)
			if(prob(5))
				if(!indestructible)
					visible_message(SPAN_DANGER(SPAN_UNDERLINE("\The [src] [msg]")))
					deconstruct(FALSE)
		if(EXPLOSION_THRESHOLD_LOW to EXPLOSION_THRESHOLD_MEDIUM)
			if(prob(50))
				if(!indestructible)
					deconstruct(FALSE)
		if(EXPLOSION_THRESHOLD_MEDIUM to INFINITY)
			if(!indestructible)
				visible_message(SPAN_DANGER(SPAN_UNDERLINE("\The [src] [msg]")))
				deconstruct(FALSE)

/obj/item/mob_launch_collision(mob/living/L)
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

/*Global item proc for all of your unique item skin needs. Works with any
item, and will change the skin to whatever you specify here. You can also
manually override the icon with a unique skin if wanted, for the outlier
cases. Override_icon_state should be a list.*/
/obj/item/proc/select_gamemode_skin(expected_type, list/override_icon_state, list/override_protection)
	if(type != expected_type)
		return

	var/new_icon_state
	var/new_protection
	var/new_item_state
	if(override_icon_state && override_icon_state.len)
		new_icon_state = override_icon_state[SSmapping.configs[GROUND_MAP].map_name]
	if(override_protection && override_protection.len)
		new_protection = override_protection[SSmapping.configs[GROUND_MAP].map_name]
	switch(SSmapping.configs[GROUND_MAP].camouflage_type)
		if("snow")
			icon_state = new_icon_state ? new_icon_state : "s_" + icon_state
			item_state = new_item_state ? new_item_state : "s_" + item_state
		if("desert")
			icon_state = new_icon_state ? new_icon_state : "d_" + icon_state
			item_state = new_item_state ? new_item_state : "d_" + item_state
		if("classic")
			icon_state = new_icon_state ? new_icon_state : "c_" + icon_state
			item_state = new_item_state ? new_item_state : "c_" + item_state
	if(new_protection)
		min_cold_protection_temperature = new_protection

/obj/item/get_examine_text(mob/user)
	. = list()
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
	. += "This is a [blood_color ? blood_color != COLOR_OIL ? "bloody " : "oil-stained " : ""][icon2html(src, user)][src.name]. It is a [size] item."
	if(desc)
		. += desc
	if(desc_lore)
		. += SPAN_NOTICE("This has an <a href='byond://?src=\ref[src];desc_lore=1'>extended lore description</a>.")

/obj/item/attack_hand(mob/user)
	if (!user)
		return

	if(anchored)
		to_chat(user, "[src] is anchored to the ground.")
		return

	if(!Adjacent(user)) // needed because of alt-click
		if(src.clone && !src.clone.Adjacent(user)) // Is the clone adjacent?
			return

	if(isgun(loc)) // more alt-click hijinx
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
		add_fingerprint(user)
		if(!user.put_in_active_hand(src))
			dropped(user)

// Due to storage type consolidation this should get used more now.
// I have cleaned it up a little, but it could probably use more.  -Sayu
/obj/item/attackby(obj/item/W, mob/user)
	if(SEND_SIGNAL(src, COMSIG_ITEM_ATTACKED, W, user) & COMPONENT_CANCEL_ITEM_ATTACK)
		return

	if(istype(W,/obj/item/storage))
		var/obj/item/storage/S = W
		if(S.storage_flags & STORAGE_CLICK_GATHER && isturf(loc))
			if(S.storage_flags & STORAGE_GATHER_SIMULTAENOUSLY) //Mode is set to collect all items on a tile and we clicked on a valid one.
				var/success = 0
				var/failure = 0

				for(var/obj/item/I in src.loc)
					if(!S.can_be_inserted(I, user, stop_messages = TRUE))
						failure = 1
						continue
					success = 1
					S.handle_item_insertion(I, TRUE, user) //The 1 stops the "You put the [src] into [S]" insertion message from being displayed.
				if(success && !failure)
					to_chat(user, SPAN_NOTICE("You put everything in [S]."))
				else if(success)
					to_chat(user, SPAN_NOTICE("You put some things in [S]."))
				else
					to_chat(user, SPAN_NOTICE("You fail to pick anything up with [S]."))

			else if(S.can_be_inserted(src, user))
				S.handle_item_insertion(src, FALSE, user)

	return

/obj/item/proc/talk_into(mob/M as mob, text)
	return

/obj/item/proc/moved(mob/user as mob, old_loc as turf)
	return

// apparently called whenever an item is removed from a slot, container, or anything else.
//the call happens after the item's potential loc change.
/obj/item/proc/dropped(mob/user as mob)
	SHOULD_CALL_PARENT(TRUE)

	remove_item_verbs(user)

	for(var/X in actions)
		var/datum/action/A = X
		A.remove_from(user)

	if(flags_item & DELONDROP)
		qdel(src)

	SEND_SIGNAL(src, COMSIG_ITEM_DROPPED, user)
	SEND_SIGNAL(user, COMSIG_MOB_ITEM_DROPPED, src)
	if(drop_sound && (src.loc?.z))
		playsound(src, drop_sound, dropvol, drop_vary)
	src.do_drop_animation(user)

	appearance_flags &= ~NO_CLIENT_COLOR //So saturation/desaturation etc. effects affect it.

// called just as an item is picked up (loc is not yet changed)
/obj/item/proc/pickup(mob/user, silent)
	SHOULD_CALL_PARENT(TRUE)
	SEND_SIGNAL(src, COMSIG_ITEM_PICKUP, user)
	SEND_SIGNAL(user, COMSIG_MOB_PICKUP_ITEM, src)
	setDir(SOUTH)//Always rotate it south. This resets it to default position, so you wouldn't be putting things on backwards
	if(pickup_sound && !silent && src.loc?.z)
		playsound(src, pickup_sound, pickupvol, pickup_vary)
	do_pickup_animation(user)

// called when this item is removed from a storage item, which is passed on as S. The loc variable is already set to the new destination before this is called.
/obj/item/proc/on_exit_storage(obj/item/storage/S as obj)
	SHOULD_CALL_PARENT(TRUE)
	appearance_flags &= ~NO_CLIENT_COLOR
	if(LAZYISIN(S.hearing_items, src))
		LAZYREMOVE(S.hearing_items, src)
		if(!LAZYLEN(S.hearing_items))
			S.flags_atom &= ~USES_HEARING
	var/atom/location = S.get_loc_turf()
	do_drop_animation(location)

// called when this item is added into a storage item, which is passed on as S. The loc variable is already set to the storage item.
/obj/item/proc/on_enter_storage(obj/item/storage/S as obj)
	SHOULD_CALL_PARENT(TRUE)
	appearance_flags |= NO_CLIENT_COLOR //It's in an inventory item, so saturation/desaturation etc. effects shouldn't affect it.
	if(src.flags_atom & USES_HEARING)
		LAZYADD(S.hearing_items, src)
		S.flags_atom |= USES_HEARING

// called when "found" in pockets and storage items. Returns 1 if the search should end.
/obj/item/proc/on_found(mob/finder as mob)
	return

/obj/item/proc/remove_item_verbs(mob/user)
	if(!user.item_verbs)
		return

	var/list/verbs_to_remove = list()
	for(var/v in verbs)
		if(length(user.item_verbs[v]) == 1)
			if(user.item_verbs[v][1] == src)
				verbs_to_remove += v
		LAZYREMOVE(user.item_verbs[v], src)
	remove_verb(user, verbs_to_remove)

// called after an item is placed in an equipment slot
// user is mob that equipped it
// slot uses the slot_X defines found in setup.dm
// for items that can be placed in multiple slots
// note this isn't called during the initial dressing of a player
/obj/item/proc/equipped(mob/user, slot, silent)
	SHOULD_CALL_PARENT(TRUE)

	SEND_SIGNAL(src, COMSIG_ITEM_EQUIPPED, user, slot)

	if(item_action_slot_check(user, slot))
		add_verb(user, verbs)
		for(var/v in verbs)
			LAZYDISTINCTADD(user.item_verbs[v], src)
		for(var/datum/action/item_action in actions)
			item_action.give_to(user) //some items only give their actions buttons when in a specific slot.
	else
		remove_item_verbs(user)

	setDir(SOUTH)//Always rotate it south. This resets it to default position, so you wouldn't be putting things on backwards


	appearance_flags |= NO_CLIENT_COLOR //So that saturation/desaturation etc. effects don't hit inventory.
	if(LAZYLEN(uniform_restricted))
		UnregisterSignal(user, COMSIG_MOB_ITEM_UNEQUIPPED)
		if(flags_equip_slot & slotdefine2slotbit(slot))
			RegisterSignal(user, COMSIG_MOB_ITEM_UNEQUIPPED, PROC_REF(check_for_uniform_restriction))

// Called after the item is removed from equipment slot.
/obj/item/proc/unequipped(mob/user, slot)
	SHOULD_CALL_PARENT(TRUE)

	SEND_SIGNAL(src, COMSIG_ITEM_UNEQUIPPED, user, slot)

	// Unregister first so as not to have to handle our own event
	UnregisterSignal(user, COMSIG_MOB_ITEM_UNEQUIPPED)
	SEND_SIGNAL(user, COMSIG_MOB_ITEM_UNEQUIPPED, src, slot)

/obj/item/proc/check_for_uniform_restriction(mob/user, obj/item/item, slot)
	SIGNAL_HANDLER

	if(item.flags_equip_slot & slotdefine2slotbit(slot))
		if(is_type_in_list(item, uniform_restricted))
			if(light_on)
				turn_light(toggle_on = FALSE)
			user.drop_inv_item_on_ground(src)
			to_chat(user, SPAN_NOTICE("You drop \the [src] to the ground while unequipping \the [item]."))

//sometimes we only want to grant the item's action if it's equipped in a specific slot.
/obj/item/proc/item_action_slot_check(mob/user, slot)
	return TRUE

/obj/item/proc/scatter_item()
	if(!pixel_x && !pixel_y)
		pixel_x = rand(-ground_offset_x, ground_offset_x)
		pixel_y = rand(-ground_offset_y, ground_offset_y)

// The mob M is attempting to equip this item into the slot passed through as 'slot'. return TRUE if it can do this and 0 if it can't.
// If you are making custom procs but would like to retain partial or complete functionality of this one, include a 'return ..()' to where you want this to happen.
// Set disable_warning to TRUE if you wish it to not give you outputs.
// warning_text is used in the case that you want to provide a specific warning for why the item cannot be equipped.
/obj/item/proc/mob_can_equip(mob/equipping_mob, slot, disable_warning = FALSE)
	if(!slot)
		return FALSE
	if(!equipping_mob)
		return FALSE

	if(SEND_SIGNAL(src, COMSIG_ITEM_ATTEMPTING_EQUIP, equipping_mob, slot) & COMPONENT_CANCEL_EQUIP)
		return FALSE

	if(ishuman(equipping_mob))
		//START HUMAN
		var/mob/living/carbon/human/human = equipping_mob
		var/list/mob_equip = list()
		if(human.hud_used && human.hud_used.equip_slots)
			mob_equip = human.hud_used.equip_slots

		if(human.species && !(slot in mob_equip))
			return FALSE

		if(uniform_restricted)
			var/list/required_clothing = list()
			var/restriction_satisfied = FALSE
			for(var/obj/item/restriction_type as anything in uniform_restricted)
				var/valid_equip_slots = initial(restriction_type.flags_equip_slot)
				required_clothing += initial(restriction_type.name)
				// You can't replace this with a switch(), flags_equip_slot is a bitfield
				if(valid_equip_slots & SLOT_ICLOTHING)
					if(istype(human.w_uniform, restriction_type))
						restriction_satisfied = TRUE
						break
				if(valid_equip_slots & SLOT_OCLOTHING)
					if(istype(human.wear_suit, restriction_type))
						restriction_satisfied = TRUE
						break
			if(!restriction_satisfied)
				if(!disable_warning)
					to_chat(human, SPAN_WARNING("You cannot wear this without wearing one of the following; [required_clothing.Join(", ")]."))
				return FALSE

		switch(slot)
			if(WEAR_L_HAND)
				if(human.l_hand)
					return FALSE
				if(human.body_position == LYING_DOWN)
					to_chat(human, SPAN_WARNING("You can't equip that while lying down."))
					return
				return TRUE
			if(WEAR_R_HAND)
				if(human.r_hand)
					return FALSE
				if(human.body_position == LYING_DOWN)
					to_chat(human, SPAN_WARNING("You can't equip that while lying down."))
					return
				return TRUE
			if(WEAR_FACE)
				if(human.wear_mask)
					return FALSE
				if(!(flags_equip_slot & SLOT_FACE))
					return FALSE
				return TRUE
			if(WEAR_BACK)
				if(human.back)
					return FALSE
				if(!(flags_equip_slot & SLOT_BACK))
					return FALSE
				return TRUE
			if(WEAR_JACKET)
				if(human.wear_suit)
					return FALSE
				if(!(flags_equip_slot & SLOT_OCLOTHING))
					return FALSE
				return TRUE
			if(WEAR_HANDS)
				if(human.gloves)
					return FALSE
				if(!(flags_equip_slot & SLOT_HANDS))
					return FALSE
				return TRUE
			if(WEAR_FEET)
				if(human.shoes)
					return FALSE
				if(!(flags_equip_slot & SLOT_FEET))
					return FALSE
				return TRUE
			if(WEAR_WAIST)
				if(human.belt)
					return FALSE
				if(!human.w_uniform && (WEAR_BODY in mob_equip))
					if(!disable_warning)
						to_chat(human, SPAN_WARNING("You need a jumpsuit before you can attach this [name]."))
					return FALSE
				if(!(flags_equip_slot & SLOT_WAIST))
					return
				return TRUE
			if(WEAR_EYES)
				if(human.glasses)
					return FALSE
				if(!(flags_equip_slot & SLOT_EYES))
					return FALSE
				return TRUE
			if(WEAR_HEAD)
				if(human.head)
					return FALSE
				if(!(flags_equip_slot & SLOT_HEAD))
					return FALSE
				return TRUE
			if(WEAR_L_EAR)
				if(human.wear_l_ear)
					return FALSE
				if(HAS_TRAIT(src, TRAIT_ITEM_EAR_EXCLUSIVE))
					if(human.wear_r_ear && HAS_TRAIT(human.wear_r_ear, TRAIT_ITEM_EAR_EXCLUSIVE))
						if(!disable_warning)
							to_chat(human, SPAN_WARNING("You can't wear [src] while you have [human.wear_r_ear] in your right ear!"))
						return FALSE
				if(!(flags_equip_slot & SLOT_EAR))
					return FALSE
				return TRUE
			if(WEAR_R_EAR)
				if(human.wear_r_ear)
					return FALSE
				if(HAS_TRAIT(src, TRAIT_ITEM_EAR_EXCLUSIVE))
					if(human.wear_l_ear && HAS_TRAIT(human.wear_l_ear, TRAIT_ITEM_EAR_EXCLUSIVE))
						if(!disable_warning)
							to_chat(human, SPAN_WARNING("You can't wear [src] while you have [human.wear_l_ear] in your left ear!"))
						return FALSE
				if(!(flags_equip_slot & SLOT_EAR))
					return FALSE
				return TRUE
			if(WEAR_BODY)
				if(human.w_uniform)
					return FALSE
				if(!(flags_equip_slot & SLOT_ICLOTHING))
					return FALSE
				return TRUE
			if(WEAR_ID)
				if(human.wear_id)
					return FALSE
				if(!(flags_equip_slot & SLOT_ID))
					return FALSE
				return TRUE
			if(WEAR_L_STORE)
				if(human.l_store)
					return FALSE
				if(!human.w_uniform && (WEAR_BODY in mob_equip))
					if(!disable_warning)
						to_chat(human, SPAN_WARNING("You need a jumpsuit before you can attach this [name]."))
					return FALSE
				if(flags_equip_slot & SLOT_NO_STORE)
					return FALSE
				if(w_class <= SIZE_SMALL || (flags_equip_slot & SLOT_STORE))
					return TRUE
			if(WEAR_R_STORE)
				if(human.r_store)
					return FALSE
				if(!human.w_uniform && (WEAR_BODY in mob_equip))
					if(!disable_warning)
						to_chat(human, SPAN_WARNING("You need a jumpsuit before you can attach this [name]."))
					return FALSE
				if(flags_equip_slot & SLOT_NO_STORE)
					return FALSE
				if(w_class <= SIZE_SMALL || (flags_equip_slot & SLOT_STORE))
					return TRUE
				return FALSE
			if(WEAR_ACCESSORY)
				for(var/obj/item/clothing/clothes in human.contents)
					if(clothes.can_attach_accessory(src))
						return TRUE
				return FALSE
			if(WEAR_J_STORE)
				if(human.s_store)
					return FALSE
				if(flags_equip_slot & SLOT_SUIT_STORE)
					return TRUE
				if(flags_equip_slot & SLOT_BLOCK_SUIT_STORE)
					return FALSE
				if(!human.wear_suit && (WEAR_JACKET in mob_equip))
					if(!disable_warning)
						to_chat(human, SPAN_WARNING("You need a suit before you can attach this [name]."))
					return FALSE
				if(human.wear_suit && !human.wear_suit.allowed)
					if(!disable_warning)
						to_chat(usr, "You somehow have a suit with no defined allowed items for suit storage, stop that.")
					return FALSE
				if(human.wear_suit && is_type_in_list(src, human.wear_suit.allowed))
					return TRUE
				return FALSE
			if(WEAR_HANDCUFFS)
				if(human.handcuffed)
					return FALSE
				if(!istype(src, /obj/item/restraint))
					return FALSE
				return TRUE
			if(WEAR_LEGCUFFS)
				if(human.legcuffed)
					return FALSE
				if(!istype(src, /obj/item/restraint))
					return FALSE
				return TRUE
			if(WEAR_IN_ACCESSORY)
				if(human.w_uniform)
					for(var/accessory in human.w_uniform.accessories)
						if(istype(accessory, /obj/item/clothing/accessory/storage))
							var/obj/item/clothing/accessory/storage/holster = accessory
							if(holster.hold.can_be_inserted(src, human, TRUE))
								return TRUE
						else if(istype(accessory, /obj/item/storage/internal/accessory/holster))
							var/obj/item/storage/internal/accessory/holster/internal_storage = accessory
							if(!(internal_storage.current_gun) && internal_storage.can_be_inserted(src, human))
								return TRUE
				return FALSE
			if(WEAR_IN_JACKET)
				if(human.wear_suit)
					var/obj/item/clothing/suit/storage/storage = human.wear_suit
					if(istype(storage) && storage.pockets)//not all suits have pockits
						var/obj/item/storage/internal/internal_storage = storage.pockets
						if(internal_storage.can_be_inserted(src, human, TRUE))
							return TRUE
				return FALSE
			if(WEAR_IN_HELMET)
				if(human.head)
					var/obj/item/clothing/head/helmet/marine/helmet = human.head
					if(istype(helmet) && helmet.pockets)//not all helmuts have pockits
						var/obj/item/storage/internal/internal_storage = helmet.pockets
						if(internal_storage.can_be_inserted(src, human, TRUE))
							return TRUE
			if(WEAR_IN_BACK)
				if (human.back && isstorage(human.back))
					var/obj/item/storage/backpack = human.back
					if(backpack.can_be_inserted(src, human, TRUE))
						return TRUE
				return FALSE
			if(WEAR_IN_SHOES)
				if(human.shoes && istype(human.shoes, /obj/item/clothing/shoes))
					var/obj/item/clothing/shoes/shoes = human.shoes
					if(shoes.can_be_inserted(src))
						return TRUE
				return FALSE
			if(WEAR_IN_SCABBARD)
				if(human.back && istype(human.back, /obj/item/storage/large_holster))
					var/obj/item/storage/large_holster/backpack = human.back
					if(backpack.can_be_inserted(src, human, TRUE))
						return TRUE
				return FALSE
			if(WEAR_IN_BELT)
				if(human.belt &&  isstorage(human.belt))
					var/obj/item/storage/belt = human.belt
					if(belt.can_be_inserted(src, human, TRUE))
						return TRUE
				return FALSE
			if(WEAR_IN_J_STORE)
				if(human.s_store && isstorage(human.s_store))
					var/obj/item/storage/armor = human.s_store
					if(armor.can_be_inserted(src, human, TRUE))
						return TRUE
				return FALSE
			if(WEAR_IN_L_STORE)
				if(human.l_store && istype(human.l_store, /obj/item/storage/pouch))
					var/obj/item/storage/pouch/pouch = human.l_store
					if(pouch.can_be_inserted(src, human, TRUE))
						return TRUE
				return FALSE
			if(WEAR_IN_R_STORE)
				if(human.r_store && istype(human.r_store, /obj/item/storage/pouch))
					var/obj/item/storage/pouch/pouch = human.r_store
					if(pouch.can_be_inserted(src, human, TRUE))
						return TRUE
				return FALSE
		return FALSE //Unsupported slot
		//END HUMAN

///Checks if an item can be put in a slot (string) based on their slot flags (bit flags)
/obj/item/proc/is_valid_slot(slot, ignore_non_flags)
	switch(slot)
		if(WEAR_FACE)
			return flags_equip_slot & SLOT_FACE
		if(WEAR_BACK)
			return flags_equip_slot & SLOT_BACK
		if(WEAR_JACKET)
			return flags_equip_slot & SLOT_OCLOTHING
		if(WEAR_HANDS)
			return flags_equip_slot & SLOT_HANDS
		if(WEAR_FEET)
			return flags_equip_slot & SLOT_FEET
		if(WEAR_WAIST)
			return flags_equip_slot & SLOT_WAIST
		if(WEAR_EYES)
			return flags_equip_slot & SLOT_EYES
		if(WEAR_HEAD)
			return flags_equip_slot & SLOT_HEAD
		if(WEAR_L_EAR, WEAR_R_EAR)
			return flags_equip_slot & SLOT_EAR
		if(WEAR_BODY)
			return flags_equip_slot & SLOT_ICLOTHING
		if(WEAR_ID)
			return flags_equip_slot & SLOT_ID
		if(WEAR_L_STORE, WEAR_R_STORE)
			if((flags_equip_slot & SLOT_NO_STORE) || !(flags_equip_slot & SLOT_STORE))
				return FALSE
			return TRUE
		else
			return !ignore_non_flags

//This proc is executed when someone clicks the on-screen UI button. To make the UI button show, set the 'icon_action_button' to the icon_state of the image of the button in actions.dmi
//The default action is attack_self().
//Checks before we get to here are: mob is alive, mob is not restrained, paralyzed, asleep, resting, laying, item is on the mob.
/obj/item/proc/ui_action_click()
	if(src in usr)
		attack_self(usr)


/obj/item/proc/IsShield()
	return FALSE

/obj/item/proc/get_loc_turf()
	var/atom/L = loc
	while(L && !istype(L, /turf/))
		L = L.loc
	return loc


/obj/item/proc/showoff(mob/user)
	var/list/viewers = get_mobs_in_view(GLOB.world_view_size, user)
	user.langchat_speech("holds up [src].", viewers, GLOB.all_languages, skip_language_check = TRUE, animation_style = LANGCHAT_FAST_POP, additional_styles = list("langchat_small", "emote"))
	for (var/mob/M in viewers)
		M.show_message("[user] holds up [src]. <a HREF=?src=\ref[M];lookitem=\ref[src]>Take a closer look.</a>", SHOW_MESSAGE_VISIBLE)

/mob/living/carbon/verb/showoff()
	set name = "Show Held Item"
	set category = "Object"

	var/obj/item/I = get_active_hand()
	if(I && !(I.flags_item & ITEM_ABSTRACT))
		I.showoff(src)


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
	else if(!zoom)
		do_zoom(user, tileoffset, viewsize, keep_zoom)
		return
	unzoom(user)

/obj/item/proc/unzoom(mob/living/user)
	if(user.interactee == src)
		user.unset_interaction()
	var/zoom_device = zoomdevicename ? "\improper [zoomdevicename] of [src]" : "\improper [src]"
	INVOKE_ASYNC(user, TYPE_PROC_REF(/atom, visible_message), SPAN_NOTICE("[user] looks up from [zoom_device]."),
	SPAN_NOTICE("You look up from [zoom_device]."))
	zoom = !zoom
	COOLDOWN_START(user, zoom_cooldown, 20)
	SEND_SIGNAL(user, COMSIG_LIVING_ZOOM_OUT, src)
	SEND_SIGNAL(src, COMSIG_ITEM_UNZOOM, user)
	UnregisterSignal(src, list(
		COMSIG_ITEM_DROPPED,
		COMSIG_ITEM_UNWIELD,
		COMSIG_PARENT_QDELETING,
	))
	UnregisterSignal(user, COMSIG_MOB_MOVE_OR_LOOK)
	//General reset in case anything goes wrong, the view will always reset to default unless zooming in.
	if(user.client)
		user.client.change_view(GLOB.world_view_size, src)
		user.client.pixel_x = 0
		user.client.pixel_y = 0

/obj/item/proc/zoom_handle_mob_move_or_look(mob/living/mover, actually_moving, direction, specific_direction)
	SIGNAL_HANDLER

	if(mover.dir != zoom_initial_mob_dir && mover.client) //Dropped when disconnected, whoops
		unzoom(mover)

/obj/item/proc/unzoom_dropped_callback(datum/source, mob/user)
	SIGNAL_HANDLER
	unzoom(user)

/obj/item/proc/do_zoom(mob/living/user, tileoffset = 11, viewsize = 12, keep_zoom = 0)
	if(!COOLDOWN_FINISHED(user, zoom_cooldown)) //If we are spamming the zoom, cut it out
		return
	COOLDOWN_START(user, zoom_cooldown, 20)
	if(user.interactee)
		user.unset_interaction()
	else
		user.set_interaction(src)
	if(user.client)
		user.client.change_view(viewsize, src)

		RegisterSignal(src, list(
			COMSIG_ITEM_DROPPED,
			COMSIG_ITEM_UNWIELD,
			COMSIG_PARENT_QDELETING,
		), PROC_REF(unzoom_dropped_callback))
		RegisterSignal(user, COMSIG_MOB_MOVE_OR_LOOK, PROC_REF(zoom_handle_mob_move_or_look))

		zoom_initial_mob_dir = user.dir

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

	SEND_SIGNAL(src, COMSIG_ITEM_ZOOM, user)
	var/zoom_device = zoomdevicename ? "\improper [zoomdevicename] of [src]" : "\improper [src]"
	user.visible_message(SPAN_NOTICE("[user] peers through \the [zoom_device]."),
	SPAN_NOTICE("You peer through \the [zoom_device]."))
	zoom = !zoom

/obj/item/proc/get_icon_state(mob/user_mob, slot)
	var/mob_state
	var/item_state_slot_state = LAZYACCESS(item_state_slots, slot)
	if(item_state_slot_state)
		mob_state = item_state_slot_state
	else if (item_state && (slot == WEAR_R_HAND || slot == WEAR_L_HAND || slot == WEAR_ID || slot == WEAR_WAIST))
		mob_state = item_state
	else
		mob_state = icon_state
	if(contained_sprite)
		mob_state += GLOB.slot_to_contained_sprite_shorthand[slot]
	return mob_state

/obj/item/proc/drop_to_floor(mob/wearer, body_position)
	SIGNAL_HANDLER
	if(body_position == LYING_DOWN)
		wearer.drop_inv_item_on_ground(src)

// item animatzionen

/obj/item/proc/do_pickup_animation(atom/target)
	if(!istype(loc, /turf))
		return
	var/image/pickup_animation = image(icon = src, loc = loc, layer = layer + 0.1)
	var/animation_alpha = 175
	if(target.alpha < 175)
		animation_alpha = target.alpha
	pickup_animation.alpha = animation_alpha
	pickup_animation.plane = GAME_PLANE
	pickup_animation.transform.Scale(0.75)
	pickup_animation.appearance_flags = APPEARANCE_UI_IGNORE_ALPHA

	var/turf/current_turf = get_turf(src)
	var/direction = get_dir(current_turf, target)
	var/to_x = target.base_pixel_x
	var/to_y = target.base_pixel_y

	if(direction & NORTH)
		to_y += 32
	else if(direction & SOUTH)
		to_y -= 32
	if(direction & EAST)
		to_x += 32
	else if(direction & WEST)
		to_x -= 32
	if(!direction)
		to_y += 10
		pickup_animation.pixel_x += 6 * (prob(50) ? 1 : -1) //6 to the right or left, helps break up the straight upward move

	var/list/viewers_clients = list()
	for(var/mob/M as anything in viewers(7, src))
		if(M.client)
			if(M.client.prefs.item_animation_pref_level == SHOW_ITEM_ANIMATIONS_NONE)
				continue
			if(src.loc == target.loc && M.client.prefs.item_animation_pref_level == SHOW_ITEM_ANIMATIONS_HALF)
				continue
			viewers_clients += M.client

	flick_overlay_to_clients(pickup_animation, viewers_clients, 4)

	var/matrix/animation_matrix = new(pickup_animation.transform)
	animation_matrix.Turn(pick(-30, 30))
	animation_matrix.Scale(0.65)

	animate(pickup_animation, alpha = animation_alpha, pixel_x = to_x, pixel_y = to_y, time = 3, transform = animation_matrix, easing = CUBIC_EASING)
	animate(alpha = 0, transform = matrix().Scale(0.7), time = 1)

/obj/item/proc/do_drop_animation(atom/moving_from)
	if(!istype(loc, /turf))
		return

	if(!istype(moving_from))
		return

	var/turf/current_turf = get_turf(src)
	var/direction = get_dir(moving_from, current_turf)
	var/from_x = moving_from.base_pixel_x
	var/from_y = moving_from.base_pixel_y

	if(direction & NORTH)
		from_y -= 32
	else if(direction & SOUTH)
		from_y += 32
	if(direction & EAST)
		from_x -= 32
	else if(direction & WEST)
		from_x += 32
	if(!direction)
		from_y += 10
		from_x += 6 * (prob(50) ? 1 : -1) //6 to the right or left, helps break up the straight upward move

	//We're moving from these chords to our current ones
	var/old_x = pixel_x
	var/old_y = pixel_y
	var/old_alpha = alpha
	var/matrix/old_transform = transform
	var/matrix/animation_matrix = new(old_transform)
	animation_matrix.Turn(pick(-30, 30))
	animation_matrix.Scale(0.7) // Shrink to start, end up normal sized

	pixel_x = from_x
	pixel_y = from_y
	alpha = 0
	transform = animation_matrix

	SEND_SIGNAL(src, COMSIG_ATOM_TEMPORARY_ANIMATION_START, 3)
	// This is instant on byond's end, but to our clients this looks like a quick drop
	animate(src, alpha = old_alpha, pixel_x = old_x, pixel_y = old_y, transform = old_transform, time = 3, easing = CUBIC_EASING)


/**
 * Set the item up on a table.
 * @param target: table which is being used to host the item.
 */
/obj/item/proc/set_to_table(obj/structure/surface/target)
	if (do_after(usr, 1 SECONDS, INTERRUPT_NO_NEEDHAND, BUSY_ICON_GENERIC))
		table_setup = TRUE
		usr.drop_inv_item_to_loc(src, target.loc)
	else
		to_chat(usr, SPAN_WARNING("You fail to setup the [name]"))

/**
 * Called to reset the state of the item to not be settled on the table.
 */
/obj/item/proc/teardown()
	table_setup = FALSE

/**
 * Grab item when its placed on table
 */
/obj/item/MouseDrop(over_object)
	if(!has_special_table_placement)
		return ..()

	if(over_object == usr && Adjacent(usr) && has_special_table_placement)
		teardown()
		usr.put_in_any_hand_if_possible(src, disable_warning = TRUE)

/atom/movable/proc/do_item_attack_animation(atom/attacked_atom, visual_effect_icon, obj/item/used_item)
	var/image/attack_image
	if(visual_effect_icon)
		attack_image = image('icons/effects/effects.dmi', attacked_atom, visual_effect_icon, attacked_atom.layer + 0.1)
	else if(used_item)
		attack_image = image(icon = used_item, loc = attacked_atom, layer = attacked_atom.layer + 0.1)
		attack_image.plane = attacked_atom.plane + 1

		// Scale the icon.
		attack_image.transform *= 0.4
		// The icon should not rotate.
		attack_image.appearance_flags = APPEARANCE_UI

		// Set the direction of the icon animation.
		var/direction = get_dir(src, attacked_atom)
		if(direction & NORTH)
			attack_image.pixel_y = -12
		else if(direction & SOUTH)
			attack_image.pixel_y = 12

		if(direction & EAST)
			attack_image.pixel_x = -14
		else if(direction & WEST)
			attack_image.pixel_x = 14

		if(!direction) // Attacked self?!
			attack_image.pixel_y = 12
			attack_image.pixel_x = 5 * (prob(50) ? 1 : -1)

	if(!attack_image)
		return

	flick_overlay_to_clients(attack_image, GLOB.clients, 10)
	var/matrix/copy_transform = new(transform)
	// And animate the attack!
	animate(attack_image, alpha = 175, transform = copy_transform.Scale(0.75), pixel_x = 0, pixel_y = 0, pixel_z = 0, time = 3)
	animate(time = 1)
	animate(alpha = 0, time = 3, easing = CIRCULAR_EASING|EASE_OUT)

///Called by /mob/living/carbon/swap_hand() when hands are swapped
/obj/item/proc/hands_swapped(mob/living/carbon/swapper_of_hands)
	return
