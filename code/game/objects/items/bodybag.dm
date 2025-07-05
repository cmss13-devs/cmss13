//Also contains /obj/structure/closet/bodybag because I doubt anyone would think to look for bodybags in /object/structures

/obj/item/bodybag
	name = "body bag"
	desc = "A folded bag designed for the storage and transportation of cadavers."
	icon = 'icons/obj/bodybag.dmi'
	item_icons = list(
		WEAR_L_HAND = 'icons/mob/humans/onmob/inhands/equipment/medical_lefthand.dmi',
		WEAR_R_HAND = 'icons/mob/humans/onmob/inhands/equipment/medical_righthand.dmi',
	)
	icon_state = "bodybag_folded"
	item_state = "bodybag"
	w_class = SIZE_SMALL
	var/unfolded_path = /obj/structure/closet/bodybag

/obj/item/bodybag/attack_self(mob/user)
	..()
	deploy_bodybag(user, user.loc)

/obj/item/bodybag/afterattack(atom/target, mob/user, proximity)
	if(!proximity)
		return
	if(isturf(target))
		var/turf/T = target
		if(!T.density)
			deploy_bodybag(user, T)

/obj/item/bodybag/proc/deploy_bodybag(mob/user, atom/location)
	var/obj/structure/closet/bodybag/R = new unfolded_path(location, src)
	R.add_fingerprint(user)
	R.open(user)
	user.temp_drop_inv_item(src)
	qdel(src)


/obj/item/bodybag/cryobag
	name = "stasis bag"
	desc = "A folded, reusable bag designed to prevent additional damage to an occupant."
	icon = 'icons/obj/bodybag.dmi'
	icon_state = "cryobag_folded"
	item_state = "cryobag"
	unfolded_path = /obj/structure/closet/bodybag/cryobag
	matter = list("plastic" = 7500)
	var/used = 0

/obj/item/bodybag/cryobag/Initialize(mapload, obj/structure/closet/bodybag/cryobag/CB)
	. = ..()
	if(CB)
		used = CB.used

/obj/item/storage/box/bodybags
	name = "body bags box"
	desc = "This box contains body bags."
	icon_state = "bodybags"
	w_class = SIZE_LARGE
	can_hold = list(/obj/item/bodybag)

/obj/item/storage/box/bodybags/fill_preset_inventory()
	for(var/i = 1 to 7)
		new /obj/item/bodybag(src)

/obj/structure/closet/bodybag
	name = "body bag"
	var/bag_name = "body bag"
	desc = "A plastic bag designed for the storage and transportation of cadavers."
	icon = 'icons/obj/bodybag.dmi'
	icon_state = "bodybag_closed"
	icon_closed = "bodybag_closed"
	icon_opened = "bodybag_open"
	open_sound = 'sound/items/zip.ogg'
	close_sound = 'sound/items/zip.ogg'
	var/item_path = /obj/item/bodybag
	/// the active var that tracks the cooldown for opening and closing
	var/open_cooldown = 0
	density = FALSE
	anchored = FALSE
	/// To layer above rollerbeds.
	layer = ABOVE_OBJ_LAYER
	/// slightly easier than to drag the body directly.
	drag_delay = 2
	/// the roller bed this bodybag is attached to.
	var/obj/structure/bed/roller/roller_buckled
	/// How many extra pixels to offset the bag by when buckled, since rollerbeds are set up to offset a centered horizontal human sprite.
	var/buckle_offset = 5
	store_items = FALSE

/obj/structure/closet/bodybag/Initialize()
	. = ..()
	storage_capacity = (mob_size * 2) - 1

/obj/structure/closet/bodybag/proc/update_name()
	if(opened)
		name = bag_name
	else
		var/mob/living/carbon/human/H = locate() in contents
		if(H)
			name = "[bag_name] ([H.get_visible_name()])"
		else
			name = "[bag_name] (empty)"

