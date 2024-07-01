#define INPUT_CONTAINER 0
#define INPUT_TURING 1

#define MODE_SPLIT 0
#define MODE_DISTRIBUTE 1

/obj/structure/machinery/centrifuge
	name = "Chemical Centrifuge"
	desc = "A machine that uses centrifugal forces to separate fluids of different densities. Needs a reagent container for input and a vialbox for output. Has a series of toggles to modify its behaviour."
	icon = 'icons/obj/structures/machinery/science_machines.dmi'
	icon_state = "centrifuge_empty_open"
	active_power_usage = 500

	var/obj/item/reagent_container/glass/input_container = null //Our input beaker
	var/obj/item/storage/fancy/vials/output_container //Contains vials for the output
	var/obj/structure/machinery/autodispenser/connected_turing = null

	var/status = 0
	var/centrifuge_mode = MODE_SPLIT
	var/tether_range = 20
	var/input_source = INPUT_CONTAINER
	var/autolabel = null

/obj/structure/machinery/centrifuge/Initialize()
	. = ..()
	connect_turing()


/obj/structure/machinery/centrifuge/proc/connect_turing()
	if(connected_turing)
		return
	connected_turing = locate(/obj/structure/machinery/autodispenser) in range(tether_range, src)
	if(connected_turing)
		RegisterSignal(connected_turing, COMSIG_PARENT_QDELETING, PROC_REF(cleanup))
		visible_message(SPAN_NOTICE("<b>The [src] beeps:</b> Turing Dispenser connected."))

/obj/structure/machinery/centrifuge/attackby(obj/item/B, mob/living/user)
	if(machine_processing)
		to_chat(user, SPAN_WARNING("The [src] is still running!"))
		return
	if(!skillcheck(user, SKILL_RESEARCH, SKILL_RESEARCH_TRAINED))
		to_chat(user, SPAN_WARNING("You have no idea how to use this."))
		return
	if(B.is_open_container() || istype(B, /obj/item/reagent_container/blood))
		if(input_container)
			to_chat(user, SPAN_WARNING("A container is already loaded into the [src]."))
			return
		if(input_source == INPUT_TURING)
			to_chat(user, SPAN_WARNING("The [src] is expecting its input from the Turing. Toggle input back to container if you want to centrifuge this."))
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
	if(((input_container && input_source == INPUT_CONTAINER) || turing_ready()) && output_container)
		to_chat(user, SPAN_NOTICE("You insert [B] and start configuring the [src]."))
		updateUsrDialog()
		icon_state = "centrifuge_spinning"
		start_processing()
	else
		to_chat(user, SPAN_NOTICE("You insert [B] into the [src]."))

/obj/structure/machinery/centrifuge/attack_hand(mob/user as mob)
	if(machine_processing)
		if(input_source == INPUT_TURING && status == 0)
			stop_processing()
		else
			to_chat(user, SPAN_WARNING("The [src] is still running!"))
			return
	if(!skillcheck(user, SKILL_RESEARCH, SKILL_RESEARCH_TRAINED))
		to_chat(user, SPAN_WARNING("You have no idea how to use this."))
		return
	if(!input_container && !output_container)
		tgui_interact(user)
		return
	if(output_container)
		to_chat(user, SPAN_NOTICE("You remove [output_container] from the [src]."))
		user.put_in_active_hand(output_container)
		output_container = null
		if(input_container)
			icon_state = "centrifuge_on_open"
		else
			icon_state = "centrifuge_empty_open"
	else if(input_container)
		to_chat(user, SPAN_NOTICE("You remove [input_container] from the [src]."))
		user.put_in_active_hand(input_container)
		input_container = null
		icon_state = "centrifuge_empty_open"
	return

// TGUI SHIT \\

/obj/structure/machinery/centrifuge/tgui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "Centrifuge", "[src.name]")
		ui.open()

/obj/structure/machinery/centrifuge/ui_state(mob/user)
	return GLOB.not_incapacitated_and_adjacent_state

/obj/structure/machinery/centrifuge/ui_status(mob/user, datum/ui_state/state)
	. = ..()
	if(inoperable())
		return UI_CLOSE

/obj/structure/machinery/centrifuge/ui_data(mob/user)
	var/list/data = list()

	data["mode"] = centrifuge_mode
	data["input_source"] = input_source
	data["label"] = autolabel
	data["turing"] = connected_turing

	return data

/obj/structure/machinery/centrifuge/ui_act(action, list/params, datum/tgui/ui, datum/ui_state/state)
	. = ..()
	if(.)
		return

	switch(action)
		if("togglemode")
			centrifuge_mode = !centrifuge_mode
			. = TRUE

		if("togglesource")
			if(input_source == INPUT_CONTAINER)
				input_source = INPUT_TURING
			else if(input_source == INPUT_TURING)
				input_source = INPUT_CONTAINER
			. = TRUE

		if("setlabel")
			autolabel = reject_bad_text(params["name"])
			. = TRUE

		if("attempt_connection")
			connect_turing()
			. = TRUE

