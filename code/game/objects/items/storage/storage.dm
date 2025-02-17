// To clarify:
// For STORAGE_CLICK_GATHER and STORAGE_QUICK_GATHER functionality,
// see item/attackby() (/game/obj/items.dm)
// Do not remove this functionality without good reason, cough reagent_containers cough.
// -Sayu


/obj/item/storage
	name = "storage"
	w_class = SIZE_MEDIUM
	flags_atom = FPRINT|NO_GAMEMODE_SKIN
	var/list/can_hold = new/list() //List of objects which this item can store (if set, it can't store anything else)
	var/list/cant_hold = new/list() //List of objects which this item can't store (in effect only if can_hold isn't set)
	var/list/bypass_w_limit = new/list() //a list of objects which this item can store despite not passing the w_class limit
	var/list/click_border_start = new/list() //In slotless storage, stores areas where clicking will refer to the associated item
	var/list/click_border_end = new/list()
	var/list/hearing_items //A list of items that use hearing for the purpose of performance
	var/max_w_class = SIZE_SMALL //Max size of objects that this object can store
	var/max_storage_space = 14 //The sum of the storage costs of all the items in this storage item.
	var/storage_slots = 7 //The number of storage slots in this container.
	var/atom/movable/screen/storage/boxes = null
	var/atom/movable/screen/storage/storage_start = null //storage UI
	var/atom/movable/screen/storage/storage_continue = null
	var/atom/movable/screen/storage/storage_end = null
	var/datum/item_storage_box/stored_ISB //! This contains what previously was known as stored_start, stored_continue, and stored_end
	var/atom/movable/screen/close/closer = null
	var/foldable = null
	var/use_sound = "rustle" //sound played when used. null for no sound.
	var/opened = FALSE //Has it been opened before?
	var/list/content_watchers //list of mobs currently seeing the storage's contents
	var/storage_flags = STORAGE_FLAGS_DEFAULT

	///Special can_holds that require a skill to insert, it is an associated list of typepath = list(skilltype, skilllevel)
	var/list/can_hold_skill = list()

	///Dictates whether or not we only check for items in can_hold_skill rather than can_hold or free usage
	var/can_hold_skill_only = FALSE

	/// The required skill for opening this storage if it is inside another storage type
	var/required_skill_for_nest_opening = null

	/// The required level of a skill for opening this storage if it is inside another storage type
	var/required_skill_level_for_nest_opening = null

/obj/item/storage/MouseDrop(obj/over_object as obj)
	if(CAN_PICKUP(usr, src))
		if(over_object == usr) // this must come before the screen objects only block
			open(usr)
			return

		if(!istype(over_object, /atom/movable/screen))
			return ..()

		//Makes sure that the storage is equipped, so that we can't drag it into our hand from miles away.
		//There's got to be a better way of doing this.
		if(loc != usr || (loc && loc.loc == usr))
			return

		if(!usr.is_mob_restrained() && !usr.stat)
			switch(over_object.name)
				if("r_hand")
					if(usr.drop_inv_item_on_ground(src))
						usr.put_in_r_hand(src)
				if("l_hand")
					if(usr.drop_inv_item_on_ground(src))
						usr.put_in_l_hand(src)
			add_fingerprint(usr)

/obj/item/storage/clicked(mob/user, list/mods)
	if(!mods["shift"] && mods["middle"] && CAN_PICKUP(user, src))
		handle_mmb_open(user)
		return TRUE

	//Allow alt-clicking to remove items directly from storage.
	//Does so by passing the alt mod back to do_click(), which eventually delivers it to attack_hand().
	//This ensures consistent click behaviour between alt-click and left-mouse drawing.
	if(mods["alt"]  && loc == user && !user.get_active_hand())
		return FALSE

	return ..()

/obj/item/storage/proc/handle_mmb_open(mob/user)
	open(user)

/obj/item/storage/proc/return_inv()
	RETURN_TYPE(/list)
	var/list/L = list(  )

	L += src.contents

	for(var/obj/item/storage/S in src)
		L += S.return_inv()
	for(var/obj/item/gift/G in src)
		L += G.gift
		if (isstorage(G.gift))
			L += G.gift:return_inv()
	return L

/obj/item/storage/proc/show_to(mob/user as mob)
	if(user.s_active != src)
		for(var/obj/item/I in src)
			if(I.on_found(user))
				return
	if(user.s_active)
		user.s_active.hide_from(user)
	user.client.remove_from_screen(boxes)
	user.client.remove_from_screen(storage_start)
	user.client.remove_from_screen(storage_continue)
	user.client.remove_from_screen(storage_end)
	user.client.remove_from_screen(closer)
	user.client.remove_from_screen(contents)
	user.client.add_to_screen(closer)
	user.client.add_to_screen(contents)

	if(storage_slots)
		user.client.add_to_screen(boxes)
	else
		user.client.add_to_screen(storage_start)
		user.client.add_to_screen(storage_continue)
		user.client.add_to_screen(storage_end)

	user.s_active = src
	add_to_watchers(user)

