/proc/spawn_reagent(target, volume)
	message_admins("[usr] spawned in a container of [target] with a volume of [volume]u")

	if(volume > 300)
		var/obj/structure/reagent_dispensers/fueltank/custom/C = new(usr.loc, volume, target)
		C.reagents.add_reagent(target, volume)

		if(alert(usr, "Do you want to set the explosive capabilities on your fueltank? (This will disallow transferring to and from the tank)", "", "Yes", "No") == "Yes")
			var/explosive_power = tgui_input_number(usr,"Power")
			var/falloff = tgui_input_number(usr, "Base Falloff")

			if(explosive_power && falloff)

				C.reagents.max_ex_power = explosive_power
				C.reagents.base_ex_falloff = max(1, falloff)

				C.reagents.locked = TRUE

				message_admins("[usr] modified [C] ([target]) to have [C.reagents.max_ex_power] explosive power and [C.reagents.base_ex_falloff] falloff")

	else if(volume > 120)
		var/obj/item/reagent_container/glass/beaker/bluespace/C = new /obj/item/reagent_container/glass/beaker/bluespace(usr.loc)
		C.reagents.add_reagent(target,volume)
	else if (volume > 60)
		var/obj/item/reagent_container/glass/beaker/large/C = new /obj/item/reagent_container/glass/beaker/large(usr.loc)
		C.reagents.add_reagent(target,volume)
	else if (volume > 30)
		var/obj/item/reagent_container/glass/beaker/C = new /obj/item/reagent_container/glass/beaker(usr.loc)
		C.reagents.add_reagent(target,volume)
	else
		var/obj/item/reagent_container/glass/beaker/vial/C = new /obj/item/reagent_container/glass/beaker/vial(usr.loc)
		C.reagents.add_reagent(target,volume)
	return


