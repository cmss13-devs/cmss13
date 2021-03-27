#define MODE_AMPLIFY 			1
#define MODE_SUPPRESS 			2
#define MODE_RELATE				3
#define MODE_CREATE				4

#define SIMULATION_FAILURE		-1
#define SIMULATION_STAGE_OFF	0
#define SIMULATION_STAGE_FINAL	1
#define SIMULATION_STAGE_WAIT	2
#define SIMULATION_STAGE_3		3
#define SIMULATION_STAGE_4		4
#define SIMULATION_STAGE_5		5
#define SIMULATION_STAGE_BEGIN	6

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
	var/list/simulations

	var/mode = MODE_AMPLIFY
	var/datum/chem_property/target_property
	var/datum/chem_property/reference_property
	var/datum/reagent/generated/chem_cache
	var/list/property_costs
	var/list/recipe_targets
	var/recipe_target
	var/new_od_level = 10

	var/simulating = SIMULATION_STAGE_OFF
	var/status_bar = "READY"
	var/ready = FALSE

	var/template_filter = PROPERTY_TYPE_ALL
	var/complexity_editor = FALSE
	var/creation_template
	var/creation_complexity = list(CHEM_CLASS_COMMON, CHEM_CLASS_UNCOMMON, CHEM_CLASS_RARE)
	var/creation_name = ""
	var/creation_cost = 0
	var/creation_od_level = 10 //a cache for new_od_level when switching between modes

/obj/structure/machinery/chem_simulator/Initialize()
	. = ..()
	LAZYINITLIST(simulations)
	LAZYINITLIST(property_costs)
	LAZYINITLIST(recipe_targets)
	LAZYINITLIST(creation_template)

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
		"complexity_editor" = complexity_editor,
		"property_costs" = property_costs,
		"simulating" = simulating,
		"status_bar" = status_bar,
		"ready" = ready,
		"od_lvl" = new_od_level,
		"recipe_target" = recipe_target,
		"recipe_targets" = list(),
		"property_codings" = list()
	)

	if(simulating == SIMULATION_STAGE_FINAL)
		for(var/reagent_id in recipe_targets)
			var/datum/reagent/R = chemical_reagents_list[reagent_id]
			var/list/id_name[0]
			id_name["[R.id]"] = R.name
			data["recipe_targets"] += id_name

	if(mode == MODE_CREATE)
		data["creation_name"] = creation_name
		data["creation_cost"] = creation_cost
		data["complexity"] = complexity_to_string_list()

		//List of all available properties
		data["property_data_list"] = list()
		for(var/datum/chem_property/P in chemical_data.research_property_data)
			data["property_codings"][P.name] = P.code
			if(template_filter && !check_bitflag(P.category, template_filter))
				continue
			data["property_data_list"][P.name] = P.level
			data["property_data_list"] = sortAssoc(data["property_data_list"])
		//List of enabled properties
		data["target_property_list"] = list()
		for(var/datum/chem_property/P in creation_template)
			data["target_property_list"][P.name] = P.level
			if(template_filter && !check_bitflag(P.category, template_filter))
				continue
			//Override the editor level with the enabled property level
			data["property_data_list"][P.name] = P.level

		data["template_filter"] = list(
				"MED" = list(check_bitflag(template_filter, PROPERTY_TYPE_MEDICINE),	PROPERTY_TYPE_MEDICINE),
				"TOX" = list(check_bitflag(template_filter, PROPERTY_TYPE_TOXICANT),	PROPERTY_TYPE_TOXICANT),
				"STI" = list(check_bitflag(template_filter, PROPERTY_TYPE_STIMULANT),	PROPERTY_TYPE_STIMULANT),
				"REA" = list(check_bitflag(template_filter, PROPERTY_TYPE_REACTANT),	PROPERTY_TYPE_REACTANT),
				"IRR" = list(check_bitflag(template_filter, PROPERTY_TYPE_IRRITANT),	PROPERTY_TYPE_IRRITANT),
				"MET" = list(check_bitflag(template_filter, PROPERTY_TYPE_METABOLITE),	PROPERTY_TYPE_METABOLITE)
			)

	else if(target && target.data && target.completed)
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
		ui = new(user, src, ui_key, "chem_simulator.tmpl", "Synthesis Simulator", 800, 550)
		ui.set_initial_data(data)
		ui.open()