/obj/item/storage/proc/add_to_watchers(mob/user)
	if(!(user in content_watchers))
		LAZYADD(content_watchers, user)
		RegisterSignal(user, COMSIG_PARENT_QDELETING, PROC_REF(watcher_deleted))

/obj/item/storage/proc/del_from_watchers(mob/watcher)
	if(watcher in content_watchers)
		LAZYREMOVE(content_watchers, watcher)
		UnregisterSignal(watcher, COMSIG_PARENT_QDELETING)

///Used to hide the storage's inventory screen.
/obj/item/storage/proc/hide_from(mob/user as mob)
	if(user.client)
		user.client.remove_from_screen(src.boxes)
		user.client.remove_from_screen(storage_start)
		user.client.remove_from_screen(storage_continue)
		user.client.remove_from_screen(storage_end)
		user.client.remove_from_screen(src.closer)
		user.client.remove_from_screen(src.contents)
	if(user.s_active == src)
		user.s_active = null
	del_from_watchers(user)

/obj/item/storage/proc/can_see_content()
	var/list/lookers = list()
	for(var/mob/M in content_watchers)
		if(M.s_active == src && M.client)
			lookers |= M
		else
			del_from_watchers(M)
	return lookers

/obj/item/storage/proc/open(mob/user)
	if(user.s_active == src) //Spam prevention.
		return

	if(istype(loc, /obj/item/storage) && required_skill_for_nest_opening)
		if(!user || user.skills?.get_skill_level(required_skill_for_nest_opening) < required_skill_level_for_nest_opening)
			to_chat(user, SPAN_NOTICE("You can't seem to open [src] while it is in [loc]."))
			return

	if(!opened)
		orient2hud()
		opened = 1
	if (use_sound)
		playsound(loc, use_sound, 25, TRUE, 3)

	if (user.s_active)
		user.s_active.storage_close(user)
	show_to(user)
	update_icon()

///Used to close the storage item. Used a lot - if tying it to special effects, use a content_watchers check to make sure it's closed properly and no-one's looking inside.
/obj/item/storage/proc/storage_close(mob/user)
	SIGNAL_HANDLER
	hide_from(user)
	update_icon()

//This proc draws out the inventory and places the items on it. It uses the standard position.
/obj/item/storage/proc/slot_orient_objs(rows, cols, list/obj/item/display_contents)
	var/cx = 4
	var/cy = 2+rows
	boxes.screen_loc = "4:16,2:16 to [4+cols]:16,[2+rows]:16"

	if (storage_flags & STORAGE_CONTENT_NUM_DISPLAY)
		for (var/datum/numbered_display/ND in display_contents)
			ND.sample_object.mouse_opacity = MOUSE_OPACITY_OPAQUE
			ND.sample_object.screen_loc = "[cx]:16,[cy]:16"
			ND.sample_object.maptext = "<font color='white'>[(ND.number > 1)? "[ND.number]" : ""]</font>"
			ND.sample_object.layer = ABOVE_HUD_LAYER
			ND.sample_object.plane = ABOVE_HUD_PLANE
			cx++
			if (cx > (4+cols))
				cx = 4
				cy--
	else
		for (var/obj/item/O in contents)
			O.mouse_opacity = MOUSE_OPACITY_OPAQUE //So storage items that start with contents get the opacity trick.
			O.screen_loc = "[cx]:[16+O.hud_offset],[cy]:16"
			O.layer = ABOVE_HUD_LAYER
			O.plane = ABOVE_HUD_PLANE
			cx++
			if (cx > (4+cols))
				cx = 4
				cy--
	closer.screen_loc = "[4+cols+1]:16,2:16"
	if (storage_flags & STORAGE_SHOW_FULLNESS)
		boxes.update_fullness(src)

GLOBAL_LIST_EMPTY_TYPED(item_storage_box_cache, /datum/item_storage_box)

/datum/item_storage_box
	var/atom/movable/screen/storage/start
	var/atom/movable/screen/storage/continued
	var/atom/movable/screen/storage/end
	/// The index that indentifies me inside GLOB.item_storage_box_cache
	var/index

/datum/item_storage_box/New()
	. = ..()
	start = new()
	start.icon_state = "stored_start"
	continued = new()
	continued.icon_state = "stored_continue"
	end = new()
	end.icon_state = "stored_end"

/datum/item_storage_box/Destroy(force, ...)
	QDEL_NULL(start)
	QDEL_NULL(continued)
	QDEL_NULL(end)
	GLOB.item_storage_box_cache -= index
	return ..()

