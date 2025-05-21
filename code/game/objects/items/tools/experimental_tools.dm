/obj/item/tool/crew_monitor
	name = "crew monitor"
	desc = "A tool used to get coordinates to deployed personnel. It was invented after it was found out 3/4 command officers couldn't read numbers."
	icon = 'icons/obj/items/devices.dmi'
	icon_state = "crew_monitor"
	flags_equip_slot = SLOT_WAIST
	w_class = SIZE_SMALL
	var/datum/radar/lifeline/radar
	var/faction = FACTION_MARINE

/obj/item/tool/crew_monitor/Initialize(mapload, ...)
	. = ..()
	radar = new /datum/radar/lifeline(src, faction)

/obj/item/tool/crew_monitor/Destroy()
	QDEL_NULL(radar)
	. = ..()

/obj/item/tool/crew_monitor/attack_self(mob/user)
	. = ..()
	radar.tgui_interact(user)

/obj/item/tool/crew_monitor/dropped(mob/user)
	. = ..()
	SStgui.close_uis(src)

/obj/item/clothing/suit/auto_cpr
	name = "autocompressor" //autocompressor
	desc = "A device that gives regular compression to the victim's ribcage, used in case of urgent heart issues.\nClick a person with it to place it on them."
	icon = 'icons/obj/items/medical_tools.dmi'
	icon_state = "autocomp"
	item_state = "autocomp"
	item_state_slots = list(WEAR_JACKET = "autocomp")
	w_class = SIZE_MEDIUM
	flags_equip_slot = SLOT_OCLOTHING
	flags_atom = FPRINT|CONDUCT
	flags_item = NOBLUDGEON
	force = 5
	throwforce = 5
	var/last_pump
	var/doing_cpr = FALSE
	var/pump_cost = 20
	var/obj/item/cell/pdcell = null
	movement_compensation = 0
	item_icons = list(
		WEAR_JACKET = 'icons/mob/humans/onmob/clothing/suits/objects.dmi',
	)

/obj/item/clothing/suit/auto_cpr/Initialize(mapload, ...)
	. = ..()
	pdcell = new/obj/item/cell(src) //has 1000 charge
	update_icon()

/obj/item/clothing/suit/auto_cpr/mob_can_equip(mob/living/carbon/human/H, slot, disable_warning = 0, force = 0)
	. = ..()
	if(!ishuman_strict(H))
		return FALSE

/obj/item/clothing/suit/auto_cpr/attack(mob/living/carbon/human/M, mob/living/user)
	if(M == user)
		return ..()
	if(!skillcheck(user, SKILL_MEDICAL, SKILL_MEDICAL_MEDIC))
		to_chat(user, SPAN_WARNING("You have no idea how to use \the [src]..."))
		return
	if(M.stat == CONSCIOUS)
		to_chat(user, SPAN_WARNING("They're fine, no need for <b>CPR</b>!"))
		return
	if(!M.is_revivable() || !M.check_tod())
		to_chat(user, SPAN_WARNING("That won't be of any use, they're already too far gone!"))
		return
	if(istype(M) && user.a_intent == INTENT_HELP)
		if(M.wear_suit)
			to_chat(user, SPAN_WARNING("Their [M.wear_suit] is in the way, remove it first!"))
			return
		if(!mob_can_equip(M, WEAR_JACKET))
			to_chat(user, SPAN_WARNING("\The [src] only fits on humans!"))
			return
		user.affected_message(M,
							SPAN_NOTICE("You start fitting \the [src] onto [M]'s chest."),
							SPAN_WARNING("[user] starts fitting \the [src] onto your chest!"),
							SPAN_NOTICE("[user] starts fitting \the [src] onto [M]'s chest."))
		if(!(do_after(user, HUMAN_STRIP_DELAY * user.get_skill_duration_multiplier(SKILL_MEDICAL), INTERRUPT_ALL, BUSY_ICON_GENERIC, M, INTERRUPT_MOVED, BUSY_ICON_MEDICAL)))
			return
		if(!mob_can_equip(M, WEAR_JACKET))
			return
		user.drop_inv_item_on_ground(src)
		if(!M.equip_to_slot_if_possible(src, WEAR_JACKET))
			user.put_in_active_hand(src)
			return
		M.update_inv_wear_suit()
	else
		return ..()

