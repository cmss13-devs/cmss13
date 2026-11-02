/obj/item/device/vulture_spotter_scope
	name = "\improper M707 spotter scope"
	desc = "A scope that, when mounted on a tripod, allows a user to assist the M707's firer in target acquisition."
	icon_state = "vulture_scope"
	item_state = "electronic"
	icon = 'icons/obj/items/binoculars.dmi'
	item_icons = list(
		WEAR_L_HAND = 'icons/mob/humans/onmob/inhands/equipment/devices_lefthand.dmi',
		WEAR_R_HAND = 'icons/mob/humans/onmob/inhands/equipment/devices_righthand.dmi',
	)
	flags_atom = FPRINT|CONDUCT
	unacidable = TRUE
	explo_proof = TRUE
	/// A weakref to the corresponding rifle
	var/datum/weakref/bound_rifle

/obj/item/device/vulture_spotter_scope/Initialize(mapload, datum/weakref/rifle)
	. = ..()
	if(rifle)
		bound_rifle = rifle

/obj/item/device/vulture_spotter_scope/attack_self(mob/user)
	. = ..()
	to_chat(user, SPAN_WARNING("[src] needs to be mounted on a tripod to use!"))

/obj/item/device/vulture_spotter_scope/skillless

/obj/item/device/vulture_spotter_scope/designator
	name = "\improper M708 laser designator"
	desc = "A laser designator camera that mounts on an M707 spotting tripod to provide accurate target aquisition to laser guided munitions."
	icon_state = "rangefinder_scope"
	item_state = "rangefinder"
	w_class = SIZE_SMALL
	flags_atom = FPRINT|CONDUCT|MAP_COLOR_INDEX

/obj/item/device/vulture_spotter_scope/designator/Initialize(mapload, datum/weakref/rifle)
	. = ..()
	select_gamemode_skin(type)

/obj/item/device/vulture_spotter_tripod
	name = "\improper M707 spotter tripod"
	desc = "A tripod, meant for stabilizing a spotting scope for the M707 anti-materiel rifle."
	icon_state = "vulture_tripod"
	item_state = "electronic"
	w_class = SIZE_SMALL
	icon = 'icons/obj/items/binoculars.dmi'
	flags_atom = FPRINT|CONDUCT
	unacidable = TRUE
	explo_proof = TRUE

/obj/item/device/vulture_spotter_tripod/get_examine_text(mob/user)
	. = ..()
	. += SPAN_NOTICE("[src] can be set down by <b>using in-hand</b>.")

/obj/item/device/vulture_spotter_tripod/attack_self(mob/user)
	. = ..()
	deploy_tripod(user)

/obj/item/device/vulture_spotter_tripod/proc/deploy_tripod(mob/user)
	user.balloon_alert(user, "setting up tripod")
	if(!do_after(user, 1.5 SECONDS, target = user))
		return

	new /obj/structure/vulture_spotter_tripod(get_turf(user))
	qdel(src)