/obj/item/storage/proc/space_orient_objs(list/obj/item/display_contents)
	var/baseline_max_storage_space = 21 //should be equal to default backpack capacity
	var/storage_cap_width = 2 //length of sprite for start and end of the box representing total storage space
	var/stored_cap_width = 4 //length of sprite for start and end of the box representing the stored item
	var/storage_width = min(round(258 * max_storage_space/baseline_max_storage_space, 1), 284) //length of sprite for the box representing total storage space

	click_border_start.Cut()
	click_border_end.Cut()
	storage_start.overlays.Cut()

	if(QDELETED(storage_continue))
		storage_continue = new /atom/movable/screen/storage()
		storage_continue.name = "storage"
		storage_continue.master = src
		storage_continue.icon_state = "storage_continue"
		storage_continue.screen_loc = "7,7 to 10,8"
		var/matrix/M = matrix()
		M.Scale((storage_width-storage_cap_width*2+3)/32,1)
		storage_continue.apply_transform(M)

	if(!opened) //initialize background box
		storage_start.screen_loc = "4:16,2:16"
		storage_continue.screen_loc = "4:[floor(storage_cap_width+(storage_width-storage_cap_width*2)/2+2)],2:16"
		storage_end.screen_loc = "4:[19+storage_width-storage_cap_width],2:16"

	var/startpoint = 0
	var/endpoint = 1
	for(var/obj/item/O in contents)
		startpoint = endpoint + 1
		endpoint += storage_width * O.get_storage_cost()/max_storage_space
		var/isb_index = "[startpoint], [endpoint], [stored_cap_width]"

		click_border_start.Add(startpoint)
		click_border_end.Add(endpoint)

		var/datum/item_storage_box/ISB = GLOB.item_storage_box_cache[isb_index]
		if(QDELETED(ISB))
			ISB = new()
			var/matrix/M_start = matrix()
			var/matrix/M_continue = matrix()
			var/matrix/M_end = matrix()
			M_start.Translate(startpoint, 0)
			M_continue.Scale((endpoint-startpoint-stored_cap_width*2)/32,1)
			M_continue.Translate(startpoint+stored_cap_width+(endpoint-startpoint-stored_cap_width*2)/2 - 16,0)
			M_end.Translate(endpoint-stored_cap_width,0)
			ISB.start.apply_transform(M_start)
			ISB.continued.apply_transform(M_continue)
			ISB.end.apply_transform(M_end)
			ISB.index = isb_index
			GLOB.item_storage_box_cache[isb_index] = ISB

		stored_ISB = ISB

		storage_start.overlays += ISB.start
		storage_start.overlays += ISB.continued
		storage_start.overlays += ISB.end

		O.screen_loc = "4:[floor((startpoint+endpoint)/2)+(2+O.hud_offset)],2:16"
		O.layer = ABOVE_HUD_LAYER
		O.plane = ABOVE_HUD_PLANE

	src.closer.screen_loc = "4:[storage_width+19],2:16"
	return

/atom/movable/screen/storage/clicked(mob/user, list/mods) //Much of this is replicated do_click behaviour.
	if(user.is_mob_incapacitated() || !isturf(user.loc))
		return TRUE

	if(master)
		var/obj/item/storage/S = master
		var/obj/item/I = user.get_active_hand()
		var/user_carried_master = user.contains(master)
		// Placing something in the storage screen
		if(I && !mods["alt"] && !mods["shift"] && !mods["ctrl"]) //These mods should be caught later on and either examine or do nothing.
			if(world.time <= user.next_move && !user_carried_master) //Click delay doesn't apply to clicking items in your first-layer inventory.
				return TRUE
			user.next_move = world.time
			if(master.Adjacent(user)) //Throwing a storage item (or, possibly, other people pulling it away) doesn't close its screen.
				user.click_adjacent(master, I, mods)
			return TRUE

		// examining or taking something out of the storage screen by clicking on item border overlay
		var/list/screen_loc_params = splittext(mods["screen-loc"], ",")
		var/list/screen_loc_X = splittext(screen_loc_params[1],":")
		var/click_x = text2num(screen_loc_X[1])*32+text2num(screen_loc_X[2]) - 144

		for(var/i in 1 to length(S.click_border_start))
			if(S.click_border_start[i] <= click_x && click_x <= S.click_border_end[i])
				var/list/content_items = list()
				for(var/obj/item/content_item in S.contents)
					content_items += content_item
				I = LAZYACCESS(content_items, i)
				if(I && I.Adjacent(user)) //Catches pulling items out of nested storage.
					if(I.clicked(user, mods)) //Examine, alt-click etc.
						return TRUE
					if(world.time <= user.next_move) //Clicking an item in storage respects click delays.
						return TRUE
					user.next_move = world.time
					user.click_adjacent(I, null, mods)
					return TRUE
	return FALSE

/obj/item/storage/Entered(atom/movable/AM, oldloc)
	. = ..()
	AM.layer = ABOVE_HUD_LAYER
	AM.plane = ABOVE_HUD_PLANE

