#define PROGRAM_MEMORY 1
#define PROGRAM_BOX 2

#define OUTPUT_TO_CONTAINER	0
#define OUTPUT_TO_SMARTFRIDGE 1
#define OUTPUT_TO_CENTRIFUGE 2

#define AUTODISPENSER_STUCK -1
#define AUTODISPENSER_IDLE 0
#define AUTODISPENSER_RUNNING 1
#define AUTODISPENSER_FINISHED 2


/obj/structure/machinery/autodispenser
	name = "\improper Turing Dispenser"
	desc = "A chem dispenser variant that can not be operated manually, but will instead automatically dispense chemicals based on a program of chemicals, loaded using a vial box. Despite having a digital screen the machine is mostly analog."
	icon = 'icons/obj/structures/machinery/science_machines.dmi'
	icon_state = "autodispenser"
	active_power_usage = 40
	health = STRUCTURE_HEALTH_REINFORCED
	layer = BELOW_OBJ_LAYER
	density = TRUE
	///Contains vials for our program
	var/obj/item/storage/fancy/vials/input_container
	///Our output beaker
	var/obj/item/reagent_container/glass/output_container
	///Where we take chemicals from
	var/obj/structure/machinery/smartfridge/chemistry/linked_storage

	///the program of chem datums to dispense, 1 = memory, 2 = box
	var/list/list/programs = list(list(),list())
	///how much to dispense with each program item, 1 = memory, 2 = box
	var/list/program_amount = list(list(),list())
	/// snowflake list for tgui, 1 = memory, 2 = box
	var/list/tgui_friendly_program_list = list(list(),list())
	var/program = PROGRAM_BOX
	var/multiplier = 1
	var/energy = 100
	var/max_energy = 100
	var/recharge_delay = 0
	var/cycle_limit = 1
	var/cycle = 0
	///Remember where we are
	var/stage = 1
	///How much we have left to dispense, if we didn't have enough
	var/stage_missing = 0
	///0 = idle, <0 = stuck, 1 = running, 2 = finished
	var/status = AUTODISPENSER_IDLE
	///Error status message
	var/error
	var/automode = FALSE
	var/smartlink = TRUE
	var/outputmode = OUTPUT_TO_CONTAINER
	var/centrifuge_tether_range = 20
	var/smartfridge_tether_range = 3
	var/buffer_size = 1080 // 180 * 6

/obj/structure/machinery/autodispenser/Initialize()
	. = ..()
	create_reagents(buffer_size) // Inner buffer.
	connect_storage()
	start_processing()

/obj/structure/machinery/autodispenser/Destroy()
	cleanup()
	. = ..()

/obj/structure/machinery/autodispenser/update_icon()
	overlays.Cut()
	if(!input_container)
		overlays += "+open"
	if(output_container)
		overlays += "+autodispenser_beaker"

	if(stat & NOPOWER)
		icon_state = "autodispenser_nopower"
		return // do not show state info
	else if(stat & BROKEN)
		icon_state = "autodispenser_broken"
		return
	else
		icon_state = "autodispenser"

	if(status < AUTODISPENSER_IDLE)
		overlays += "+stuck"
	else if(status == AUTODISPENSER_RUNNING)
		overlays += "+running"
	else if(status == AUTODISPENSER_FINISHED)
		overlays += "+full"

/obj/structure/machinery/autodispenser/proc/connect_storage()
	if(linked_storage)
		return
	linked_storage = locate(/obj/structure/machinery/smartfridge/chemistry) in range(smartfridge_tether_range, src)
	if(linked_storage)
		RegisterSignal(linked_storage, COMSIG_PARENT_QDELETING, PROC_REF(cleanup))

