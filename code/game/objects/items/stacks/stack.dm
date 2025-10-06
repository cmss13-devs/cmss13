/* Stack type objects!
 * Contains:
 * Stacks
 * Recipe datum
 * Recipe list datum
 */

/*
 * Stacks
 */

/obj/item/stack
	gender = PLURAL

	var/list/datum/stack_recipe/recipes
	var/singular_name
	var/amount = 1
	///also see stack recipes initialisation, param "max_res_amount" must be equal to this max_amount
	var/max_amount
	///used to determine if two stacks are of the same kind.
	var/stack_id
	///does it have sprites for extra amount, like metal, plasteel, or wood
	var/amount_sprites = FALSE
	///does it show amount on top of the icon
	var/display_maptext = TRUE
	//Coords for contents display, to make it play nice with inventory borders.
	maptext_x = 4
	maptext_y = 3

/obj/item/stack/Initialize(mapload, amount = null)
	. = ..()
	if(amount)
		src.amount = amount
	if(!singular_name)
		singular_name = name
	update_icon()

/*Check the location of the stack, and if it's in a storage item or a mob's inventory, display the number of items in the stack.
Also change the icon to reflect the amount of sheets, if possible.*/
/obj/item/stack/update_icon()
	..()
	if((isstorage(loc) || ismob(loc)) && display_maptext)
		maptext = SPAN_LANGCHAT("[(amount > 1)? "[amount]" : ""]")
	else
		maptext = ""

	if(!amount_sprites)
		return
	if(amount == 1)
		icon_state = initial(icon_state) //if it has only one sheet, it is the singular sprite
	else if(amount < max_amount * 0.5)
		icon_state = "[initial(icon_state)]-2" //if it's less than half the max amount, use the 2 sheets sprite
	else if(amount < max_amount)
		icon_state = "[initial(icon_state)]-3" //if it's equal or more than half of max amount, but less than the maximum, use 3 sheets
	else
		icon_state = "[initial(icon_state)]-4" //otherwise use max sheet sprite

/obj/item/stack/equipped() //Used when entering a mob's hands.
	..()
	update_icon()

/obj/item/stack/on_exit_storage()
	..()
	if(ismob(loc))
		return
	update_icon()

/obj/item/stack/dropped() //Also used when inserted into storage items.
	..()
	update_icon()

/obj/item/stack/get_examine_text(mob/user)
	. = ..()
	. += "There are [amount] [singular_name]\s in the stack."

/obj/item/stack/tgui_interact(mob/user, datum/tgui/ui)
	if(length(recipes) <= 0)
		return
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "StackReceipts", "Constructions from the [name]")
		ui.open()

/obj/item/stack/proc/get_unified_stack_receipts()
	var/list/uni_receipts = list()

	for(var/i in 1 to length(recipes))
		var/receipt = recipes[i]
		if (!receipt)
			continue

		if (istype(receipt, /datum/stack_recipe_list))
			var/datum/stack_recipe_list/srl = receipt

			for (var/j in 1 to length(srl.recipes))
				var/datum/stack_recipe/rec = srl.recipes[j]
				if (!istype(rec, /datum/stack_recipe))
					continue

				LAZYADD(uni_receipts, rec)
			LAZYADD(uni_receipts, srl)
			continue

		if (istype(receipt, /datum/stack_recipe))
			var/datum/stack_recipe/rec = receipt
			LAZYADD(uni_receipts, rec)

	return uni_receipts

/obj/item/stack/ui_assets(mob/user)
	return list(get_asset_datum(/datum/asset/spritesheet/stack_receipts))

