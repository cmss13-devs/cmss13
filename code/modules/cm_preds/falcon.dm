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
	flags_atom = FPRINT|USES_HEARING


/obj/item/falcon_drone/hear_talk(mob/living/sourcemob, message, verb, datum/language/language, italics)
	var/mob/hologram/falcon/hologram = loc
	if(!istype(hologram))
		return FALSE
	var/mob/living/carbon/human/user = hologram.owned_bracers.loc
	if(!ishuman(user) || user == sourcemob)
		return FALSE

	to_chat(user, SPAN_YAUTJABOLD("Falcon Relay: [sourcemob.name] [verb], <span class='[language.color]'>\"[message]\"</span>"))
	if(user && user.client && user.client.prefs && !user.client.prefs.lang_chat_disabled \
	   && !user.ear_deaf && user.say_understands(sourcemob, language))
		sourcemob.langchat_display_image(user)

	return TRUE

/obj/item/falcon_drone/get_examine_location(mob/living/carbon/human/wearer, mob/examiner, slot, t_he = "They", t_his = "their", t_him = "them", t_has = "have", t_is = "are")
	switch(slot)
		if(WEAR_L_EAR, WEAR_R_EAR)
			return "on [t_his] shoulder"
	return ..()

/obj/item/falcon_drone/equipped(mob/user, slot, silent)
	. = ..()
	if(!(slot == WEAR_L_EAR || slot == WEAR_R_EAR))
		return
	add_verb(user, /obj/item/falcon_drone/proc/can_control_falcon_drone)
	var/datum/action/predator_action/mask/control_falcon_drone/falcon_action = give_action(user, /datum/action/predator_action/mask/control_falcon_drone)
	falcon_action.linked_falcon_drone = src

/obj/item/falcon_drone/dropped(mob/user)
	. = ..()
	remove_verb(user, /obj/item/falcon_drone/proc/can_control_falcon_drone)
	remove_action(user, /datum/action/predator_action/mask/control_falcon_drone)

/obj/item/falcon_drone/attack_self(mob/user)
	..()
	can_control_falcon_drone()

/obj/item/falcon_drone/proc/can_control_falcon_drone()
	set name = "Control Falcon Drone"
	set desc = "Activates your falcon drone."
	set category = "Yautja.Misc"

	if(usr.is_mob_incapacitated())
		return

	var/mob/living/carbon/human/human = usr
	if(!istype(human) || !HAS_TRAIT(usr, TRAIT_YAUTJA_TECH))
		to_chat(usr, SPAN_WARNING("You do not know how to use this."))
		return

	if(!istype(human.gloves, /obj/item/clothing/gloves/yautja))
		to_chat(usr, SPAN_WARNING("You need your bracers to control \the [src]!"))
		return
	control_falcon_drone(human, human.gloves)

/obj/item/falcon_drone/proc/control_falcon_drone(mob/living/user, obj/item/clothing/gloves/yautja/bracers)
	var/mob/hologram/falcon/hologram = new /mob/hologram/falcon(get_turf(user), user, src, bracers)
	user.drop_inv_item_to_loc(src, hologram)

/mob/hologram/falcon
	name = "falcon drone"
	desc = "An agile drone used by Yautja to survey the hunting grounds."
	icon = 'icons/obj/items/hunter/pred_gear.dmi'
	action_icon_state = "falcon_drone"
	icon_state = "falcon_drone_active"
	hud_possible = list(HUNTER_HUD)
	motion_sensed = TRUE
	initial_leave_button = /datum/action/leave_hologram/falcon

	var/obj/item/falcon_drone/parent_drone
	var/obj/item/clothing/gloves/yautja/owned_bracers

/mob/hologram/falcon/Initialize(mapload, mob/M, obj/item/falcon_drone/drone, obj/item/clothing/gloves/yautja/bracers)
	. = ..()
	parent_drone = drone
	owned_bracers = bracers
	RegisterSignal(owned_bracers, COMSIG_ITEM_DROPPED, PROC_REF(handle_bracer_drop))
	med_hud_set_status()
	add_to_all_mob_huds()

/mob/hologram/falcon/initialize_pass_flags(datum/pass_flags_container/PF)
	..()
	if(PF)
		PF.flags_pass = PASS_MOB_THRU|PASS_MOB_IS|PASS_BUILDING
		PF.flags_can_pass_all = PASS_ALL

/mob/hologram/falcon/add_to_all_mob_huds()
	var/datum/mob_hud/hud = GLOB.huds[MOB_HUD_HUNTER]
	hud.add_to_hud(src)

/mob/hologram/falcon/remove_from_all_mob_huds()
	var/datum/mob_hud/hud = GLOB.huds[MOB_HUD_HUNTER]
	hud.remove_from_hud(src)

/mob/hologram/falcon/med_hud_set_status()
	if(!hud_list)
		return

	var/image/holder = hud_list[HUNTER_HUD]
	holder?.icon_state = "falcon_drone_active"

/mob/hologram/falcon/Destroy()
	if(parent_drone)
		if(!linked_mob.equip_to_slot_if_possible(parent_drone, WEAR_L_EAR, TRUE, FALSE, TRUE, TRUE, FALSE))
			if(!linked_mob.equip_to_slot_if_possible(parent_drone, WEAR_R_EAR, TRUE, FALSE, TRUE, TRUE, FALSE))
				linked_mob.put_in_hands(parent_drone)
		parent_drone = null
	if(owned_bracers)
		UnregisterSignal(owned_bracers, COMSIG_ITEM_DROPPED)
		owned_bracers = null

	remove_from_all_mob_huds()

	return ..()

/mob/hologram/falcon/ex_act()
	new /obj/item/trash/falcon_drone(loc)
	QDEL_NULL(parent_drone)
	qdel(src)

/mob/hologram/falcon/emp_act()
	. = ..()
	new /obj/item/trash/falcon_drone/emp(loc)
	QDEL_NULL(parent_drone)
	qdel(src)

/mob/hologram/falcon/proc/handle_bracer_drop()
	SIGNAL_HANDLER

	qdel(src)

/datum/action/leave_hologram/falcon
	icon_file = 'icons/mob/hud/actions_yautja.dmi'
	button_icon_state = "pred_template"
	action_icon_state = "falcon_drone"

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
