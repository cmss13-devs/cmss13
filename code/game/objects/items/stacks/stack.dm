/* Stack type objects!
 * Contains:
 * 		Stacks
 * 		Recipe datum
 * 		Recipe list datum
 */

/*
 * Stacks
 */

#define SHOW_FULL_LIST "More Recipes"

/obj/item/stack
	gender = PLURAL

	var/list/datum/stack_recipe/recipes
	var/singular_name
	var/amount = 1
	var/max_amount //also see stack recipes initialisation, param "max_res_amount" must be equal to this max_amount
	var/stack_id //used to determine if two stacks are of the same kind.
	var/amount_sprites = FALSE //does it have sprites for extra amount, like metal, plasteel, or wood
	var/display_maptext = TRUE //does it show amount on top of the icon
	//Coords for contents display, to make it play nice with inventory borders.
	maptext_x = 4
	maptext_y = 3

	var/list/radial_buildables
	var/list/radial_options

/obj/item/stack/Initialize(mapload, var/amount = null)
	. = ..()
	if(amount)
		src.amount = amount
	if(!singular_name)
		singular_name = name
	if(length(radial_buildables))
		var/list/rebuilt_radial_buildables = list()
		radial_options = list()
		radial_options[SHOW_FULL_LIST] = image(icon = 'icons/mob/radial.dmi', icon_state = "radial_more")
		for(var/atom/buildable as anything in radial_buildables)
			var/buildable_name = capitalize_first_letters(initial(buildable.name))
			radial_options[buildable_name] = image(icon = initial(buildable.icon), icon_state = initial(buildable.icon_state))
			rebuilt_radial_buildables[buildable_name] = buildable
		radial_buildables = rebuilt_radial_buildables
	update_icon()

/*Check the location of the stack, and if it's in a storage item or a mob's inventory, display the number of items in the stack.
Also change the icon to reflect the amount of sheets, if possible.*/
/obj/item/stack/update_icon()
	..()
	if((isstorage(loc) || ismob(loc)) && display_maptext)
		maptext = "<span class='langchat'>[(amount > 1)? "[amount]" : ""]</span>"
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

/obj/item/stack/Destroy()
	if (usr && usr.interactee == src)
		close_browser(src, "stack")
	return ..()

/obj/item/stack/examine(mob/user)
	..()
	to_chat(user, "There are [amount] [singular_name]\s in the stack.")

/obj/item/stack/attack_self(mob/user)
	..()
	if(length(radial_options) && HAS_RADIAL_PREF(user))
		open_radial_menu(user)
	else
		list_recipes(user)

/obj/item/stack/proc/open_radial_menu(var/mob/user)
	var/option = show_radial_menu(user, src, radial_options, custom_check = CALLBACK(src, .proc/in_hand_check))
	if(!option)
		return
	if(user.get_active_hand() != src)
		to_chat(user, SPAN_WARNING("\The [src] must remain in your active hand!"))
		return
	if(option == SHOW_FULL_LIST)
		list_recipes(user)
	else
		var/selected_recipe = radial_buildables[option]
		for(var/datum/stack_recipe/recipe as anything in recipes)
			if(recipe.result_type == selected_recipe)
				make_recipe(user, recipe, 1)
				if(!QDELETED(src))
					open_radial_menu(user)
				return
		to_chat(user, SPAN_DANGER("Something went wrong, we couldn't find that recipe! Contact a developer."))

/obj/item/stack/proc/in_hand_check()
	if(!ismob(loc))
		return FALSE
	return TRUE