/obj/item/stack/ui_act(action, list/params, datum/tgui/ui, datum/ui_state/state)
	. = ..()
	if(!ui || !ui.user)
		return

	if((ui.user.is_mob_restrained() || ui.user.stat || ui.user.get_active_hand() != src))
		return

	if(amount < 1)
		qdel(src) //Never should happen
		return FALSE

	if(action != "make")
		return FALSE

	var/id = params["id"]
	var/list/recipes_list = get_unified_stack_receipts()
	if(!recipes_list || !length(recipes_list))
		return FALSE

	var/raw_recipe = recipes_list[id]

	if (istype(raw_recipe, /datum/stack_recipe_list))
		return FALSE

	var/datum/stack_recipe/recipe = raw_recipe

	if(!recipe) // Oh no
		return FALSE

	var/multiplier = params["multiplier"]

	if(multiplier != multiplier) // isnan
		message_admins("[key_name_admin(ui.user)] has attempted to multiply [src] with NaN")
		return FALSE
	if(!isnum(multiplier)) // this used to block nan...
		message_admins("[key_name_admin(ui.user)] has attempted to multiply [src] with !isnum")
		return FALSE
	multiplier = floor(multiplier)

	if(multiplier < 1)
		return FALSE  //href exploit protection

	if(recipe.max_res_amount <= 1)
		multiplier = 1

	if(recipe.skill_lvl)
		if(ishuman(ui.user) && !skillcheck(ui.user, recipe.skill_req, recipe.skill_lvl))
			to_chat(ui.user, SPAN_WARNING("You are not trained to build this..."))
			return FALSE
	if(amount < recipe.req_amount * multiplier)
		if(recipe.req_amount * multiplier > 1)
			to_chat(ui.user, SPAN_WARNING("You need more [name] to build \the [recipe.req_amount*multiplier] [recipe.title]\s!"))
		else
			to_chat(ui.user, SPAN_WARNING("You need more [name] to build \the [recipe.title]!"))
		return FALSE

	if(check_one_per_turf(recipe, ui.user))
		return FALSE

	if(recipe.on_floor && istype(ui.user.loc, /turf/open))
		var/turf/open/OT = ui.user.loc
		var/obj/structure/blocker/anti_cade/AC = locate(/obj/structure/blocker/anti_cade) in ui.user.loc // for M2C HMG, look at smartgun_mount.dm
		var/area/area = get_area(ui.user)
		if(!OT.allow_construction || !area.allow_construction)
			to_chat(ui.user, SPAN_WARNING("The [recipe.title] must be constructed on a proper surface!"))
			return FALSE

		if(AC)
			to_chat(ui.user, SPAN_WARNING("The [recipe.title] cannot be built here!"))  //might cause some friendly fire regarding other items like barbed wire, shouldn't be a problem?
			return FALSE

		var/obj/structure/tunnel/tunnel = locate(/obj/structure/tunnel) in ui.user.loc
		if(tunnel)
			to_chat(ui.user, SPAN_WARNING("The [recipe.title] cannot be constructed on a tunnel!"))
			return FALSE

		if(recipe.one_per_turf != ONE_TYPE_PER_BORDER) //all barricade-esque structures utilize this define and have their own check for object density. checking twice is unneeded.
			for(var/obj/object in ui.user.loc)
				if(object.density || istype(object, /obj/structure/machinery/door/airlock))
					to_chat(ui.user, SPAN_WARNING("[object] is blocking you from constructing \the [recipe.title]!"))
					return FALSE

	if((recipe.flags & RESULT_REQUIRES_SNOW) && !(istype(ui.user.loc, /turf/open/snow) || istype(ui.user.loc, /turf/open/auto_turf/snow)))
		to_chat(ui.user, SPAN_WARNING("The [recipe.title] must be built on snow!"))
		return FALSE

	if(recipe.time)
		if(ui.user.action_busy)
			return FALSE
		var/time_mult = skillcheck(ui.user, SKILL_CONSTRUCTION, 2) ? 1 : 2
		ui.user.visible_message(SPAN_NOTICE("[ui.user] starts assembling \a [recipe.title]."),
			SPAN_NOTICE("You start assembling \a [recipe.title]."))
		if(!do_after(ui.user, max(recipe.time * time_mult, recipe.min_time), INTERRUPT_NO_NEEDHAND|BEHAVIOR_IMMOBILE, BUSY_ICON_BUILD))
			return FALSE

		//check again after some time has passed
		if(amount < recipe.req_amount * multiplier)
			return FALSE

		if(check_one_per_turf(recipe,ui.user))
			return FALSE

	var/atom/new_item
	if(ispath(recipe.result_type, /turf))
		var/turf/current_turf = get_turf(ui.user)
		if(!current_turf)
			return FALSE
		new_item = current_turf.ChangeTurf(recipe.result_type)
	else
		new_item = new recipe.result_type(ui.user.loc, ui.user)

	ui.user.visible_message(SPAN_NOTICE("[ui.user] assembles \a [new_item]."),
	SPAN_NOTICE("You assemble \a [new_item]."))
	new_item.setDir(ui.user.dir)
	if(recipe.max_res_amount > 1)
		var/obj/item/stack/new_stack = new_item
		new_stack.amount = recipe.res_amount * multiplier
	amount -= recipe.req_amount * multiplier
	update_icon()

	if(amount <= 0)
		var/oldsrc = src
		src = null //dont kill proc after qdel()
		ui.user.drop_inv_item_on_ground(oldsrc)
		qdel(oldsrc)

	if(istype(new_item,/obj/item/stack)) //floor stacking convenience
		var/obj/item/stack/stack_item = new_item
		for(var/obj/item/stack/found_item in ui.user.loc)
			if(stack_item.stack_id == found_item.stack_id && stack_item != found_item)
				var/diff = found_item.max_amount - found_item.amount
				if (stack_item.amount < diff)
					found_item.amount += stack_item.amount
					qdel(stack_item)
				else
					stack_item.amount -= diff
					found_item.amount += diff
				break

	new_item?.add_fingerprint(ui.user)

	//BubbleWrap - so newly formed boxes are empty
	if(isstorage(new_item))
		for (var/obj/item/found_item in new_item)
			qdel(found_item)
	//BubbleWrap END

	return TRUE

