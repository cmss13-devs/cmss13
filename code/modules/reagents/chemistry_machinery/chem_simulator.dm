#define MODE_AMPLIFY 			1
#define MODE_SUPPRESS 			2
#define MODE_RELATE				3

/obj/structure/machinery/chem_simulator
	name = "Synthesis Simulator"
	desc = "This computer uses advanced algorithms to perform simulations of reagent properties, for the purpose of calculating the synthesis required to make a new variant."
	icon = 'icons/obj/structures/machinery/chemical_machines_64x32.dmi'
	icon_state = "modifier"
	active_power_usage = 1000
	layer = BELOW_OBJ_LAYER
	density = 1
	bound_x = 32

	var/obj/item/paper/chem_report/target
	var/obj/item/paper/chem_report/reference
	var/list/simulations = list()
	var/list/dictionary = list("negative","neutral","positive","all")
	var/list/property_codings = list(
		//Negative
		PROPERTY_HYPOXEMIC = "HPX", 		PROPERTY_TOXIC = "TXC", 			PROPERTY_CORROSIVE = "CRS", 		PROPERTY_BIOCIDIC = "BCD", 			PROPERTY_HEMOLYTIC = "HML",\
		PROPERTY_HEMORRAGING = "HMR",		PROPERTY_CARCINOGENIC = "CRG", 		PROPERTY_HEPATOTOXIC = "HPT", 		PROPERTY_NEPHROTOXIC = "NPT", 		PROPERTY_PNEUMOTOXIC = "PNT",\
		PROPERTY_OCULOTOXIC = "OCT", 		PROPERTY_CARDIOTOXIC = "CDT",		PROPERTY_NEUROTOXIC = "NRT", 		PROPERTY_EMBRYONIC = "MYO", 		PROPERTY_TRANSFORMING = "TRF",\
		PROPERTY_RAVENING = "RAV",		
		//Neutral
		PROPERTY_NUTRITIOUS = "NTR", 		PROPERTY_KETOGENIC = "KTG", 		PROPERTY_PAINING = "PNG", 			PROPERTY_NEUROINHIBITING = "NIH", 		PROPERTY_ALCOHOLIC = "AOL",\
		PROPERTY_HALLUCINOGENIC = "HLG",	PROPERTY_RELAXING = "RLX", 			PROPERTY_HYPERTHERMIC = "HPR",		PROPERTY_HYPOTHERMIC = "HPO", 		PROPERTY_BALDING = "BLD",\
		PROPERTY_FLUFFING = "FLF", 			PROPERTY_ALLERGENIC = "ALG",		PROPERTY_CRYOMETABOLIZING = "CMB", 	PROPERTY_EUPHORIC = "EPH",			PROPERTY_EMETIC = "EME",\
		PROPERTY_PSYCHOSTIMULATING = "PST",	PROPERTY_ANTIHALLUCINOGENIC = "AHL",PROPERTY_CROSSMETABOLIZING = "XMB",
		//Positive
		PROPERTY_ANTITOXIC = "ATX", 		PROPERTY_ANTICORROSIVE = "ACR", 	PROPERTY_NEOGENETIC = "NGN", 		PROPERTY_REPAIRING = "REP", 		PROPERTY_HEMOGENIC = "HMG",\
		PROPERTY_NERVESTIMULATING = "NST", 	PROPERTY_MUSCLESTIMULATING = "MST",	PROPERTY_PAINKILLING = "PNK",		PROPERTY_HEPATOPEUTIC = "HPP", 		PROPERTY_NEPHROPEUTIC = "NPP",\
		PROPERTY_PNEUMOPEUTIC = "PNP", 		PROPERTY_OCULOPEUTIC = "OCP", 		PROPERTY_CARDIOPEUTIC = "CDP", 		PROPERTY_NEUROPEUTIC = "NRP",		PROPERTY_BONEMENDING = "BNM",\
		PROPERTY_FLUXING = "FLX", 			PROPERTY_NEUROCRYOGENIC = "NRC", 	PROPERTY_ANTIPARASITIC = "APS", 	PROPERTY_DEFIBRILLATING ="DFB",\
		PROPERTY_OMNIPOTENT = "OMN", 		PROPERTY_CURING = "CUR")

	var/mode = MODE_AMPLIFY
	var/target_property = ""
	var/target_info = ""
	var/reference_property = ""
	var/reference_info = ""
	var/list/property_costs = list()
	var/simulating = 0
	var/status_bar = "READY"
	var/ready = FALSE

