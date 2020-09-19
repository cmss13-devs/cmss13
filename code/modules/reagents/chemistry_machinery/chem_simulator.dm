#define MODE_AMPLIFY 			1
#define MODE_SUPPRESS 			2
#define MODE_RELATE				3

/obj/structure/machinery/chem_simulator
	name = "Synthesis Simulator"
	desc = "This computer uses advanced algorithms to perform simulations of reagent properties, for the purpose of calculating the synthesis required to make a new variant."
	icon = 'icons/obj/structures/machinery/science_machines_64x32.dmi'
	icon_state = "modifier"
	active_power_usage = 1000
	layer = BELOW_OBJ_LAYER
	density = 1
	bound_x = 32

	var/obj/item/paper/research_report/target
	var/obj/item/paper/research_report/reference
	var/list/simulations = list()

	var/mode = MODE_AMPLIFY
	var/datum/chem_property/target_property
	var/datum/chem_property/reference_property
	var/list/property_costs = list()
	var/simulating = 0
	var/status_bar = "READY"
	var/ready = FALSE

/obj/structure/machinery/chem_simulator/power_change()
	..()
	if(inoperable())
		icon_state = "modifier_off"
	nanomanager.update_uis(src) // update all UIs attached to src

/obj/structure/machinery/chem_simulator/attackby(obj/item/B, mob/living/user)
	if(!skillcheck(user, SKILL_RESEARCH, SKILL_RESEARCH_TRAINED))
		to_chat(user, SPAN_WARNING("You have no idea how to use this."))
		return
	if(istype(B, /obj/item/paper/research_notes))
		var/obj/item/paper/research_notes/N = B
		if(!target || (mode == MODE_RELATE && !reference))
			B = N.convert_to_chem_report()
		else
			to_chat(user, SPAN_WARNING("Chemical data already inserted."))
			return
	if(istype(B, /obj/item/paper/research_report))
		if(!target)
			target = B
			ready = check_ready()
		else if(mode == MODE_RELATE && !reference)
			target_property = ""
			reference = B
			ready = check_ready()
		else
			to_chat(user, SPAN_WARNING("Chemical data already inserted."))
			return
	else 
		to_chat(user, SPAN_WARNING("The [src] refuses the [B]."))
		return
	user.drop_inv_item_to_loc(B, src)
	to_chat(user, SPAN_NOTICE("You insert [B] into the [src]."))
	flick("[icon_state]_reading",src)
	update_costs()
	nanomanager.update_uis(src) // update all UIs attached to src

/obj/structure/machinery/chem_simulator/attack_hand(mob/user as mob)
	if(inoperable())
		return
	if(!skillcheck(user, SKILL_RESEARCH, SKILL_RESEARCH_TRAINED))
		to_chat(user, SPAN_WARNING("You have no idea how to use this."))
		return
	ui_interact(user)

/obj/structure/machinery/chem_simulator/ui_interact(mob/user, ui_key = "main", var/datum/nanoui/ui = null, var/force_open = 0)
	var/list/data = list(
		"rsc_credits" = chemical_data.rsc_credits,
		"target" = target,
		"reference" = reference,
		"mode" = mode,
		"property_costs" = property_costs,
		"simulating" = simulating,
		"status_bar" = status_bar,
		"ready" = ready,
		"simulating" = simulating,
		"property_codings" = list()
	)
	if(target && target.data && target.completed)
		data["target_property_list"] = target.data.properties_to_assoc()
		for(var/datum/chem_property/P in target.data.properties)
			data["property_codings"][P.name] = P.code
	if(reference && reference.data && reference.completed)
		data["reference_property_list"] = reference.data.properties_to_assoc()
		for(var/datum/chem_property/P in reference.data.properties)
			data["property_codings"][P.name] = P.code
	if(target_property)
		data["target_property"] = target_property.name
		data["target_info"] = target_property.description
		data["target_categories"] = target_property.categories_to_string()
	else
		data["target_info"] = ""
	if(reference_property)
		data["reference_property"] = reference_property.name
		data["reference_info"] = reference_property.description
		data["reference_categories"] = reference_property.categories_to_string()
	else
		data["reference_info"] = ""
	ui = nanomanager.try_update_ui(user, src, ui_key, ui, data, force_open)
	if(!ui)
		ui = new(user, src, ui_key, "chem_simulator.tmpl", "Synthesis Simulator", 800, 480)
		ui.set_initial_data(data)
		ui.open()