/obj/structure/machinery/chem_simulator/Topic(href, href_list)
	. = ..()
	if(.)
		return
	if(inoperable() || !ishuman(usr))
		return
	var/mob/living/carbon/human/user = usr
	if(user.stat || user.is_mob_restrained() || !in_range(src, user))
		return

	if(mode == MODE_CREATE && chemical_data.has_new_properties)
		update_costs()

	if(href_list["simulate"] && ready)
		simulating = SIMULATION_STAGE_BEGIN
		status_bar = "COMMENCING SIMULATION"
		icon_state = "modifier_running"
		recipe_targets = list() //reset
		start_processing()
		if(mode == MODE_CREATE)
			msg_admin_niche("[key_name(user)] has created the chemical: [creation_name]")
	else if(href_list["ejectT"])
		if(target)
			if(!user.put_in_active_hand(target))
				target.forceMove(loc)
			target = null
		target_property = null
		stop_processing()
		simulating = SIMULATION_STAGE_OFF
		flick("[icon_state]_printing",src)
	else if(href_list["ejectR"])
		if(reference)
			if(!user.put_in_active_hand(reference))
				reference.forceMove(loc)
			reference = null
		reference_property = null
		stop_processing()
		simulating = SIMULATION_STAGE_OFF
		flick("[icon_state]_printing",src)
	else if(href_list["set_mode"])
		if(mode == MODE_CREATE) //for when you set the mode away from MODE_CREATE
			target_property = null
			reference_property = null
			complexity_editor = FALSE
		switch(href_list["set_mode"])
			if("amp")
				mode = MODE_AMPLIFY
			if("sup")
				mode = MODE_SUPPRESS
			if("rel")
				mode = MODE_RELATE
			if("cre")
				mode = MODE_CREATE
				target_property = null
				reference_property = null
		calculate_new_od_level()
		if(mode == MODE_CREATE)
			calculate_creation_cost()
		update_costs()
	else if(href_list["set_target"])
		if(simulating)
			return
		if(mode == MODE_CREATE)
			var/target_name = href_list["set_target"]
			for(var/datum/chem_property/P in chemical_data.research_property_data)
				if(P.name == target_name)
					if(target_property && target_property.name == target_name)
						//Toggle the property
						if(LAZYISIN(creation_template, target_property))
							target_property.level = 0
							LAZYREMOVE(creation_template, target_property)
						else
							target_property.level = 1
							LAZYADD(creation_template, target_property)
						calculate_creation_cost()
					else
						target_property = P
					break
		else
			target_property = target.data.get_property(href_list["set_target"])
			calculate_new_od_level()
		if(simulating)
			stop_processing()
			icon_state = "modifier"
			simulating = SIMULATION_STAGE_OFF
	else if(href_list["set_reference"])
		reference_property = reference.data.get_property(href_list["set_reference"])
		if(simulating)
			stop_processing()
			icon_state = "modifier"
			simulating = SIMULATION_STAGE_OFF
		update_costs()
	else if(href_list["set_recipe_target"])
		recipe_target = href_list["set_recipe_target"]
	else if(href_list["stop_simulation"])
		stop_processing()
		icon_state = "modifier"
		simulating = SIMULATION_STAGE_OFF
	else if(href_list["finalize_simulation"] && recipe_target)
		finalize_simulation(chem_cache)
	//Template creation editor
	else if(href_list["set_name"])
		var/newname = input("Set name for template (2-20 characters)","[src]") as text
		newname = reject_bad_name(newname, TRUE, 20, FALSE)
		if(isnull(newname))
			to_chat(user, "Bad name.")
		else if(chemical_reagents_list[newname])
			to_chat(user, "Name already taken.")
		else
			creation_name = newname
	else if(href_list["set_level"] && target_property)
		var/level_to_set = tgui_input_list(usr, "Set target level for [target_property.name]:","[src]", list(1,2,3,4,5,6,7,8,9,10))
		if(!level_to_set)
			return

		target_property.level = level_to_set
		if(target_property.max_level && target_property.level > target_property.max_level)
			target_property.level = target_property.max_level
			to_chat(user, "Max level for [target_property.name] is [target_property.max_level].")
		calculate_creation_cost()
	else if(href_list["set_od"])
		var/od_to_set = tgui_input_list(usr, "Set new OD:", "[src]", list(5,10,15,20,25,30,35,40,45,50,55,60))
		if(!od_to_set)
			return
		new_od_level = od_to_set
		creation_od_level = od_to_set
		calculate_creation_cost()
	else if(href_list["set_filter"])
		if(href_list["set_filter"] == "ALL")
			template_filter = 0
		else
			var/flag_value = text2num(href_list["config_value"])
			if(template_filter & flag_value)
				template_filter &= ~flag_value
			else
				template_filter |= flag_value
	else if(href_list["toggle_complexity_editor"])
		complexity_editor = !complexity_editor
	else if(href_list["set_complexity"])
		var/slot = text2num(href_list["set_complexity"])
		var/new_rarity = tgui_input_list(usr, "Set chemical rarity for complexity slot [slot]:","[src]", list("BASIC (+7)","COMMON (+4)","UNCOMMON (1)","RARE (-5)"))
		if(!new_rarity)
			return

		switch(new_rarity)
			if("BASIC (+7)")
				creation_complexity[slot] = CHEM_CLASS_BASIC
			if("COMMON (+4)")
				creation_complexity[slot] = CHEM_CLASS_COMMON
			if("UNCOMMON (1)")
				creation_complexity[slot] = CHEM_CLASS_UNCOMMON
			if("RARE (-5)")
				creation_complexity[slot] = CHEM_CLASS_RARE
		calculate_creation_cost()
	ready = check_ready()
	playsound(loc, pick('sound/machines/computer_typing1.ogg','sound/machines/computer_typing2.ogg','sound/machines/computer_typing3.ogg'), 5, 1)
	nanomanager.update_uis(src)

