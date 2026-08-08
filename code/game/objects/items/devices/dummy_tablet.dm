/obj/item/device/professor_dummy_tablet
	icon = 'icons/obj/items/devices.dmi'
	name = "\improper Professor DUMMY tablet"
	desc = "A Professor DUMMY Control Tablet."
	icon_state = "dummytablet"
	item_state = "dummytablet"
	item_icons = list(WEAR_R_HAND = null, WEAR_L_HAND = null) // No mob state currently

	var/mob/living/carbon/human/linked_dummy
	///Should the dummy be destroyed on hijack?
	var/dust_on_hijack = FALSE

	/// List of items to be used as 'training embryo'
	var/static/list/parasite_types = list(
		/obj/item/toy/plush/farwa,
		/obj/item/toy/plush/bee,
		/obj/item/toy/plush/shark,
		/obj/item/toy/plush/gnarp
	)

	COOLDOWN_DECLARE(randomize_condition_cooldown)

/obj/item/device/professor_dummy_tablet/Initialize()
	. = ..()
	var/turf/actual_location = get_turf(src)
	if(is_mainship_level(actual_location.z))
		dust_on_hijack = TRUE
	COOLDOWN_START(src, randomize_condition_cooldown, 5 SECONDS)
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

/obj/item/device/professor_dummy_tablet/proc/is_adjacent_to_dummy(mob/user)
	if(get_dist(linked_dummy, user) > 1)
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
	tgui_interact(user)

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

/obj/item/device/professor_dummy_tablet/proc/randomize_dummy_condition(mob/user)
	if(!COOLDOWN_FINISHED(src, randomize_condition_cooldown))
		to_chat(user, SPAN_WARNING("Tablet processors recharging!"))
		return FALSE

	COOLDOWN_START(src, randomize_condition_cooldown, 5 SECONDS)

	var/damage_amount_split = ((rand(1, 100)) / 100)
	var/list/limbs = linked_dummy.limbs
	var/amount_of_parts = rand(1, 10)	// Amount of times to roll for a limb fracture
	var/damage_amount = rand(50, 400)

	for(var/i in 1 to amount_of_parts)
		var/obj/limb/selected_limb = pick(limbs)
		selected_limb.take_damage(round((damage_amount * damage_amount_split) / amount_of_parts), round((damage_amount * (1 - damage_amount_split)) / amount_of_parts))
		if((damage_amount > selected_limb.min_broken_damage) && prob(40))
			selected_limb.fracture()

	if(prob(40))
		linked_dummy.setToxLoss(rand(1, 100))

	linked_dummy.updatehealth()
	linked_dummy.UpdateDamageIcon()

/obj/item/device/professor_dummy_tablet/ui_static_data(mob/user)
	var/list/data = list()

	data["patient"] = linked_dummy.name

	return data

/obj/item/device/professor_dummy_tablet/ui_data(mob/user)
	if(!linked_dummy)
		return

	var/list/data = list(
		"status" = linked_dummy.stat,
		"health" = linked_dummy.health,
		"total_brute" = floor(linked_dummy.getBruteLoss()),
		"total_burn" = floor(linked_dummy.getFireLoss()),
		"total_toxin" = floor(linked_dummy.getToxLoss()),
		"total_oxy" = floor(linked_dummy.getOxyLoss()),
		"revival_timer" = linked_dummy.revive_grace_period DECISECONDS_TO_SECONDS
	)

	if(linked_dummy.stat == DEAD)
		var/revival_time_left = linked_dummy.timeofdeath - world.time + linked_dummy.revive_grace_period
		if(revival_time_left <= 0)
			data["revival_timer"] = 0
		else
			data["revival_timer"] = floor(revival_time_left DECISECONDS_TO_SECONDS)

	return data

/obj/item/device/professor_dummy_tablet/ui_status(mob/user, datum/ui_state/state)
	. = ..()

	if(is_adjacent_to_dummy(user))
		return UI_INTERACTIVE

	return UI_DISABLED

/obj/item/device/professor_dummy_tablet/ui_state(mob/user)
	return GLOB.not_incapacitated_and_inventory_state

/obj/item/device/professor_dummy_tablet/tgui_interact(mob/user, datum/tgui/ui, datum/ui_state/state)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "DummyTablet", "Dummy Tablet")
		ui.open()

