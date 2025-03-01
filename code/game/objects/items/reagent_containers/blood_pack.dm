#define BLOOD_BAG_INJECTING 1
#define BLOOD_BAG_TAKING 0

/obj/item/reagent_container/blood
	name = "blood pack"
	desc = "A blood pack. Contains fluids, typically used for transfusions."
	icon = 'icons/obj/items/bloodpack.dmi'
	icon_state = "bloodpack"
	volume = 300
	matter = list("plastic" = 500)
	flags_atom = CAN_BE_SYRINGED
	transparent = TRUE

	var/mode = BLOOD_BAG_INJECTING
	var/mob/living/carbon/human/connected_to
	var/mob/living/carbon/human/connected_from
	var/blood_type = null
	var/datum/beam/current_beam

/obj/item/reagent_container/blood/Initialize()
	. = ..()
	if(blood_type != null)
		name = "[blood_type] blood pack"
		reagents.add_reagent("blood", initial(volume), list("viruses" = null, "blood_type" = blood_type, "resistances" = null))
		update_icon()

/obj/item/reagent_container/blood/on_reagent_change()
	update_icon()

/obj/item/reagent_container/blood/update_icon()
	var/percent = floor((reagents.total_volume / volume) * 100)
	overlays = null
	underlays = null

	if(blood_type)
		overlays += image('icons/obj/items/bloodpack.dmi', src, blood_type)

	if(reagents && reagents.total_volume)
		var/image/filling = image('icons/obj/items/reagentfillings.dmi', src, "[icon_state]10")

		switch(percent)
			if(1 to 9)
				filling.icon_state = "[icon_state]5"
			if(10 to 19)
				filling.icon_state = "[icon_state]10"
			if(20 to 39)
				filling.icon_state = "[icon_state]25"
			if(40 to 64)
				filling.icon_state = "[icon_state]50"
			if(65 to 79)
				filling.icon_state = "[icon_state]75"
			if(80 to 90)
				filling.icon_state = "[icon_state]80"
			if(91 to INFINITY)
				filling.icon_state = "[icon_state]100"

		filling.color = mix_color_from_reagents(reagents.reagent_list)
		underlays += filling

/obj/item/reagent_container/blood/proc/update_beam()
	if(current_beam)
		QDEL_NULL(current_beam)
	else if(connected_from && connected_to)
		current_beam = connected_from.beam(connected_to, "iv_tube")

/obj/item/reagent_container/blood/attack(mob/attacked_mob, mob/user)
	. = ..()

	if(attacked_mob == user)
		to_chat(user, SPAN_WARNING("You cannot connect this to yourself!"))
		return

	if(connected_to == attacked_mob)
		STOP_PROCESSING(SSobj, src)
		user.visible_message("[user] detaches [src] from [connected_to].",
			"You detach [src] from [connected_to].")
		connected_to.active_transfusions -= src
		connected_to.base_pixel_x = 0
		connected_to = null
		connected_from = null
		update_beam()
		return

	if(!skillcheck(user, SKILL_SURGERY, SKILL_SURGERY_NOVICE))
		to_chat(user, SPAN_WARNING("You don't know how to connect this!"))
		return

	if(user.action_busy)
		return

	if(!do_after(user, (1 SECONDS) * user.get_skill_duration_multiplier(SKILL_SURGERY), INTERRUPT_ALL, BUSY_ICON_FRIENDLY, attacked_mob, INTERRUPT_MOVED, BUSY_ICON_MEDICAL))
		to_chat(user, SPAN_WARNING("You were interrupted before you could finish!"))
		return

	if(istype(attacked_mob, /mob/living/carbon/human))
		connected_to = attacked_mob
		connected_from = user
		connected_to.active_transfusions += src
		connected_to.base_pixel_x = 5
		START_PROCESSING(SSobj, src)
		user.visible_message("[user] attaches \the [src] to [connected_to].",
			"You attach \the [src] to [connected_to].")
		update_beam()

/obj/item/reagent_container/blood/process()
	//if we're not connected to anything stop doing stuff
	if(!connected_to)
		return PROCESS_KILL

	//if we're not on a human stop doing stuff
	if(!ishuman(loc))
		bad_disconnect()
		return PROCESS_KILL

	//if we're not being held in a hand stop doing stuff
	var/mob/living/carbon/human/current_human = loc
	if(!(current_human.l_hand == src || current_human.r_hand == src))
		bad_disconnect()
		return PROCESS_KILL

	//if we're further than 1 tile away or we're not on a turf stop doing stuff
	if(!(get_dist(src, connected_to) <= 1 && isturf(connected_to.loc)))
		bad_disconnect()
		return PROCESS_KILL

	//give blood
	if(mode == BLOOD_BAG_INJECTING)
		if(volume > 0)
			var/transfer_amount = REAGENTS_METABOLISM * 30
			connected_to.inject_blood(src, transfer_amount)
			return

	// Take blood
	var/amount = reagents.maximum_volume - reagents.total_volume
	amount = min(amount, 4)
	if(!amount)
		return

	if(!istype(connected_to))
		return
	if(connected_to.species && connected_to.species.flags & NO_BLOOD)
		return

	connected_to.take_blood(src, amount)

/obj/item/reagent_container/blood/dropped()
	..()
	bad_disconnect()

///Used to standardize effects of a blood bag disconnecting improperly
/obj/item/reagent_container/blood/proc/bad_disconnect()
	if(!connected_to)
		return

	connected_to.visible_message("[src] breaks free of [connected_to]!", "[src] is pulled out of you!")
	connected_to.apply_damage(3, BRUTE, pick("r_arm", "l_arm"))
	if(connected_to.pain.feels_pain)
		connected_to.emote("pain")
	connected_to.active_transfusions -= src
	connected_to.base_pixel_x = 0
	connected_to = null
	connected_from = null
	update_beam()

/obj/item/reagent_container/blood/verb/toggle_mode()
	set category = "Object"
	set name = "Toggle Mode"
	set src in view(1)

	if(!istype(usr, /mob/living))
		return

	if(usr.stat || usr.is_mob_incapacitated())
		return

	mode = !mode
	to_chat(usr, "The blood bag is now [mode ? "giving blood" : "taking blood"].")


/obj/item/reagent_container/blood/APlus
	blood_type = "A+"

/obj/item/reagent_container/blood/AMinus
	blood_type = "A-"

/obj/item/reagent_container/blood/BPlus
	blood_type = "B+"

/obj/item/reagent_container/blood/BMinus
	blood_type = "B-"

/obj/item/reagent_container/blood/OPlus
	blood_type = "O+"

/obj/item/reagent_container/blood/OMinus
	blood_type = "O-"

/obj/item/reagent_container/blood/empty
	name = "empty blood pack"
	desc = "An empty blood pack. Sorry, vampires, no luck here."

#undef BLOOD_BAG_INJECTING
#undef BLOOD_BAG_TAKING
