//?Ought to be the parent class, generalize so it can specify if the clip object can detatch, how many mags can it hold etc.
//LMAO THE FUCKING LIST INDEX STARTS FROM 1?????
//TODO: Make it so the thing actually accepts mags, make it so the thing feeds into guns and reloads properly

/*
*Current Problems:
	- //TODO: Shit code
	- The mag clip doesn't goes into the gun, instead the magazine teleports into the gun and leaves the mag clip behind while the mag clip still points to the magazine
	- Lacks user feedback when the clip is switched
	- The fucking clip eats everything, make it so it only eats magazines
	- Tactical reload is un-accounted for, after tactical reload into a normal mag and when the mag is set to be unloaded the magazine is disapeared and the magazine clip is teleported over instead
	- //TODO: The fucking color band on ap ammo and such doesn't give a fuck when the thing is thrown: everything else spins while it just stands there
*/
/*
TODO:
	- Further refine the item examine message: include the magazine names as well
	- Clean up the comments
	- Check over all the procs, look into initiate() and destroy() [research qdelete]
	- Work on potential optimization problems
	- Work out an acceptable sprite
	- Actually add the item into vendor
	- Allow people to interact with the magazine clip using context menu when it's on the ground; no clue how to do this one
	- Add support for tactical reload; Actually erm probably gonna avoid it altogether, took a peak at the code and I don't see a easy non-intrusive way to include it as a feature. Besides people really shouldn't be doing tactical reload all that often, and even more unlikely to do it with mag clips
	- Make sure all cases inside reload() and unload() are accounted for
	- Generalize magazine_clip and make more specific objects
*/

/obj/item/magazine_clip
	name = "\improper magazine clip"
	desc = "A 3D printed magazine clip, can secure two magazines."

	icon = 'icons/obj/items/weapons/guns/magazine_clips/magazine_clip.dmi' //PLACEHOLDER FOR TESTING
	icon_state = null
	var/foreground_icon_state = null //Storing foreground sprite; TODO: clean it up and move to m41a mag clip after finish with testing
	var/magazine_icon_reference = list(FALSE, FALSE) //Stores x and y offsets for putting magazine onto the overlay

	item_state = "generic_mag"
	item_icons = list(
		WEAR_L_HAND = 'icons/mob/humans/onmob/inhands/weapons/ammo_lefthand.dmi',
		WEAR_R_HAND = 'icons/mob/humans/onmob/inhands/weapons/ammo_righthand.dmi'
		)

	var/compatible_magazines = list()
	var/contained_mags = list(0, 0)
	var/active_slot = FALSE //It's two slots, 0 and 1 works

//Custom Processes
/obj/item/magazine_clip/proc/switch_active_slot(mob/user)
	active_slot = !active_slot
	to_chat(user, SPAN_BLUE("You switched the magazine slot to slot [active_slot+1]"))

/obj/item/magazine_clip/proc/active_magazine()
	return contained_mags[active_slot+1]

/obj/item/magazine_clip/proc/insert_magazine(mob/user, obj/item/ammo_magazine/M)
	if (istype(M)) //Checks if incoming item is a magazine
		if (src.active_magazine() == 0)
			if (user)
				user.drop_inv_item_to_loc(M, src)
			else
				M.forceMove(get_turf(src))
			contained_mags[active_slot+1] = M
			update_icon()
			return TRUE
		else
			to_chat(user, SPAN_WARNING("The active slot already has a magazine in it!"))
			return FALSE
	else
		to_chat(user, SPAN_WARNING("[src] only accepts magazines!"))
		return FALSE

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
	update_icon()
	return TRUE


//Overwriting Parent Processes
/obj/item/magazine_clip/get_examine_text(mob/user)
	. += ..()

	. += "Use special action or alt-click to switch active slot, use in hand or click with an empty hand to remove magazine."

	for(var/i in 1 to length(contained_mags))
		if (contained_mags[i] == 0)
			. += "Slot [i] is empty."
		else
			var/obj/item/ammo_magazine/target_mag = contained_mags[i]
			. += "Slot [i] is occupied: [target_mag] has [target_mag.current_rounds] out of [target_mag.max_rounds]."

	. += "The active slot is slot [active_slot+1]."

/obj/item/magazine_clip/attack_hand(mob/user)
	if (src == user.get_inactive_hand())
		src.remove_magazine(user)
	else
		..()

/obj/item/magazine_clip/attackby(obj/item/I, mob/living/user, bypass_hold_check)
	src.insert_magazine(user, I)

/obj/item/magazine_clip/attack_self(mob/user) //?I am not sure how it works exactly, mimicing gun_helpers.dm
	..()

	src.remove_magazine(user)

/obj/item/magazine_clip/unique_action(mob/user)
	src.switch_active_slot(user)

/obj/item/magazine_clip/clicked(mob/user, list/mods) //? Absolutely clueless as to how this works, mimicing gun_helpers.dm
	if (mods[ALT_CLICK])
		src.switch_active_slot(user)
		return TRUE
	return (..())

/obj/item/magazine_clip/update_icon()
	if(overlays)
		overlays.Cut()
	else
		overlays = list()

	for(var/i in 1 to length(contained_mags))
		var/obj/item/ammo_magazine/target_magazine = contained_mags[i]
		if(target_magazine)
			var/image/target_magazine_icon = image(target_magazine.icon, src, target_magazine.icon_state)
			target_magazine_icon.overlays += target_magazine.overlays
			target_magazine_icon.layer = FLOAT_LAYER-i
			if(magazine_icon_reference[i])
				target_magazine_icon.pixel_w = magazine_icon_reference[i][1]
				target_magazine_icon.pixel_z = magazine_icon_reference[i][2]
			overlays += target_magazine_icon

	if(foreground_icon_state)
		overlays += image(icon, src, foreground_icon_state)