/obj/item/storage/Exited(atom/movable/AM, newloc)
	. = ..()
	AM.layer = initial(AM.layer)
	AM.plane = initial(AM.plane)

/datum/numbered_display
	var/obj/item/sample_object
	var/number

/datum/numbered_display/New(obj/item/sample)
	if(!istype(sample))
		qdel(src)
	sample_object = sample
	number = 1

/datum/numbered_display/Destroy()
	sample_object = null
	return ..()

//This proc determins the size of the inventory to be displayed. Please touch it only if you know what you're doing.
/obj/item/storage/proc/orient2hud()

	var/adjusted_contents = length(contents)

	//Numbered contents display
	var/list/datum/numbered_display/numbered_contents
	if (storage_flags & STORAGE_CONTENT_NUM_DISPLAY)
		numbered_contents = list()
		adjusted_contents = 0
		for (var/obj/item/I in contents)
			var/found = 0
			for (var/datum/numbered_display/ND in numbered_contents)
				if (ND.sample_object.type == I.type)
					ND.number++
					found = 1
					break
			if (!found)
				adjusted_contents++
				numbered_contents.Add( new/datum/numbered_display(I) )

	if (storage_slots == null)
		space_orient_objs(numbered_contents)
	else
		var/row_num = 0
		var/col_count = min(7,storage_slots) -1
		if (adjusted_contents > 7)
			row_num = floor((adjusted_contents-1) / 7) // 7 is the maximum allowed width.
		slot_orient_objs(row_num, col_count, numbered_contents)
	return

///Returns TRUE if there is room for the given item. W_class_override allows checking for just a generic W_class, meant for checking shotgun handfuls without having to spawn and delete one just to check.
/obj/item/storage/proc/has_room(obj/item/new_item, W_class_override = null)
	for(var/obj/item/cur_item in contents)
		if(!istype(cur_item, /obj/item/stack) || !istype(new_item, /obj/item/stack))
			continue

		var/obj/item/stack/cur_stack = cur_item
		var/obj/item/stack/new_stack = new_item

		if(cur_stack.amount < cur_stack.max_amount && new_stack.stack_id == cur_stack.stack_id)
			return TRUE

	if(storage_slots != null && length(contents) < storage_slots)
		return TRUE //At least one open slot.

	//calculate storage space only for containers that don't have slots
	if (storage_slots == null)
		var/sum_storage_cost = W_class_override ? W_class_override : new_item.get_storage_cost() //Takes the override if there is one, the given item otherwise.
		for(var/obj/item/I in contents)
			sum_storage_cost += I.get_storage_cost() //Adds up the combined storage costs which will be in the storage item if the item is added to it.

		if(sum_storage_cost <= max_storage_space) //Adding this item won't exceed the maximum.
			return TRUE

#define SKILL_TYPE_INDEX 1
#define SKILL_LEVEL_INDEX 2

/obj/item/storage/proc/can_hold_type(type_to_hold, mob/user)
	if(length(can_hold_skill))
		for(var/can_hold_skill_typepath in can_hold_skill)
			if(ispath(type_to_hold, can_hold_skill_typepath) && user.skills?.get_skill_level(can_hold_skill[can_hold_skill_typepath][SKILL_TYPE_INDEX]) >= can_hold_skill[can_hold_skill_typepath][SKILL_LEVEL_INDEX])
				return TRUE
		if(can_hold_skill_only)
			return FALSE

	for(var/A in cant_hold)
		if(ispath(type_to_hold, A))
			return FALSE

	if(length(can_hold))
		for(var/A in can_hold)
			if(ispath(type_to_hold, A))
				return TRUE

		return FALSE

	return TRUE

#undef SKILL_TYPE_INDEX
#undef SKILL_LEVEL_INDEX

//This proc return 1 if the item can be picked up and 0 if it can't.
//Set the stop_messages to stop it from printing messages
/obj/item/storage/proc/can_be_inserted(obj/item/W, mob/user, stop_messages = FALSE)
	if(!istype(W) || (W.flags_item & NODROP))
		return //Not an item

	if(src.loc == W)
		return 0 //Means the item is already in the storage item

	//specific labeler check
	if(istype(W, /obj/item/tool/hand_labeler))
		var/obj/item/tool/hand_labeler/L = W
		if(L.mode)
			return 0

	if(W.heat_source && !(W.flags_item & IGNITING_ITEM))
		to_chat(usr, SPAN_ALERT("[W] is ignited, you can't store it!"))
		return

	if(!can_hold_type(W.type, user))
		if(!stop_messages)
			to_chat(usr, SPAN_NOTICE("[src] cannot hold [W]."))
		return

	var/w_limit_bypassed = 0
	if(length(bypass_w_limit))
		for(var/A in bypass_w_limit)
			if(istype(W, A))
				w_limit_bypassed = 1
				break

	if (!w_limit_bypassed && W.w_class > max_w_class)
		if(!stop_messages)
			to_chat(usr, SPAN_NOTICE("[W] is too long for this [src]."))
		return 0

	//Checks if there is room for the item.
	if(!has_room(W))
		if(!stop_messages)
			to_chat(usr, SPAN_NOTICE("[src] is full, make some space."))
		return 0

	if(W.w_class >= src.w_class && (isstorage(W)))
		if(!istype(src, /obj/item/storage/backpack/holding)) //bohs should be able to hold backpacks again. The override for putting a boh in a boh is in backpack.dm.
			if(!stop_messages)
				to_chat(usr, SPAN_NOTICE("[src] cannot hold [W] as it's a storage item of the same size."))
			return 0 //To prevent the stacking of same sized storage items.

	return 1