/obj/structure/closet/bodybag/attackby(obj/item/W, mob/user)
	if(HAS_TRAIT(W, TRAIT_TOOL_PEN))
		var/prior_label_text
		var/datum/component/label/labelcomponent = GetComponent(/datum/component/label)
		if(labelcomponent && labelcomponent.has_label())
			prior_label_text = labelcomponent.label_name
		var/tmp_label = tgui_input_text(user, "Enter a label for [src]", "Label", prior_label_text, MAX_NAME_LEN, ui_state=GLOB.not_incapacitated_state)
		if(isnull(tmp_label))
			return // Canceled
		if(!tmp_label)
			if(prior_label_text)
				to_chat(user, SPAN_NOTICE("You're going to need to use wirecutters to remove the label."))
			return
		if(length(tmp_label) > MAX_NAME_LEN)
			to_chat(user, SPAN_WARNING("The label can be at most [MAX_NAME_LEN] characters long."))
			return
		if(prior_label_text == tmp_label)
			to_chat(user, SPAN_WARNING("The label already says \"[tmp_label]\"."))
			return
		user.visible_message(SPAN_NOTICE("[user] labels [src] as \"[tmp_label]\"."),
		SPAN_NOTICE("You label [src] as \"[tmp_label]\"."))
		msg_admin_niche("[key_name(usr)] changed [src]'s name to [tmp_label] [ADMIN_JMP(src)]")
		AddComponent(/datum/component/label, tmp_label)
		playsound(src, "paper_writing", 15, TRUE)
		return

	else if(HAS_TRAIT(W, TRAIT_TOOL_WIRECUTTERS))
		overlays.Cut()
		var/datum/component/label/labelcomponent = GetComponent(/datum/component/label)
		if(labelcomponent && labelcomponent.has_label())
			log_admin("[key_name(usr)] has removed label from [src].")
			user.visible_message(SPAN_NOTICE("[user] cuts the tag off of the [name]."),
								SPAN_NOTICE("You cut the tag off the [name]."))
			labelcomponent.clear_label()
		return

	else if(istype(W, /obj/item/weapon/zombie_claws))
		open()

/obj/structure/closet/bodybag/store_mobs(stored_units) // overriding this
	var/list/dead_mobs = list()
	for(var/mob/living/mob in loc)
		if(mob.buckled)
			continue
		if(mob.stat != DEAD) // covers alive mobs
			continue
		if(!ishuman(mob)) // all the dead other shit
			dead_mobs += mob
			continue
		var/mob/living/carbon/human/human = mob
		if(issynth(human))
			continue
		if(human.check_tod() && human.is_revivable()) // revivable
			continue
		dead_mobs += mob
	var/mob/living/mob_to_store
	if(length(dead_mobs))
		mob_to_store = pick(dead_mobs)
		mob_to_store.forceMove(src)
		stored_units += mob_size
	for(var/obj/item/limb/limb in loc)
		limb.forceMove(src)
	return stored_units

/obj/structure/closet/bodybag/attack_hand(mob/living/user)
	if(!opened)
		open_cooldown = world.time + 10 //1s cooldown for opening and closing, stop that spam! - stan_albatross
	if(opened && open_cooldown > world.time)
		to_chat(user, SPAN_WARNING("\The [src] has been opened too recently!"))
		return
	user.visible_message(SPAN_WARNING("[user] opens [src]."), SPAN_NOTICE("You open [src]."))
	. = ..()


/obj/structure/closet/bodybag/close()
	if(..())
		density = FALSE
		update_name()
		return 1
	return 0

/obj/structure/closet/bodybag/open()
	. = ..()
	update_name()

/obj/structure/closet/bodybag/MouseDrop(over_object, src_location, over_location)
	..()
	if(over_object == usr && Adjacent(usr) && !roller_buckled)
		if(!ishuman(usr))
			return
		if(length(contents))
			return 0
		visible_message(SPAN_NOTICE("[usr] folds up [name]."))
		var/obj/item/I = new item_path(get_turf(src), src)
		usr.put_in_hands(I)
		qdel(src)



