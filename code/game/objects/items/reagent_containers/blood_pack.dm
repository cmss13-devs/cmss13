/obj/item/reagent_container/blood
	name = "BloodPack"
	desc = "Contains blood used for transfusion."
	icon = 'icons/obj/items/bloodpack.dmi'
	icon_state = "empty"
	volume = 160
	matter = list("plastic" = 500)
	flags_atom = CAN_BE_SYRINGED
	transparent = TRUE
	var/mode = 1 // 1 is injecting, 0 is taking blood.
	var/mob/living/carbon/human/connected_to
	var/blood_type = null

/obj/item/reagent_container/blood/Initialize()
	. = ..()
	if(blood_type != null)
		name = "BloodPack [blood_type]"
		reagents.add_reagent("blood", 160, list("viruses"=null,"blood_type"=blood_type,"resistances"=null))
		update_icon()

/obj/item/reagent_container/blood/on_reagent_change()
	update_icon()

/obj/item/reagent_container/blood/update_icon()
	var/percent = round((reagents.total_volume / volume) * 100)
	switch(percent)
		if(0 to 9) icon_state = "empty"
		if(10 to 50) icon_state = "half"
		if(51 to INFINITY) icon_state = "full"

/obj/item/reagent_container/blood/attack(mob/attacked_mob, mob/user)
	. = ..()
	if(connected_to == attacked_mob)
		connected_to = null
		STOP_PROCESSING(SSobj, src)
		user.visible_message("[user] detaches \the [src] from \the [connected_to].", \
			"You detach \the [src] from \the [connected_to].")
		return

	if(istype(attacked_mob, /mob/living/carbon/human))
		connected_to = attacked_mob
		START_PROCESSING(SSobj, src)
		user.visible_message("[user] attaches [src] to [connected_to].", \
			"You attach [src] to [connected_to].")

/obj/item/reagent_container/blood/process()
	if(!connected_to)
		STOP_PROCESSING(SSobj, src)

	if(!(get_dist(src, src.connected_to) <= 1 && isturf(src.connected_to.loc)))
		visible_message("[src] breaks free of [connected_to]!")
		connected_to.apply_damage(3, BRUTE, pick("r_arm", "l_arm"))
		connected_to = null
		STOP_PROCESSING(SSobj, src)
		return

	//give blood
	if(mode)
		if(volume > 0)
			var/transfer_amount = REAGENTS_METABOLISM * 2
			connected_to.inject_blood(src, transfer_amount)

	// Take blood
	else
		var/amount = reagents.maximum_volume - reagents.total_volume
		amount = min(amount, 4)
		if(amount == 0)
			return

		var/mob/living/carbon/connected_carbon = connected_to

		if(!istype(connected_carbon))
			return
		if(ishuman(connected_carbon))
			var/mob/living/carbon/human/connected_human = connected_carbon
			if(connected_human.species && connected_human.species.flags & NO_BLOOD)
				return

		connected_carbon.take_blood(src, amount)

/obj/item/reagent_container/blood/verb/toggle_mode()
	set category = "Object"
	set name = "Toggle Mode"
	set src in view(1)

	if(!istype(usr, /mob/living))
		return

	if(usr.stat || usr.lying)
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
	name = "Empty BloodPack"
	desc = "Seems pretty useless... Maybe if there were a way to fill it?"
	icon_state = "empty"
