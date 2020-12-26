/obj/item/reagent_container
	name = "Container"
	desc = ""
	icon = 'icons/obj/items/chemistry.dmi'
	icon_state = null
	throwforce = 3
	w_class = SIZE_SMALL
	throw_speed = SPEED_FAST
	throw_range = 5
	var/amount_per_transfer_from_this = 5
	var/possible_transfer_amounts = list(5,10,15,25,30)
	var/volume = 30

/obj/item/reagent_container/verb/set_APTFT() //set amount_per_transfer_from_this
	set name = "Set transfer amount"
	set category = "Object"

	if(!ishuman(usr))
		return
	var/mob/living/carbon/human/user = usr
	var/obj/item/reagent_container/R = user.get_active_hand()
	if(!istype(R))
		return
	var/N = input("Amount per transfer from this:","[R]") as null|anything in possible_transfer_amounts
	if (N)
		R.amount_per_transfer_from_this = N

/obj/item/reagent_container/Initialize()
	. = ..()
	if (!possible_transfer_amounts)
		remove_verb(src, /obj/item/reagent_container/verb/set_APTFT) //which objects actually uses it?
	create_reagents(volume)

/obj/item/reagent_container/proc/display_contents(mob/user) // Used on examine for properly skilled people to see contents.
	if(isXeno(user))
		return
	if(skillcheck(user, SKILL_MEDICAL, SKILL_MEDICAL_TRAINED))
		to_chat(user, "[src] contains: [get_reagent_list_text()].")//this the pill
	else
		to_chat(user, "You don't know what's in it.")

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