/obj/structure/machinery/autodispenser/attackby(obj/item/B, mob/living/user)
	if(!skillcheck(user, SKILL_RESEARCH, SKILL_RESEARCH_TRAINED))
		to_chat(user, SPAN_WARNING("You have no idea how to use this."))
		return
	if(istype(B, /obj/item/storage/fancy/vials))
		if(input_container)
			to_chat(user, SPAN_WARNING("A vial box is already loaded into \the [src]."))
			return
		else if(status == AUTODISPENSER_RUNNING)
			to_chat(user, SPAN_WARNING("You can't insert a box while \the [src] is running."))
			return
		if(user.drop_inv_item_to_loc(B, src))
			input_container = B
			update_icon()
		get_program(PROGRAM_BOX)
	else if(B.is_open_container() || B.flags_atom & CAN_BE_DISPENSED_INTO)
		if(output_container)
			to_chat(user, SPAN_WARNING("A container is already loaded into \the [src]."))
			return
		if(user.drop_inv_item_to_loc(B, src))
			output_container = B
			update_icon()
	else
		to_chat(user, SPAN_WARNING("[B] doesn't fit in \the [src]."))
		return
	to_chat(user, SPAN_NOTICE("You insert [B] into \the [src]."))
	if(input_container && output_container && outputmode == OUTPUT_TO_CONTAINER)
		if(automode)
			run_program()

/obj/structure/machinery/autodispenser/attack_hand(mob/user as mob)
	if(inoperable())
		return
	if(!skillcheck(user, SKILL_RESEARCH, SKILL_RESEARCH_TRAINED))
		to_chat(user, SPAN_WARNING("You have no idea how to use this."))
		return
	tgui_interact(user)

// TGUI \\

/obj/structure/machinery/autodispenser/tgui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if (!ui)
		ui = new(user, src, "Autodispenser", name)
		ui.open()

/obj/structure/machinery/autodispenser/ui_status(mob/user)
	. = ..()
	if(inoperable())
		return UI_CLOSE

/obj/structure/machinery/autodispenser/ui_data(mob/user)
	var/list/data = list()

	data["status"] = status
	data["energy"] = energy
	data["error"] = error
	data["multiplier"] = multiplier
	data["cycle_limit"] = cycle_limit
	data["automode"] = automode
	data["networked_storage"] = linked_storage?.is_in_network()
	data["smartlink"] = smartlink
	data["outputmode"] = outputmode
	data["buffervolume"] = reagents.total_volume
	data["buffermax"] = buffer_size

	if(output_container)
		data["output_container"] = output_container.name
		data["output_totalvol"] = output_container.reagents.total_volume
		data["output_maxvol"] = output_container.reagents.maximum_volume
		if(length(output_container.reagents.reagent_list))
			data["output_color"] = mix_color_from_reagents(output_container.reagents.reagent_list)
		else
			data["output_color"] = null
	else
		data["output_container"] = null
		data["output_totalvol"] = null
		data["output_maxvol"] = null
		data["output_color"] = null

	if(input_container)
		data["input_container"] = input_container.name
	else
		data["input_container"] = null

	var/list/memorylist = program_amount[PROGRAM_MEMORY]
	var/list/boxlist = program_amount[PROGRAM_BOX]

	if(length(memorylist))
		data["memory"] = tgui_friendly_program_list[PROGRAM_MEMORY]
	else
		data["memory"] = "Empty"

	if(length(boxlist))
		data["box"] = tgui_friendly_program_list[PROGRAM_BOX]
	else
		data["box"] = "Empty"

	return data