/obj/structure/machinery/chem_simulator/process()
	if(inoperable())
		return
	if(simulating > SIMULATION_STAGE_OFF)
		simulating = max(simulating - 1, SIMULATION_STAGE_FINAL)
		switch(simulating)
			if(SIMULATION_STAGE_5)
				status_bar = pick("SIMULATING HUMANS","SIMULATING MONKEYS","SIMULATING BODILY FUNCTIONS","MEASURING PROPERTIES","INJECTING VIRTUAL HUMANS","TORTURING DIGITAL MONKEYS","EMULATING METABOLISM")
			if(SIMULATION_STAGE_4)
				status_bar = pick("SEARCHING FOR CHIMPANZEES","PLAYING CHESS WITH ARES","CONSULTING DOC","BLAMING GOD","SEARCHING FOR MY PURPOSE","SPYING ON JONES","DIVIDING BY NULL","EQUATING SPACE TIME")
			if(SIMULATION_STAGE_3)
				status_bar = pick("PREDICTING REACTION PATTERNS","CALCULATING OVERDOSE RATIOS","CALCULATING SYNTHESIS","CLOSING THE EVENTUALITY","COMPUTING REAGENT INTERPRETATIONS",)
			if(SIMULATION_STAGE_WAIT)
				var/datum/reagent/generated/C = new /datum/reagent/generated
				if(mode == MODE_CREATE)
					status_bar = "CREATION COMPLETE"
					simulating = SIMULATION_STAGE_OFF
					create(C)
				else
					switch(mode)
						if(MODE_AMPLIFY)
							amplify(C)
						if(MODE_SUPPRESS)
							suppress(C)
						if(MODE_RELATE)
							relate(C)
					if(!C.original_id)
						C.original_id = target.data.id
					C.id = encode_reagent(C)
					C.name = C.id
					if(C.id in simulations)
						//We've already simulated this before, so we don't need to continue
						C = chemical_reagents_list[C.id]
						print(C.id)
						status_bar = "SIMULATION COMPLETE"
						simulating = SIMULATION_STAGE_OFF
					else if(prepare_recipe_options())
						chem_cache = C
						status_bar = "ANALYSIS READY"
						icon_state = "modifier_ready"
						playsound(loc, 'sound/machines/twobeep.ogg', 15, 1)
					else
						finalize_simulation(C)
	else
		ready = check_ready()
		stop_processing()
	nanomanager.update_uis(src)