/obj/item/stack/proc/list_recipes(mob/user, recipes_sublist)
	if(!recipes)
		return
	if(!src || amount <= 0)
		close_browser(user, "stack")
	user.set_interaction(src) //for correct work of onclose
	var/list/recipe_list = recipes
	if(recipes_sublist && recipe_list[recipes_sublist] && istype(recipe_list[recipes_sublist], /datum/stack_recipe_list))
		var/datum/stack_recipe_list/srl = recipe_list[recipes_sublist]
		recipe_list = srl.recipes
	var/t1 = text("<HTML><HEAD><title>Constructions from []</title></HEAD><body><TT>Amount Left: []<br>", src, src.amount)
	for(var/i = 1; i <= recipe_list.len, i++)
		var/E = recipe_list[i]
		if(isnull(E))
			t1 += "<hr>"
			continue

		if(i > 1 && !isnull(recipe_list[i-1]))
			t1+="<br>"

		if(istype(E, /datum/stack_recipe_list))
			var/datum/stack_recipe_list/srl = E
			if(src.amount >= srl.req_amount)
				t1 += "<a href='?src=\ref[src];sublist=[i]'>[srl.title] ([srl.req_amount] [src.singular_name]\s)</a>"
			else
				t1 += "[srl.title] ([srl.req_amount] [src.singular_name]\s)<br>"

		if(istype(E, /datum/stack_recipe))
			var/datum/stack_recipe/R = E
			var/max_multiplier = round(src.amount / R.req_amount)
			var/title
			var/can_build = 1
			can_build = can_build && (max_multiplier > 0)
			if(R.res_amount > 1)
				title += "[R.res_amount]x [R.title]\s"
			else
				title += "[R.title]"
			title+= " ([R.req_amount] [src.singular_name]\s)"
			if(can_build)
				t1 += text("<A href='?src=\ref[src];sublist=[recipes_sublist];make=[i];multiplier=1'>[title]</A>  ")
			else
				t1 += text("[]", title)
				continue
			if(R.max_res_amount>1 && max_multiplier > 1)
				max_multiplier = min(max_multiplier, round(R.max_res_amount/R.res_amount))
				t1 += " |"
				var/list/multipliers = list(5, 10, 25)
				for (var/n in multipliers)
					if (max_multiplier>=n)
						t1 += " <A href='?src=\ref[src];make=[i];multiplier=[n]'>[n*R.res_amount]x</A>"
				if(!(max_multiplier in multipliers))
					t1 += " <A href='?src=\ref[src];make=[i];multiplier=[max_multiplier]'>[max_multiplier*R.res_amount]x</A>"

	t1 += "</TT></body></HTML>"
	show_browser(user, t1, "Construction using [src]", "stack")
	return

/obj/item/stack/Topic(href, href_list)
	..()
	if((usr.is_mob_restrained() || usr.stat || usr.get_active_hand() != src))
		return

	if(href_list["sublist"] && !href_list["make"])
		list_recipes(usr, text2num(href_list["sublist"]))

	if(href_list["make"])
		if(amount < 1) qdel(src) //Never should happen

		var/list/recipes_list = recipes
		if(href_list["sublist"])
			var/datum/stack_recipe_list/srl = recipes_list[text2num(href_list["sublist"])]
			recipes_list = srl.recipes
		var/datum/stack_recipe/R = recipes_list[text2num(href_list["make"])]
		var/multiplier = text2num(href_list["multiplier"])
		if(!isnum(multiplier))
			return
		multiplier = round(multiplier)
		if(multiplier < 1)
			return  //href exploit protection
		make_recipe(usr, R, multiplier)

	if(src && usr.interactee == src) //do not reopen closed window
		INVOKE_ASYNC(src, .proc/interact, usr)

