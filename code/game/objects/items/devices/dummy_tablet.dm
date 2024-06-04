/obj/item/device/professor_dummy_tablet
	icon = 'icons/obj/items/devices.dmi'
	name = "\improper Professor DUMMY tablet"
	desc = "A Professor DUMMY Control Tablet."
	suffix = "\[3\]"
	icon_state = "Cotablet"
	item_state = "Cotablet"

	var/mob/living/carbon/human/linked_dummy
	///Should the dummy be destroyed on hijack?
	var/dust_on_hijack = FALSE

/obj/item/device/professor_dummy_tablet/Initialize()
	. = ..()
	var/turf/actual_location = get_turf(src)
	if(is_mainship_level(actual_location.z))
		dust_on_hijack = TRUE
	RegisterSignal(SSdcs, COMSIG_GLOB_HIJACK_LANDED, PROC_REF(destroy_dummy_upon_hijack))

/obj/item/device/professor_dummy_tablet/proc/destroy_dummy_upon_hijack()
	SIGNAL_HANDLER

	if(!dust_on_hijack)
		return
	if(!linked_dummy)
		return
	linked_dummy.visible_message(SPAN_WARNING("The [linked_dummy] suddenly disintegrates!"))
	linked_dummy.dust(create_cause_data("hijack autodelete"))

/obj/item/device/professor_dummy_tablet/Destroy()
	UnregisterSignal(src, COMSIG_GLOB_HIJACK_LANDED)
	linked_dummy = null
	. = ..()

/**
 * Checks if the user is adjacent to the dummy
 *
 * Returns TRUE if the user is adjacent to the dummy, FALSE otherwise
 *
 * * arg-1: The user
 */
/obj/item/device/professor_dummy_tablet/proc/is_adjacent_to_dummy(mob/user)
	if (get_dist(linked_dummy, user) > 1)
		to_chat(user, SPAN_WARNING("You are too far away from the dummy to use its tablet."))
		return FALSE
	return TRUE

/obj/item/device/professor_dummy_tablet/proc/link_dummy(mob/living/carbon/human/dummy_to_link)
	if(dummy_to_link)
		linked_dummy = dummy_to_link
		RegisterSignal(linked_dummy, COMSIG_PARENT_QDELETING, PROC_REF(self_delete))
		return

/obj/item/device/professor_dummy_tablet/proc/self_delete()
	SIGNAL_HANDLER

	UnregisterSignal(linked_dummy, COMSIG_PARENT_QDELETING)
	linked_dummy = null
	if(isstorage(loc))
		var/obj/item/storage/storage = loc
		storage.remove_from_storage(src, get_turf(src))
	qdel(src)

/obj/item/device/professor_dummy_tablet/attack_self(mob/user as mob)
	..()
	interact(user)

/obj/item/device/professor_dummy_tablet/interact(mob/user as mob)
	if(isnull(linked_dummy))
		return

	if(!is_adjacent_to_dummy(user))
		return

	user.set_interaction(src)
	var/dat = "<head><title>Professor DUMMY Control Tablet</title></head><body>"

	dat += "<BR>\[ <A HREF='?src=\ref[src];operation=brute_damage_limb'>Brute Damage (Limb)</A> \]"
	dat += "<BR>\[ <A HREF='?src=\ref[src];operation=brute_damage_organ'>Brute Damage (Organ)</A> \]"
	dat += "<BR>\[ <A HREF='?src=\ref[src];operation=burn_damage'>Burn Damage</A> \]"
	dat += "<BR>\[ <A HREF='?src=\ref[src];operation=toxin'>Inject Toxins</A> \]"
	dat += "<BR>\[ <A HREF='?src=\ref[src];operation=bones'>Break Bones</A> \]"
	dat += "<BR>\[ <A HREF='?src=\ref[src];operation=blood_loss'>Blood Loss</A> \]"
	dat += "<BR>\[ <A HREF='?src=\ref[src];operation=bleeding'>Internal Bleeding</A> \]"
	dat += "<BR>\[ <A HREF='?src=\ref[src];operation=shrapnel'>Shrapnel</A> \]"
	dat += "<BR>\[ <A HREF='?src=\ref[src];operation=delimb'>Delimb</A> \]"
	dat += "<BR>\[ <A HREF='?src=\ref[src];operation=reset'>Reset</A> \]"
	dat += "<BR><hr>"

	show_browser(user, dat, "Professor DUMMY Control Tablet", "dummytablet", window_options="size=400x500")
	onclose(user, "dummytablet")
	updateDialog()
	return

/obj/item/device/professor_dummy_tablet/proc/select_delimb_target()
	var/list/procedureChoices = list(
		"Right Hand" = "r_hand",
		"Left Hand" = "l_hand",
		"Right Arm" = "r_arm",
		"Left Arm" = "l_arm",
		"Right Foot" = "r_foot",
		"Left Foot" = "l_foot",
		"Right Leg" = "r_leg",
		"Left Leg" = "l_leg",
	)
	var/selection = ""
	selection = tgui_input_list(usr, "Select Organ", "Organ selection", procedureChoices)
	return LAZYACCESS(procedureChoices, selection)