/obj/structure/machinery/chem_simulator/proc/update_costs()
	property_costs = list()
	var/only_positive = TRUE
	if(mode == MODE_CREATE)
		for(var/datum/chem_property/P in chemical_data.research_property_data)
			property_costs[P.name] = P.value
	else if(target && target.data && target.completed)
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
	chemical_data.has_new_properties = FALSE

//Here the cost for creating a chemical is calculated. If you're looking to rebalance create mode, this is where you do it
/obj/structure/machinery/chem_simulator/proc/calculate_creation_cost()
	creation_cost = 0
	var/slots_used = LAZYLEN(creation_template)
	creation_cost += slots_used * 3 - 6 //3 cost for each slot after the 2nd
	var/has_combustibles = FALSE
	for(var/datum/chem_property/P in creation_template)
		creation_cost += P.value * P.level
		if(P.level > 5) // a penalty is added at each level above 5 (+1 at 6, +2 at 7, +4 at 8, +5 at 9, +7 at 10)
			creation_cost += P.level - 6 + n_ceil((P.level - 5) / 2)
		if(P.category & PROPERTY_TYPE_COMBUSTIBLE)
			has_combustibles = TRUE
	if(has_combustibles) //negative values are not applied in templates that use combustibles unless those properties are also of the combustible category
		for(var/datum/chem_property/P in creation_template)
			if(P.value < 0 && !(P.category & PROPERTY_TYPE_COMBUSTIBLE))
				creation_cost += P.value * P.level * -1 //revert
	creation_cost += ((new_od_level - 10) / 5) * 3 //3 cost for every 5 units above 10
	for(var/rarity in creation_complexity)
		switch(rarity)
			if(CHEM_CLASS_BASIC)
				creation_cost += 7
			if(CHEM_CLASS_COMMON)
				creation_cost += 4
			if(CHEM_CLASS_UNCOMMON)
				creation_cost += 1
			if(CHEM_CLASS_RARE)
				creation_cost -= 5
	creation_cost = max(creation_cost, 5) //min cost of 5

/obj/structure/machinery/chem_simulator/proc/calculate_new_od_level()
	if(mode == MODE_CREATE || !target || !target.data)
		new_od_level = creation_od_level
		return
	new_od_level = max(target.data.overdose, 1)
	if(isNeutralProperty(target_property)) //unchanged
		return
	if((mode == MODE_AMPLIFY && isPositiveProperty(target_property)) || (mode == MODE_SUPPRESS && isNegativeProperty(target_property)) || (mode == MODE_RELATE && isPositiveProperty(target_property)))
		if(new_od_level <= 5)
			new_od_level = max(new_od_level - 1, 1)
		else
			new_od_level = max(5, new_od_level - 5)
	else
		new_od_level += 5