/**Handler for inserting items. It does not perform any checks of whether an item can or can't be inserted into the storage item.
That's done by can_be_inserted(). Its checks are whether the item exists, is an item, and (if it's held by a mob) the mob can drop it.
The stop_warning parameter will stop the insertion message from being displayed. It is intended for cases where you are inserting multiple
items at once, such as when picking up all the items on a tile with one click.
user can be null, it refers to the potential mob doing the insertion.**/
/obj/item/storage/proc/handle_item_insertion(obj/item/new_item, prevent_warning = FALSE, mob/user)
	if(!istype(new_item))
		return FALSE

	if(user && new_item.loc == user)
		if(istype(new_item, /obj/item/stack))
			var/obj/item/stack/new_stack = new_item

			for(var/obj/item/cur_item in contents)
				if(!istype(cur_item, /obj/item/stack))
					continue
				var/obj/item/stack/cur_stack = cur_item

				if(cur_stack.amount < cur_stack.max_amount && new_stack.stack_id == cur_stack.stack_id)
					var/amount = min(cur_stack.max_amount - cur_stack.amount, new_stack.amount)
					new_stack.use(amount)
					cur_stack.add(amount)

			if(!QDELETED(new_stack) && can_be_inserted(new_stack, user))
				if(!user.drop_inv_item_to_loc(new_item, src))
					return FALSE
			else
				return TRUE

		if(!user.drop_inv_item_to_loc(new_item, src))
			return FALSE
	else
		new_item.forceMove(src)

	_item_insertion(new_item, prevent_warning, user)
	return TRUE

/**Inserts the item. Separate proc because handle_item_insertion isn't guaranteed to insert
and it therefore isn't safe to override it before calling parent. Updates icon when done.
Can be called directly but only if the item was spawned inside src - handle_item_insertion is safer.
W is always an item. stop_warning prevents messaging. user may be null.**/
/obj/item/storage/proc/_item_insertion(obj/item/W, prevent_warning = FALSE, mob/user)
	W.on_enter_storage(src)
	if(user)
		if (user.client && user.s_active != src)
			user.client.remove_from_screen(W)
		add_fingerprint(user)
		if(!prevent_warning)
			var/visidist = W.w_class >= 3 ? 3 : 1
			user.visible_message(SPAN_NOTICE("[user] puts [W] into [src]."),
								SPAN_NOTICE("You put \the [W] into [src]."),
								null, visidist)
	orient2hud()
	for(var/mob/M in can_see_content())
		show_to(M)
	if (storage_slots)
		W.mouse_opacity = MOUSE_OPACITY_OPAQUE //not having to click the item's tiny sprite to take it out of the storage.
	update_icon()
	if(user)
		user.update_inv_l_hand()
		user.update_inv_r_hand()

///Call this proc to handle the removal of an item from the storage item. The item will be moved to the atom sent as new_target.
/obj/item/storage/proc/remove_from_storage(obj/item/W as obj, atom/new_location, mob/user)
	if(!istype(W))
		return FALSE

	_item_removal(W, new_location, user)
	return TRUE

///Separate proc because remove_from_storage isn't guaranteed to finish. Can be called directly if the target atom exists and is an item. Updates icon when done.
/obj/item/storage/proc/_item_removal(obj/item/W as obj, atom/new_location, mob/user)
	for(var/mob/M in can_see_content())
		if(M.client)
			M.client.remove_from_screen(W)

	if(new_location)
		if(ismob(new_location))
			W.pickup(new_location)
		W.forceMove(new_location)
	else
		var/turf/T = get_turf(src)
		if(T)
			W.forceMove(T)
		else
			W.moveToNullspace()

	orient2hud()
	for(var/mob/M in can_see_content())
		show_to(M)
	if(W.maptext && (storage_flags & STORAGE_CONTENT_NUM_DISPLAY))
		W.maptext = ""
	W.on_exit_storage(src)
	update_icon()
	if(user)
		user.update_inv_l_hand()
		user.update_inv_r_hand()
	W.mouse_opacity = initial(W.mouse_opacity)