/obj/item/device/professor_dummy_tablet/ui_act(action, list/params, datum/tgui/ui, datum/ui_state/state)
	. = ..()

	var/mob/user = ui.user

	switch(action)
		if("brute_damage_organ")
			var/selection = select_internal_organ()
			if(!selection)
				return
			var/datum/internal_organ/organ = LAZYACCESS(linked_dummy.internal_organs_by_name, selection)
			if(!organ)
				return
			var/amount = tgui_input_real_number(user, "Amount?")
			if(!amount)
				return
			organ.take_damage(amount)
		if("brute_damage_limb")
			var/selection = select_body_part()
			if(!selection)
				return
			var/obj/limb/limb = linked_dummy.get_limb(selection)
			if(!limb || limb?.status & LIMB_DESTROYED)
				return
			var/amount = tgui_input_real_number(user, "Amount?")
			if(!amount)
				return
			limb.take_damage(amount)
		if("burn_damage")
			var/selection = select_body_part()
			if(!selection)
				return
			var/obj/limb/limb = linked_dummy.get_limb(selection)
			if(!limb || limb?.status & LIMB_DESTROYED)
				return
			var/amount = tgui_input_real_number(user, "Amount?")
			if(!amount)
				return
			limb.take_damage(0, amount)
		if("toxin")
			var/amount = tgui_input_real_number(user, "Amount?")
			if(!amount)
				return
			linked_dummy.setToxLoss(amount)
		if("bones")
			var/selection = select_body_part()
			if(!selection)
				return
			var/obj/limb/limb = linked_dummy.get_limb(selection)
			if(!limb || limb?.status & LIMB_DESTROYED)
				return
			limb.fracture(100)
		if("eschar")
			var/selection = select_body_part()
			if(!selection)
				return
			var/obj/limb/limb = linked_dummy.get_limb(selection)
			if(!limb || limb?.status & LIMB_ESCHAR)
				return
			limb.eschar()
			limb.take_damage(0, limb.burn_healing_threshold)
		if("blood_loss")
			var/amount = tgui_input_real_number(user, "Amount?")
			if(!amount)
				return
			linked_dummy.drip(amount)
		if("bleeding")
			var/selection = select_body_part()
			if(!selection)
				return
			var/obj/limb/limb = linked_dummy.get_limb(selection)
			if(!limb || limb?.status & LIMB_DESTROYED)
				return
			var/datum/wound/internal_bleeding/internal_bleeding = new(linked_dummy.effects_list)
			limb.add_bleeding(internal_bleeding, TRUE)
			limb.wounds += internal_bleeding
		if("shrapnel")
			var/selection = select_body_part()
			if(!selection)
				return
			var/obj/limb/limb = linked_dummy.get_limb(selection)
			if(!limb || limb?.status & LIMB_DESTROYED)
				return
			var/obj/item/shard/shrapnel/shrapnel = new /obj/item/shard/shrapnel()
			limb.embed(shrapnel)
		if("delimb")
			var/selection = select_body_part()
			var/clean_amputation_confirmation = tgui_alert(user, "Should the limb be cleanly removed?", "Confirmation", list("Yes", "No"), 10 SECONDS)
			var/clean_amputation = TRUE
			if(!clean_amputation_confirmation)
				return
			if(clean_amputation_confirmation == "No")
				clean_amputation = FALSE
			var/obj/limb/limb = linked_dummy.get_limb(selection)
			if(!limb || limb?.status & LIMB_DESTROYED)
				return
			if(!clean_amputation)
				limb.parent?.take_damage(30, 0, TRUE)
			limb.droplimb(clean_amputation, TRUE, "tablet")
			playsound(loc, 'sound/weapons/slice.ogg', 25)
		if("simulate_parasite")
			if(locate(/obj/item/toy/plush) in linked_dummy)
				to_chat(user, SPAN_WARNING("[linked_dummy] already contains a parasite!"))
				return
			var/obj/item/toy/plush/plush = pick(parasite_types)
			new plush(linked_dummy)
			to_chat(user, SPAN_WARNING("[linked_dummy] now contains a training parasite!"))
		if("randomize_condition")
			randomize_dummy_condition(user)
		if("set_revival_time")
			var/grace_period = tgui_input_number(user, "How many seconds should the revival timer be set to?")
			if(!grace_period || grace_period == linked_dummy.revive_grace_period)
				return
			linked_dummy.revive_grace_period = grace_period SECONDS
		if("reset")
			linked_dummy.revive()