/obj/structure/machinery/chem_simulator/proc/prepare_recipe_options()
	var/datum/chemical_reaction/generated/O = chemical_reactions_list[target.data.id]
	if(!O) //If it doesn't have a recipe, go immediately to finalizing, which will then generate a new associated recipe
		return FALSE
	recipe_targets = list() //reset
	var/list/old_reaction = O.required_reagents.Copy()
	var/datum/chemical_reaction/generated/R = new /datum/chemical_reaction/generated()
	R.required_reagents = old_reaction.Copy()
	while(LAZYLEN(recipe_targets) < 3)
		var/list/target_elevated[0]
		for(var/i = 0 to 5) //5 attempts at modifying the recipe before elevating recipe length
			if(LAZYLEN(R.required_reagents) > 2)
				LAZYREMOVE(R.required_reagents, pick(R.required_reagents))
			var/new_component_id = R.add_component(tier = max(min(target.data.chemclass, CHEM_CLASS_COMMON), target.data.gen_tier, 1))
			var/datum/reagent/new_component = chemical_reagents_list[new_component_id]
			//Make sure we don't have an identical reaction and that the component is identified
			if(R.check_duplicate() || R.check_reaction_uses_all_default_medical() || new_component.chemclass >= CHEM_CLASS_SPECIAL)
				R.required_reagents = old_reaction.Copy()
				if(i >= 5)
					//Elevate the reaction to a higher order
					target_elevated["[new_component.id]"] = TRUE
					break
				continue
			target_elevated["[new_component.id]"] = FALSE
			break
		LAZYADD(recipe_targets, target_elevated)
		R.required_reagents = old_reaction.Copy() //it was just a simulation
	return TRUE

/obj/structure/machinery/chem_simulator/proc/check_ready()
	if(simulating == SIMULATION_FAILURE)
		status_bar = "CRITICAL FAILURE: NO POSSIBLE CHEMICAL COMBINATION"
		simulating = SIMULATION_STAGE_OFF
		return FALSE
	if(target && mode != MODE_CREATE)
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
		if(target && length(target.data.properties) < 2)
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
	if(mode == MODE_CREATE)
		if(!LAZYLEN(creation_template))
			status_bar = "TEMPLATE IS EMPTY"
			return FALSE
		if(LAZYLEN(creation_name) < 2)
			status_bar = "NAME NOT SET"
			return FALSE
		if(creation_cost > chemical_data.rsc_credits)
			status_bar = "INSUFFICIENT FUNDS"
			return FALSE
	else if(!target)
		status_bar = "NO TARGET INSERTED"
		return FALSE
	status_bar = "READY"
	return TRUE

/obj/structure/machinery/chem_simulator/proc/print(var/id, var/is_new)
	icon_state = "modifier"
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
		suffix += P.code+"[P.level]"
	return O.name + suffix

/obj/structure/machinery/chem_simulator/proc/complexity_to_string_list()
	var/list/L = list()
	for(var/rarity in creation_complexity)
		switch(rarity)
			if(CHEM_CLASS_BASIC)
				LAZYADD(L, "BASIC")
			if(CHEM_CLASS_COMMON)
				LAZYADD(L, "COMMON")
			if(CHEM_CLASS_UNCOMMON)
				LAZYADD(L, "UNCOMMON")
			if(CHEM_CLASS_RARE)
				LAZYADD(L, "RARE")
	return L

/obj/structure/machinery/chem_simulator/proc/finalize_simulation(var/datum/reagent/generated/C)
	simulating = SIMULATION_STAGE_OFF
	end_simulation(C)
	chem_cache = null

/obj/structure/machinery/chem_simulator/proc/amplify(var/datum/reagent/generated/C)
	if(!target || !target_property)
		return
	C.make_alike(target.data)
	//Change the reagent
	C.relevel_property(target_property.name, target_property.level + 1)

/obj/structure/machinery/chem_simulator/proc/suppress(var/datum/reagent/generated/C)
	if(!target || !target_property)
		return
	C.make_alike(target.data)
	//Change the reagent
	C.relevel_property(target_property.name, max(target_property.level - 1, 0))

/obj/structure/machinery/chem_simulator/proc/relate(var/datum/reagent/generated/C)
	if(!target || !reference || !target_property || !reference_property)
		return
	C.make_alike(target.data)
	//Override the target with the reference
	C.remove_property(target_property.name)
	C.insert_property(reference_property.name, reference_property.level)