/obj/item/stack/attack_self(mob/user)
	..()

	tgui_interact(usr)
	user.set_interaction(src)

/obj/item/stack/proc/create_recipe_ui_data(datum/stack_recipe/rec, id, empty_line_next = FALSE)
	var/max_build = min(20, floor(amount / rec.req_amount))
	var/can_build = max_build > 0

	var/icon/image_icon = null
	var/imgid = null
	var/is_multi = rec.max_res_amount > 1 && max_build > 1
	var/image_size = null

	if (rec.result_type)
		var/obj/item_ref = rec.result_type

		image_icon = icon(initial(item_ref.icon), initial(item_ref.icon_state))
		imgid = replacetext(replacetext("[item_ref]", "/obj/item/", ""), "/", "-")
		image_size = "[image_icon.Width()]x[image_icon.Height()]"

	return list(
		"id" = id,
		"title" = rec.title,
		"req_amount" = rec.req_amount,
		"res_amount" = rec.res_amount,
		"is_multi" = is_multi,
		"maximum_to_build" = max_build,
		"can_build" = can_build,
		"amount_to_build" = 1 * rec.res_amount,
		"empty_line_next" = empty_line_next,
		"image" = imgid,
		"image_size" = image_size,
	)

/obj/item/stack/ui_static_data(mob/user)
	. = ..()

	.["stack_name"] = name
	.["singular_name"] = singular_name

/obj/item/stack/ui_data(mob/user)
	if (!src || amount <= 0)
		return

	. = ..()
	.["stack_receipts"] = list()
	.["stack_amount"] = amount

	var/item_id = 1
	var/empty_line_next = FALSE

	for(var/i in 1 to length(recipes))
		var/single = recipes[i]
		if (isnull(single))
			empty_line_next = TRUE
			continue

		if (istype(single, /datum/stack_recipe_list))
			var/datum/stack_recipe_list/srl = single
			var/list/sub = list()

			for (var/j in 1 to length(srl.recipes))
				var/datum/stack_recipe/rec = srl.recipes[j]
				if (!istype(rec, /datum/stack_recipe))
					continue
				LAZYADD(sub, list(create_recipe_ui_data(rec, item_id)))
				item_id++

			LAZYADD(.["stack_receipts"], list(list(
				"id" = item_id,
				"title" = srl.title,
				"stack_sub_receipts" = sub
			)))
			item_id++
			empty_line_next = FALSE
			continue

		if (istype(single, /datum/stack_recipe))
			var/datum/stack_recipe/rec = single
			LAZYADD(.["stack_receipts"], list(create_recipe_ui_data(rec, item_id, empty_line_next)))
			item_id++
			empty_line_next = FALSE

/obj/item/stack/proc/check_one_per_turf(datum/stack_recipe/R, mob/user)
	switch(R.one_per_turf)

		if(ONE_TYPE_PER_TURF)
			if(locate(R.result_type) in user.loc)
				to_chat(user, SPAN_WARNING("There is already another [R.title] here!"))
				return TRUE

		if(ONE_TYPE_PER_BORDER)
			for(var/obj/O in user.loc) //Objects, we don't care about mobs. Turfs are checked elsewhere
				if(O.density && !istype(O, R.result_type) && !((O.flags_atom & ON_BORDER))) //Note: If no dense items, or if dense item, both it and result must be border tiles
					to_chat(user, SPAN_WARNING("You need a clear, open area to build \a [R.title]!"))
					return TRUE
				if((O.flags_atom & ON_BORDER) && O.dir == usr.dir) //We check overlapping dir here. Doesn't have to be the same type
					to_chat(user, SPAN_WARNING("There is already \a [O.name] in this direction!"))
					return TRUE

	return FALSE

/obj/item/stack/proc/use(used)
	if(used > amount) //If it's larger than what we have, no go.
		return FALSE
	amount -= used
	if(amount <= 0)
		if(loc == usr)
			usr?.temp_drop_inv_item(src)
		else if(isstorage(loc))
			var/obj/item/storage/storage = loc
			storage.remove_from_storage(src)
		qdel(src)
	else
		update_icon()
	return TRUE

