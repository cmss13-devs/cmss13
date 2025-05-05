/obj/structure/machinery/iv_drip
	name = "\improper IV drip"
	icon = 'icons/obj/structures/machinery/iv_drip.dmi'
	anchored = FALSE
	density = FALSE
	drag_delay = 1
	base_pixel_x = 15
	base_pixel_y = -2

	var/mob/living/carbon/attached = null
	var/mode = 1 // 1 is injecting, 0 is taking blood.
	var/obj/item/reagent_container/beaker = null
	var/datum/beam/current_beam
	//make it so that IV doesn't require power to function.
	use_power = USE_POWER_NONE
	needs_power = FALSE

/obj/structure/machinery/iv_drip/update_icon()
	if(attached)
		icon_state = "hooked"
	else
		icon_state = ""

	overlays = null

	if(beaker)
		var/datum/reagents/reagents = beaker.reagents
		if(reagents.total_volume)
			var/image/filling = image('icons/obj/structures/machinery/iv_drip.dmi', src, "reagent")

			var/percent = floor((reagents.total_volume / beaker.volume) * 100)
			switch(percent)
				if(0 to 9)
					filling.icon_state = "reagent0"
				if(10 to 24)
					filling.icon_state = "reagent10"
				if(25 to 49)
					filling.icon_state = "reagent25"
				if(50 to 74)
					filling.icon_state = "reagent50"
				if(75 to 79)
					filling.icon_state = "reagent75"
				if(80 to 90)
					filling.icon_state = "reagent80"
				if(91 to INFINITY)
					filling.icon_state = "reagent100"

			filling.color = mix_color_from_reagents(reagents.reagent_list)
			overlays += filling

/obj/structure/machinery/iv_drip/proc/update_beam()
	if(current_beam && !attached)
		QDEL_NULL(current_beam)
	else if(!current_beam && attached && !QDELETED(src))
		current_beam = beam(attached, "iv_tube")

/obj/structure/machinery/iv_drip/Destroy()
	attached?.active_transfusions -= src
	attached = null
	update_beam()
	. = ..()

/obj/structure/machinery/iv_drip/MouseDrop(over_object, src_location, over_location)
	..()

	if(ishuman(usr))
		var/mob/living/carbon/human/user = usr
		if(user.is_mob_incapacitated() || get_dist(user, src) > 1 || user.blinded)
			return

		if(!skillcheck(user, SKILL_SURGERY, SKILL_SURGERY_NOVICE))
			to_chat(user, SPAN_WARNING("You don't know how to [attached ? "disconnect" : "connect"] this!"))
			return

		if(attached)
			user.visible_message("[user] detaches \the [src] from \the [attached].",
			"You detach \the [src] from \the [attached].")
			attached.active_transfusions -= src
			attached = null
			update_beam()
			update_icon()
			stop_processing()
			return

		if(in_range(src, usr) && iscarbon(over_object) && get_dist(over_object, src) <= 1)
			user.visible_message("[user] attaches \the [src] to \the [over_object].",
			"You attach \the [src] to \the [over_object].")
			attached = over_object
			attached.active_transfusions += src
			update_beam()
			update_icon()
			start_processing()

/obj/structure/machinery/iv_drip/attackby(obj/item/container, mob/living/user)
	if (istype(container, /obj/item/reagent_container))
		if(beaker)
			to_chat(user, SPAN_WARNING("There is already a reagent container loaded!"))
			return

		if((!istype(container, /obj/item/reagent_container/blood) && !istype(container, /obj/item/reagent_container/glass)) || istype(container, /obj/item/reagent_container/glass/bucket))
			to_chat(user, SPAN_WARNING("That won't fit!"))
			return

		if(user.drop_inv_item_to_loc(container, src))
			beaker = container

			var/reagentnames = ""

			for(var/datum/reagent/chem in beaker.reagents.reagent_list)
				reagentnames += ";[chem.name]"

			log_admin("[key_name(user)] put \a [beaker] into [src], containing [reagentnames] at ([src.loc.x],[src.loc.y],[src.loc.z]).")

			to_chat(user, "You attach \the [container] to \the [src].")
			update_beam()
			update_icon()
		return
	else
		return ..()


/obj/structure/machinery/iv_drip/process()
	if(src.attached)

		if(!(get_dist(src, src.attached) <= 1 && isturf(src.attached.loc)))
			visible_message("The needle is ripped out of [src.attached], doesn't that hurt?")
			attached.apply_damage(3, BRUTE, pick("r_arm", "l_arm"))
			if(attached.pain.feels_pain)
				attached.emote("scream")
			attached.active_transfusions -= src
			attached = null
			update_beam()
			update_icon()
			stop_processing()
			return

	if(attached && beaker)
		// Give blood
		if(mode)
			if(beaker.volume > 0)
				var/transfer_amount = REAGENTS_METABOLISM
				if(istype(src.beaker, /obj/item/reagent_container/blood))
					// speed up transfer on blood packs
					transfer_amount = 4
				attached.inject_blood(beaker, transfer_amount)
				update_icon()

		// Take blood
		else
			var/amount = beaker.reagents.maximum_volume - beaker.reagents.total_volume
			amount = min(amount, 4)
			// If the beaker is full, ping
			if(amount == 0)
				if(prob(5))
					visible_message("\The [src] pings.")
				return

			var/mob/living/carbon/patient = attached

			if(!istype(patient))
				return
			if(ishuman(patient))
				var/mob/living/carbon/human/human_patient = patient
				if(human_patient.species && human_patient.species.flags & NO_BLOOD)
					return

			// If the human is losing too much blood, beep.
			if(patient.blood_volume < BLOOD_VOLUME_SAFE && prob(5))
				visible_message("\The [src] beeps loudly.")

			patient.take_blood(beaker,amount)
			update_icon()

/obj/structure/machinery/iv_drip/attack_hand(mob/user as mob)
	if(src.beaker)
		src.beaker.forceMove(get_turf(src))
		src.beaker = null
		update_icon()
	else
		return ..()


/obj/structure/machinery/iv_drip/verb/toggle_mode()
	set category = "Object"
	set name = "Toggle Mode"
	set src in view(1)

	if(!istype(usr, /mob/living))
		return

	if(usr.stat || usr.is_mob_incapacitated())
		return

	mode = !mode
	to_chat(usr, "The IV drip is now [mode ? "injecting" : "taking blood"].")

/obj/structure/machinery/iv_drip/get_examine_text(mob/user)
	. = ..()
	. += "The IV drip is [mode ? "injecting" : "taking blood"]."

	if(beaker)
		if(beaker.reagents && length(beaker.reagents.reagent_list))
			. += SPAN_NOTICE(" Attached is \a [beaker] with [beaker.reagents.total_volume] units of liquid.")
		else
			. += SPAN_NOTICE(" Attached is an empty [beaker].")
	else
		. += SPAN_NOTICE(" No chemicals are attached.")

	. += SPAN_NOTICE(" [attached ? attached : "No one"] is attached.")