/obj/structure/closet/bodybag/Move(NewLoc, direct)
	if (roller_buckled && roller_buckled.loc != NewLoc) //not updating position
		if (!roller_buckled.anchored)
			return roller_buckled.Move(NewLoc, direct)
		else
			return 0
	else
		. = ..()


/obj/structure/closet/bodybag/forceMove(atom/destination)
	if(roller_buckled)
		roller_buckled.unbuckle()
	. = ..()



/obj/structure/closet/bodybag/update_icon()
	if(!opened)
		icon_state = icon_closed
		for(var/mob/living/L in contents)
			icon_state += "1"
			break
	else
		icon_state = icon_opened



/obj/structure/closet/bodybag/cryobag
	name = "stasis bag"
	bag_name = "stasis bag"
	desc = "A reusable plastic bag designed to prevent additional damage to an occupant."
	icon = 'icons/obj/bodybag.dmi'
	icon_state = "cryobag_closed"
	icon_closed = "cryobag_closed"
	icon_opened = "cryobag_open"
	item_path = /obj/item/bodybag/cryobag
	store_items = FALSE
	/// the mob in stasis
	var/mob/living/carbon/human/stasis_mob
	var/used = 0
	/// remembers the value of used, to delay crostasis start.
	var/last_use = 0
	/// 15 mins of usable cryostasis
	var/max_uses = 1800

/obj/structure/closet/bodybag/cryobag/Initialize(mapload, obj/item/bodybag/cryobag/CB)
	. = ..()
	if(CB)
		used = CB.used

/obj/structure/closet/bodybag/cryobag/attackby(obj/item/I, mob/living/user)
	if(!istype(I, /obj/item/device/healthanalyzer))
		return
	if(!stasis_mob)
		to_chat(user, SPAN_WARNING("The stasis bag is empty!"))
		return
	var/obj/item/device/healthanalyzer/J = I
	J.attack(stasis_mob, user) // yes this is awful -spookydonut
	return

/obj/structure/closet/bodybag/cryobag/Destroy()
	var/mob/living/L = locate() in contents
	if(L)
		L.in_stasis = FALSE
		stasis_mob = null
	STOP_PROCESSING(SSobj, src)
	. = ..()

/obj/structure/closet/bodybag/cryobag/update_icon()
	. = ..()
	// Bump up a living player in the bag to layer of an actual corpse and not just an accidentally coverable prop

	overlays.Cut()	// makes sure any previous triage cards are removed

	if(!stasis_mob)
		layer = initial(layer)
		return

	layer = LYING_BETWEEN_MOB_LAYER

	if(stasis_mob.holo_card_color && !opened)
		var/image/holo_card_icon = image('icons/obj/bodybag.dmi', src, "cryocard_[stasis_mob.holo_card_color]")

		if(!holo_card_icon) // makes sure an icon was actually located
			return

		overlays |= holo_card_icon

/obj/structure/closet/bodybag/cryobag/open()
	. = ..()
	if(stasis_mob)
		stasis_mob.in_stasis = FALSE
		UnregisterSignal(stasis_mob, COMSIG_HUMAN_TRIAGE_CARD_UPDATED)
		stasis_mob = null
	STOP_PROCESSING(SSobj, src)
	if(used > max_uses)
		new /obj/item/trash/used_stasis_bag(loc)
		qdel(src)

/obj/structure/closet/bodybag/cryobag/store_mobs(stored_units)
	. = ..()
	var/list/mobs_can_store = list()
	for(var/mob/living/carbon/human/human in loc)
		if(human.buckled || (human.stat == DEAD))
			continue
		mobs_can_store += human
	if(length(mobs_can_store))
		var/mob/living/carbon/human/mob_to_store = pick(mobs_can_store)
		mob_to_store.forceMove(src)
		stored_units += mob_size
	return stored_units