/obj/item/stack/proc/make_recipe(var/mob/user, var/datum/stack_recipe/recipe, var/multiplier = 1)
	if(recipe.skill_lvl)
		if(ishuman(user) && !skillcheck(user, recipe.skill_req, recipe.skill_lvl))
			to_chat(user, SPAN_WARNING("You are not trained to build this..."))
			return
	if(amount < recipe.req_amount * multiplier)
		if(recipe.req_amount * multiplier > 1)
			to_chat(user, SPAN_WARNING("You need more [name] to build \the [recipe.req_amount*multiplier] [recipe.title]\s!"))
		else
			to_chat(user, SPAN_WARNING("You need more [name] to build \the [recipe.title]!"))
		return

	if(check_one_per_turf(recipe, user))
		return

	if(recipe.on_floor && istype(user.loc, /turf/open))
		var/turf/open/OT = user.loc
		var/obj/structure/blocker/anti_cade/AC = locate(/obj/structure/blocker/anti_cade) in user.loc // for M2C HMG, look at smartgun_mount.dm
		if(!OT.allow_construction)
			to_chat(user, SPAN_WARNING("The [recipe.title] must be constructed on a proper surface!"))
			return

		if(AC)
			to_chat(user, SPAN_WARNING("The [recipe.title] cannot be built here!"))  //might cause some friendly fire regarding other items like barbed wire, shouldn't be a problem?
			return

	if((recipe.flags & RESULT_REQUIRES_SNOW) && !(istype(user.loc, /turf/open/snow) || istype(user.loc, /turf/open/auto_turf/snow)))
		to_chat(user, SPAN_WARNING("The [recipe.title] must be built on snow!"))
		return

	if(recipe.time)
		if(user.action_busy)
			return
		var/time_mult = skillcheck(user, SKILL_CONSTRUCTION, 2) ? 1 : 2
		user.visible_message(SPAN_NOTICE("[user] starts assembling \a [recipe.title]."), \
			SPAN_NOTICE("You start assembling \a [recipe.title]."))
		if(!do_after(user, max(recipe.time * time_mult, recipe.min_time), INTERRUPT_NO_NEEDHAND|BEHAVIOR_IMMOBILE, BUSY_ICON_BUILD))
			return

		//check again after some time has passed
		if(amount < recipe.req_amount * multiplier)
			return

		if(check_one_per_turf(recipe, user))
			return

	var/atom/O = new recipe.result_type(user.loc, user)
	user.visible_message(SPAN_NOTICE("[user] assembles \a [O]."),
	SPAN_NOTICE("You assemble \a [O]."))
	O.setDir(user.dir)
	if(recipe.max_res_amount > 1)
		var/obj/item/stack/new_item = O
		new_item.amount = recipe.res_amount * multiplier
	amount -= recipe.req_amount * multiplier
	update_icon()

	if(amount <= 0)
		var/oldsrc = src
		src = null //dont kill proc after qdel()
		user.drop_inv_item_on_ground(oldsrc)
		qdel(oldsrc)

	if(istype(O,/obj/item/stack))	//floor stacking convenience
		var/obj/item/stack/S = O
		for(var/obj/item/stack/F in user.loc)
			if(S.stack_id == F.stack_id && S != F)
				var/diff = F.max_amount - F.amount
				if (S.amount < diff)
					F.amount += S.amount
					qdel(S)
				else
					S.amount -= diff
					F.amount += diff
				break

	O?.add_fingerprint(user)

	//BubbleWrap - so newly formed boxes are empty
	if(isstorage(O))
		for (var/obj/item/I in O)
			qdel(I)
	//BubbleWrap END


/obj/item/stack/proc/check_one_per_turf(var/datum/stack_recipe/R, var/mob/user)
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
		return 0
	amount -= used
	update_icon()
	if(amount <= 0)
		if(usr && loc == usr)
			usr.temp_drop_inv_item(src)
		qdel(src)
	return 1

/obj/item/stack/proc/add(var/extra)
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

/obj/item/stack/attack_hand(mob/user as mob)
	if (user.get_inactive_hand() == src)
		var/obj/item/stack/F = new src.type(user, 1)
		transfer_fingerprints_to(F)
		user.put_in_hands(F)
		src.add_fingerprint(user)
		F.add_fingerprint(user)
		use(1)
		if (src && usr.interactee==src)
			INVOKE_ASYNC(src, /obj/item/stack/.proc/interact, usr)
	else
		..()
	return

/obj/item/stack/attackby(obj/item/W as obj, mob/user as mob)
	if (istype(W, /obj/item/stack))
		var/obj/item/stack/S = W
		if(S.stack_id == stack_id) //same stack type
			if(S.amount >= max_amount)
				to_chat(user, SPAN_NOTICE("The stack is full!"))
				return TRUE
			var/to_transfer
			if(user.get_inactive_hand() == src)
				var/desired = tgui_input_number(user, "How much would you like to transfer from this stack?", "How much?", 1, amount, 1)
				if(!desired)
					return
				to_transfer = Clamp(desired, 0, min(amount, S.max_amount-S.amount))
			else
				to_transfer = min(src.amount, S.max_amount-S.amount)
			if(to_transfer <= 0)
				return
			to_chat(user, SPAN_INFO("You transfer [to_transfer] between the stacks."))
			S.add(to_transfer)
			if (S && usr.interactee==S)
				INVOKE_ASYNC(S, /obj/item/stack/.proc/interact, usr)
			src.use(to_transfer)
			if (src && usr.interactee==src)
				INVOKE_ASYNC(src, /obj/item/stack/.proc/interact, usr)
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
	New(title, recipes, req_amount = 1)
		src.title = title
		src.recipes = recipes
		src.req_amount = req_amount

#undef SHOW_FULL_LIST