/obj/structure/machinery/centrifuge/process()
	if(turing_ready() && (connected_turing.reagents.total_volume == 0 || connected_turing.status > 1))
		if(connected_turing.reagents.total_volume == 0)
			playsound(loc, 'sound/machines/twobeep.ogg', 15, 1)
			connected_turing.run_program()
		return
	status++
	if(status <= 1)
		playsound(loc, 'sound/machines/centrifuge.ogg', 30)
		centrifuge()
	if(status >= 2)
		status = 0
		icon_state = "centrifuge_finish"
		stop_processing()
		return

/obj/structure/machinery/centrifuge/proc/turing_ready()
	if(QDELETED(connected_turing) || src.z != connected_turing.z || get_dist(src, connected_turing) > tether_range)
		visible_message(SPAN_WARNING("The centrifuge beeps: Turing not found within range."))
		cleanup()
		return FALSE

	if(status == 0 && input_source == INPUT_TURING && connected_turing && connected_turing.outputmode == 2 && (connected_turing.programs[1].len || connected_turing.programs[2].len))
		return TRUE
	return FALSE

/obj/structure/machinery/centrifuge/proc/centrifuge()
	if(!output_container.contents.len) return //Is output empty?

	var/obj/item/reagent_container/source_container = input_container
	if(input_source == INPUT_TURING)
		source_container = connected_turing
	var/initial_reagents = source_container.reagents.reagent_list.len
	var/list/vials = list()
	for(var/obj/item/reagent_container/V in output_container.contents)
		vials += V
	if(initial_reagents)
		if(centrifuge_mode == MODE_SPLIT && initial_reagents > 1)
			split(source_container, vials)
		else
			distribute(source_container, vials)


	//Label the vials
	for(var/obj/item/reagent_container/V in vials)
		if(istype(V,/obj/item/reagent_container/hypospray/autoinjector))
			var/obj/item/reagent_container/hypospray/autoinjector/A = V
			if(autolabel)
				A.name = "autoinjector ([autolabel])"
			else if(!(A.reagents.reagent_list.len))
				A.name = "autoinjector"
			else
				A.name = "autoinjector (" + A.reagents.reagent_list[1].name + ")"
			var/numberOfUses = A.reagents.total_volume / A.amount_per_transfer_from_this
			A.uses_left = floor(numberOfUses) == numberOfUses ? numberOfUses : floor(numberOfUses) + 1
			A.update_icon()
		else
			if(autolabel)
				V.name = "vial ([autolabel])"
			else if(!(V.reagents.reagent_list.len) || (V.reagents.reagent_list.len > 1))
				V.name = "vial"
			else
				V.name = "vial (" + V.reagents.reagent_list[1].name + ")"

	input_container.update_icon()

	output_container.contents = vials


/obj/structure/machinery/centrifuge/proc/split(obj/item/source_container, list/vials)
//Split reagent types best possible, if we have move volume that types available, split volume best possible
	for(var/datum/reagent/R in source_container.reagents.reagent_list)

		//A filter mechanic for QoL, as you'd never want multiple full vials with the same reagent. Lets players use impure vials as filters.
		var/filter = FALSE
		for(var/obj/item/reagent_container/V in vials)
			if(V.reagents.has_reagent(R.id))
				if(length(V.reagents.reagent_list) > 1 || V.reagents.total_volume == V.reagents.maximum_volume) //If the reagent is in an impure vial, or a full vial, we skip it
					filter = 1
					break
		if(filter)
			continue

		for(var/obj/item/reagent_container/V in vials)
			//Check the vial
			if(length(V.reagents.reagent_list) > 1) //We don't work with impure vials
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
			source_container.reagents.remove_reagent(R.id,amount_to_transfer)
			V.update_icon()


/obj/structure/machinery/centrifuge/proc/distribute(obj/item/source_container, list/vials)
	for(var/obj/item/reagent_container/V in vials)
		if(source_container.reagents.total_volume <= 0) //We're out
			break
		if(V.reagents.total_volume == V.reagents.maximum_volume) //The vial is full
			continue

		//Calculate how much we are transfering
		var/amount_to_transfer = V.reagents.maximum_volume - V.reagents.total_volume
		if(source_container.reagents.total_volume < amount_to_transfer)
			amount_to_transfer = source_container.reagents.total_volume

		//Transfer to the vial
		source_container.reagents.trans_to(V, amount_to_transfer)
		V.update_icon()


/obj/structure/machinery/centrifuge/proc/cleanup()
	SIGNAL_HANDLER
	if(connected_turing)
		connected_turing = null

#undef INPUT_CONTAINER
#undef INPUT_TURING

#undef MODE_SPLIT
#undef MODE_DISTRIBUTE