//This proc is called when you want to place an item into the storage item.
/obj/item/storage/attackby(obj/item/W as obj, mob/user as mob)
	..()
	return attempt_item_insertion(W, FALSE, user)

/obj/item/storage/equipped(mob/user, slot, silent)
	if ((storage_flags & STORAGE_ALLOW_EMPTY))
		if(!isxeno(user))
			verbs |= /obj/item/storage/verb/empty_verb
			verbs |= /obj/item/storage/verb/toggle_click_empty
		else
			verbs -= /obj/item/storage/verb/empty_verb
			verbs -= /obj/item/storage/verb/toggle_click_empty
	..()

/obj/item/storage/proc/attempt_item_insertion(obj/item/W as obj, prevent_warning = FALSE, mob/user as mob)
	if(!can_be_inserted(W, user))
		return

	W.add_fingerprint(user)
	return handle_item_insertion(W, prevent_warning, user)

/obj/item/storage/attack_hand(mob/user, mods)
	if (loc == user)
		if((mods && mods["alt"] || storage_flags & STORAGE_USING_DRAWING_METHOD) && ishuman(user) && length(contents)) //Alt mod can reach attack_hand through the clicked() override.
			var/obj/item/I
			if(storage_flags & STORAGE_USING_FIFO_DRAWING)
				I = contents[1]
			else
				I = contents[length(contents)]
			I.attack_hand(user)
		else
			open(user)
	else
		..()
		for(var/mob/M in content_watchers)
			storage_close(M)
	add_fingerprint(user)

/obj/item/storage/verb/toggle_gathering_mode()
	set name = "Switch Gathering Method"
	set category = "Object"
	set src in usr
	storage_flags ^= STORAGE_GATHER_SIMULTAENOUSLY
	if (storage_flags & STORAGE_GATHER_SIMULTAENOUSLY)
		to_chat(usr, "[src] now picks up all items in a tile at once.")
	else
		to_chat(usr, "[src] now picks up one item at a time.")

/obj/item/storage/verb/toggle_draw_mode()
	set name = "Switch Storage Drawing Method"
	set category = "Object"
	set src in usr

	storage_draw_logic(src.name)


/obj/item/storage/verb/toggle_click_empty()
	set name = "Toggle Tile Dumping"
	set category = "Object"
	set src in usr
	storage_flags ^= STORAGE_CLICK_EMPTY
	if (storage_flags & STORAGE_CLICK_EMPTY)
		to_chat(usr, "Clicking on a tile with [src] in your hand now empties its contents on that tile.")
	else
		to_chat(usr, "Clicking on a tile with [src] in your hand will no longer do anything.")

/obj/item/storage/verb/empty_verb()
	set name = "Empty"
	set category = "Object"
	set src in usr
	var/mob/living/carbon/human/H = usr
	empty(H, get_turf(H))

/obj/item/storage/proc/empty(mob/user, turf/T)
	if (!(storage_flags & STORAGE_ALLOW_EMPTY) || !ishuman(user) || !(user.l_hand == src || user.r_hand == src) || user.is_mob_incapacitated())
		return

	if (!isturf(T) || get_dist(src, T) > 1)
		T = get_turf(src)

	if(!allowed(user))
		to_chat(user, SPAN_WARNING("Access denied."))
		return

	if(!length(contents))
		to_chat(user, SPAN_WARNING("[src] is already empty."))
		return

	if (!(storage_flags & STORAGE_QUICK_EMPTY))
		user.visible_message(SPAN_NOTICE("[user] starts to empty \the [src]..."),
			SPAN_NOTICE("You start to empty \the [src]..."))
		if (!do_after(user, 2 SECONDS, INTERRUPT_ALL, BUSY_ICON_GENERIC))
			return

	storage_close(user)
	for (var/obj/item/I in contents)
		remove_from_storage(I, T, user)
	user.visible_message(SPAN_NOTICE("[user] empties \the [src]."),
		SPAN_NOTICE("You empty \the [src]."))
	if (use_sound)
		playsound(loc, use_sound, 25, TRUE, 3)

/obj/item/storage/verb/shake_verb()
	set name = "Shake"
	set category = "Object"
	set src in usr
	var/mob/user_mob = usr
	shake(user_mob, get_turf(user_mob))