/obj/structure/machinery/autodispenser/ui_act(action, list/params, datum/tgui/ui, datum/ui_state/state)
	. = ..()
	if(.)
		return

	switch(action)
		if("ejectI")
			if(input_container)
				input_container.forceMove(loc)
				input_container = null
			programs[PROGRAM_BOX] = list()
			program_amount[PROGRAM_BOX] = list()
			tgui_friendly_program_list[PROGRAM_BOX] = list()
			stop_program()
			. = TRUE

		if("ejectO")
			if(output_container)
				output_container.forceMove(loc)
				output_container = null
			stop_program()
			. = TRUE

		if("runprogram")
			if(outputmode != OUTPUT_TO_CENTRIFUGE)
				run_program()
				. = TRUE

		if("saveprogram")
			get_program(PROGRAM_MEMORY)
			. = TRUE

		if("clearmemory")
			programs[PROGRAM_MEMORY] = list()
			program_amount[PROGRAM_MEMORY] = list()
			tgui_friendly_program_list[PROGRAM_MEMORY] = list()
			program = PROGRAM_BOX
			stop_program()
			. = TRUE

		if("dispose")
			output_container.reagents.clear_reagents()
			. = TRUE

		if("set_multiplier")
			var/new_multiplier = text2num(params["set_multiplier"])
			if(!new_multiplier)
				return
			multiplier = new_multiplier
			. = TRUE

		if("set_cycles")
			var/new_cycles = text2num(params["set_cycles"])
			if(!new_cycles)
				return
			cycle_limit = new_cycles
			. = TRUE

		if("toggleauto")
			automode = !automode
			. = TRUE

		if("togglesmart")
			smartlink = !smartlink
			. = TRUE

		if("toggleoutput")
			switch(outputmode)
				if(OUTPUT_TO_CONTAINER)
					if(linked_storage)
						outputmode = OUTPUT_TO_SMARTFRIDGE
					else if(locate(/obj/structure/machinery/centrifuge) in range(centrifuge_tether_range, src))
						outputmode = OUTPUT_TO_CENTRIFUGE
				if(OUTPUT_TO_SMARTFRIDGE)
					flush_buffer()
					if(locate(/obj/structure/machinery/centrifuge) in range(centrifuge_tether_range, src))
						outputmode = OUTPUT_TO_CENTRIFUGE
					else
						outputmode = OUTPUT_TO_CONTAINER
				if(OUTPUT_TO_CENTRIFUGE)
					flush_buffer()
					outputmode = OUTPUT_TO_CONTAINER
			. = TRUE

/obj/structure/machinery/autodispenser/process()
	if(inoperable())
		return
	//We're always recharging
	if(energy < max_energy)
		if(recharge_delay <= 0)
			recharge()
		else
			recharge_delay--

	if(status == AUTODISPENSER_IDLE || status == AUTODISPENSER_FINISHED) //Nothing to do
		return

	if(!linked_storage)
		connect_storage()

	if(QDELETED(linked_storage) || src.z != linked_storage.z || get_dist(src, linked_storage) > smartfridge_tether_range)
		visible_message(SPAN_WARNING("Smartfridge is out of range. Connection severed."))
		cleanup()

	var/obj/item/reagent_container/container = output_container
	if(outputmode != OUTPUT_TO_CONTAINER)
		container = src

	var/space = container.reagents.maximum_volume - container.reagents.total_volume
	if(!space || cycle >= cycle_limit) //We done boys
		stop_program(2)
		update_icon()
		return

	for(var/i=stage,i<=length(programs[1]) + length(programs[2]) && i != 0,i++)
		if(status < AUTODISPENSER_IDLE) //We're waiting for new chems to be stored
			status++
			if(status == AUTODISPENSER_IDLE)
				status = AUTODISPENSER_RUNNING
				update_icon()

			else
				break

		var/datum/reagent/R = programs[program][stage]
		if(!R)
			next_stage()
			continue
		var/amount
		if(stage_missing)
			amount = stage_missing
		else
			amount = min(program_amount[program]["[R.name]"] * multiplier, space)

		//Check and use stored chemicals first. This doesn't consume energy.
		if(smartlink && linked_storage)
			var/skip
			for(var/obj/item/reagent_container/C in linked_storage.contents)
				if(!C.reagents)
					continue
				var/O = C.reagents.get_reagent_amount(R.id)
				if(O)
					//Check if there's enough and note if there isn't, then transfer
					if(O < amount)
						stage_missing = amount - O
						amount = O
					else
						stage_missing = 0

					C.reagents.trans_to(container, amount)
					//We don't care about keeping empty bottles stored
					if(C.reagents.total_volume <= 0 && istypestrict(C,/obj/item/reagent_container/glass/bottle))
						linked_storage.delete_contents(C)

					if(stage_missing)
						amount = stage_missing
					else
						next_stage()
						skip = TRUE
						break
			if(skip)
				continue
		if(R.chemclass != CHEM_CLASS_BASIC && R.chemclass != CHEM_CLASS_COMMON)
			//We have to wait until the chem is stored
			error = R.name + " NOT FOUND"
			status = -5
			update_icon()

		else //We can dispense any basic or common chemical directly. This does use energy as we're creating stuff from thin air
			//Check if we have enough energy to afford dispensing
			var/savings = energy - amount * 0.1
			if(savings < 0) //Check if we can afford dispensing the chemical
				break
			container.reagents.add_reagent(R.id,amount)
			energy = savings
			stage_missing = 0
			next_stage()