/obj/structure/machinery/chem_simulator/Initialize()
	. = ..()
	dictionary["negative"] = get_negative_chem_properties(1)
	dictionary["neutral"] = get_neutral_chem_properties(1)
	dictionary["positive"] = get_positive_chem_properties(1)
	dictionary["all"] = dictionary["negative"] + dictionary["neutral"] + dictionary["positive"]

/obj/structure/machinery/chem_simulator/power_change()
	..()
	if(stat & (BROKEN|NOPOWER))
		icon_state = "modifier_off"
	nanomanager.update_uis(src) // update all UIs attached to src

/obj/structure/machinery/chem_simulator/attackby(obj/item/B, mob/living/user)
	if(!skillcheck(user, SKILL_RESEARCH, SKILL_RESEARCH_TRAINED))
		to_chat(user, SPAN_WARNING("You have no idea how to use this."))
		return
	if(istype(B, /obj/item/paper/chem_report))
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
		user.drop_inv_item_to_loc(B, src)
		to_chat(user, SPAN_NOTICE("You insert [B] into the [src]."))
		flick("[icon_state]_reading",src)
		update_costs()
		nanomanager.update_uis(src) // update all UIs attached to src
	else 
		to_chat(user, SPAN_WARNING("The [src] refuses the [B]."))

/obj/structure/machinery/chem_simulator/attack_hand(mob/user as mob)
	if(stat & (BROKEN|NOPOWER))
		return
	if(!skillcheck(user, SKILL_RESEARCH, SKILL_RESEARCH_TRAINED))
		to_chat(user, SPAN_WARNING("You have no idea how to use this."))
		return
	ui_interact(user)

/obj/structure/machinery/chem_simulator/ui_interact(mob/user, ui_key = "main", var/datum/nanoui/ui = null, var/force_open = 0)
	var/list/data = list(
		"rsc_credits" = chemical_research_data.rsc_credits,
		"target" = target,
		"reference" = reference,
		"mode" = mode,
		"target_property" = target_property,
		"property_costs" = property_costs,
		"reference_property" = reference_property,
		"simulating" = simulating,
		"status_bar" = status_bar,
		"ready" = ready,
		"simulating" = simulating,
		"dictionary" = dictionary,
		"property_codings" = property_codings
	)
	
	if(target && target.data && target.completed)
		data["target_property_list"] = target.data.properties
	if(reference && reference.data && reference.completed)
		data["reference_property_list"] = reference.data.properties
	
	if(target_property)
		if(dictionary["all"].Find(target_property))
			data["target_info"] = dictionary["all"][target_property]
	else
		target_info = ""
	
	if(reference_property)
		if(dictionary["all"].Find(reference_property))
			data["reference_info"] = dictionary["all"][reference_property]
	else
		reference_info = ""

	ui = nanomanager.try_update_ui(user, src, ui_key, ui, data, force_open)
	if(!ui)
		ui = new(user, src, ui_key, "chem_simulator.tmpl", "Synthesis Simulator", 800, 480)
		ui.set_initial_data(data)
		ui.open()

