/obj/item/reagent_container
	name = "Container"
	icon = 'icons/obj/items/chemistry.dmi'
	throwforce = 3
	w_class = SIZE_SMALL
	throw_range = 5
	attack_speed = 3
	ground_offset_x = 7
	ground_offset_y = 7
	/// How many units of reagent get transfered out of the container at a time
	var/amount_per_transfer_from_this = 5
	/// A list of possible amounts that can be transferred
	var/possible_transfer_amounts = list(5, 10, 15, 25, 30)
	/// The maximum volume the container can hold
	var/volume = 30
	/// Can we see what's in it?
	var/transparent = FALSE
	/// Does it have a special examining mechanic that should override the normal /reagent_containers examine proc?
	var/reagent_desc_override = FALSE
	/// Whether the container can have the set transfer amount action at all
	var/has_set_transfer_action = TRUE

/obj/item/reagent_container/Initialize()
	if(has_set_transfer_action && LAZYLEN(possible_transfer_amounts))
		LAZYADD(actions_types, /datum/action/item_action/reagent_container/set_transfer_amount)
	. = ..()
	create_reagents(volume)


/obj/item/reagent_container/get_examine_text(mob/user)
	. = ..()
	var/reagent_info = show_reagent_info(user)
	if(reagent_info)
		. += reagent_info

/// Whether the user can see the amount or reagents inside
/obj/item/reagent_container/proc/show_reagent_info(mob/user)
	if(reagent_desc_override)
		return
	if(!reagents)
		return
	if(isxeno(user))
		return
	var/reagent_desc = "[src] contains: "

	if(user.can_see_reagents())
		reagent_desc += get_reagent_list_text()
		return SPAN_INFO(reagent_desc)

	if(!transparent)
		return
	if(user != loc && !in_range(src, user))
		return SPAN_WARNING("[src] is too far away for you to see what's in it!")

	if(!LAZYLEN(reagents.reagent_list))
		reagent_desc += "Nothing"
		return SPAN_INFO(reagent_desc)

	reagent_desc += "[reagents.total_volume] units of liquid"
	return SPAN_INFO(reagent_desc)

// this proc is general-purpose and primarily for medical items that you shouldn't need scigoggles to scan
/// Shows the reagent amount if the examining user is sufficiently skilled
/obj/item/reagent_container/proc/display_contents(mob/user)
	if(isxeno(user))
		return

	if(!skillcheck(user, SKILL_MEDICAL, SKILL_MEDICAL_TRAINED))
		return "You don't know what's in it."

	return "[src] contains: [get_reagent_list_text()]."

/// Returns a string listing all reagents (and their volume) in the container
/obj/item/reagent_container/proc/get_reagent_list_text()
	if(!reagents || !LAZYLEN(reagents.reagent_list))
		return "No reagents"

	var/total_reagent_desc = ""
	for(var/datum/reagent/current_reagent as anything in reagents.reagent_list)
		if(total_reagent_desc != "")
			total_reagent_desc += ", "
		total_reagent_desc += "[current_reagent.name] ([current_reagent.volume]u)"

	return total_reagent_desc

/datum/action/item_action/reagent_container/set_transfer_amount
	name = "Set Transfer Amount"
	/// The container that transfer amount will be set on
	var/obj/item/reagent_container/container

/datum/action/item_action/reagent_container/set_transfer_amount/Destroy()
	container = null
	. = ..()

/datum/action/item_action/reagent_container/set_transfer_amount/New(mob/living/user, obj/item/holder)
	..()
	button.name = name
	button.overlays.Cut()
	var/image/button_overlay = image(holder_item.icon, button, holder_item.icon_state)
	button.overlays += button_overlay
	container = holder_item

/datum/action/item_action/reagent_container/set_transfer_amount/action_activate()
	. = ..()
	var/new_reagent_amount = tgui_input_list(owner, "Amount per transfer from this:","[container]", container.possible_transfer_amounts)
	if(!new_reagent_amount)
		return
	to_chat(owner, SPAN_NOTICE("You change [container]'s reagent transfer amount to [new_reagent_amount]."))
	container.amount_per_transfer_from_this = new_reagent_amount