/obj/item/device/professor_dummy_tablet/proc/select_internal_organ()
	var/list/procedureChoices = list(
		"Heart" = "heart",
		"Lungs" = "lungs",
		"Liver" = "liver",
		"Kidneys" = "kidneys",
		"Brain" = "brain",
		"Eyes" = "eyes",
	)
	var/selection = ""
	selection = tgui_input_list(usr, "Select Organ", "Organ selection", procedureChoices)
	return LAZYACCESS(procedureChoices, selection)

/obj/item/device/professor_dummy_tablet/proc/select_body_part()
	var/list/procedureChoices = list(
		"Head" = "head",
		"Chest" = "chest",
		"Groin" = "groin",
		"Right Hand" = "r_hand",
		"Left Hand" = "l_hand",
		"Right Arm" = "r_arm",
		"Left Arm" = "l_arm",
		"Right Foot" = "r_foot",
		"Left Foot" = "l_foot",
		"Right Leg" = "r_leg",
		"Left Leg" = "l_leg",
	)
	var/selection = ""
	selection = tgui_input_list(usr, "Select Organ", "Organ selection", procedureChoices)
	return LAZYACCESS(procedureChoices, selection)


/obj/item/device/professor_dummy_tablet/Topic(href, href_list)
	if(..()) return FALSE

	if (!is_adjacent_to_dummy(usr))
		return FALSE

	usr.set_interaction(src)

	switch(href_list["operation"])
		if ("brute_damage_organ")
			var/selection = select_internal_organ()
			if (!selection)
				return
			var/datum/internal_organ/organ = LAZYACCESS(linked_dummy.internal_organs_by_name, selection)
			if (!istype(organ))
				return
			var/amount = 0
			amount = tgui_input_real_number(usr, "Amount?")
			if (amount==0)
				return
			organ.take_damage(amount)
		if ("brute_damage_limb")
			var/selection = select_body_part()
			if (!selection)
				return
			var/obj/limb/limb = linked_dummy.get_limb(selection)
			if (!istype(limb))
				return
			if(limb.status & LIMB_DESTROYED)
				return
			var/amount = 0
			amount = tgui_input_real_number(usr, "Amount?")
			if (amount==0)
				return
			limb.take_damage(amount, 0)
		if ("burn_damage")
			var/selection = select_body_part()
			if (!selection)
				return
			var/obj/limb/limb = linked_dummy.get_limb(selection)
			if (!istype(limb))
				return
			if(limb.status & LIMB_DESTROYED)
				return
			var/amount = 0
			amount = tgui_input_real_number(usr, "Amount?")
			if (amount==0)
				return
			limb.take_damage(0, amount)
		if ("toxin")
			var/amount = 0
			amount = tgui_input_real_number(usr, "Amount?")
			if (amount==0)
				return
			linked_dummy.reagents.add_reagent("toxin", amount)
		if ("bones")
			var/selection = select_body_part()
			if (!selection)
				return
			var/obj/limb/limb = linked_dummy.get_limb(selection)
			if (!istype(limb))
				return
			if(limb.status & LIMB_DESTROYED)
				return
			limb.fracture(100)
		if ("blood_loss")
			var/amount = 0
			amount = tgui_input_real_number(usr, "Amount?")
			if (amount==0)
				return
			linked_dummy.drip(amount)
		if ("bleeding")
			var/selection = select_body_part()
			if (!selection)
				return
			var/obj/limb/limb = linked_dummy.get_limb(selection)
			if (!istype(limb))
				return
			if(limb.status & LIMB_DESTROYED)
				return
			if(linked_dummy.get_limb(selection).status & LIMB_DESTROYED)
				return
			var/datum/wound/internal_bleeding/I = new (0)//<- copied from limbs.dm, doesn't have any issues with cybernetics
			limb.add_bleeding(I, TRUE)
			limb.wounds += I
		if ("shrapnel")
			var/selection = select_body_part()
			if (!selection)
				return
			var/obj/limb/limb = linked_dummy.get_limb(selection)
			if (!istype(limb))
				return
			if(limb.status & LIMB_DESTROYED)
				return
			var/obj/item/shard/shrapnel/s = new /obj/item/shard/shrapnel()
			limb.embed(s)
		if ("delimb")
			var/selection = select_body_part()
			if (!selection)
				return
			var/obj/limb/limb = linked_dummy.get_limb(selection)
			if (!istype(limb))
				return
			if(limb.status & LIMB_DESTROYED)
				return
			limb.droplimb(TRUE, TRUE, "tablet")
			playsound(loc, 'sound/weapons/slice.ogg', 25)
		if("reset")
			linked_dummy.revive()
		else
			updateUsrDialog()
			return FALSE
	linked_dummy.regenerate_all_icons()
	linked_dummy.emote("scream")
	updateUsrDialog()
	return TRUE