/datum/admins/proc/topic_chems(href)
	switch(href)
		if("view_reagent")
			var/response = alert(usr,"Enter ID or select ID from list?",null, "Enter ID","Select from list")
			var/target
			if(response == "Select from list")
				var/list/pool = GLOB.chemical_reagents_list
				pool = sortAssoc(pool)
				target = tgui_input_list(usr,"Select the ID of the chemical reagent you wish to view:", "View reagent", pool)
			else if(response == "Enter ID")
				target = input(usr,"Enter the ID of the chemical reagent you wish to view:")
			if(!target)
				return
			var/datum/reagent/R = GLOB.chemical_reagents_list[target]
			if(R)
				usr.client.debug_variables(R)
			else
				to_chat(usr,SPAN_WARNING("No reagent with this ID could been found."))
			return
		if("view_reaction")
			var/target = input(usr,"Enter the ID of the chemical reaction you wish to view:")
			if(!target)
				return
			var/datum/chemical_reaction/R = GLOB.chemical_reactions_list[target]
			if(R)
				usr.client.debug_variables(R)
				log_admin("[key_name(usr)] is viewing the chemical reaction for [R].")
			else
				to_chat(usr,SPAN_WARNING("No reaction with this ID could been found."))
			return
		if("sync_filter")
			var/target = input(usr,"Enter the ID of the chemical reaction you wish to syncronize. This is only necessary if you edited a reaction through the debugger (VV).")
			if(!target)
				return
			var/datum/chemical_reaction/R = GLOB.chemical_reactions_list[target]
			if(R)
				R.add_to_filtered_list(TRUE)
				log_debug("[key_name(usr)] resyncronized [R.id]")
				to_chat(usr,SPAN_WARNING("Resyncronized [R.id]."))
			else
				to_chat(usr,SPAN_WARNING("No reaction with this ID could been found."))
			return
		if("spawn_reagent")
			var/target = input(usr,"Enter the ID of the chemical reagent you wish to make:")
			if(!GLOB.chemical_reagents_list[target])
				to_chat(usr,SPAN_WARNING("No reagent with this ID could been found."))
				return
			var/volume = tgui_input_number(usr,"How much? An appropriate container will be selected.")
			if(volume <= 0)
				return

			spawn_reagent(target, volume)
			return
		if("make_report")
			var/target = input(usr, "Enter the ID of the chemical reagent you wish to make a report of:")
			if(!GLOB.chemical_reagents_list[target])
				to_chat(usr, SPAN_WARNING("No reagent with this ID could be found."))
				return

			var/datum/reagent/R = GLOB.chemical_reagents_list[target]
			R.print_report(loc = usr.loc, admin_spawned = TRUE)
		//For quickly generating a new chemical
		if("create_random_reagent")
			var/target = input(usr,"Enter the ID of the chemical reagent you wish to make:")
			if(!target)
				return
			if(GLOB.chemical_reagents_list[target])
				to_chat(usr,SPAN_WARNING("This ID is already in use."))
				return
			var/tier = tgui_input_number(usr,"Enter the generation tier you wish. This will affect the number of properties (tier + 1), rarity of components and potential for good properties. Ought to be 1-4, max 10.", "Generation tier", 1, 10)
			if(tier <= 0)
				return
			if(tier > 10)
				tier = 10
			var/datum/reagent/generated/R = new /datum/reagent/generated
			R.id = target
			R.gen_tier = tier
			R.chemclass = CHEM_CLASS_ULTRA
			R.save_chemclass()
			R.properties = list()
			R.generate_name()
			R.generate_stats()
			//Save our reagent
			GLOB.chemical_reagents_list[target] = R
			message_admins("[key_name_admin(usr)] has generated the reagent: [target].")
			var/response = alert(usr,"Do you want to do anything else?",null,"Generate associated reaction","View my reagent","Finish")
			while(response != "Finish")
				switch(response)
					if("Generate associated reaction")
						if(GLOB.chemical_reactions_list[target])
							to_chat(usr,SPAN_WARNING("This ID is already in use."))
							return
						R.generate_assoc_recipe()
						if(!GLOB.chemical_reactions_list[target])
							to_chat(usr,SPAN_WARNING("Something went wrong when saving the reaction. The associated reagent has been deleted."))
							GLOB.chemical_reagents_list[target] -= R
							return
						response = alert(usr,"Do you want to do anything else?",null,"View my reaction","View my reagent","Finish")
					if("View my reagent")
						if(GLOB.chemical_reagents_list[target])
							R = GLOB.chemical_reagents_list[target]
							usr.client.debug_variables(R)
							log_admin("[key_name(usr)] is viewing the chemical reaction for [R].")
						else
							to_chat(usr,SPAN_WARNING("No reagent with this ID could been found. Wait what? But I just... Contact a debugger."))
							GLOB.chemical_reagents_list.Remove(target)
							GLOB.chemical_reactions_list.Remove("[target]")
							GLOB.chemical_reactions_filtered_list.Remove("[target]")
						return
					if("View my reaction")
						if(GLOB.chemical_reactions_list[target])
							var/datum/chemical_reaction/generated/G = GLOB.chemical_reactions_list[target]
							usr.client.debug_variables(G)
						else
							to_chat(usr,SPAN_WARNING("No reaction with this ID could been found. Wait what? But I just... Contact a debugger."))
							GLOB.chemical_reagents_list.Remove(target)
							GLOB.chemical_reactions_list.Remove("[target]")
							GLOB.chemical_reactions_filtered_list.Remove("[target]")
						return
					else
						break
			//See what we want to do last
			if(alert(usr,"Spawn container with reagent?","Custom reagent [target]","Yes","No") != "Yes")
				return
			var/volume = tgui_input_number(usr,"How much? An appropriate container will be selected.")
			if(volume <= 0)
				return
		//For creating a custom reagent
		if("create_custom_reagent")
			var/target = input(usr,"Enter the ID of the chemical reagent you wish to make:")
			if(!target)
				return
			if(GLOB.chemical_reagents_list[target])
				to_chat(usr,SPAN_WARNING("This ID is already in use."))
				return
			var/datum/reagent/generated/R = new /datum/reagent/generated
			R.id = target
			R.chemclass = CHEM_CLASS_NONE //So we don't count it towards defcon
			R.properties = list()
			R.overdose = 15
			R.overdose_critical = 30
			var/response = alert(usr,"Use capitalized ID as name?","Custom reagent [target]","[capitalize(target)]","Random name")
			if(!response)
				return
			if(response == "Random name")
				R.generate_name()
			else
				R.name = capitalize(response)
			response = alert(usr,"What do you want customized?","Custom reagent [target]","Add property","Randomize non property vars","Finish")
			while(response != "Finish")
				switch(response)
					if("Add property")
						response = alert(usr,"A specific property or a specific number of random properties?","Custom reagent [target]","Specific property","Specific number","No more properties")
					if("Specific property")
						response = alert(usr,"Select Input Type","Custom reagent [target]","Manual Input","Select","No more properties")
					if("Manual Input")
						var/input = input(usr,"Enter the name of the chemical property you wish to add:")
						var/datum/chem_property/P = GLOB.chemical_properties_list[input]
						if(!P)
							to_chat(usr,SPAN_WARNING("Property not found, did you spell it right?"))
							response = "Specific property"
						else
							var/level = tgui_input_number(usr,"Choose the level (this is a strength modifier, ought to be between 1-8)", "strengthmod", 1)
							R.insert_property(P.name,level)
							response = alert(usr,"Done. Add more?","Custom reagent [target]","Specific property","Specific number","No more properties")
					if("Select")
						var/list/pool = GLOB.chemical_properties_list
						pool = sortAssoc(pool)
						var/P = tgui_input_list(usr,"Which property do you want?", "Property selection", pool)
						var/level = tgui_input_number(usr,"Choose the level (this is a strength modifier, ought to be between 1-8)", "strengthmod", 1)
						R.insert_property(P,level)
						response = alert(usr,"Done. Add more?","Custom reagent [target]","Specific property","Specific number","No more properties")
					if("Specific number")
						var/number = tgui_input_number(usr,"How many properties?")
						R.gen_tier = tgui_input_number(usr,"Enter the generation tier. This will affect how potent the properties can be. Must be between 1-5.", "generation tier", 1, 5, 1)
						if(number > 10)
							number = 10
						for(var/i=1,i<=number,i++)
							R.add_property()
						response = alert(usr,"Done. What do you want customized next?","Custom reagent [target]","Add property","Randomize non property vars","Finish")
					if("No more properties")
						response = alert(usr,"What do you want customized?","Custom reagent [target]","Add property","Randomize non property vars","Finish")
					if("Randomize non property vars")
						R.generate_stats(1)
						response = alert(usr,"Done. What do you want customized next?","Custom reagent [target]","Add property","Randomize non property vars","Finish")
					else
						break
			R.generate_description()
			//Save our reagent
			GLOB.chemical_reagents_list[target] = R
			message_admins("[key_name_admin(usr)] has created a custom reagent: [target].")
			//See what we want to do last
			response = alert(usr,"Spawn container with reagent?","Custom reagent [target]","Yes","No, show me the reagent","No, I'm all done")
			switch(response)
				if("Yes")
					var/volume = tgui_input_number(usr,"How much? An appropriate container will be selected.")
					if(volume <= 0)
						return

					spawn_reagent(target, volume)
				if("No, show me the reagent")
					usr.client.debug_variables(GLOB.chemical_reagents_list[target])
			return
		//For creating a custom reaction
		if("create_custom_reaction")
			var/target = input(usr,"Enter the ID of the chemical reaction you wish to make:")
			if(!target)
				return
			if(GLOB.chemical_reactions_list[target])
				to_chat(usr,SPAN_WARNING("This ID is already in use."))
				return
			var/datum/chemical_reaction/generated/R = new /datum/chemical_reaction/generated
			R.id = target
			R.result = input(usr,"Enter the reagent ID the reaction should result in:")
			R.name = capitalize(target)
			var/modifier = 1
			var/component = "water"
			var/catalyst = FALSE
			var/response = alert(usr,"What do you want customized?","Custom reaction [target]","Add component","Add catalyst","Finish")
			while(response != "Finish")
				switch(response)
					if("Add component")
						catalyst = FALSE
						response = "Select type"
					if("Add catalyst")
						catalyst = TRUE
						response = "Select type"
					if("Select type")
						response = alert(usr,"Enter id manually or select from list?","Custom reaction [target]","Select from list","Manual input","Back")
					if("Select from list")
						var/list/pool = GLOB.chemical_reagents_list
						pool = sortAssoc(pool)
						component = tgui_input_list(usr,"Select:", "Create custom reaction", pool)
						if(!component)
							response = "Select type"
							continue
						response = "Add"
					if("Manual input")
						component = input(usr,"Enter the ID of the reagent:")
						if(!component)
							response = "Select type"
							continue
						if(!GLOB.chemical_reagents_list[component])
							to_chat(usr,SPAN_WARNING("ID not found. Try again."))
							continue
						response = "Add"
					if("Add")
						modifier = tgui_input_number(usr, "How much is required per reaction?")
						R.add_component(component,modifier,catalyst)
						response = "Back"
					if("Back")
						response = alert(usr,"What do you want customized?","Custom reaction [target]","Add component","Add catalyst","Finish")
					else
						return
			if(length(R.required_reagents) < 3)
				to_chat(usr,SPAN_WARNING("You need to add at least 3 components excluding catalysts. The reaction has not been saved."))
				return
			//Save our reaction
			GLOB.chemical_reactions_list[target] = R
			R.add_to_filtered_list()
			if(!GLOB.chemical_reactions_list[target])
				to_chat(usr,SPAN_WARNING("Something went wrong when saving the reaction."))
				return
			usr.client.debug_variables(GLOB.chemical_reactions_list[target])
			message_admins("[key_name_admin(usr)] has created a custom chemical reaction: [target].")
			return
