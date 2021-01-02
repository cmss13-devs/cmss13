#define PROGRAM_MEMORY 			1
#define PROGRAM_BOX 			2
#define OUTPUT_TO_CONTAINER		0
#define OUTPUT_TO_SMARTFRIDGE	1
#define OUTPUT_TO_CENTRIFUGE	2

/obj/structure/machinery/autodispenser
	name = "Turing Dispenser"
	desc = "A chem dispenser variant that can not be operated manually, but will instead automatically dispense chemicals based on a program of chemicals, loaded using a vial box. Despite having a digital screen the machine is mostly analog."
	icon = 'icons/obj/structures/machinery/science_machines.dmi'
	icon_state = "autodispenser_empty_open"
	active_power_usage = 40
	layer = BELOW_OBJ_LAYER
	density = 1

	var/obj/item/storage/fancy/vials/input_container //Contains vials for our program
	var/obj/item/reagent_container/glass/output_container //Our output beaker
	var/obj/structure/machinery/smartfridge/chemistry/linked_storage //Where we take chemicals from

	var/list/list/programs = list(list(),list()) //the program of chem datums to dispense, 1 = memory, 2 = box
	var/list/program_amount = list(list(),list()) //how much to dispense with each program item, 1 = memory, 2 = box
	var/program = PROGRAM_BOX
	var/multiplier = 1
	var/energy = 100
	var/max_energy = 100
	var/recharge_delay = 0
	var/cycle_limit = 1 //
	var/cycle = 0
	var/stage = 1 //Remember where we are
	var/stage_missing = 0 //How much we have left to dispense, if we didn't have enough
	var/status = 0 //0 = idle, <0 = stuck, 1 = finished, 2 = running
	var/error //Error status message
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

/obj/structure/machinery/autodispenser/proc/connect_storage()
	if(linked_storage)
		return
	linked_storage = locate(/obj/structure/machinery/smartfridge/chemistry) in range(smartfridge_tether_range, src)
	if(linked_storage)
		RegisterSignal(linked_storage, COMSIG_PARENT_QDELETING, .proc/cleanup)

/obj/structure/machinery/autodispenser/attackby(obj/item/B, mob/living/user)
	if(!skillcheck(user, SKILL_RESEARCH, SKILL_RESEARCH_TRAINED))
		to_chat(user, SPAN_WARNING("You have no idea how to use this."))
		return
	if(istype(B, /obj/item/storage/fancy/vials))
		if(input_container)
			to_chat(user, SPAN_WARNING("A vial box is already loaded into the [src]."))
			return
		else if(status == 2)
			to_chat(user, SPAN_WARNING("You can't insert a box while the [src] is running."))
			return
		if(user.drop_inv_item_to_loc(B, src))
			input_container = B
			if(output_container)
				if(!automode)
					icon_state = "autodispenser_idle"
			else
				icon_state = "autodispenser_empty_closed"
		get_program()
	else if(B.is_open_container() || B.flags_atom & CAN_BE_DISPENSED_INTO)
		if(output_container)
			to_chat(user, SPAN_WARNING("A container is already loaded into the [src]."))
			return
		if(user.drop_inv_item_to_loc(B, src))
			output_container = B
			if(input_container)
				if(!automode)
					icon_state = "autodispenser_idle"
			else
				icon_state = "autodispenser_full_open"
	else
		to_chat(user, SPAN_WARNING("[B] doesn't fit in the [src]."))
		return
	to_chat(user, SPAN_NOTICE("You insert [B] into the [src]."))
	if(input_container && output_container && outputmode == OUTPUT_TO_CONTAINER)
		if(automode)
			run_program()
	nanomanager.update_uis(src) // update all UIs attached to src

/obj/structure/machinery/autodispenser/attack_hand(mob/user as mob)
	if(inoperable())
		return
	if(!skillcheck(user, SKILL_RESEARCH, SKILL_RESEARCH_TRAINED))
		to_chat(user, SPAN_WARNING("You have no idea how to use this."))
		return
	ui_interact(user)

/obj/structure/machinery/autodispenser/ui_interact(mob/user, ui_key = "main",var/datum/nanoui/ui = null, var/force_open = 0)
	var/list/data = list(
		"status" = status,
		"energy" = energy,
		"status" = status,
		"error" = error,
		"multiplier" = multiplier,
		"cycle_limit" = cycle_limit,
		"automode" = automode,
		"linked_storage" = linked_storage,
		"networked_storage" = linked_storage.is_in_network(),
		"smartlink" = smartlink,
		"outputmode" = outputmode,
		"buffervolume" = reagents.total_volume,
		"buffermax" = buffer_size
	)
	if(output_container)
		data["output_container"] = list(
			"name" = output_container.name,
			"total" = output_container.reagents.total_volume,
			"max" = output_container.reagents.maximum_volume
		)
	if(input_container)
		data["input_container"] = input_container.name
	if(program_amount[PROGRAM_MEMORY])
		data["memory"] = program_amount[PROGRAM_MEMORY]
	if(program_amount[PROGRAM_BOX])
		data["box"] = program_amount[PROGRAM_BOX]

	ui = nanomanager.try_update_ui(user, src, ui_key, ui, data, force_open)
	if(!ui)
		ui = new(user, src, ui_key, "autodispenser.tmpl", "Turing Dispenser Console", 600, 480)
		ui.set_initial_data(data)
		ui.open()

