//?Ought to be the parent class, generalize so it can specify if the clip object can detatch, how many mags can it hold etc.
//LMAO THE FUCKING LIST INDEX STARTS FROM 1?????
//TODO: Make it so the thing actually accepts mags, make it so the thing feeds into guns and reloads properly

/*
*Current Problems:
	- //TODO: Shit code
	- The mag clip doesn't goes into the gun, instead the magazine teleports into the gun and leaves the mag clip behind while the mag clip still points to the magazine
	- Lacks user feedback when the clip is switched
*/

/obj/item/magazine_clip
	name = "magazine_clip"
	desc = "A 3D printed magazine clip, can secure two magazines."
	icon = 'icons/obj/items/tools.dmi' //PLACEHOLDER FOR TESTING
	icon_state = "c_tube"
	var/accepted_magazines = list()

	var/contained_mags = list(0, 0) //-!This doesn't work; make it use a placeholder magazine object instead? Relate this to gun.dm
	var/active_slot = FALSE //?Maybe make it into bitflag at some point?

//Custom Processes
/obj/item/magazine_clip/proc/switch_active_slot(mob/user)
	active_slot = !active_slot
	to_chat(user, SPAN_BLUE("You switched the magazine slot to slot [active_slot]"))

/obj/item/magazine_clip/proc/active_magazine()
	return contained_mags[active_slot+1] //!This part is broken

/obj/item/magazine_clip/proc/insert_magazine(mob/user, obj/item/magazine_clip/M)
	// if (ispath(I, /obj/item/magazine_clip))
	// 	var/obj/item/ammo_magazine/target_magazine = I
	if (src.active_magazine() == 0)
		if (user)
			user.drop_inv_item_to_loc(M, src)
		else
			M.forceMove(get_turf(src))
		// else
		// 	to_chat(user, SPAN_WARNING("[src] only accepts magazines!"))
		// 	return FALSE
		contained_mags[active_slot+1] = M //!This part is broken
		return TRUE
	else
		to_chat(user, SPAN_WARNING("The active slot already has a magazine in it!"))
		return FALSE
	//TODO: include other stuffs that would be taken into account when a magazine is inserted

/obj/item/magazine_clip/proc/remove_magazine(mob/user)
	var/obj/item/ammo_magazine/target_magazine = active_magazine()
	if (!target_magazine)
		to_chat(user, SPAN_WARNING("The active slot doesn't have any magazines in it!"))
		return FALSE
	if (user)
		user.put_in_hands(target_magazine)
	else
		target_magazine.forceMove(get_turf(src))
	contained_mags[active_slot+1] = 0
	return TRUE
	//TODO: include other stuffs that would be taken into account when a magazine is removed


//Overwriting Parent Processes
/obj/item/magazine_clip/get_examine_text(mob/user)
	. += ..()

	if (contained_mags[0+1] == 0)
		. += "Slot 0 is empty."
	else
		var/obj/item/ammo_magazine/mag0 = contained_mags[0+1]
		. += "Slot 0 has [mag0.current_rounds] out of [mag0.max_rounds]."

	if (contained_mags[1+1] == 0)
		. += "Slot 1 is empty."
	else
		var/obj/item/ammo_magazine/mag1 = contained_mags[1+1]
		. += "Slot 1 has [mag1.current_rounds] out of [mag1.max_rounds]."

	. += "The active slot is slot [active_slot]."

/obj/item/magazine_clip/attack_hand(mob/user)
	if (src == user.get_inactive_hand())
		src.remove_magazine(user)
	else
		..()

/obj/item/magazine_clip/attackby(obj/item/I, mob/living/user, bypass_hold_check)
	src.insert_magazine(user, I)

/obj/item/magazine_clip/unique_action(mob/user)
	src.switch_active_slot(user)
