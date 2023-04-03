/obj/item/reagent_container
	name = "Container"
	desc = ""
	icon = 'icons/obj/items/chemistry.dmi'
	icon_state = null
	throwforce = 3
	w_class = SIZE_SMALL
	throw_speed = SPEED_FAST
	throw_range = 5
	attack_speed = 3
	var/amount_per_transfer_from_this = 5
	var/possible_transfer_amounts = list(5,10,15,25,30)
	var/volume = 30
	var/transparent = FALSE //can we see what's in it?
	var/reagent_desc_override = FALSE //does it have a special examining mechanic that should override the normal /reagent_containers examine proc?
	actions_types = list(/datum/action/item_action/reagent_container/set_transfer_amount)

/obj/item/reagent_container/Initialize()
	if(!possible_transfer_amounts)
		actions_types -= /datum/action/item_action/reagent_container/set_transfer_amount
	. = ..()
	if(!possible_transfer_amounts)
		verbs -= /obj/item/reagent_container/verb/set_APTFT //which objects actually uses it?
	create_reagents(volume)

/obj/item/reagent_container/get_examine_text(mob/user)
	. = ..()
	var/reagent_info = show_reagent_info(user)
	if(reagent_info)
		. += reagent_info

/obj/item/reagent_container/proc/show_reagent_info(mob/user)
	if(isxeno(user) || reagent_desc_override)
		return
	var/list/reagent_desc
	if(reagents && (transparent || user.can_see_reagents()))
		reagent_desc += "It contains : "
		if(!user.can_see_reagents())
			if(get_dist(user, src) > 2 && user != loc) //we have a distance check with this
				return SPAN_WARNING("It's too far away for you to see what's in it!")
			if(!length(reagents.reagent_list))
				reagent_desc += "nothing."
			else
				reagent_desc += "[reagents.total_volume] units of liquid."
			return SPAN_INFO("[reagent_desc]")
		else //when wearing science goggles, you can see what's in something from any range
			if(!length(reagents.reagent_list))
				reagent_desc += "nothing."
			else
				for(var/datum/reagent/current_reagent as anything in reagents.reagent_list)
					reagent_desc += "[round(current_reagent.volume, 0.01)] units of [current_reagent.name].<br>"
			return SPAN_INFO("[reagent_desc]")

/obj/item/reagent_container/verb/set_APTFT() //set amount_per_transfer_from_this
	set name = "Set transfer amount"
	set category = "Object"
	set src in usr
	if(!ishuman(usr))
		return
	var/mob/living/carbon/human/user = usr
	var/obj/item/reagent_container/R = user.get_active_hand()
	if(!istype(R))
		return
	var/N = tgui_input_list(usr, "Amount per transfer from this:","[R]", possible_transfer_amounts)
	if (N)
		R.amount_per_transfer_from_this = N

/obj/item/reagent_container/Initialize()
	. = ..()
	if (!possible_transfer_amounts)
		verbs -= /obj/item/reagent_container/verb/set_APTFT //which objects actually uses it?
	create_reagents(volume)

/obj/item/reagent_container/Destroy()
	possible_transfer_amounts = null
	return ..()

/*
// Used on examine for properly skilled people to see contents.
// this is separate from show_reagent_info, as that proc is intended for use with science goggles
// this proc is general-purpose and primarily for medical items that you shouldn't need scigoggles to scan - ie pills, syringes, etc.
*/
/obj/item/reagent_container/proc/display_contents(mob/user)
	if(isxeno(user))
		return
	if(skillcheck(user, SKILL_MEDICAL, SKILL_MEDICAL_TRAINED))
		return "[src] contains: [get_reagent_list_text()]."//this the pill
	else
		return "You don't know what's in it."

//returns a text listing the reagents (and their volume) in the atom. Used by Attack logs for reagents in pills
/obj/item/reagent_container/proc/get_reagent_list_text()
	if(reagents && reagents.reagent_list && reagents.reagent_list.len)
		var/datum/reagent/R = reagents.reagent_list[1]
		. = "[R.name]([R.volume]u)"
		if(reagents.reagent_list.len < 2) return
		for (var/i in 2 to reagents.reagent_list.len)
			R = reagents.reagent_list[i]
			if(!R) continue
			. += "; [R.name]([R.volume]u)"
	else
		. = "No reagents"


/datum/action/item_action/reagent_container/set_transfer_amount

/datum/action/item_action/reagent_container/set_transfer_amount/New(mob/living/user, obj/item/holder)
	..()
	name = "Set Transfer Amount"
	button.name = name
	button.overlays.Cut()
	var/image/IMG = image(holder_item.icon, button, holder_item.icon_state)
	button.overlays += IMG

/datum/action/item_action/reagent_container/set_transfer_amount/action_activate()
	var/obj/item/reagent_container/cont = holder_item
	cont.set_APTFT()
