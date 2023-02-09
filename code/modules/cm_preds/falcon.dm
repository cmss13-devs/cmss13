/obj/item/falcon_drone
	name = "falcon drone"
	desc = "An agile drone used by Yautja to survey the hunting grounds."
	icon = 'icons/obj/items/hunter/pred_gear.dmi'
	icon_state = "falcon_drone"
	item_icons = list(
		WEAR_L_EAR = 'icons/mob/humans/onmob/hunter/pred_gear.dmi',
		WEAR_R_EAR = 'icons/mob/humans/onmob/hunter/pred_gear.dmi',
		WEAR_L_HAND = 'icons/mob/humans/onmob/hunter/items_lefthand.dmi',
		WEAR_R_HAND = 'icons/mob/humans/onmob/hunter/items_righthand.dmi'
	)
	flags_equip_slot = SLOT_EAR
	flags_item = ITEM_PREDATOR

/obj/item/falcon_drone/get_examine_location(mob/living/carbon/human/wearer, mob/examiner, slot, t_he = "They", t_his = "their", t_him = "them", t_has = "have", t_is = "are")
	switch(slot)
		if(WEAR_L_EAR)
			return "on [t_his] shoulder"
		if(WEAR_R_EAR)
			return "on [t_his] shoulder"
	return ..()

/obj/item/falcon_drone/attack_self(mob/user)
	..()
	control_falcon_drone()

/obj/item/falcon_drone/verb/control_falcon_drone()
	set name = "Control Falcon Drone"
	set desc = "Activates your falcon drone."
	set category = "Yautja.Misc"
	set src in usr

	if(usr.is_mob_incapacitated())
		return

	var/mob/living/carbon/human/H = usr
	if(!istype(H) || !HAS_TRAIT(usr, TRAIT_YAUTJA_TECH))
		to_chat(usr, SPAN_WARNING("You do not know how to use this."))
		return

	if(!istype(H.gloves, /obj/item/clothing/gloves/yautja))
		to_chat(usr, SPAN_WARNING("You need your bracers to control \the [src]!"))
		return

	var/mob/hologram/falcon/hologram = new /mob/hologram/falcon(usr.loc, usr, src, H.gloves)
	usr.drop_inv_item_to_loc(src, hologram)

/mob/hologram/falcon
	name = "falcon drone"
	hud_possible = list(HUNTER_HUD)
	var/obj/item/falcon_drone/parent_drone
	desc = "An agile drone used by Yautja to survey the hunting grounds."

/mob/hologram/falcon/Initialize(mapload, mob/M, obj/item/falcon_drone/drone, obj/item/clothing/gloves/yautja/bracers)
	. = ..()
	parent_drone = drone
	RegisterSignal(bracers, COMSIG_ITEM_DROPPED, PROC_REF(handle_bracer_drop))
	med_hud_set_status()
	add_to_all_mob_huds()

/mob/hologram/falcon/initialize_pass_flags(datum/pass_flags_container/PF)
	..()
	if(PF)
		PF.flags_pass = PASS_MOB_THRU|PASS_MOB_IS|PASS_BUILDING
		PF.flags_can_pass_all = PASS_ALL

/mob/hologram/falcon/add_to_all_mob_huds()
	var/datum/mob_hud/hud = huds[MOB_HUD_HUNTER]
	hud.add_to_hud(src)

/mob/hologram/falcon/remove_from_all_mob_huds()
	var/datum/mob_hud/hud = huds[MOB_HUD_HUNTER]
	hud.remove_from_hud(src)

/mob/hologram/falcon/med_hud_set_status()
	var/image/holder = hud_list[HUNTER_HUD]
	holder.icon_state = "falcon_drone_active"

/mob/hologram/falcon/Destroy()
	if(parent_drone)
		if(!linked_mob.equip_to_slot_if_possible(parent_drone, WEAR_L_EAR, TRUE, FALSE, TRUE, TRUE, FALSE))
			if(!linked_mob.equip_to_slot_if_possible(parent_drone, WEAR_R_EAR, TRUE, FALSE, TRUE, TRUE, FALSE))
				linked_mob.put_in_hands(parent_drone)
		parent_drone = null
	remove_from_all_mob_huds()
	return ..()

/mob/hologram/falcon/ex_act()
	new /obj/item/trash/falcon_drone(loc)
	QDEL_NULL(parent_drone)
	qdel(src)

/mob/hologram/falcon/emp_act()
	new /obj/item/trash/falcon_drone/emp(loc)
	QDEL_NULL(parent_drone)
	qdel(src)

/mob/hologram/falcon/proc/handle_bracer_drop()
	SIGNAL_HANDLER

	qdel(src)

/obj/item/trash/falcon_drone
	name = "destroyed falcon drone"
	desc = "The wreckage of a Yautja drone."
	icon = 'icons/obj/items/hunter/pred_gear.dmi'
	icon_state = "falcon_drone_destroyed"
	flags_item = ITEM_PREDATOR

/obj/item/trash/falcon_drone/emp
	name = "disabled falcon drone"
	desc = "An intact Yautja drone. The internal electronics are completely fried."
	icon_state = "falcon_drone_emped"