/obj/structure/closet/bodybag/cryobag/close()
	. = ..()
	last_use = used + 1
	for(var/mob/living/carbon/human/human in contents)
		stasis_mob = human
		// Uses RegisterSignal with an override, just in case the human escaped the last bag without calling open() somehow
		RegisterSignal(human, COMSIG_HUMAN_TRIAGE_CARD_UPDATED, PROC_REF(update_icon), TRUE)
		START_PROCESSING(SSobj, src)
		update_icon()
		return

/obj/structure/closet/bodybag/cryobag/process()
	used++
	if(!stasis_mob)
		STOP_PROCESSING(SSobj, src)
		open()
		return
	if(stasis_mob.stat == DEAD)// || !stasis_mob.key || !stasis_mob.client) // stop using cryobags for corpses and SSD/Ghosted
		STOP_PROCESSING(SSobj, src)
		open()
		visible_message(SPAN_NOTICE("\The [src] rejects the corpse."))
		return
	if(used > last_use) //cryostasis takes a couple seconds to kick in.
		if(!stasis_mob.in_stasis)
			stasis_mob.in_stasis = STASIS_IN_BAG
	if(used > max_uses)
		open()

/obj/structure/closet/bodybag/cryobag/get_examine_text(mob/living/user)
	. = ..()
	if(ishuman(stasis_mob) && hasHUD(user,"medical"))
		var/mob/living/carbon/human/H = stasis_mob
		var/stasis_ref = WEAKREF(H)
		for(var/datum/data/record/R as anything in GLOB.data_core.medical)
			if (R.fields["ref"] == stasis_ref)
				if(!(R.fields["last_scan_time"]))
					. += "<span class = 'deptradio'>No scan report on record</span>\n"
				else
					. += "<span class = 'deptradio'><a href='byond://?src=\ref[src];scanreport=1'>Scan from [R.fields["last_scan_time"]]</a></span>\n"
				break



	switch(used)
		if(0 to 600) . += "It looks new."
		if(601 to 1200) . += "It looks a bit used."
		if(1201 to 1800) . += "It looks really used."

/obj/structure/closet/bodybag/cryobag/Topic(href, href_list)
	. = ..()
	if(.)
		return
	if (href_list["scanreport"])
		if(hasHUD(usr,"medical"))
			if(!skillcheck(usr, SKILL_MEDICAL, SKILL_MEDICAL_MEDIC))
				to_chat(usr, SPAN_WARNING("You're not trained to use this."))
				return
			if(get_dist(usr, src) > 7)
				to_chat(usr, SPAN_WARNING("[src] is too far away."))
				return
			if(ishuman(stasis_mob))
				var/mob/living/carbon/human/H = stasis_mob
				var/stasis_ref = WEAKREF(H)
				for(var/datum/data/record/R as anything in GLOB.data_core.medical)
					if (R.fields["ref"] == stasis_ref)
						if(R.fields["last_scan_time"] && R.fields["last_tgui_scan_result"])
							tgui_interact(usr, human = H)
						break

/obj/structure/closet/bodybag/cryobag/tgui_interact(mob/user, datum/tgui/ui, mob/living/carbon/human/human)
	. = ..()
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "HealthScan", "Last Medical Scan of [human]")
		ui.open()
		ui.set_autoupdate(FALSE)

/obj/structure/closet/bodybag/cryobag/ui_data(mob/user)
	if(ishuman(stasis_mob))
		var/mob/living/carbon/human/H = stasis_mob
		var/stasis_ref = WEAKREF(H)
		for(var/datum/data/record/R as anything in GLOB.data_core.medical)
			if(R.fields["ref"] == stasis_ref)
				if(R.fields["last_tgui_scan_result"])
					return R.fields["last_tgui_scan_result"]

/obj/structure/closet/bodybag/cryobag/ui_state(mob/user)
	return GLOB.not_incapacitated_state

/obj/item/trash/used_stasis_bag
	name = "used stasis bag"
	icon = 'icons/obj/bodybag.dmi'
	icon_state = "cryobag_used"
	desc = "It's been ripped open. You will need to find a machine capable of recycling it."