/obj/structure/machinery/autodispenser/Topic(href, href_list)
	. = ..()
	if(.)
		return
	if(inoperable() || !ishuman(usr))
		return
	var/mob/living/carbon/human/user = usr
	if(user.stat || user.is_mob_restrained() || !in_range(src, user))
		return

	if(href_list["ejectI"])
		if(input_container)
			input_container.forceMove(loc)
			input_container = null
		programs[PROGRAM_BOX] = list()
		program_amount[PROGRAM_BOX] = list()
		stop_program()
	else if(href_list["ejectO"])
		if(output_container)
			output_container.forceMove(loc)
			output_container = null
		stop_program()
	else if(href_list["runprogram"])
		if(outputmode != OUTPUT_TO_CENTRIFUGE)
			run_program()
	else if(href_list["saveprogram"])
		get_program(PROGRAM_MEMORY)
	else if(href_list["clearmemory"])
		programs[PROGRAM_MEMORY] = list()
		program_amount[PROGRAM_MEMORY] = list()
		program = PROGRAM_BOX
		stop_program()
	else if(href_list["dispose"])
		output_container.reagents.clear_reagents()
	else if(href_list["setmulti"])
		var/list/multipliers = list(0.5,1,2,3,4,5,6,10)
		var/M = input("Set multiplier:","[src]") as null|anything in multipliers
		if(M)
			multiplier = M
	else if(href_list["setcycle"])
		var/L = input("Set cycle limit:","[src]") as num
		if(L)
			cycle_limit = L
	else if(href_list["toggleauto"])
		automode = !automode
	else if(href_list["togglesmart"])
		smartlink = !smartlink
	else if(href_list["toggleoutput"])
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

	nanomanager.update_uis(src) // update all UIs attached to src
	add_fingerprint(user)
	attack_hand(usr)
	return 1

/obj/structure/machinery/autodispenser/process()
	if(inoperable())
		return
	//We're always recharging
	if(energy < max_energy)
		if(recharge_delay <= 0)
			recharge()
		else
			recharge_delay--
		nanomanager.update_uis(src)

	if(status == 0 || status == 1) //Nothing to do
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
		stop_program(1)
		icon_state = "autodispenser_full"
		nanomanager.update_uis(src)
		return

	for(var/i=stage,i<=programs[1].len + programs[2].len && i != 0,i++)
		if(status < 0) //We're waiting for new chems to be stored
			status++
			if(status == 0)
				status = 2
				icon_state = "autodispenser_running"
				nanomanager.update_uis(src)
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
						linked_storage.item_quants[C.name]--
						qdel(C) //Might want to connect it to a disposal system later instead

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
			icon_state = "autodispenser_stuck"
			error = R.name + " NOT FOUND"
			status = -5
			nanomanager.update_uis(src)
		else //We can dispense any basic or common chemical directly. This does use energy as we're creating stuff from thin air
			//Check if we have enough energy to afford dispensing
			var/savings = energy - amount * 0.1
			if(savings < 0) //Check if we can afford dispensing the chemical
				break
			container.reagents.add_reagent(R.id,amount)
			energy = savings
			stage_missing = 0
			next_stage()

/obj/structure/machinery/autodispenser/proc/get_program(var/save_to = PROGRAM_BOX)
	for(var/obj/item/reagent_container/glass/beaker/vial/V in input_container.contents)
		if(!V.reagents.get_reagents()) //Ignore empty vials
			continue
		if(V.reagents.reagent_list.len > 1) //We don't work with impure vials
			continue
		var/datum/reagent/R = V.reagents.reagent_list[1]
		if(program_amount[save_to]["[R.name]"])
			program_amount[save_to]["[R.name]"] += V.reagents.total_volume
		else
			programs[save_to] += R
			var/list/L[0]
			L["[R.name]"] = V.reagents.total_volume
			program_amount[save_to] += L

/obj/structure/machinery/autodispenser/proc/recharge()
	energy = min(energy + 10, max_energy)
	recharge_delay = 10 //a 3rd faster than the manual dispenser
	use_power(1500)

/obj/structure/machinery/autodispenser/proc/run_program()
	if(programs[PROGRAM_MEMORY].len)
		program = PROGRAM_MEMORY
	else
		program = PROGRAM_BOX
	if(programs[program].len && (outputmode == OUTPUT_TO_CONTAINER && output_container) || outputmode != OUTPUT_TO_CONTAINER)
		status = 2
		icon_state = "autodispenser_running"
	else
		stop_program()

/obj/structure/machinery/autodispenser/proc/next_stage()
	stage++
	if(stage > programs[program].len) //End of program
		if(programs[PROGRAM_MEMORY].len && programs[PROGRAM_BOX].len)
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


/obj/structure/machinery/autodispenser/proc/stop_program(var/set_status = 0)
	stage = 1
	cycle = 0
	stage_missing = 0
	error = 0
	status = set_status

	if(outputmode == OUTPUT_TO_SMARTFRIDGE)
		flush_buffer()

	if(input_container && output_container)
		icon_state = "autodispenser_idle"
	else if(input_container && !output_container)
		icon_state = "autodispenser_empty_closed"
	else if(output_container && !input_container)
		icon_state = "autodispenser_full_open"
	else
		icon_state = "autodispenser_empty_open"

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
				linked_storage.add_item(P)



/obj/structure/machinery/autodispenser/proc/cleanup()
	SIGNAL_HANDLER
	if(linked_storage)
		linked_storage = null

#undef PROGRAM_MEMORY
#undef PROGRAM_BOX
#undef OUTPUT_TO_CONTAINER
#undef OUTPUT_TO_SMARTFRIDGE
#undef OUTPUT_TO_CENTRIFUGE