/obj/structure/machinery/chem_simulator/Topic(href, href_list)
	if(stat & (BROKEN|NOPOWER) || !ishuman(usr))
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
		target_property = ""
		stop_processing()
		simulating = 0
		flick("[icon_state]_printing",src)
	else if(href_list["ejectR"])
		if(reference)
			if(!user.put_in_active_hand(reference))
				reference.forceMove(loc)
			reference = null
		reference_property = ""
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
		target_property = href_list["set_target"]
		if(simulating)
			stop_processing()
			icon_state = "modifier"
			simulating = 0
	else if(href_list["set_reference"])
		reference_property = href_list["set_reference"]
		if(simulating)
			stop_processing()
			icon_state = "modifier"
			simulating = 0
	else if(href_list["stop_simulation"])
		stop_processing()
		icon_state = "modifier"
		simulating = 0
	ready = check_ready()
	playsound(loc, pick('sound/machines/computer_typing1.ogg','sound/machines/computer_typing2.ogg','sound/machines/computer_typing3.ogg'), 5, 1)
	nanomanager.update_uis(src)

/obj/structure/machinery/chem_simulator/process()
	if(stat & (BROKEN|NOPOWER))
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
	if(target && target.data && target.completed)
		for(var/P in target.data.properties)
			switch(mode)
				if(MODE_AMPLIFY)
					property_costs[P] = max(min(target.data.properties[P] - 1, 5), 1)
				if(MODE_SUPPRESS)
					property_costs[P] = 2
				if(MODE_RELATE)
					property_costs[P] = target.data.properties[P]

/obj/structure/machinery/chem_simulator/proc/check_ready()
	if(target)
		if(!target.completed)
			status_bar = "INCOMPLETE DATA DETECTED IN TARGET"
			return FALSE
		if(!target.data)
			status_bar = "DATA CORRUPTION DETECTED, RESCAN CHEMICAL"
			return FALSE
	if(property_costs[target_property] > chemical_research_data.rsc_credits)
		status_bar = "INSUFFICIENT FUNDS"
		return FALSE
	if(mode == MODE_RELATE)
		if(reference && !reference.completed)
			status_bar = "INCOMPLETE DATA DETECTED IN REFERENCE"
			return FALSE
		if(target && target.data.properties.len < 2)
			status_bar = "TARGET COMPLEXITY INSUFFICIENT FOR RELATION"
			return FALSE
		if(reference && target)
			if(target.data.properties.Find(reference_property))
				status_bar = "REFERENCE PROPERTY ALREADY IN TARGET"
				return FALSE
			if(target_property && reference_property && target.data.properties[target_property] != reference.data.properties[reference_property])
				status_bar = "REFERENCE AND TARGET PROPERTY MUST BE OF EQUAL LEVELS"
				return FALSE
	status_bar = "READY"
	return TRUE

/obj/structure/machinery/chem_simulator/proc/print(var/id, var/is_new)
	playsound(loc, 'sound/machines/fax.ogg', 15, 1)
	flick("[icon_state]_printing",src)
	sleep(10)
	var/obj/item/paper/chem_report/report = new /obj/item/paper/chem_report/(loc)
	var/datum/reagent/D = chemical_reagents_list[id]
	report.name = "Simulation result for [D.name]"
	report.info += "<center><img src = wylogo.png><HR><I><B>Official Company Document</B><BR>Simulated Synthesis Report</I><HR><H2>Result for [D.name]</H2></center>"
	report.generate(D)
	report.info += "<BR><HR><font size = \"1\"><I>This report was automatically printed by the Synthesis Simulator.<BR>The USS Almayer, [time2text(world.timeofday, "MM/DD")]/[game_year], [worldtime2text()]</I></font><BR>\n<span class=\"paper_field\"></span>"
	playsound(loc, 'sound/machines/twobeep.ogg', 15, 1)
	if(is_new)
		chemical_research_data.save_document(report, "Synthesis Simulations", report.name)