/obj/structure/machinery/chem_simulator/Topic(href, href_list)
	if(inoperable() || !ishuman(usr))
		return
	var/mob/living/carbon/human/user = usr
	if(user.stat || user.is_mob_restrained() || !in_range(src, user))
		return

	if(href_list["simulate"])
		simulating = 5
		status_bar = "COMMENCING SIMULATION"
		icon_state = "modifier_running"
		start_processing()
	else if(href_list["ejectT"])
		if(target)
			if(!user.put_in_active_hand(target))
				target.forceMove(loc)
			target = null
		target_property = null
		stop_processing()
		simulating = 0
		flick("[icon_state]_printing",src)
	else if(href_list["ejectR"])
		if(reference)
			if(!user.put_in_active_hand(reference))
				reference.forceMove(loc)
			reference = null
		reference_property = null
		stop_processing()
		simulating = 0
		flick("[icon_state]_printing",src)
	else if(href_list["set_mode"])
		switch(href_list["set_mode"])
			if("amp")
				mode = MODE_AMPLIFY
			if("sup")
				mode = MODE_SUPPRESS
			if("rel")
				mode = MODE_RELATE
		update_costs()
	else if(href_list["set_target"])
		target_property = target.data.get_property(href_list["set_target"])
		if(simulating)
			stop_processing()
			icon_state = "modifier"
			simulating = 0
	else if(href_list["set_reference"])
		reference_property = reference.data.get_property(href_list["set_reference"])
		if(simulating)
			stop_processing()
			icon_state = "modifier"
			simulating = 0
		update_costs()
	else if(href_list["stop_simulation"])
		stop_processing()
		icon_state = "modifier"
		simulating = 0
	ready = check_ready()
	playsound(loc, pick('sound/machines/computer_typing1.ogg','sound/machines/computer_typing2.ogg','sound/machines/computer_typing3.ogg'), 5, 1)
	nanomanager.update_uis(src)

/obj/structure/machinery/chem_simulator/process()
	if(inoperable())
		return
	if(simulating)
		simulating--
		switch(simulating)
			if(4)
				status_bar = pick("SIMULATING HUMANS","SIMULATING MONKEYS","SIMULATING BODILY FUNCTIONS","MEASURING PROPERTIES","INJECTING VIRTUAL HUMANS","TORTURING DIGITAL MONKEYS","EMULATING METABOLISM")
			if(3)
				status_bar = pick("SEARCHING FOR CHIMPANZEES","PLAYING CHESS WITH ARES","CONSULTING DOC","BLAMING GOD","SEARCHING FOR MY PURPOSE","SPYING ON JONES","DIVIDING BY NULL","EQUATING SPACE TIME")
			if(2)
				status_bar = pick("PREDICTING REACTION PATTERNS","CALCULATING OVERDOSE RATIOS","CALCULATING SYNTHESIS","CLOSING THE EVENTUALITY","COMPUTING REAGENT INTERPRETATIONS",)
			if(1)
				icon_state = "modifier"
				switch(mode)
					if(MODE_AMPLIFY)
						amplify()
					if(MODE_SUPPRESS)
						suppress()
					if(MODE_RELATE)
						relate()
				status_bar = "SIMULATION COMPLETED"
			else
				simulating = 0
				ready = check_ready()
	else
		stop_processing()	
	nanomanager.update_uis(src)

/obj/structure/machinery/chem_simulator/proc/update_costs()
	property_costs = list()
	var/only_positive = TRUE
	if(target && target.data && target.completed)
		for(var/datum/chem_property/P in target.data.properties)
			if(!isPositiveProperty(P))
				only_positive = FALSE
			if(P.category & PROPERTY_TYPE_ANOMALOUS)
				property_costs[P.name] = P.level * 10
				continue
			switch(mode)
				if(MODE_AMPLIFY)
					property_costs[P.name] = max(min(P.level - 1, 5), 1)
				if(MODE_SUPPRESS)
					property_costs[P.name] = 2
				if(MODE_RELATE)
					if(reference_property)
						if(reference_property.category & PROPERTY_TYPE_ANOMALOUS)
							property_costs[P.name] = P.level * 10
						else if(reference_property.rarity < PROPERTY_RARE)
							property_costs[P.name] = P.level
						else
							property_costs[P.name] = P.level * 3
					else
						property_costs[P.name] = P.level * 1
		if(only_positive)
			for(var/P in property_costs)
				property_costs[P] = property_costs[P] + 1