/obj/structure/machinery/autodispenser/proc/get_program(save_to = PROGRAM_BOX)
	for(var/obj/item/reagent_container/glass/beaker/vial/V in input_container.contents)
		if(!V.reagents.get_reagents()) //Ignore empty vials
			continue
		if(length(V.reagents.reagent_list) > 1) //We don't work with impure vials
			continue
		var/datum/reagent/R = V.reagents.reagent_list[1]
		if(program_amount[save_to]["[R.name]"])
			program_amount[save_to]["[R.name]"] += V.reagents.total_volume
			tgui_friendly_program_list[save_to]["[R.name]"]["amount"] += V.reagents.total_volume
		else
			programs[save_to] += R
			var/list/L[0]
			L["[R.name]"] = V.reagents.total_volume
			program_amount[save_to] += L
			tgui_friendly_program_list[save_to]["[R.name]"] += list("name" = R.name, "amount" = V.reagents.total_volume)

/obj/structure/machinery/autodispenser/proc/recharge()
	energy = min(energy + 10, max_energy)
	recharge_delay = 10 //a 3rd faster than the manual dispenser
	use_power(1500)

/obj/structure/machinery/autodispenser/proc/run_program()
	if(length(programs[PROGRAM_MEMORY]))
		program = PROGRAM_MEMORY
	else
		program = PROGRAM_BOX
	if(length(programs[program]) && (outputmode == OUTPUT_TO_CONTAINER && output_container) || outputmode != OUTPUT_TO_CONTAINER)
		status = AUTODISPENSER_RUNNING
		update_icon()
	else
		stop_program()

/obj/structure/machinery/autodispenser/proc/next_stage()
	stage++
	if(stage > length(programs[program])) //End of program
		if(length(programs[PROGRAM_MEMORY]) && length(programs[PROGRAM_BOX]))
			if(program == PROGRAM_BOX)
				cycle++
				program--
			else
				program++
		else
			cycle++
		stage = 1
		if(outputmode == OUTPUT_TO_SMARTFRIDGE)
			flush_buffer()


/obj/structure/machinery/autodispenser/proc/stop_program(set_status = AUTODISPENSER_IDLE)
	stage = 1
	cycle = 0
	stage_missing = 0
	error = 0
	status = set_status

	if(outputmode == OUTPUT_TO_SMARTFRIDGE)
		flush_buffer()

	update_icon()

/obj/structure/machinery/autodispenser/proc/flush_buffer()
	if(reagents.total_volume > 0)
		if(!linked_storage)
			reagents.clear_reagents()
			return

		var/name = reagents.get_master_reagent_name()
		var/obj/item/reagent_container/glass/P
		while(reagents.total_volume > 0)
			P = new /obj/item/reagent_container/glass/bottle()
			P.name = "[name] bottle"
			P.icon_state = "bottle-1" // Default bottle
			P.amount_per_transfer_from_this = 60
			reagents.trans_to(P, 60)
			if(!linked_storage.add_network_item(P)) // Prefer network to avoid recursion (create bottle, then consume from bottle)
				linked_storage.add_local_item(P)



/obj/structure/machinery/autodispenser/proc/cleanup()
	SIGNAL_HANDLER
	if(linked_storage)
		linked_storage = null

#undef PROGRAM_MEMORY
#undef PROGRAM_BOX
#undef OUTPUT_TO_CONTAINER
#undef OUTPUT_TO_SMARTFRIDGE
#undef OUTPUT_TO_CENTRIFUGE
#undef AUTODISPENSER_STUCK
#undef AUTODISPENSER_IDLE
#undef AUTODISPENSER_RUNNING
#undef AUTODISPENSER_FINISHED