/obj/item/clothing/suit/auto_cpr/equipped(mob/user, slot)
	..()
	if(slot == WEAR_JACKET)
		start_cpr()

/obj/item/clothing/suit/auto_cpr/unequipped(mob/user, slot)
	. = ..()
	if(slot == WEAR_JACKET)
		end_cpr()


/obj/item/clothing/suit/auto_cpr/update_icon()
	. = ..()
	if(doing_cpr)
		icon_state = "autocomp_active"
	else
		icon_state = "autocomp"
	if(pdcell && pdcell.charge)
		overlays.Cut()
	switch(floor(pdcell.charge * 100 / pdcell.maxcharge))
		if(1 to 32)
			overlays += "cpr_batt_lo"
		if(33 to 65)
			overlays += "cpr_batt_mid"
		if(66 to INFINITY)
			overlays += "cpr_batt_hi"


/obj/item/clothing/suit/auto_cpr/get_examine_text(mob/user)
	. = ..()
	. += SPAN_NOTICE("It has [floor(pdcell.charge * 100 / pdcell.maxcharge)]% charge remaining.")



/obj/item/clothing/suit/auto_cpr/proc/start_cpr()
	if(doing_cpr)
		return
	src.visible_message(SPAN_NOTICE("\The [src] whirrs into life and begins pumping."))
	START_PROCESSING(SSobj,src)
	doing_cpr = TRUE
	update_icon()

/obj/item/clothing/suit/auto_cpr/proc/end_cpr()
	if(!doing_cpr)
		return
	doing_cpr = FALSE
	if(ishuman(loc))
		var/mob/living/carbon/human/H = loc
		H.drop_inv_item_on_ground(src)
		src.visible_message(SPAN_NOTICE("\The [src] automatically detaches from [H]!"))
	src.visible_message(SPAN_NOTICE("\The [src] powers down and stops pumping."))
	STOP_PROCESSING(SSobj,src)
	update_icon()

/obj/item/clothing/suit/auto_cpr/process()
	if(!ishuman(loc))
		end_cpr()
		return PROCESS_KILL

	var/mob/living/carbon/human/H = loc
	if(H.wear_suit != src)
		end_cpr()
		return PROCESS_KILL

	if(pdcell.charge <= 49)
		src.visible_message(SPAN_NOTICE("\The [src] beeps its low power alarm."))
		end_cpr()
		return PROCESS_KILL

	if(world.time > last_pump + 7.5 SECONDS)
		last_pump = world.time
		if(H.stat == UNCONSCIOUS)
			var/suff = min(H.getOxyLoss(), 10) //Pre-merge level, less healing, more prevention of dying.
			H.apply_damage(-suff, OXY)
			H.updatehealth()
			H.affected_message(H,
				SPAN_HELPFUL("You feel a <b>breath of fresh air</b> enter your lungs. It feels good."),
				message_viewer = SPAN_NOTICE("<b>\The [src]</b> automatically performs <b>CPR</b> on <b>[H]</b>.")
				)
			pdcell.use(pump_cost)
			update_icon()
			return
		else if(H.is_revivable() && H.stat == DEAD)
			if(H.cpr_cooldown < world.time)
				H.revive_grace_period += 7 SECONDS
				H.visible_message(SPAN_NOTICE("<b>\The [src]</b> automatically performs <b>CPR</b> on <b>[H]</b>."))
			else
				H.visible_message(SPAN_NOTICE("<b>\The [src]</b> fails to perform CPR on <b>[H]</b>."))
				if(prob(50))
					var/obj/limb/E = H.get_limb("chest")
					E.fracture(100)
			H.cpr_cooldown = world.time + 7 SECONDS
			pdcell.use(pump_cost)
			update_icon()
			return
		else
			end_cpr()
			return PROCESS_KILL

