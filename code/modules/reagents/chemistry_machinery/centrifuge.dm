/obj/structure/machinery/centrifuge
	name = "Chemical Centrifuge"
	desc = "A machine that uses centrifugal forces to separate fluids of different densities. Needs a reagent container for input and a vialbox for output."
	icon = 'icons/obj/structures/machinery/science_machines.dmi'
	icon_state = "centrifuge_empty_open"
	active_power_usage = 500

	var/obj/item/reagent_container/glass/input_container = null //Our input beaker
	var/obj/item/storage/fancy/vials/output_container //Contains vials for the output

	var/processing = 0
	var/status = 0

/obj/structure/machinery/centrifuge/attackby(obj/item/B, mob/living/user)
	if(processing)
		to_chat(user, SPAN_WARNING("The [src] is still running!"))
		return
	if(!skillcheck(user, SKILL_RESEARCH, SKILL_RESEARCH_TRAINED))
		to_chat(user, SPAN_WARNING("You have no idea how to use this."))
		return
	if(B.is_open_container() || istype(B, /obj/item/reagent_container/blood))
		if(input_container)
			to_chat(user, SPAN_WARNING("A container is already loaded into the [src]."))
			return
		if(user.drop_inv_item_to_loc(B, src))
			input_container = B
			if(output_container)
				icon_state = "centrifuge_on_closed"
			else
				icon_state = "centrifuge_on_open"
	else if(istype(B, /obj/item/storage/fancy/vials))
		if(output_container)
			to_chat(user, SPAN_WARNING("A vial box is already loaded into the [src]."))
			return
		if(user.drop_inv_item_to_loc(B, src))
			output_container = B
			if(input_container)
				icon_state = "centrifuge_on_closed"
			else
				icon_state = "centrifuge_empty_closed"
	else
		to_chat(user, SPAN_WARNING("[B] doesn't fit in the [src]."))
		return
	if(input_container && output_container)
		to_chat(user, SPAN_NOTICE("You insert [B] and start configuring the [src]."))
		updateUsrDialog()
		icon_state = "centrifuge_spinning"
		processing = 1
		playsound(loc, 'sound/machines/centrifuge.ogg', 30)
		start_processing()
	else
		to_chat(user, SPAN_NOTICE("You insert [B] into the [src]."))

/obj/structure/machinery/centrifuge/attack_hand(mob/user as mob)
	if(processing)
		to_chat(user, SPAN_WARNING("The [src] is still running!"))
		return
	if(!input_container && !output_container)
		to_chat(user, SPAN_WARNING("The [src] is empty."))
		return
	if(output_container)
		to_chat(user, SPAN_NOTICE("You remove the [output_container] from the [src]."))
		user.put_in_active_hand(output_container)
		output_container = null
		if(input_container)
			icon_state = "centrifuge_on_open"
		else
			icon_state = "centrifuge_empty_open"
	else if(input_container)
		to_chat(user, SPAN_NOTICE("You remove the [input_container] from the [src]."))
		user.put_in_active_hand(input_container)
		input_container = null
		icon_state = "centrifuge_empty_open"
	return

/obj/structure/machinery/centrifuge/process()
	status++
	if(status <= 1)
		centrifuge()
	if(status >= 2)
		status = 0
		processing = 0
		icon_state = "centrifuge_finish"
		stop_processing()
		return

/obj/structure/machinery/centrifuge/proc/centrifuge()
	if(!output_container.contents.len) return //Is output empty?

	var/initial_reagents = input_container.reagents.reagent_list.len
	var/list/vials = list()
	for(var/obj/item/reagent_container/V in output_container.contents)
		vials += V

	//Split reagent types best possible, if we have move volume that types available, split volume best possible
	if(initial_reagents)
		var/distribute = TRUE
		if(initial_reagents == 1)
			distribute = FALSE
		for(var/datum/reagent/R in input_container.reagents.reagent_list)

			//A filter mechanic for QoL, as you'd never want multiple full vials with the same reagent. Lets players use impure vials as filters.
			var/filter = FALSE
			for(var/obj/item/reagent_container/V in vials)
				if(distribute && V.reagents.has_reagent(R.id))
					if(V.reagents.reagent_list.len > 1 || V.reagents.total_volume == V.reagents.maximum_volume) //If the reagent is in an impure vial, or a full vial, we skip it
						filter = 1
						break
			if(filter)
				continue

			for(var/obj/item/reagent_container/V in vials)
				//Check the vial
				if(V.reagents.reagent_list.len > 1) //We don't work with impure vials
					continue
				if(V.reagents.get_reagents() && !V.reagents.has_reagent(R.id)) //We only add to vials with the same reagent
					continue
				if(V.reagents.total_volume == V.reagents.maximum_volume) //The vial is full
					continue

				//Calculate how much we are transfering
				var/amount_to_transfer = V.reagents.maximum_volume - V.reagents.total_volume
				if(R.volume < amount_to_transfer)
					amount_to_transfer = R.volume

				//Transfer to the vial
				V.reagents.add_reagent(R.id,amount_to_transfer,R.data_properties)
				input_container.reagents.remove_reagent(R.id,amount_to_transfer)
				V.update_icon()

				if(distribute)//otherwise we want to fill all
					break //Continue to next reagent

	//Label the vials
	for(var/obj/item/reagent_container/V in vials)
		if(istype(V,/obj/item/reagent_container/hypospray/autoinjector))
			var/obj/item/reagent_container/hypospray/autoinjector/A = V
			if(!(A.reagents.reagent_list.len) || (A.reagents.reagent_list.len > 1))
				A.name = "autoinjector"
			else
				A.name = "autoinjector (" + A.reagents.reagent_list[1].name + ")"
				A.uses_left = 3
				A.update_icon()
		else
			if(!(V.reagents.reagent_list.len) || (V.reagents.reagent_list.len > 1))
				V.name = "vial"
			else
				V.name = "vial (" + V.reagents.reagent_list[1].name + ")"

	input_container.update_icon()
	output_container.contents = vials