/obj/structure/machinery/chem_simulator/proc/create(var/datum/reagent/generated/C)
	C.chemclass = CHEM_CLASS_RARE
	C.name = creation_name
	if(LAZYLEN(C.name) < 2) //Don't know how this would even happen, but here's a safety
		C.generate_name()
	C.id = C.name
	C.properties = list()
	C.custom_metabolism = REAGENTS_METABOLISM
	C.color = text("#[][][]",num2hex(rand(0,255)),num2hex(rand(0,255)),num2hex(rand(0,255)))
	C.burncolor = color
	for(var/datum/chem_property/P in creation_template)
		C.insert_property(P.name, P.level)
	creation_name = "" //reset it
	end_simulation(C)

/obj/structure/machinery/chem_simulator/proc/end_simulation(var/datum/reagent/C)
	//Set tier
	C.gen_tier = max(min(C.chemclass, CHEM_CLASS_COMMON),C.gen_tier,1)
	if(C.chemclass == CHEM_CLASS_SPECIAL)
		C.gen_tier = 4

	//Change a single component of the reaction or generate a new one if there is no recipe
	var/datum/chemical_reaction/generated/R = new /datum/chemical_reaction/generated
	var/datum/chemical_reaction/generated/assoc_R

	R.gen_tier = C.gen_tier

	if(mode != MODE_CREATE)
		assoc_R = chemical_reactions_list[target.data.id]
	if(!assoc_R) //no associated recipe found
		if(mode == MODE_CREATE)
			assoc_R = C.generate_assoc_recipe(creation_complexity)
		else
			assoc_R = C.generate_assoc_recipe()
	if(!assoc_R) //no possible associated recipe could be generated
		icon_state = "modifier"
		playsound(loc, 'sound/machines/buzz-two.ogg', 15, 1)
		simulating = SIMULATION_FAILURE
		qdel(C)
		qdel(R)
		return

	R.make_alike(assoc_R)

	if(mode != MODE_CREATE)
		if(R.required_reagents.len > 2 && !recipe_targets[recipe_target]) //we only replace if the recipe isn't small and the target is not set TRUE to being elevated
			LAZYREMOVE(R.required_reagents, pick(R.required_reagents))
		R.add_component(recipe_target)

	//Handle new overdose
	C.overdose = new_od_level
	if(C.overdose < 1) //to prevent chems that start at 0 OD to become un-OD-able
		C.overdose = 1
	C.overdose_critical = max(min(new_od_level * 2, new_od_level + 30), 10)

	//Pay
	if(mode == MODE_CREATE)
		chemical_data.update_credits(creation_cost * -1)
	else
		chemical_data.update_credits(property_costs[target_property.name] * -1)
		//Refund 1 credit if a rare or rarer target was added
		var/datum/reagent/component = chemical_reagents_list[recipe_target]
		if(component && component.chemclass >= CHEM_CLASS_RARE)
			chemical_data.update_credits(1)


	//Save the reagent
	C.generate_description()
	C.chemclass = CHEM_CLASS_RARE //So that we can always scan this in the future, don't generate defcon, and don't get a loop of making credits
	chemical_reagents_list[C.id] = C
	LAZYADD(simulations, C.id) //Remember we've simulated this

	//Save the reaction
	R.id = C.id
	R.result = C.id
	chemical_reactions_list[R.id] = R
	R.add_to_filtered_list()
	status_bar = "SIMULATION COMPLETE"
	print(C.id, TRUE)

#undef SIMULATION_FAILURE
#undef SIMULATION_STAGE_OFF
#undef SIMULATION_STAGE_FINAL
#undef SIMULATION_STAGE_WAIT
#undef SIMULATION_STAGE_3
#undef SIMULATION_STAGE_4
#undef SIMULATION_STAGE_5
#undef SIMULATION_STAGE_BEGIN

#undef MODE_AMPLIFY
#undef MODE_SUPPRESS
#undef MODE_RELATE
#undef MODE_CREATE