/obj/structure/machinery/chem_simulator/proc/encode_reagent(var/datum/reagent/C)
	var/datum/reagent/O = new C.original_type //So make the new name based on the Original
	var/suffix = " "
	for(var/P in C.properties)
		if(P in O.properties) //This property was amplified or suppressed
			if(C.properties[P] > O.properties[P] || C.properties[P] < O.properties[P])
				suffix += property_codings[P] + "[C.properties[P]]"
		else //This property was added through relation
			suffix += property_codings[P] + "[C.properties[P]]"
	if(C.overdose > O.overdose)
		suffix += "+"
	else if(C.overdose < O.overdose)
		suffix += "-"
	return O.name + suffix

/obj/structure/machinery/chem_simulator/proc/amplify()
	if(target && target_property)
		var/datum/reagent/generated/C = new /datum/reagent/generated
		C.make_alike(target.data)
		//Change the reagent
		C.properties[target_property] += 1
		if(dictionary["positive"].Find(target_property))
			if(C.overdose <= 5)
				C.overdose = max(C.overdose--,1)
			else
				C.overdose = max(5, C.overdose - 5)
			C.overdose_critical = max(10, C.overdose_critical - 5)
		else if(dictionary["negative"].Find(target_property))
			C.overdose += 5
			C.overdose_critical += 5
		end_simulation(C)

/obj/structure/machinery/chem_simulator/proc/suppress()
	if(target && target_property)
		var/datum/reagent/generated/C = new /datum/reagent/generated
		C.make_alike(target.data)
		//Change the reagent
		C.properties[target_property] = max(C.properties[target_property]-1,0)
		if(dictionary["positive"].Find(target_property))
			C.overdose += 5
			C.overdose_critical += 5
		else if(dictionary["negative"].Find(target_property))
			if(C.overdose <= 5)
				C.overdose = max(C.overdose - 1,1)
			else
				C.overdose = max(5, C.overdose - 5)
			C.overdose_critical = max(10, C.overdose_critical - 5)
		end_simulation(C)

/obj/structure/machinery/chem_simulator/proc/relate()
	if(target && reference && target_property && reference_property)
		var/datum/reagent/generated/C = new /datum/reagent/generated
		C.make_alike(target.data)
		//Override the target with the reference
		C.properties -= target_property
		C.insert_property(reference_property, reference.data.properties[reference_property])
		if(dictionary["positive"].Find(reference_property))
			if(C.overdose <= 5)
				C.overdose = max(C.overdose - 1,1)
			else
				C.overdose = max(5, C.overdose - 5)
			C.overdose_critical = max(10, C.overdose_critical - 5)
		else if(dictionary["negative"].Find(reference_property))
			C.overdose += 5
			C.overdose_critical += 5
		end_simulation(C)

/obj/structure/machinery/chem_simulator/proc/end_simulation(var/datum/reagent/C)
	if(!C.original_type)
		C.original_type = target.data.type
	C.name = encode_reagent(C)
	C.id = C.name
	if(C.id in simulations)
		//We've already simulated this before, so we don't need to continue
		C = chemical_reagents_list[C.id]
		print(C.id)
		return
	simulations += C.id //Remember we've simulated this
	chemical_research_data.update_credits(property_costs[target_property] * -1) //Pay
	//Determined rarity of new components
	C.gen_tier = max(min(C.chemclass, CHEM_CLASS_COMMON),C.gen_tier,1)
	//Change a single component of the reaction
	var/datum/chemical_reaction/generated/R = new /datum/chemical_reaction/generated
	R.make_alike(chemical_reactions_list[target.data.id])
	R.gen_tier = max(min(C.chemclass, CHEM_CLASS_COMMON),C.gen_tier,1)
	var/list/old_reaction = R.required_reagents.Copy()
	R.required_reagents -= pick(R.required_reagents)
	for(var/i = 0, i <= 5, i++)
		var/datum/reagent/new_component = chemical_reagents_list[R.add_component()]
		//Make sure we don't have an identical reaction and that the component is identified
		if(R.check_duplicate() || new_component.chemclass >= CHEM_CLASS_SPECIAL)
			R.required_reagents = old_reaction.Copy()
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