/obj/item/tool/portadialysis
	name = "portable dialysis machine"
	desc = "A man-portable dialysis machine, with a small internal battery that can be recharged. Filters out all foreign compounds from the bloodstream of whoever it's attached to, but also typically ends up removing some blood as well."
	icon = 'icons/obj/items/medical_tools.dmi'
	item_icons = list(
		WEAR_L_HAND = 'icons/mob/humans/onmob/inhands/equipment/medical_lefthand.dmi',
		WEAR_R_HAND = 'icons/mob/humans/onmob/inhands/equipment/medical_righthand.dmi',
	)
	icon_state = "portadialysis"
	item_state = "syringe_0"
	flags_equip_slot = SLOT_WAIST
	w_class = SIZE_MEDIUM
	var/attaching = FALSE
	var/filtering = FALSE
	var/mob/living/carbon/human/attached = null
	var/reagent_removed_per_second = AMOUNT_PER_TIME(3, 2 SECONDS)
	var/obj/item/cell/pdcell = null
	var/filter_cost = AMOUNT_PER_TIME(20, 2 SECONDS)
	var/blood_cost = AMOUNT_PER_TIME(12, 2 SECONDS)
	var/attach_time = 1.2 SECONDS

/obj/item/tool/portadialysis/Initialize(mapload, ...)
	. = ..()

	pdcell = new/obj/item/cell(src) //has 1000 charge
	update_icon()

/obj/item/tool/portadialysis/update_icon(detaching = FALSE)
	overlays.Cut()
	if(attached)
		overlays += "+hooked"
	else
		overlays += "+unhooked"

	if(detaching)
		overlays += "+draining"
		addtimer(CALLBACK(src, PROC_REF(update_icon)), attach_time)

	else if(attaching)
		overlays += "+filling"
		overlays += "+running"

	else if(filtering)
		overlays += "+running"
		overlays += "+filtering"

	if(pdcell && pdcell.charge)
		switch(floor(pdcell.charge * 100 / pdcell.maxcharge))
			if(85 to INFINITY)
				overlays += "dialysis_battery_100"
			if(60 to 84)
				overlays += "dialysis_battery_85"
			if(45 to 59)
				overlays += "dialysis_battery_60"
			if(30 to 44)
				overlays += "dialysis_battery_45"
			if(15 to 29)
				overlays += "dialysis_battery_30"
			if(1 to 14)
				overlays += "dialysis_battery_15"
			else
				overlays += "dialysis_battery_0"

/obj/item/tool/portadialysis/get_examine_text(mob/user)
	. = ..()
	var/currentpercent = 0
	currentpercent = floor(pdcell.charge * 100 / pdcell.maxcharge)
	. += SPAN_INFO("It has [currentpercent]% charge left in its internal battery.")

/obj/item/tool/portadialysis/proc/painful_detach()
	if(!attached) //sanity
		return
	attached.visible_message(SPAN_WARNING("\The [src]'s needle is ripped out of [attached], doesn't that hurt?"))
	to_chat(attached, SPAN_WARNING("Ow! A needle is ripped out of you!"))
	damage_arms(attached)
	if(attached.pain.feels_pain)
		attached.emote("scream")
	attached = null
	filtering = FALSE
	attaching = FALSE
	update_icon(TRUE)
	STOP_PROCESSING(SSobj, src)

