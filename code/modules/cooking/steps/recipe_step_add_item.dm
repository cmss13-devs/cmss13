// TODO for v2: See if a "count" option can be added to reduce
// the need for both longer recipe step lists, and whatever
// fuckery I eventually come up with for combining equivalent
// steps for generating instructions for the wiki.
/datum/cooking/recipe_step/add_item
	var/obj/item_type
	var/exact_path
	var/skip_reagents = FALSE
	// The original cooking system removed nutriment from
	// the ingredients put into a recipe
	var/list/exclude_reagents = list("nutriment")

/datum/cooking/recipe_step/add_item/New(item_type_, options)
	item_type = item_type_

	if("exact" in options)
		exact_path = options["exact"]
	if("skip_reagents" in options)
		skip_reagents = options["skip_reagents"]
	if("exclude_reagents" in options)
		exclude_reagents |= options["exclude_reagents"]

	..(options)

/datum/cooking/recipe_step/add_item/Destroy()
	. = ..()
	QDEL_NULL(item_type)

/datum/cooking/recipe_step/add_item/check_conditions_met(obj/added_item, datum/cooking/recipe_tracker/tracker)
	#ifdef PCWJ_DEBUG
	log_debug("Called add_item/check_conditions_met for [added_item], checking against item type [item_type]. Exact_path = [exact_path]")
	#endif
	if(!istype(added_item, /obj/item))
		return PCWJ_CHECK_INVALID
	if(exact_path)
		if(added_item.type == item_type)
			return PCWJ_CHECK_VALID
	else
		if(istype(added_item, item_type))
			return PCWJ_CHECK_VALID
	return PCWJ_CHECK_INVALID

/datum/cooking/recipe_step/add_item/is_complete(obj/added_item, datum/cooking/recipe_tracker/tracker, list/step_data)
	var/obj/item/container = tracker.container_parent
	if(!istype(container))
		return FALSE

	if(exact_path)
		if(step_data["stack_added"] == item_type)
			return TRUE
	else
		if(ispath(step_data["stack_added"], item_type))
			return TRUE

	return (added_item in container.contents)

/datum/cooking/recipe_step/add_item/follow_step(obj/used_item, datum/cooking/recipe_tracker/tracker, mob/user)
	#ifdef PCWJ_DEBUG
	log_debug("Called: /datum/cooking/recipe_step/add_item/follow_step")
	#endif
	var/obj/item/container = tracker.container_parent
	if(!user && ismob(used_item.loc))
		user = used_item.loc
	if(container)
		if(istype(user) && user.Adjacent(container))
			var/obj/item/stack/stack = used_item
			if(istype(stack))
				if(stack.use(1))
					var/stack_type = stack.type
					new stack_type(container, 1)
					return list(message = "You add one of \the [stack.name] to \the [container].", stack_added = stack_type)
				else
					to_chat(user, SPAN_NOTICE("You can't remove one of \the [stack.name] from the stack!"))
					return list()
			if(user.drop_held_item(used_item))
				used_item.forceMove(container)
			else
				to_chat(user, SPAN_NOTICE("You can't remove [used_item] from your hands!"))
				return list()
		else
			used_item.forceMove(container)

		return list(message = "You add \the [used_item] to \the [container].", target = used_item)

	return list(message = "Something went real fucking wrong here!")