/obj/item/storage/proc/shake(mob/user, turf/tile)
	if(!(storage_flags & STORAGE_ALLOW_EMPTY))
		return

	if(user.l_hand != src && user.r_hand != src && user.back != src)
		return

	if(user.is_mob_incapacitated())
		return

	if (!isturf(tile) || get_dist(src, tile) > 1)
		tile = get_turf(src)

	if (use_sound)
		playsound(loc, use_sound, 25, TRUE, 3)

	if(!length(contents))
		if(prob(25) && isxeno(user))
			user.drop_inv_item_to_loc(src, tile)
			user.visible_message(SPAN_NOTICE("[user] shakes \the [src] off."),
				SPAN_NOTICE("You shake \the [src] off."))
		else
			user.visible_message(SPAN_NOTICE("[user] shakes \the [src] but nothing falls out."),
				SPAN_NOTICE("You shake \the [src] but nothing falls out. It feels empty."))
		return

	if(!allowed(user))
		user.visible_message(SPAN_NOTICE("[user] shakes \the [src] but nothing falls out."),
			SPAN_NOTICE("You shake \the [src] but nothing falls out. Access denied."))
		return

	if(!prob(75))
		user.visible_message(SPAN_NOTICE("[user] shakes \the [src] but nothing falls out."),
			SPAN_NOTICE("You shake \the [src] but nothing falls out."))
		return

	storage_close(user)
	var/obj/item/item_obj
	if(storage_flags & STORAGE_USING_FIFO_DRAWING)
		item_obj = contents[1]
	else
		item_obj = contents[length(contents)]
	if(!istype(item_obj))
		return
	remove_from_storage(item_obj, tile, user)
	user.visible_message(SPAN_NOTICE("[user] shakes \the [src] and \a [item_obj] falls out."),
		SPAN_NOTICE("You shake \the [src] and \a [item_obj] falls out."))

/obj/item/storage/proc/dump_ammo_to(obj/item/ammo_magazine/ammo_dumping, mob/user, amount_to_dump = 5) //amount_to_dump should never actually need to be used as default value
	if(user.action_busy)
		return

	if(ammo_dumping.flags_magazine & AMMUNITION_CANNOT_REMOVE_BULLETS)
		to_chat(user, SPAN_WARNING("You can't remove ammo from \the [ammo_dumping]!"))
		return

	if(ammo_dumping.flags_magazine & AMMUNITION_HANDFUL_BOX)
		var/handfuls = round(ammo_dumping.current_rounds / amount_to_dump, 1) //The number of handfuls, we round up because we still want the last one that isn't full
		if(ammo_dumping.current_rounds != 0)
			if(length(contents) < storage_slots)
				to_chat(user, SPAN_NOTICE("You start refilling [src] with [ammo_dumping]."))
				if(!do_after(user, 1.5 SECONDS, INTERRUPT_ALL, BUSY_ICON_GENERIC))
					return
				for(var/i = 1 to handfuls)
					if(length(contents) < storage_slots)
						//Hijacked from /obj/item/ammo_magazine/proc/create_handful because it had to be handled differently
						//All this because shell types are instances and not their own objects :)

						var/obj/item/ammo_magazine/handful/new_handful = new /obj/item/ammo_magazine/handful
						var/transferred_handfuls = min(ammo_dumping.current_rounds, amount_to_dump)
						new_handful.generate_handful(ammo_dumping.default_ammo, ammo_dumping.caliber, amount_to_dump, transferred_handfuls, ammo_dumping.gun_type)
						ammo_dumping.current_rounds -= transferred_handfuls
						handle_item_insertion(new_handful, TRUE, user)
						update_icon(-transferred_handfuls)
					else
						break
				playsound(user.loc, "rustle", 15, TRUE, 6)
				ammo_dumping.update_icon()
			else
				to_chat(user, SPAN_WARNING("[src] is full."))
		else
			to_chat(user, SPAN_WARNING("[ammo_dumping] is empty."))
	return TRUE

/obj/item/storage/proc/dump_into(obj/item/storage/origin_storage, mob/user)

	if(user.action_busy)
		return

	if(!length(origin_storage.contents))
		to_chat(user, SPAN_WARNING("[origin_storage] is empty."))
		return
	if(!has_room(origin_storage.contents[1])) //Does it have room for the first item to be inserted?
		to_chat(user, SPAN_WARNING("[src] is full."))
		return

	to_chat(user, SPAN_NOTICE("You start refilling [src] with [origin_storage]."))
	if(!do_after(user, 1.5 SECONDS, INTERRUPT_ALL, BUSY_ICON_GENERIC))
		return
	for(var/obj/item/new_item in origin_storage)
		if(!has_room(new_item))
			break
		origin_storage.remove_from_storage(new_item, user)
		handle_item_insertion(new_item, TRUE, user) //quiet insertion

	playsound(user.loc, "rustle", 15, TRUE, 6)
	return TRUE