/obj/structure/machinery/chem_simulator/proc/check_ready()
	if(target)
		if(!target.completed)
			status_bar = "INCOMPLETE DATA DETECTED IN TARGET"
			return FALSE
		if(!target.data)
			status_bar = "DATA CORRUPTION DETECTED, RESCAN CHEMICAL"
			return FALSE
		if(target.data.chemclass < CHEM_CLASS_COMMON)
			status_bar = "TARGET CAN NOT BE ALTERED"
			return FALSE
		//Safety check in case of irregular papers
		var/datum/chemical_reaction/C = chemical_reactions_list[target.data.id]
		if(C)
			for(var/component in C.required_reagents)
				var/datum/reagent/R = chemical_reagents_list[component]
				if(R && R.chemclass >= CHEM_CLASS_SPECIAL && !chemical_identified_list[R.id])
					status_bar = "UNREGISTERED COMPONENTS DETECTED"
					return FALSE
			for(var/catalyst in C.required_catalysts)
				var/datum/reagent/R = chemical_reagents_list[catalyst]
				if(R && R.chemclass >= CHEM_CLASS_SPECIAL && !chemical_identified_list[R.id])
					status_bar = "UNREGISTERED CATALYSTS DETECTED"
					return FALSE
		if(target_property)
			if(property_costs[target_property.name] > chemical_data.rsc_credits)
				status_bar = "INSUFFICIENT FUNDS"
				return FALSE
			if(target_property.category & PROPERTY_TYPE_UNADJUSTABLE)
				status_bar = "TARGET PROPERTY CAN NOT BE SIMULATED"
				return FALSE
	if(mode == MODE_RELATE)
		if(target && target.data.properties.len < 2)
			status_bar = "TARGET COMPLEXITY IMPROPER FOR RELATION"
			return FALSE
		if(reference && target)
			if(!reference.completed)
				status_bar = "INCOMPLETE DATA DETECTED IN REFERENCE"
				return FALSE
			if(reference_property)
				if(target.data.get_property(reference_property.name))
					status_bar = "REFERENCE PROPERTY ALREADY IN TARGET"
					return FALSE
				if(target_property)
					if(target_property.level != reference_property.level)
						status_bar = "REFERENCE AND TARGET PROPERTY MUST BE OF EQUAL LEVELS"
						return FALSE
					if(reference_property.category & PROPERTY_TYPE_UNADJUSTABLE)
						status_bar = "REFERENCE PROPERTY CAN NOT BE SIMULATED"
						return FALSE
	status_bar = "READY"
	return TRUE

/obj/structure/machinery/chem_simulator/proc/print(var/id, var/is_new)
	playsound(loc, 'sound/machines/fax.ogg', 15, 1)
	flick("[icon_state]_printing",src)
	sleep(10)
	var/obj/item/paper/research_report/report = new /obj/item/paper/research_report/(loc)
	var/datum/reagent/D = chemical_reagents_list[id]
	report.name = "Simulation result for [D.name]"
	report.info += "<center><img src = wylogo.png><HR><I><B>Official Company Document</B><BR>Simulated Synthesis Report</I><HR><H2>Result for [D.name]</H2></center>"
	report.generate(D)
	report.info += "<BR><HR><font size = \"1\"><I>This report was automatically printed by the Synthesis Simulator.<BR>The USS Almayer, [time2text(world.timeofday, "MM/DD")]/[game_year], [worldtime2text()]</I></font><BR>\n<span class=\"paper_field\"></span>"
	playsound(loc, 'sound/machines/twobeep.ogg', 15, 1)
	if(is_new)
		chemical_data.save_document(report, "Synthesis Simulations", report.name)

/obj/structure/machinery/chem_simulator/proc/encode_reagent(var/datum/reagent/C)
	var/datum/reagent/O = chemical_reagents_list[C.original_id] //So make the new name based on the Original
	var/suffix = " "
	for(var/datum/chem_property/P in C.properties)
		var/datum/chem_property/OP = O.get_property(P.name)
		if(OP) //if the original has the property	
			if(P.level != OP.level)//This property was amplified or suppressed
				suffix += P.code + "[P.level]"
		else //This property was added through relation
			suffix += P.code + "[P.level]"
	return O.name + suffix