/obj/item/tool/portadialysis/attack(mob/living/carbon/human/target, mob/living/carbon/human/user)
	if(!ishuman_strict(target))
		return ..()

	if(!skillcheck(user, SKILL_MEDICAL, SKILL_MEDICAL_MEDIC))
		to_chat(user, SPAN_WARNING("You don't seem to know how to use \the [src]..."))
		return

	if(!pdcell || pdcell.charge == 0)
		to_chat(user, SPAN_NOTICE("\The [src] flashes its 'battery low' light, and refuses to attach."))
		return

	if(ishuman(user))
		if(user.stat || user.blinded || user.body_position == LYING_DOWN)
			return

		if(attaching)
			return

		if(attached && !(target == attached)) //are we already attached to something that isn't the target?
			to_chat(user, SPAN_WARNING("You're already using \the [src] on someone else!"))
			return

		if(target == attached) //are we attached to the target?
			user.visible_message("[user] detaches \the [src] from [attached].",
			"You detach \the [src] from [attached].")
			attached = null
			filtering = FALSE
			attaching = FALSE
			update_icon(TRUE)
			STOP_PROCESSING(SSobj, src)
			return

		else
			//check for if they actually have arms...
			var/obj/limb/l_arm = target.get_limb("l_arm")
			var/obj/limb/r_arm = target.get_limb("r_arm")
			if((l_arm.status & LIMB_DESTROYED) && (r_arm.status & LIMB_DESTROYED))
				to_chat(user, SPAN_WARNING("[target] has no arms to attach \the [src] to!"))
				return

			attaching = TRUE
			update_icon()
			to_chat(target, SPAN_DANGER("[user] is trying to attach \the [src] to you!"))
			user.visible_message(SPAN_WARNING("[user] starts setting up \the [src]'s needle on [target]'s arm."),
				SPAN_WARNING("You start setting up \the [src]'s needle on [target]'s arm."))
			if(!do_after(user, attach_time, INTERRUPT_ALL, BUSY_ICON_FRIENDLY, target, INTERRUPT_MOVED, BUSY_ICON_MEDICAL))
				user.visible_message(SPAN_WARNING("[user] stops setting up \the [src]'s needle on [target]'s arm."),
				SPAN_WARNING("You stop setting up \the [src]'s needle on [target]'s arm."))
				visible_message("\The [src]'s tubing snaps back onto the machine frame.")
				attaching = FALSE
				update_icon()
				return

			user.visible_message("[user] attaches \the [src] to [target].",
			"You attach \the [src] to [target].")
			attached = target
			filtering = TRUE
			attaching = FALSE
			update_icon()
			START_PROCESSING(SSobj, src)
			return

/obj/item/tool/portadialysis/dropped(mob/user)
	if(attached)
		painful_detach()
	. = ..()


/obj/item/tool/portadialysis/process(delta_time)
	if(!attached)
		return

	if(get_dist(src, attached) > 1)
		painful_detach()
		return

	if(!pdcell || pdcell.charge == 0)
		attached.visible_message(SPAN_NOTICE("\The [src] automatically detaches from [attached], blinking its 'battery low' light."))
		attached = null
		filtering = FALSE
		update_icon(TRUE)
		STOP_PROCESSING(SSobj, src)
		return

	var/obj/limb/l_arm = attached.get_limb("l_arm")
	var/obj/limb/r_arm = attached.get_limb("r_arm")
	if((l_arm.status & LIMB_DESTROYED) && (r_arm.status & LIMB_DESTROYED))
		attached.visible_message(SPAN_NOTICE("\The [src] automatically detaches from [attached] - \he has no arms to attach to!."))
		attached = null
		filtering = FALSE
		update_icon(TRUE)
		STOP_PROCESSING(SSobj, src)
		return

	if(filtering)
		attached.reagents.remove_any_but("blood", reagent_removed_per_second*delta_time)
		attached.take_blood(attached, blood_cost*delta_time)
		if(attached.blood_volume < BLOOD_VOLUME_SAFE && prob(5))
			visible_message("\The [src] beeps loudly.")
		pdcell.use(filter_cost*delta_time)

	updateUsrDialog()
	update_icon()

/obj/item/tool/portadialysis/proc/damage_arms(mob/living/carbon/human/human_to_damage)
	var/obj/limb/l_arm = human_to_damage.get_limb("l_arm")
	var/obj/limb/r_arm = human_to_damage.get_limb("r_arm")
	var/list/arms_to_damage = list(l_arm, r_arm)
	if(l_arm.status & LIMB_DESTROYED)
		arms_to_damage -= l_arm
	if(r_arm.status & LIMB_DESTROYED)
		arms_to_damage -= r_arm
	if(length(arms_to_damage))
		human_to_damage.apply_damage(3, BRUTE, pick(arms_to_damage))