/obj/item/storage/Initialize()
	. = ..()
	if (!(storage_flags & STORAGE_QUICK_GATHER))
		verbs -= /obj/item/storage/verb/toggle_gathering_mode

	if (!(storage_flags & STORAGE_ALLOW_DRAWING_METHOD_TOGGLE))
		verbs -= /obj/item/storage/verb/toggle_draw_mode

	if (!(storage_flags & STORAGE_ALLOW_EMPTY))
		verbs -= /obj/item/storage/verb/empty_verb
		verbs -= /obj/item/storage/verb/toggle_click_empty
		verbs -= /obj/item/storage/verb/shake_verb

	boxes = new
	boxes.name = "storage"
	boxes.master = src
	boxes.icon_state = "block"
	boxes.screen_loc = "7,7 to 10,8"
	boxes.layer = HUD_LAYER

	storage_start = new /atom/movable/screen/storage()
	storage_start.name = "storage"
	storage_start.master = src
	storage_start.icon_state = "storage_start"
	storage_start.screen_loc = "7,7 to 10,8"
	storage_end = new /atom/movable/screen/storage()
	storage_end.name = "storage"
	storage_end.master = src
	storage_end.icon_state = "storage_end"
	storage_end.screen_loc = "7,7 to 10,8"

	closer = new
	closer.master = src

	if(!(flags_atom & NO_GAMEMODE_SKIN))
		select_gamemode_skin(type)
	post_skin_selection()
	fill_preset_inventory()
	update_icon()

/*
 * We need to do this separately from Destroy too...
 * When a mob is deleted, it's first ghostize()ed,
 * then its equipement is deleted. This means that client
 * is already unset and can't be used for clearing
 * screen objects properly.
 */
/obj/item/storage/proc/watcher_deleted(mob/watcher)
	SIGNAL_HANDLER
	storage_close(watcher)

/obj/item/storage/proc/dump_objectives()
	for(var/obj/item/cur_item in src)
		if(cur_item.is_objective)
			remove_from_storage(cur_item, loc)


/obj/item/storage/Destroy()
	dump_objectives()
	for(var/mob/M in content_watchers)
		hide_from(M)
	content_watchers = null
	QDEL_NULL(boxes)
	QDEL_NULL(storage_start)
	QDEL_NULL(storage_continue)
	QDEL_NULL(storage_end)
	QDEL_NULL(closer)
	stored_ISB = null
	return ..()

/obj/item/storage/emp_act(severity)
	. = ..()
	if(!istype(src.loc, /mob/living))
		for(var/obj/O in contents)
			O.emp_act(severity)
	..()

/obj/item/storage/attack_self(mob/user)
	..()

	//Clicking on itself will empty it, if it has contents and the verb to do that. Contents but no verb means nothing happens.
	if(length(contents))
		if (!(storage_flags & STORAGE_DISABLE_USE_EMPTY))
			empty(user)
		return

	//Otherwise we'll try to fold it.
	if(!foldable)
		return

	// Close any open UI windows first
	storage_close(user)

	if(ispath(foldable))
		new foldable(get_turf(src))
	to_chat(user, SPAN_NOTICE("You fold [src] flat."))
	qdel(src)

/obj/item/storage/afterattack(atom/target, mob/user, proximity)
	if(!proximity)
		return

	if(isturf(target) && get_dist(src, target) <= 1 && storage_flags & STORAGE_CLICK_EMPTY)
		empty(user, target)

/obj/item/storage/hear_talk(mob/living/M, msg, verb, datum/language/speaking, italics)
	// Whatever is stored in /storage/ substypes should ALWAYS be an item
	for (var/obj/item/I as anything in hearing_items)
		I.hear_talk(M, msg, verb, speaking, italics)

/obj/item/proc/get_storage_cost() //framework for adjusting storage costs
	if (storage_cost)
		return storage_cost
	else
		return w_class

/obj/item/storage/proc/fill_preset_inventory()
	return

///Things to be done after selecting a map skin (if any) and before adding inventory and updating icon for the first time. Most likely saving basic icon state.
/obj/item/storage/proc/post_skin_selection()
	return

/**Returns the storage depth of an atom. This is the number of items the atom is nested in before reaching the designated container, counted inclusively.
Returning 1 == directly inside the container's contents, 2 == inside something which is itself inside the container, etc.
An alternative to loc.loc; looked at another way, the number it returns is the number of loc checks before reaching the target.
Returns FALSE if the atom isn't somewhere inside the container's contents.**/
/atom/proc/get_storage_depth_to(atom/container)
	var/atom/cur_atom = src
	. = 1

	while(cur_atom && cur_atom.loc != container)
		if(isarea(cur_atom))
			return FALSE
		.++
		cur_atom = cur_atom.loc

	if(!cur_atom)
		return FALSE //inside something with a null loc.

/**Like get storage depth to, but returns the depth to the nearest turf, inclusively
Returns FALSE if no top level turf (a loc was null somewhere, or a non-turf atom's loc was an area somehow).**/
/atom/proc/get_storage_depth_turf()
	var/atom/cur_atom = src
	. = 1

	while(cur_atom && !isturf(cur_atom))
		if(isarea(cur_atom))
			return FALSE
		.++
		cur_atom = cur_atom.loc

	if(!cur_atom)
		return FALSE