/obj/structure/machinery/chem_simulator/proc/amplify()
	if(!target || !target_property)
		return
	var/datum/reagent/generated/C = new /datum/reagent/generated
	C.make_alike(target.data)
	//Change the reagent
	C.relevel_property(target_property.name, target_property.level + 1)
	if(isPositiveProperty(target_property))
		if(C.overdose <= 5)
			C.overdose = max(C.overdose - 1,1)
		else
			C.overdose = max(5, C.overdose - 5)
		C.overdose_critical = max(10, C.overdose_critical - 5)
	else if(isNegativeProperty(target_property))
		C.overdose += 5
		C.overdose_critical += 5
	end_simulation(C)

/obj/structure/machinery/chem_simulator/proc/suppress()
	if(!target || !target_property)
		return
	var/datum/reagent/generated/C = new /datum/reagent/generated
	C.make_alike(target.data)
	//Change the reagent
	C.relevel_property(target_property.name, max(target_property.level - 1, 0))
	if(isPositiveProperty(target_property))
		C.overdose += 5
		C.overdose_critical += 5
	else if(isNegativeProperty(target_property))
		if(C.overdose <= 5)
			C.overdose = max(C.overdose - 1,1)
		else
			C.overdose = max(5, C.overdose - 5)
		C.overdose_critical = max(10, C.overdose_critical - 5)
	end_simulation(C)

/obj/structure/machinery/chem_simulator/proc/relate()
	if(!target || !reference || !target_property || !reference_property)
		return
	var/datum/reagent/generated/C = new /datum/reagent/generated
	C.make_alike(target.data)
	//Override the target with the reference
	C.remove_property(target_property.name)
	C.insert_property(reference_property.name, reference_property.level)
	if(isPositiveProperty(reference_property))
		if(C.overdose <= 5)
			C.overdose = max(C.overdose - 1,1)
		else
			C.overdose = max(5, C.overdose - 5)
		C.overdose_critical = max(10, C.overdose_critical - 5)
	else if(isNegativeProperty(reference_property))
		C.overdose += 5
		C.overdose_critical += 5
	end_simulation(C)

/obj/structure/machinery/chem_simulator/proc/end_simulation(var/datum/reagent/C)
	if(!C.original_id)
		C.original_id = target.data.id
	C.name = encode_reagent(C)
	C.id = C.name
	if(C.id in simulations)
		//We've already simulated this before, so we don't need to continue
		C = chemical_reagents_list[C.id]
		print(C.id)
		return
	if(C.overdose < 1) //to prevent chems that start at 0 OD to become un-OD-able
		C.overdose = 1
	simulations += C.id //Remember we've simulated this
	chemical_data.update_credits(property_costs[target_property.name] * -1) //Pay
	//Determined rarity of new components
	C.gen_tier = max(min(C.chemclass, CHEM_CLASS_COMMON),C.gen_tier,1)
	if(C.chemclass == CHEM_CLASS_SPECIAL)
		C.gen_tier = 4
	//Change a single component of the reaction
	var/datum/chemical_reaction/generated/R = new /datum/chemical_reaction/generated
	var/datum/chemical_reaction/generated/assoc_R = chemical_reactions_list[target.data.id]
	if(!assoc_R)
		assoc_R = C.generate_assoc_recipe()
	R.make_alike(assoc_R)
	R.gen_tier = C.gen_tier
	var/list/old_reaction = R.required_reagents.Copy()
	if(R.required_reagents.len > 2) //we only replace if the recipe isn't small
		R.required_reagents -= pick(R.required_reagents)
	for(var/i = 0, i <= 5, i++)
		var/datum/reagent/new_component = chemical_reagents_list[R.add_component()]
		//Make sure we don't have an identical reaction and that the component is identified
		if(R.check_duplicate() || new_component.chemclass >= CHEM_CLASS_SPECIAL)
			R.required_reagents = old_reaction.Copy()
			if(R.required_reagents.len > 2)
				R.required_reagents -= pick(R.required_reagents)
			if(i >= 5)
				//Elevate the reaction to a higher order
				R.add_component()
				old_reaction = R.required_reagents.Copy()
				i = 0
			continue
		break
	//Save the reagent
	C.generate_description()
	C.chemclass = CHEM_CLASS_RARE //So that we can always scan this in the future, don't generate defcon, and don't get a loop of making credits
	chemical_reagents_list[C.id] = C
	//Save the reaction
	R.id = C.id
	R.result = C.id
	chemical_reactions_list[R.id] = R
	var/filter_id = R.get_filter()
	if(filter_id)
		chemical_reactions_filtered_list[filter_id] += R
	print(C.id, TRUE)

#undef MODE_AMPLIFY
#undef MODE_SUPPRESS
#undef MODE_RELATE