/obj/item/stack/proc/add(extra)
	if(amount + extra > max_amount)
		return FALSE
	amount += extra
	update_icon()
	return TRUE

/obj/item/stack/proc/get_amount()
	return amount

/obj/item/stack/proc/add_to_stacks(mob/user)
	var/obj/item/stack/oldsrc = src
	src = null
	for (var/obj/item/stack/item in user.loc)
		if (item==oldsrc)
			continue
		if (!istype(item, oldsrc.type))
			continue
		if (item.amount>=item.max_amount)
			continue
		oldsrc.attackby(item, user)
		to_chat(user, "You add new [item.singular_name] to the stack. It now contains [item.amount] [item.singular_name]\s.")
		if(!oldsrc)
			break

/obj/item/stack/clicked(mob/user, list/mods)
	if(mods[ALT_CLICK])
		if(!CAN_PICKUP(user, src))
			return
		if(amount <= 1)
			return
		var/desired = tgui_input_number(user, "How much would you like to split off from this stack?", "How much?", 1, amount-1, 1)
		if(!desired)
			return
		if(!use(desired))
			return
		var/obj/item/stack/newstack = new type(user, desired)
		transfer_fingerprints_to(newstack)
		user.put_in_hands(newstack)
		add_fingerprint(user)
		newstack.add_fingerprint(user)
		if(!QDELETED(src) && user.interactee == src)
			INVOKE_ASYNC(src, TYPE_PROC_REF(/obj/item/stack, interact), user)
		return TRUE

	return ..()

/obj/item/stack/attack_hand(mob/user as mob)
	if(user.get_inactive_hand() == src)
		var/obj/item/stack/new_stack = new type(user, 1)
		transfer_fingerprints_to(new_stack)
		user.put_in_hands(new_stack)
		add_fingerprint(user)
		new_stack.add_fingerprint(user)
		use(1)
		if(!QDELETED(src) && user.interactee == src)
			INVOKE_ASYNC(src, TYPE_PROC_REF(/obj/item/stack, interact), user)
		return

	return ..()

/obj/item/stack/attackby(obj/item/W as obj, mob/user as mob)
	if(istype(W, /obj/item/stack))
		var/obj/item/stack/other_stack = W
		if(other_stack.stack_id == stack_id) //same stack type
			if(other_stack.amount >= max_amount)
				to_chat(user, SPAN_WARNING("The stack is full!"))
				return TRUE
			var/to_transfer = min(amount, other_stack.max_amount - other_stack.amount)
			if(to_transfer <= 0)
				return
			to_chat(user, SPAN_INFO("You transfer [to_transfer] between the stacks."))
			other_stack.add(to_transfer)
			if(other_stack && user.interactee == other_stack)
				INVOKE_ASYNC(other_stack, TYPE_PROC_REF(/obj/item/stack, interact), user)
			use(to_transfer)
			if(!QDELETED(src) && user.interactee == src)
				INVOKE_ASYNC(src, TYPE_PROC_REF(/obj/item/stack, interact), user)
			user.next_move = world.time + 0.3 SECONDS
			return TRUE

	return ..()

/*
 * Recipe datum
 */
/datum/stack_recipe
	var/title = "ERROR"
	var/result_type
	var/req_amount = 1
	var/res_amount = 1
	var/max_res_amount = 1
	var/time = 0
	var/min_time = 0
	var/one_per_turf = 0
	var/on_floor = 0
	var/skill_req = SKILL_CONSTRUCTION
	var/skill_lvl = 0 //whether only people with sufficient construction skill can build this.
	var/flags = NO_FLAGS

/datum/stack_recipe/New(title, result_type, req_amount = 1, res_amount = 1, max_res_amount = 1, time = 0, one_per_turf = 0, on_floor = 0, skill_req, skill_lvl = 0, min_time = 0, flags = NO_FLAGS)
	src.title = title
	src.result_type = result_type
	src.req_amount = req_amount
	src.res_amount = res_amount
	src.max_res_amount = max_res_amount
	src.time = time
	src.min_time = min_time
	src.one_per_turf = one_per_turf
	src.on_floor = on_floor
	src.skill_req = skill_req
	src.skill_lvl = skill_lvl
	src.flags = flags

/*
 * Recipe list datum
 */
/datum/stack_recipe_list
	var/title = "ERROR"
	var/list/recipes = null
	var/req_amount = 1

/datum/stack_recipe_list/New(title, recipes, req_amount = 1)
	src.title = title
	src.recipes = recipes
	src.req_amount = req_amount
